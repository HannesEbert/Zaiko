import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_providers.dart';
import '../../features/auth/domain/auth_status.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/household/presentation/pages/join_household_page.dart';
import '../../features/inventory/presentation/pages/inventory_page.dart';
import '../../features/recipes/presentation/pages/recipes_page.dart';
import '../../features/shopping_list/presentation/pages/shopping_list_page.dart';
import 'scaffold_with_nav_bar.dart';

/// Central route table, exposed as a provider so the [GoRouter.redirect] auth
/// guard can read app state (currently [authStateProvider]).
///
/// Each page owns its `routePath`/`routeName` constants; the router only wires
/// them together, so route strings are never duplicated (see ADR-0005). The
/// three main tabs live inside a [StatefulShellRoute] so each keeps its own
/// navigation stack; `/login` and `/join/:code` sit outside the shell.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: InventoryPage.routePath,
    redirect: (context, state) {
      final status = ref.read(authStateProvider);
      final location = state.matchedLocation;
      final isLoggingIn = location == LoginPage.routePath;
      // Invite links must be reachable before a user has signed in.
      final isPublic =
          isLoggingIn || location.startsWith(JoinHouseholdPage.pathPrefix);

      if (status == AuthStatus.unauthenticated && !isPublic) {
        return LoginPage.routePath;
      }
      if (status == AuthStatus.authenticated && isLoggingIn) {
        return InventoryPage.routePath;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: LoginPage.routePath,
        name: LoginPage.routeName,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: JoinHouseholdPage.routePath,
        name: JoinHouseholdPage.routeName,
        builder: (context, state) => JoinHouseholdPage(
          connectionCode: state.pathParameters['code'] ?? '',
        ),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: InventoryPage.routePath,
                name: InventoryPage.routeName,
                builder: (context, state) => const InventoryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ShoppingListPage.routePath,
                name: ShoppingListPage.routeName,
                builder: (context, state) => const ShoppingListPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RecipesPage.routePath,
                name: RecipesPage.routeName,
                builder: (context, state) => const RecipesPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
