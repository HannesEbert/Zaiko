import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_item.freezed.dart';
part 'inventory_item.g.dart';

/// A single stocked article in a household's inventory.
///
/// Mirrors a `public.inventory_items` row. The three foreign keys ([foodId],
/// [categoryId], [storageLocationId]) are kept as raw ids; the presentation
/// layer resolves them against the household's [Category] and [StorageLocation]
/// lists. [deletedAt]/[updatedAt] carry the soft-delete + last-write-wins shape
/// used across the schema.
@freezed
abstract class InventoryItem with _$InventoryItem {
  const factory InventoryItem({
    required String id,
    @JsonKey(name: 'household_id') required String householdId,
    required String name,

    /// The size of one unit (e.g. `1.5` for a 1.5 L bottle); a placeholder `1`
    /// when the item has no measurable size (a plain count). See [unit].
    required num quantity,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,

    /// How many units are stocked (the "Anzahl"). The total is `count` ×
    /// [quantity]; a single item is `1`. Stepped down on the detail page.
    @Default(1) int count,

    /// Optional link to the product catalog (`foods`); null for ad-hoc items.
    @JsonKey(name: 'food_id') String? foodId,

    /// App-owned unit key for the per-unit size (g/kg/ml/l); null when the item
    /// is a plain count with no measurable size.
    String? unit,
    @JsonKey(name: 'category_id') String? categoryId,
    @JsonKey(name: 'storage_location_id') String? storageLocationId,

    /// Best-before date. Null means the item has no expiry and shows no status.
    @JsonKey(name: 'best_before') DateTime? bestBefore,

    /// The user who added the item; nulled out if their account is deleted.
    @JsonKey(name: 'added_by') String? addedBy,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
  }) = _InventoryItem;

  factory InventoryItem.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemFromJson(json);
}
