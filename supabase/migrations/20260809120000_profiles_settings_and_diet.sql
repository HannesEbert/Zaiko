-- Profile settings and dietary preferences (E4.2).
--
-- Extends the profiles table (E4.1) with the user's app-language preference and
-- their dietary profile. Both hang off profiles rather than a separate table
-- (KISS, ADR-0011): they are single-valued per user and always fetched together
-- with the rest of the profile.
--
-- language: BCP-47-ish app locale code ('de'/'en'); null means "follow the
-- system", the default. Free text on purpose, like avatar_preset, so adding a
-- supported locale needs no migration.
--
-- allergens/diets/dislikes: stable app-side keys the user ticked (e.g. 'gluten',
-- 'vegan'), stored as text[] with an empty-array default. dietary_note is an
-- optional free-text addition to the fixed dislike list. In E4.2 these are only
-- captured and stored; applying them to recipe filtering comes later (E3.3).
--
-- The empty-array defaults matter: handle_new_user() and the repository's
-- insert-fallback list only (id, display_name), so the new NOT NULL array
-- columns must default themselves. The existing self-only profiles_update RLS
-- policy is column-agnostic and already covers these columns; no policy or grant
-- change is needed.

alter table public.profiles
  add column locale text,
  add column allergens text[] not null default '{}',
  add column diets text[] not null default '{}',
  add column dislikes text[] not null default '{}',
  add column dietary_note text;
