import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/app.dart';
import 'package:zaiko/features/auth/presentation/pages/login_page.dart';

void main() {
  testWidgets('app boots and the auth guard shows the login page', (
    tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: ZaikoApp()));
    await tester.pumpAndSettle();

    // The placeholder auth state is unauthenticated, so the top-level redirect
    // sends the user to /login.
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
