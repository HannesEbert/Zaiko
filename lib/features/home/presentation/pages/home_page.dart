import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
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
import '../../../household/application/households_providers.dart';
import '../../../inventory/application/inventory_providers.dart';
import '../../../inventory/application/inventory_view.dart';
import '../../../inventory/presentation/inventory_labels.dart';
import '../../../inventory/presentation/pages/all_items_page.dart';
import '../../../inventory/presentation/pages/location_detail_page.dart';
import '../../../inventory/presentation/widgets/add_item_sheet.dart';
import '../../../inventory/presentation/widgets/inventory_message.dart';
import '../../../inventory/presentation/widgets/storage_location_card.dart';

/// Home tab: greeting header with bell and avatar, a search field, the
/// horizontal "expiring soon" rail and the storage-location grid — all driven
/// by the active household's real inventory data.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  static const String routePath = '/home';
  static const String routeName = 'home';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final household = ref.watch(currentHouseholdProvider);
    final stats = ref.watch(quickStatsProvider);
    final expiring = ref.watch(expiringSoonItemsProvider);
    final summaries = ref.watch(locationSummariesProvider);

    final name = household.asData?.value?.name;
    final greeting = name == null
        ? l10n.homeGreetingGeneric
        : l10n.homeGreeting(name);
    final subtitle = stats.maybeWhen(
      data: (value) => l10n.homeExpiringCount(value.soon),
      orElse: () => '',
    );

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
              title: greeting,
              subtitle: subtitle,
              trailing: Row(
                children: [
                  HeaderIconButton(
                    icon: Icons.notifications_none,
                    showDot: true,
                    onTap: () {},
                  ),
                  const SizedBox(width: AppSpacing.s3),
                  UserAvatar(initial: householdInitial(name)),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s5),
            PillField(
              icon: Icons.search,
              hint: l10n.homeSearchHint,
              onTap: () => AllItemsPage.open(context),
            ),
            const SizedBox(height: AppSpacing.s6),
            SectionLabel(
              l10n.homeExpiringSoon,
              trailing: SeeAllLink(onTap: () {}),
            ),
            const SizedBox(height: AppSpacing.s3),
            expiring.when(
              loading: () => const InventoryLoading(height: 116),
              error: (_, _) => InventoryError(
                onRetry: () => ref.invalidate(inventoryItemsProvider),
              ),
              data: (items) => items.isEmpty
                  ? InventoryEmptyLine(l10n.homeExpiringEmpty)
                  : _ExpiringRail(items: items),
            ),
            const SizedBox(height: AppSpacing.s6),
            SectionLabel(l10n.homeCategories),
            const SizedBox(height: AppSpacing.s3),
            summaries.when(
              loading: () => const InventoryLoading(height: 128),
              error: (_, _) => InventoryError(
                onRetry: () => ref.invalidate(inventoryItemsProvider),
              ),
              data: (locations) => _LocationGrid(locations: locations),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationGrid extends StatelessWidget {
  const _LocationGrid({required this.locations});

  final List<LocationSummary> locations;

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.s3,
        crossAxisSpacing: AppSpacing.s3,
        mainAxisExtent: 128,
      ),
      children: [
        for (final summary in locations)
          StorageLocationCard(
            summary,
            showStatus: false,
            onTap: () => context.pushNamed(
              LocationDetailPage.homeRouteName,
              pathParameters: {'locationId': summary.location.id},
            ),
          ),
      ],
    );
  }
}

/// Horizontally scrolling rail of items that need attention soon.
class _ExpiringRail extends StatelessWidget {
  const _ExpiringRail({required this.items});

  final List<ResolvedItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s3),
        itemBuilder: (context, index) => _ExpiringCard(resolved: items[index]),
      ),
    );
  }
}

class _ExpiringCard extends StatelessWidget {
  const _ExpiringCard({required this.resolved});

  final ResolvedItem resolved;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final item = resolved.item;
    final label = expiryShortLabel(l10n, item.bestBefore) ?? '';

    return SizedBox(
      width: 160,
      child: ZaikoCard(
        padding: const EdgeInsets.all(AppSpacing.s4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconTile(
              AppIcons.forKey(resolved.category?.icon),
              color: AppColors.categoryForKey(resolved.category?.color),
              size: 32,
              iconSize: 16,
            ),
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
              label,
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
