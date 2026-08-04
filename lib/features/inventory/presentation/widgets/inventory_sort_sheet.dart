import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../application/inventory_query.dart';

/// Shows the sort-mode picker as a modal bottom sheet and resolves to the chosen
/// [InventorySortMode], or null when dismissed. Shared by the searchable
/// inventory views (all-items and location detail).
Future<InventorySortMode?> showInventorySortSheet(
  BuildContext context,
  InventorySortMode current,
) {
  return showModalBottomSheet<InventorySortMode>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _InventorySortSheet(current: current),
  );
}

String _sortLabel(BuildContext context, InventorySortMode mode) {
  final l10n = context.l10n;
  return switch (mode) {
    InventorySortMode.recentlyAdded => l10n.inventorySortRecent,
    InventorySortMode.nameAsc => l10n.inventorySortName,
    InventorySortMode.expiry => l10n.inventorySortExpiry,
  };
}

class _InventorySortSheet extends StatelessWidget {
  const _InventorySortSheet({required this.current});

  final InventorySortMode current;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.s5,
            AppSpacing.s2,
            AppSpacing.s5,
            AppSpacing.s5,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.s3),
                  decoration: BoxDecoration(
                    color: colors.borderStrong,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
              Text(
                l10n.inventorySortTitle,
                style: AppTypography.headline.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.s4),
              CardList(
                children: [
                  for (final mode in InventorySortMode.values)
                    _SortOption(
                      label: _sortLabel(context, mode),
                      selected: mode == current,
                      onTap: () => Navigator.of(context).pop(mode),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortOption extends StatelessWidget {
  const _SortOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s3 + 2),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: selected ? colors.accentText : colors.textPrimary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
            if (selected) Icon(Icons.check, size: 18, color: colors.accentText),
          ],
        ),
      ),
    );
  }
}
