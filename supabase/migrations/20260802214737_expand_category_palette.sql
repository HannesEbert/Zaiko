-- Expand the category / storage-location colour palette and replace the eight
-- generic default categories with a finer 12-category set (each with its own
-- colour key + Material icon).
--
-- The palette CHECK and the original defaults shipped in
-- 20260802181115_storage_locations_categories.sql. That migration is merged and
-- therefore append-only, so this change supersedes it with a new migration.

-- Widen the colour palette on both tables (drop + re-add the inline CHECK).
alter table public.storage_locations
  drop constraint storage_locations_color_check,
  add constraint storage_locations_color_check check (color in (
    'blue', 'cyan', 'orange', 'purple', 'green', 'red', 'amber', 'yellow',
    'beige', 'lime', 'slate', 'pink', 'brown'
  ));

alter table public.categories
  drop constraint categories_color_check,
  add constraint categories_color_check check (color in (
    'blue', 'cyan', 'orange', 'purple', 'green', 'red', 'amber', 'yellow',
    'beige', 'lime', 'slate', 'pink', 'brown'
  ));

-- Replace the global default categories with the 12-category taxonomy. Items
-- that referenced an old default fall back to null via the FK's `on delete set
-- null` (there is no production data yet).
delete from public.categories where is_default;

insert into public.categories (name, icon, color, is_default) values
  ('Obst & Gemüse',                'eco',             'green',  true),
  ('Fleisch & Fisch',              'set_meal',        'red',    true),
  ('Käse, Eier & Molkerei',        'egg',             'amber',  true),
  ('Brot, Cerealien & Aufstriche', 'bakery_dining',   'orange', true),
  ('Nudeln, Reis & Getreide',      'ramen_dining',    'yellow', true),
  ('Backen & Kochzutaten',         'cake',            'beige',  true),
  ('Öle, Soßen & Gewürze',         'soup_kitchen',    'lime',   true),
  ('Fertiggerichte & Konserven',   'takeout_dining',  'slate',  true),
  ('Tiefkühlkost',                 'ac_unit',         'cyan',   true),
  ('Süßes & Salziges',             'cookie',          'pink',   true),
  ('Tee, Kaffee & Kakao',          'coffee',          'brown',  true),
  ('Getränke & Genussmittel',      'local_bar',       'purple', true);
