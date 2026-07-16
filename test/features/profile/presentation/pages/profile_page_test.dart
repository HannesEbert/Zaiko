import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/profile/presentation/pages/profile_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../../auth/fake_auth_repository.dart';

void main() {
  Future<void> pumpProfilePage(
    WidgetTester tester,
    FakeAuthRepository repository,
  ) async {
    // A tall surface so the whole profile (incl. the sign-out row) is on-screen.
    await tester.binding.setSurfaceSize(const Size(500, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ProfilePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('confirming the sign-out dialog signs the user out', (
    tester,
  ) async {
    final repository = FakeAuthRepository(
      initialStatus: AuthStatus.authenticated,
    );
    addTearDown(repository.dispose);
    await pumpProfilePage(tester, repository);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    // Dialog is up; confirm via its filled action button.
    await tester.tap(find.widgetWithText(FilledButton, 'Sign out'));
    await tester.pumpAndSettle();

    expect(repository.signOutCalls, 1);
  });

  testWidgets('cancelling the sign-out dialog keeps the user signed in', (
    tester,
  ) async {
    final repository = FakeAuthRepository(
      initialStatus: AuthStatus.authenticated,
    );
    addTearDown(repository.dispose);
    await pumpProfilePage(tester, repository);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(repository.signOutCalls, 0);
  });
}
