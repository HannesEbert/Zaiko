import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../inventory_demo_data.dart';

/// A tappable inventory list row: leading icon tile, name + subtitle, and an
/// optional trailing widget (a relative date or status pill).
class InventoryItemRow extends StatelessWidget {
  const InventoryItemRow(this.item, {this.trailing, this.onTap, super.key});

  final InventoryItem item;

  /// Overrides [InventoryItem.trailing]; use for a status pill instead of text.
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    Widget? trailingWidget = trailing;
    if (trailingWidget == null && item.trailing != null) {
      trailingWidget = Text(
        item.trailing!,
        style: AppTypography.caption.copyWith(
          fontSize: 13,
          color: colors.textTertiary,
          fontFeatures: AppTypography.tabularFigures,
        ),
      );
    }

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s3 + 2,
          vertical: AppSpacing.s3,
        ),
        child: Row(
          children: [
            IconTile(item.icon),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: AppTypography.bodyMedium.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    item.subtitle,
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (trailingWidget != null) ...[
              const SizedBox(width: AppSpacing.s2),
              trailingWidget,
            ],
          ],
        ),
      ),
    );
  }
}
