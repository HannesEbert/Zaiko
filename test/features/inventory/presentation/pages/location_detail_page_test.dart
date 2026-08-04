import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/domain/household.dart';
import 'package:zaiko/features/inventory/application/inventory_providers.dart';
import 'package:zaiko/features/inventory/domain/inventory_item.dart';
import 'package:zaiko/features/inventory/domain/storage_location.dart';
import 'package:zaiko/features/inventory/presentation/pages/location_detail_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../../household/fake_household_repository.dart';
import '../../fake_inventory_repository.dart';

void main() {
  const fridge = StorageLocation(
    id: 'fridge',
    householdId: 'hh-1',
    name: 'Kühlschrank',
  );
  const pantry = StorageLocation(
    id: 'pantry',
    householdId: 'hh-1',
    name: 'Vorrat',
  );

  late FakeInventoryRepository inventory;
  late FakeHouseholdRepository household;

  setUp(() {
    final now = DateTime.now();
    InventoryItem item(String id, String location) => InventoryItem(
      id: id,
      householdId: 'hh-1',
      name: id,
      quantity: 1,
      storageLocationId: location,
      createdAt: now,
      updatedAt: now,
    );

    inventory = FakeInventoryRepository()
      ..locations = const [fridge, pantry]
      ..items = [item('Butter', 'fridge'), item('Reis', 'pantry')];
    household = FakeHouseholdRepository()
      ..current = Household(
        id: 'hh-1',
        name: 'Lindenhof',
        createdAt: DateTime.utc(2026),
      );
  });

  testWidgets(
    'shows only the tapped location\'s items, not the fridge always',
    (tester) async {
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
            home: const LocationDetailPage(location: pantry),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The pantry screen shows the pantry item and not the fridge item — the
      // regression this epic fixes.
      expect(find.text('Reis'), findsOneWidget);
      expect(find.text('Butter'), findsNothing);
    },
  );
}
