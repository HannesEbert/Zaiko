import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/domain/household.dart';
import 'package:zaiko/features/inventory/application/inventory_providers.dart';
import 'package:zaiko/features/inventory/domain/category.dart';
import 'package:zaiko/features/shopping_list/application/shopping_providers.dart';
import 'package:zaiko/features/shopping_list/domain/shopping_item.dart';
import 'package:zaiko/features/shopping_list/domain/shopping_repository.dart';

import '../../household/fake_household_repository.dart';
import '../../inventory/fake_inventory_repository.dart';
import '../fake_shopping_repository.dart';

void main() {
  const beverageId = 'cat-bev';

  late FakeShoppingRepository shopping;
  late FakeInventoryRepository inventory;
  late FakeHouseholdRepository household;
  late ProviderContainer container;

  final now = DateTime.now();
  ShoppingItem item(
    String id, {
    String? category,
    bool checked = false,
    String? quantity,
  }) => ShoppingItem(
    id: id,
    householdId: 'hh-1',
    name: id,
    createdAt: now,
    updatedAt: now,
    quantity: quantity,
    categoryId: category,
    checked: checked,
  );

  setUp(() {
    shopping = FakeShoppingRepository();
    inventory = FakeInventoryRepository()
      ..categories = const [
        Category(id: beverageId, name: 'Getränke', color: 'blue'),
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
        shoppingRepositoryProvider.overrideWithValue(shopping),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(shopping.dispose);
    addTearDown(inventory.dispose);
    addTearDown(household.dispose);
  });

  test('shoppingItems is empty when the user has no household', () async {
    household.current = null;
    container.invalidate(currentHouseholdProvider);

    container.listen(shoppingItemsProvider, (_, _) {}, onError: (_, _) {});
    final items = await container.read(shoppingItemsProvider.future);
    expect(items, isEmpty);
  });

  test(
    'resolvedShoppingItems joins the category, open items before checked',
    () async {
      // Stream order (newest first) puts the checked item first; the resolver must
      // still surface open items ahead of checked ones.
      shopping.items = [
        item('bought', category: beverageId, checked: true),
        item('milk', category: beverageId),
      ];

      container.listen(
        resolvedShoppingItemsProvider,
        (_, _) {},
        onError: (_, _) {},
      );
      final resolved = await container.read(
        resolvedShoppingItemsProvider.future,
      );

      expect(resolved.map((r) => r.item.id), ['milk', 'bought']);
      expect(resolved.first.category?.name, 'Getränke');
    },
  );

  test('shoppingOpenCount counts only unchecked items', () async {
    shopping.items = [item('a'), item('b', checked: true), item('c')];

    container.listen(shoppingOpenCountProvider, (_, _) {}, onError: (_, _) {});
    expect(await container.read(shoppingOpenCountProvider.future), 2);
  });

  test('shoppingFilterCategories lists distinct categories present', () async {
    shopping.items = [
      item('a', category: beverageId),
      item('b', category: beverageId),
      item('c'),
    ];

    container.listen(
      shoppingFilterCategoriesProvider,
      (_, _) {},
      onError: (_, _) {},
    );
    final categories = await container.read(
      shoppingFilterCategoriesProvider.future,
    );

    expect(categories.map((c) => c.id), [beverageId]);
  });

  test('controller.add inserts an item and reports success', () async {
    // Resolve the active household so the create guard passes.
    container.listen(currentHouseholdProvider, (_, _) {}, onError: (_, _) {});
    await container.read(currentHouseholdProvider.future);

    final ok = await container
        .read(shoppingListControllerProvider.notifier)
        .add(name: 'Milk', quantity: '2 l', categoryId: beverageId);

    expect(ok, isTrue);
    expect(shopping.addItemCalls, 1);
    expect(shopping.items.single.name, 'Milk');
    expect(container.read(shoppingListControllerProvider).hasError, isFalse);
  });

  test('controller.toggle ticks an item off the list', () async {
    shopping.items = [item('milk')];

    final ok = await container
        .read(shoppingListControllerProvider.notifier)
        .toggle(id: 'milk', checked: true);

    expect(ok, isTrue);
    expect(shopping.setCheckedCalls, 1);
    expect(shopping.items.single.checked, isTrue);
  });

  test('controller.clearChecked removes only the bought items', () async {
    shopping.items = [
      item('a'),
      item('b', checked: true),
      item('c', checked: true),
    ];
    container.listen(currentHouseholdProvider, (_, _) {}, onError: (_, _) {});
    await container.read(currentHouseholdProvider.future);

    final ok = await container
        .read(shoppingListControllerProvider.notifier)
        .clearChecked();

    expect(ok, isTrue);
    expect(shopping.items.map((i) => i.id), ['a']);
  });

  test('a write failure surfaces as an error and reports failure', () async {
    container.listen(currentHouseholdProvider, (_, _) {}, onError: (_, _) {});
    await container.read(currentHouseholdProvider.future);
    shopping.writeError = const ShoppingFailure(
      ShoppingFailureReason.notMember,
      'denied',
    );

    final ok = await container
        .read(shoppingListControllerProvider.notifier)
        .add(name: 'Milk');

    expect(ok, isFalse);
    final state = container.read(shoppingListControllerProvider);
    expect(state.hasError, isTrue);
    expect(state.error, isA<ShoppingFailure>());
  });
}
