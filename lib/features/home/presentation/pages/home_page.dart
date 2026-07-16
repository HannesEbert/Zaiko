import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../../shared/widgets/zaiko_card.dart';
import '../../../inventory/presentation/inventory_demo_data.dart';
import '../../../inventory/presentation/widgets/inventory_item_row.dart';

/// Home tab: a household overview with quick stats and items expiring soon.
///
/// Demo content; composed from the shared design components so it reads as one
/// system with the other tabs.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routePath = '/home';
  static const String routeName = 'home';

  static const List<_ExpiringItem> _expiring = [
    _ExpiringItem(
      item: InventoryItem(
        name: 'Bio Vollmilch',
        subtitle: '1 l · Kühlschrank',
        icon: Icons.local_drink_outlined,
      ),
      label: 'Noch 2 Tage',
      tone: StatusTone.warning,
    ),
    _ExpiringItem(
      item: InventoryItem(
        name: 'Hähnchenbrust',
        subtitle: '400 g · Kühlschrank',
        icon: Icons.set_meal_outlined,
      ),
      label: 'Heute',
      tone: StatusTone.error,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
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
              title: l10n.homeGreeting('Hannes'),
              subtitle: l10n.homeSubtitle(InventoryDemoData.householdName),
              trailing: const UserAvatar(initial: 'H'),
            ),
            const SizedBox(height: AppSpacing.s5),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    value: '${InventoryDemoData.itemCount}',
                    label: l10n.homeStatItems,
                  ),
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: _StatCard(
                    value: '3',
                    label: l10n.homeStatExpiring,
                    tone: StatusTone.warning,
                  ),
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: _StatCard(value: '11', label: l10n.homeStatShopping),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s5),
            SectionLabel(l10n.homeExpiringSoon),
            const SizedBox(height: AppSpacing.s2),
            CardList(
              children: [
                for (final entry in _expiring)
                  InventoryItemRow(
                    entry.item,
                    trailing: StatusPill(entry.label, tone: entry.tone),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpiringItem {
  const _ExpiringItem({
    required this.item,
    required this.label,
    required this.tone,
  });

  final InventoryItem item;
  final String label;
  final StatusTone tone;
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label, this.tone});

  final String value;
  final String label;
  final StatusTone? tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final valueColor = switch (tone) {
      StatusTone.warning => colors.warning,
      StatusTone.error => colors.error,
      _ => colors.textPrimary,
    };

    return ZaikoCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: AppSpacing.s4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: AppTypography.title.copyWith(
              color: valueColor,
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.caption.copyWith(
              fontSize: 12,
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
