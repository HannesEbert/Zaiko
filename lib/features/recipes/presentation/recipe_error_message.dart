import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n_extension.dart';
import '../../../l10n/app_localizations.dart';
import '../application/recipes_providers.dart';
import '../domain/recipe_repository.dart';

/// Maps a recipe [error] to a localized, user-facing message.
///
/// Anything that is not a [RecipeFailure] (e.g. a shopping-list failure raised
/// while adding missing ingredients) falls back to a generic string.
String recipeErrorMessage(AppLocalizations l10n, Object? error) {
  if (error is! RecipeFailure) return l10n.recipesErrorGeneric;
  return switch (error.reason) {
    RecipeFailureReason.notMember => l10n.recipesErrorNotMember,
    RecipeFailureReason.notFound => l10n.recipesErrorNotFound,
    RecipeFailureReason.unknown => l10n.recipesErrorGeneric,
  };
}

/// Shows a snackbar with the localized message for the recipe controller's last
/// failure — the shared handler for a mutation that returned `false`.
void showRecipeErrorSnackBar(BuildContext context, WidgetRef ref) {
  final error = ref.read(recipeControllerProvider).error;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(recipeErrorMessage(context.l10n, error))),
    );
}
