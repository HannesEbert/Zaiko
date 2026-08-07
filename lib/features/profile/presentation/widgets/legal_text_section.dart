import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

/// A titled paragraph block for the static privacy and help screens: a heading
/// with body copy and bottom spacing unless it is the [isLast] section.
class LegalTextSection extends StatelessWidget {
  const LegalTextSection({
    required this.title,
    required this.body,
    this.isLast = false,
    super.key,
  });

  final String title;
  final String body;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.s6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.bodyMedium.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.s2),
          Text(
            body,
            style: AppTypography.body.copyWith(
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
