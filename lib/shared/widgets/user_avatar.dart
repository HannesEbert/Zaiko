import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import 'avatar_presets.dart';

/// A rounded-square avatar, matching the design's `rounded-xl` header avatar.
///
/// Renders one of three ways, in priority order:
///  * [preset] set — the preset's motif glyph on its palette colour;
///  * [backgroundColor] set — the [initial] in white on that colour (a per-user
///    identity colour, e.g. from [avatarColorForId]);
///  * otherwise — the [initial] using [accent] (solid indigo for the current
///    user, a neutral tint for others).
class UserAvatar extends StatelessWidget {
  const UserAvatar({
    required this.initial,
    this.preset,
    this.backgroundColor,
    this.size = 36,
    this.accent = true,
    this.borderColor,
    super.key,
  });

  final String initial;
  final AvatarPreset? preset;
  final Color? backgroundColor;
  final double size;
  final bool accent;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasColor = preset != null || backgroundColor != null;
    final background =
        preset?.color ??
        backgroundColor ??
        (accent ? colors.accent : colors.sunken);
    // Palette/identity colours are saturated, so white reads on them; the
    // neutral fallbacks keep their theme-aware foreground.
    final foreground = hasColor
        ? Colors.white
        : (accent ? colors.onAccent : colors.textStrong);

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(size / 3),
        border: borderColor == null
            ? null
            : Border.all(color: borderColor!, width: 2),
      ),
      child: preset != null
          ? Icon(preset!.icon, size: size * 0.5, color: foreground)
          : Text(
              initial,
              style: AppTypography.caption.copyWith(
                fontSize: size * 0.38,
                fontWeight: FontWeight.w700,
                color: foreground,
              ),
            ),
    );
  }
}
