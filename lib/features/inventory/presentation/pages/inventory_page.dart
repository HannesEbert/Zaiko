import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../auth/application/auth_providers.dart';

/// Landing page of the app: the household food inventory.
///
/// The list itself is still a placeholder; the actual inventory arrives with
/// the first feature issue.
class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  static const String routePath = '/inventory';
  static const String routeName = 'inventory';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          // Temporary home for sign-out until a dedicated profile/settings
          // screen exists.
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: const EmptyState(
        icon: Icons.kitchen_outlined,
        title: 'Your inventory is empty',
        message: 'Items you add to your fridge and pantry will show up here.',
      ),
    );
  }
}
