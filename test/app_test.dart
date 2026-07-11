import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/app.dart';
import 'package:zaiko/features/inventory/presentation/pages/inventory_page.dart';

void main() {
  testWidgets('app boots and shows the inventory page', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: ZaikoApp()));
    await tester.pumpAndSettle();

    expect(find.byType(InventoryPage), findsOneWidget);
  });
}
