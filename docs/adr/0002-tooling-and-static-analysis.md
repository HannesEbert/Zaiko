# ADR-0002: Tooling and static analysis

**Status:** Accepted · **Date:** 2026-07-11

## Context

Lint rules and analyzer strictness should be decided once, early, before code
accumulates — retrofitting stricter rules onto a grown codebase is painful.

## Decision

- Baseline lint set: **`flutter_lints`** (the official Flutter-recommended
  set), extended in [`analysis_options.yaml`](../../analysis_options.yaml)
  with the strict analyzer language modes (`strict-casts`,
  `strict-inference`, `strict-raw-types`) and a small curated set of extra
  rules (single quotes, trailing commas, `unawaited_futures`, …).
- Formatting is enforced by `dart format` and checked in CI
  (`--set-exit-if-changed`), so style is never discussed in review.
- `pubspec.lock` is committed — this is an application, so dependency
  resolution must be reproducible.

## Alternatives considered

- **`very_good_analysis`** — a much stricter community set. Good, but it
  front-loads a lot of friction (e.g. mandatory doc comments) for a solo
  project. The chosen setup takes the official baseline and adds the strict
  modes that catch real bugs; individual rules can still be adopted later.
- **Default `flutter_lints` only** — misses the strict type-checking modes,
  which are cheap to enable on a fresh codebase and catch implicit-dynamic
  mistakes.

## Consequences

- CI fails on formatting drift, analyzer warnings, and lint violations.
- Generated files (`*.g.dart`, `*.freezed.dart`) are excluded from analysis
  upfront, anticipating future code generation.
