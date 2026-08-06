-- Give recipe steps an optional per-step timer.
--
-- E3.2's cook mode gains recipe-defined step timers: a step can carry a fixed
-- duration (e.g. "bake for 15 min") or none (e.g. "chop the onions"). A flat
-- text[] can't hold that, so `steps` becomes a jsonb array of objects
-- `{ "text": "...", "timer_seconds": 900 }` (timer_seconds omitted/null = no
-- timer).
--
-- Postgres forbids a subquery inside an `ALTER COLUMN ... TYPE ... USING`
-- transform, and mapping a text[] to an array of objects needs an aggregate.
-- So the conversion runs through a temporary column + `UPDATE` (which may
-- aggregate), then drop + rename. `with ordinality` keeps the step order.

alter table public.recipes
  add column steps_jsonb jsonb not null default '[]'::jsonb;

update public.recipes r
set steps_jsonb = coalesce(
  (
    select jsonb_agg(jsonb_build_object('text', s.val) order by s.ord)
    from unnest(r.steps) with ordinality as s(val, ord)
  ),
  '[]'::jsonb
);

alter table public.recipes drop column steps;
alter table public.recipes rename column steps_jsonb to steps;
