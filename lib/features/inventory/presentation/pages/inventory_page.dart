import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../../../shared/widgets/header_icon_button.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/pill_field.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../../shared/widgets/see_all_link.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../../shared/widgets/zaiko_card.dart';
import '../inventory_demo_data.dart';
import '../widgets/add_item_sheet.dart';
import '../widgets/inventory_item_row.dart';
import '../widgets/storage_location_card.dart';
import 'item_detail_page.dart';
import 'location_detail_page.dart';

/// Inventory tab: the household food inventory, organized by storage location,
/// with the quick-stats strip and the "recently added" list from the design.
///
/// Content is demo data (see [InventoryDemoData]); the layout is ready to bind
/// to real providers. The FAB opens the "add item" sheet.
class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  static const String routePath = '/inventory';
  static const String routeName = 'inventory';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddItemSheet(context),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageInset,
            AppSpacing.s6,
            AppSpacing.pageInset,
            AppSpacing.s10,
          ),
          children: [
            PageHeader(
              title: l10n.navInventory,
              subtitle: l10n.inventorySubtitle(
                InventoryDemoData.itemCount,
                InventoryDemoData.locations.length,
              ),
              trailing: Row(
                children: [
                  HeaderIconButton(
                    icon: Icons.notifications_none,
                    showDot: true,
                    onTap: () {},
                  ),
                  const SizedBox(width: AppSpacing.s3),
                  const UserAvatar(initial: 'H'),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s5),
            PillField(
              icon: Icons.search,
              hint: l10n.inventorySearchHint,
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.s6),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.s3,
                crossAxisSpacing: AppSpacing.s3,
                // Fixed height keeps the card content from overflowing on
                // narrower phones (unlike a width-derived aspect ratio).
                mainAxisExtent: 158,
              ),
              children: [
                for (final location in InventoryDemoData.locations)
                  StorageLocationCard(
                    location,
                    onTap: () => LocationDetailPage.open(context, location),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.s6),
            const _QuickStats(),
            const SizedBox(height: AppSpacing.s6),
            SectionLabel(
              l10n.inventoryRecentlyAdded,
              trailing: SeeAllLink(onTap: () {}),
            ),
            const SizedBox(height: AppSpacing.s3),
            CardList(
              children: [
                for (final item in InventoryDemoData.recentlyAdded)
                  InventoryItemRow(
                    item,
                    onTap: () => _openDetail(context, item),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, InventoryItem item) {
    Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            ItemDetailPage(title: item.name, subtitle: item.subtitle),
      ),
    );
  }
}

/// The design's quick-stats strip: expiring / expired / fresh counters
/// separated by hairline dividers.
class _QuickStats extends StatelessWidget {
  const _QuickStats();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return ZaikoCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s4,
        vertical: AppSpacing.s3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Stat(
            value: '${InventoryDemoData.expiringCount}',
            label: l10n.inventoryStatExpiring,
            color: colors.accentText,
          ),
          const _StatDivider(),
          _Stat(
            value: '${InventoryDemoData.expiredCount}',
            label: l10n.inventoryStatExpired,
            color: colors.error,
          ),
          const _StatDivider(),
          _Stat(
            value: '${InventoryDemoData.freshCount}',
            label: l10n.inventoryStatFresh,
            color: colors.success,
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.color});

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: AppTypography.headline.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: color,
            fontFeatures: AppTypography.tabularFigures,
          ),
        ),
        Text(
          label,
          style: AppTypography.caption.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 32, color: context.colors.divider);
  }
}
