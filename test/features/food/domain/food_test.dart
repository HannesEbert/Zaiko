import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/food/domain/food.dart';

void main() {
  group('Food', () {
    test('create() mints a non-empty UUID and equal timestamps', () {
      final food = Food.create(name: 'Milk', source: FoodSource.custom);

      expect(food.id, isNotEmpty);
      expect(food.deletedAt, isNull);
      expect(food.createdAt, equals(food.updatedAt));
      expect(food.createdAt.isUtc, isTrue);
    });

    test('create() generates a unique id per call', () {
      final a = Food.create(name: 'Milk', source: FoodSource.custom);
      final b = Food.create(name: 'Milk', source: FoodSource.custom);

      expect(a.id, isNot(equals(b.id)));
    });

    test('survives a toJson/fromJson round-trip', () {
      final original = Food.create(
        name: 'Nutella',
        source: FoodSource.openFoodFacts,
        brand: 'Ferrero',
        barcode: '3017620422003',
        imageUrl: 'https://example.test/nutella.png',
        householdId: 'household-1',
      );

      final restored = Food.fromJson(original.toJson());

      expect(restored, equals(original));
      expect(restored.source, equals(FoodSource.openFoodFacts));
    });

    test('serialises the source enum to its stable string value', () {
      final food = Food.create(name: 'Apple', source: FoodSource.openFoodFacts);

      expect(food.toJson()['source'], equals('openFoodFacts'));
    });
  });
}
