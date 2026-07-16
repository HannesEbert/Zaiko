import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../../shared/widgets/zaiko_card.dart';
import '../../../auth/application/auth_providers.dart';
import 'household_link_page.dart';
import 'profile_edit_page.dart';
import 'reminders_page.dart';
import 'settings_page.dart';

/// Profile tab: account, household and settings, plus sign-out.
///
/// The account/household details are demo content; the rows navigate to the
/// existing (placeholder) sub-pages. Sign-out flows through the auth
/// repository, after which the router redirect returns the user to login.
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  static const String routePath = '/profile';
  static const String routeName = 'profile';

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageInset,
            AppSpacing.s3 + 2,
            AppSpacing.pageInset,
            AppSpacing.s10,
          ),
          children: [
            Text(
              l10n.profileTitle,
              style: AppTypography.screenTitle.copyWith(
                color: colors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.s4),
            _AccountCard(
              onTap: () => context.pushNamed(ProfileEditPage.routeName),
            ),
            const SizedBox(height: AppSpacing.s5),
            SectionLabel(l10n.profileHouseholdSection),
            const SizedBox(height: AppSpacing.s2),
            _HouseholdCard(
              onInvite: () => context.pushNamed(HouseholdLinkPage.routeName),
            ),
            const SizedBox(height: AppSpacing.s5),
            SectionLabel(l10n.profileSettingsSection),
            const SizedBox(height: AppSpacing.s2),
            CardList(
              children: [
                _SettingRow(
                  icon: Icons.notifications_outlined,
                  label: l10n.settingNotifications,
                  trailing: Switch.adaptive(
                    value: _notificationsEnabled,
                    onChanged: (value) =>
                        setState(() => _notificationsEnabled = value),
                  ),
                ),
                _SettingRow(
                  icon: Icons.schedule_outlined,
                  label: l10n.settingReminder,
                  value: l10n.settingReminderValue,
                  onTap: () => context.pushNamed(RemindersPage.routeName),
                ),
                _SettingRow(
                  icon: Icons.dark_mode_outlined,
                  label: l10n.settingAppearance,
                  value: l10n.settingAppearanceSystem,
                  onTap: () => context.pushNamed(SettingsPage.routeName),
                ),
                _SettingRow(
                  icon: Icons.language_outlined,
                  label: l10n.settingLanguage,
                  value: l10n.settingLanguageGerman,
                  onTap: () => context.pushNamed(SettingsPage.routeName),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s4),
            ZaikoCard(
              child: _SignOutRow(onTap: () => _confirmSignOut(context, ref)),
            ),
            const SizedBox(height: AppSpacing.s3 + 2),
            Center(
              child: Text(
                l10n.profileVersion('0.1.0'),
                style: AppTypography.caption.copyWith(
                  fontSize: 12,
                  color: colors.textTertiary,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ),
          ],
        ),
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

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ZaikoCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.s3 + 2),
      child: Row(
        children: [
          const UserAvatar(initial: 'H', size: 52),
          const SizedBox(width: AppSpacing.s3 + 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hannes',
                  style: AppTypography.headline.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  'hannes@beispiel.de',
                  style: AppTypography.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 18, color: colors.borderStrong),
        ],
      ),
    );
  }
}

class _HouseholdCard extends StatelessWidget {
  const _HouseholdCard({required this.onInvite});

  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return ZaikoCard(
      padding: const EdgeInsets.all(AppSpacing.s3 + 2),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lindenhof',
                      style: AppTypography.bodyMedium.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    Text(
                      l10n.profileMembersCount(2),
                      style: AppTypography.caption.copyWith(
                        color: colors.textSecondary,
                        fontFeatures: AppTypography.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 52,
                height: 30,
                child: Stack(
                  children: [
                    UserAvatar(
                      initial: 'H',
                      size: 30,
                      borderColor: colors.card,
                    ),
                    Positioned(
                      left: 22,
                      child: UserAvatar(
                        initial: 'M',
                        size: 30,
                        accent: false,
                        borderColor: colors.card,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          OutlinedButton.icon(
            onPressed: onInvite,
            icon: const Icon(Icons.person_add_alt, size: 16),
            label: Text(l10n.profileInviteMember),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(40),
              foregroundColor: colors.accentText,
              side: BorderSide(color: colors.borderSubtle),
              textStyle: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm + 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s3 + 2,
          vertical: AppSpacing.s3,
        ),
        child: Row(
          children: [
            Icon(icon, size: 19, color: colors.textStrong),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Text(
                label,
                style: AppTypography.body.copyWith(color: colors.textPrimary),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (value != null) ...[
              Text(
                value!,
                style: AppTypography.caption.copyWith(
                  fontSize: 14,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(width: AppSpacing.s1 + 2),
              Icon(Icons.chevron_right, size: 16, color: colors.borderStrong),
            ],
          ],
        ),
      ),
    );
  }
}

class _SignOutRow extends StatelessWidget {
  const _SignOutRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s3 + 2,
          vertical: AppSpacing.s3,
        ),
        child: Row(
          children: [
            Icon(Icons.logout, size: 18, color: colors.error),
            const SizedBox(width: AppSpacing.s3),
            Text(
              context.l10n.profileSignOut,
              style: AppTypography.bodyMedium.copyWith(color: colors.error),
            ),
          ],
        ),
      ),
    );
  }
}
