import 'recipe_step.dart';

/// The editable content of a recipe, collected by the create/edit form and
/// handed to the [RecipeRepository].
///
/// Plain Dart (no persistence ids): a draft describes what a recipe should
/// become, independent of whether it already exists. Ingredient order follows
/// the list order; the repository assigns `sort_order` from it.
class RecipeDraft {
  const RecipeDraft({
    required this.title,
    required this.ingredients,
    required this.steps,
    this.totalMinutes,
    this.servings,
  });

  final String title;
  final int? totalMinutes;
  final int? servings;

  /// The ingredients in author order; empty is allowed.
  final List<RecipeIngredientDraft> ingredients;

  /// The step-by-step instructions in order; empty is allowed. Reuses
  /// [RecipeStep] (it carries no persistence id) instead of a separate draft.
  final List<RecipeStep> steps;
}

/// A single ingredient line in a [RecipeDraft].
class RecipeIngredientDraft {
  const RecipeIngredientDraft({required this.name, this.amount});

  final String name;

  /// Free-form amount text (e.g. "200 g"); null when unspecified.
  final String? amount;
}
