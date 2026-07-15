import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../shared/widgets/empty_state.dart';

/// Placeholder for configuring expiry (MHD) reminders.
///
/// Reached from the profile tab; the actual settings arrive with the
/// notifications feature issue.
class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  /// Relative segment under the profile branch (`/profile/reminders`).
  static const String routeSegment = 'reminders';
  static const String routeName = 'profile-reminders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profileReminders)),
      body: EmptyState(
        icon: Icons.notifications_outlined,
        title: context.l10n.profileRemindersEmptyTitle,
        message: context.l10n.profileRemindersEmptyMessage,
      ),
    );
  }
}
