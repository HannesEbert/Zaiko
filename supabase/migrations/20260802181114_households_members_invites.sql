-- Households, their members, and short-lived join invites.
--
-- Households sit at the top of the ownership chain: inventory items, shopping
-- items and (later) recipes belong to a household, never directly to a user.
-- A user belongs to at most one household (unique user_id in
-- household_members) -- see ADR-0011. Row-level security keys every table off
-- household membership.

-- Generic trigger function to keep an `updated_at` column current on write.
-- Reused by every table that carries one.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at := now();
  return new;
end;
$$;

-- Tables ---------------------------------------------------------------------

create table public.households (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  -- Kept for audit; nullable + set null so deleting the creator does not
  -- delete the household out from under the remaining members.
  created_by uuid references auth.users (id) on delete set null,
  created_at timestamptz not null default now()
);

create table public.household_members (
  household_id uuid not null references public.households (id) on delete cascade,
  -- Unique: one household per user (ADR-0011).
  user_id uuid not null unique references auth.users (id) on delete cascade,
  role text not null default 'member' check (role in ('owner', 'member')),
  joined_at timestamptz not null default now(),
  primary key (household_id, user_id)
);

-- Short-lived invite tokens. A QR code encodes the token link; joining a
-- household consumes the token. Acceptance (setting used_at + inserting the
-- membership) runs through a SECURITY DEFINER RPC added with the households
-- feature, not through direct table writes.
create table public.household_invites (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households (id) on delete cascade,
  token text not null unique,
  created_by uuid not null references auth.users (id) on delete cascade,
  expires_at timestamptz not null,
  used_at timestamptz,
  created_at timestamptz not null default now()
);

-- Membership helpers ---------------------------------------------------------
--
-- Used by every RLS policy. SECURITY DEFINER so they read household_members
-- without invoking that table's own RLS, which would recurse. search_path is
-- pinned (Supabase hardening guidance).

create or replace function public.is_household_member(hid uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.household_members m
    where m.household_id = hid
      and m.user_id = auth.uid()
  );
$$;

create or replace function public.is_household_owner(hid uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1
    from public.household_members m
    where m.household_id = hid
      and m.user_id = auth.uid()
      and m.role = 'owner'
  );
$$;

-- On creation, enrol the creator as the household's owner. SECURITY DEFINER so
-- the insert bypasses household_members RLS (there is deliberately no member
-- INSERT policy for regular users -- membership changes go through this
-- trigger and the join RPC).
create or replace function public.handle_new_household()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.household_members (household_id, user_id, role)
  values (new.id, new.created_by, 'owner');
  return new;
end;
$$;

create trigger on_household_created
  after insert on public.households
  for each row
  execute function public.handle_new_household();

-- Keep a household from being orphaned when a member is removed (whether they
-- leave, are removed by an owner, or their account is deleted). SECURITY
-- DEFINER so it can read and adjust membership regardless of RLS.
--
--   * household already gone (cascade from a household delete) -> nothing to do
--   * no members left            -> delete the now-empty household (its cascade
--                                   cleans up the household's data, which would
--                                   otherwise be unreachable under RLS)
--   * members left but no owner  -> promote the longest-standing member, so a
--                                   household always has at least one owner
--
-- Multiple owners are allowed by design (co-ownership); this only guarantees a
-- lower bound of one. Targeted ownership transfer/promotion is a SECURITY
-- DEFINER RPC added with the households feature (there is no member UPDATE
-- policy -- membership is only changed through definer paths).
create or replace function public.handle_member_removed()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if not exists (
    select 1 from public.households where id = old.household_id
  ) then
    return old;
  end if;

  if not exists (
    select 1 from public.household_members where household_id = old.household_id
  ) then
    delete from public.households where id = old.household_id;
    return old;
  end if;

  if not exists (
    select 1
    from public.household_members
    where household_id = old.household_id and role = 'owner'
  ) then
    update public.household_members
    set role = 'owner'
    where household_id = old.household_id
      and user_id = (
        select user_id
        from public.household_members
        where household_id = old.household_id
        order by joined_at asc, user_id asc
        limit 1
      );
  end if;

  return old;
end;
$$;

create trigger on_member_removed
  after delete on public.household_members
  for each row
  execute function public.handle_member_removed();

-- Row-level security ---------------------------------------------------------

alter table public.households enable row level security;
alter table public.household_members enable row level security;
alter table public.household_invites enable row level security;

-- households: members read; any authenticated user creates one (becoming owner
-- via the trigger); only owners rename or delete it.
create policy households_select on public.households
  for select to authenticated
  using (public.is_household_member(id));

create policy households_insert on public.households
  for insert to authenticated
  with check (created_by = auth.uid());

create policy households_update on public.households
  for update to authenticated
  using (public.is_household_owner(id))
  with check (public.is_household_owner(id));

create policy households_delete on public.households
  for delete to authenticated
  using (public.is_household_owner(id));

-- household_members: members see their household's roster; a user may leave and
-- an owner may remove members. No INSERT/UPDATE policy on purpose -- membership
-- is created by the household trigger and (later) the join RPC, and roles are
-- changed only through a definer RPC. The on_member_removed trigger keeps a
-- household from ending up ownerless or orphaned when a member is removed.
create policy household_members_select on public.household_members
  for select to authenticated
  using (public.is_household_member(household_id));

create policy household_members_delete on public.household_members
  for delete to authenticated
  using (user_id = auth.uid() or public.is_household_owner(household_id));

-- household_invites: members read and create invites for their household; the
-- creator or an owner can revoke them. used_at is set by the join RPC only.
create policy household_invites_select on public.household_invites
  for select to authenticated
  using (public.is_household_member(household_id));

create policy household_invites_insert on public.household_invites
  for insert to authenticated
  with check (
    public.is_household_member(household_id) and created_by = auth.uid()
  );

create policy household_invites_delete on public.household_invites
  for delete to authenticated
  using (created_by = auth.uid() or public.is_household_owner(household_id));

-- Data API grants ------------------------------------------------------------
--
-- New tables are not auto-exposed to the Data API roles, so the authenticated
-- role needs table privileges before any RLS policy can grant row access. The
-- RLS policies above remain the actual gate; anon is granted nothing. Grants are
-- scoped to the operations that actually have a policy: household_members has no
-- INSERT/UPDATE path for regular users, and invites' used_at is set by the join
-- RPC, so those privileges are withheld rather than left to default-deny.
grant select, insert, update, delete on public.households to authenticated;
grant select, delete on public.household_members to authenticated;
grant select, insert, delete on public.household_invites to authenticated;

-- The RLS policies call these helpers, so the authenticated role must be able to
-- execute them. PUBLIC has EXECUTE by default on standard Supabase; granting it
-- explicitly keeps the policies working under a hardened baseline that revokes
-- EXECUTE from PUBLIC.
grant execute on function public.is_household_member(uuid) to authenticated;
grant execute on function public.is_household_owner(uuid) to authenticated;
