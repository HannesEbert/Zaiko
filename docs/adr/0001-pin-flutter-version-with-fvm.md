# ADR-0001: Pin the Flutter version with FVM

**Status:** Accepted · **Date:** 2026-07-11

## Context

Flutter releases frequently and minor versions can change tooling behavior,
lint results, and build output. Without a pinned version, CI, collaborators,
and the local machine can silently drift apart ("works on my machine").

## Decision

The Flutter version is pinned in [`.fvmrc`](../../.fvmrc) and managed with
[FVM](https://fvm.app). That file is the **single source of truth**:

- Developers run `fvm install` once and prefix commands with `fvm`
  (`fvm flutter pub get`), or configure their IDE to use `.fvm/versions/<v>`.
- CI reads the version out of `.fvmrc` (see `.github/workflows/ci.yml`), so
  bumping the version is a one-file change that automatically applies
  everywhere.

Version upgrades are deliberate, reviewed changes: update `.fvmrc` and
`.vscode/settings.json` in a PR and let CI validate it.

## Alternatives considered

- **`.flutter-version` file (plain text)** — equivalent idea, but FVM is the
  de-facto standard in the Flutter community and manages side-by-side SDK
  installs, which a bare version file does not.
- **No pin, always latest stable** — simplest, but makes builds
  non-reproducible and lets CI break on days Flutter releases.

## Consequences

- Reproducible builds locally and in CI.
- One extra setup step for new developers (`dart pub global activate fvm`,
  `fvm install`), documented in the README.
