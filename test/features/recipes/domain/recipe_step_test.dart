import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/recipes/domain/recipe_step.dart';

void main() {
  test('round-trips a step without a timer', () {
    const step = RecipeStep(text: 'Chop the onions');

    final json = step.toJson();
    expect(json['text'], 'Chop the onions');
    expect(json['timer_seconds'], isNull);

    // A row stored before timers existed has no timer_seconds key.
    expect(RecipeStep.fromJson({'text': 'Chop the onions'}), step);
  });

  test('round-trips a step with a timer', () {
    const step = RecipeStep(text: 'Bake', timerSeconds: 900);

    final json = step.toJson();
    expect(json, {'text': 'Bake', 'timer_seconds': 900});
    expect(RecipeStep.fromJson(json), step);
  });
}
