# ADR-0005: go_router for navigation

**Status:** Accepted · **Date:** 2026-07-11

## Context

The app starts with a handful of screens, but the roadmap (shared shopping
lists, notifications) implies **deep links**: tapping an expiry notification
should open the item, an invite link should open a specific shopping list.
Imperative `Navigator.push` navigation does not handle URL-based entry points
well.

## Decision

**go_router** for declarative, URL-based routing:

- The route table lives in one place: `lib/core/router/app_router.dart`,
  exposed as a Riverpod provider so redirects can later react to app state
  (e.g. auth).
- Each page owns its `routePath`/`routeName` constants; the router imports
  them, so route strings are never duplicated.
- Deep links map directly to route paths when notifications and invites land
  — no extra plumbing needed.

## Alternatives considered

- **Navigator 1.0 (`Navigator.push`)** — fine for a prototype, but deep links
  and web support must be bolted on later; route logic ends up scattered
  across widgets.
- **auto_route** — comparable feature set, but requires code generation and
  is a community package; go_router is maintained under the official
  flutter.dev umbrella and is the documented default choice.

## Consequences

- All navigation goes through named routes; `Navigator.push` with inline
  `MaterialPageRoute`s is avoided by convention.
- Notification tap-handling and invite links can be implemented as plain
  deep links later without restructuring.
