import '../../../l10n/app_localizations.dart';

/// Pure, UI-agnostic form validators for the inventory item form. Take
/// [AppLocalizations] explicitly (not a `BuildContext`) so they stay unit
/// testable, mirroring `AuthValidators`.
abstract final class InventoryValidators {
  /// Rejects an empty / whitespace-only item or taxonomy name.
  static String? name(AppLocalizations l10n, String? value) =>
      (value == null || value.trim().isEmpty) ? l10n.itemFormNameEmpty : null;

  /// Rejects a quantity that is missing, unparseable or not greater than zero.
  static String? quantity(AppLocalizations l10n, String? value) {
    final amount = parseQuantity(value);
    return (amount == null || amount <= 0)
        ? l10n.itemFormQuantityInvalid
        : null;
  }

  /// Parses a user-typed quantity, tolerating a comma decimal separator.
  /// Returns null when the input is not a number.
  static num? parseQuantity(String? value) {
    final text = value?.trim().replaceAll(',', '.');
    if (text == null || text.isEmpty) return null;
    return num.tryParse(text);
  }

  /// Rejects a count that is missing, not a whole number, or below one.
  static String? count(AppLocalizations l10n, String? value) {
    final n = parseCount(value);
    return (n == null || n < 1) ? l10n.itemFormCountInvalid : null;
  }

  /// Parses a user-typed count as a whole number. Returns null when the input
  /// is empty or not an integer.
  static int? parseCount(String? value) {
    final text = value?.trim();
    if (text == null || text.isEmpty) return null;
    return int.tryParse(text);
  }
}
