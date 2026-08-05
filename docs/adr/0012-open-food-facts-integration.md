# ADR-0012: Open Food Facts integration (barcode scan + product lookup)

**Status:** Accepted · **Date:** 2026-08-05

## Context

Adding an inventory item by hand is slow. The fastest path is to scan a
product's barcode (or search it by name), resolve it against
[Open Food Facts](https://world.openfoodfacts.org) (OFF) — a free, open product
database — and pre-fill the add form. This is the first non-Supabase API the app
consumes and the first feature that needs the camera, so two net-new concerns
arrive together: an HTTP client and a runtime permission.

[ADR-0006](0006-supabase-backend-and-networking.md) already anticipated this:
"If a non-Supabase API is ever consumed (e.g. a product/barcode database), an
HTTP client gets introduced *inside that feature's data layer* with its own
ADR." The configuration (`OFF_USER_AGENT`, read via `AppConfig.offUserAgent`)
and the `Food` model (`FoodSource.openFoodFacts`, `barcode`/`brand`/`imageUrl`)
were put in place ahead of this work; the `foods` table already exists as a
catalog (see [ADR-0011](0011-database-schema-design.md)).

## Decision

### HTTP client — `http`, in `food/data/`

Introduce the `http` package (not `dio`), used **only** inside
`lib/features/food/data/`. OFF access is two simple `GET` requests, so `dio`'s
interceptors/transformers would be unused abstraction (KISS). The client is
injected into the repository constructor so tests substitute
`package:http/testing.dart`'s `MockClient` without hitting the network — the
same seam as `SupabaseAuthRepository([GoTrueClient?])`. Every request sends the
`AppConfig.offUserAgent` header, which OFF's usage policy requires.

### Scanner — `mobile_scanner`

Use `mobile_scanner` for barcode capture. It wraps the platform-native barcode
engines (Apple Vision on iOS, ML Kit on Android), is actively maintained, and is
the de-facto standard in the Flutter ecosystem, exposing the camera preview as a
widget we can style. Camera permission is requested at runtime through
`permission_handler`, which also gives us a clean "permanently denied → open
settings" path.

### Product resolution and caching

- **Two repositories, two responsibilities.** `FoodLookupRepository` (OFF over
  HTTP) resolves a barcode or a search term to `Food` objects.
  `FoodCatalogRepository` (Supabase `foods` table) persists them.
- **Search focuses on Germany, ranked by popularity.** Text search restricts to
  products sold in Germany (`tag_0=germany`, `cc/lc=de`) and sorts by scan count
  (`sort_by=unique_scans_n`), so the DACH audience sees mainstream local brands
  first instead of global imports. Germany is the pragmatic DACH proxy — the big
  Austrian/Swiss brands are listed there too and `cgi/search.pl` cannot OR
  several countries cleanly. Barcode lookup stays global (a barcode is
  worldwide-unique). The UI only searches from two characters on, since a single
  letter is a wildcard.
- **Resilience.** `cgi/search.pl` is slow and returns transient 5xx under load,
  so both requests use a 15s timeout and one automatic retry; a persistent
  timeout or 5xx surfaces as a temporary-unavailability message rather than a
  "check your connection" one.
- **Cache as a shared catalog.** Resolved OFF products are written to `foods`
  with `household_id = null` (the shared cache) and `source = openFoodFacts`, so
  a scan by one household benefits all of them and a re-scan resolves offline.
- **Dedupe by barcode, insert-only.** A partial unique index on
  `barcode` (`where source = 'openFoodFacts' and deleted_at is null`) makes
  concurrent scans of the same code race-safe. Caching is
  `INSERT … ON CONFLICT DO NOTHING` followed by a `SELECT`, never an update:
  RLS lets an authenticated user *insert* a shared (`household_id = null`) row
  but not *update* one (`is_household_member(null)` is false).
- **Quantity prefill.** The add form is seeded with the product's package size
  from Open Food Facts (`product_quantity` + `product_quantity_unit`, normalized
  to the app's units, e.g. 1000 ml → 1 l). This is carried on `Food` as two
  transient, non-persisted fields — a prefill hint only; the shared catalog stays
  size-agnostic.
- **Fallback.** An unknown barcode (or being offline) drops to the manual form
  with the barcode pre-filled; on save a household-scoped `Food`
  (`source = custom`) carrying that barcode is created and linked via
  `inventory_items.food_id`.

### Privacy

- The camera is used **only** on the scanner screen and the controller is
  stopped when it closes. No frame is stored or uploaded — only the decoded
  barcode string leaves the device.
- Requests to OFF carry only the barcode or the search term plus the configured
  User-Agent: no user id, household id, or any other personal data. OFF is a
  third party and its privacy policy applies to what is sent.
- Product images are loaded from OFF's CDN by URL, which exposes the client IP
  to that CDN. This is accepted for the thumbnail preview and noted here so the
  trade-off is explicit.

## Alternatives considered

- **`dio` instead of `http`.** Richer (interceptors, retries), but unnecessary
  for two GETs; `http` keeps the dependency surface minimal.
- **`ai_barcode_scanner` / `flutter_zxing`.** `ai_barcode_scanner` is a thin UI
  wrapper *around* `mobile_scanner` — depending on the base package directly
  keeps us closer to the source and the styling in our own widgets.
  `flutter_barcode_scanner` is effectively unmaintained. `flutter_zxing` bundles
  a C++ engine with a heavier build and no advantage over the OS-native
  decoders.
- **Per-household cache (`household_id` set).** Simpler RLS story (members can
  update their own rows), but duplicates the same product across households and
  loses the "someone already scanned this" offline win. The shared catalog with
  insert-only caching was chosen instead.
- **A live/full-text OFF search backend (search-a-licious).** The stable
  `cgi/search.pl` endpoint is enough for name search in this scope.

## Consequences

- `http` is now a direct dependency but confined to `food/data/`; the repository
  boundary keeps OFF's JSON and HTTP errors out of the rest of the app (mapped
  to `FoodFailure`, mirroring `InventoryFailure`).
- A new migration adds the partial unique index on `foods.barcode`; the shared
  catalog grows over time and is readable by every authenticated user.
- The camera permission and its usage strings become part of the native config
  (`ios/Runner/Info.plist`, `android/.../AndroidManifest.xml`); Android parity
  is kept even though the app is iOS-first.
- `mobile_scanner` pulls in the platform barcode engines, increasing binary
  size — accepted for a core add-item path.
