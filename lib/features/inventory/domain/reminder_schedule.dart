import '../../profile/domain/reminder_time.dart';
import 'expiry.dart';
import 'inventory_item.dart';

/// One planned expiry-reminder notification: a fire time and what it would say
/// about the inventory as of that day.
///
/// Because iOS bakes a notification's content at schedule time, the daily
/// "collective" reminder is precomputed per day here and rescheduled whenever
/// the inventory or settings change.
class PlannedReminder {
  const PlannedReminder({
    required this.fireDate,
    required this.itemCount,
    required this.sampleNames,
  });

  /// Local wall-clock time the notification should fire (day at the reminder
  /// time-of-day).
  final DateTime fireDate;

  /// How many items are within the lead window as of [fireDate].
  final int itemCount;

  /// The most urgent item names (soonest best-before first), for the body text.
  final List<String> sampleNames;

  @override
  bool operator ==(Object other) =>
      other is PlannedReminder &&
      other.fireDate == fireDate &&
      other.itemCount == itemCount &&
      _sameList(other.sampleNames, sampleNames);

  @override
  int get hashCode =>
      Object.hash(fireDate, itemCount, Object.hashAll(sampleNames));

  @override
  String toString() =>
      'PlannedReminder($fireDate, count: $itemCount, sample: $sampleNames)';

  static bool _sameList(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// How many item names each reminder carries as a sample for its body text.
const int _maxSampleNames = 3;

/// Plans the daily expiry reminders for the next [horizonDays] days.
///
/// For each day at [reminderTime], an item counts when its best-before is
/// between that day (inclusive) and [leadDays] later — i.e. it is within the
/// user's lead window and not yet past. Days with no such items produce no
/// reminder, so the user is only pinged when something is actually expiring
/// soon. A day whose fire time has already passed relative to [now] is skipped.
///
/// Pure and deterministic (drive it with an injected [now] in tests); it knows
/// nothing about whether reminders are enabled or permission — that policy is
/// the scheduler's.
List<PlannedReminder> planExpiryReminders({
  required List<InventoryItem> items,
  required int leadDays,
  required ReminderTime reminderTime,
  required int horizonDays,
  required DateTime now,
}) {
  final result = <PlannedReminder>[];

  for (var offset = 0; offset < horizonDays; offset++) {
    final fireDate = DateTime(
      now.year,
      now.month,
      now.day + offset,
      reminderTime.hour,
      reminderTime.minute,
    );
    if (!fireDate.isAfter(now)) continue;

    final due = items.where((item) {
      final days = daysUntilExpiry(item.bestBefore, now: fireDate);
      return days != null && days >= 0 && days <= leadDays;
    }).toList()..sort((a, b) => a.bestBefore!.compareTo(b.bestBefore!));

    if (due.isEmpty) continue;

    result.add(
      PlannedReminder(
        fireDate: fireDate,
        itemCount: due.length,
        sampleNames: due
            .take(_maxSampleNames)
            .map((item) => item.name)
            .toList(),
      ),
    );
  }

  return result;
}
