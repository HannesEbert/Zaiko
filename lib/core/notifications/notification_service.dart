/// Feature-agnostic contract for scheduling and cancelling local
/// notifications.
///
/// The application and presentation layers depend only on this interface, so
/// the platform-backed [FlutterLocalNotificationsService] can be replaced by a
/// fake in tests. Only primitive types cross this boundary — no plugin or
/// timezone type leaks out — which keeps the seam trivially mockable.
abstract interface class NotificationService {
  /// Initialises the plugin and the local time zone. Idempotent: safe to call
  /// repeatedly, and every other method ensures initialisation first, so call
  /// order never matters.
  Future<void> init();

  /// Asks the user for permission to post notifications, returning whether it
  /// was granted. Call this when the user first enables reminders, not at
  /// startup.
  Future<bool> requestPermission();

  /// Schedules a one-shot notification to fire at [when] (local wall-clock).
  /// Re-using an existing [id] replaces that pending notification.
  Future<void> scheduleAt({
    required int id,
    required DateTime when,
    required String title,
    required String body,
    String? payload,
  });

  /// Cancels the pending notification with [id]. A no-op if none is pending.
  Future<void> cancel(int id);

  /// Cancels every id in the half-open range `[startInclusive, endExclusive)`.
  ///
  /// Lets a caller clear a whole reserved block (see [NotificationIds]) before
  /// rescheduling, so a reschedule can never duplicate or leak ids.
  Future<void> cancelRange(int startInclusive, int endExclusive);
}
