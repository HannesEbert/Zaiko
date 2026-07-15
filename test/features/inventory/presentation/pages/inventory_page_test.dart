import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/inventory/presentation/pages/inventory_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';
import 'package:zaiko/shared/widgets/empty_state.dart';

void main() {
  testWidgets('shows an empty state while the inventory has no items', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const InventoryPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('Your inventory is empty'), findsOneWidget);
  });
}
