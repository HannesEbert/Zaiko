import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/app.dart';
import 'package:zaiko/core/router/app_router.dart';
import 'package:zaiko/core/router/scaffold_with_nav_bar.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/auth/presentation/pages/login_page.dart';
import 'package:zaiko/features/household/presentation/pages/join_household_page.dart';
import 'package:zaiko/features/inventory/presentation/pages/inventory_page.dart';

import '../../features/auth/fake_auth_repository.dart';

void main() {
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
    expect(find.byType(InventoryPage), findsNothing);
  });

  testWidgets('authenticated users see the inventory shell with a nav bar', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) => AuthStatus.authenticated),
        ],
        child: const ZaikoApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ScaffoldWithNavBar), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(InventoryPage), findsOneWidget);
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
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(JoinHouseholdPage), findsOneWidget);
    expect(find.textContaining('ABC123'), findsOneWidget);
  });
}
