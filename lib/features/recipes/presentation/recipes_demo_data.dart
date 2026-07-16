import '../../../shared/widgets/status_pill.dart';

/// Placeholder recipe data used to render the UI before recipe suggestions are
/// derived from the real inventory. Demo content only.
abstract final class RecipesDemoData {
  static const List<String> filters = [
    'Alle',
    'Fast vollständig',
    'Unter 30 Min',
  ];

  static const List<Recipe> recipes = [
    Recipe(
      title: 'Spinat-Ricotta-Pasta',
      meta: '25 Min · 4 Portionen',
      matchLabel: '6/8 Zutaten',
      matchTone: StatusTone.warning,
      missing: ['Ricotta', 'Parmesan'],
    ),
    Recipe(
      title: 'Shakshuka',
      meta: '30 Min · 2 Portionen',
      matchLabel: 'Alle Zutaten da',
      matchTone: StatusTone.success,
    ),
  ];
}

/// A recipe suggestion card.
class Recipe {
  const Recipe({
    required this.title,
    required this.meta,
    required this.matchLabel,
    required this.matchTone,
    this.missing = const [],
  });

  final String title;
  final String meta;
  final String matchLabel;
  final StatusTone matchTone;

  /// Ingredients not currently in stock; empty when all are available.
  final List<String> missing;
}
