-- Add a "count" (Anzahl) dimension to inventory items.
--
-- An item now has a per-unit size (quantity + unit, e.g. 1.5 L) and a separate
-- count of how many units are stocked (e.g. a 6-pack). This lets "6 × 1.5 L" be
-- entered as size 1.5 L with count 6, instead of a single misleading figure.
-- unit is now only a measurable amount (g/kg/ml/l) or null; the former
-- 'piece'/'package' units are folded into the count.

alter table public.inventory_items
  add column count integer not null default 1;

-- Existing countable rows (piece/package, or unitless) become a plain count:
-- their quantity was really "how many", so move it into count and clear the
-- now-meaningless size.
update public.inventory_items
  set count = greatest(round(quantity)::int, 1),
      quantity = 1,
      unit = null
  where unit is null or unit in ('piece', 'package');
