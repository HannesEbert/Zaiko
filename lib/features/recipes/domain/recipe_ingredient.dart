import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_ingredient.freezed.dart';
part 'recipe_ingredient.g.dart';

/// A single ingredient of a [Recipe], mirroring a `public.recipe_ingredients`
/// row.
///
/// [amount] is free-form text (e.g. "200 g", "1 Dose"); a structured
/// quantity/unit is deferred. [sortOrder] preserves the author's ordering. The
/// ingredient is matched against the household's stock by its normalized [name]
/// (see `recipe_match.dart`).
@freezed
abstract class RecipeIngredient with _$RecipeIngredient {
  const factory RecipeIngredient({
    required String id,
    @JsonKey(name: 'recipe_id') required String recipeId,
    required String name,

    /// Free-form amount text (e.g. "200 g"); null when unspecified.
    String? amount,
    @JsonKey(name: 'sort_order') @Default(0) int sortOrder,
  }) = _RecipeIngredient;

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) =>
      _$RecipeIngredientFromJson(json);
}
