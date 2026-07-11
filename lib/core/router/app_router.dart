import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/inventory/presentation/pages/inventory_page.dart';

/// Central route table. Every feature registers its routes here so there is
/// a single place to see how the app is navigated.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: InventoryPage.routePath,
    routes: [
      GoRoute(
        path: InventoryPage.routePath,
        name: InventoryPage.routeName,
        builder: (context, state) => const InventoryPage(),
      ),
    ],
  );
});
