import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/status_pill.dart';
import '../domain/expiry.dart';
import '../domain/inventory_unit.dart';
import '../domain/storage_location.dart';

/// Presentation-only formatting for inventory data: turns raw quantities,
/// units and dates into the localized labels the screens render. Kept out of
/// the widgets so the strings are computed in one place and unit-testable.

/// The stocked amount: `"6 × 1.5 l"` for a multipack, `"500 g"` for a single
/// sized item, or just `"3"` when the item has no measurable size (a plain
/// count). [unit] is a language-neutral symbol (g/kg/ml/l), shown as-is.
String formatQuantity({
  required int count,
  required num quantity,
  String? unit,
}) {
  if (unit == null || unit.isEmpty) return '$count';
  final amount = quantity % 1 == 0
      ? quantity.toInt().toString()
      : quantity.toString();
  final size = '$amount $unit';
  return count == 1 ? size : '$count × $size';
}

/// The picker-chip label for a fixed [InventoryUnit] — the language-neutral
/// symbol (g/kg/ml/l).
String inventoryUnitLabel(InventoryUnit unit) => unit.key;

/// Short expiry label for rails and list rows ("Morgen", "In 2 Tagen",
/// "Abgelaufen"); null when the item has no best-before date.
String? expiryShortLabel(
  AppLocalizations l10n,
  DateTime? bestBefore, {
  DateTime? now,
}) {
  final days = daysUntilExpiry(bestBefore, now: now);
  if (days == null) return null;
  if (days < 0) return l10n.expiryExpired;
  if (days == 0) return l10n.expiryToday;
  if (days == 1) return l10n.expiryTomorrow;
  return l10n.expiryInDays(days);
}

/// Longer phrasing for the item detail status pill ("Läuft in 2 Tagen ab");
/// null when the item has no best-before date.
String? expiryDetailLabel(
  AppLocalizations l10n,
  DateTime? bestBefore, {
  DateTime? now,
}) {
  final days = daysUntilExpiry(bestBefore, now: now);
  if (days == null) return null;
  if (days < 0) return l10n.expiryExpired;
  if (days == 0) return l10n.itemDetailExpiresToday;
  if (days == 1) return l10n.itemDetailExpiresTomorrow;
  return l10n.itemDetailExpiresInDays(days);
}

/// Relative label for when an item was added ("Heute", "Gestern",
/// "Vor 3 Tagen"), falling back to a short date for older items.
String addedRelativeLabel(
  AppLocalizations l10n,
  DateTime createdAt, {
  DateTime? now,
}) {
  final today = _dateOnly(now ?? DateTime.now());
  final day = _dateOnly(createdAt.toLocal());
  final daysAgo = today.difference(day).inDays;
  if (daysAgo <= 0) return l10n.relativeToday;
  if (daysAgo == 1) return l10n.relativeYesterday;
  if (daysAgo <= 6) return l10n.relativeDaysAgo(daysAgo);
  return DateFormat('dd.MM.yy').format(day);
}

/// Full best-before date for the item detail screen ("17.07.2026").
String formatBestBefore(DateTime bestBefore) =>
    DateFormat('dd.MM.yyyy').format(bestBefore);

/// The display name for a storage location, resolving the synthetic
/// "unassigned" bucket ([StorageLocation.unassignedId]) to its localized label.
String storageLocationLabel(AppLocalizations l10n, StorageLocation location) =>
    location.id == StorageLocation.unassignedId
    ? l10n.locationUnassignedName
    : location.name;

/// The uppercase first letter of a household [name] for the header avatar, or
/// "?" while the name is unknown.
String householdInitial(String? name) =>
    name == null || name.isEmpty ? '?' : name.substring(0, 1).toUpperCase();

/// The status-pill tone that matches an [ExpiryStatus].
StatusTone expiryTone(ExpiryStatus status) => switch (status) {
  ExpiryStatus.expired => StatusTone.error,
  ExpiryStatus.soon => StatusTone.warning,
  ExpiryStatus.fresh || ExpiryStatus.none => StatusTone.success,
};

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);
