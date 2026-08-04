// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's [InventoryRepository]. Overridden with a fake in tests.

@ProviderFor(inventoryRepository)
final inventoryRepositoryProvider = InventoryRepositoryProvider._();

/// The app's [InventoryRepository]. Overridden with a fake in tests.

final class InventoryRepositoryProvider
    extends
        $FunctionalProvider<
          InventoryRepository,
          InventoryRepository,
          InventoryRepository
        >
    with $Provider<InventoryRepository> {
  /// The app's [InventoryRepository]. Overridden with a fake in tests.
  InventoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<InventoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InventoryRepository create(Ref ref) {
    return inventoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryRepository>(value),
    );
  }
}

String _$inventoryRepositoryHash() =>
    r'0afb7a4935e1b8c6e4b5cf57589a797001187a47';

/// The active household's inventory items, newest first, kept live. Emits an
/// empty list while the user has no household.

@ProviderFor(inventoryItems)
final inventoryItemsProvider = InventoryItemsProvider._();

/// The active household's inventory items, newest first, kept live. Emits an
/// empty list while the user has no household.

final class InventoryItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InventoryItem>>,
          List<InventoryItem>,
          Stream<List<InventoryItem>>
        >
    with
        $FutureModifier<List<InventoryItem>>,
        $StreamProvider<List<InventoryItem>> {
  /// The active household's inventory items, newest first, kept live. Emits an
  /// empty list while the user has no household.
  InventoryItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryItemsHash();

  @$internal
  @override
  $StreamProviderElement<List<InventoryItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<InventoryItem>> create(Ref ref) {
    return inventoryItems(ref);
  }
}

String _$inventoryItemsHash() => r'4765a6452b570b6c6f3e380c827617c16819912a';

/// The active household's storage locations, ordered for the grid.

@ProviderFor(storageLocations)
final storageLocationsProvider = StorageLocationsProvider._();

/// The active household's storage locations, ordered for the grid.

final class StorageLocationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StorageLocation>>,
          List<StorageLocation>,
          FutureOr<List<StorageLocation>>
        >
    with
        $FutureModifier<List<StorageLocation>>,
        $FutureProvider<List<StorageLocation>> {
  /// The active household's storage locations, ordered for the grid.
  StorageLocationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageLocationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageLocationsHash();

  @$internal
  @override
  $FutureProviderElement<List<StorageLocation>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<StorageLocation>> create(Ref ref) {
    return storageLocations(ref);
  }
}

String _$storageLocationsHash() => r'eef1e78af2fce34fe2bf28003288db3d2274324c';

/// The categories visible to the active household (defaults + custom).

@ProviderFor(categories)
final categoriesProvider = CategoriesProvider._();

/// The categories visible to the active household (defaults + custom).

final class CategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>
        >
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  /// The categories visible to the active household (defaults + custom).
  CategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    return categories(ref);
  }
}

String _$categoriesHash() => r'dc5e1d9e03c908ada0ce9989261615b126bc0e97';

/// Categories keyed by id, for resolving an item's category cheaply.

@ProviderFor(categoriesById)
final categoriesByIdProvider = CategoriesByIdProvider._();

/// Categories keyed by id, for resolving an item's category cheaply.

final class CategoriesByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, Category>>,
          Map<String, Category>,
          FutureOr<Map<String, Category>>
        >
    with
        $FutureModifier<Map<String, Category>>,
        $FutureProvider<Map<String, Category>> {
  /// Categories keyed by id, for resolving an item's category cheaply.
  CategoriesByIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoriesByIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoriesByIdHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, Category>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, Category>> create(Ref ref) {
    return categoriesById(ref);
  }
}

String _$categoriesByIdHash() => r'b7e3fa175a363df5629172b8a5dfd7087e8d7f1b';

/// Storage locations keyed by id, for resolving an item's location cheaply.

@ProviderFor(storageLocationsById)
final storageLocationsByIdProvider = StorageLocationsByIdProvider._();

/// Storage locations keyed by id, for resolving an item's location cheaply.

final class StorageLocationsByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, StorageLocation>>,
          Map<String, StorageLocation>,
          FutureOr<Map<String, StorageLocation>>
        >
    with
        $FutureModifier<Map<String, StorageLocation>>,
        $FutureProvider<Map<String, StorageLocation>> {
  /// Storage locations keyed by id, for resolving an item's location cheaply.
  StorageLocationsByIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageLocationsByIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageLocationsByIdHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, StorageLocation>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, StorageLocation>> create(Ref ref) {
    return storageLocationsById(ref);
  }
}

String _$storageLocationsByIdHash() =>
    r'390540652eaada048ea79fefcb836d4486c1267a';

