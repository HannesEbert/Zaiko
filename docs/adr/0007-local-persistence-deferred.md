# ADR-0007: Local persistence decision deferred

**Status:** Accepted · **Date:** 2026-07-11

## Context

Earlier project notes shortlisted **Isar**, **Drift**, and **Hive** for local
storage. A local database only becomes necessary when offline support or
caching is implemented — no current feature needs it yet.

## Decision

**Defer the choice** until offline support is actually scheduled. Deciding
now would mean carrying an unused dependency and possibly betting on the
wrong horse before the access patterns are known.

Recorded evaluation state, to be re-checked when the decision is due:

- **Drift (current lean):** actively maintained, SQL/relational — mirrors the
  Supabase Postgres schema, which makes a sync layer conceptually simple.
- **Isar:** was the original recommendation, but its maintenance has been
  unreliable (long gaps between releases, large open-issue backlog) — this
  needs re-evaluation at decision time.
- **Hive:** key-value only; fine for preferences, too limited as an offline
  mirror of relational data.

Because repositories abstract all data access
([ADR-0006](0006-supabase-backend-and-networking.md)), deferring this costs
nothing architecturally: a cache slots into the data layer behind existing
interfaces.

## Consequences

- Until then, the app is online-only against Supabase.
- A follow-up ADR supersedes this one when offline support is designed.
