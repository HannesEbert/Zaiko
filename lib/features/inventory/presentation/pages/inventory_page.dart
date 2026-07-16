import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/pill_field.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../inventory_demo_data.dart';
import '../widgets/add_item_sheet.dart';
import '../widgets/inventory_item_row.dart';
import '../widgets/storage_location_card.dart';
import 'item_detail_page.dart';

/// Inventory tab: the household food inventory, organized by storage location.
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
    final colors = context.colors;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddItemSheet(context),
        backgroundColor: colors.accent,
        foregroundColor: colors.onAccent,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageInset,
            AppSpacing.s3 + 2,
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
              trailing: const UserAvatar(initial: 'H'),
            ),
            const SizedBox(height: AppSpacing.s3 + 2),
            PillField(
              icon: Icons.search,
              hint: l10n.inventorySearchHint,
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.s5),
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
                  StorageLocationCard(location, onTap: () {}),
              ],
            ),
            const SizedBox(height: AppSpacing.s5),
            SectionLabel(l10n.inventoryRecentlyAdded),
            const SizedBox(height: AppSpacing.s2),
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
