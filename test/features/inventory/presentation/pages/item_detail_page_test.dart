import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/inventory/application/inventory_providers.dart';
import 'package:zaiko/features/inventory/application/inventory_view.dart';
import 'package:zaiko/features/inventory/domain/expiry.dart';
import 'package:zaiko/features/inventory/domain/inventory_item.dart';
import 'package:zaiko/features/inventory/presentation/pages/item_detail_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../fake_inventory_repository.dart';

void main() {
  late FakeInventoryRepository inventory;

  ResolvedItem resolvedItem({required int count}) {
    final now = DateTime.now();
    return ResolvedItem(
      item: InventoryItem(
        id: 'milk',
        householdId: 'hh-1',
        name: 'Milch',
        quantity: 1,
        count: count,
        createdAt: now,
        updatedAt: now,
      ),
      status: ExpiryStatus.none,
    );
  }

  setUp(() => inventory = FakeInventoryRepository());

  Future<void> pumpDetail(WidgetTester tester, ResolvedItem resolved) async {
    await tester.binding.setSurfaceSize(const Size(500, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    addTearDown(inventory.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [inventoryRepositoryProvider.overrideWithValue(inventory)],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: ItemDetailPage(resolved),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('stepping the count to zero moves the item to the trash', (
    tester,
  ) async {
    inventory.items = [resolvedItem(count: 1).item];
    await pumpDetail(tester, resolvedItem(count: 1));

    // One decrement takes the count 1 -> 0, which soft-deletes the item.
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pumpAndSettle();

    expect(inventory.softDeleteCalls, 1);
    expect(inventory.deletedItems.single.id, 'milk');
  });

  testWidgets('the consumed button removes the item', (tester) async {
    inventory.items = [resolvedItem(count: 3).item];
    await pumpDetail(tester, resolvedItem(count: 3));

    await tester.tap(find.text('Mark as consumed'));
    await tester.pumpAndSettle();

    expect(inventory.softDeleteCalls, 1);
  });
}
