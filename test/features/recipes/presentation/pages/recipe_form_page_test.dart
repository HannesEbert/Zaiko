import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/domain/household.dart';
import 'package:zaiko/features/recipes/application/recipes_providers.dart';
import 'package:zaiko/features/recipes/presentation/pages/recipe_form_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../../household/fake_household_repository.dart';
import '../../fake_recipe_repository.dart';

void main() {
  late FakeRecipeRepository recipes;
  late FakeHouseholdRepository household;

  setUp(() {
    recipes = FakeRecipeRepository();
    household = FakeHouseholdRepository()
      ..current = Household(
        id: 'hh-1',
        name: 'Lindenhof',
        createdAt: DateTime.utc(2026),
      );
  });

  // Pumps a launcher that pushes the create form onto a GoRouter (the form uses
  // context.pop(), so it needs a real router to return to).
  Future<void> pumpCreateForm(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    addTearDown(household.dispose);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => context.push('/form'),
                child: const Text('open'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/form',
          builder: (context, state) => const RecipeFormPage(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWithValue(AuthStatus.authenticated),
          householdRepositoryProvider.overrideWithValue(household),
          recipeRepositoryProvider.overrideWithValue(recipes),
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

    // Warm the household provider (and keep it alive) so the form's save guard
    // sees a resolved household — in the app the shell already watches it.
    final container = ProviderScope.containerOf(
      tester.element(find.text('open')),
    );
    container.listen(currentHouseholdProvider, (_, _) {});
    await container.read(currentHouseholdProvider.future);
    await tester.pumpAndSettle();

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('saves a step with the entered timer duration', (tester) async {
    await pumpCreateForm(tester);

    // Fields in order: title (0), minutes (1), servings (2), ingredient name
    // (3), ingredient amount (4), step text (5).
    await tester.enterText(find.byType(TextField).at(0), 'Bratapfel');
    await tester.enterText(find.byType(TextField).at(5), 'Im Ofen backen');

    // Turn the step's timer on, then enter 2 min 30 s.
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(6), '2');
    await tester.enterText(find.byType(TextField).at(7), '30');

    await tester.tap(find.widgetWithText(FilledButton, 'Create recipe'));
    await tester.pumpAndSettle();

    expect(recipes.createCalls, 1);
    final step = recipes.recipes.single.steps.single;
    expect(step.text, 'Im Ofen backen');
    expect(step.timerSeconds, 150);
  });

  testWidgets('saves a step without a timer when the toggle stays off', (
    tester,
  ) async {
    await pumpCreateForm(tester);

    await tester.enterText(find.byType(TextField).at(0), 'Rührei');
    await tester.enterText(find.byType(TextField).at(5), 'Eier verquirlen');

    await tester.tap(find.widgetWithText(FilledButton, 'Create recipe'));
    await tester.pumpAndSettle();

    expect(recipes.createCalls, 1);
    final step = recipes.recipes.single.steps.single;
    expect(step.text, 'Eier verquirlen');
    expect(step.timerSeconds, isNull);
  });
}
