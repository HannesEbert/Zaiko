import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/application/auth_providers.dart';
import '../../features/auth/domain/auth_status.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/household/application/households_providers.dart';
import '../../features/household/presentation/pages/join_household_page.dart';
import '../../features/household/presentation/pages/onboarding_page.dart';
import '../../features/inventory/presentation/pages/inventory_page.dart';
import '../../features/profile/presentation/pages/help_page.dart';
import '../../features/profile/presentation/pages/household_link_page.dart';
import '../../features/profile/presentation/pages/personal_data_page.dart';
import '../../features/profile/presentation/pages/privacy_page.dart';
import '../../features/profile/presentation/pages/profile_edit_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/reminders_page.dart';
import '../../features/profile/presentation/pages/settings_page.dart';
import '../../features/recipes/presentation/pages/recipes_page.dart';
import '../../features/shopping_list/presentation/pages/shopping_list_page.dart';
import 'scaffold_with_nav_bar.dart';

/// Central route table, exposed as a provider so the [GoRouter.redirect] auth
/// guard can read app state (currently [authStateProvider]).
///
/// Each page owns its `routePath`/`routeName` constants; the router only wires
/// them together, so route strings are never duplicated (see ADR-0005). The
/// five main tabs live inside a [StatefulShellRoute] so each keeps its own
/// navigation stack; the profile tab nests its detail pages as sub-routes, and
/// `/login` and `/join/:code` sit outside the shell.
final appRouterProvider = Provider<GoRouter>((ref) {
  // Bridge the auth and household providers to Listenables so go_router re-runs
  // `redirect` on sign-in/sign-out and on gaining/leaving a household, without
  // rebuilding the router (which would drop the navigation stack).
  final authListenable = ValueNotifier<AuthStatus>(ref.read(authStateProvider));
  // The household load is gated on auth (see [currentHouseholdProvider]), so it
  // refetches on sign-in on its own — the router only re-runs `redirect`.
  ref.listen(authStateProvider, (_, next) => authListenable.value = next);
  final householdListenable = ValueNotifier<HouseholdMembership>(
    ref.read(householdMembershipProvider),
  );
  ref.listen(
    householdMembershipProvider,
    (_, next) => householdListenable.value = next,
  );
  final recoveryListenable = ValueNotifier<bool>(
    ref.read(passwordRecoveryActiveProvider),
  );
  ref.listen(
    passwordRecoveryActiveProvider,
    (_, next) => recoveryListenable.value = next,
  );
  ref.onDispose(() {
    authListenable.dispose();
    householdListenable.dispose();
    recoveryListenable.dispose();
  });

  return GoRouter(
    initialLocation: HomePage.routePath,
    refreshListenable: Listenable.merge([
      authListenable,
      householdListenable,
      recoveryListenable,
    ]),
    redirect: (context, state) {
      final status = ref.read(authStateProvider);
      final location = state.matchedLocation;

      // A recovery deep link creates a session, so the user is authenticated —
      // keep them on the reset screen instead of bouncing to home/onboarding
      // until the new password is saved (which clears this flag).
      if (ref.read(passwordRecoveryActiveProvider)) {
        return location == ResetPasswordPage.routePath
            ? null
            : ResetPasswordPage.routePath;
      }

      final isAuthScreen =
          location == LoginPage.routePath || location == RegisterPage.routePath;
      final isJoin = location.startsWith(JoinHouseholdPage.pathPrefix);
      // Auth screens, the forgot-password request, and invite links must be
      // reachable before signing in.
      final isPublic =
          isAuthScreen || isJoin || location == ForgotPasswordPage.routePath;

      if (status == AuthStatus.unauthenticated && !isPublic) {
        return LoginPage.routePath;
      }
      if (status == AuthStatus.authenticated) {
        if (isAuthScreen) return HomePage.routePath;

        // A signed-in user without a household is sent to onboarding, except
        // while already there or on a join link. `unknown` (the membership
        // load still in flight) is a no-op, so a restored session doesn't
        // flash onboarding before the answer is known.
        final membership = ref.read(householdMembershipProvider);
        final onOnboarding = location == OnboardingPage.routePath;
        if (membership == HouseholdMembership.none &&
            !onOnboarding &&
            !isJoin) {
          return OnboardingPage.routePath;
        }
        if (membership == HouseholdMembership.joined && onOnboarding) {
          return HomePage.routePath;
        }
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
        path: RegisterPage.routePath,
        name: RegisterPage.routeName,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: ForgotPasswordPage.routePath,
        name: ForgotPasswordPage.routeName,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: ResetPasswordPage.routePath,
        name: ResetPasswordPage.routeName,
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: JoinHouseholdPage.routePath,
        name: JoinHouseholdPage.routeName,
        builder: (context, state) => JoinHouseholdPage(
          connectionCode: state.pathParameters['code'] ?? '',
        ),
      ),
      GoRoute(
        path: OnboardingPage.routePath,
        name: OnboardingPage.routeName,
        builder: (context, state) => const OnboardingPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: HomePage.routePath,
                name: HomePage.routeName,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: ProfilePage.routePath,
                name: ProfilePage.routeName,
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: ProfileEditPage.routeSegment,
                    name: ProfileEditPage.routeName,
                    builder: (context, state) => const ProfileEditPage(),
                  ),
                  GoRoute(
                    path: PersonalDataPage.routeSegment,
                    name: PersonalDataPage.routeName,
                    builder: (context, state) => const PersonalDataPage(),
                  ),
                  GoRoute(
                    path: RemindersPage.routeSegment,
                    name: RemindersPage.routeName,
                    builder: (context, state) => const RemindersPage(),
                  ),
                  GoRoute(
                    path: HouseholdLinkPage.routeSegment,
                    name: HouseholdLinkPage.routeName,
                    builder: (context, state) => const HouseholdLinkPage(),
                  ),
                  GoRoute(
                    path: SettingsPage.routeSegment,
                    name: SettingsPage.routeName,
                    builder: (context, state) => const SettingsPage(),
                  ),
                  GoRoute(
                    path: PrivacyPage.routeSegment,
                    name: PrivacyPage.routeName,
                    builder: (context, state) => const PrivacyPage(),
                  ),
                  GoRoute(
                    path: HelpPage.routeSegment,
                    name: HelpPage.routeName,
                    builder: (context, state) => const HelpPage(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
