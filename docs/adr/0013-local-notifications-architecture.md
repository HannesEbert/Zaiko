# ADR-0013: Local notifications architecture

**Status:** Accepted · **Date:** 2026-08-07

## Context

Expiry reminders and the cook-mode step timer (E5.1, #37) need to alert the user
at a specific time even when the app is backgrounded or the phone is locked.
Until now there was no notification infrastructure: the cook timer ran only as a
foreground `Timer.periodic`, and the expiry warning window was a fixed
three-day constant. Reminders are inherently per-device (each household member
on their own phone), and the app is online-only against Supabase
([ADR-0006](0006-supabase-backend-and-networking.md)) with no server-side
scheduling.

## Decision

**Schedule notifications on-device with `flutter_local_notifications`**, planned
locally. No server push.

- **Packages:** `flutter_local_notifications` for scheduling, `timezone` +
  `flutter_timezone` for zone-correct wall-clock times (without the device zone
  name, `tz.local` defaults to UTC and reminders would fire at the wrong hour).
- **Feature-agnostic `NotificationService` in `core/notifications/`** — an
  abstract interface (init, request permission, `scheduleAt`, `cancel`,
  `cancelRange`) exposing only primitive types, with a plugin-backed
  implementation. Both the expiry reminders (inventory) and the cook-mode timer
  (recipes) depend on it, and tests substitute a fake. Ids are allocated in
  non-overlapping blocks (`NotificationIds`) so one feature's reschedule never
  clears another's.
- **Pure planner, impure driver.** A pure, unit-tested function
  (`planExpiryReminders`, in the inventory `domain/`) maps items + lead time +
  daily time onto the notifications to schedule; an `application/` driver
  (`ReminderScheduler`) watches the profile and inventory and drives the
  service. No plugin or `timezone` type crosses into `domain/`.
- **Recompute-and-reschedule model.** A local notification bakes its content at
  schedule time — no code runs at fire time. So the daily "collective" reminder
  is fully recomputed and rescheduled on every relevant change (app start, saved
  setting, inventory edit), over a **14-day horizon** (one notification per day,
  well under the iOS ~64 pending cap). The whole expiry id block is cleared
  before each reschedule, so reschedules can neither duplicate nor leak.
- **Per-user settings on `profiles`** (`reminders_enabled`, `reminder_lead_days`,
  `reminder_time`), replacing the fixed three-day window; single-valued per user
  and stored alongside the rest of the profile ([ADR-0011](0011-database-schema-design.md)).
- **Permission is requested on first enable**, not at startup, via the plugin's
  own permission API. Denial leaves the toggle on; the scheduler simply has
  nothing to deliver until permission is granted in system settings.
- **Native config** kept in parity across platforms per
  [ADR-0012](0012-open-food-facts-integration.md): Android core-library
  desugaring (required by the plugin), notification/exact-alarm/boot permissions
  and the plugin receivers; iOS sets the `UNUserNotificationCenter` delegate for
  foreground alerts.

## Alternatives considered

- **Server push (Supabase + FCM/APNs).** Rejected for now: it needs server
  infrastructure and device-token management for a feature that is per-device
  and works fully offline. A future ADR can supersede this if cross-device or
  server-driven notifications are needed.
- **A single daily repeating notification** (`matchDateTimeComponents`).
  Rejected: its text is fixed, so it cannot reflect the current inventory; the
  recompute model keeps the content accurate.
- **Postgres `time` column for `reminder_time`.** Rejected in favour of an
  `'HH:mm'` text value that round-trips 1:1 with the app-side value object.

## Consequences

- Reminders are per-device; enabling on one phone does not affect another
  household member's.
- Because content is precomputed, a reminder can be at most as fresh as the last
  app open, inventory change or settings change; the 14-day horizon plus
  reschedule-on-open bridges the gap.
- **Known limitations (follow-ups):** notification-tap deep-linking is stubbed;
  a time-zone change between app opens is only corrected on the next open; and
  per-category lead-time overrides are deferred to #53. Android 14 exact-alarm
  UX may need hardening before release.
