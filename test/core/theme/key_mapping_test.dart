import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/theme/app_colors.dart';
import 'package:zaiko/core/theme/app_icons.dart';

void main() {
  group('AppColors.categoryForKey', () {
    test('maps known palette keys to their constants', () {
      expect(AppColors.categoryForKey('green'), AppColors.categoryGreen);
      expect(AppColors.categoryForKey('amber'), AppColors.categoryAmber);
      expect(AppColors.categoryForKey('purple'), AppColors.categoryPurple);
    });

    test('falls back to slate for unknown or null keys', () {
      expect(AppColors.categoryForKey(null), AppColors.categorySlate);
      expect(AppColors.categoryForKey('chartreuse'), AppColors.categorySlate);
    });
  });

  group('AppIcons.forKey', () {
    test('maps known icon identifiers to Material icons', () {
      expect(AppIcons.forKey('kitchen'), Icons.kitchen_outlined);
      expect(AppIcons.forKey('eco'), Icons.eco_outlined);
      expect(AppIcons.forKey('local_bar'), Icons.local_bar_outlined);
    });

    test('falls back to a neutral icon for unknown or null keys', () {
      expect(AppIcons.forKey(null), Icons.inventory_2_outlined);
      expect(AppIcons.forKey('spaceship'), Icons.inventory_2_outlined);
    });
  });
}