/// Inventory items joined with their category and location and tagged with an
/// [ExpiryStatus]. Every display provider derives from this single source.

@ProviderFor(resolvedItems)
final resolvedItemsProvider = ResolvedItemsProvider._();

/// Inventory items joined with their category and location and tagged with an
/// [ExpiryStatus]. Every display provider derives from this single source.

final class ResolvedItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ResolvedItem>>,
          List<ResolvedItem>,
          FutureOr<List<ResolvedItem>>
        >
    with
        $FutureModifier<List<ResolvedItem>>,
        $FutureProvider<List<ResolvedItem>> {
  /// Inventory items joined with their category and location and tagged with an
  /// [ExpiryStatus]. Every display provider derives from this single source.
  ResolvedItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resolvedItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resolvedItemsHash();

  @$internal
  @override
  $FutureProviderElement<List<ResolvedItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ResolvedItem>> create(Ref ref) {
    return resolvedItems(ref);
  }
}

String _$resolvedItemsHash() => r'5e8a0885840024f945953c9d3408e5055468087a';

/// Counts for the quick-stats strip.

@ProviderFor(quickStats)
final quickStatsProvider = QuickStatsProvider._();

/// Counts for the quick-stats strip.

final class QuickStatsProvider
    extends
        $FunctionalProvider<
          AsyncValue<InventoryStats>,
          InventoryStats,
          FutureOr<InventoryStats>
        >
    with $FutureModifier<InventoryStats>, $FutureProvider<InventoryStats> {
  /// Counts for the quick-stats strip.
  QuickStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quickStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quickStatsHash();

  @$internal
  @override
  $FutureProviderElement<InventoryStats> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<InventoryStats> create(Ref ref) {
    return quickStats(ref);
  }
}

String _$quickStatsHash() => r'bf02e9cc80d210e9878d5dfa47c55b1bb0cf0454';

/// Items needing attention (expiring soon or already expired), most urgent
/// first — the home tab's "expiring soon" rail.

@ProviderFor(expiringSoonItems)
final expiringSoonItemsProvider = ExpiringSoonItemsProvider._();

/// Items needing attention (expiring soon or already expired), most urgent
/// first — the home tab's "expiring soon" rail.

final class ExpiringSoonItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ResolvedItem>>,
          List<ResolvedItem>,
          FutureOr<List<ResolvedItem>>
        >
    with
        $FutureModifier<List<ResolvedItem>>,
        $FutureProvider<List<ResolvedItem>> {
  /// Items needing attention (expiring soon or already expired), most urgent
  /// first — the home tab's "expiring soon" rail.
  ExpiringSoonItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'expiringSoonItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$expiringSoonItemsHash();

  @$internal
  @override
  $FutureProviderElement<List<ResolvedItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ResolvedItem>> create(Ref ref) {
    return expiringSoonItems(ref);
  }
}

String _$expiringSoonItemsHash() => r'4f06f240bbb6a084ec80d22d535a60b1a94a8588';

/// The most recently added items (already sorted newest-first upstream).

@ProviderFor(recentlyAddedItems)
final recentlyAddedItemsProvider = RecentlyAddedItemsProvider._();

/// The most recently added items (already sorted newest-first upstream).

final class RecentlyAddedItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ResolvedItem>>,
          List<ResolvedItem>,
          FutureOr<List<ResolvedItem>>
        >
    with
        $FutureModifier<List<ResolvedItem>>,
        $FutureProvider<List<ResolvedItem>> {
  /// The most recently added items (already sorted newest-first upstream).
  RecentlyAddedItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentlyAddedItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentlyAddedItemsHash();

  @$internal
  @override
  $FutureProviderElement<List<ResolvedItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ResolvedItem>> create(Ref ref) {
    return recentlyAddedItems(ref);
  }
}

String _$recentlyAddedItemsHash() =>
    r'2fadc98350cdec53831b1c96683c7a5f64e62c02';

/// The household's soft-deleted items — the 30-day trash, newest removal first.

@ProviderFor(deletedItems)
final deletedItemsProvider = DeletedItemsProvider._();

/// The household's soft-deleted items — the 30-day trash, newest removal first.

final class DeletedItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<InventoryItem>>,
          List<InventoryItem>,
          FutureOr<List<InventoryItem>>
        >
    with
        $FutureModifier<List<InventoryItem>>,
        $FutureProvider<List<InventoryItem>> {
  /// The household's soft-deleted items — the 30-day trash, newest removal first.
  DeletedItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deletedItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deletedItemsHash();

  @$internal
  @override
  $FutureProviderElement<List<InventoryItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<InventoryItem>> create(Ref ref) {
    return deletedItems(ref);
  }
}

