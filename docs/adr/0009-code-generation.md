# ADR-0009: Code generation for models and providers

**Status:** Accepted · **Date:** 2026-07-14

## Context

Zaiko will have many immutable data models (foods, inventory items, households,
shopping lists) that need value equality, `copyWith`, and JSON (de)serialization
for the Supabase backend and the Open Food Facts API. Writing that boilerplate
by hand is repetitive and a common source of bugs (a forgotten field in
`==`, `hashCode`, `copyWith`, or `toJson`). Riverpod (ADR-0004) additionally
offers a generator that produces type-safe providers from annotated functions
and classes.

Establishing the code-generation toolchain now — before real models exist —
means every model built afterwards starts from the same foundation.

## Decision

Adopt the standard Dart code-generation stack, driven by `build_runner`:

- **freezed** — immutable data classes with value equality, `copyWith`, and
  pattern-matching support.
- **json_serializable** — `fromJson` / `toJson`, wired into the freezed classes.
- **riverpod_generator** — type-safe providers from `@riverpod` annotations.

A reference model, [`Food`](../../lib/features/food/domain/food.dart), proves the
chain end to end (freezed + json_serializable, including an enum with stable
`@JsonValue` codes and a `Food.create` factory that mints the client-side UUID),
and a trivial `@riverpod` provider
([`sampleFoods`](../../lib/features/food/presentation/food_providers.dart))
confirms the Riverpod generator.

**Generated files (`*.freezed.dart`, `*.g.dart`) are committed to the
repository.** A fresh clone builds and runs without a codegen step, generated
output shows up in review, and CI does not need a generation stage.

### Version pinning

The issue targeted the newest major versions, but on the pinned Flutter
(3.41.9 / Dart 3.11, see ADR-0001) the whole generator toolchain only resolves
as a coupled set: `riverpod_generator 4.0.3` requires `riverpod_annotation
4.0.2` (which pins `riverpod 3.2.1`) and `analyzer ^9.0.0`. To satisfy that,
`flutter_riverpod` resolves to **3.3.1** rather than 3.3.2, and
`json_serializable` / `json_annotation` stay on the analyzer-9 line
(`6.13.0` / `4.11.0`). Newer `riverpod_generator` releases (`>= 4.0.4`) require
a newer Dart SDK than the pinned Flutter ships. Exact versions are pinned in
`pubspec.yaml` and locked in `pubspec.lock`; they move up together with the
next Flutter bump.

## Alternatives considered

- **Hand-written models.** No build step and no generated files to review, but
  the per-model boilerplate and its silent-bug risk grow with every field. The
  generators pay for themselves after the first few models.
- **Generating in CI instead of committing.** Keeps generated code out of the
  diff, but makes clones non-runnable without a build, adds a CI stage, and
  turns every generator/analyzer bump into an opaque CI-only change. Committing
  keeps the repo self-contained and the output auditable.
- **`equatable` + manual JSON.** Covers value equality but not `copyWith`,
  unions, or JSON, and still leaves the serialization boilerplate by hand.

## Consequences

- Editing a model or provider requires a codegen run; `build_runner watch`
  keeps output in sync during development (documented in the README).
- Generated files live next to their sources and are excluded from static
  analysis (`analysis_options.yaml` already ignores `*.g.dart` /
  `*.freezed.dart`).
- The codegen packages are coupled to the Flutter/Dart version; upgrades happen
  as a set, re-resolved via `flutter pub upgrade` when the Flutter pin moves.
