import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Central theme definition — widgets read colors and text styles from
/// `Theme.of(context)` (and the [AppColors] extension) instead of hard-coding
/// them.
///
/// The palette is the Zaiko design system's exact tokens rather than a
/// generated `fromSeed` scheme, so brand green stays precise. Extra semantic
/// colors that Material's [ColorScheme] doesn't cover live in [AppColors].
abstract final class AppTheme {
  static ThemeData get light => _base(Brightness.light, AppColors.light);

  static ThemeData get dark => _base(Brightness.dark, AppColors.dark);

  static ThemeData _base(Brightness brightness, AppColors colors) {
    final isDark = brightness == Brightness.dark;

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: const Color(0xFF004225),
          brightness: brightness,
        ).copyWith(
          primary: colors.accent,
          onPrimary: colors.onAccent,
          surface: colors.card,
          onSurface: colors.textPrimary,
          error: colors.error,
        );

    return ThemeData(
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.pageBackground,
      splashFactory: InkSparkle.splashFactory,
      extensions: [colors],
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colors.pageBackground,
        foregroundColor: colors.textPrimary,
        titleTextStyle: AppTypography.headline.copyWith(
          color: colors.textPrimary,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colors.divider,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? colors.card : const Color(0xFF1E1E1E),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.field,
        hintStyle: AppTypography.body.copyWith(color: colors.textTertiary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4,
          vertical: AppSpacing.s3,
        ),
        border: _fieldBorder(colors.borderSubtle),
        enabledBorder: _fieldBorder(colors.borderSubtle),
        focusedBorder: _fieldBorder(colors.accent, width: 1.5),
        errorBorder: _fieldBorder(colors.error),
        focusedErrorBorder: _fieldBorder(colors.error, width: 1.5),
      ),
    );
  }

  static OutlineInputBorder _fieldBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
