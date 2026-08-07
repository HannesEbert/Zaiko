import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/notifications/notification_ids.dart';
import 'package:zaiko/core/notifications/notification_providers.dart';
import 'package:zaiko/features/recipes/application/cook_timers.dart';

import '../../../core/notifications/fake_notification_service.dart';

const _title = 'Timer done';
const _body = 'Your step timer has finished.';

void main() {
  // Binding so the expiry alert's HapticFeedback/SystemSound platform calls are
  // handled as no-ops instead of throwing.
  TestWidgetsFlutterBinding.ensureInitialized();

  CookTimer? timerAt(ProviderContainer container, int step) =>
      container.read(cookTimersProvider)[step];

  // A ProviderContainer with a standing subscription: `read` alone wouldn't
  // keep the autoDispose provider alive, so a running timer would be torn down
  // between operations. The notification service is faked so scheduling never
  // touches a platform channel.
  ProviderContainer makeContainer([FakeNotificationService? notifications]) {
    final container = ProviderContainer(
      overrides: [
        notificationServiceProvider.overrideWithValue(
          notifications ?? FakeNotificationService(),
        ),
      ],
    );
    container.listen(cookTimersProvider, (_, _) {});
    return container;
  }

  test('an untouched step reads as idle at the default duration', () {
    final container = makeContainer();
    addTearDown(container.dispose);

    // No entry yet; the UI falls back to the initial timer.
    expect(container.read(cookTimersProvider), isEmpty);
    expect(kInitialCookTimer.status, CookTimerStatus.idle);
    expect(kInitialCookTimer.configured, const Duration(minutes: 5));
    expect(kInitialCookTimer.remaining, kInitialCookTimer.configured);
  });

  test('adjust raises and lowers the configured duration by a minute', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final controller = container.read(cookTimersProvider.notifier);

    controller.adjust(0, const Duration(minutes: 1));
    expect(timerAt(container, 0)!.configured, const Duration(minutes: 6));
    expect(timerAt(container, 0)!.remaining, const Duration(minutes: 6));
    expect(timerAt(container, 0)!.status, CookTimerStatus.idle);

    controller.adjust(0, const Duration(minutes: -1));
    expect(timerAt(container, 0)!.configured, const Duration(minutes: 5));
  });

  test('adjust also steps the duration by seconds', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final controller = container.read(cookTimersProvider.notifier);

    controller.adjust(0, const Duration(seconds: 10));
    expect(
      timerAt(container, 0)!.configured,
      const Duration(minutes: 5, seconds: 10),
    );

    controller.adjust(0, const Duration(seconds: -20));
    expect(
      timerAt(container, 0)!.configured,
      const Duration(minutes: 4, seconds: 50),
    );
  });

  test('adjust never lowers the configured duration below the floor', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final controller = container.read(cookTimersProvider.notifier);

    for (var i = 0; i < 10; i++) {
      controller.adjust(0, const Duration(minutes: -1));
    }

    expect(timerAt(container, 0)!.configured, const Duration(seconds: 5));
  });

  test('seed pre-loads a step at its recipe-defined duration', () {
    final container = makeContainer();
    addTearDown(container.dispose);
    final controller = container.read(cookTimersProvider.notifier);

    controller.seed({0: const Duration(minutes: 15)});

    expect(timerAt(container, 0)!.configured, const Duration(minutes: 15));
    expect(timerAt(container, 0)!.remaining, const Duration(minutes: 15));
    expect(timerAt(container, 0)!.status, CookTimerStatus.idle);
  });

  test('start begins running from the configured duration', () {
    fakeAsync((async) {
      final container = makeContainer();
      final controller = container.read(cookTimersProvider.notifier);

      controller.start(0, notifTitle: _title, notifBody: _body);

      expect(timerAt(container, 0)!.status, CookTimerStatus.running);
      expect(timerAt(container, 0)!.remaining, const Duration(minutes: 5));

      container.dispose();
    });
  });

  test('a running timer counts down and finishes at zero', () {
    fakeAsync((async) {
      final container = makeContainer();
      final controller = container.read(cookTimersProvider.notifier);

      controller.start(0, notifTitle: _title, notifBody: _body);
      async.elapse(const Duration(minutes: 2));
      expect(timerAt(container, 0)!.remaining, const Duration(minutes: 3));
      expect(timerAt(container, 0)!.status, CookTimerStatus.running);

      async.elapse(const Duration(minutes: 3));
      expect(timerAt(container, 0)!.status, CookTimerStatus.finished);
      expect(timerAt(container, 0)!.remaining, Duration.zero);

      container.dispose();
    });
  });

  test('adjust extends the remaining time while running', () {
    fakeAsync((async) {
      final container = makeContainer();
      final controller = container.read(cookTimersProvider.notifier);

      controller.start(0, notifTitle: _title, notifBody: _body);
      async.elapse(const Duration(minutes: 1));
      expect(timerAt(container, 0)!.remaining, const Duration(minutes: 4));

      controller.adjust(0, const Duration(minutes: 1));
      expect(timerAt(container, 0)!.remaining, const Duration(minutes: 5));
      expect(timerAt(container, 0)!.status, CookTimerStatus.running);

      container.dispose();
    });
  });

  test('pause stops the countdown and start resumes it', () {
    fakeAsync((async) {
      final container = makeContainer();
      final controller = container.read(cookTimersProvider.notifier);

      controller.start(0, notifTitle: _title, notifBody: _body);
      async.elapse(const Duration(seconds: 30));
      expect(
        timerAt(container, 0)!.remaining,
        const Duration(minutes: 4, seconds: 30),
      );

      controller.pause(0);
      expect(timerAt(container, 0)!.status, CookTimerStatus.paused);

      // While paused the countdown does not advance.
      async.elapse(const Duration(minutes: 1));
      expect(
        timerAt(container, 0)!.remaining,
        const Duration(minutes: 4, seconds: 30),
      );

      // Resuming keeps counting from where it stopped.
      controller.start(0, notifTitle: _title, notifBody: _body);
      expect(timerAt(container, 0)!.status, CookTimerStatus.running);
      async.elapse(const Duration(seconds: 30));
      expect(timerAt(container, 0)!.remaining, const Duration(minutes: 4));

      container.dispose();
    });
  });

  test('reset returns a running timer to idle at its configured duration', () {
    fakeAsync((async) {
      final container = makeContainer();
      final controller = container.read(cookTimersProvider.notifier);

      controller.start(0, notifTitle: _title, notifBody: _body);
      async.elapse(const Duration(minutes: 1));
      controller.reset(0);

      expect(timerAt(container, 0)!.status, CookTimerStatus.idle);
      expect(timerAt(container, 0)!.remaining, const Duration(minutes: 5));

      container.dispose();
    });
  });

  test('start schedules a cook-timer notification for the step', () {
    fakeAsync((async) {
      final service = FakeNotificationService();
      final container = makeContainer(service);
      final controller = container.read(cookTimersProvider.notifier);

      controller.start(1, notifTitle: _title, notifBody: _body);

      expect(service.scheduled, hasLength(1));
      final n = service.scheduled.single;
      expect(n.id, NotificationIds.cookTimerBase + 1);
      expect(n.title, _title);
      expect(n.body, _body);

      container.dispose();
    });
  });

  test('pause cancels the scheduled cook-timer notification', () {
    fakeAsync((async) {
      final service = FakeNotificationService();
      final container = makeContainer(service);
      final controller = container.read(cookTimersProvider.notifier);

      controller.start(0, notifTitle: _title, notifBody: _body);
      controller.pause(0);

      expect(service.cancelled, contains(NotificationIds.cookTimerBase));

      container.dispose();
    });
  });

  test('finishing in the foreground cancels the backup notification', () {
    fakeAsync((async) {
      final service = FakeNotificationService();
      final container = makeContainer(service);
      final controller = container.read(cookTimersProvider.notifier);

      controller.start(0, notifTitle: _title, notifBody: _body);
      async.elapse(const Duration(minutes: 5));

      expect(timerAt(container, 0)!.status, CookTimerStatus.finished);
      expect(service.cancelled, contains(NotificationIds.cookTimerBase));

      container.dispose();
    });
  });

  test('leaving cook mode cancels a running timer notification', () {
    fakeAsync((async) {
      final service = FakeNotificationService();
      final container = makeContainer(service);
      final controller = container.read(cookTimersProvider.notifier);

      controller.start(0, notifTitle: _title, notifBody: _body);
      container.dispose();

      expect(service.cancelled, contains(NotificationIds.cookTimerBase));
    });
  });
}
