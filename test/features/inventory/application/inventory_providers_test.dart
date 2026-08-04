import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/domain/household.dart';
import 'package:zaiko/features/inventory/application/inventory_providers.dart';
import 'package:zaiko/features/inventory/domain/category.dart';
import 'package:zaiko/features/inventory/domain/expiry.dart';
import 'package:zaiko/features/inventory/domain/inventory_item.dart';
import 'package:zaiko/features/inventory/domain/inventory_repository.dart';
import 'package:zaiko/features/inventory/domain/storage_location.dart';

import '../../household/fake_household_repository.dart';
import '../fake_inventory_repository.dart';

void main() {
  const fridgeId = 'loc-fridge';
  const pantryId = 'loc-pantry';
  const dairyId = 'cat-dairy';

  late FakeInventoryRepository inventory;
  late FakeHouseholdRepository household;
  late ProviderContainer container;

  // Dates are relative to now so the derived expiry status is deterministic.
  final now = DateTime.now();
  InventoryItem item(
    String id, {
    required String? location,
    String? category,
    DateTime? bestBefore,
    int daysCreatedAgo = 0,
  }) => InventoryItem(
    id: id,
    householdId: 'hh-1',
    name: id,
    quantity: 1,
    createdAt: now.subtract(Duration(days: daysCreatedAgo)),
    updatedAt: now,
    categoryId: category,
    storageLocationId: location,
    bestBefore: bestBefore,
  );

  setUp(() {
    inventory = FakeInventoryRepository()
      ..locations = const [
        StorageLocation(id: fridgeId, householdId: 'hh-1', name: 'Kühlschrank'),
        StorageLocation(id: pantryId, householdId: 'hh-1', name: 'Vorrat'),
      ]
      ..categories = const [
        Category(id: dairyId, name: 'Milchprodukte', color: 'amber'),
      ]
      ..items = [
        item(
          'soon-fridge',
          location: fridgeId,
          category: dairyId,
          bestBefore: now.add(const Duration(days: 2)),
          daysCreatedAgo: 0,
        ),
        item(
          'fresh-fridge',
          location: fridgeId,
          category: dairyId,
          bestBefore: now.add(const Duration(days: 10)),
          daysCreatedAgo: 1,
        ),
        item(
          'expired-pantry',
          location: pantryId,
          bestBefore: now.subtract(const Duration(days: 1)),
          daysCreatedAgo: 2,
        ),
        item('nodate-fridge', location: fridgeId, daysCreatedAgo: 3),
      ];

    household = FakeHouseholdRepository()
      ..current = Household(
        id: 'hh-1',
        name: 'Lindenhof',
        createdAt: DateTime.utc(2026),
      );

    container = ProviderContainer(
      overrides: [
        authStateProvider.overrideWithValue(AuthStatus.authenticated),
        householdRepositoryProvider.overrideWithValue(household),
        inventoryRepositoryProvider.overrideWithValue(inventory),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(inventory.dispose);
    addTearDown(household.dispose);
  });

  test('inventoryItems is empty when the user has no household', () async {
    household.current = null;
    container.invalidate(currentHouseholdProvider);

    container.listen(inventoryItemsProvider, (_, _) {}, onError: (_, _) {});
    final items = await container.read(inventoryItemsProvider.future);
    expect(items, isEmpty);
  });

  test(
    'quickStats counts soon, expired and fresh (incl. no-date) items',
    () async {
      container.listen(quickStatsProvider, (_, _) {}, onError: (_, _) {});
      final stats = await container.read(quickStatsProvider.future);

      expect(stats.total, 4);
      expect(stats.soon, 1);
      expect(stats.expired, 1);
      // fresh = total - soon - expired, so the no-date item counts as fresh.
      expect(stats.fresh, 2);
    },
  );

  test(
    'itemsForLocation returns only that location (fridge, not pantry)',
    () async {
      container.listen(
        itemsForLocationProvider(fridgeId),
        (_, _) {},
        onError: (_, _) {},
      );
      container.listen(
        itemsForLocationProvider(pantryId),
        (_, _) {},
        onError: (_, _) {},
      );
      final fridge = await container.read(
        itemsForLocationProvider(fridgeId).future,
      );
      final pantry = await container.read(
        itemsForLocationProvider(pantryId).future,
      );

      expect(
        fridge.map((r) => r.item.id),
        containsAll(['soon-fridge', 'fresh-fridge', 'nodate-fridge']),
      );
      expect(fridge.any((r) => r.item.id == 'expired-pantry'), isFalse);
      expect(pantry.map((r) => r.item.id), ['expired-pantry']);
    },
  );

  test('expiringSoonItems includes expired, most urgent first', () async {
    container.listen(expiringSoonItemsProvider, (_, _) {}, onError: (_, _) {});
    final urgent = await container.read(expiringSoonItemsProvider.future);

    // Overdue item sorts before the upcoming one; the fresh/no-date items are
    // excluded.
    expect(urgent.map((r) => r.item.id), ['expired-pantry', 'soon-fridge']);
  });

  test(
    'recentlyAddedItems keeps only the last three days, newest first',
    () async {
      inventory.items = [
        item('today', location: fridgeId, daysCreatedAgo: 0),
        item('two-days', location: fridgeId, daysCreatedAgo: 2),
        item('long-ago', location: pantryId, daysCreatedAgo: 10),
      ];

      container.listen(
        recentlyAddedItemsProvider,
        (_, _) {},
        onError: (_, _) {},
      );
      final recent = await container.read(recentlyAddedItemsProvider.future);

      // The 10-day-old item falls outside the window; the rest are newest-first.
      expect(recent.map((r) => r.item.id), ['today', 'two-days']);
    },
  );

  test(
    'resolvedItems joins the category and location and computes status',
    () async {
      container.listen(resolvedItemsProvider, (_, _) {}, onError: (_, _) {});
      final resolved = await container.read(resolvedItemsProvider.future);
      final soon = resolved.firstWhere((r) => r.item.id == 'soon-fridge');

      expect(soon.category?.name, 'Milchprodukte');
      expect(soon.location?.name, 'Kühlschrank');
      expect(soon.status, ExpiryStatus.soon);
    },
  );

  test(
    'locationSummaries carries per-location counts and attention flags',
    () async {
      container.listen(
        locationSummariesProvider,
        (_, _) {},
        onError: (_, _) {},
      );
      final summaries = await container.read(locationSummariesProvider.future);
      final fridge = summaries.firstWhere((s) => s.location.id == fridgeId);
      final pantry = summaries.firstWhere((s) => s.location.id == pantryId);

      expect(fridge.itemCount, 3);
      expect(fridge.soonCount, 1);
      expect(fridge.expiredCount, 0);

      expect(pantry.itemCount, 1);
      expect(pantry.expiredCount, 1);
    },
  );

  test('locationSummaries omits the unassigned bucket when every item has a '
      'location', () async {
    container.listen(locationSummariesProvider, (_, _) {}, onError: (_, _) {});
    final summaries = await container.read(locationSummariesProvider.future);

    expect(
      summaries.any((s) => s.location.id == StorageLocation.unassignedId),
      isFalse,
    );
  });

  test('locationSummaries gathers items without a location into a trailing '
      'unassigned bucket', () async {
    inventory.items = [
      ...inventory.items,
      item(
        'loose-soon',
        location: null,
        bestBefore: now.add(const Duration(days: 2)),
      ),
      item('loose-nodate', location: null),
    ];

    container.listen(locationSummariesProvider, (_, _) {}, onError: (_, _) {});
    final summaries = await container.read(locationSummariesProvider.future);
    final unassigned = summaries.last;

    expect(unassigned.location.id, StorageLocation.unassignedId);
    expect(unassigned.itemCount, 2);
    expect(unassigned.soonCount, 1);
  });

  test('itemsForLocation with the unassigned id returns only items without a '
      'location', () async {
    inventory.items = [...inventory.items, item('loose', location: null)];

    container.listen(
      itemsForLocationProvider(StorageLocation.unassignedId),
      (_, _) {},
      onError: (_, _) {},
    );
    final loose = await container.read(
      itemsForLocationProvider(StorageLocation.unassignedId).future,
    );

    expect(loose.map((r) => r.item.id), ['loose']);
  });

  test(
    'a storage-locations load failure surfaces as an InventoryFailure',
    () async {
      inventory.locationsError = const InventoryFailure(
        InventoryFailureReason.unknown,
        'boom',
      );

      // Capture the error from the provider's state transition rather than its
      // `.future`, which can race autoDispose in this Riverpod version.
      final error = Completer<Object?>();
      container.listen<AsyncValue<List<StorageLocation>>>(
        storageLocationsProvider,
        (_, next) {
          if (next.hasError && !error.isCompleted) {
            error.complete(next.error);
          }
        },
        onError: (e, _) {
          if (!error.isCompleted) error.complete(e);
        },
      );

      expect(await error.future, isA<InventoryFailure>());
    },
  );
}
