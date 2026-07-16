# CLAUDE.md — AI Assistant Guidelines for Zaiko

This file defines rules and context for AI coding assistants (Claude, Claude Code, etc.) working on this project. **Read this before writing or modifying any code.**

---

## 1. Project Context

**Zaiko** (在庫, Japanese for "inventory") is a Flutter app for household food inventory tracking with expiration dates, collaborative shopping lists, and smart notifications.

- **Platform:** iOS-first (Android planned later — never write iOS-only hacks that block Android)
- **Flutter:** pinned via FVM in `.fvmrc` — never suggest upgrading without being asked. Run commands as `fvm flutter …`
- **State Management:** Riverpod (with riverpod_annotation / code generation)
- **Local Database:** none — deferred until offline support is scheduled ([ADR-0007](docs/adr/0007-local-persistence-deferred.md)). The app is online-only against Supabase
- **Backend / Sync:** Supabase (auth, Postgres, realtime)
- **Linting:** `flutter_lints` + strict analyzer modes and extra rules (see `analysis_options.yaml`, [ADR-0002](docs/adr/0002-tooling-and-static-analysis.md))
- **This is a portfolio project.** Code quality, clean Git history, and documentation matter as much as functionality.

**Architecture decisions live in [`docs/adr/`](docs/adr/README.md), with [`docs/architecture.md`](docs/architecture.md) as the map.** The ADRs win over this file if they ever disagree — check them before assuming a structure.

---

## 2. Golden Rules (Non-Negotiable)

1. **DRY — no duplication.** Before writing new code, check if similar logic already exists. Extract feature-agnostic helpers into `lib/core/`, widgets needed by a second feature into `lib/shared/widgets/`. Never copy-paste code between files.
2. **KISS — simplest solution that works.** No premature abstraction, no speculative features, no "we might need this later". Three similar lines of code do not need a factory pattern.
3. **One responsibility per file/class/function.** If a function does two things, split it. If a widget file exceeds ~300 lines, extract sub-widgets.
4. **Never break existing behavior.** When modifying code, preserve the existing public API unless explicitly asked to change it.
5. **All code, comments, identifiers, and commit messages in English.** Conversation with the developer may be German, but the codebase is 100% English.
6. **No secrets in code.** Configuration is injected at compile time via `--dart-define-from-file` and read through `lib/core/config/app_config.dart`, fed from the git-ignored `config/app_config.json` ([ADR-0008](docs/adr/0008-secrets-management.md)). Never hardcode credentials, even in examples.
7. **If unsure, ask — don't guess.** When requirements are ambiguous, ask one precise question instead of implementing an assumption.

---

## 3. Architecture & Folder Structure

**Feature-first**, layered inside each feature ([ADR-0003](docs/adr/0003-feature-first-structure.md)). Respect this structure. Never place files elsewhere without discussion:

```
lib/
├── main.dart        # Entry point: bootstraps ProviderScope
├── app.dart         # Root widget: theming + routing
├── core/            # App-wide building blocks, feature-agnostic
│   ├── config/      # AppConfig (compile-time configuration)
│   ├── constants/   # App-wide constants
│   ├── l10n/        # Localization helpers
│   ├── router/      # go_router route table (single source of truth)
│   └── theme/       # AppColors, AppSpacing, AppTypography, AppTheme
├── l10n/            # ARB files + generated localizations
├── shared/widgets/  # Reusable widgets used by more than one feature
└── features/        # One folder per user-facing feature
    └── <feature>/
        ├── domain/       # Entities + repository interfaces + failures (pure Dart)
        ├── data/         # Repository implementations, DTOs, data sources
        ├── application/  # Riverpod providers and controllers
        └── presentation/ # Pages, widgets, view models
```

Layers inside a feature are created **when needed**, not upfront. A
presentation-only feature is fine until it grows a data layer.

**Layer rules:**
- Dependency rule: `presentation → application → domain ← data`. The `domain/` layer knows nothing about Flutter, Supabase, or any database
- Repository **interfaces** and their failure types live in `domain/`; the Supabase implementation lives in `data/`. Presentation never imports `data/` or `supabase_flutter`
- `application/` providers are the only layer wiring repositories to the UI
- `core/` holds what every feature may use but no feature owns; `shared/` holds widgets — a widget moves there once a second feature needs it
- `test/` mirrors `lib/` one-to-one

`lib/features/auth/` is the reference slice for how a feature is wired
(repository behind an interface, providers in `application/`, a fake repository
in `test/features/auth/fake_auth_repository.dart` for tests). One exception:
its `AuthRepository` interface and `AuthFailure` still sit in `data/` from
before this rule existed and are scheduled to move to `domain/`. Follow the
rule above, not that detail.

---

## 4. Code Style

