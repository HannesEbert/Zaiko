import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../../shared/widgets/zaiko_card.dart';
import '../inventory_demo_data.dart';

/// A single storage-location tile in the inventory grid: icon, name, item count
/// and a status line (a colored dot + text, or "Alles frisch").
class StorageLocationCard extends StatelessWidget {
  const StorageLocationCard(this.location, {this.onTap, super.key});

  final StorageLocation location;
  final VoidCallback? onTap;

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
          IconTile(location.icon, accent: true),
          const SizedBox(height: AppSpacing.s3),
          Text(
            location.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            l10n.inventoryItemsCount(location.itemCount),
            style: AppTypography.caption.copyWith(
              color: colors.textSecondary,
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.s2),
          _StatusLine(location: location),
        ],
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.location});

  final StorageLocation location;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final status = location.status;
    final tone = location.tone;

    if (status == null || tone == null) {
      return Text(
        context.l10n.inventoryAllFresh,
        style: AppTypography.caption.copyWith(
          fontSize: 12,
          color: colors.textTertiary,
        ),
      );
    }

    final color = tone == StatusTone.error ? colors.error : colors.warning;

    return Row(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(fontSize: 12, color: color),
          ),
        ),
      ],
    );
  }
}
