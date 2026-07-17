import 'package:flutter/material.dart';

/// Semantic color tokens from the Zaiko design system, exposed as a
/// [ThemeExtension] so widgets read them from `Theme.of(context)`.
///
/// The palette follows the "Modern App Layout" Figma design: a near-black
/// canvas (`#000000` page, `#0a0a0a` cards) with hairline white borders,
/// indigo (`#6366f1`) as the single brand accent and slate greys for
/// secondary text. Storage-location colors live in the `category*` constants.
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

  /// Category accents for storage locations (fridge, freezer, pantry,
  /// drinks). Fixed brand values straight from the design — they don't vary
  /// with theme brightness, so they are constants rather than instance
  /// tokens. Tinted backgrounds are derived at 12% alpha (see `IconTile`).
  static const Color categoryBlue = Color(0xFF3B82F6);
  static const Color categoryCyan = Color(0xFF06B6D4);
  static const Color categoryOrange = Color(0xFFF97316);
  static const Color categoryPurple = Color(0xFFA855F7);

  /// Page background behind cards (`--background`).
  final Color pageBackground;

  /// Elevated surface for cards, sheets and list containers (`--card`).
  final Color card;

  /// Sunken neutral fill for chips and inactive icon tiles (`--muted`).
  final Color sunken;

  /// Background of inputs and search fields.
  final Color field;

  /// Primary brand color for filled buttons, active nav and the FAB.
  final Color accent;

  /// Brand color when used as text/icon on a neutral surface.
  final Color accentText;

  /// Indigo tint (15%) behind the active nav item.
  final Color accentMuted;

  /// Faintest indigo wash (12%) for icon tiles.
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

  /// The design is dark-only, so both theme slots share one token set.
  static const AppColors light = dark;

  /// Token set from the Figma "Modern App Layout" design (dark).
  static const AppColors dark = AppColors(
    pageBackground: Color(0xFF000000),
    card: Color(0xFF0A0A0A),
    sunken: Color(0xFF171717),
    field: Color(0xFF0A0A0A),
    accent: Color(0xFF6366F1),
    accentText: Color(0xFF6366F1),
    accentMuted: Color(0x266366F1),
    accentWash: Color(0x1F6366F1),
    onAccent: Color(0xFFFFFFFF),
    textPrimary: Color(0xFFF8FAFC),
    textSecondary: Color(0xFF94A3B8),
    textTertiary: Color(0xFF64748B),
    textStrong: Color(0xFF94A3B8),
    borderSubtle: Color(0x0FFFFFFF),
    borderStrong: Color(0x1FFFFFFF),
    divider: Color(0x0AFFFFFF),
    success: Color(0xFF34D399),
    successBg: Color(0x1F34D399),
    warning: Color(0xFFFBBF24),
    warningBg: Color(0x1FFBBF24),
    error: Color(0xFFF87171),
    errorBg: Color(0x1FF87171),
    navBackground: Color(0xEB000000),
    navSelected: Color(0xFF6366F1),
    navUnselected: Color(0xFF475569),
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
