-- Storage locations and categories.
--
-- Storage locations are per-household and seeded with a default set when a
-- household is created. Categories are hybrid: a shared set of app-wide
-- defaults (household_id null, is_default true) plus per-household custom ones.
--
-- `color` stores a stable palette key (not a hex value); the app maps it to the
-- AppColors.category* constants. `icon` stores a Material icon identifier.

-- Tables ---------------------------------------------------------------------

create table public.storage_locations (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households (id) on delete cascade,
  name text not null,
  icon text,
  color text check (color in ('blue', 'cyan', 'orange', 'purple')),
  sort_order integer not null default 0
);

create table public.categories (
  id uuid primary key default gen_random_uuid(),
  household_id uuid references public.households (id) on delete cascade,
  name text not null,
  icon text,
  color text check (color in ('blue', 'cyan', 'orange', 'purple')),
  is_default boolean not null default false,
  -- A default category is global (no household); a custom one belongs to a
  -- household. Keeps the two kinds from contradicting each other.
  constraint categories_default_is_global
    check (
      (is_default and household_id is null)
      or (not is_default and household_id is not null)
    )
);

-- App-wide default categories, seeded once (global, is_default). German
-- display names -- the app is German-first; users add their own for anything
-- else.
insert into public.categories (name, icon, color, is_default) values
  ('Obst & Gemüse',    'eco',            'cyan',   true),
  ('Milchprodukte',    'egg',            'blue',   true),
  ('Fleisch & Fisch',  'set_meal',       'orange', true),
  ('Tiefkühl',         'ac_unit',        'cyan',   true),
  ('Getränke',         'local_drink',    'purple', true),
  ('Vorrat',           'inventory_2',    'orange', true),
  ('Backwaren',        'bakery_dining',  'orange', true),
  ('Sonstiges',        'category',       'blue',   true);

-- Seed a default set of storage locations whenever a household is created.
-- Extends the trigger function from the previous migration (append-only:
-- redefined here, not edited there).
create or replace function public.handle_new_household()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.household_members (household_id, user_id, role)
  values (new.id, new.created_by, 'owner');

  insert into public.storage_locations (household_id, name, icon, color, sort_order)
  values
    (new.id, 'Kühlschrank',    'kitchen',     'blue',   0),
    (new.id, 'Gefrierschrank', 'ac_unit',     'cyan',   1),
    (new.id, 'Vorratsschrank', 'inventory_2', 'orange', 2),
    (new.id, 'Getränke',       'local_drink', 'purple', 3);

  return new;
end;
$$;

-- Row-level security ---------------------------------------------------------

alter table public.storage_locations enable row level security;
alter table public.categories enable row level security;

-- storage_locations: full CRUD for members of the owning household.
create policy storage_locations_select on public.storage_locations
  for select to authenticated
  using (public.is_household_member(household_id));

create policy storage_locations_insert on public.storage_locations
  for insert to authenticated
  with check (public.is_household_member(household_id));

create policy storage_locations_update on public.storage_locations
  for update to authenticated
  using (public.is_household_member(household_id))
  with check (public.is_household_member(household_id));

create policy storage_locations_delete on public.storage_locations
  for delete to authenticated
  using (public.is_household_member(household_id));

-- categories: everyone reads the global defaults; members also read and manage
-- their household's custom ones. The global defaults are read-only for regular
-- users (no household to be a member of).
create policy categories_select on public.categories
  for select to authenticated
  using (household_id is null or public.is_household_member(household_id));

create policy categories_insert on public.categories
  for insert to authenticated
  with check (
    household_id is not null and public.is_household_member(household_id)
  );

create policy categories_update on public.categories
  for update to authenticated
  using (household_id is not null and public.is_household_member(household_id))
  with check (
    household_id is not null and public.is_household_member(household_id)
  );

create policy categories_delete on public.categories
  for delete to authenticated
  using (household_id is not null and public.is_household_member(household_id));

-- Data API grants (see the households migration for the rationale).
grant select, insert, update, delete on public.storage_locations to authenticated;
grant select, insert, update, delete on public.categories to authenticated;
