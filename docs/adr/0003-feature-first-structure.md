# ADR-0003: Feature-first project structure

**Status:** Accepted · **Date:** 2026-07-11

## Context

The two common ways to organize a Flutter codebase are **layer-first**
(`lib/presentation`, `lib/domain`, `lib/data` — grouped by technical layer)
and **feature-first** (`lib/features/<feature>/…` — grouped by user-facing
capability, layered inside each feature).

Zaiko has clearly separable features: inventory, expiration management,
shopping lists, notifications, and later recipes and analytics.

## Decision

**Feature-first**, with two supporting top-level folders:

- `lib/features/<feature>/` — everything belonging to one feature, layered
  internally as `presentation/`, `domain/`, `data/` (layers created only when
  needed).
- `lib/core/` — feature-agnostic building blocks: theme, router, constants,
  utils.
- `lib/shared/` — reusable widgets used by more than one feature.

`test/` mirrors `lib/` one-to-one.

Reasoning: when working on "shopping lists", everything relevant sits in one
folder instead of being scattered across three layer folders. Features can be
understood, reviewed, and (worst case) deleted in isolation. This scales
better as the feature list grows, and it is the structure recommended by most
current Flutter architecture guides (including the Riverpod documentation).

## Alternatives considered

- **Layer-first** — works for small apps, but every feature change touches
  three distant folders, and the layer folders grow monotonically until they
  are junk drawers.
- **Strict Clean Architecture with use-case classes** — one class per
  interaction (`GetInventoryItems`, `AddItem`, …). Deliberately not adopted:
  at this project size the indirection costs more than it buys. Repositories
  + Riverpod controllers give the same testability with less ceremony. This
  can be revisited if domain logic becomes genuinely complex.

## Consequences

- The dependency rule (`presentation → domain ← data`) is convention, not
  compiler-enforced; reviews must watch for violations.
- Deciding "is this `shared` or feature-local?" requires judgment — rule of
  thumb: it moves to `shared/` when the second feature needs it.
