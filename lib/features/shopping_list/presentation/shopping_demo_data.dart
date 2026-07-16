/// Placeholder shopping-list data used to render the UI before the real,
/// collaborative list (Supabase-synced) exists. Demo content only.
abstract final class ShoppingDemoData {
  static const int doneCount = 4;
  static const int totalCount = 11;

  /// Fraction of the list that is done, for the progress bar.
  static double get progress => doneCount / totalCount;

  static const List<ShoppingSection> openSections = [
    ShoppingSection(
      title: 'Obst & Gemüse',
      items: [
        ShoppingItem(name: 'Bananen', trailing: '6 Stück'),
        ShoppingItem(name: 'Tomaten', memberInitial: 'M'),
      ],
    ),
    ShoppingSection(
      title: 'Milchprodukte',
      items: [
        ShoppingItem(name: 'Bio Vollmilch', trailing: '2 × 1 l'),
        ShoppingItem(name: 'Skyr', memberInitial: 'H'),
      ],
    ),
  ];

  static const List<ShoppingItem> doneItems = [
    ShoppingItem(name: 'Brot'),
    ShoppingItem(name: 'Eier'),
  ];
}

/// A titled group of shopping items (e.g. "Obst & Gemüse").
class ShoppingSection {
  const ShoppingSection({required this.title, required this.items});

  final String title;
  final List<ShoppingItem> items;
}

/// A single shopping-list entry.
class ShoppingItem {
  const ShoppingItem({required this.name, this.trailing, this.memberInitial});

  final String name;

  /// Quantity text shown on the trailing edge, if any.
  final String? trailing;

  /// Initial of the member who added it, shown as a small avatar, if any.
  final String? memberInitial;
}