String _$deletedItemsHash() => r'a3b42d77e90e753c8b371b67995d7d916a178a14';

/// Trash items joined with their category and location for the trash screen.

@ProviderFor(resolvedDeletedItems)
final resolvedDeletedItemsProvider = ResolvedDeletedItemsProvider._();

/// Trash items joined with their category and location for the trash screen.

final class ResolvedDeletedItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ResolvedItem>>,
          List<ResolvedItem>,
          FutureOr<List<ResolvedItem>>
        >
    with
        $FutureModifier<List<ResolvedItem>>,
        $FutureProvider<List<ResolvedItem>> {
  /// Trash items joined with their category and location for the trash screen.
  ResolvedDeletedItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resolvedDeletedItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resolvedDeletedItemsHash();

  @$internal
  @override
  $FutureProviderElement<List<ResolvedItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ResolvedItem>> create(Ref ref) {
    return resolvedDeletedItems(ref);
  }
}

String _$resolvedDeletedItemsHash() =>
    r'22519b292520c03fa9bb39a003bdeab1aa5c6440';

/// The items stored in [locationId]. [StorageLocation.unassignedId] selects the
/// items that have no storage location.

@ProviderFor(itemsForLocation)
final itemsForLocationProvider = ItemsForLocationFamily._();

/// The items stored in [locationId]. [StorageLocation.unassignedId] selects the
/// items that have no storage location.

