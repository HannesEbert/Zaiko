import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// A round avatar showing a single initial on a tinted background.
///
/// [accent] uses the brand-green tint (the current user); otherwise a neutral
/// tint is used for other household members.
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.initial,
    this.size = 36,
    this.accent = true,
    this.borderColor,
    super.key,
  });

  final String initial;
  final double size;
  final bool accent;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent ? colors.accentMuted : colors.sunken,
        shape: BoxShape.circle,
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: 2),
      ),
      child: Text(
        initial,
        style: AppTypography.caption.copyWith(
          fontSize: size * 0.36,
          fontWeight: FontWeight.w600,
          color: accent ? colors.accentText : colors.textStrong,
        ),
      ),
    );
  }
}
