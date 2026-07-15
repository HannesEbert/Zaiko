import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
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
      appBar: AppBar(title: Text(context.l10n.recipesTitle)),
      body: EmptyState(
        icon: Icons.menu_book_outlined,
        title: context.l10n.recipesEmptyTitle,
        message: context.l10n.recipesEmptyMessage,
      ),
    );
  }
}
