import '../../../l10n/app_localizations.dart';
import '../domain/inventory_repository.dart';

/// Maps an inventory [error] to a localized, user-facing message.
///
/// Anything that is not an [InventoryFailure] falls back to a generic string.
String inventoryErrorMessage(AppLocalizations l10n, Object? error) {
  if (error is! InventoryFailure) return l10n.inventoryErrorGeneric;
  return switch (error.reason) {
    InventoryFailureReason.notMember => l10n.inventoryErrorNotMember,
    InventoryFailureReason.notFound => l10n.inventoryErrorNotFound,
    InventoryFailureReason.unknown => l10n.inventoryErrorGeneric,
  };
}
