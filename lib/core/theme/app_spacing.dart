/// Spacing, radius and sizing tokens from the Zaiko design system (4px grid).
///
/// Widgets use these instead of hard-coded numbers so the layout rhythm stays
/// consistent across screens.
abstract final class AppSpacing {
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 20;
  static const double s6 = 24;
  static const double s8 = 32;
  static const double s10 = 40;
  static const double s12 = 48;
  static const double s16 = 64;

  /// Default horizontal inset for page content on mobile.
  static const double pageInset = 20;

  /// Standard minimum hit target for interactive elements.
  static const double hitTarget = 44;
}

/// Corner-radius tokens — rounded but restrained (12–16px on containers).
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double full = 999;
}
