import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/recipe.dart';
import '../domain/recipe_draft.dart';
import '../domain/recipe_repository.dart';

/// Parses a row and orders its embedded ingredients by `sort_order` — PostgREST
/// does not guarantee the order of an embedded resource.
Recipe _parseRecipe(Map<String, dynamic> row) {
  final recipe = Recipe.fromJson(row);
  final ingredients = [...recipe.ingredients]
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return recipe.copyWith(ingredients: ingredients);
}

/// [RecipeRepository] backed by Supabase Postgres.
///
/// Reads and writes are gated by RLS (a member only ever touches their own
/// household's recipes). Every backend exception is translated to a
/// [RecipeFailure] so callers never see a raw `PostgrestException`.
class SupabaseRecipeRepository implements RecipeRepository {
  SupabaseRecipeRepository([SupabaseClient? client])
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  /// Recipe columns plus the embedded ingredients — the single select shape
  /// every read returns.
  static const String _withIngredients = '*, recipe_ingredients(*)';

  @override
  Future<List<Recipe>> loadRecipes(String householdId) async {
    try {
      final rows = await _client
          .from('recipes')
          .select(_withIngredients)
          .eq('household_id', householdId)
          .isFilter('deleted_at', null)
          .order('created_at', ascending: false);
      return rows.map(_parseRecipe).toList();
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Recipe> createRecipe({
    required String householdId,
    required RecipeDraft draft,
  }) async {
    try {
      final inserted = await _client
          .from('recipes')
          .insert({
            'household_id': householdId,
            'title': draft.title,
            'total_minutes': draft.totalMinutes,
            'servings': draft.servings,
            'steps': [for (final step in draft.steps) step.toJson()],
            'created_by': _client.auth.currentUser?.id,
          })
          .select('id')
          .single();
      final id = inserted['id'] as String;
      await _insertIngredients(id, draft);
      return _loadById(id);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> updateRecipe({
    required String id,
    required RecipeDraft draft,
  }) async {
    try {
      await _client
          .from('recipes')
          .update({
            'title': draft.title,
            'total_minutes': draft.totalMinutes,
            'servings': draft.servings,
            'steps': [for (final step in draft.steps) step.toJson()],
          })
          .eq('id', id);
      // Replace the ingredient set wholesale — simpler than diffing, and the
      // list is small.
      await _client.from('recipe_ingredients').delete().eq('recipe_id', id);
      await _insertIngredients(id, draft);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> deleteRecipe(String id) async {
    try {
      await _client
          .from('recipes')
          .update({'deleted_at': DateTime.now().toIso8601String()})
          .eq('id', id);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  /// Inserts [draft]'s ingredients for recipe [recipeId], numbering their
  /// `sort_order` from the list order. A no-op when the draft has none.
  Future<void> _insertIngredients(String recipeId, RecipeDraft draft) async {
    if (draft.ingredients.isEmpty) return;
    final rows = [
      for (final (index, ingredient) in draft.ingredients.indexed)
        {
          'recipe_id': recipeId,
          'name': ingredient.name,
          'amount': ingredient.amount,
          'sort_order': index,
        },
    ];
    await _client.from('recipe_ingredients').insert(rows);
  }

  /// Re-reads a single recipe with its ingredients after a write.
  Future<Recipe> _loadById(String id) async {
    final row = await _client
        .from('recipes')
        .select(_withIngredients)
        .eq('id', id)
        .single();
    return _parseRecipe(row);
  }

  RecipeFailure _mapError(PostgrestException e) {
    final reason = switch (e.code) {
      '42501' => RecipeFailureReason.notMember,
      // PostgREST returns PGRST116 when a single-row request matched no row.
      'PGRST116' => RecipeFailureReason.notFound,
      _ => RecipeFailureReason.unknown,
    };
    return RecipeFailure(reason, e.message);
  }
}
