import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'flutter_local_notifications_service.dart';
import 'notification_service.dart';

part 'notification_providers.g.dart';

/// The app's [NotificationService]. Kept alive for the whole session and
/// overridden with a fake in tests.
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) =>
    FlutterLocalNotificationsService();
