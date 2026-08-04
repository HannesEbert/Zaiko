import 'package:flutter/material.dart';

/// Maps the Material icon *identifiers* stored on categories and storage
/// locations (e.g. `kitchen`, `eco`) to concrete [IconData].
///
/// The lookup is an explicit const map, not a dynamic `IconData(codePoint)`:
/// Flutter tree-shakes icon fonts and only keeps icons referenced as compile-
/// time constants, so a runtime-built [IconData] would render as a blank box in
/// release builds. Extend the map when the seed data gains a new icon key.
abstract final class AppIcons {
  /// Resolves a stored icon [key] to its [IconData], falling back to a neutral
  /// inventory icon for unknown or null keys.
  static IconData forKey(String? key) => _byKey[key] ?? _fallback;

  /// The icon keys offered in the category / location editor, in display order.
  /// Every key resolves through [forKey].
  static const List<String> selectableKeys = [
    'kitchen',
    'ac_unit',
    'inventory_2',
    'local_drink',
    'eco',
    'set_meal',
    'egg',
    'bakery_dining',
    'ramen_dining',
    'cake',
    'soup_kitchen',
    'takeout_dining',
    'cookie',
    'coffee',
    'local_bar',
    'category',
  ];

  static const IconData _fallback = Icons.inventory_2_outlined;

  static const Map<String, IconData> _byKey = {
    // Storage-location defaults.
    'kitchen': Icons.kitchen_outlined,
    'ac_unit': Icons.ac_unit_outlined,
    'inventory_2': Icons.inventory_2_outlined,
    'local_drink': Icons.local_drink_outlined,
    // Category defaults (see the storage_locations_categories migration).
    'eco': Icons.eco_outlined,
    'set_meal': Icons.set_meal_outlined,
    'egg': Icons.egg_outlined,
    'bakery_dining': Icons.bakery_dining_outlined,
    'ramen_dining': Icons.ramen_dining_outlined,
    'cake': Icons.cake_outlined,
    'soup_kitchen': Icons.soup_kitchen_outlined,
    'takeout_dining': Icons.takeout_dining_outlined,
    'cookie': Icons.cookie_outlined,
    'coffee': Icons.coffee_outlined,
    'local_bar': Icons.local_bar_outlined,
    'category': Icons.category_outlined,
  };
}
