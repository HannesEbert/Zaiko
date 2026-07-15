import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../shared/widgets/empty_state.dart';

/// Placeholder for managing the user's own profile (name, avatar, account).
///
/// Reached from the profile tab; the actual editing arrives with the profile
/// feature issue.
class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  /// Relative segment under the profile branch (`/profile/edit`).
  static const String routeSegment = 'edit';
  static const String routeName = 'profile-edit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.profileManageAccount)),
      body: EmptyState(
        icon: Icons.manage_accounts_outlined,
        title: context.l10n.profileManageAccountEmptyTitle,
        message: context.l10n.profileManageAccountEmptyMessage,
      ),
    );
  }
}
