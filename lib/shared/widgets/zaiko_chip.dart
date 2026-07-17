import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// A selectable filter pill. Selected is solid indigo with white text;
/// unselected is a bordered card-surface pill — the design's filter chips.
class ZaikoChip extends StatelessWidget {
  const ZaikoChip({
    required this.label,
    required this.selected,
    this.onTap,
    super.key,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(AppRadius.md);

    return Material(
      color: selected ? colors.accent : colors.card,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          height: 36,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: selected ? null : Border.all(color: colors.borderSubtle),
          ),
          child: Text(
            label,
            style: AppTypography.body.copyWith(
              fontWeight: FontWeight.w500,
              color: selected ? colors.onAccent : colors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
