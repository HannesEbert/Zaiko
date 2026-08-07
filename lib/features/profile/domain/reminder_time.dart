/// The time of day at which the daily expiry reminder fires.
///
/// A pure value object with no Flutter dependency (deliberately not
/// `TimeOfDay`), stored on the profile as an `'HH:mm'` string.
class ReminderTime {
  const ReminderTime({required this.hour, required this.minute})
    : assert(hour >= 0 && hour <= 23, 'hour must be 0-23'),
      assert(minute >= 0 && minute <= 59, 'minute must be 0-59');

  /// Parses an `'HH:mm'` string (e.g. `'20:00'`), falling back to
  /// [defaultTime] when the input is malformed so a bad stored value never
  /// crashes the scheduler.
  factory ReminderTime.parse(String value) {
    final parts = value.split(':');
    if (parts.length == 2) {
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour != null &&
          minute != null &&
          hour >= 0 &&
          hour <= 23 &&
          minute >= 0 &&
          minute <= 59) {
        return ReminderTime(hour: hour, minute: minute);
      }
    }
    return defaultTime;
  }

  /// Hour in 24-hour form (0-23).
  final int hour;

  /// Minute (0-59).
  final int minute;

  /// The fallback daily reminder time (20:00), matching the profile default.
  static const ReminderTime defaultTime = ReminderTime(hour: 20, minute: 0);

  /// Formats as a zero-padded `'HH:mm'` string.
  String format() =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  bool operator ==(Object other) =>
      other is ReminderTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() => 'ReminderTime(${format()})';
}
