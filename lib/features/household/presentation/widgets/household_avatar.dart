import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// A neutral member avatar: a rounded-square with a person glyph.
///
/// Members have no display name or photo yet (identity arrives with the
/// `profiles` feature), so the roster uses this placeholder — [accent] marks the
/// current user in indigo, others use the neutral surface.
class HouseholdAvatar extends StatelessWidget {
  const HouseholdAvatar({
    this.accent = false,
    this.size = 36,
    this.borderColor,
    super.key,
  });

  final bool accent;
  final double size;
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
      child: Icon(
        Icons.person,
        size: size * 0.55,
        color: accent ? colors.onAccent : colors.textStrong,
      ),
    );
  }
}
