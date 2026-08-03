import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../household/application/households_providers.dart';
import '../data/supabase_inventory_repository.dart';
import '../domain/category.dart';
import '../domain/expiry.dart';
import '../domain/inventory_item.dart';
import '../domain/inventory_repository.dart';
import '../domain/storage_location.dart';
import 'inventory_view.dart';

part 'inventory_providers.g.dart';

/// The app's [InventoryRepository]. Overridden with a fake in tests.
@riverpod
InventoryRepository inventoryRepository(Ref ref) =>
    SupabaseInventoryRepository();

/// The active household's inventory items, newest first, kept live. Emits an
/// empty list while the user has no household.
@riverpod
Stream<List<InventoryItem>> inventoryItems(Ref ref) async* {
  final household = await ref.watch(currentHouseholdProvider.future);
  if (household == null) {
    yield const [];
    return;
  }
  yield* ref.watch(inventoryRepositoryProvider).watchItems(household.id);
}

/// The active household's storage locations, ordered for the grid.
@riverpod
Future<List<StorageLocation>> storageLocations(Ref ref) async {
  final household = await ref.watch(currentHouseholdProvider.future);
  if (household == null) return const [];
  return ref
      .watch(inventoryRepositoryProvider)
      .loadStorageLocations(household.id);
}

/// The categories visible to the active household (defaults + custom).
@riverpod
Future<List<Category>> categories(Ref ref) async {
  final household = await ref.watch(currentHouseholdProvider.future);
  if (household == null) return const [];
  return ref.watch(inventoryRepositoryProvider).loadCategories(household.id);
}

/// Categories keyed by id, for resolving an item's category cheaply.
@riverpod
Future<Map<String, Category>> categoriesById(Ref ref) async {
  final list = await ref.watch(categoriesProvider.future);
  return {for (final category in list) category.id: category};
}

/// Storage locations keyed by id, for resolving an item's location cheaply.
@riverpod
Future<Map<String, StorageLocation>> storageLocationsById(Ref ref) async {
  final list = await ref.watch(storageLocationsProvider.future);
  return {for (final location in list) location.id: location};
}

/// Inventory items joined with their category and location and tagged with an
/// [ExpiryStatus]. Every display provider derives from this single source.
@riverpod
Future<List<ResolvedItem>> resolvedItems(Ref ref) async {
  final items = await ref.watch(inventoryItemsProvider.future);
  final categoriesById = await ref.watch(categoriesByIdProvider.future);
  final locationsById = await ref.watch(storageLocationsByIdProvider.future);
  final now = DateTime.now();
  return [
    for (final item in items)
      ResolvedItem(
        item: item,
        status: expiryStatus(item.bestBefore, now: now),
        category: categoriesById[item.categoryId],
        location: locationsById[item.storageLocationId],
      ),
  ];
}

/// Counts for the quick-stats strip.
@riverpod
Future<InventoryStats> quickStats(Ref ref) async {
  final resolved = await ref.watch(resolvedItemsProvider.future);
  var soon = 0;
  var expired = 0;
  for (final item in resolved) {
    switch (item.status) {
      case ExpiryStatus.soon:
        soon++;
      case ExpiryStatus.expired:
        expired++;
      case ExpiryStatus.fresh:
      case ExpiryStatus.none:
        break;
    }
  }
  final total = resolved.length;
  return InventoryStats(
    total: total,
    fresh: total - soon - expired,
    soon: soon,
    expired: expired,
  );
}

/// Items needing attention (expiring soon or already expired), most urgent
/// first — the home tab's "expiring soon" rail.
@riverpod
Future<List<ResolvedItem>> expiringSoonItems(Ref ref) async {
  final resolved = await ref.watch(resolvedItemsProvider.future);
  final urgent = resolved
      .where(
        (item) =>
            item.status == ExpiryStatus.soon ||
            item.status == ExpiryStatus.expired,
      )
      .toList();
  // Every urgent item has a best-before date (that is what makes it urgent).
  urgent.sort((a, b) => a.item.bestBefore!.compareTo(b.item.bestBefore!));
  return urgent;
}

/// The most recently added items (already sorted newest-first upstream).
@riverpod
Future<List<ResolvedItem>> recentlyAddedItems(Ref ref) async {
  final resolved = await ref.watch(resolvedItemsProvider.future);
  return resolved.take(_recentlyAddedLimit).toList();
}

/// The items stored in [locationId].
@riverpod
Future<List<ResolvedItem>> itemsForLocation(Ref ref, String locationId) async {
  final resolved = await ref.watch(resolvedItemsProvider.future);
  return resolved
      .where((item) => item.item.storageLocationId == locationId)
      .toList();
}

/// Per-location counts + attention flags for the inventory grid.
@riverpod
Future<List<LocationSummary>> locationSummaries(Ref ref) async {
  final resolved = await ref.watch(resolvedItemsProvider.future);
  final locations = await ref.watch(storageLocationsProvider.future);
  return [for (final location in locations) _summaryFor(location, resolved)];
}

LocationSummary _summaryFor(
  StorageLocation location,
  List<ResolvedItem> resolved,
) {
  var itemCount = 0;
  var soon = 0;
  var expired = 0;
  for (final item in resolved) {
    if (item.item.storageLocationId != location.id) continue;
    itemCount++;
    switch (item.status) {
      case ExpiryStatus.soon:
        soon++;
      case ExpiryStatus.expired:
        expired++;
      case ExpiryStatus.fresh:
      case ExpiryStatus.none:
        break;
    }
  }
  return LocationSummary(
    location: location,
    itemCount: itemCount,
    soonCount: soon,
    expiredCount: expired,
  );
}

const int _recentlyAddedLimit = 5;
