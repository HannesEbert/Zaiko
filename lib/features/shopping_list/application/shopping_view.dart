import '../../inventory/domain/category.dart';
import '../domain/shopping_item.dart';

/// A shopping item joined with its category — the read model the shopping
/// screens consume.
///
/// Pure Dart (no Flutter types): the presentation layer maps the category's
/// palette/icon keys to `AppColors`/`AppIcons`.
class ResolvedShoppingItem {
  const ResolvedShoppingItem({required this.item, this.category});

  final ShoppingItem item;

  /// The item's category, or null if it has none / it was deleted.
  final Category? category;
}
