import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../household/application/households_providers.dart';
import '../data/supabase_inventory_repository.dart';
import '../domain/category.dart';
import '../domain/expiry.dart';
import '../domain/inventory_item.dart';
import '../domain/inventory_repository.dart';
import '../domain/storage_location.dart';
import 'inventory_query.dart';
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

/// The items added within the last few days, newest first — the inventory
/// tab's "recently added" list.
@riverpod
Future<List<ResolvedItem>> recentlyAddedItems(Ref ref) async {
  final resolved = await ref.watch(resolvedItemsProvider.future);
  return recentlyAddedWithin(resolved, DateTime.now());
}

/// The household's soft-deleted items — the 30-day trash, newest removal first.
@riverpod
Future<List<InventoryItem>> deletedItems(Ref ref) async {
  final household = await ref.watch(currentHouseholdProvider.future);
  if (household == null) return const [];
  return ref.watch(inventoryRepositoryProvider).loadDeletedItems(household.id);
}

/// Trash items joined with their category and location for the trash screen.
@riverpod
Future<List<ResolvedItem>> resolvedDeletedItems(Ref ref) async {
  final items = await ref.watch(deletedItemsProvider.future);
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

/// The items stored in [locationId]. [StorageLocation.unassignedId] selects the
/// items that have no storage location.
@riverpod
Future<List<ResolvedItem>> itemsForLocation(Ref ref, String locationId) async {
  final resolved = await ref.watch(resolvedItemsProvider.future);
  final unassigned = locationId == StorageLocation.unassignedId;
  return resolved
      .where(
        (item) => unassigned
            ? item.item.storageLocationId == null
            : item.item.storageLocationId == locationId,
      )
      .toList();
}

/// Per-location counts + attention flags for the inventory grid. Items without
/// a storage location are gathered into a trailing synthetic "unassigned"
/// bucket, shown only when at least one such item exists so nothing added
/// without a location silently disappears.
@riverpod
Future<List<LocationSummary>> locationSummaries(Ref ref) async {
  final resolved = await ref.watch(resolvedItemsProvider.future);
  final locations = await ref.watch(storageLocationsProvider.future);
  final summaries = [
    for (final location in locations) _summaryFor(location, resolved),
  ];
  final unassigned = _unassignedSummary(resolved);
  if (unassigned.itemCount > 0) summaries.add(unassigned);
  return summaries;
}

LocationSummary _summaryFor(
  StorageLocation location,
  List<ResolvedItem> resolved,
) => _countInto(
  location,
  resolved.where((item) => item.item.storageLocationId == location.id),
);

/// The synthetic bucket for items whose [InventoryItem.storageLocationId] is
/// null. Its location carries [StorageLocation.unassignedId]; the presentation
/// layer resolves the localized name.
LocationSummary _unassignedSummary(List<ResolvedItem> resolved) => _countInto(
  const StorageLocation(
    id: StorageLocation.unassignedId,
    householdId: '',
    name: '',
  ),
  resolved.where((item) => item.item.storageLocationId == null),
);

LocationSummary _countInto(
  StorageLocation location,
  Iterable<ResolvedItem> items,
) {
  var itemCount = 0;
  var soon = 0;
  var expired = 0;
  for (final item in items) {
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

/// The active household's id, or throws an [InventoryFailure] when there is
/// none — the guard every create action shares. Read synchronously: a mutation
/// is only reachable from screens where the household is already resolved.
String _requireActiveHouseholdId(Ref ref) {
  final id = ref.read(currentHouseholdProvider).asData?.value?.id;
  if (id == null) {
    throw const InventoryFailure(
      InventoryFailureReason.unknown,
      'No active household.',
    );
  }
  return id;
}

/// Drives create/edit/consume/restore for inventory items with loading/error
/// state. The item list itself refreshes through the realtime [watchItems]
/// stream, so only the trash (a one-shot load) is invalidated after a change.
@riverpod
class InventoryItemController extends _$InventoryItemController {
  @override
  FutureOr<void> build() {}

  /// Adds a new item to the active household. Returns whether it succeeded.
  Future<bool> add({
    required String name,
    required num quantity,
    String? unit,
    String? categoryId,
    String? storageLocationId,
    DateTime? bestBefore,
  }) => _run(
    () => ref
        .read(inventoryRepositoryProvider)
        .addItem(
          householdId: _requireActiveHouseholdId(ref),
          name: name,
          quantity: quantity,
          unit: unit,
          categoryId: categoryId,
          storageLocationId: storageLocationId,
          bestBefore: bestBefore,
        ),
  );

  /// Overwrites the editable fields of the item with [id].
  Future<bool> save({
    required String id,
    required String name,
    required num quantity,
    String? unit,
    String? categoryId,
    String? storageLocationId,
    DateTime? bestBefore,
  }) => _run(
    () => ref
        .read(inventoryRepositoryProvider)
        .updateItem(
          id: id,
          name: name,
          quantity: quantity,
          unit: unit,
          categoryId: categoryId,
          storageLocationId: storageLocationId,
          bestBefore: bestBefore,
        ),
  );

  /// Sets the item's quantity. A [quantity] of 0 or less means "used up": the
  /// item is soft-deleted into the trash instead of stored as an empty stock.
  Future<bool> setQuantity({required String id, required num quantity}) =>
      _run(() async {
        if (quantity <= 0) {
          await ref.read(inventoryRepositoryProvider).softDeleteItem(id);
          ref.invalidate(deletedItemsProvider);
        } else {
          await ref
              .read(inventoryRepositoryProvider)
              .setItemQuantity(id: id, quantity: quantity);
        }
      });

  /// Removes the item (used up or discarded) into the trash.
  Future<bool> consume(String id) => _run(() async {
    await ref.read(inventoryRepositoryProvider).softDeleteItem(id);
    ref.invalidate(deletedItemsProvider);
  });

  /// Restores a trashed item back into the active inventory.
  Future<bool> restore(String id) => _run(() async {
    await ref.read(inventoryRepositoryProvider).restoreItem(id);
    ref.invalidate(deletedItemsProvider);
  });

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return true;
    } on InventoryFailure catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

/// Drives create/rename/delete for the household's storage locations. Each
/// change invalidates [storageLocationsProvider]; the item views derive from it
/// and refresh in turn.
///
/// Kept alive: the UI only reaches it through `ref.read(...notifier)` and never
/// watches it, so an autoDispose controller would be disposed during the async
/// mutation and its post-`await` `ref.invalidate` would never fire.
@Riverpod(keepAlive: true)
class StorageLocationController extends _$StorageLocationController {
  @override
  FutureOr<void> build() {}

  /// Creates a storage location and returns its id, or null on failure — the id
  /// lets the picker auto-select the freshly created location.
  Future<String?> add({required String name, String? icon, String? color}) =>
      _add(() async {
        final created = await ref
            .read(inventoryRepositoryProvider)
            .addStorageLocation(
              householdId: _requireActiveHouseholdId(ref),
              name: name,
              icon: icon,
              color: color,
            );
        ref.invalidate(storageLocationsProvider);
        return created.id;
      });

  /// Renames / re-styles the storage location with [id].
  Future<bool> save({
    required String id,
    required String name,
    String? icon,
    String? color,
  }) => _run(() async {
    await ref
        .read(inventoryRepositoryProvider)
        .updateStorageLocation(id: id, name: name, icon: icon, color: color);
    ref.invalidate(storageLocationsProvider);
  });

  /// Deletes the storage location with [id]. Items keep existing but lose their
  /// location.
  Future<bool> delete(String id) => _run(() async {
    await ref.read(inventoryRepositoryProvider).deleteStorageLocation(id);
    ref.invalidate(storageLocationsProvider);
  });

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return true;
    } on InventoryFailure catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<String?> _add(Future<String> Function() action) async {
    state = const AsyncLoading();
    try {
      final id = await action();
      state = const AsyncData(null);
      return id;
    } on InventoryFailure catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}

/// Drives create/rename/delete for the household's custom categories (the
/// app-wide defaults are global and not editable). Each change invalidates
/// [categoriesProvider].
///
/// Kept alive for the same reason as [StorageLocationController]: nothing
/// watches it, so autoDispose would drop it mid-mutation and skip the
/// post-`await` `ref.invalidate`.
@Riverpod(keepAlive: true)
class CategoryController extends _$CategoryController {
  @override
  FutureOr<void> build() {}

  /// Creates a custom category and returns its id, or null on failure — the id
  /// lets the picker auto-select the freshly created category.
  Future<String?> add({required String name, String? icon, String? color}) =>
      _add(() async {
        final created = await ref
            .read(inventoryRepositoryProvider)
            .addCategory(
              householdId: _requireActiveHouseholdId(ref),
              name: name,
              icon: icon,
              color: color,
            );
        ref.invalidate(categoriesProvider);
        return created.id;
      });

  /// Renames / re-styles the custom category with [id].
  Future<bool> save({
    required String id,
    required String name,
    String? icon,
    String? color,
  }) => _run(() async {
    await ref
        .read(inventoryRepositoryProvider)
        .updateCategory(id: id, name: name, icon: icon, color: color);
    ref.invalidate(categoriesProvider);
  });

  /// Deletes the custom category with [id]. Items keep existing but lose their
  /// category.
  Future<bool> delete(String id) => _run(() async {
    await ref.read(inventoryRepositoryProvider).deleteCategory(id);
    ref.invalidate(categoriesProvider);
  });

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return true;
    } on InventoryFailure catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<String?> _add(Future<String> Function() action) async {
    state = const AsyncLoading();
    try {
      final id = await action();
      state = const AsyncData(null);
      return id;
    } on InventoryFailure catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}
