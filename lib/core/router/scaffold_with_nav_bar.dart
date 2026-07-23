import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../l10n/l10n_extension.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// App shell that hosts the main tabs behind a bottom navigation bar.
///
/// Wraps the [StatefulNavigationShell] built by the router's
/// [StatefulShellRoute], so each tab keeps its own navigation stack and scroll
/// state while switching between Home, Inventory, Shopping list, Recipes and
/// Profile. The bar is a custom flat design (icon + micro label) rather than a
/// Material [NavigationBar] to match the Zaiko design system.
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  /// The shell created by the router; also tracks the active branch index.
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.navBackground,
          border: Border(top: BorderSide(color: colors.borderSubtle)),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.s2),
            child: Row(
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home,
                  label: l10n.navHome,
                  index: 0,
                  navigationShell: navigationShell,
                ),
                _NavItem(
                  icon: Icons.kitchen_outlined,
                  activeIcon: Icons.kitchen,
                  label: l10n.navInventory,
                  index: 1,
                  navigationShell: navigationShell,
                ),
                _NavItem(
                  icon: Icons.shopping_cart_outlined,
                  activeIcon: Icons.shopping_cart,
                  label: l10n.navShopping,
                  index: 2,
                  navigationShell: navigationShell,
                ),
                _NavItem(
                  icon: Icons.menu_book_outlined,
                  activeIcon: Icons.menu_book,
                  label: l10n.navRecipes,
                  index: 3,
                  navigationShell: navigationShell,
                ),
                _NavItem(
                  icon: Icons.person_outline,
                  activeIcon: Icons.person,
                  label: l10n.navProfile,
                  index: 4,
                  navigationShell: navigationShell,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.index,
    required this.navigationShell,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int index;
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSelected = navigationShell.currentIndex == index;
    final color = isSelected ? colors.navSelected : colors.navUnselected;

    return Expanded(
      child: InkResponse(
        onTap: () => navigationShell.goBranch(
          index,
          // Re-tapping the active tab resets it to its initial route.
          initialLocation: index == navigationShell.currentIndex,
        ),
        radius: 40,
        // The outer min-height Column keeps the bar exactly one item tall. A
        // Center here would instead stretch to the loose height the Scaffold
        // offers the bottom bar (the full screen), covering every page.
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.s1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s3,
                  vertical: AppSpacing.s1 + 2,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? colors.accentMuted : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected ? activeIcon : icon,
                      size: 20,
                      color: color,
                    ),
                    const SizedBox(height: AppSpacing.s1),
                    Text(
                      label,
                      style: AppTypography.micro.copyWith(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: color,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
