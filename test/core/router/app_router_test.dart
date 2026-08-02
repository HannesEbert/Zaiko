import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/app.dart';
import 'package:zaiko/core/router/app_router.dart';
import 'package:zaiko/core/router/scaffold_with_nav_bar.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/auth/presentation/pages/login_page.dart';
import 'package:zaiko/features/home/presentation/pages/home_page.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/presentation/pages/join_household_page.dart';
import 'package:zaiko/features/inventory/presentation/pages/inventory_page.dart';
import 'package:zaiko/features/profile/presentation/pages/profile_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../features/auth/fake_auth_repository.dart';
import '../../features/household/fake_household_repository.dart';

void main() {
  /// Boots the full app with a signed-in session so the shell is shown.
  Future<void> pumpAuthedApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => AuthStatus.authenticated),
        ],
        child: const ZaikoApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('unauthenticated users are redirected to the login page', (
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

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
  });

  testWidgets('authenticated users land on the home tab within the shell', (
    tester,
  ) async {
    await pumpAuthedApp(tester);

    expect(find.byType(ScaffoldWithNavBar), findsOneWidget);
    expect(find.byType(HomePage), findsOneWidget);

    // The custom bottom bar exposes all five main tab labels.
    for (final label in [
      'Home',
      'Inventory',
      'Shopping',
      'Recipes',
      'Profile',
    ]) {
      expect(find.text(label), findsOneWidget);
    }
  });

  testWidgets('the bottom nav bar stays at the bottom, not over the page', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpAuthedApp(tester);

    // Regression: a `Center` in the nav item expanded to the loose height the
    // Scaffold offers its bottom bar, so the bar filled the screen and
    // vertically centred the labels over every page. The labels must sit in
    // the bottom slice of the viewport instead.
    expect(tester.getCenter(find.text('Home')).dy, greaterThan(700));
  });

  testWidgets('tapping a nav destination switches the active branch', (
    tester,
  ) async {
    await pumpAuthedApp(tester);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);

    await tester.tap(find.text('Inventory'));
    await tester.pumpAndSettle();

    expect(find.byType(InventoryPage), findsOneWidget);
  });

  /// Pumps the router at the `/join/ABC123` deep link for the given auth status,
  /// with the household repository faked so tests never touch Supabase.
  Future<void> pumpJoinDeepLink(
    WidgetTester tester, {
    required AuthStatus status,
    required FakeHouseholdRepository repository,
  }) async {
    final container = ProviderContainer(
      overrides: [
        authStateProvider.overrideWithValue(status),
        householdRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider)
      ..go(JoinHouseholdPage.location('ABC123'));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          theme: AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('the join deep link prompts a signed-out visitor to sign in', (
    tester,
  ) async {
    final repository = FakeHouseholdRepository();
    addTearDown(repository.dispose);

    await pumpJoinDeepLink(
      tester,
      status: AuthStatus.unauthenticated,
      repository: repository,
    );

    // The invite link is public, so it renders rather than bouncing to login.
    expect(find.byType(JoinHouseholdPage), findsOneWidget);
    expect(find.text('Sign in & join'), findsOneWidget);
  });

  testWidgets('the join deep link shows the code when the user can join', (
    tester,
  ) async {
    // A signed-in user without a household (fake returns none) may accept.
    final repository = FakeHouseholdRepository();
    addTearDown(repository.dispose);

    await pumpJoinDeepLink(
      tester,
      status: AuthStatus.authenticated,
      repository: repository,
    );

    expect(find.byType(JoinHouseholdPage), findsOneWidget);
    expect(find.textContaining('ABC123'), findsOneWidget);
  });
}
