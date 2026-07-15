import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../shared/widgets/empty_state.dart';

/// Landing page of the collaborative shopping list.
///
/// Placeholder for now — the actual list arrives with the shopping-list
/// feature issue.
class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({super.key});

  static const String routePath = '/shopping-list';
  static const String routeName = 'shopping-list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.shoppingTitle)),
      body: EmptyState(
        icon: Icons.shopping_cart_outlined,
        title: context.l10n.shoppingEmptyTitle,
        message: context.l10n.shoppingEmptyMessage,
      ),
    );
  }
}
