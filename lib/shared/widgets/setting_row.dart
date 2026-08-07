import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// A single tappable settings line: leading [icon], [label], and an optional
/// right-hand accessory.
///
/// Used inside a [CardList] for the grouped settings look. Pass [trailing] for a
/// custom accessory (e.g. a switch or a check), [value] for a caption plus a
/// chevron, or neither with an [onTap] for a bare chevron. With none of those it
/// renders as a plain, non-tappable info row.
class SettingRow extends StatelessWidget {
  const SettingRow({
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
    this.onTap,
    super.key,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s3 + 2,
          vertical: AppSpacing.s3,
        ),
        child: Row(
          children: [
            Icon(icon, size: 19, color: colors.textStrong),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Text(
                label,
                style: AppTypography.body.copyWith(color: colors.textPrimary),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (value != null) ...[
              Text(
                value!,
                style: AppTypography.caption.copyWith(
                  fontSize: 14,
                  color: colors.textSecondary,
                ),
              ),
              if (onTap != null) ...[
                const SizedBox(width: AppSpacing.s1 + 2),
                Icon(Icons.chevron_right, size: 16, color: colors.borderStrong),
              ],
            ] else if (onTap != null)
              Icon(Icons.chevron_right, size: 16, color: colors.borderStrong),
          ],
        ),
      ),
    );
  }
}
