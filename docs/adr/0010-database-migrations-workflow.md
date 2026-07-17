# ADR-0010: Database schema and migrations workflow

**Status:** Accepted · **Date:** 2026-07-17

## Context

[ADR-0006](0006-supabase-backend-and-networking.md) chose Supabase with
PostgreSQL and noted that row-level security policies "become part of the
reviewed schema". That is only true if the schema exists as files in the
repository — until now it does not. There is no Postgres schema, no migrations,
and no way to put a schema change through review.

Every collaborative feature (inventory, shopping lists) depends on households
plus RLS, so the data foundation has to stand before those features can be
built. Separately, this is a portfolio project: the SQL *is* part of what the
project shows off, which argues against any workflow that leaves it invisible.

This record fixes the **workflow only**. The schema itself follows in its own
change.

## Decision

**Supabase CLI, migrations committed to the repository, local Postgres via
Docker.**

- `supabase/config.toml` is committed; `supabase/migrations/` holds
  hand-written SQL, one file per change.
- Migrations are **append-only**: a migration that has been applied anywhere is
  never edited. A mistake is corrected by a new migration.
- `supabase db reset` replays the whole chain against an empty local database,
  which proves the schema builds from zero rather than only from the current
  state.
- `supabase db push` promotes migrations to the hosted project and is run
  **manually**. It needs a `SUPABASE_ACCESS_TOKEN`, which stays local and is
  never committed (see [ADR-0008](0008-secrets-management.md)).
- RLS policies live in the same migrations as the tables they protect, so a
  table and its access rules are reviewed together.

The workflow in full:

```
supabase migration new <name>   # new file
# write the SQL by hand
supabase db reset               # replay the chain on an empty DB
supabase db push                # against hosted, manual
```

## Alternatives considered

- **SQL written in the Supabase dashboard.** Fastest to start, but nothing is
  reviewable, the schema drifts from any description of it, and no artifact
  lands in the repo. For this project that discards most of the value — the
  schema is a thing to show, not just to run.
- **ORM-driven migrations.** No ORM exists in this stack; there is no local
  database layer at all ([ADR-0007](0007-local-persistence-deferred.md)), so
  there is nothing to generate migrations from.
- **A migrations pipeline in CI.** Automating `db push` on merge would remove
  the manual step, but it needs database credentials in CI and a deploy job to
  maintain — ceremony a solo project does not earn. Manual `db push` is one
  command.

## Consequences

- Local schema work requires **Docker** and the **Supabase CLI**; both are
  developer-machine prerequisites, documented in `docs/database.md`.
- CI is unaffected and needs no database access. `config/app_config.json` is
  gitignored, `AppConfig` reads through `String.fromEnvironment` with an empty
  default and only validates at runtime behind an `assert`, so format, analyze,
  test, and build all compile without configuration and tests run against
  fakes. No deploy job is added.
- Because `db push` is manual, hosted and repo can drift if someone forgets to
  push. `supabase db reset` staying green is the guard that the chain itself is
  sound.
- The append-only rule means the migration list only grows; squashing it is a
  deliberate, separate decision if it ever becomes unwieldy.
