# Architecture Overview

This document describes how Zaiko is structured and why. Individual decisions
are recorded as [Architecture Decision Records](adr/README.md) (ADRs); this
page is the map that ties them together.

## Guiding principles

- **Feature-first, layered inside.** Code is grouped by feature, and each
  feature is layered internally (presentation → domain → data). See
  [ADR-0003](adr/0003-feature-first-structure.md).
- **Unidirectional data flow.** Widgets watch state, state changes flow down.
  Riverpod providers are both the state management and the dependency
  injection mechanism. See [ADR-0004](adr/0004-riverpod-state-management-and-di.md).
- **Keep it as simple as the project allows.** This is a portfolio-scale app;
  we deliberately avoid ceremony (no separate DI container, no use-case class
  per method) until a feature proves it is needed.

## Folder structure

```
lib/
├── main.dart                  # Entry point: bootstraps ProviderScope
├── app.dart                   # Root widget: theming + routing
├── core/                      # App-wide building blocks, feature-agnostic
│   ├── config/                # AppConfig (compile-time configuration)
│   ├── constants/             # App-wide constants
│   ├── l10n/                  # Localization helpers (context.l10n)
│   ├── router/                # go_router route table (single source of truth)
│   └── theme/                 # Design tokens + ThemeData
├── l10n/                      # ARB files + generated localizations
├── shared/                    # Reusable UI widgets used by multiple features
│   └── widgets/
└── features/                  # One folder per user-facing feature
    └── inventory/
        └── presentation/      # Widgets, pages, providers/controllers
            └── pages/
```

Layers inside a feature are created **when they are needed**, not upfront:

```
features/<feature>/
├── presentation/   # Pages, widgets, view models
├── application/    # Riverpod providers and controllers
├── domain/         # Entities + repository interfaces (pure Dart, no Flutter)
└── data/           # Repository implementations, DTOs, data sources
```

Dependency rule: `presentation → application → domain ← data`. The domain layer
knows nothing about Flutter, Supabase, or the local database. Presentation and
data both depend on domain, never on each other; `application/` is the only
layer that wires a repository to the UI.

Repository **interfaces** and their failure types belong to `domain/`, their
backend implementations to `data/`. (`features/auth` still keeps its interface
in `data/` from before this was settled; it is scheduled to move.)

- **`core/`** holds building blocks every feature may use but that belong to
  no feature (theme, router, constants, utils).
- **`shared/`** holds reusable *widgets* (e.g. `EmptyState`). Rule of thumb:
  a widget moves here once a second feature needs it.
- **`test/`** mirrors the `lib/` structure one-to-one
  (`test/features/inventory/...` tests `lib/features/inventory/...`).

## Technology decisions

| Concern | Decision | ADR |
|---|---|---|
| Flutter version | Pinned via FVM (`.fvmrc`) | [ADR-0001](adr/0001-pin-flutter-version-with-fvm.md) |
| Linting | `flutter_lints` + strict analyzer modes | [ADR-0002](adr/0002-tooling-and-static-analysis.md) |
| Project structure | Feature-first | [ADR-0003](adr/0003-feature-first-structure.md) |
| State management & DI | Riverpod | [ADR-0004](adr/0004-riverpod-state-management-and-di.md) |
| Navigation | go_router | [ADR-0005](adr/0005-go-router-for-navigation.md) |
| Backend & networking | Supabase (`supabase_flutter`), repository pattern | [ADR-0006](adr/0006-supabase-backend-and-networking.md) |
| Local persistence | Deferred — evaluated when offline support lands | [ADR-0007](adr/0007-local-persistence-deferred.md) |

## Error handling conventions

- Repositories catch data-source exceptions at the boundary and rethrow them
  as domain-specific failures; UI layers never see raw `PostgrestException`
  or `SocketException`.
- Async UI state is modeled with Riverpod's `AsyncValue`, which forces every
  screen to handle loading and error states explicitly.

## Testing strategy

- **Unit tests** for domain logic and controllers (pure Dart, fast).
- **Widget tests** for pages and shared widgets.
- Integration/E2E tests are added once there is a real backend to talk to.
- CI (`.github/workflows/ci.yml`) runs format check, `flutter analyze`,
  `flutter test`, and a debug Android build on every PR.
