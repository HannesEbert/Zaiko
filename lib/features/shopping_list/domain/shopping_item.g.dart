// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShoppingItem _$ShoppingItemFromJson(Map<String, dynamic> json) =>
    _ShoppingItem(
      id: json['id'] as String,
      householdId: json['household_id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      quantity: json['quantity'] as String?,
      categoryId: json['category_id'] as String?,
      checked: json['checked'] as bool? ?? false,
      addedBy: json['added_by'] as String?,
    );

Map<String, dynamic> _$ShoppingItemToJson(_ShoppingItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'household_id': instance.householdId,
      'name': instance.name,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'quantity': instance.quantity,
      'category_id': instance.categoryId,
      'checked': instance.checked,
      'added_by': instance.addedBy,
    };
