/// App-wide constants that are not feature-specific.
abstract final class AppConstants {
  static const String appName = 'Zaiko';

  /// How many days before its best-before date an item counts as "expiring
  /// soon". Fixed for now; made per-user configurable in Phase 5 (see #37).
  static const int expiryWarningDays = 3;
}
