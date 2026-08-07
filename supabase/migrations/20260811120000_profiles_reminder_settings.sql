-- Per-user expiry reminder settings (E5.1).
--
-- Extends the profiles table with the local-notification preferences: whether
-- expiry reminders fire, how many days before a best-before date to warn
-- (replacing the previously fixed 3-day window), and the daily time-of-day for
-- the digest. Like the E4.2 settings these hang off profiles (KISS, ADR-0011):
-- single-valued per user and always fetched with the rest of the profile.
--
-- reminder_lead_days: whole days of lead time, bounded to the scheduler's
-- 14-day planning horizon. reminder_time: an 'HH:mm' string (text, not the
-- Postgres time type) so it round-trips 1:1 with the app-side value object and
-- avoids 'HH:MM:SS' parsing.
--
-- The NOT NULL + default on every column matters: handle_new_user() and the
-- repository's insert-fallback supply only (id, display_name), so each new
-- column must default itself. The existing self-only profiles_update RLS policy
-- is column-agnostic and already covers these; no policy or grant change needed.

alter table public.profiles
  add column reminders_enabled boolean not null default false,
  add column reminder_lead_days integer not null default 3
    check (reminder_lead_days between 1 and 14),
  add column reminder_time text not null default '20:00';
