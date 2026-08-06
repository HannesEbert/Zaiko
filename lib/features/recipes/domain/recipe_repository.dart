import 'recipe.dart';
import 'recipe_draft.dart';

/// Why a [RecipeRepository] operation failed.
///
/// Mapped from backend errors at the data boundary so the UI never sees a raw
/// `PostgrestException`.
enum RecipeFailureReason {
  /// The user is not a member of the household they tried to read or write.
  notMember,

  /// The targeted recipe does not exist (or is not visible to the caller).
  notFound,

  /// Any other backend or network error.
  unknown,
}

/// Domain-level recipe error with a [reason] and a user-presentable [message]
/// fallback. Keeps Supabase exceptions out of the UI layer.
class RecipeFailure implements Exception {
  const RecipeFailure(this.reason, this.message);

  /// The categorized cause, used to pick a localized message.
  final RecipeFailureReason reason;

  /// Human-readable reason, used when no specific localized message applies.
  final String message;

  @override
  String toString() => 'RecipeFailure(${reason.name}): $message';
}

/// Abstraction over the household's recipes.
///
/// The app depends on this interface, not on Supabase directly, so tests can
/// substitute a fake and the backend can be swapped without touching callers.
/// Every method throws [RecipeFailure] on backend errors.
///
/// Recipes are loaded (not streamed): a recipe carries its ingredients as an
/// embedded resource, which Postgres realtime cannot join, so the application
/// layer re-fetches after each mutation instead.
abstract interface class RecipeRepository {
  /// Loads the household's recipes with their ingredients, newest first.
  /// Soft-deleted recipes are excluded.
  Future<List<Recipe>> loadRecipes(String householdId);

  /// Creates a recipe with its ingredients in [householdId] and returns the
  /// created row (with ingredients).
  Future<Recipe> createRecipe({
    required String householdId,
    required RecipeDraft draft,
  });

  /// Overwrites the recipe with [id] from [draft], replacing its ingredients.
  Future<void> updateRecipe({required String id, required RecipeDraft draft});

  /// Soft-deletes the recipe with [id] (sets `deleted_at`).
  Future<void> deleteRecipe(String id);
}
