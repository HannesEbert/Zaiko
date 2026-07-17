import 'package:flutter/material.dart';

/// Typography tokens from the Zaiko design system.
///
/// One family (the platform default). The Figma design leans on heavy weights
/// for hierarchy: extrabold screen titles, bold card names, semibold list
/// items. Styles carry no color; call sites apply a color from [AppColors].
/// Letter-spacing values are the design's em tracking multiplied by the font
/// size (Flutter expresses spacing in logical pixels).
abstract final class AppTypography {
  /// Enables tabular (monospaced) figures for quantities, dates and counts.
  static const List<FontFeature> tabularFigures = [
    FontFeature.tabularFigures(),
  ];

  /// Hero numbers and onboarding.
  static const TextStyle display = TextStyle(
    fontSize: 32,
    height: 1.15,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
  );

  /// Large screen titles (e.g. "Inventar", "Einkauf") — 30px extrabold with
  /// tight tracking, matching the design's `text-3xl font-extrabold`.
  static const TextStyle screenTitle = TextStyle(
    fontSize: 30,
    height: 1.2,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.75,
  );

  /// Detail/page titles.
  static const TextStyle title = TextStyle(
    fontSize: 22,
    height: 1.25,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.22,
  );

  /// Card headers and location names (`text-base font-bold`).
  static const TextStyle headline = TextStyle(
    fontSize: 16,
    height: 1.35,
    fontWeight: FontWeight.w700,
  );

  /// Default copy (`text-sm`).
  static const TextStyle body = TextStyle(
    fontSize: 14,
    height: 1.5,
    fontWeight: FontWeight.w400,
  );

  /// Emphasized body, list-item names (`text-sm font-semibold`).
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    height: 1.4,
    fontWeight: FontWeight.w600,
  );

  /// Metadata, timestamps, secondary lines (`text-xs`).
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );

  /// Section headers and badges (`text-xs font-bold tracking-widest`,
  /// uppercased at the call site).
  static const TextStyle micro = TextStyle(
    fontSize: 12,
    height: 1.35,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );
}
