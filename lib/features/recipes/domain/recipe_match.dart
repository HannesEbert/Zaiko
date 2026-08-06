import 'recipe.dart';
import 'recipe_ingredient.dart';

/// A recipe paired with how well its ingredients are covered by the household's
/// current stock — the read model the recipe list and card consume.
///
/// Pure Dart: computed by [matchRecipe] from normalized name sets, so it is
/// trivially testable and independent of how stock is loaded.
class RecipeMatch {
  const RecipeMatch({
    required this.recipe,
    required this.missing,
    required this.matchedCount,
    required this.usesExpiring,
    required this.expiringCount,
  });

  final Recipe recipe;

  /// The ingredients not currently in stock, in their original order.
  final List<RecipeIngredient> missing;

  /// How many of the recipe's ingredients are in stock.
  final int matchedCount;

  /// Whether the recipe uses at least one item from the expiring/expired (red)
  /// zone — the signal for the "use it up" badge and top-of-list sorting.
  final bool usesExpiring;

  /// How many in-stock ingredients are in the expiring/expired zone.
  final int expiringCount;

  /// The recipe's total ingredient count.
  int get totalCount => recipe.ingredients.length;

  /// Whether every ingredient is in stock.
  bool get isComplete => missing.isEmpty;
}

/// Normalizes an ingredient or stock name for matching: trimmed, lower-cased,
/// and inner whitespace collapsed. Keeps the match forgiving of casing and
/// spacing without a catalog lookup (finer `foods`-based matching is deferred).
String normalizeIngredientName(String name) =>
    name.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

/// Matches [recipe] against the household's stock.
///
/// [stockNames] and [expiringNames] are pre-normalized sets of the in-stock
/// item names and of those in the expiring/expired zone (a subset of
/// [stockNames]). An ingredient counts as available when its normalized name is
/// in [stockNames]; anything else lands in [RecipeMatch.missing].
RecipeMatch matchRecipe(
  Recipe recipe, {
  required Set<String> stockNames,
  required Set<String> expiringNames,
}) {
  final missing = <RecipeIngredient>[];
  var matched = 0;
  var expiring = 0;
  for (final ingredient in recipe.ingredients) {
    final key = normalizeIngredientName(ingredient.name);
    if (stockNames.contains(key)) {
      matched++;
      if (expiringNames.contains(key)) expiring++;
    } else {
      missing.add(ingredient);
    }
  }
  return RecipeMatch(
    recipe: recipe,
    missing: missing,
    matchedCount: matched,
    usesExpiring: expiring > 0,
    expiringCount: expiring,
  );
}
