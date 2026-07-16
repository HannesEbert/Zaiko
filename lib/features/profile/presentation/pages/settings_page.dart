import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../shared/widgets/empty_state.dart';

/// Placeholder for app settings.
///
/// Reached from the profile tab; the actual settings arrive with the settings
/// feature issue.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  /// Relative segment under the profile branch (`/profile/settings`).
  static const String routeSegment = 'settings';
  static const String routeName = 'profile-settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profileSettings)),
      body: EmptyState(
        icon: Icons.settings_outlined,
        title: context.l10n.profileSettingsEmptyTitle,
        message: context.l10n.profileSettingsEmptyMessage,
      ),
    );
  }
}
