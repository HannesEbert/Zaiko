import 'package:freezed_annotation/freezed_annotation.dart';

import 'recipe_ingredient.dart';
import 'recipe_step.dart';

part 'recipe.freezed.dart';
part 'recipe.g.dart';

/// A household recipe, mirroring a `public.recipes` row with its embedded
/// `recipe_ingredients`.
///
/// Recipes belong to a household (like inventory and shopping items), so every
/// member sees the same list. [steps] holds the ordered step-by-step
/// instructions shown on the detail page (E3.2's cook mode builds on them).
/// [ingredients] is populated from the embedded `recipe_ingredients` select;
/// [deletedAt]/[updatedAt] carry the soft-delete + last-write-wins shape used
/// across the schema.
@freezed
abstract class Recipe with _$Recipe {
  const factory Recipe({
    required String id,
    @JsonKey(name: 'household_id') required String householdId,
    required String title,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,

    /// Total time in minutes; null when unspecified. Drives the "under 30 min"
    /// filter.
    @JsonKey(name: 'total_minutes') int? totalMinutes,
    int? servings,
    @JsonKey(name: 'image_url') String? imageUrl,

    /// Ordered step-by-step instructions; empty until the author adds any.
    @Default(<RecipeStep>[]) List<RecipeStep> steps,

    /// The recipe's ingredients, ordered by their `sort_order`.
    @JsonKey(name: 'recipe_ingredients')
    @Default(<RecipeIngredient>[])
    List<RecipeIngredient> ingredients,

    /// The user who created the recipe; nulled out if their account is deleted.
    @JsonKey(name: 'created_by') String? createdBy,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
  }) = _Recipe;

  factory Recipe.fromJson(Map<String, dynamic> json) => _$RecipeFromJson(json);
}
