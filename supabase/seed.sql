-- Local development seed. Runs after migrations on `supabase db reset`.
-- Creates one confirmed dev user and a sample household with data so the app
-- has something to show against the local stack. Never runs against hosted.
--
-- Dev login: dev@zaiko.local / password123

insert into auth.users (
  instance_id, id, aud, role, email,
  encrypted_password, email_confirmed_at,
  created_at, updated_at,
  confirmation_token, recovery_token, email_change, email_change_token_new,
  raw_app_meta_data, raw_user_meta_data
) values (
  '00000000-0000-0000-0000-000000000000',
  '11111111-1111-1111-1111-111111111111',
  'authenticated', 'authenticated', 'dev@zaiko.local',
  extensions.crypt('password123', extensions.gen_salt('bf')),
  now(), now(), now(),
  '', '', '', '',
  '{"provider":"email","providers":["email"]}'::jsonb,
  '{}'::jsonb
)
on conflict (id) do nothing;

insert into auth.identities (
  provider_id, user_id, identity_data, provider,
  last_sign_in_at, created_at, updated_at
) values (
  '11111111-1111-1111-1111-111111111111',
  '11111111-1111-1111-1111-111111111111',
  '{"sub":"11111111-1111-1111-1111-111111111111","email":"dev@zaiko.local"}'::jsonb,
  'email', now(), now(), now()
)
on conflict do nothing;

-- Sample household. The on_household_created trigger enrols the dev user as
-- owner and seeds the default storage locations.
insert into public.households (id, name, created_by) values
  ('22222222-2222-2222-2222-222222222222', 'Lindenhof',
   '11111111-1111-1111-1111-111111111111')
on conflict (id) do nothing;

-- A household-specific custom category (the defaults are global, seeded by the
-- migration).
insert into public.categories (id, household_id, name, icon, color, is_default)
values
  ('33333333-3333-3333-3333-333333333333',
   '22222222-2222-2222-2222-222222222222',
   'Snacks', 'cookie', 'orange', false)
on conflict (id) do nothing;

-- A few inventory items in the seeded fridge.
insert into public.inventory_items (
  household_id, name, quantity, unit, category_id, storage_location_id,
  best_before, added_by
)
select
  '22222222-2222-2222-2222-222222222222', v.name, v.quantity, v.unit,
  c.id, sl.id, v.best_before,
  '11111111-1111-1111-1111-111111111111'
from (values
  ('Milch',  1, 'l',       'Milchprodukte', 'Kühlschrank', current_date + 5),
  ('Äpfel',  6, 'piece',   'Obst & Gemüse', 'Kühlschrank', current_date + 10),
  ('Butter', 1, 'package', 'Milchprodukte', 'Kühlschrank', current_date + 2)
) as v(name, quantity, unit, category_name, location_name, best_before)
left join public.categories c
  on c.name = v.category_name and c.is_default
left join public.storage_locations sl
  on sl.name = v.location_name
  and sl.household_id = '22222222-2222-2222-2222-222222222222';

-- A couple of shopping items.
insert into public.shopping_items (
  household_id, name, quantity, category_id, checked, added_by
)
select
  '22222222-2222-2222-2222-222222222222', v.name, v.quantity, c.id, v.checked,
  '11111111-1111-1111-1111-111111111111'
from (values
  ('Haferdrink', '2 x 1 l', 'Milchprodukte', false),
  ('Brot',       '1 Laib',  'Backwaren',     false)
) as v(name, quantity, category_name, checked)
left join public.categories c on c.name = v.category_name and c.is_default;
