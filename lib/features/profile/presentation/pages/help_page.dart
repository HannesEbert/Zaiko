import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../shared/widgets/empty_state.dart';

/// Placeholder for help and support.
///
/// Reached from the profile tab; the actual help content arrives with the
/// support feature issue.
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  /// Relative segment under the profile branch (`/profile/help`).
  static const String routeSegment = 'help';
  static const String routeName = 'profile-help';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profileHelp)),
      body: EmptyState(
        icon: Icons.help_outline,
        title: context.l10n.profileHelpEmptyTitle,
        message: context.l10n.profileHelpEmptyMessage,
      ),
    );
  }
}
