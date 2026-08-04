import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/domain/household.dart';
import 'package:zaiko/features/inventory/application/inventory_providers.dart';
import 'package:zaiko/features/inventory/domain/category.dart';
import 'package:zaiko/features/inventory/domain/inventory_item.dart';
import 'package:zaiko/features/inventory/domain/storage_location.dart';
import 'package:zaiko/features/inventory/presentation/pages/inventory_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../../household/fake_household_repository.dart';
import '../../fake_inventory_repository.dart';

void main() {
  late FakeInventoryRepository inventory;
  late FakeHouseholdRepository household;

  setUp(() {
    final now = DateTime.now();
    inventory = FakeInventoryRepository()
      ..locations = const [
        StorageLocation(id: 'fridge', householdId: 'hh-1', name: 'Kühlschrank'),
      ]
      ..categories = const [
        Category(id: 'dairy', name: 'Milchprodukte', color: 'amber'),
      ]
      ..items = [
        InventoryItem(
          id: 'milk',
          householdId: 'hh-1',
          name: 'Milch',
          quantity: 1,
          unit: 'l',
          categoryId: 'dairy',
          storageLocationId: 'fridge',
          bestBefore: now.add(const Duration(days: 2)),
          createdAt: now,
          updatedAt: now,
        ),
      ];
    household = FakeHouseholdRepository()
      ..current = Household(
        id: 'hh-1',
        name: 'Lindenhof',
        createdAt: DateTime.utc(2026),
      );
  });

  Future<void> pumpInventoryPage(WidgetTester tester) async {
    // A tall surface so the full page renders (the ListView builds its
    // children lazily, so off-screen sections would otherwise be absent).
    await tester.binding.setSurfaceSize(const Size(500, 1600));
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
          home: const InventoryPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders the inventory overview with real data', (tester) async {
    await pumpInventoryPage(tester);

    // Storage-location grid, quick stats and the recently-added item.
    expect(find.text('Kühlschrank'), findsWidgets);
    expect(find.text('RECENTLY ADDED'), findsOneWidget);
    expect(find.text('Milch'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('the FAB opens the add-item sheet', (tester) async {
    await pumpInventoryPage(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Scan barcode'), findsOneWidget);
    expect(find.text('Enter manually'), findsOneWidget);
  });
}
