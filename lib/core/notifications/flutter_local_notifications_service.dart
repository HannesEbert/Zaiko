import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'notification_service.dart';

/// [NotificationService] backed by `flutter_local_notifications`.
///
/// This is the only place the plugin and the `timezone` package are touched;
/// everything else depends on the [NotificationService] abstraction.
class FlutterLocalNotificationsService implements NotificationService {
  FlutterLocalNotificationsService();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// The single notification channel (Android). Its name/description surface in
  /// the system settings; kept generic since it covers both expiry reminders
  /// and cook-mode timers.
  static const String _channelId = 'zaiko_reminders';
  static const String _channelName = 'Reminders';
  static const String _channelDescription =
      'Expiry reminders and cook-mode timers';

  /// Cached so [init] runs its side effects exactly once; every method awaits
  /// it before touching the plugin.
  Future<void>? _initialization;

  @override
  Future<void> init() => _initialization ??= _initialize();

  Future<void> _initialize() async {
    tz.initializeTimeZones();
    final localZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localZone.identifier));

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    // Permission is requested explicitly via [requestPermission] on first
    // enable, not implicitly during initialisation.
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: android, iOS: darwin),
      onDidReceiveNotificationResponse: _onResponse,
    );
  }

  @override
  Future<bool> requestPermission() async {
    await init();
    if (Platform.isIOS) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return granted ?? false;
    }
    if (Platform.isAndroid) {
      final granted = await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      return granted ?? false;
    }
    return false;
  }

  @override
  Future<void> scheduleAt({
    required int id,
    required DateTime when,
    required String title,
    required String body,
    String? payload,
  }) async {
    await init();
    await _plugin.zonedSchedule(
      id: id,
      scheduledDate: tz.TZDateTime.from(when, tz.local),
      notificationDetails: _details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      title: title,
      body: body,
      payload: payload,
    );
  }

  @override
  Future<void> cancel(int id) async {
    await init();
    await _plugin.cancel(id: id);
  }

  @override
  Future<void> cancelRange(int startInclusive, int endExclusive) async {
    await init();
    for (var id = startInclusive; id < endExclusive; id++) {
      await _plugin.cancel(id: id);
    }
  }

  NotificationDetails get _details => const NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  /// Handles a tapped notification. Deep-linking to the relevant item or cook
  /// step is a follow-up; for now the tap just opens the app.
  void _onResponse(NotificationResponse response) {}
}
