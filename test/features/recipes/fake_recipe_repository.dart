import 'package:zaiko/features/recipes/domain/recipe.dart';
import 'package:zaiko/features/recipes/domain/recipe_draft.dart';
import 'package:zaiko/features/recipes/domain/recipe_ingredient.dart';
import 'package:zaiko/features/recipes/domain/recipe_repository.dart';

/// In-memory [RecipeRepository] for tests: no Supabase, fully controllable.
///
/// [loadRecipes] returns the current [recipes]; mutations update the in-memory
/// state so provider tests observe the same "reload after write" behavior as
/// production. Scripting a failure is done via [loadError]/[writeError].
class FakeRecipeRepository implements RecipeRepository {
  List<Recipe> recipes = const [];

  /// When set, [loadRecipes] throws it — for load-path tests.
  RecipeFailure? loadError;

  /// When set, every mutation throws it — for failure-path tests.
  RecipeFailure? writeError;

  int loadCalls = 0;
  int createCalls = 0;
  int updateCalls = 0;
  int deleteCalls = 0;

  int _seq = 0;

  @override
  Future<List<Recipe>> loadRecipes(String householdId) async {
    loadCalls++;
    final error = loadError;
    if (error != null) throw error;
    return recipes;
  }

  @override
  Future<Recipe> createRecipe({
    required String householdId,
    required RecipeDraft draft,
  }) async {
    createCalls++;
    _throwIfScripted();
    final id = 'recipe-${++_seq}';
    final recipe = _fromDraft(id: id, householdId: householdId, draft: draft);
    recipes = [recipe, ...recipes];
    return recipe;
  }

  @override
  Future<void> updateRecipe({
    required String id,
    required RecipeDraft draft,
  }) async {
    updateCalls++;
    _throwIfScripted();
    recipes = [
      for (final recipe in recipes)
        if (recipe.id == id)
          _fromDraft(id: id, householdId: recipe.householdId, draft: draft)
        else
          recipe,
    ];
  }

  @override
  Future<void> deleteRecipe(String id) async {
    deleteCalls++;
    _throwIfScripted();
    recipes = recipes.where((recipe) => recipe.id != id).toList();
  }

  Recipe _fromDraft({
    required String id,
    required String householdId,
    required RecipeDraft draft,
  }) {
    final now = DateTime.now();
    return Recipe(
      id: id,
      householdId: householdId,
      title: draft.title,
      createdAt: now,
      updatedAt: now,
      totalMinutes: draft.totalMinutes,
      servings: draft.servings,
      steps: draft.steps,
      ingredients: [
        for (final (index, ingredient) in draft.ingredients.indexed)
          RecipeIngredient(
            id: '$id-ing-$index',
            recipeId: id,
            name: ingredient.name,
            amount: ingredient.amount,
            sortOrder: index,
          ),
      ],
    );
  }

  void _throwIfScripted() {
    final error = writeError;
    if (error != null) throw error;
  }
}
