-- The food catalog, inventory items and shopping items.
--
-- foods is a product catalog: rows with a null household_id are a shared cache
-- (e.g. Open Food Facts lookups), rows with a household_id are that
-- household's own products. inventory_items and shopping_items are always
-- household-scoped. Soft delete (deleted_at) + updated_at follow the Food
-- model's offline-sync shape; shopping_items are hard-deleted (no deleted_at).

-- Tables ---------------------------------------------------------------------

create table public.foods (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  brand text,
  barcode text,
  image_url text,
  source text not null default 'custom'
    check (source in ('openFoodFacts', 'custom')),
  -- null = shared catalog entry; set = a household's own product.
  household_id uuid references public.households (id) on delete cascade,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create table public.inventory_items (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households (id) on delete cascade,
  food_id uuid references public.foods (id) on delete set null,
  name text not null,
  quantity numeric not null default 1,
  -- Enum value owned by the app (g/kg/ml/l/piece/package); not constrained
  -- here so the enum can grow without a migration.
  unit text,
  category_id uuid references public.categories (id) on delete set null,
  storage_location_id uuid
    references public.storage_locations (id) on delete set null,
  best_before date,
  added_by uuid references auth.users (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create table public.shopping_items (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households (id) on delete cascade,
  name text not null,
  -- Free-form quantity for now (e.g. "2 x 1 l"); a later change structures it.
  quantity text,
  category_id uuid references public.categories (id) on delete set null,
  checked boolean not null default false,
  added_by uuid references auth.users (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

-- Keep updated_at current on every row update.
create trigger set_foods_updated_at
  before update on public.foods
  for each row execute function public.set_updated_at();

create trigger set_inventory_items_updated_at
  before update on public.inventory_items
  for each row execute function public.set_updated_at();

create trigger set_shopping_items_updated_at
  before update on public.shopping_items
  for each row execute function public.set_updated_at();

-- Row-level security ---------------------------------------------------------

alter table public.foods enable row level security;
alter table public.inventory_items enable row level security;
alter table public.shopping_items enable row level security;

-- foods: everyone reads the shared catalog and their household's products;
-- members write their household's products; the shared catalog (null
-- household) is read-only for regular users and maintained by the service role.
create policy foods_select on public.foods
  for select to authenticated
  using (household_id is null or public.is_household_member(household_id));

create policy foods_insert on public.foods
  for insert to authenticated
  with check (household_id is null or public.is_household_member(household_id));

create policy foods_update on public.foods
  for update to authenticated
  using (public.is_household_member(household_id))
  with check (public.is_household_member(household_id));

create policy foods_delete on public.foods
  for delete to authenticated
  using (public.is_household_member(household_id));

-- inventory_items: full CRUD for members of the owning household.
create policy inventory_items_select on public.inventory_items
  for select to authenticated
  using (public.is_household_member(household_id));

create policy inventory_items_insert on public.inventory_items
  for insert to authenticated
  with check (public.is_household_member(household_id));

create policy inventory_items_update on public.inventory_items
  for update to authenticated
  using (public.is_household_member(household_id))
  with check (public.is_household_member(household_id));

create policy inventory_items_delete on public.inventory_items
  for delete to authenticated
  using (public.is_household_member(household_id));

-- shopping_items: full CRUD for members of the owning household.
create policy shopping_items_select on public.shopping_items
  for select to authenticated
  using (public.is_household_member(household_id));

create policy shopping_items_insert on public.shopping_items
  for insert to authenticated
  with check (public.is_household_member(household_id));

create policy shopping_items_update on public.shopping_items
  for update to authenticated
  using (public.is_household_member(household_id))
  with check (public.is_household_member(household_id));

create policy shopping_items_delete on public.shopping_items
  for delete to authenticated
  using (public.is_household_member(household_id));

-- Data API grants (see the households migration for the rationale).
grant select, insert, update, delete on public.foods to authenticated;
grant select, insert, update, delete on public.inventory_items to authenticated;
grant select, insert, update, delete on public.shopping_items to authenticated;
