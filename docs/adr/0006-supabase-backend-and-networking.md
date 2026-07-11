# ADR-0006: Supabase as backend, repository pattern for networking

**Status:** Accepted · **Date:** 2026-07-11

## Context

Collaborative shopping lists and multi-device sync require a backend with
auth, a relational data model (households ↔ members ↔ items), and realtime
updates. Building and operating a custom API is out of scope for a solo
portfolio project.

## Decision

- **Supabase** as backend-as-a-service: PostgreSQL (fits the relational
  domain), built-in auth, row-level security for household data isolation,
  and realtime subscriptions for collaborative lists — all with a first-class
  Flutter SDK (`supabase_flutter`).
- **No general-purpose HTTP client (dio/http) for now.** The Supabase SDK
  covers all networking; adding dio would be an unused abstraction. If a
  non-Supabase API is ever consumed (e.g. a product/barcode database), an
  HTTP client gets introduced *inside that feature's data layer* with its own
  ADR.
- **Repository pattern as the boundary:** feature code talks to repository
  interfaces defined in `domain/`; implementations in `data/` call Supabase.
  Data-source exceptions (`PostgrestException`, network errors) are caught at
  this boundary and rethrown as domain failures, so UI code never depends on
  Supabase types.

The `supabase_flutter` dependency is added with the first backend-connected
feature, not before; configuration (URL, anon key) will come from `.env` /
`--dart-define`, never committed.

## Alternatives considered

- **Firebase** — comparable feature set, but Firestore's document model fits
  the relational household/inventory domain worse than Postgres, and vendor
  lock-in is higher. Supabase's SQL schema is also a portfolio asset in
  itself.
- **Custom REST/GraphQL backend** — maximum control, but hosting, auth, and
  realtime would consume the project's entire time budget.

## Consequences

- The repository boundary keeps a later backend migration (or an offline
  cache, see [ADR-0007](0007-local-persistence-deferred.md)) contained in the
  data layer.
- Row-level security policies become part of the reviewed schema — the
  database schema will be documented in `docs/` once designed.
