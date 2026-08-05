import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_item.freezed.dart';
part 'shopping_item.g.dart';

/// A single entry on a household's collaborative shopping list.
///
/// Mirrors a `public.shopping_items` row. [categoryId] is kept as a raw id; the
/// presentation layer resolves it against the household's `Category` list.
/// Unlike inventory items, shopping items are hard-deleted (there is no
/// `deleted_at`); the `checked` flag marks an item as already bought.
@freezed
abstract class ShoppingItem with _$ShoppingItem {
  const factory ShoppingItem({
    required String id,
    @JsonKey(name: 'household_id') required String householdId,
    required String name,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,

    /// Free-form quantity text (e.g. "2 × 1 l"); null when unspecified. A
    /// structured quantity/unit is deferred (see ADR-0011).
    String? quantity,
    @JsonKey(name: 'category_id') String? categoryId,

    /// Whether the item has already been bought (ticked off the list).
    @Default(false) bool checked,

    /// The user who added the item; nulled out if their account is deleted.
    @JsonKey(name: 'added_by') String? addedBy,
  }) = _ShoppingItem;

  factory ShoppingItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingItemFromJson(json);
}
