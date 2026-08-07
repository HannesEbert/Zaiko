/// Central allocation of local-notification ids, split into non-overlapping
/// blocks so one feature's reschedule never clears another feature's pending
/// ids.
abstract final class NotificationIds {
  /// First id of the expiry-reminder block — one slot per day ahead
  /// (`expiryBase + dayOffset`).
  static const int expiryBase = 1000;

  /// How many days ahead the expiry scheduler plans. iOS caps the number of
  /// pending notifications (~64), so the block stays small and is fully
  /// recomputed on every app start, inventory change and settings change.
  static const int expiryHorizonDays = 14;

  /// One past the last expiry id — the block is `[expiryBase, expiryEnd)`.
  static const int expiryEnd = expiryBase + expiryHorizonDays;

  /// Base for cook-mode step timers (`cookTimerBase + stepIndex`). Kept well
  /// clear of the expiry block; only one cook session runs at a time.
  static const int cookTimerBase = 2000;
}
