// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Recipe _$RecipeFromJson(Map<String, dynamic> json) => _Recipe(
  id: json['id'] as String,
  householdId: json['household_id'] as String,
  title: json['title'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  totalMinutes: (json['total_minutes'] as num?)?.toInt(),
  servings: (json['servings'] as num?)?.toInt(),
  imageUrl: json['image_url'] as String?,
  steps:
      (json['steps'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  ingredients:
      (json['recipe_ingredients'] as List<dynamic>?)
          ?.map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <RecipeIngredient>[],
  createdBy: json['created_by'] as String?,
  deletedAt: json['deleted_at'] == null
      ? null
      : DateTime.parse(json['deleted_at'] as String),
);

Map<String, dynamic> _$RecipeToJson(_Recipe instance) => <String, dynamic>{
  'id': instance.id,
  'household_id': instance.householdId,
  'title': instance.title,
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'total_minutes': instance.totalMinutes,
  'servings': instance.servings,
  'image_url': instance.imageUrl,
  'steps': instance.steps,
  'recipe_ingredients': instance.ingredients,
  'created_by': instance.createdBy,
  'deleted_at': instance.deletedAt?.toIso8601String(),
};
