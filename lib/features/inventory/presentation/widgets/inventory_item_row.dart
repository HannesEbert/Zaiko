import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../application/inventory_view.dart';
import '../../domain/expiry.dart';
import '../inventory_labels.dart';

/// What a row shows on its trailing edge.
enum ItemRowTrailing {
  /// Nothing.
  none,

  /// The item's expiry label ("In 2 Tagen", "Abgelaufen").
  expiry,

  /// When the item was added ("Gestern").
  addedDate,
}

/// A tappable inventory list row: category-tinted icon tile, name + subtitle
/// (quantity, unit and optionally the storage location) and a trailing label.
///
/// The visual accent comes from the item's category; items without a category
/// fall back to the neutral palette.
class InventoryItemRow extends StatelessWidget {
  const InventoryItemRow(
    this.resolved, {
    this.trailing = ItemRowTrailing.expiry,
    this.showLocation = false,
    this.onTap,
    super.key,
  });

  final ResolvedItem resolved;

  /// Which trailing label to render.
  final ItemRowTrailing trailing;

  /// Whether the subtitle appends the storage-location name.
  final bool showLocation;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final item = resolved.item;

    final icon = AppIcons.forKey(resolved.category?.icon);
    final color = AppColors.categoryForKey(resolved.category?.color);

    var subtitle = formatQuantity(l10n, item.quantity, item.unit);
    if (showLocation && resolved.location != null) {
      subtitle = '$subtitle · ${resolved.location!.name}';
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
            IconTile(icon, color: color, iconSize: 18),
            const SizedBox(width: AppSpacing.s4),
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
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            ..._buildTrailing(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTrailing(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final item = resolved.item;

    final (String? text, Color color) = switch (trailing) {
      ItemRowTrailing.none => (null, colors.textTertiary),
      ItemRowTrailing.addedDate => (
        addedRelativeLabel(l10n, item.createdAt),
        colors.textTertiary,
      ),
      ItemRowTrailing.expiry => (
        expiryShortLabel(l10n, item.bestBefore),
        switch (resolved.status) {
          ExpiryStatus.expired => colors.error,
          ExpiryStatus.soon => colors.warning,
          ExpiryStatus.fresh || ExpiryStatus.none => colors.textTertiary,
        },
      ),
    };

    if (text == null) return const [];
    return [
      const SizedBox(width: AppSpacing.s2),
      Text(
        text,
        style: AppTypography.caption.copyWith(
          fontSize: 13,
          color: color,
          fontFeatures: AppTypography.tabularFigures,
        ),
      ),
    ];
  }
}
