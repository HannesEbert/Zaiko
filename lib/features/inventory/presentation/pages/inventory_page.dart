import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../shared/widgets/empty_state.dart';

/// Landing page of the inventory tab: the household food inventory.
///
/// The list itself is still a placeholder; the actual inventory arrives with
/// the first feature issue. Sign-out now lives on the profile tab.
class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  static const String routePath = '/inventory';
  static const String routeName = 'inventory';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: EmptyState(
        icon: Icons.kitchen_outlined,
        title: context.l10n.inventoryEmptyTitle,
        message: context.l10n.inventoryEmptyMessage,
      ),
    );
  }
}
