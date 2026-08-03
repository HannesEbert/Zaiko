import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../../../shared/widgets/zaiko_card.dart';
import '../../application/inventory_view.dart';

/// A single storage-location tile in the inventory grid: tinted icon, name,
/// item count and — unless [showStatus] is false — a status badge summarizing
/// how many of its items need attention.
class StorageLocationCard extends StatelessWidget {
  const StorageLocationCard(
    this.summary, {
    this.onTap,
    this.showStatus = true,
    super.key,
  });

  final LocationSummary summary;
  final VoidCallback? onTap;

  /// The home tab's category grid hides the status line.
  final bool showStatus;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return ZaikoCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.s4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(
            AppIcons.forKey(summary.location.icon),
            color: AppColors.categoryForKey(summary.location.color),
          ),
          const SizedBox(height: AppSpacing.s3),
          Text(
            summary.location.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.headline.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            l10n.inventoryItemsCount(summary.itemCount),
            style: AppTypography.caption.copyWith(
              color: colors.textSecondary,
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
          if (showStatus) ...[
            const SizedBox(height: AppSpacing.s3),
            _StatusBadge(summary: summary),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.summary});

  final LocationSummary summary;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final (color, icon, text) = switch (summary) {
      _ when summary.expiredCount > 0 => (
        colors.error,
        Icons.error_outline,
        l10n.inventoryLocationExpired(summary.expiredCount),
      ),
      _ when summary.soonCount > 0 => (
        colors.warning,
        Icons.schedule,
        l10n.inventoryLocationExpiringSoon(summary.soonCount),
      ),
      _ => (colors.success, Icons.check_circle_outline, l10n.inventoryAllFresh),
    };

    return Row(
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}
