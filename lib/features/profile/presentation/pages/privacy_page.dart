import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../shared/widgets/empty_state.dart';

/// Placeholder for the privacy policy and data-protection settings.
///
/// Reached from the profile tab; the actual content arrives with the privacy
/// feature issue.
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  /// Relative segment under the profile branch (`/profile/privacy`).
  static const String routeSegment = 'privacy';
  static const String routeName = 'profile-privacy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profilePrivacy)),
      body: EmptyState(
        icon: Icons.privacy_tip_outlined,
        title: context.l10n.profilePrivacyEmptyTitle,
        message: context.l10n.profilePrivacyEmptyMessage,
      ),
    );
  }
}
