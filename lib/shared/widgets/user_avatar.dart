import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';

/// A rounded-square avatar showing a single initial, matching the design's
/// `rounded-xl` header avatar.
///
/// [accent] renders solid indigo with white text (the current user);
/// otherwise a neutral tint is used for other household members.
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
        color: accent ? colors.accent : colors.sunken,
        borderRadius: BorderRadius.circular(size / 3),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: 2),
      ),
      child: Text(
        initial,
        style: AppTypography.caption.copyWith(
          fontSize: size * 0.38,
          fontWeight: FontWeight.w700,
          color: accent ? colors.onAccent : colors.textStrong,
        ),
      ),
    );
  }
}
