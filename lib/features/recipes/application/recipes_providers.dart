import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../household/application/households_providers.dart';
import '../../inventory/application/inventory_providers.dart';
import '../../inventory/domain/expiry.dart';
import '../../shopping_list/application/shopping_providers.dart';
import '../../shopping_list/domain/shopping_repository.dart';
import '../data/supabase_recipe_repository.dart';
import '../domain/recipe.dart';
import '../domain/recipe_draft.dart';
import '../domain/recipe_ingredient.dart';
import '../domain/recipe_match.dart';
import '../domain/recipe_repository.dart';

part 'recipes_providers.g.dart';

/// The recipe-list filter chips.
enum RecipeFilterKind {
  /// No filtering.
  all,

  /// At most one missing ingredient.
  almostComplete,

  /// Total time under 30 minutes.
  under30Min,
}

/// The app's [RecipeRepository]. Overridden with a fake in tests.
@riverpod
RecipeRepository recipeRepository(Ref ref) => SupabaseRecipeRepository();

/// The active household's recipes, newest first. Emits an empty list while the
/// user has no household. Re-fetched (not streamed) because ingredients are an
/// embedded resource; the [RecipeController] invalidates this after each write.
@riverpod
Future<List<Recipe>> recipes(Ref ref) async {
  final household = await ref.watch(currentHouseholdProvider.future);
  if (household == null) return const [];
  return ref.watch(recipeRepositoryProvider).loadRecipes(household.id);
}

/// Every recipe matched against the household's current stock, most useful
/// first: recipes that use expiring/expired items lead (then by how much they
/// use up), then the ones missing the fewest ingredients, then by title.
@riverpod
Future<List<RecipeMatch>> recipeMatches(Ref ref) async {
  final recipes = await ref.watch(recipesProvider.future);
  final resolved = await ref.watch(resolvedItemsProvider.future);

  final stockNames = <String>{};
  final expiringNames = <String>{};
  for (final resolvedItem in resolved) {
    final key = normalizeIngredientName(resolvedItem.item.name);
    stockNames.add(key);
    if (resolvedItem.status == ExpiryStatus.soon ||
        resolvedItem.status == ExpiryStatus.expired) {
      expiringNames.add(key);
    }
  }

  final matches = [
    for (final recipe in recipes)
      matchRecipe(recipe, stockNames: stockNames, expiringNames: expiringNames),
  ];
  matches.sort(_byUsefulness);
  return matches;
}

/// Sort order for the recipe list — see [recipeMatches].
int _byUsefulness(RecipeMatch a, RecipeMatch b) {
  if (a.usesExpiring != b.usesExpiring) return a.usesExpiring ? -1 : 1;
  if (a.expiringCount != b.expiringCount) {
    return b.expiringCount.compareTo(a.expiringCount);
  }
  if (a.missing.length != b.missing.length) {
    return a.missing.length.compareTo(b.missing.length);
  }
  return a.recipe.title.toLowerCase().compareTo(b.recipe.title.toLowerCase());
}

/// The selected recipe-list filter. Held in a provider (not local widget state)
/// so the filtering logic is testable in isolation.
@riverpod
class RecipeFilterController extends _$RecipeFilterController {
  @override
  RecipeFilterKind build() => RecipeFilterKind.all;

  /// Selects [kind] as the active filter.
  void select(RecipeFilterKind kind) => state = kind;
}

/// [recipeMatches] narrowed by the active [RecipeFilterKind].
@riverpod
Future<List<RecipeMatch>> filteredRecipeMatches(Ref ref) async {
  final matches = await ref.watch(recipeMatchesProvider.future);
  final filter = ref.watch(recipeFilterControllerProvider);
  return switch (filter) {
    RecipeFilterKind.all => matches,
    RecipeFilterKind.almostComplete =>
      matches.where((match) => match.missing.length <= 1).toList(),
    RecipeFilterKind.under30Min =>
      matches
          .where(
            (match) =>
                match.recipe.totalMinutes != null &&
                match.recipe.totalMinutes! < 30,
          )
          .toList(),
  };
}

/// The active household's id, or throws a [RecipeFailure] when there is none —
/// the guard every write shares. Read synchronously: a mutation is only
/// reachable from screens where the household is already resolved.
String _requireActiveHouseholdId(Ref ref) {
  final id = ref.read(currentHouseholdProvider).asData?.value?.id;
  if (id == null) {
    throw const RecipeFailure(
      RecipeFailureReason.unknown,
      'No active household.',
    );
  }
  return id;
}

/// Drives create/edit/delete for recipes plus the "add missing to shopping
/// list" action, with loading/error state.
///
/// Kept alive: the UI only reaches it through `ref.read(...notifier)` and never
/// watches it, so an autoDispose controller would be disposed during the async
/// mutation and its post-`await` `ref.invalidate` would never fire (the recipe
/// list is a one-shot load, so it must be invalidated explicitly).
@Riverpod(keepAlive: true)
class RecipeController extends _$RecipeController {
  @override
  FutureOr<void> build() {}

  /// Creates a recipe from [draft] in the active household.
  Future<bool> create(RecipeDraft draft) => _run(() async {
    await ref
        .read(recipeRepositoryProvider)
        .createRecipe(
          householdId: _requireActiveHouseholdId(ref),
          draft: draft,
        );
    ref.invalidate(recipesProvider);
  });

  /// Overwrites the recipe with [id] from [draft].
  Future<bool> save({required String id, required RecipeDraft draft}) =>
      _run(() async {
        await ref
            .read(recipeRepositoryProvider)
            .updateRecipe(id: id, draft: draft);
        ref.invalidate(recipesProvider);
      });

  /// Soft-deletes the recipe with [id].
  Future<bool> delete(String id) => _run(() async {
    await ref.read(recipeRepositoryProvider).deleteRecipe(id);
    ref.invalidate(recipesProvider);
  });

  /// Adds every [missing] ingredient to the household's shopping list, carrying
  /// the ingredient's amount across as the item's free-form quantity. Returns
  /// whether all inserts succeeded.
  Future<bool> addMissingToShoppingList(List<RecipeIngredient> missing) async {
    state = const AsyncLoading();
    try {
      final householdId = _requireActiveHouseholdId(ref);
      final shopping = ref.read(shoppingRepositoryProvider);
      for (final ingredient in missing) {
        await shopping.addItem(
          householdId: householdId,
          name: ingredient.name,
          quantity: ingredient.amount,
        );
      }
      state = const AsyncData(null);
      return true;
    } on ShoppingFailure catch (e, st) {
      state = AsyncError(e, st);
      return false;
    } on RecipeFailure catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return true;
    } on RecipeFailure catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}
