import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../shared/widgets/empty_state.dart';

/// Placeholder for linking and managing the user's household.
///
/// Reached from the profile tab; joining via an invite code already has its own
/// deep-link page ([JoinHouseholdPage]). Management arrives with the household
/// feature issue.
class HouseholdLinkPage extends StatelessWidget {
  const HouseholdLinkPage({super.key});

  /// Relative segment under the profile branch (`/profile/household`).
  static const String routeSegment = 'household';
  static const String routeName = 'profile-household';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profileHousehold)),
      body: EmptyState(
        icon: Icons.group_outlined,
        title: context.l10n.profileHouseholdEmptyTitle,
        message: context.l10n.profileHouseholdEmptyMessage,
      ),
    );
  }
}
