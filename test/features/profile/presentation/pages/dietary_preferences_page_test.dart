import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/profile/application/profile_providers.dart';
import 'package:zaiko/features/profile/domain/profile.dart';
import 'package:zaiko/features/profile/presentation/pages/dietary_preferences_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../fake_profile_repository.dart';

void main() {
  late FakeProfileRepository profiles;

  setUp(() {
    profiles = FakeProfileRepository()
      ..profile = Profile(
        id: 'user-1',
        displayName: 'Hannes',
        allergens: const ['gluten'],
        createdAt: DateTime.utc(2026),
      );
  });

  // The page uses context.pop() on save, so it needs a real router to return to.
  Future<void> pumpDietaryPage(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => context.push('/dietary'),
                child: const Text('open'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/dietary',
          builder: (context, state) => const DietaryPreferencesPage(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWithValue(AuthStatus.authenticated),
          profileRepositoryProvider.overrideWithValue(profiles),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('renders the option groups', (tester) async {
    await pumpDietaryPage(tester);

    expect(find.text('Gluten'), findsOneWidget);
    expect(find.text('Vegan'), findsOneWidget);
    expect(find.text('Olives'), findsOneWidget);
  });

  testWidgets('saves the seeded and newly ticked preferences', (tester) async {
    await pumpDietaryPage(tester);

    // Add a diet on top of the seeded 'gluten' allergen.
    await tester.tap(find.text('Vegan'));
    await tester.pumpAndSettle();

    final saveButton = find.widgetWithText(FilledButton, 'Save');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(profiles.dietaryCalls, 1);
    expect(profiles.lastAllergens, contains('gluten'));
    expect(profiles.lastDiets, contains('vegan'));
    // Popped back to the launcher on success.
    expect(find.text('open'), findsOneWidget);
  });
}
