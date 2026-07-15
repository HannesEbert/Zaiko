import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../auth/application/auth_providers.dart';
import 'help_page.dart';
import 'household_link_page.dart';
import 'personal_data_page.dart';
import 'privacy_page.dart';
import 'profile_edit_page.dart';
import 'reminders_page.dart';
import 'settings_page.dart';

/// Profile tab: a menu into account, household, settings, privacy and help,
/// plus sign-out.
///
/// Each entry navigates to its own (currently placeholder) sub-page; the
/// individual features are filled in later. Sign-out flows through the auth
/// repository, after which the router redirect sends the user back to login.
class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  static const String routePath = '/profile';
  static const String routeName = 'profile';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle)),
      body: ListView(
        children: [
          _ProfileMenuTile(
            icon: Icons.manage_accounts_outlined,
            label: l10n.profileManageAccount,
            routeName: ProfileEditPage.routeName,
          ),
          _ProfileMenuTile(
            icon: Icons.badge_outlined,
            label: l10n.profilePersonalData,
            routeName: PersonalDataPage.routeName,
          ),
          _ProfileMenuTile(
            icon: Icons.notifications_outlined,
            label: l10n.profileReminders,
            routeName: RemindersPage.routeName,
          ),
          _ProfileMenuTile(
            icon: Icons.group_outlined,
            label: l10n.profileHousehold,
            routeName: HouseholdLinkPage.routeName,
          ),
          const Divider(),
          _ProfileMenuTile(
            icon: Icons.settings_outlined,
            label: l10n.profileSettings,
            routeName: SettingsPage.routeName,
          ),
          _ProfileMenuTile(
            icon: Icons.privacy_tip_outlined,
            label: l10n.profilePrivacy,
            routeName: PrivacyPage.routeName,
          ),
          _ProfileMenuTile(
            icon: Icons.help_outline,
            label: l10n.profileHelp,
            routeName: HelpPage.routeName,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.profileSignOut),
            onTap: () => _confirmSignOut(context, ref),
          ),
        ],
      ),
    );
  }

  /// Asks for confirmation, then signs out via the auth repository.
  Future<void> _confirmSignOut(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.profileSignOutDialogTitle),
        content: Text(l10n.profileSignOutDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.profileSignOut),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      await ref.read(authRepositoryProvider).signOut();
    }
  }
}

/// A single tappable row in the profile menu that pushes a named sub-route.
class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.label,
    required this.routeName,
  });

  final IconData icon;
  final String label;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.pushNamed(routeName),
    );
  }
}
