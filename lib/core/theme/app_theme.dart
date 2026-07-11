import 'package:flutter/material.dart';

/// Central theme definition — widgets read colors and text styles from
/// `Theme.of(context)` instead of hard-coding them.
abstract final class AppTheme {
  /// Seed color: fresh green, fitting the "waste less food" theme.
  static const Color _seedColor = Color(0xFF2E7D32);

  static ThemeData get light => _base(Brightness.light);

  static ThemeData get dark => _base(Brightness.dark);

  static ThemeData _base(Brightness brightness) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _seedColor,
      brightness: brightness,
    );

    return ThemeData(
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: colorScheme.surface,
      ),
    );
  }
}
