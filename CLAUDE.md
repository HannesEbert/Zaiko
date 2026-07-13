# CLAUDE.md — AI Assistant Guidelines for Zaiko

This file defines rules and context for AI coding assistants (Claude, Claude Code, etc.) working on this project. **Read this before writing or modifying any code.**

---

## 1. Project Context

**Zaiko** (在庫, Japanese for "inventory") is a Flutter app for household food inventory tracking with expiration dates, collaborative shopping lists, and smart notifications.

- **Platform:** iOS-first (Android planned later — never write iOS-only hacks that block Android)
- **Flutter:** 3.13.0, pinned via FVM — never suggest upgrading without being asked
- **State Management:** Riverpod (with riverpod_annotation / code generation)
- **Local Database:** Isar
- **Backend / Sync:** Supabase (auth, Postgres, realtime)
- **Linting:** very_good_analysis (see `analysis_options.yaml`)
- **This is a portfolio project.** Code quality, clean Git history, and documentation matter as much as functionality.

---

## 2. Golden Rules (Non-Negotiable)

1. **DRY — no duplication.** Before writing new code, check if similar logic already exists. Extract shared logic into `lib/utils/`, shared widgets into `lib/widgets/common/`, shared services into `lib/services/`. Never copy-paste code between files.
2. **KISS — simplest solution that works.** No premature abstraction, no speculative features, no "we might need this later". Three similar lines of code do not need a factory pattern.
3. **One responsibility per file/class/function.** If a function does two things, split it. If a widget file exceeds ~300 lines, extract sub-widgets.
4. **Never break existing behavior.** When modifying code, preserve the existing public API unless explicitly asked to change it.
5. **All code, comments, identifiers, and commit messages in English.** Conversation with the developer may be German, but the codebase is 100% English.
6. **No secrets in code.** API keys, Supabase URLs/keys go into `.env` / `lib/config/secrets.dart` (gitignored). Never hardcode credentials, even in examples.
7. **If unsure, ask — don't guess.** When requirements are ambiguous, ask one precise question instead of implementing an assumption.

---

## 3. Architecture & Folder Structure

Respect this structure. Never place files elsewhere without discussion:

```
lib/
├── config/          # App config, routes, theme (colors, typography)
├── models/          # Isar collections & domain models
├── providers/       # Riverpod providers (one provider per file)
├── screens/         # One folder per screen: screen file + widgets/ subfolder
├── services/        # Database, notifications, Supabase sync (no UI code!)
├── widgets/         # Reusable widgets (common/ = generic, components/ = domain)
└── utils/           # Pure helper functions, constants, validators
```

**Layer rules:**
- `screens/` may use `providers/`, `widgets/`, `models/` — never `services/` directly
- `providers/` are the only layer that talks to `services/`
- `services/` never import Flutter UI packages (`material.dart`, `cupertino.dart`)
- `models/` have zero dependencies on other layers

---

## 4. Code Style

- Follow `analysis_options.yaml` strictly — code must pass `flutter analyze` with **zero warnings**
- `dart format` before every commit (line length: default 80)
- Prefer `const` constructors wherever possible
- Prefer `final` over `var`; avoid mutable state outside providers
- Widgets: always `Key? key` parameter, always typed (`StatelessWidget`/`ConsumerWidget`)
- Naming: `snake_case` files, `PascalCase` classes, `camelCase` members, `SCREAMING_SNAKE_CASE` only for compile-time constants in `utils/constants.dart`
- No magic numbers/strings in widgets — use `AppSpacing`, `AppColors`, `AppTypography` from `lib/config/theme/`
- Comments explain **why**, not **what**. No commented-out code in commits.
- Public APIs (services, providers, models) get dartdoc comments (`///`)

---

## 5. State Management (Riverpod)

- Use code generation (`@riverpod` annotation) — no manual `StateNotifierProvider` boilerplate
- One provider per file, named after what it provides: `food_items_provider.dart`
- UI reads state via `ref.watch`, triggers actions via `ref.read(...).method()`
- No business logic in widgets — widgets render state and forward events, nothing else
- Async state always modeled with `AsyncValue` — every screen handles loading & error states

---

## 6. Database (Isar)

- All collections live in `lib/models/`, one collection per file
- After model changes always mention: `dart run build_runner build --delete-conflicting-outputs`
- Schema changes must stay backwards-compatible or include a migration note
- All Isar access goes through `lib/services/database_service.dart` — never open Isar instances in widgets or providers directly

---

## 7. Testing

- Every service and every non-trivial util function gets unit tests in `test/` (mirroring `lib/` structure)
- Every provider with logic gets a test using `ProviderContainer`
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
- CI (`flutter analyze`, `dart format`, `flutter test`) must pass before merge

---

## 9. How Claude Should Work in This Project

### Workflow for every task
1. **Understand:** Restate the task in one sentence. Ask if ambiguous.
2. **Locate:** Identify affected files/layers before writing code. Check for existing implementations to reuse.
3. **Plan:** For anything beyond a trivial change, list the steps briefly before coding.
4. **Implement:** Complete, runnable code — no `// TODO: implement` stubs, no pseudo-code, no omitted imports.
5. **Verify:** State which commands to run (`flutter analyze`, `flutter test`, `build_runner`) and what output to expect.
6. **Commit:** Suggest a conventional commit message for the change.

### Output rules
- When editing existing files: show the **complete changed file** or a clearly marked, unambiguous diff — never fragments that could be misapplied
- New files: always state the **full path** (e.g. `lib/services/notification_service.dart`)
- Match the versions in `pubspec.yaml` — never introduce a new dependency without stating why and asking first
- If a request conflicts with these rules, say so and propose a compliant alternative instead of silently complying

### Consistency
- Same task type → same structure and patterns as existing code (look at neighboring files first)
- Never mix architectural styles (e.g. no Bloc, no GetX, no setState for shared state)
- Reuse the existing theme system for all UI — no inline colors, no inline text styles

---

## 10. Definition of Done

A task is only complete when:
- [ ] Code passes `flutter analyze` with zero warnings
- [ ] Code is formatted (`dart format`)
- [ ] Tests exist for new logic and all tests pass
- [ ] No duplicated logic introduced
- [ ] Follows folder structure & layer rules
- [ ] Conventional commit message provided
- [ ] No secrets, no commented-out code, no TODOs left behind
