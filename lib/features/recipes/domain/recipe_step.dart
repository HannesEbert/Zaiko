import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe_step.freezed.dart';
part 'recipe_step.g.dart';

/// A single step of a [Recipe]: the instruction plus an optional timer.
///
/// Stored as one object in the recipe's `steps` jsonb array. [timerSeconds] is
/// null for steps without a set duration (e.g. "chop the onions"); when present
/// it seeds the countdown the cook mode offers for that step (e.g. "bake for 15
/// min"). Steps carry no id — order in the array is their identity.
@freezed
abstract class RecipeStep with _$RecipeStep {
  const factory RecipeStep({
    required String text,

    /// Timer duration in seconds, or null when the step has no timer.
    @JsonKey(name: 'timer_seconds') int? timerSeconds,
  }) = _RecipeStep;

  factory RecipeStep.fromJson(Map<String, dynamic> json) =>
      _$RecipeStepFromJson(json);
}
