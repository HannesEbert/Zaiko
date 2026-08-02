# Database

How Zaiko's Postgres schema is built, changed, and reviewed. The workflow and
its rationale are recorded in
[ADR-0010](adr/0010-database-migrations-workflow.md); this page is the practical
reference.

> **Status:** the first schema is in place (households, membership, storage
> locations, categories, foods, inventory items, shopping items). Its design and
> rationale are recorded in [ADR-0011](adr/0011-database-schema-design.md).

## Prerequisites

- **Docker** — runs the local Postgres that `supabase start` / `supabase db
  reset` operate on.
- **Supabase CLI** — see the
  [installation docs](https://supabase.com/docs/guides/local-development).

For `supabase db push` against the hosted project, a `SUPABASE_ACCESS_TOKEN`
must be present in the local environment. It is a secret: never commit it, and
never put it in `config/app_config.json` (see
[ADR-0008](adr/0008-secrets-management.md)).

## Commands

| Command | What it does |
|---|---|
| `supabase start` | Boots the local Supabase stack in Docker |
| `supabase stop` | Shuts it down again |
| `supabase migration new <name>` | Creates an empty timestamped migration file |
| `supabase db reset` | Drops the local DB and replays every migration from zero |
| `supabase db push` | Applies pending migrations to the hosted project (manual) |
| `supabase migration list` | Shows which migrations are applied locally vs. hosted |

## Changing the schema

1. `supabase migration new <name>` — creates
   `supabase/migrations/<timestamp>_<name>.sql`.
2. Write the SQL by hand. Table and its RLS policies belong in the **same**
   migration, so review sees the access rules next to the data they guard.
3. `supabase db reset` — must run clean. This is the proof that the chain
   builds an empty database into the current schema.
4. Commit the migration, open a PR, get the SQL reviewed like any other code.
5. `supabase db push` after merge, manually.

**Migrations are append-only.** Once a migration has been applied anywhere, it
is never edited — not to fix a typo, not to reorder a column. Corrections are a
new migration. Editing an applied migration silently desynchronizes every
database that already ran the old version.

## ER overview

The domain centers on **households**. A user belongs to at most one household
(`household_members.user_id` is unique); inventory and shopping items belong to
a household, never directly to a user. That ownership chain is what the RLS
policies key off.

```
auth.users ─┐
            ├─< household_members >── households ──< household_invites
            │                            │
            │                            ├──< storage_locations
            │                            ├──< categories        (also global defaults, household_id null)
            │                            ├──< foods             (also shared catalog, household_id null)
            │                            ├──< inventory_items >── foods / categories / storage_locations
            │                            └──< shopping_items  >── categories
            └── added_by / created_by (audit references)
```

| Table | Purpose | Notes |
|---|---|---|
| `households` | Top of the ownership chain | `created_by` is nullable audit (set null on user delete) |
| `household_members` | Who is in a household, with a role | `user_id` unique → one household per user; role `owner`/`member` |
| `household_invites` | Short-lived join tokens | unique `token`, `expires_at`; a QR code encodes the token link |
| `storage_locations` | Per-household places (fridge, freezer, …) | seeded with a default set on household creation |
| `categories` | Item categories | hybrid: global defaults (`household_id` null, `is_default`) + per-household custom |
| `foods` | Product catalog | shared cache (`household_id` null) + per-household products; soft-deleted |
| `inventory_items` | What's in stock | household-scoped; `quantity`/`unit`, `best_before`; soft-deleted |
| `shopping_items` | The shopping list | household-scoped; `checked`; hard-deleted (no `deleted_at`) |

`color` on storage locations and categories stores a stable palette key (e.g.
`green`, `amber`, `cyan`; see the `AppColors.category*` constants for the full
set) that the app maps to a color; the twelve default categories each get their
own key, storage-location defaults use blue/cyan/orange/purple. `icon` stores a
Material icon identifier. Retention: `purge_expired()` hard-deletes
`deleted_at` tombstones older than 30 days and drops expired invites, scheduled
via `pg_cron` on the hosted project.

## RLS patterns

Row-level security is not optional here: household data isolation is the whole
reason the backend has a relational model with membership in it. Every table
holding user data gets RLS enabled, and the policies ship in the same migration
as the table. Because new tables are **not** auto-exposed to the Data API, each
table also grants CRUD to the `authenticated` role in the same migration — the
grant makes the table reachable, RLS decides which rows. `anon` gets nothing.

**Membership lookup.** Two `SECURITY DEFINER` helpers,
`is_household_member(hid)` and `is_household_owner(hid)`, answer "is the current
user in / an owner of this household?". They are `SECURITY DEFINER` so they read
`household_members` without invoking that table's own RLS (which would recurse),
with `search_path` pinned to `public`.

**Read vs. write split.** The common pattern is: `select` for members of the
owning household; the same for `insert`/`update`/`delete`. Owner-only actions
(rename/delete a household, remove members) use `is_household_owner`. Global rows
(default categories, the shared food catalog, `household_id null`) are readable
by every authenticated user but not writable by them.

**Membership changes bypass RLS deliberately.** There is no member `INSERT`
policy. The creator is enrolled by the `on_household_created` trigger, and
joining via an invite runs through a `SECURITY DEFINER` RPC (see below) — both
run as the definer and so are not gated by RLS, which is what lets them write
membership while direct client inserts stay blocked. The service role bypasses
RLS entirely for administrative tasks.

## Invite RPCs

Invite generation and join are two `SECURITY DEFINER` functions
(`20260803090000_household_invite_rpcs.sql`), the only sanctioned write path for
membership and for consuming an invite (`household_members` has no `INSERT`
policy, `household_invites` no `UPDATE` policy).

- **`create_household_invite(hid uuid) → text`** — checks the caller is a member
  of `hid`, then inserts an invite with a fresh 6-character code (alphabet
  `ABCDEFGHJKLMNPQRSTUVWXYZ23456789`, no `0/O/1/I/L`, regenerated on collision)
  and `expires_at = now() + 15 min`, and returns the code. The QR shown in the
  app encodes the `/join/<code>` link.
- **`accept_household_invite(invite_code text) → uuid`** — enforces the
  one-household-per-user rule, locks and validates the invite (`for update`),
  inserts the caller as a `member`, marks the invite `used_at`, and returns the
  joined household id.

Failures raise custom SQLSTATEs, surfaced to the client as
`PostgrestException.code` and mapped to localized messages in the Dart
repository:

| Code | Meaning |
| --- | --- |
| `ZKH01` | caller already belongs to a household |
| `ZKH02` | invite code not found |
| `ZKH03` | invite already used |
| `ZKH04` | invite expired |
| `42501` | caller is not a member of the household (create) |
