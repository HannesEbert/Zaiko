import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state.dart';

/// Landing page of the recipes feature.
///
/// Placeholder for now — recipe suggestions based on the inventory arrive with
/// the recipes feature issue.
class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  static const String routePath = '/recipes';
  static const String routeName = 'recipes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipes')),
      body: const EmptyState(
        icon: Icons.menu_book_outlined,
        title: 'No recipes yet',
        message: 'Recipe ideas from what you have in stock will show up here.',
      ),
    );
  }
}
