import 'package:zaiko/core/notifications/notification_service.dart';

/// A single recorded [NotificationService.scheduleAt] call.
class ScheduledNotification {
  const ScheduledNotification({
    required this.id,
    required this.when,
    required this.title,
    required this.body,
    this.payload,
  });

  final int id;
  final DateTime when;
  final String title;
  final String body;
  final String? payload;
}

/// Recording [NotificationService] for tests: captures calls instead of
/// touching any platform, and lets a test script the permission result.
class FakeNotificationService implements NotificationService {
  final List<ScheduledNotification> scheduled = [];
  final List<int> cancelled = [];
  final List<(int, int)> cancelledRanges = [];

  bool permissionGranted = true;
  int initCalls = 0;
  int permissionRequests = 0;

  @override
  Future<void> init() async => initCalls++;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    return permissionGranted;
  }

  @override
  Future<void> scheduleAt({
    required int id,
    required DateTime when,
    required String title,
    required String body,
    String? payload,
  }) async {
    scheduled.add(
      ScheduledNotification(
        id: id,
        when: when,
        title: title,
        body: body,
        payload: payload,
      ),
    );
  }

  @override
  Future<void> cancel(int id) async => cancelled.add(id);

  @override
  Future<void> cancelRange(int startInclusive, int endExclusive) async =>
      cancelledRanges.add((startInclusive, endExclusive));
}
