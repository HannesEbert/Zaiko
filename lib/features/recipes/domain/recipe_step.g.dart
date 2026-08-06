// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecipeStep _$RecipeStepFromJson(Map<String, dynamic> json) => _RecipeStep(
  text: json['text'] as String,
  timerSeconds: (json['timer_seconds'] as num?)?.toInt(),
);

Map<String, dynamic> _$RecipeStepToJson(_RecipeStep instance) =>
    <String, dynamic>{
      'text': instance.text,
      'timer_seconds': instance.timerSeconds,
    };
