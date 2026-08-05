-- Deduplicate the shared Open Food Facts cache by barcode.
--
-- Resolved products are cached as shared-catalog rows (household_id null,
-- source 'openFoodFacts'). This partial unique index guarantees at most one
-- live shared entry per barcode, so concurrent scans of the same product race
-- safely: the second INSERT is rejected and the caller re-reads the first
-- (see ADR-0012). It is intentionally scoped so it never constrains a
-- household's own custom products or soft-deleted rows.

create unique index foods_off_barcode_unique
  on public.foods (barcode)
  where source = 'openFoodFacts' and deleted_at is null;
