import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// A rounded square holding an icon on a tinted background — the leading
/// element of location cards and list rows throughout the app.
class IconTile extends StatelessWidget {
  const IconTile(
    this.icon, {
    this.size = 40,
    this.iconSize = 20,
    this.accent = false,
    super.key,
  });

  final IconData icon;
  final double size;
  final double iconSize;

  /// When true the tile uses the green wash + brand icon color; otherwise a
  /// neutral sunken tile with a strong-grey icon.
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: accent ? colors.accentWash : colors.sunken,
        borderRadius: BorderRadius.circular(AppRadius.sm + 2),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: accent ? colors.accentText : colors.textStrong,
      ),
    );
  }
}
