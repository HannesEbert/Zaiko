import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/profile/application/profile_providers.dart';
import 'package:zaiko/features/profile/domain/profile.dart';
import 'package:zaiko/features/profile/presentation/pages/profile_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../../auth/fake_auth_repository.dart';
import '../../../household/fake_household_repository.dart';
import '../../fake_profile_repository.dart';

void main() {
  late FakeProfileRepository profiles;
  late FakeHouseholdRepository household;

  setUp(() {
    profiles = FakeProfileRepository();
    household = FakeHouseholdRepository()..current = null;
  });

  Future<void> pumpProfilePage(
    WidgetTester tester,
    FakeAuthRepository auth,
  ) async {
    // A tall surface so the whole profile (incl. the sign-out row) is on-screen.
    await tester.binding.setSurfaceSize(const Size(500, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    addTearDown(household.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          profileRepositoryProvider.overrideWithValue(profiles),
          householdRepositoryProvider.overrideWithValue(household),
        ],
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

  testWidgets('account card shows the profile name and email', (tester) async {
    profiles
      ..profile = Profile(
        id: 'user-1',
        displayName: 'Hannes',
        createdAt: DateTime.utc(2026),
      )
      ..currentUserEmail = 'hannes@example.com';
    final auth = FakeAuthRepository(initialStatus: AuthStatus.authenticated);
    addTearDown(auth.dispose);

    await pumpProfilePage(tester, auth);

    expect(find.text('Hannes'), findsOneWidget);
    expect(find.text('hannes@example.com'), findsOneWidget);
  });

  testWidgets('confirming the sign-out dialog signs the user out', (
    tester,
  ) async {
    final auth = FakeAuthRepository(initialStatus: AuthStatus.authenticated);
    addTearDown(auth.dispose);
    await pumpProfilePage(tester, auth);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    // Dialog is up; confirm via its filled action button.
    await tester.tap(find.widgetWithText(FilledButton, 'Sign out'));
    await tester.pumpAndSettle();

    expect(auth.signOutCalls, 1);
  });

  testWidgets('cancelling the sign-out dialog keeps the user signed in', (
    tester,
  ) async {
    final auth = FakeAuthRepository(initialStatus: AuthStatus.authenticated);
    addTearDown(auth.dispose);
    await pumpProfilePage(tester, auth);

    await tester.tap(find.text('Sign out'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();

    expect(auth.signOutCalls, 0);
  });
}
