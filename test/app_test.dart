import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/app.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/presentation/pages/login_page.dart';

import 'features/auth/fake_auth_repository.dart';

void main() {
  testWidgets('app boots and the auth guard shows the login page', (
    tester,
  ) async {
    final repository = FakeAuthRepository();
    addTearDown(repository.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const ZaikoApp(),
      ),
    );
    await tester.pumpAndSettle();

    // No session, so the top-level redirect sends the user to /login.
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
