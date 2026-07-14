import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// App shell that hosts the main tabs behind a bottom navigation bar.
///
/// Wraps the [StatefulNavigationShell] built by the router's
/// [StatefulShellRoute], so each tab keeps its own navigation stack and scroll
/// state while switching between Inventory, Shopping list and Recipes.
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  /// The shell created by the router; also tracks the active branch index.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.kitchen_outlined),
            selectedIcon: Icon(Icons.kitchen),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Shopping',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Recipes',
          ),
        ],
      ),
    );
  }

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      // Re-tapping the active tab resets it to its initial route.
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
