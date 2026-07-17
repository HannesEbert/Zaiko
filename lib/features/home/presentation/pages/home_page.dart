import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/header_icon_button.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/pill_field.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../../shared/widgets/see_all_link.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../../shared/widgets/zaiko_card.dart';
import '../../../inventory/presentation/inventory_demo_data.dart';
import '../../../inventory/presentation/pages/location_detail_page.dart';
import '../../../inventory/presentation/widgets/add_item_sheet.dart';
import '../../../inventory/presentation/widgets/storage_location_card.dart';

/// Home tab, following the Figma "Start" screen: greeting header with bell and
/// avatar, a search field, the horizontal "expiring soon" rail and the
/// category grid.
///
/// Demo content; composed from the shared design components so it reads as one
/// system with the other tabs.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routePath = '/home';
  static const String routeName = 'home';

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
              title: l10n.homeGreeting('Hannes'),
              subtitle: l10n.homeExpiringCount(InventoryDemoData.expiringCount),
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
              hint: l10n.homeSearchHint,
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.s6),
            SectionLabel(
              l10n.homeExpiringSoon,
              trailing: SeeAllLink(onTap: () {}),
            ),
            const SizedBox(height: AppSpacing.s3),
            const _ExpiringRail(),
            const SizedBox(height: AppSpacing.s6),
            SectionLabel(l10n.homeCategories),
            const SizedBox(height: AppSpacing.s3),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: AppSpacing.s3,
                crossAxisSpacing: AppSpacing.s3,
                mainAxisExtent: 128,
              ),
              children: [
                for (final location in InventoryDemoData.locations)
                  StorageLocationCard(
                    location,
                    showStatus: false,
                    onTap: () => LocationDetailPage.open(context, location),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontally scrolling rail of items that expire soon.
class _ExpiringRail extends StatelessWidget {
  const _ExpiringRail();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: InventoryDemoData.expiringSoon.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s3),
        itemBuilder: (context, index) =>
            _ExpiringCard(item: InventoryDemoData.expiringSoon[index]),
      ),
    );
  }
}

class _ExpiringCard extends StatelessWidget {
  const _ExpiringCard({required this.item});

  final InventoryItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      width: 160,
      child: ZaikoCard(
        padding: const EdgeInsets.all(AppSpacing.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconTile(item.icon, color: item.color, size: 32, iconSize: 16),
            const SizedBox(height: AppSpacing.s3),
            Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.trailing!,
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: colors.error,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