final class ItemsForLocationProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ResolvedItem>>,
          List<ResolvedItem>,
          FutureOr<List<ResolvedItem>>
        >
    with
        $FutureModifier<List<ResolvedItem>>,
        $FutureProvider<List<ResolvedItem>> {
  /// The items stored in [locationId]. [StorageLocation.unassignedId] selects the
  /// items that have no storage location.
  ItemsForLocationProvider._({
    required ItemsForLocationFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'itemsForLocationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$itemsForLocationHash();

  @override
  String toString() {
    return r'itemsForLocationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ResolvedItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ResolvedItem>> create(Ref ref) {
    final argument = this.argument as String;
    return itemsForLocation(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ItemsForLocationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$itemsForLocationHash() => r'376f973b9d435689e37546c72e05b5bae611b5f2';

/// The items stored in [locationId]. [StorageLocation.unassignedId] selects the
/// items that have no storage location.

final class ItemsForLocationFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ResolvedItem>>, String> {
  ItemsForLocationFamily._()
    : super(
        retry: null,
        name: r'itemsForLocationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// The items stored in [locationId]. [StorageLocation.unassignedId] selects the
  /// items that have no storage location.

  ItemsForLocationProvider call(String locationId) =>
      ItemsForLocationProvider._(argument: locationId, from: this);

  @override
  String toString() => r'itemsForLocationProvider';
}

/// Per-location counts + attention flags for the inventory grid. Items without
/// a storage location are gathered into a trailing synthetic "unassigned"
/// bucket, shown only when at least one such item exists so nothing added
/// without a location silently disappears.

@ProviderFor(locationSummaries)
final locationSummariesProvider = LocationSummariesProvider._();

/// Per-location counts + attention flags for the inventory grid. Items without
/// a storage location are gathered into a trailing synthetic "unassigned"
/// bucket, shown only when at least one such item exists so nothing added
/// without a location silently disappears.

final class LocationSummariesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LocationSummary>>,
          List<LocationSummary>,
          FutureOr<List<LocationSummary>>
        >
    with
        $FutureModifier<List<LocationSummary>>,
        $FutureProvider<List<LocationSummary>> {
  /// Per-location counts + attention flags for the inventory grid. Items without
  /// a storage location are gathered into a trailing synthetic "unassigned"
  /// bucket, shown only when at least one such item exists so nothing added
  /// without a location silently disappears.
  LocationSummariesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationSummariesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationSummariesHash();

  @$internal
  @override
  $FutureProviderElement<List<LocationSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LocationSummary>> create(Ref ref) {
    return locationSummaries(ref);
  }
}

String _$locationSummariesHash() => r'9aa9eb15227aa1ab22fc3e836e1bdc70627f34f4';

/// Drives create/edit/consume/restore for inventory items with loading/error
/// state. The item list itself refreshes through the realtime [watchItems]
/// stream, so only the trash (a one-shot load) is invalidated after a change.

@ProviderFor(InventoryItemController)
final inventoryItemControllerProvider = InventoryItemControllerProvider._();

/// Drives create/edit/consume/restore for inventory items with loading/error
/// state. The item list itself refreshes through the realtime [watchItems]
/// stream, so only the trash (a one-shot load) is invalidated after a change.
final class InventoryItemControllerProvider
    extends $AsyncNotifierProvider<InventoryItemController, void> {
  /// Drives create/edit/consume/restore for inventory items with loading/error
  /// state. The item list itself refreshes through the realtime [watchItems]
  /// stream, so only the trash (a one-shot load) is invalidated after a change.
  InventoryItemControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryItemControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryItemControllerHash();

  @$internal
  @override
  InventoryItemController create() => InventoryItemController();
}

String _$inventoryItemControllerHash() =>
    r'634802701faf6e5536a8f4074a056f0bb0d06e35';

/// Drives create/edit/consume/restore for inventory items with loading/error
/// state. The item list itself refreshes through the realtime [watchItems]
/// stream, so only the trash (a one-shot load) is invalidated after a change.

abstract class _$InventoryItemController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Drives create/rename/delete for the household's storage locations. Each
/// change invalidates [storageLocationsProvider]; the item views derive from it
/// and refresh in turn.
///
/// Kept alive: the UI only reaches it through `ref.read(...notifier)` and never
/// watches it, so an autoDispose controller would be disposed during the async
/// mutation and its post-`await` `ref.invalidate` would never fire.

@ProviderFor(StorageLocationController)
final storageLocationControllerProvider = StorageLocationControllerProvider._();

/// Drives create/rename/delete for the household's storage locations. Each
/// change invalidates [storageLocationsProvider]; the item views derive from it
/// and refresh in turn.
///
/// Kept alive: the UI only reaches it through `ref.read(...notifier)` and never
/// watches it, so an autoDispose controller would be disposed during the async
/// mutation and its post-`await` `ref.invalidate` would never fire.
final class StorageLocationControllerProvider
    extends $AsyncNotifierProvider<StorageLocationController, void> {
  /// Drives create/rename/delete for the household's storage locations. Each
  /// change invalidates [storageLocationsProvider]; the item views derive from it
  /// and refresh in turn.
  ///
  /// Kept alive: the UI only reaches it through `ref.read(...notifier)` and never
  /// watches it, so an autoDispose controller would be disposed during the async
  /// mutation and its post-`await` `ref.invalidate` would never fire.
  StorageLocationControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storageLocationControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storageLocationControllerHash();

  @$internal
  @override
  StorageLocationController create() => StorageLocationController();
}

String _$storageLocationControllerHash() =>
    r'ed435aa4a9455130fa03b9d7916b7052c6bcb6d5';

/// Drives create/rename/delete for the household's storage locations. Each
/// change invalidates [storageLocationsProvider]; the item views derive from it
/// and refresh in turn.
///
/// Kept alive: the UI only reaches it through `ref.read(...notifier)` and never
/// watches it, so an autoDispose controller would be disposed during the async
/// mutation and its post-`await` `ref.invalidate` would never fire.

abstract class _$StorageLocationController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Drives create/rename/delete for the household's custom categories (the
/// app-wide defaults are global and not editable). Each change invalidates
/// [categoriesProvider].
///
/// Kept alive for the same reason as [StorageLocationController]: nothing
/// watches it, so autoDispose would drop it mid-mutation and skip the
/// post-`await` `ref.invalidate`.

@ProviderFor(CategoryController)
final categoryControllerProvider = CategoryControllerProvider._();

/// Drives create/rename/delete for the household's custom categories (the
/// app-wide defaults are global and not editable). Each change invalidates
/// [categoriesProvider].
///
/// Kept alive for the same reason as [StorageLocationController]: nothing
/// watches it, so autoDispose would drop it mid-mutation and skip the
/// post-`await` `ref.invalidate`.
final class CategoryControllerProvider
    extends $AsyncNotifierProvider<CategoryController, void> {
  /// Drives create/rename/delete for the household's custom categories (the
  /// app-wide defaults are global and not editable). Each change invalidates
  /// [categoriesProvider].
  ///
  /// Kept alive for the same reason as [StorageLocationController]: nothing
  /// watches it, so autoDispose would drop it mid-mutation and skip the
  /// post-`await` `ref.invalidate`.
  CategoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryControllerHash();

  @$internal
  @override
  CategoryController create() => CategoryController();
}

String _$categoryControllerHash() =>
    r'21983a837372417bd9bcb97925595cf0c36b1223';

/// Drives create/rename/delete for the household's custom categories (the
/// app-wide defaults are global and not editable). Each change invalidates
/// [categoriesProvider].
///
/// Kept alive for the same reason as [StorageLocationController]: nothing
/// watches it, so autoDispose would drop it mid-mutation and skip the
/// post-`await` `ref.invalidate`.

abstract class _$CategoryController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
