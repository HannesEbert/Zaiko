/// The fixed sets of dietary-preference keys the user can tick.
///
/// These are stable, app-internal keys persisted verbatim in the profile
/// (`allergens`/`diets`/`dislikes` arrays); only their display labels are
/// localized (see `context.l10n`). Keeping the source of truth here means the
/// picker UI, storage and any later recipe filtering all share one list.
abstract final class DietaryOptions {
  /// The 14 major allergens that must be declared under EU food law.
  static const List<String> allergens = [
    'gluten',
    'crustaceans',
    'eggs',
    'fish',
    'peanuts',
    'soy',
    'milk',
    'treeNuts',
    'celery',
    'mustard',
    'sesame',
    'sulphites',
    'lupin',
    'molluscs',
  ];

  /// Common diets and eating patterns.
  static const List<String> diets = [
    'vegetarian',
    'vegan',
    'pescetarian',
    'halal',
    'kosher',
    'glutenFree',
    'lactoseFree',
    'lowCarb',
  ];

  /// A few common dislikes offered as presets; free-text covers the rest.
  static const List<String> dislikes = [
    'coriander',
    'olives',
    'mushrooms',
    'offal',
    'blueCheese',
  ];
}
