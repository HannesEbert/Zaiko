import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../shared/widgets/empty_state.dart';

/// Placeholder for the user's stored personal data.
///
/// Reached from the profile tab; the actual data view arrives with the profile
/// feature issue.
class PersonalDataPage extends StatelessWidget {
  const PersonalDataPage({super.key});

  /// Relative segment under the profile branch (`/profile/personal-data`).
  static const String routeSegment = 'personal-data';
  static const String routeName = 'profile-personal-data';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profilePersonalData)),
      body: EmptyState(
        icon: Icons.badge_outlined,
        title: context.l10n.profilePersonalDataEmptyTitle,
        message: context.l10n.profilePersonalDataEmptyMessage,
      ),
    );
  }
}
