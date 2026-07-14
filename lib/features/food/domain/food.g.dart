// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Food _$FoodFromJson(Map<String, dynamic> json) => _Food(
  id: json['id'] as String,
  name: json['name'] as String,
  source: $enumDecode(_$FoodSourceEnumMap, json['source']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  brand: json['brand'] as String?,
  barcode: json['barcode'] as String?,
  imageUrl: json['imageUrl'] as String?,
  householdId: json['householdId'] as String?,
  deletedAt: json['deletedAt'] == null
      ? null
      : DateTime.parse(json['deletedAt'] as String),
);

Map<String, dynamic> _$FoodToJson(_Food instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'source': _$FoodSourceEnumMap[instance.source]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
  'brand': instance.brand,
  'barcode': instance.barcode,
  'imageUrl': instance.imageUrl,
  'householdId': instance.householdId,
  'deletedAt': instance.deletedAt?.toIso8601String(),
};

const _$FoodSourceEnumMap = {
  FoodSource.openFoodFacts: 'openFoodFacts',
  FoodSource.custom: 'custom',
};
