import 'dart:async';
import 'dart:ui' show Locale, PlatformDispatcher;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/notifications/notification_ids.dart';
import '../../../core/notifications/notification_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../profile/application/profile_providers.dart';
import '../../profile/domain/reminder_time.dart';
import '../domain/reminder_schedule.dart';
import 'inventory_providers.dart';

part 'reminder_scheduler.g.dart';

/// Keeps the OS's scheduled expiry reminders in sync with the inventory and the
/// user's reminder settings.
///
/// It watches [myProfileProvider] and [inventoryItemsProvider], so `build`
/// re-runs on every relevant change (app start, a saved setting, an inventory
/// edit). Each run clears the whole expiry id block and reschedules from the
/// pure [planExpiryReminders] plan — a full recompute, since iOS bakes a
/// notification's content at schedule time and cannot recompute at fire time.
///
/// Kept alive and activated once from the app root; it renders nothing.
@Riverpod(keepAlive: true)
class ReminderScheduler extends _$ReminderScheduler {
  @override
  Future<void> build() async {
    final service = ref.read(notificationServiceProvider);
    final profile = await ref.watch(myProfileProvider.future);

    // Clear any previously scheduled expiry reminders before deciding what to
    // schedule, so a disable (or an emptied inventory) leaves nothing behind.
    await service.cancelRange(
      NotificationIds.expiryBase,
      NotificationIds.expiryEnd,
    );

    if (profile == null || !profile.remindersEnabled) return;

    final items = await ref.watch(inventoryItemsProvider.future);
    final planned = planExpiryReminders(
      items: items,
      leadDays: profile.reminderLeadDays,
      reminderTime: ReminderTime.parse(profile.reminderTime),
      horizonDays: NotificationIds.expiryHorizonDays,
      now: DateTime.now(),
    );
    if (planned.isEmpty) return;

    final l10n = lookupAppLocalizations(_resolveLocale(profile.locale));
    for (final reminder in planned) {
      await service.scheduleAt(
        id: NotificationIds.expiryBase + _dayOffset(reminder.fireDate),
        when: reminder.fireDate,
        title: l10n.remindersNotificationTitle(reminder.itemCount),
        body: reminder.sampleNames.join(', '),
      );
    }
  }

  /// Whole days from today until [fireDate], the stable slot within the expiry
  /// id block so a reschedule reuses ids rather than leaking them.
  int _dayOffset(DateTime fireDate) {
    final today = DateTime.now();
    return DateTime(
      fireDate.year,
      fireDate.month,
      fireDate.day,
    ).difference(DateTime(today.year, today.month, today.day)).inDays;
  }

  /// Resolves the locale for notification text outside the widget tree: the
  /// saved profile locale, else the system language, always narrowed to a
  /// supported locale so [lookupAppLocalizations] never throws.
  Locale _resolveLocale(String? code) {
    if (code == 'de') return const Locale('de');
    if (code == 'en') return const Locale('en');
    final system = PlatformDispatcher.instance.locale;
    return system.languageCode == 'de'
        ? const Locale('de')
        : const Locale('en');
  }
}