- Follow `analysis_options.yaml` strictly — code must pass `fvm flutter analyze` with **zero warnings**
- `dart format` before every commit (line length: default 80)
- Prefer `const` constructors wherever possible
- Prefer `final` over `var`; avoid mutable state outside providers
- Widgets: always `Key? key` parameter, always typed (`StatelessWidget`/`ConsumerWidget`)
- Naming: `snake_case` files, `PascalCase` classes, `camelCase` members
- No magic numbers/strings in widgets — use `AppSpacing`, `AppColors`, `AppTypography` from `lib/core/theme/`
- No user-facing strings in widgets — every one goes through `lib/l10n/app_en.arb` + `app_de.arb`, read via `context.l10n`
- Comments explain **why**, not **what**. No commented-out code in commits.
- Public APIs (repositories, providers, domain models) get dartdoc comments (`///`)

---

## 5. State Management (Riverpod)

- Use code generation (`@riverpod` annotation) — no manual `StateNotifierProvider` boilerplate
- Providers live in the feature's `application/`, grouped per feature: `<feature>_providers.dart` (e.g. `auth_providers.dart`). Split the file only when it gets unwieldy
- UI reads state via `ref.watch`, triggers actions via `ref.read(...).method()`
- No business logic in widgets — widgets render state and forward events, nothing else
- Async state always modeled with `AsyncValue` — every screen handles loading & error states

---

## 6. Data & Persistence

- **There is no local database.** The choice is deferred until offline support is scheduled ([ADR-0007](docs/adr/0007-local-persistence-deferred.md)) — never add Isar, Drift, or Hive without discussing it first
- All backend access goes through Supabase behind a repository interface ([ADR-0006](docs/adr/0006-supabase-backend-and-networking.md)). Never call `Supabase.instance` outside a `data/` implementation
- Repositories catch data-source exceptions at the boundary and rethrow them as domain failures — UI never sees a raw `PostgrestException` or `AuthException`
- Domain models live in the owning feature's `domain/`, one per file, built with freezed + json_serializable ([ADR-0009](docs/adr/0009-code-generation.md))
- After model or provider changes always mention: `dart run build_runner build --delete-conflicting-outputs`

---

## 7. Testing

- Every repository and every non-trivial domain function gets unit tests in `test/` (mirroring `lib/` structure)
- Every provider with logic gets a test using `ProviderContainer`, with the repository substituted by a fake (see `test/features/auth/fake_auth_repository.dart`) — never hit a real backend in tests
- Test naming: `test('returns expired items sorted by date', ...)` — describe behavior, not implementation
- When fixing a bug: write a failing test first, then the fix
- Never delete or weaken existing tests to make code pass

---

## 8. Git Workflow

- **Never commit directly to `main`** — feature branches + PR only
- Branch naming: `feature/<short-name>`, `fix/<short-name>`, `chore/<short-name>`
- **Conventional Commits** required:
  - `feat:` new feature
  - `fix:` bug fix
  - `refactor:` no behavior change
  - `test:` tests only
  - `docs:` documentation only
  - `chore:` tooling, dependencies, config
  - `ci:` pipeline changes
- Commit messages: imperative, lowercase, no period, max 72 chars in subject
- Small, atomic commits — one logical change per commit
- **Always branch from `main` and target `main` in the PR.** Never stack a PR onto another feature branch — check the base before opening one
- CI (`fvm flutter analyze`, `dart format`, `fvm flutter test`) must pass before merge
- GitHub issues are written in German (title + body); code and commits stay English

---

## 9. How Claude Should Work in This Project

### Workflow for every task
1. **Understand:** Restate the task in one sentence. Ask if ambiguous.
2. **Locate:** Identify affected files/layers before writing code. Check for existing implementations to reuse.
3. **Plan:** For anything beyond a trivial change, list the steps briefly before coding.
4. **Implement:** Complete, runnable code — no `// TODO: implement` stubs, no pseudo-code, no omitted imports.
5. **Verify:** Actually run them — `fvm flutter analyze`, `dart format`, `fvm flutter test`, and `build_runner` when generated code is involved. Report real output; never claim green without having seen it.
6. **Commit:** Suggest a conventional commit message for the change.

### Output rules
- When editing existing files: show the **complete changed file** or a clearly marked, unambiguous diff — never fragments that could be misapplied
- New files: always state the **full path** (e.g. `lib/features/inventory/data/supabase_inventory_repository.dart`)
- Match the versions in `pubspec.yaml` — never introduce a new dependency without stating why and asking first
- If a request conflicts with these rules, say so and propose a compliant alternative instead of silently complying

### Consistency
- Same task type → same structure and patterns as existing code (look at neighboring files first)
- Never mix architectural styles (e.g. no Bloc, no GetX, no setState for shared state)
- Reuse the existing theme system for all UI — no inline colors, no inline text styles

---

## 10. Definition of Done

A task is only complete when:
- [ ] Code passes `fvm flutter analyze` with zero warnings
- [ ] Code is formatted (`dart format`)
- [ ] Tests exist for new logic and all tests pass
- [ ] No duplicated logic introduced
- [ ] Follows folder structure & layer rules
- [ ] Conventional commit message provided
- [ ] No secrets, no commented-out code, no TODOs left behind
