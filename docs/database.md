# Database

How Zaiko's Postgres schema is built, changed, and reviewed. The workflow and
its rationale are recorded in
[ADR-0010](adr/0010-database-migrations-workflow.md); this page is the practical
reference.

> **Status:** the workflow is in place, the schema is not designed yet. The ER
> overview and RLS sections below are scaffolds and get filled in with the
> first schema migration.

## Prerequisites

- **Docker** — runs the local Postgres that `supabase start` / `supabase db
  reset` operate on.
- **Supabase CLI** — see the
  [installation docs](https://supabase.com/docs/guides/local-development).

For `supabase db push` against the hosted project, a `SUPABASE_ACCESS_TOKEN`
must be present in the local environment. It is a secret: never commit it, and
never put it in `config/app_config.json` (see
[ADR-0008](adr/0008-secrets-management.md)).

## Commands

| Command | What it does |
|---|---|
| `supabase start` | Boots the local Supabase stack in Docker |
| `supabase stop` | Shuts it down again |
| `supabase migration new <name>` | Creates an empty timestamped migration file |
| `supabase db reset` | Drops the local DB and replays every migration from zero |
| `supabase db push` | Applies pending migrations to the hosted project (manual) |
| `supabase migration list` | Shows which migrations are applied locally vs. hosted |

## Changing the schema

1. `supabase migration new <name>` — creates
   `supabase/migrations/<timestamp>_<name>.sql`.
2. Write the SQL by hand. Table and its RLS policies belong in the **same**
   migration, so review sees the access rules next to the data they guard.
3. `supabase db reset` — must run clean. This is the proof that the chain
   builds an empty database into the current schema.
4. Commit the migration, open a PR, get the SQL reviewed like any other code.
5. `supabase db push` after merge, manually.

**Migrations are append-only.** Once a migration has been applied anywhere, it
is never edited — not to fix a typo, not to reorder a column. Corrections are a
new migration. Editing an applied migration silently desynchronizes every
database that already ran the old version.

## ER overview

Not yet designed. The domain centers on households: users belong to a
household, and inventory items and shopping lists belong to a household rather
than to an individual user — that ownership chain is what the RLS policies key
off.

This section gets the table-by-table overview when the first schema migration
lands.

## RLS patterns

Row-level security is not optional here: household data isolation is the whole
reason the backend has a relational model with membership in it. Every table
holding user data gets RLS enabled, and the policies ship in the same migration
as the table.

The concrete policy patterns (household membership lookup, the read vs. write
split, and how the service role bypasses them) are written down here once the
first tables exist.
