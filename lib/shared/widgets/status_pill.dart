import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';

/// Visual tone of a [StatusPill].
enum StatusTone { neutral, brand, success, warning, error }

/// A small rounded pill used for statuses, categories and counts
/// ("Läuft in 2 Tagen ab", "Milchprodukte", "Alle Zutaten da").
class StatusPill extends StatelessWidget {
  const StatusPill(this.label, {this.tone = StatusTone.neutral, super.key});

  final String label;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = switch (tone) {
      StatusTone.neutral => (colors.sunken, colors.textStrong),
      StatusTone.brand => (colors.accentMuted, colors.accentText),
      StatusTone.success => (colors.successBg, colors.success),
      StatusTone.warning => (colors.warningBg, colors.warning),
      StatusTone.error => (colors.errorBg, colors.error),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: AppTypography.micro.copyWith(
          color: foreground,
          letterSpacing: 0,
          fontFeatures: AppTypography.tabularFigures,
        ),
      ),
    );
  }
}
