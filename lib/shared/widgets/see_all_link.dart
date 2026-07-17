import 'package:flutter/material.dart';

import '../../core/l10n/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// The accent-colored "Alle ›" link on section headers, as in the design.
class SeeAllLink extends StatelessWidget {
  const SeeAllLink({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.commonAll,
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.accentText,
            ),
          ),
          Icon(Icons.chevron_right, size: 14, color: colors.accentText),
        ],
      ),
    );
  }
}
