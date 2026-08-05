import '../../../l10n/app_localizations.dart';
import '../domain/food_failure.dart';

/// Maps a food lookup/catalog [error] to a localized, user-facing message.
///
/// Anything that is not a [FoodFailure] falls back to a generic string.
String foodErrorMessage(AppLocalizations l10n, Object? error) {
  if (error is! FoodFailure) return l10n.foodErrorGeneric;
  return switch (error.reason) {
    FoodFailureReason.network => l10n.foodErrorNetwork,
    FoodFailureReason.rateLimited => l10n.foodErrorRateLimited,
    FoodFailureReason.unknown => l10n.foodErrorGeneric,
  };
}
