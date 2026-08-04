import 'inventory_view.dart';

/// How a [ResolvedItem] list is ordered in the searchable inventory views.
enum InventorySortMode {
  /// Newest first by creation date — the default, matching the upstream order.
  recentlyAdded,

  /// Alphabetically by name (case-insensitive).
  nameAsc,

  /// By best-before date, soonest first; items without a date go last.
  expiry,
}

/// Pure query helpers over the resolved inventory list, kept out of the widgets
/// so search, sorting and the "recently added" window are computed in one place
/// and unit-testable.

/// Returns the items whose name contains [query] (case-insensitive, trimmed).
/// An empty or whitespace-only query returns the list unchanged.
List<ResolvedItem> filterResolvedItemsByQuery(
  List<ResolvedItem> items,
  String query,
) {
  final needle = query.trim().toLowerCase();
  if (needle.isEmpty) return items;
  return items
      .where((item) => item.item.name.toLowerCase().contains(needle))
      .toList();
}

/// Returns a new list of [items] ordered by [mode]. The input is not mutated.
List<ResolvedItem> sortResolvedItems(
  List<ResolvedItem> items,
  InventorySortMode mode,
) {
  final sorted = [...items];
  switch (mode) {
    case InventorySortMode.recentlyAdded:
      sorted.sort((a, b) => b.item.createdAt.compareTo(a.item.createdAt));
    case InventorySortMode.nameAsc:
      sorted.sort(
        (a, b) =>
            a.item.name.toLowerCase().compareTo(b.item.name.toLowerCase()),
      );
    case InventorySortMode.expiry:
      sorted.sort(_byExpiry);
  }
  return sorted;
}

/// Best-before ascending; items without a date sort after those with one.
int _byExpiry(ResolvedItem a, ResolvedItem b) {
  final da = a.item.bestBefore;
  final db = b.item.bestBefore;
  if (da == null && db == null) return 0;
  if (da == null) return 1;
  if (db == null) return -1;
  return da.compareTo(db);
}

/// Returns the items created within [window] before [now], newest first — the
/// home tab's "recently added" list. Defaults to the last three days.
List<ResolvedItem> recentlyAddedWithin(
  List<ResolvedItem> items,
  DateTime now, {
  Duration window = const Duration(days: 3),
}) {
  final cutoff = now.subtract(window);
  final recent = items
      .where((item) => !item.item.createdAt.isBefore(cutoff))
      .toList();
  return sortResolvedItems(recent, InventorySortMode.recentlyAdded);
}
