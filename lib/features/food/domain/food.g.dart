// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Food _$FoodFromJson(Map<String, dynamic> json) => _Food(
  id: json['id'] as String,
  name: json['name'] as String,
  source: $enumDecode(_$FoodSourceEnumMap, json['source']),
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  brand: json['brand'] as String?,
  barcode: json['barcode'] as String?,
  imageUrl: json['image_url'] as String?,
  householdId: json['household_id'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
);

Map<String, dynamic> _$FoodToJson(_Food instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'source': _$FoodSourceEnumMap[instance.source]!,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'brand': instance.brand,
  'barcode': instance.barcode,
  'image_url': instance.imageUrl,
  'household_id': instance.householdId,
  'deleted_at': instance.deletedAt?.toIso8601String(),
};

const _$FoodSourceEnumMap = {
  FoodSource.openFoodFacts: 'openFoodFacts',
  FoodSource.custom: 'custom',
};
