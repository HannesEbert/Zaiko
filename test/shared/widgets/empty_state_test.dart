import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/shared/widgets/empty_state.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders icon, title and message', (tester) async {
    await tester.pumpWidget(
      wrap(
        const EmptyState(
          icon: Icons.inbox_outlined,
          title: 'Nothing here',
          message: 'Add something to get started.',
        ),
      ),
    );

    expect(find.byIcon(Icons.inbox_outlined), findsOneWidget);
    expect(find.text('Nothing here'), findsOneWidget);
    expect(find.text('Add something to get started.'), findsOneWidget);
  });

  testWidgets('omits the message when none is given', (tester) async {
    await tester.pumpWidget(
      wrap(const EmptyState(icon: Icons.inbox_outlined, title: 'Empty')),
    );

    expect(find.text('Empty'), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
  });
}
