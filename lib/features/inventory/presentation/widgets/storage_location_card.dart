import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../../shared/widgets/zaiko_card.dart';
import '../inventory_demo_data.dart';

/// A single storage-location tile in the inventory grid: tinted category
/// icon, name, item count and — unless [showStatus] is false — a status badge
/// (small icon + colored text, as in the design).
class StorageLocationCard extends StatelessWidget {
  const StorageLocationCard(
    this.location, {
    this.onTap,
    this.showStatus = true,
    super.key,
  });

  final StorageLocation location;
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
          IconTile(location.icon, color: location.color),
          const SizedBox(height: AppSpacing.s3),
          Text(
            location.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.headline.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            l10n.inventoryItemsCount(location.itemCount),
            style: AppTypography.caption.copyWith(
              color: colors.textSecondary,
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
          if (showStatus) ...[
            const SizedBox(height: AppSpacing.s3),
            _StatusBadge(location: location),
          ],
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.location});

  final StorageLocation location;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final (color, icon, text) = switch (location.tone) {
      StatusTone.error => (colors.error, Icons.error_outline, location.status!),
      StatusTone.warning => (colors.warning, Icons.schedule, location.status!),
      _ => (
        colors.success,
        Icons.check_circle_outline,
        context.l10n.inventoryAllFresh,
      ),
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
