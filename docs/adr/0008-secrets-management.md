# ADR-0008: Secrets and configuration management

**Status:** Accepted · **Date:** 2026-07-13

## Context

Zaiko will consume a Supabase backend and the Open Food Facts API. Two kinds
of values need managing:

- **Configuration** that is safe to ship but should not be hard-coded — the
  Supabase project URL, the Supabase **anon** key (access is gated by
  row-level security), and an identifying User-Agent for Open Food Facts.
- **Secrets** that must never reach the app or the repository — above all the
  Supabase `service_role` key.

For a portfolio project, "just don't commit secrets" is not enough: it should
be *technically hard* to leak one by accident.

## Decision

A three-layer approach:

1. **Compile-time injection via `--dart-define-from-file`.** Configuration is
   read through `String.fromEnvironment` in
   [`lib/core/config/app_config.dart`](../../lib/core/config/app_config.dart),
   fed from a git-ignored `config/app_config.json`. A committed
   `config/app_config.example.json` documents the required keys. `AppConfig`
   asserts required values are non-empty in debug builds, so a misconfigured
   run fails fast with a clear message.
2. **`.gitignore` as the first guardrail.** `config/*.json` and `.env*` are
   ignored, with the `*.example` templates explicitly re-included. The real
   config file cannot be staged.
3. **gitleaks at two gates.** A `core.hooksPath`-based `.githooks/pre-commit`
   hook scans staged changes locally, and a `gitleaks` GitHub Actions workflow
   scans every push and pull request. The workflow is a required status check
   on `main`, so a secret can never merge even if the local hook is skipped.
   GitHub's native Push Protection is kept enabled as a fourth backstop.

## Alternatives considered

- **`.env` file loaded at runtime (`flutter_dotenv`).** Adds a runtime
  dependency and ships the file as an asset; `--dart-define-from-file` bakes
  values in at build time with no extra package and no asset to leak.
- **Committing config with only "public" keys.** Even the anon key is better
  kept out of source so environments (dev/staging/prod) stay swappable and no
  key is ever normalized as "fine to commit".

## Consequences

- Running the app requires copying the example file once
  (`cp config/app_config.example.json config/app_config.json`) and filling in
  values — documented in the README setup section.
- CI needs its own config values injected once real network features land;
  until then no secrets exist in the pipeline.
- Enabling the pre-commit hook is a per-clone manual step
  (`git config core.hooksPath .githooks`); the CI check is the enforced
  backstop that does not depend on local setup.
