-- Household invite generation and join, as SECURITY DEFINER RPCs.
--
-- The base schema (20260802181114) deliberately withholds the client write
-- paths these need: household_members has no INSERT policy and household_invites
-- has no UPDATE policy, so a user cannot self-join an arbitrary household or
-- burn a token by editing rows directly. Joining therefore runs entirely
-- through the two definer functions below (ADR-0011), which run as the function
-- owner and so bypass those tables' RLS -- exactly like handle_new_household.
-- search_path is pinned (Supabase hardening guidance).
--
-- Custom SQLSTATEs are surfaced to the client as PostgrestException.code so the
-- Dart layer can map each failure to a localized message:
--   ZKH01  caller already belongs to a household (one household per user)
--   ZKH02  invite code not found
--   ZKH03  invite already used
--   ZKH04  invite expired

-- Create a short-lived invite for a household the caller belongs to and return
-- its code. The code is a 6-character string from an unambiguous alphabet (no
-- 0/O/1/I/L) so it reads cleanly aloud and inside a QR. Regenerated on the rare
-- collision with the unique token column.
create or replace function public.create_household_invite(hid uuid)
returns text
language plpgsql
security definer
set search_path = public
as $$
declare
  alphabet constant text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  new_code text;
begin
  if not public.is_household_member(hid) then
    raise exception 'not a member of this household'
      using errcode = '42501'; -- insufficient_privilege
  end if;

  loop
    new_code := '';
    for i in 1..6 loop
      new_code := new_code
        || substr(alphabet, floor(random() * length(alphabet))::int + 1, 1);
    end loop;
    exit when not exists (
      select 1 from public.household_invites where token = new_code
    );
  end loop;

  insert into public.household_invites (household_id, token, created_by, expires_at)
  values (hid, new_code, auth.uid(), now() + interval '15 minutes');

  return new_code;
end;
$$;

-- Consume an invite code and enrol the caller as a member of its household.
-- Enforces the one-household-per-user rule, single use and expiry, then inserts
-- the membership and marks the invite used in one transaction. Returns the
-- joined household's id.
create or replace function public.accept_household_invite(invite_code text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  inv public.household_invites;
begin
  if exists (
    select 1 from public.household_members where user_id = auth.uid()
  ) then
    raise exception 'user already belongs to a household'
      using errcode = 'ZKH01';
  end if;

  -- Lock the invite row so two concurrent joins cannot both consume it.
  select * into inv
  from public.household_invites
  where token = invite_code
  for update;

  if not found then
    raise exception 'invite code not found' using errcode = 'ZKH02';
  end if;
  if inv.used_at is not null then
    raise exception 'invite already used' using errcode = 'ZKH03';
  end if;
  if inv.expires_at < now() then
    raise exception 'invite expired' using errcode = 'ZKH04';
  end if;

  insert into public.household_members (household_id, user_id, role)
  values (inv.household_id, auth.uid(), 'member');

  update public.household_invites set used_at = now() where id = inv.id;

  return inv.household_id;
end;
$$;

grant execute on function public.create_household_invite(uuid) to authenticated;
grant execute on function public.accept_household_invite(text) to authenticated;
