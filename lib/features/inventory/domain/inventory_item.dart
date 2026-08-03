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
    required num quantity,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,

    /// Optional link to the product catalog (`foods`); null for ad-hoc items.
    @JsonKey(name: 'food_id') String? foodId,

    /// App-owned unit key (g/kg/ml/l/piece/package); null when unitless.
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
