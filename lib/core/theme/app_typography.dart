import 'package:flutter/material.dart';

/// Typography tokens from the Zaiko design system.
///
/// One family (the platform default, which mirrors Inter's intent — SF on iOS,
/// Roboto on Android). Hierarchy comes from weight and spacing, not color or
/// decoration. Styles carry no color; call sites apply a color from
/// [AppColors]. Letter-spacing values are the design's em tracking multiplied
/// by the font size (Flutter expresses spacing in logical pixels).
abstract final class AppTypography {
  /// Enables tabular (monospaced) figures for quantities, dates and counts.
  static const List<FontFeature> tabularFigures = [
    FontFeature.tabularFigures(),
  ];

  /// Hero numbers and onboarding.
  static const TextStyle display = TextStyle(
    fontSize: 32,
    height: 1.15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.64,
  );

  /// Large screen titles (e.g. "Inventar", "Einkaufsliste").
  static const TextStyle screenTitle = TextStyle(
    fontSize: 28,
    height: 1.15,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.56,
  );

  /// Detail/page titles.
  static const TextStyle title = TextStyle(
    fontSize: 22,
    height: 1.25,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.22,
  );

  /// Card and section headers.
  static const TextStyle headline = TextStyle(
    fontSize: 17,
    height: 1.35,
    fontWeight: FontWeight.w600,
  );

  /// Default copy.
  static const TextStyle body = TextStyle(
    fontSize: 15,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  /// Emphasized body, list-item names.
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    height: 1.4,
    fontWeight: FontWeight.w500,
  );

  /// Metadata, timestamps, secondary lines.
  static const TextStyle caption = TextStyle(
    fontSize: 13,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );

  /// Badges and tab labels — usually uppercase for section headers.
  static const TextStyle micro = TextStyle(
    fontSize: 11,
    height: 1.35,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.44,
  );
}
