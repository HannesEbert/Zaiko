-- Household recipes and their ingredients.
--
-- A recipe belongs to a household (like inventory_items and shopping_items),
-- so every member sees and edits the same recipes. Its step-by-step
-- instructions live in the ordered `steps` text[] column (E3.2's cook mode
-- builds on it); its ingredients are rows in recipe_ingredients, matched by
-- normalized name against the household's stock. Soft delete (deleted_at) +
-- updated_at follow the same shape as inventory_items.

-- Tables ---------------------------------------------------------------------

create table public.recipes (
  id uuid primary key default gen_random_uuid(),
  household_id uuid not null references public.households (id) on delete cascade,
  title text not null,
  -- Total time in minutes; null when unspecified. Drives the "under 30 min"
  -- filter.
  total_minutes integer,
  servings integer,
  image_url text,
  -- Ordered step-by-step instructions; empty until the author adds any.
  steps text[] not null default '{}',
  created_by uuid references auth.users (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create table public.recipe_ingredients (
  id uuid primary key default gen_random_uuid(),
  recipe_id uuid not null references public.recipes (id) on delete cascade,
  name text not null,
  -- Free-form amount (e.g. "200 g", "1 Dose"); null when unspecified. A
  -- structured quantity/unit is deferred, like shopping_items.quantity.
  amount text,
  sort_order integer not null default 0
);

-- Look up a recipe's ingredients (and enforce the RLS join below) cheaply.
create index recipe_ingredients_recipe_id_idx
  on public.recipe_ingredients (recipe_id);

-- Keep updated_at current on every recipe update.
create trigger set_recipes_updated_at
  before update on public.recipes
  for each row execute function public.set_updated_at();

-- Row-level security ---------------------------------------------------------

alter table public.recipes enable row level security;
alter table public.recipe_ingredients enable row level security;

-- recipes: full CRUD for members of the owning household.
create policy recipes_select on public.recipes
  for select to authenticated
  using (public.is_household_member(household_id));

create policy recipes_insert on public.recipes
  for insert to authenticated
  with check (public.is_household_member(household_id));

create policy recipes_update on public.recipes
  for update to authenticated
  using (public.is_household_member(household_id))
  with check (public.is_household_member(household_id));

create policy recipes_delete on public.recipes
  for delete to authenticated
  using (public.is_household_member(household_id));

-- recipe_ingredients: scoped through the parent recipe's household, so a member
-- only ever touches ingredients of a recipe they can already see.
create policy recipe_ingredients_select on public.recipe_ingredients
  for select to authenticated
  using (
    exists (
      select 1 from public.recipes r
      where r.id = recipe_id and public.is_household_member(r.household_id)
    )
  );

create policy recipe_ingredients_insert on public.recipe_ingredients
  for insert to authenticated
  with check (
    exists (
      select 1 from public.recipes r
      where r.id = recipe_id and public.is_household_member(r.household_id)
    )
  );

create policy recipe_ingredients_update on public.recipe_ingredients
  for update to authenticated
  using (
    exists (
      select 1 from public.recipes r
      where r.id = recipe_id and public.is_household_member(r.household_id)
    )
  )
  with check (
    exists (
      select 1 from public.recipes r
      where r.id = recipe_id and public.is_household_member(r.household_id)
    )
  );

create policy recipe_ingredients_delete on public.recipe_ingredients
  for delete to authenticated
  using (
    exists (
      select 1 from public.recipes r
      where r.id = recipe_id and public.is_household_member(r.household_id)
    )
  );

-- Data API grants (see the households migration for the rationale). The RLS
-- policies above remain the actual gate; anon is granted nothing.
grant select, insert, update, delete on public.recipes to authenticated;
grant select, insert, update, delete
  on public.recipe_ingredients to authenticated;
