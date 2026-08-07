import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_constants.dart';
import 'core/notifications/notification_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/inventory/application/reminder_scheduler.dart';
import 'features/profile/application/profile_providers.dart';
import 'l10n/app_localizations.dart';

/// Root widget of the app.
///
/// Wires up routing and theming. State is provided by the [ProviderScope]
/// in `main.dart`.
class ZaikoApp extends ConsumerStatefulWidget {
  const ZaikoApp({super.key});

  @override
  ConsumerState<ZaikoApp> createState() => _ZaikoAppState();
}

class _ZaikoAppState extends ConsumerState<ZaikoApp> {
  @override
  void initState() {
    super.initState();
    // Initialise the plugin and local time zone early so scheduling is ready
    // before the user opts in. Permission is requested only on first enable.
    ref.read(notificationServiceProvider).init();
    // Activate the expiry-reminder scheduler. It is kept alive and watches the
    // profile and inventory itself, so reading it once is enough to keep it
    // rescheduling for the app's lifetime.
    ref.read(reminderSchedulerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    // `null` follows the system language; a saved profile locale overrides it.
    final locale = ref.watch(appLocaleProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      // Dark-only for now (AppTheme.light aliases dark); a light theme and a
      // toggle are a separate follow-up issue.
      theme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    );
  }
}
