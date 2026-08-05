import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/domain/household.dart';
import 'package:zaiko/features/inventory/application/inventory_providers.dart';
import 'package:zaiko/features/inventory/domain/inventory_item.dart';
import 'package:zaiko/features/inventory/domain/inventory_repository.dart';

import '../../household/fake_household_repository.dart';
import '../fake_inventory_repository.dart';

void main() {
  late FakeInventoryRepository inventory;
  late FakeHouseholdRepository household;
  late ProviderContainer container;

  InventoryItem seedItem(String id, {num quantity = 1}) {
    final now = DateTime.now();
    return InventoryItem(
      id: id,
      householdId: 'hh-1',
      name: id,
      quantity: quantity,
      createdAt: now,
      updatedAt: now,
    );
  }

  setUp(() {
    inventory = FakeInventoryRepository();
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

  // Resolve the current household so the controllers can read its id, keeping
  // it alive with a listener.
  Future<void> warmUp() async {
    container.listen(currentHouseholdProvider, (_, _) {}, onError: (_, _) {});
    await container.read(currentHouseholdProvider.future);
  }

  group('InventoryItemController', () {
    Future<InventoryItemController> ready() async {
      container.listen(
        inventoryItemControllerProvider,
        (_, _) {},
        onError: (_, _) {},
      );
      await warmUp();
      await container.read(inventoryItemControllerProvider.future);
      return container.read(inventoryItemControllerProvider.notifier);
    }

    test('add inserts an item into the active household', () async {
      final controller = await ready();

      final ok = await controller.add(
        name: 'Milch',
        quantity: 2,
        count: 1,
        unit: 'l',
        categoryId: 'cat-1',
        storageLocationId: 'loc-1',
      );

      expect(ok, isTrue);
      expect(inventory.addItemCalls, 1);
      expect(inventory.items.single.name, 'Milch');
      expect(inventory.items.single.householdId, 'hh-1');
    });

    test('setCount above zero updates and keeps the item', () async {
      inventory.items = [seedItem('x')];
      final controller = await ready();

      final ok = await controller.setCount(id: 'x', count: 3);

      expect(ok, isTrue);
      expect(inventory.setCountCalls, 1);
      expect(inventory.softDeleteCalls, 0);
      expect(inventory.items.single.count, 3);
    });

    test('setCount of zero moves the item to the trash', () async {
      inventory.items = [seedItem('x')];
      final controller = await ready();

      final ok = await controller.setCount(id: 'x', count: 0);

      expect(ok, isTrue);
      expect(inventory.softDeleteCalls, 1);
      expect(inventory.setCountCalls, 0);
      expect(inventory.items, isEmpty);
      expect(inventory.deletedItems.single.id, 'x');
    });

    test('consume soft-deletes the item into the trash', () async {
      inventory.items = [seedItem('x')];
      final controller = await ready();

      final ok = await controller.consume('x');

      expect(ok, isTrue);
      expect(inventory.softDeleteCalls, 1);
      expect(inventory.deletedItems.single.id, 'x');
    });

    test('restore brings a trashed item back into the inventory', () async {
      inventory.deletedItems = [seedItem('x')];
      final controller = await ready();

      final ok = await controller.restore('x');

      expect(ok, isTrue);
      expect(inventory.restoreCalls, 1);
      expect(inventory.items.single.id, 'x');
      expect(inventory.deletedItems, isEmpty);
    });

    test('a write failure returns false and records the error', () async {
      inventory.writeError = const InventoryFailure(
        InventoryFailureReason.unknown,
        'boom',
      );
      final controller = await ready();

      final ok = await controller.add(name: 'Milch', quantity: 1, count: 1);

      expect(ok, isFalse);
      expect(
        container.read(inventoryItemControllerProvider),
        isA<AsyncError<void>>(),
      );
    });
  });

  group('StorageLocationController', () {
    Future<StorageLocationController> ready() async {
      container.listen(
        storageLocationControllerProvider,
        (_, _) {},
        onError: (_, _) {},
      );
      await warmUp();
      await container.read(storageLocationControllerProvider.future);
      return container.read(storageLocationControllerProvider.notifier);
    }

    test('add returns the created id', () async {
      final controller = await ready();

      final id = await controller.add(name: 'Keller', color: 'blue');

      expect(id, isNotNull);
      expect(inventory.addLocationCalls, 1);
      expect(inventory.locations.single.name, 'Keller');
    });

    test('save renames the location', () async {
      final controller = await ready();
      final id = await controller.add(name: 'Keller');

      final ok = await controller.save(id: id!, name: 'Vorratskeller');

      expect(ok, isTrue);
      expect(inventory.updateLocationCalls, 1);
      expect(inventory.locations.single.name, 'Vorratskeller');
    });

    test('delete removes the location', () async {
      final controller = await ready();
      final id = await controller.add(name: 'Keller');

      final ok = await controller.delete(id!);

      expect(ok, isTrue);
      expect(inventory.deleteLocationCalls, 1);
      expect(inventory.locations, isEmpty);
    });

    test('add returns null on failure', () async {
      inventory.writeError = const InventoryFailure(
        InventoryFailureReason.unknown,
        'boom',
      );
      final controller = await ready();

      final id = await controller.add(name: 'Keller');

      expect(id, isNull);
    });
  });

  group('CategoryController', () {
    Future<CategoryController> ready() async {
      container.listen(
        categoryControllerProvider,
        (_, _) {},
        onError: (_, _) {},
      );
      await warmUp();
      await container.read(categoryControllerProvider.future);
      return container.read(categoryControllerProvider.notifier);
    }

    test('add creates a custom category and returns its id', () async {
      final controller = await ready();

      final id = await controller.add(name: 'Asiatisch', color: 'lime');

      expect(id, isNotNull);
      expect(inventory.addCategoryCalls, 1);
      expect(inventory.categories.single.name, 'Asiatisch');
      expect(inventory.categories.single.householdId, 'hh-1');
    });

    test('save renames the category', () async {
      final controller = await ready();
      final id = await controller.add(name: 'Asiatisch');

      final ok = await controller.save(id: id!, name: 'Asia-Küche');

      expect(ok, isTrue);
      expect(inventory.categories.single.name, 'Asia-Küche');
    });

    test('delete removes the category', () async {
      final controller = await ready();
      final id = await controller.add(name: 'Asiatisch');

      final ok = await controller.delete(id!);

      expect(ok, isTrue);
      expect(inventory.categories, isEmpty);
    });
  });

  // Reproduces the real UI: the manage screens and pickers watch the *list*
  // provider but only `ref.read` the controller. The list is kept alive and
  // cached here while the controller is not, so a stale list can only refresh
  // if the controller survives its own async mutation to run `ref.invalidate`.
  // These fail if the controllers are autoDispose.
  group(
    'taxonomy mutations refresh their list without a controller listener',
    () {
      test('creating a storage location refreshes the list', () async {
        await warmUp();
        container.listen(
          storageLocationsProvider,
          (_, _) {},
          onError: (_, _) {},
        );
        expect(await container.read(storageLocationsProvider.future), isEmpty);

        final id = await container
            .read(storageLocationControllerProvider.notifier)
            .add(name: 'Keller');

        final locations = await container.read(storageLocationsProvider.future);
        expect(locations.map((l) => l.id), contains(id));
      });

      test('deleting a storage location refreshes the list', () async {
        await warmUp();
        final id = await container
            .read(storageLocationControllerProvider.notifier)
            .add(name: 'Keller');
        container.listen(
          storageLocationsProvider,
          (_, _) {},
          onError: (_, _) {},
        );
        expect(
          (await container.read(
            storageLocationsProvider.future,
          )).map((l) => l.id),
          contains(id),
        );

        await container
            .read(storageLocationControllerProvider.notifier)
            .delete(id!);

        expect(await container.read(storageLocationsProvider.future), isEmpty);
      });

      test('creating a category refreshes the list', () async {
        await warmUp();
        container.listen(categoriesProvider, (_, _) {}, onError: (_, _) {});
        expect(await container.read(categoriesProvider.future), isEmpty);

        final id = await container
            .read(categoryControllerProvider.notifier)
            .add(name: 'Asiatisch');

        final categories = await container.read(categoriesProvider.future);
        expect(categories.map((c) => c.id), contains(id));
      });
    },
  );
}
