import 'package:flutter/material.dart';

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
      appBar: AppBar(title: const Text('Shopping list')),
      body: const EmptyState(
        icon: Icons.shopping_cart_outlined,
        title: 'Your shopping list is empty',
        message: 'Items you need to buy will show up here.',
      ),
    );
  }
}
