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
import 'package:zaiko/features/auth/presentation/pages/reset_password_page.dart';
import 'package:zaiko/features/home/presentation/pages/home_page.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/domain/household.dart';
import 'package:zaiko/features/household/presentation/pages/join_household_page.dart';
import 'package:zaiko/features/household/presentation/pages/onboarding_page.dart';
import 'package:zaiko/features/inventory/application/inventory_providers.dart';
import 'package:zaiko/features/inventory/domain/inventory_item.dart';
import 'package:zaiko/features/inventory/domain/storage_location.dart';
import 'package:zaiko/features/inventory/presentation/pages/inventory_page.dart';
import 'package:zaiko/features/inventory/presentation/pages/location_detail_page.dart';
import 'package:zaiko/features/profile/presentation/pages/profile_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../features/auth/fake_auth_repository.dart';
import '../../features/household/fake_household_repository.dart';
import '../../features/inventory/fake_inventory_repository.dart';

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

  testWidgets(
    'a returning member with a household lands on home, not onboarding, after '
    'sign-in',
    (tester) async {
      final auth = FakeAuthRepository();
      addTearDown(auth.dispose);
      // No household is loaded while signed out; sign-in must trigger the load
      // and route the member home rather than to onboarding.
      final household = FakeHouseholdRepository()..current = null;
      addTearDown(household.dispose);

      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(auth),
          householdRepositoryProvider.overrideWithValue(household),
        ],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            theme: AppTheme.dark,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: container.read(appRouterProvider),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Keep the auth chain subscribed so the fake's broadcast sign-in event is
      // observed (auto-dispose would otherwise tear it down between pumps).
      container.listen(authStateProvider, (_, _) {});

      // Signed out → login (membership is `unknown`, never a stale `none`).
      expect(find.byType(LoginPage), findsOneWidget);

      // Sign in; the account already has a household.
      household.current = Household(
        id: 'hh-1',
        name: 'Lindenhof',
        createdAt: DateTime.utc(2026),
      );
      auth.emit(AuthStatus.authenticated);
      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(OnboardingPage), findsNothing);
    },
  );

  testWidgets('an open location survives switching tabs and coming back', (
    tester,
  ) async {
    // Regression: the location detail used to be pushed imperatively on the
    // branch navigator, so leaving the inventory tab and returning dropped it
    // back to the inventory root. As a declared sub-route it must stay put.
    final household = FakeHouseholdRepository()
      ..current = Household(
        id: 'hh-1',
        name: 'Lindenhof',
        createdAt: DateTime.utc(2026),
      );
    addTearDown(household.dispose);

    final inventory = FakeInventoryRepository()
      ..locations = const [
        StorageLocation(id: 'fridge', householdId: 'hh-1', name: 'Fridge'),
      ]
      ..items = [
        InventoryItem(
          id: 'butter',
          householdId: 'hh-1',
          name: 'Butter',
          quantity: 1,
          storageLocationId: 'fridge',
          createdAt: DateTime.utc(2026),
          updatedAt: DateTime.utc(2026),
        ),
      ];
    addTearDown(inventory.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => AuthStatus.authenticated),
          householdRepositoryProvider.overrideWithValue(household),
          inventoryRepositoryProvider.overrideWithValue(inventory),
        ],
        child: const ZaikoApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Inventory tab → open the fridge location.
    await tester.tap(find.text('Inventory'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fridge'));
    await tester.pumpAndSettle();
    expect(find.byType(LocationDetailPage), findsOneWidget);
    expect(find.text('Butter'), findsOneWidget);

    // Switch to Shopping, then back to Inventory.
    await tester.tap(find.text('Shopping'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Inventory'));
    await tester.pumpAndSettle();

    // The fridge location is still open — not reset to the inventory root.
    expect(find.byType(LocationDetailPage), findsOneWidget);
    expect(find.text('Butter'), findsOneWidget);
  });

  testWidgets('re-tapping the active inventory tab returns to its root', (
    tester,
  ) async {
    final household = FakeHouseholdRepository()
      ..current = Household(
        id: 'hh-1',
        name: 'Lindenhof',
        createdAt: DateTime.utc(2026),
      );
    addTearDown(household.dispose);

    final inventory = FakeInventoryRepository()
      ..locations = const [
        StorageLocation(id: 'fridge', householdId: 'hh-1', name: 'Fridge'),
      ];
    addTearDown(inventory.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => AuthStatus.authenticated),
          householdRepositoryProvider.overrideWithValue(household),
          inventoryRepositoryProvider.overrideWithValue(inventory),
        ],
        child: const ZaikoApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Inventory'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fridge'));
    await tester.pumpAndSettle();
    expect(find.byType(LocationDetailPage), findsOneWidget);

    // Tapping the already-active tab pops the branch back to its root.
    await tester.tap(find.text('Inventory'));
    await tester.pumpAndSettle();

    expect(find.byType(LocationDetailPage), findsNothing);
    expect(find.byType(InventoryPage), findsOneWidget);
  });

  testWidgets('an active password recovery is routed to the reset screen', (
    tester,
  ) async {
    // A recovery deep link authenticates the user, but the guard must keep
    // them on the reset screen instead of bouncing to home/onboarding.
    final householdRepository = FakeHouseholdRepository();
    addTearDown(householdRepository.dispose);

    final container = ProviderContainer(
      overrides: [
        authStateProvider.overrideWithValue(AuthStatus.authenticated),
        householdRepositoryProvider.overrideWithValue(householdRepository),
        passwordRecoveryActiveProvider.overrideWith(_AlwaysRecovering.new),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          theme: AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: container.read(appRouterProvider),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ResetPasswordPage), findsOneWidget);
  });
}

/// Forces [passwordRecoveryActiveProvider] on, so the router test can assert the
/// redirect without driving the live recovery stream.
class _AlwaysRecovering extends PasswordRecoveryActive {
  @override
  bool build() => true;
}
