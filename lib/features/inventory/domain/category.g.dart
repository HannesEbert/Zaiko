// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Category _$CategoryFromJson(Map<String, dynamic> json) => _Category(
  id: json['id'] as String,
  name: json['name'] as String,
  isDefault: json['is_default'] as bool? ?? false,
  householdId: json['household_id'] as String?,
  icon: json['icon'] as String?,
  color: json['color'] as String?,
);

Map<String, dynamic> _$CategoryToJson(_Category instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'is_default': instance.isDefault,
  'household_id': instance.householdId,
  'icon': instance.icon,
  'color': instance.color,
};
