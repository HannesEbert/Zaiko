import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// A 36×36 rounded-square icon button used in page headers — the design's
/// bell, plus and filter buttons.
///
/// [filled] renders solid indigo (the Einkauf "add" button); otherwise a
/// bordered card surface. [showDot] adds the small orange notification dot.
class HeaderIconButton extends StatelessWidget {
  const HeaderIconButton({
    required this.icon,
    this.onTap,
    this.filled = false,
    this.showDot = false,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool filled;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(AppRadius.md);

    return Material(
      color: filled ? colors.accent : colors.card,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: filled ? null : Border.all(color: colors.borderSubtle),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: filled ? colors.onAccent : colors.textSecondary,
              ),
              if (showDot)
                Positioned(
                  top: 7,
                  right: 7,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.categoryOrange,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
