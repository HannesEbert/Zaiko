import '../../../l10n/app_localizations.dart';
import '../domain/recipe.dart';
import '../domain/recipe_match.dart';

/// Builds the "25 Min · 4 Portionen" meta line from a recipe's time and
/// servings, omitting whichever part is unset.
String recipeMetaLabel(AppLocalizations l10n, Recipe recipe) {
  final parts = <String>[
    if (recipe.totalMinutes != null) l10n.recipesMinutes(recipe.totalMinutes!),
    if (recipe.servings != null) l10n.recipesServings(recipe.servings!),
  ];
  return parts.join(' · ');
}

/// The match-pill text: "all in stock" when complete, else "X/Y ingredients".
String recipeMatchLabel(AppLocalizations l10n, RecipeMatch match) =>
    match.isComplete
    ? l10n.recipesMatchComplete
    : l10n.recipesMatchCount(match.matchedCount, match.totalCount);
