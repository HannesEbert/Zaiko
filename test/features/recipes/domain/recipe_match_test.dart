import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/recipes/domain/recipe.dart';
import 'package:zaiko/features/recipes/domain/recipe_ingredient.dart';
import 'package:zaiko/features/recipes/domain/recipe_match.dart';

void main() {
  Recipe recipeWith(List<String> ingredientNames) {
    final now = DateTime.utc(2026);
    return Recipe(
      id: 'r1',
      householdId: 'hh-1',
      title: 'Test',
      createdAt: now,
      updatedAt: now,
      ingredients: [
        for (final (index, name) in ingredientNames.indexed)
          RecipeIngredient(
            id: 'r1-$index',
            recipeId: 'r1',
            name: name,
            sortOrder: index,
          ),
      ],
    );
  }

  group('normalizeIngredientName', () {
    test('trims, lower-cases and collapses whitespace', () {
      expect(normalizeIngredientName('  Äpfel '), 'äpfel');
      expect(normalizeIngredientName('Bio   Milch'), 'bio milch');
    });
  });

  group('matchRecipe', () {
    test('splits ingredients into matched and missing by normalized name', () {
      final match = matchRecipe(
        recipeWith(['Milch', 'Eier']),
        stockNames: {'milch'},
        expiringNames: const {},
      );

      expect(match.matchedCount, 1);
      expect(match.totalCount, 2);
      expect(match.missing.map((i) => i.name), ['Eier']);
      expect(match.isComplete, isFalse);
      expect(match.usesExpiring, isFalse);
    });

    test('is complete when every ingredient is in stock', () {
      final match = matchRecipe(
        recipeWith(['Milch', 'Butter']),
        stockNames: {'milch', 'butter'},
        expiringNames: const {},
      );

      expect(match.isComplete, isTrue);
      expect(match.missing, isEmpty);
    });

    test('flags expiring stock and counts how many items it uses up', () {
      final match = matchRecipe(
        recipeWith(['Butter', 'Milch', 'Eier']),
        stockNames: {'butter', 'milch'},
        expiringNames: {'butter'},
      );

      expect(match.usesExpiring, isTrue);
      expect(match.expiringCount, 1);
      expect(match.matchedCount, 2);
      expect(match.missing.map((i) => i.name), ['Eier']);
    });

    test('matches case- and whitespace-insensitively', () {
      final match = matchRecipe(
        recipeWith(['  ÄPFEL ']),
        stockNames: {'äpfel'},
        expiringNames: const {},
      );

      expect(match.isComplete, isTrue);
    });
  });
}
