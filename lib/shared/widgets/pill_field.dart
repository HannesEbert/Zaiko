import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// A tappable, input-styled pill with a leading icon and hint text.
///
/// Used as the (non-editing) entry point for search and quick-add fields; a tap
/// would open the real input flow once implemented.
class PillField extends StatelessWidget {
  const PillField({
    required this.icon,
    required this.hint,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String hint;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.field,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Container(
          height: AppSpacing.hitTarget,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3 + 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Row(
            children: [
              Icon(icon, size: 18, color: colors.textTertiary),
              const SizedBox(width: AppSpacing.s2 + 2),
              Text(
                hint,
                style: AppTypography.body.copyWith(color: colors.textTertiary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
