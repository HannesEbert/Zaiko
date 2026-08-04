import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import '../../../household/application/households_providers.dart';
import '../../application/inventory_providers.dart';
import '../../application/inventory_view.dart';
import '../inventory_labels.dart';
import '../widgets/add_item_sheet.dart';
import '../widgets/inventory_item_row.dart';
import '../widgets/inventory_message.dart';
import '../widgets/storage_location_card.dart';
import 'item_detail_page.dart';
import 'location_detail_page.dart';
import 'trash_page.dart';

/// Inventory tab: the household food inventory, organized by storage location,
/// with the quick-stats strip and the "recently added" list. Data comes from
/// the Supabase-backed inventory providers, scoped to the active household.
class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  static const String routePath = '/inventory';
  static const String routeName = 'inventory';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final summaries = ref.watch(locationSummariesProvider);
    final stats = ref.watch(quickStatsProvider);
    final recent = ref.watch(recentlyAddedItemsProvider);
    final household = ref.watch(currentHouseholdProvider);

    final subtitle = switch ((stats, summaries)) {
      (AsyncData(:final value), AsyncData(value: final locations)) =>
        l10n.inventorySubtitle(value.total, locations.length),
      _ => '',
    };

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
              subtitle: subtitle,
              trailing: Row(
                children: [
                  HeaderIconButton(
                    icon: Icons.delete_outline,
                    onTap: () => TrashPage.open(context),
                    tooltip: l10n.inventoryTrashTooltip,
                  ),
                  const SizedBox(width: AppSpacing.s3),
                  HeaderIconButton(
                    icon: Icons.notifications_none,
                    showDot: true,
                    onTap: () {},
                  ),
                  const SizedBox(width: AppSpacing.s3),
                  UserAvatar(
                    initial: householdInitial(household.asData?.value?.name),
                  ),
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
            summaries.when(
              loading: () => const InventoryLoading(height: 158),
              error: (_, _) => InventoryError(
                onRetry: () => ref.invalidate(inventoryItemsProvider),
              ),
              data: (locations) => _LocationGrid(locations: locations),
            ),
            const SizedBox(height: AppSpacing.s6),
            stats.when(
              loading: () => const InventoryLoading(height: 64),
              error: (_, _) => const SizedBox.shrink(),
              data: (value) => _QuickStats(stats: value),
            ),
            const SizedBox(height: AppSpacing.s6),
            SectionLabel(
              l10n.inventoryRecentlyAdded,
              trailing: SeeAllLink(onTap: () {}),
            ),
            const SizedBox(height: AppSpacing.s3),
            recent.when(
              loading: () => const InventoryLoading(),
              error: (_, _) => InventoryError(
                onRetry: () => ref.invalidate(inventoryItemsProvider),
              ),
              data: (items) => items.isEmpty
                  ? InventoryEmptyLine(l10n.inventoryRecentlyAddedEmpty)
                  : CardList(
                      children: [
                        for (final resolved in items)
                          InventoryItemRow(
                            resolved,
                            trailing: ItemRowTrailing.addedDate,
                            showLocation: true,
                            onTap: () => _openDetail(context, resolved),
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, ResolvedItem resolved) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).push(MaterialPageRoute<void>(builder: (_) => ItemDetailPage(resolved)));
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
        // Fixed height keeps the card content from overflowing on narrower
        // phones (unlike a width-derived aspect ratio).
        mainAxisExtent: 158,
      ),
      children: [
        for (final summary in locations)
          StorageLocationCard(
            summary,
            onTap: () => LocationDetailPage.open(context, summary.location),
          ),
      ],
    );
  }
}

/// The design's quick-stats strip: expiring / expired / fresh counters
/// separated by hairline dividers.
class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.stats});

  final InventoryStats stats;

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
            value: '${stats.soon}',
            label: l10n.inventoryStatExpiring,
            color: colors.accentText,
          ),
          const _StatDivider(),
          _Stat(
            value: '${stats.expired}',
            label: l10n.inventoryStatExpired,
            color: colors.error,
          ),
          const _StatDivider(),
          _Stat(
            value: '${stats.fresh}',
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
