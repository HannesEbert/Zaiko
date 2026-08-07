// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: json['id'] as String,
  displayName: json['display_name'] as String,
  avatarPreset: json['avatar_preset'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  locale: json['locale'] as String?,
  allergens:
      (json['allergens'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  diets:
      (json['diets'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  dislikes:
      (json['dislikes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  dietaryNote: json['dietary_note'] as String?,
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'display_name': instance.displayName,
  'avatar_preset': instance.avatarPreset,
  'created_at': instance.createdAt.toIso8601String(),
  'locale': instance.locale,
  'allergens': instance.allergens,
  'diets': instance.diets,
  'dislikes': instance.dislikes,
  'dietary_note': instance.dietaryNote,
};
