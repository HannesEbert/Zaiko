import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/empty_state.dart';

/// Landing page of the app: the household food inventory.
///
/// Placeholder for now — the actual inventory list arrives with the first
/// feature issue.
class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  static const String routePath = '/';
  static const String routeName = 'inventory';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: const EmptyState(
        icon: Icons.kitchen_outlined,
        title: 'Your inventory is empty',
        message: 'Items you add to your fridge and pantry will show up here.',
      ),
    );
  }
}
