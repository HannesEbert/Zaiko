# ADR-0004: Riverpod for state management and dependency injection

**Status:** Accepted · **Date:** 2026-07-11

## Context

The app needs a way to hold and update UI state (inventory lists, filters,
auth state), and a way to wire dependencies (repositories, services) into
widgets and into each other — testably, without global singletons.

## Decision

**Riverpod** (`flutter_riverpod` 3.x) serves both purposes:

- **State management:** screens watch providers; async state is modeled with
  `AsyncValue`, which forces explicit handling of loading/error states.
- **Dependency injection:** repositories and services are exposed as
  providers. Tests and previews override them via `ProviderScope(overrides:)`
  — no service locator, no DI container, no code generation required.

Conventions:

- Providers live next to the feature that owns them
  (`features/<feature>/presentation/…` or `…/data/…`); app-wide ones live in
  `core/`.
- Widgets never construct repositories or services directly.

## Alternatives considered

- **Bloc** — solid and widely used, but considerably more boilerplate
  (events, states, blocs per screen) and it still needs a separate DI answer
  (usually `get_it`). The added structure pays off in large teams with strict
  conventions; for this project it is overhead.
- **Provider** — Riverpod's predecessor; compile-time unsafe (runtime
  `ProviderNotFoundException`), tied to the widget tree, and effectively in
  maintenance mode. Riverpod is its designated successor by the same author.
- **get_it + injectable for DI** — works, but introduces a second mechanism
  and code generation for something Riverpod already covers; global service
  locators also make test isolation harder.

## Consequences

- One library to learn covers both state and DI; test setup is uniform
  (`ProviderScope` overrides).
- Riverpod's flexibility means discipline is needed about where providers
  live — hence the conventions above.
