import '../domain/category.dart';
import '../domain/expiry.dart';
import '../domain/inventory_item.dart';
import '../domain/storage_location.dart';

/// An inventory item joined with its category and storage location and tagged
/// with a computed [ExpiryStatus] — the read model the display screens consume.
///
/// Pure Dart (no Flutter types): the presentation layer maps the category's and
/// location's palette/icon keys to `AppColors`/`AppIcons`.
class ResolvedItem {
  const ResolvedItem({
    required this.item,
    required this.status,
    this.category,
    this.location,
  });

  final InventoryItem item;
  final ExpiryStatus status;

  /// The item's category, or null if it has none / it was deleted.
  final Category? category;

  /// The item's storage location, or null if it has none / it was deleted.
  final StorageLocation? location;
}

/// Aggregate counts for the inventory quick-stats strip.
class InventoryStats {
  const InventoryStats({
    required this.total,
    required this.fresh,
    required this.soon,
    required this.expired,
  });

  /// No items (used while there is no household or the inventory is empty).
  static const InventoryStats empty = InventoryStats(
    total: 0,
    fresh: 0,
    soon: 0,
    expired: 0,
  );

  final int total;

  /// Items that are neither expiring soon nor expired (includes items without
  /// a best-before date).
  final int fresh;
  final int soon;
  final int expired;
}

/// A storage location plus how many of its items need attention — the data
/// behind a location card's count and status badge.
class LocationSummary {
  const LocationSummary({
    required this.location,
    required this.itemCount,
    required this.soonCount,
    required this.expiredCount,
  });

  final StorageLocation location;
  final int itemCount;
  final int soonCount;
  final int expiredCount;
}
