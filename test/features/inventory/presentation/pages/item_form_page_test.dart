import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/food/domain/food.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/domain/household.dart';
import 'package:zaiko/features/inventory/application/inventory_providers.dart';
import 'package:zaiko/features/inventory/presentation/pages/item_form_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';
import 'package:zaiko/shared/widgets/zaiko_buttons.dart';

import '../../../household/fake_household_repository.dart';
import '../../fake_inventory_repository.dart';

void main() {
  late FakeInventoryRepository inventory;
  late FakeHouseholdRepository household;

  setUp(() {
    inventory = FakeInventoryRepository();
    household = FakeHouseholdRepository()
      ..current = Household(
        id: 'hh-1',
        name: 'Lindenhof',
        createdAt: DateTime.utc(2026),
      );
  });

  Future<void> pumpForm(WidgetTester tester, {Food? product}) async {
    await tester.binding.setSurfaceSize(const Size(500, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    addTearDown(inventory.dispose);
    addTearDown(household.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWithValue(AuthStatus.authenticated),
          householdRepositoryProvider.overrideWithValue(household),
          inventoryRepositoryProvider.overrideWithValue(inventory),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ItemFormPage(product: product),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('blocks saving with an empty name', (tester) async {
    await pumpForm(tester);

    await tester.tap(find.byType(ZaikoPrimaryButton));
    await tester.pumpAndSettle();

    expect(find.text('Please enter a name'), findsOneWidget);
    expect(inventory.addItemCalls, 0);
  });

  testWidgets('adds the item once the form is valid', (tester) async {
    await pumpForm(tester);

    await tester.enterText(find.byType(TextFormField).first, 'Brot');
    await tester.tap(find.byType(ZaikoPrimaryButton));
    await tester.pumpAndSettle();

    expect(inventory.addItemCalls, 1);
    expect(inventory.items.single.name, 'Brot');
    // A new manual item defaults to a plain count of one, no measurable size.
    expect(inventory.items.single.unit, isNull);
    expect(inventory.items.single.count, 1);
  });

  testWidgets('pre-fills quantity and unit from an Open Food Facts product', (
    tester,
  ) async {
    final product = Food.create(
      name: 'Weizenmehl',
      source: FoodSource.openFoodFacts,
    ).copyWith(packagedAmount: 500, packagedUnit: 'g');

    await pumpForm(tester, product: product);

    await tester.tap(find.byType(ZaikoPrimaryButton));
    await tester.pumpAndSettle();

    expect(inventory.addItemCalls, 1);
    // Name comes from the product; size from its package; count defaults to 1.
    expect(inventory.items.single.name, 'Weizenmehl');
    expect(inventory.items.single.quantity, 500);
    expect(inventory.items.single.unit, 'g');
    expect(inventory.items.single.count, 1);
  });

  testWidgets('stores the entered count for a multipack', (tester) async {
    final product = Food.create(
      name: 'Wasser',
      source: FoodSource.openFoodFacts,
    ).copyWith(packagedAmount: 1.5, packagedUnit: 'l');

    await pumpForm(tester, product: product);

    // Fields: name (0), size (1), count (2). Bump the count to a 6-pack.
    await tester.enterText(find.byType(TextFormField).at(2), '6');
    await tester.tap(find.byType(ZaikoPrimaryButton));
    await tester.pumpAndSettle();

    expect(inventory.items.single.count, 6);
    expect(inventory.items.single.quantity, 1.5);
    expect(inventory.items.single.unit, 'l');
  });
}
