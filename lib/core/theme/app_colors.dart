import 'package:flutter/material.dart';

/// Semantic color tokens from the Zaiko design system, exposed as a
/// [ThemeExtension] so widgets read them from `Theme.of(context)` and get the
/// right values in light and dark automatically.
///
/// The palette guidance: ~80% white/neutral surfaces, ~15% British Racing
/// Green, ~5% status colors. Green is intentional and premium — never a wash.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.pageBackground,
    required this.card,
    required this.sunken,
    required this.field,
    required this.accent,
    required this.accentText,
    required this.accentMuted,
    required this.accentWash,
    required this.onAccent,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textStrong,
    required this.borderSubtle,
    required this.borderStrong,
    required this.divider,
    required this.success,
    required this.successBg,
    required this.warning,
    required this.warningBg,
    required this.error,
    required this.errorBg,
    required this.navBackground,
    required this.navSelected,
    required this.navUnselected,
  });

  /// Page background behind cards (`--surface-page`).
  final Color pageBackground;

  /// Elevated surface for cards, sheets and list containers.
  final Color card;

  /// Sunken neutral fill for chips and inactive icon tiles.
  final Color sunken;

  /// Background of inputs and search fields.
  final Color field;

  /// Primary brand color for filled buttons, active nav and the FAB.
  final Color accent;

  /// Brand color when used as text/icon on a neutral surface (lighter in dark).
  final Color accentText;

  /// Subtle green tint for selected chips and avatars.
  final Color accentMuted;

  /// Faintest green wash for icon tiles.
  final Color accentWash;

  /// Foreground on top of [accent].
  final Color onAccent;

  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  /// Slightly stronger than secondary — used for setting/list labels.
  final Color textStrong;

  final Color borderSubtle;
  final Color borderStrong;
  final Color divider;

  final Color success;
  final Color successBg;
  final Color warning;
  final Color warningBg;
  final Color error;
  final Color errorBg;

  final Color navBackground;
  final Color navSelected;
  final Color navUnselected;

  /// Light theme token set.
  static const AppColors light = AppColors(
    pageBackground: Color(0xFFF7F7F2),
    card: Color(0xFFFFFFFF),
    sunken: Color(0xFFF3F4F1),
    field: Color(0xFFFFFFFF),
    accent: Color(0xFF004225),
    accentText: Color(0xFF004225),
    accentMuted: Color(0xFFE3ECE6),
    accentWash: Color(0xFFEFF4F0),
    onAccent: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF1E1E1E),
    textSecondary: Color(0xFF6B7280),
    textTertiary: Color(0xFF9CA3AF),
    textStrong: Color(0xFF40474F),
    borderSubtle: Color(0xFFE5E7EB),
    borderStrong: Color(0xFFD6D9DE),
    divider: Color(0xFFF3F4F1),
    success: Color(0xFF2E7D32),
    successBg: Color(0xFFEBF3EB),
    warning: Color(0xFFB45309),
    warningBg: Color(0xFFFAF3E7),
    error: Color(0xFFB3261E),
    errorBg: Color(0xFFF9ECEB),
    navBackground: Color(0xFFFFFFFF),
    navSelected: Color(0xFF004225),
    navUnselected: Color(0xFF9CA3AF),
  );

  /// Dark theme token set (derived from the "Inventar · Dark Mode" screen).
  static const AppColors dark = AppColors(
    pageBackground: Color(0xFF141513),
    card: Color(0xFF1F211E),
    sunken: Color(0x12FFFFFF),
    field: Color(0xFF1F211E),
    accent: Color(0xFF1A6440),
    accentText: Color(0xFF9FC4AE),
    accentMuted: Color(0x29E3ECE6),
    accentWash: Color(0x12FFFFFF),
    onAccent: Color(0xFFFFFFFF),
    textPrimary: Color(0xFFF2F2ED),
    textSecondary: Color(0xFF9BA19B),
    textTertiary: Color(0xFF7A807A),
    textStrong: Color(0xFFA8ADA6),
    borderSubtle: Color(0x17FFFFFF),
    borderStrong: Color(0x24FFFFFF),
    divider: Color(0x12FFFFFF),
    success: Color(0xFF9FC4AE),
    successBg: Color(0x2E2E7D32),
    warning: Color(0xFFE8B37B),
    warningBg: Color(0x38B45309),
    error: Color(0xFFF2A59F),
    errorBg: Color(0x3DB3261E),
    navBackground: Color(0xFF181A17),
    navSelected: Color(0xFF9FC4AE),
    navUnselected: Color(0xFF7A807A),
  );

  @override
  AppColors copyWith({
    Color? pageBackground,
    Color? card,
    Color? sunken,
    Color? field,
    Color? accent,
    Color? accentText,
    Color? accentMuted,
    Color? accentWash,
    Color? onAccent,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textStrong,
    Color? borderSubtle,
    Color? borderStrong,
    Color? divider,
    Color? success,
    Color? successBg,
    Color? warning,
    Color? warningBg,
    Color? error,
    Color? errorBg,
    Color? navBackground,
    Color? navSelected,
    Color? navUnselected,
  }) {
    return AppColors(
      pageBackground: pageBackground ?? this.pageBackground,
      card: card ?? this.card,
      sunken: sunken ?? this.sunken,
      field: field ?? this.field,
      accent: accent ?? this.accent,
      accentText: accentText ?? this.accentText,
      accentMuted: accentMuted ?? this.accentMuted,
      accentWash: accentWash ?? this.accentWash,
      onAccent: onAccent ?? this.onAccent,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textStrong: textStrong ?? this.textStrong,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderStrong: borderStrong ?? this.borderStrong,
      divider: divider ?? this.divider,
      success: success ?? this.success,
      successBg: successBg ?? this.successBg,
      warning: warning ?? this.warning,
      warningBg: warningBg ?? this.warningBg,
      error: error ?? this.error,
      errorBg: errorBg ?? this.errorBg,
      navBackground: navBackground ?? this.navBackground,
      navSelected: navSelected ?? this.navSelected,
      navUnselected: navUnselected ?? this.navUnselected,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      card: Color.lerp(card, other.card, t)!,
      sunken: Color.lerp(sunken, other.sunken, t)!,
      field: Color.lerp(field, other.field, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentText: Color.lerp(accentText, other.accentText, t)!,
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t)!,
      accentWash: Color.lerp(accentWash, other.accentWash, t)!,
      onAccent: Color.lerp(onAccent, other.onAccent, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
      textStrong: Color.lerp(textStrong, other.textStrong, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderStrong: Color.lerp(borderStrong, other.borderStrong, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      success: Color.lerp(success, other.success, t)!,
      successBg: Color.lerp(successBg, other.successBg, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningBg: Color.lerp(warningBg, other.warningBg, t)!,
      error: Color.lerp(error, other.error, t)!,
      errorBg: Color.lerp(errorBg, other.errorBg, t)!,
      navBackground: Color.lerp(navBackground, other.navBackground, t)!,
      navSelected: Color.lerp(navSelected, other.navSelected, t)!,
      navUnselected: Color.lerp(navUnselected, other.navUnselected, t)!,
    );
  }
}

/// Terse access to [AppColors] via `context.colors`.
extension AppColorsX on BuildContext {
  /// The Zaiko color tokens for the current theme brightness.
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}
