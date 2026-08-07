import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/notifications/notification_ids.dart';
import 'package:zaiko/core/notifications/notification_providers.dart';
import 'package:zaiko/features/inventory/application/inventory_providers.dart';
import 'package:zaiko/features/inventory/application/reminder_scheduler.dart';
import 'package:zaiko/features/inventory/domain/inventory_item.dart';
import 'package:zaiko/features/profile/application/profile_providers.dart';
import 'package:zaiko/features/profile/domain/profile.dart';

import '../../../core/notifications/fake_notification_service.dart';

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

Profile _profile({
  bool remindersEnabled = true,
  int leadDays = 3,
  String reminderTime = '20:00',
}) => Profile(
  id: 'u1',
  displayName: 'Dev',
  createdAt: DateTime.utc(2026),
  locale: 'en',
  remindersEnabled: remindersEnabled,
  reminderLeadDays: leadDays,
  reminderTime: reminderTime,
);

void main() {
  ProviderContainer makeContainer({
    required Profile? profile,
    required List<InventoryItem> items,
    required FakeNotificationService service,
  }) {
    final container = ProviderContainer(
      overrides: [
        notificationServiceProvider.overrideWithValue(service),
        myProfileProvider.overrideWith((ref) async => profile),
        inventoryItemsProvider.overrideWith((ref) => Stream.value(items)),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('clears the expiry block and schedules nothing when disabled', () async {
    final service = FakeNotificationService();
    final container = makeContainer(
      profile: _profile(remindersEnabled: false),
      items: [_item(name: 'Milk', bestBefore: DateTime.now())],
      service: service,
    );

    await container.read(reminderSchedulerProvider.future);

    expect(service.scheduled, isEmpty);
    expect(service.cancelledRanges, [
      (NotificationIds.expiryBase, NotificationIds.expiryEnd),
    ]);
  });

  test('schedules nothing when signed out', () async {
    final service = FakeNotificationService();
    final container = makeContainer(
      profile: null,
      items: const [],
      service: service,
    );

    await container.read(reminderSchedulerProvider.future);

    expect(service.scheduled, isEmpty);
    expect(service.cancelledRanges, hasLength(1));
  });

  test(
    'clears then schedules reminders with unique ids inside the block',
    () async {
      final service = FakeNotificationService();
      // Two days out, within the 3-day lead window, so several future days fire.
      final bestBefore = DateTime.now().add(const Duration(days: 2));
      final container = makeContainer(
        profile: _profile(),
        items: [_item(name: 'Milk', bestBefore: bestBefore)],
        service: service,
      );

      await container.read(reminderSchedulerProvider.future);

      expect(service.cancelledRanges, [
        (NotificationIds.expiryBase, NotificationIds.expiryEnd),
      ]);
      expect(service.scheduled, isNotEmpty);
      // Ids stay within the reserved block and never repeat.
      for (final n in service.scheduled) {
        expect(
          n.id,
          inInclusiveRange(
            NotificationIds.expiryBase,
            NotificationIds.expiryEnd - 1,
          ),
        );
      }
      final ids = service.scheduled.map((n) => n.id).toList();
      expect(ids.toSet(), hasLength(ids.length));
      // The localized title carries the item count.
      expect(service.scheduled.first.title, contains('1 item'));
      expect(service.scheduled.first.body, 'Milk');
    },
  );

  test('schedules nothing when no item is within the lead window', () async {
    final service = FakeNotificationService();
    final container = makeContainer(
      profile: _profile(leadDays: 3),
      items: [
        _item(name: 'Rice'), // no best-before
        _item(
          name: 'Yogurt',
          bestBefore: DateTime.now().add(const Duration(days: 60)),
        ),
      ],
      service: service,
    );

    await container.read(reminderSchedulerProvider.future);

    expect(service.scheduled, isEmpty);
    expect(service.cancelledRanges, hasLength(1));
  });
}
