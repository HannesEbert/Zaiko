import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/l10n/l10n_extension.dart';
import '../../../l10n/app_localizations.dart';
import '../application/shopping_providers.dart';
import '../domain/shopping_repository.dart';

/// Maps a shopping-list [error] to a localized, user-facing message.
///
/// Anything that is not a [ShoppingFailure] falls back to a generic string.
String shoppingErrorMessage(AppLocalizations l10n, Object? error) {
  if (error is! ShoppingFailure) return l10n.shoppingErrorGeneric;
  return switch (error.reason) {
    ShoppingFailureReason.notMember => l10n.shoppingErrorNotMember,
    ShoppingFailureReason.notFound => l10n.shoppingErrorNotFound,
    ShoppingFailureReason.unknown => l10n.shoppingErrorGeneric,
  };
}

/// Shows a snackbar with the localized message for the shopping controller's
/// last failure — the shared handler for a mutation that returned `false`.
void showShoppingErrorSnackBar(BuildContext context, WidgetRef ref) {
  final error = ref.read(shoppingListControllerProvider).error;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(content: Text(shoppingErrorMessage(context.l10n, error))),
    );
}
