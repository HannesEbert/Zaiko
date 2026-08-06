import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/domain/household.dart';
import 'package:zaiko/features/inventory/application/inventory_providers.dart';
import 'package:zaiko/features/inventory/domain/inventory_item.dart';
import 'package:zaiko/features/recipes/application/recipes_providers.dart';
import 'package:zaiko/features/recipes/domain/recipe.dart';
import 'package:zaiko/features/recipes/domain/recipe_draft.dart';
import 'package:zaiko/features/recipes/domain/recipe_ingredient.dart';
import 'package:zaiko/features/recipes/domain/recipe_match.dart';
import 'package:zaiko/features/recipes/domain/recipe_repository.dart';
import 'package:zaiko/features/shopping_list/application/shopping_providers.dart';

import '../../household/fake_household_repository.dart';
import '../../inventory/fake_inventory_repository.dart';
import '../../shopping_list/fake_shopping_repository.dart';
import '../fake_recipe_repository.dart';

void main() {
  final now = DateTime.utc(2026);

  late FakeRecipeRepository recipesRepo;
  late FakeInventoryRepository inventory;
  late FakeShoppingRepository shopping;
  late FakeHouseholdRepository household;
  late ProviderContainer container;

  Recipe recipe(String id, {required List<String> ingredients, int? minutes}) =>
      Recipe(
        id: id,
        householdId: 'hh-1',
        title: id,
        createdAt: now,
        updatedAt: now,
        totalMinutes: minutes,
        ingredients: [
          for (final (index, name) in ingredients.indexed)
            RecipeIngredient(
              id: '$id-$index',
              recipeId: id,
              name: name,
              sortOrder: index,
            ),
        ],
      );

  InventoryItem stockItem(String name, {required int daysUntil}) =>
      InventoryItem(
        id: name,
        householdId: 'hh-1',
        name: name,
        quantity: 1,
        createdAt: now,
        updatedAt: now,
        bestBefore: DateTime.now().add(Duration(days: daysUntil)),
      );

  setUp(() {
    recipesRepo = FakeRecipeRepository();
    inventory = FakeInventoryRepository();
    shopping = FakeShoppingRepository();
    household = FakeHouseholdRepository()
      ..current = Household(
        id: 'hh-1',
        name: 'Lindenhof',
        createdAt: DateTime.utc(2026),
      );

    container = ProviderContainer(
      overrides: [
        authStateProvider.overrideWithValue(AuthStatus.authenticated),
        householdRepositoryProvider.overrideWithValue(household),
        inventoryRepositoryProvider.overrideWithValue(inventory),
        shoppingRepositoryProvider.overrideWithValue(shopping),
        recipeRepositoryProvider.overrideWithValue(recipesRepo),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(inventory.dispose);
    addTearDown(shopping.dispose);
    addTearDown(household.dispose);
  });

  /// Butter expires soon (red zone), Milch is fresh; three recipes with
  /// different coverage — the shared fixture for the matching tests.
  void seedStockAndRecipes() {
    inventory.items = [
      stockItem('Butter', daysUntil: 1),
      stockItem('Milch', daysUntil: 10),
    ];
    recipesRepo.recipes = [
      recipe('milk-only', ingredients: ['Milch'], minutes: 45),
      recipe('butter-eggs', ingredients: ['Butter', 'Eier'], minutes: 10),
      recipe('reis', ingredients: ['Reis', 'Zucker'], minutes: 20),
    ];
  }

  RecipeMatch matchFor(List<RecipeMatch> matches, String id) =>
      matches.firstWhere((match) => match.recipe.id == id);

  test('recipes is empty when the user has no household', () async {
    household.current = null;
    container.invalidate(currentHouseholdProvider);

    container.listen(recipesProvider, (_, _) {}, onError: (_, _) {});
    expect(await container.read(recipesProvider.future), isEmpty);
  });

  test('recipeMatches leads with expiring, then fewest missing', () async {
    seedStockAndRecipes();

    container.listen(recipeMatchesProvider, (_, _) {}, onError: (_, _) {});
    final matches = await container.read(recipeMatchesProvider.future);

    expect(matches.map((m) => m.recipe.id), [
      'butter-eggs', // uses expiring Butter
      'milk-only', // no missing ingredients
      'reis', // two missing ingredients
    ]);
  });

  test(
    'recipeMatches computes missing ingredients and the expiring flag',
    () async {
      seedStockAndRecipes();

      container.listen(recipeMatchesProvider, (_, _) {}, onError: (_, _) {});
      final matches = await container.read(recipeMatchesProvider.future);

      final butter = matchFor(matches, 'butter-eggs');
      expect(butter.usesExpiring, isTrue);
      expect(butter.matchedCount, 1);
      expect(butter.missing.map((i) => i.name), ['Eier']);

      expect(matchFor(matches, 'milk-only').isComplete, isTrue);
    },
  );

  test('almostComplete filter keeps recipes missing at most one', () async {
    seedStockAndRecipes();
    container
        .read(recipeFilterControllerProvider.notifier)
        .select(RecipeFilterKind.almostComplete);

    container.listen(
      filteredRecipeMatchesProvider,
      (_, _) {},
      onError: (_, _) {},
    );
    final matches = await container.read(filteredRecipeMatchesProvider.future);

    expect(matches.map((m) => m.recipe.id), ['butter-eggs', 'milk-only']);
  });

  test('under30Min filter keeps recipes with time under 30', () async {
    seedStockAndRecipes();
    container
        .read(recipeFilterControllerProvider.notifier)
        .select(RecipeFilterKind.under30Min);

    container.listen(
      filteredRecipeMatchesProvider,
      (_, _) {},
      onError: (_, _) {},
    );
    final matches = await container.read(filteredRecipeMatchesProvider.future);

    expect(matches.map((m) => m.recipe.id).toSet(), {'butter-eggs', 'reis'});
  });

  test('controller.create inserts a recipe and reports success', () async {
    container.listen(currentHouseholdProvider, (_, _) {}, onError: (_, _) {});
    await container.read(currentHouseholdProvider.future);

    final ok = await container
        .read(recipeControllerProvider.notifier)
        .create(
          const RecipeDraft(
            title: 'Pfannkuchen',
            ingredients: [RecipeIngredientDraft(name: 'Mehl')],
            steps: ['Teig rühren'],
          ),
        );

    expect(ok, isTrue);
    expect(recipesRepo.createCalls, 1);
    expect(recipesRepo.recipes.single.title, 'Pfannkuchen');
    expect(container.read(recipeControllerProvider).hasError, isFalse);
  });

  test('controller.delete removes the recipe', () async {
    recipesRepo.recipes = [
      recipe('r1', ingredients: ['Milch']),
    ];

    final ok = await container
        .read(recipeControllerProvider.notifier)
        .delete('r1');

    expect(ok, isTrue);
    expect(recipesRepo.deleteCalls, 1);
    expect(recipesRepo.recipes, isEmpty);
  });

  test('addMissingToShoppingList adds every missing ingredient', () async {
    seedStockAndRecipes();
    container.listen(currentHouseholdProvider, (_, _) {}, onError: (_, _) {});
    await container.read(currentHouseholdProvider.future);
    container.listen(recipeMatchesProvider, (_, _) {}, onError: (_, _) {});
    final matches = await container.read(recipeMatchesProvider.future);
    final butter = matchFor(matches, 'butter-eggs');

    final ok = await container
        .read(recipeControllerProvider.notifier)
        .addMissingToShoppingList(butter.missing);

    expect(ok, isTrue);
    expect(shopping.addItemCalls, 1);
    expect(shopping.items.single.name, 'Eier');
  });

  test('a write failure surfaces as an error and reports failure', () async {
    container.listen(currentHouseholdProvider, (_, _) {}, onError: (_, _) {});
    await container.read(currentHouseholdProvider.future);
    recipesRepo.writeError = const RecipeFailure(
      RecipeFailureReason.notMember,
      'denied',
    );

    final ok = await container
        .read(recipeControllerProvider.notifier)
        .create(const RecipeDraft(title: 'X', ingredients: [], steps: []));

    expect(ok, isFalse);
    final state = container.read(recipeControllerProvider);
    expect(state.hasError, isTrue);
    expect(state.error, isA<RecipeFailure>());
  });
}
