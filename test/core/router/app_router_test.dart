import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/app.dart';
import 'package:zaiko/core/router/app_router.dart';
import 'package:zaiko/core/router/scaffold_with_nav_bar.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/auth/presentation/pages/login_page.dart';
import 'package:zaiko/features/home/presentation/pages/home_page.dart';
import 'package:zaiko/features/household/presentation/pages/join_household_page.dart';
import 'package:zaiko/features/inventory/presentation/pages/inventory_page.dart';
import 'package:zaiko/features/profile/presentation/pages/profile_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../features/auth/fake_auth_repository.dart';

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

    // The bottom bar exposes all five main tabs, with Home selected.
    final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
    expect(navBar.destinations.length, 5);
    expect(navBar.selectedIndex, 0);
  });

  testWidgets('tapping a nav destination switches the active branch', (
    tester,
  ) async {
    await pumpAuthedApp(tester);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.byType(ProfilePage), findsOneWidget);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      4,
    );

    await tester.tap(find.text('Inventory'));
    await tester.pumpAndSettle();

    expect(find.byType(InventoryPage), findsOneWidget);
    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      1,
    );
  });

  testWidgets('the join deep link renders its page and connection code', (
    tester,
  ) async {
    // The join route is public, so auth is irrelevant here; pin a constant
    // status to keep this focused on deep-link routing.
    final container = ProviderContainer(
      overrides: [
        authStateProvider.overrideWithValue(AuthStatus.unauthenticated),
      ],
    );
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider)
      ..go(JoinHouseholdPage.location('ABC123'));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(JoinHouseholdPage), findsOneWidget);
    expect(find.textContaining('ABC123'), findsOneWidget);
  });
}
