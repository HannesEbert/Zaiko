# ADR-0011: Database schema design

**Status:** Accepted · **Date:** 2026-08-02

## Context

[ADR-0010](0010-database-migrations-workflow.md) fixed the migrations
*workflow* but deliberately left the schema itself for a later change. This is
that change: the first schema, covering households and membership, storage
locations and categories, the food catalog, inventory items and shopping items.
Every collaborative feature depends on it, so a handful of shape decisions get
made here rather than being rediscovered per feature.

The data model centers on the **household**: inventory and shopping items belong
to a household, not to a user, and row-level security keys off household
membership.

## Decision

**One relational schema in `public`, household-scoped, with RLS on every table.**

- **One household per user.** `household_members.user_id` is `unique`, so a user
  belongs to at most one household. Simpler sharing model; revisited only if
  multi-household is ever a real requirement.
- **Membership via a trigger, not client writes.** Creating a household enrols
  the creator as `owner` and seeds the default storage locations through a
  `SECURITY DEFINER` trigger. There is deliberately no member `INSERT` policy;
  joining another household happens through a `SECURITY DEFINER` RPC (added with
  the households feature) that validates an invite. This keeps a user from
  self-joining an arbitrary household by knowing its id.
- **Short-lived invites.** `household_invites` carries a unique `token` and an
  `expires_at`; a QR code encodes the token link. Acceptance sets `used_at` via
  the join RPC.
- **Hybrid categories.** App-wide default categories are global rows
  (`household_id null`, `is_default true`) seeded once by the migration and
  readable by everyone; households add their own (`household_id` set,
  `is_default false`). A check constraint keeps "default" and "global" in sync.
  Storage locations, by contrast, are always per-household and seeded per
  household on creation.
- **`color` is a palette key, not a hex value.** Storage locations and
  categories store one of `blue|cyan|orange|purple`; the app maps that to the
  `AppColors.category*` constants, so colors stay defined in one place (the
  design system) instead of being duplicated as hex in the database. `icon`
  stores a Material icon identifier.
- **Soft delete + 30-day retention.** `foods` and `inventory_items` carry
  `deleted_at`; a `purge_expired()` function hard-deletes tombstones older than
  30 days and drops expired invites. `shopping_items` are ephemeral and
  hard-deleted (no `deleted_at`). `updated_at` + `deleted_at` mirror the `Food`
  model's offline-sync shape ([ADR-0007](0007-local-persistence-deferred.md)).
- **`foods` is a shared catalog plus per-household products.** A null
  `household_id` is a shared entry (e.g. an Open Food Facts cache row) readable
  by all; a set `household_id` is that household's own product.
- **Data API grants are explicit.** New tables are not auto-exposed to the
  `authenticated` role, so each table grants CRUD to `authenticated`; RLS is the
  actual row gate and `anon` gets nothing.

Scheduling of `purge_expired()` uses `pg_cron` where available (hosted); the
migration skips scheduling quietly when `pg_cron` is not loaded so
`supabase db reset` stays green locally.

## Alternatives considered

- **Multi-household membership.** More flexible, but every RLS policy and the
  whole UI would carry an "active household" concept from day one. Not worth it
  for the current scope; the unique constraint is easy to drop later.
- **Per-household copies of the default categories.** Seeding a full default set
  into every household on creation duplicates rows and makes "is this a default"
  a per-row guess. Global default rows with a nullable `household_id` model the
  hybrid cleanly and keep the defaults editable in exactly one place.
- **Colors as hex in the database.** Self-contained, but it forks the palette:
  the design system already owns these colors, and storing hex invites drift.
  Palette keys keep the database referencing the single source of truth.
- **A background worker for retention.** An app-side or edge job could purge
  tombstones, but a SQL function on a `pg_cron` schedule keeps retention next to
  the data and reviewable in the migration.

## Consequences

- Later features extend this schema through their **own** migrations
  (append-only): a structured shopping quantity/unit, a `profiles` table with
  locale and dietary preferences, recipe tables, and reminder settings all land
  with the feature that needs them rather than being front-loaded here.
- Every new table must ship its RLS policies **and** its `authenticated` grants
  in the same migration; a table without grants is invisible to the app even
  with correct RLS.
- Membership is only ever changed by the creation trigger and the (upcoming)
  join RPC, so those are the places to audit for access-control correctness.
- `pg_cron` scheduling only takes effect on the hosted project; local runs rely
  on `purge_expired()` being callable on demand.
