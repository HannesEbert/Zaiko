/// Placeholder shopping-list data used to render the UI before the real,
/// collaborative list (Supabase-synced) exists. Demo content only.
abstract final class ShoppingDemoData {
  /// Filter chips above the list; the first entry is the "all" filter and is
  /// resolved via l10n at the call site.
  static const List<String> categories = ['Supermarkt', 'Drogerie'];

  static const List<ShoppingItem> items = [
    ShoppingItem(name: 'Haferdrink', detail: '2 × 1 l', category: 'Supermarkt'),
    ShoppingItem(name: 'Äpfel', detail: '1 kg', category: 'Supermarkt'),
    ShoppingItem(name: 'Brot', detail: '1 Laib', category: 'Supermarkt'),
    ShoppingItem(
      name: 'Spülmittel',
      detail: '1 Flasche',
      category: 'Drogerie',
      checked: true,
    ),
  ];

  /// Number of still-open items, for the header subtitle.
  static int get openCount => items.where((item) => !item.checked).length;
}

/// A single shopping-list entry.
class ShoppingItem {
  const ShoppingItem({
    required this.name,
    required this.detail,
    required this.category,
    this.checked = false,
  });

  final String name;

  /// Quantity text shown in the subtitle (e.g. "2 × 1 l").
  final String detail;

  /// Store category, shown in the subtitle and used by the filter chips.
  final String category;

  /// Whether the item is already ticked off (demo initial state).
  final bool checked;
}
