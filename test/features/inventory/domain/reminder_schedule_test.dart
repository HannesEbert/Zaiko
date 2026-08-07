import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/inventory/domain/inventory_item.dart';
import 'package:zaiko/features/inventory/domain/reminder_schedule.dart';
import 'package:zaiko/features/profile/domain/reminder_time.dart';

InventoryItem _item({required String name, DateTime? bestBefore}) {
  final created = DateTime(2026, 1, 1);
  return InventoryItem(
    id: name,
    householdId: 'h1',
    name: name,
    quantity: 1,
    createdAt: created,
    updatedAt: created,
    bestBefore: bestBefore,
  );
}

void main() {
  const at20 = ReminderTime(hour: 20, minute: 0);

  test('no items yields no reminders', () {
    final plan = planExpiryReminders(
      items: const [],
      leadDays: 3,
      reminderTime: at20,
      horizonDays: 14,
      now: DateTime(2026, 1, 10, 8),
    );
    expect(plan, isEmpty);
  });

  test('items without a best-before date are ignored', () {
    final plan = planExpiryReminders(
      items: [
        _item(name: 'salt'),
        _item(name: 'rice'),
      ],
      leadDays: 3,
      reminderTime: at20,
      horizonDays: 14,
      now: DateTime(2026, 1, 10, 8),
    );
    expect(plan, isEmpty);
  });

  test('an item due in 2 days fires each day it is within the lead window', () {
    // Best-before 2026-01-12; lead 3 → in window on the 10th, 11th and 12th
    // (days-until 2, 1, 0), and no longer once past.
    final plan = planExpiryReminders(
      items: [_item(name: 'Milk', bestBefore: DateTime(2026, 1, 12))],
      leadDays: 3,
      reminderTime: at20,
      horizonDays: 14,
      now: DateTime(2026, 1, 10, 8),
    );

    expect(plan.map((p) => p.fireDate), [
      DateTime(2026, 1, 10, 20),
      DateTime(2026, 1, 11, 20),
      DateTime(2026, 1, 12, 20),
    ]);
    expect(plan.every((p) => p.itemCount == 1), isTrue);
    expect(plan.first.sampleNames, ['Milk']);
  });

  test("today's reminder is skipped when its time has already passed", () {
    // now is 21:00, past the 20:00 fire time, so the 10th is skipped.
    final plan = planExpiryReminders(
      items: [_item(name: 'Milk', bestBefore: DateTime(2026, 1, 12))],
      leadDays: 3,
      reminderTime: at20,
      horizonDays: 14,
      now: DateTime(2026, 1, 10, 21),
    );

    expect(plan.map((p) => p.fireDate), [
      DateTime(2026, 1, 11, 20),
      DateTime(2026, 1, 12, 20),
    ]);
  });

  test('items expiring beyond the horizon produce no reminders', () {
    final plan = planExpiryReminders(
      items: [_item(name: 'Yogurt', bestBefore: DateTime(2026, 2, 1))],
      leadDays: 3,
      reminderTime: at20,
      horizonDays: 14,
      now: DateTime(2026, 1, 10, 8),
    );
    expect(plan, isEmpty);
  });

  test(
    'a day counts every item in the window, sampled by urgency and capped',
    () {
      // All four are within lead 5 on the 10th; sample keeps the 3 soonest.
      final plan = planExpiryReminders(
        items: [
          _item(name: 'D', bestBefore: DateTime(2026, 1, 15)),
          _item(name: 'A', bestBefore: DateTime(2026, 1, 11)),
          _item(name: 'C', bestBefore: DateTime(2026, 1, 14)),
          _item(name: 'B', bestBefore: DateTime(2026, 1, 12)),
        ],
        leadDays: 5,
        reminderTime: at20,
        horizonDays: 1,
        now: DateTime(2026, 1, 10, 8),
      );

      expect(plan, hasLength(1));
      expect(plan.single.itemCount, 4);
      expect(plan.single.sampleNames, ['A', 'B', 'C']);
    },
  );
}
