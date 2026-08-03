// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storage_location.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StorageLocation _$StorageLocationFromJson(Map<String, dynamic> json) =>
    _StorageLocation(
      id: json['id'] as String,
      householdId: json['household_id'] as String,
      name: json['name'] as String,
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      icon: json['icon'] as String?,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$StorageLocationToJson(_StorageLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'household_id': instance.householdId,
      'name': instance.name,
      'sort_order': instance.sortOrder,
      'icon': instance.icon,
      'color': instance.color,
    };
