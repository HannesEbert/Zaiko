// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InventoryItem _$InventoryItemFromJson(Map<String, dynamic> json) =>
    _InventoryItem(
      id: json['id'] as String,
      householdId: json['household_id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as num,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      count: (json['count'] as num?)?.toInt() ?? 1,
      foodId: json['food_id'] as String?,
      unit: json['unit'] as String?,
      categoryId: json['category_id'] as String?,
      storageLocationId: json['storage_location_id'] as String?,
      bestBefore: json['best_before'] == null
          ? null
          : DateTime.parse(json['best_before'] as String),
      addedBy: json['added_by'] as String?,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
    );

Map<String, dynamic> _$InventoryItemToJson(_InventoryItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'household_id': instance.householdId,
      'name': instance.name,
      'quantity': instance.quantity,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'count': instance.count,
      'food_id': instance.foodId,
      'unit': instance.unit,
      'category_id': instance.categoryId,
      'storage_location_id': instance.storageLocationId,
      'best_before': instance.bestBefore?.toIso8601String(),
      'added_by': instance.addedBy,
      'deleted_at': instance.deletedAt?.toIso8601String(),
    };
