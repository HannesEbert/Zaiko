-- User profiles: display name and avatar, one row per auth user.
--
-- Identity beyond auth.users (which only holds email/password): a member's
-- display name and chosen avatar so the UI can show *who* did what across
-- households. The row is created automatically on signup (handle_new_user) and
-- backfilled for users that predate this migration. Email stays in auth.users;
-- it is never copied here.
--
-- A user reads and writes their own profile, and reads the profiles of everyone
-- in their household (so names/avatars resolve everywhere a member appears). One
-- household per user (ADR-0011) keeps the shared-household check a simple join.

-- Table ----------------------------------------------------------------------

create table public.profiles (
  -- Shares the auth user's id; deleting the account removes the profile.
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text not null,
  -- Chosen preset avatar key (resolved app-side); null renders the default
  -- colour+initial avatar. Free text on purpose, so adding presets needs no
  -- migration.
  avatar_preset text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Keep updated_at current on every profile update.
create trigger set_profiles_updated_at
  before update on public.profiles
  for each row execute function public.set_updated_at();

-- Automatic profile creation --------------------------------------------------
--
-- Create the profile row when an auth user is created. SECURITY DEFINER so the
-- insert bypasses profiles RLS (there is a self-only INSERT policy for the
-- repository fallback, but signup runs before the user has a session). The
-- display name seeds from a `display_name` user-metadata field when the signup
-- provided one, else the email's local part.
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.profiles (id, display_name)
  values (
    new.id,
    coalesce(
      nullif(new.raw_user_meta_data ->> 'display_name', ''),
      split_part(new.email, '@', 1)
    )
  )
  on conflict (id) do nothing;
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row
  execute function public.handle_new_user();

-- Backfill profiles for users created before this migration, so existing
-- accounts get a row without needing to sign up again.
insert into public.profiles (id, display_name)
select
  u.id,
  coalesce(
    nullif(u.raw_user_meta_data ->> 'display_name', ''),
    split_part(u.email, '@', 1)
  )
from auth.users u
on conflict (id) do nothing;

-- Row-level security ----------------------------------------------------------

alter table public.profiles enable row level security;

-- Read your own profile, plus the profiles of members of your household. The
-- household_members subquery runs under that table's own RLS (members can see
-- their household's full roster), so it only ever exposes co-members' profiles.
create policy profiles_select on public.profiles
  for select to authenticated
  using (
    id = (select auth.uid())
    or exists (
      select 1
      from public.household_members me
      join public.household_members them
        on them.household_id = me.household_id
      where me.user_id = (select auth.uid())
        and them.user_id = profiles.id
    )
  );

-- Self-only insert: a fallback for the repository if the signup trigger did not
-- create the row. Normal creation goes through handle_new_user above.
create policy profiles_insert on public.profiles
  for insert to authenticated
  with check (id = (select auth.uid()));

-- Self-only update: name and avatar are the user's own to change.
create policy profiles_update on public.profiles
  for update to authenticated
  using (id = (select auth.uid()))
  with check (id = (select auth.uid()));

-- Data API grants (see the households migration for the rationale). The RLS
-- policies above remain the actual gate; anon is granted nothing. No delete
-- privilege: profiles are removed only by the cascade from auth.users.
grant select, insert, update on public.profiles to authenticated;
