import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/inventory/presentation/pages/inventory_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

void main() {
  Future<void> pumpInventoryPage(WidgetTester tester) async {
    // A tall surface so the full page renders (the ListView builds its
    // children lazily, so off-screen sections would otherwise be absent).
    await tester.binding.setSurfaceSize(const Size(500, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const InventoryPage(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders the inventory overview with storage locations', (
    tester,
  ) async {
    await pumpInventoryPage(tester);

    // Storage-location grid and the "recently added" section are present
    // (section labels are rendered upper-cased).
    expect(find.text('Kühlschrank'), findsOneWidget);
    expect(find.text('RECENTLY ADDED'), findsOneWidget);
    // The FAB opens the add-item flow.
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
