import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// A rounded square holding an icon on a tinted background — the leading
/// element of location cards and list rows throughout the app.
class IconTile extends StatelessWidget {
  const IconTile(
    this.icon, {
    this.color,
    this.size = 40,
    this.iconSize = 20,
    this.accent = false,
    super.key,
  });

  final IconData icon;
  final double size;
  final double iconSize;

  /// Category color for the icon; the background is the same color at 12%
  /// alpha, matching the design's tinted tiles. Takes precedence over
  /// [accent].
  final Color? color;

  /// When true (and [color] is null) the tile uses the indigo wash + brand
  /// icon color; otherwise a neutral sunken tile with a grey icon.
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final (Color background, Color foreground) = switch ((color, accent)) {
      (final Color c, _) => (c.withValues(alpha: 0.12), c),
      (null, true) => (colors.accentWash, colors.accent),
      (null, false) => (colors.sunken, colors.textStrong),
    };

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        // Small tiles use the tighter radius, matching the design's
        // rounded-lg / rounded-xl split.
        borderRadius: BorderRadius.circular(
          size < 36 ? AppRadius.sm : AppRadius.md,
        ),
      ),
      child: Icon(icon, size: iconSize, color: foreground),
    );
  }
}
