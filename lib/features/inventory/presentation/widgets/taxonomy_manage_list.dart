import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../../../shared/widgets/status_pill.dart';

/// One row of the taxonomy management list. [editable] is false for the
/// app-wide default categories, which are shown but cannot be edited or deleted.
class TaxonomyManageItem {
  const TaxonomyManageItem({
    required this.id,
    required this.name,
    required this.editable,
    this.color,
    this.icon,
  });

  final String id;
  final String name;
  final bool editable;
  final String? color;
  final String? icon;
}

/// The shared body of the storage-location and category management screens: a
/// card list of rows with edit/delete affordances (or a "default" badge), or an
/// empty-state line. The owning page maps its provider data to [items] and
/// wires [onEdit]/[onDelete] to the matching controller.
class TaxonomyManageList extends StatelessWidget {
  const TaxonomyManageList({
    required this.items,
    required this.emptyLabel,
    required this.onEdit,
    required this.onDelete,
    super.key,
  });

  final List<TaxonomyManageItem> items;
  final String emptyLabel;
  final ValueChanged<TaxonomyManageItem> onEdit;
  final ValueChanged<TaxonomyManageItem> onDelete;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
        child: Text(
          emptyLabel,
          style: AppTypography.body.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      );
    }

    return CardList(
      children: [
        for (final item in items)
          _Row(
            item: item,
            onEdit: () => onEdit(item),
            onDelete: () => onDelete(item),
          ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final TaxonomyManageItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3 + 2,
        vertical: AppSpacing.s2 + 2,
      ),
      child: Row(
        children: [
          IconTile(
            AppIcons.forKey(item.icon),
            color: AppColors.categoryForKey(item.color),
            size: 40,
            iconSize: 20,
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Text(
              item.name,
              style: AppTypography.bodyMedium.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
          if (item.editable) ...[
            _IconButton(
              icon: Icons.edit_outlined,
              tooltip: l10n.manageEdit,
              color: colors.textSecondary,
              onTap: onEdit,
            ),
            _IconButton(
              icon: Icons.delete_outline,
              tooltip: l10n.manageDelete,
              color: colors.error,
              onTap: onDelete,
            ),
          ] else
            StatusPill(l10n.manageDefaultBadge, tone: StatusTone.neutral),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, size: 20, color: color),
      tooltip: tooltip,
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Asks the user to confirm deleting a taxonomy row, spelling out how many items
/// will lose their assignment. Returns whether the user confirmed.
Future<bool> confirmTaxonomyDelete(
  BuildContext context, {
  required String title,
  required int affectedCount,
}) async {
  final l10n = context.l10n;
  final result = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(title),
      content: Text(l10n.manageDeleteItemsWarning(affectedCount)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.commonCancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          style: TextButton.styleFrom(foregroundColor: context.colors.error),
          child: Text(l10n.manageDeleteConfirm),
        ),
      ],
    ),
  );
  return result ?? false;
}
