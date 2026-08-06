import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/recipes/application/screen_wake_lock.dart';
import 'package:zaiko/features/recipes/domain/recipe.dart';
import 'package:zaiko/features/recipes/domain/recipe_step.dart';
import 'package:zaiko/features/recipes/presentation/pages/cook_mode_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';
import 'package:zaiko/shared/widgets/zaiko_buttons.dart';

class _FakeScreenWakeLock implements ScreenWakeLock {
  @override
  Future<void> enable() async {}

  @override
  Future<void> disable() async {}
}

void main() {
  final now = DateTime.utc(2026);

  Recipe recipeWithSteps(List<String> steps) => Recipe(
    id: 'r1',
    householdId: 'hh-1',
    title: 'Pasta',
    createdAt: now,
    updatedAt: now,
    steps: [for (final text in steps) RecipeStep(text: text)],
  );

  Recipe recipeWith(List<RecipeStep> steps) => Recipe(
    id: 'r1',
    householdId: 'hh-1',
    title: 'Pasta',
    createdAt: now,
    updatedAt: now,
    steps: steps,
  );

  // Pumps a launcher screen and opens the cook mode via [CookModePage.open], so
  // the page sits on a real (root) route and can pop cleanly.
  Future<void> openCookMode(WidgetTester tester, Recipe recipe) async {
    await tester.binding.setSurfaceSize(const Size(500, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          screenWakeLockProvider.overrideWithValue(_FakeScreenWakeLock()),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: ElevatedButton(
                  onPressed: () => CookModePage.open(context, recipe: recipe),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('steps forward through the recipe with the next button', (
    tester,
  ) async {
    await openCookMode(
      tester,
      recipeWithSteps(['Boil water', 'Add pasta', 'Serve']),
    );

    expect(find.text('Step 1/3'), findsOneWidget);
    expect(find.text('Boil water'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Step 2/3'), findsOneWidget);
    expect(find.text('Add pasta'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Step 3/3'), findsOneWidget);
    expect(find.text('Serve'), findsOneWidget);
    // The last step swaps "Next" for the closing "Done" action.
    expect(find.text('Done'), findsOneWidget);
    expect(find.text('Next'), findsNothing);
  });

  testWidgets('the back button is disabled on the first step', (tester) async {
    await openCookMode(tester, recipeWithSteps(['Boil water', 'Add pasta']));

    final back = tester.widget<ZaikoSecondaryButton>(
      find.widgetWithText(ZaikoSecondaryButton, 'Back'),
    );
    expect(back.onPressed, isNull);
  });

  testWidgets('swiping advances to the next step', (tester) async {
    await openCookMode(tester, recipeWithSteps(['Boil water', 'Add pasta']));

    await tester.drag(find.byType(PageView), const Offset(-400, 0));
    await tester.pumpAndSettle();

    expect(find.text('Step 2/2'), findsOneWidget);
    expect(find.text('Add pasta'), findsOneWidget);
  });

  testWidgets('done closes the cook mode', (tester) async {
    await openCookMode(tester, recipeWithSteps(['Boil water']));

    // A single step is immediately the last one.
    expect(find.text('Step 1/1'), findsOneWidget);

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();

    // Back on the launcher screen; the cook mode is gone.
    expect(find.text('open'), findsOneWidget);
    expect(find.text('Step 1/1'), findsNothing);
  });

  testWidgets('a step with a timer shows it and can start then pause', (
    tester,
  ) async {
    await openCookMode(
      tester,
      recipeWith(const [RecipeStep(text: 'Bake', timerSeconds: 90)]),
    );

    // Seeded from the recipe: 1 min 30 s, not the 5-min fallback.
    expect(find.text('01:30'), findsOneWidget);
    expect(find.text('Start timer'), findsOneWidget);

    await tester.tap(find.text('Start timer'));
    // A single frame — the countdown is a real periodic timer, so pumpAndSettle
    // would never settle.
    await tester.pump();
    expect(find.text('Pause'), findsOneWidget);

    await tester.tap(find.text('Pause'));
    await tester.pump();
    // Paused: the timer's ticker is cancelled, so nothing is left pending.
    expect(find.text('Resume'), findsOneWidget);
  });

  testWidgets('a step without a timer shows no timer card', (tester) async {
    await openCookMode(
      tester,
      recipeWith(const [RecipeStep(text: 'Chop the onions')]),
    );

    expect(find.text('Chop the onions'), findsOneWidget);
    expect(find.text('Start timer'), findsNothing);
  });
}
