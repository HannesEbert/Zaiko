import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../../shared/widgets/zaiko_buttons.dart';
import '../../../household/application/households_providers.dart';
import '../../../household/domain/household.dart';
import '../../../household/domain/household_role.dart';
import '../../../household/presentation/household_error_message.dart';
import '../../../household/presentation/widgets/household_avatar.dart';
import '../../../household/presentation/widgets/invite_sheet.dart';
import '../../application/profile_providers.dart';
import '../../domain/profile.dart';
import '../widgets/profile_avatar.dart';

/// Household management: the member roster, inviting new members, renaming the
/// household (owner), removing members (owner) and leaving it.
class HouseholdLinkPage extends ConsumerWidget {
  const HouseholdLinkPage({super.key});

  /// Relative segment under the profile branch (`/profile/household`).
  static const String routeSegment = 'household';
  static const String routeName = 'profile-household';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final household = ref.watch(currentHouseholdProvider);

    // Surface management failures (rename/remove/leave) as a snack bar.
    ref.listen(householdManagementControllerProvider, (_, next) {
      if (next case AsyncError(:final error)) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(householdErrorMessage(l10n, error))),
          );
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileHousehold)),
      body: household.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Text(
            l10n.householdErrorGeneric,
            style: AppTypography.body.copyWith(color: context.colors.error),
          ),
        ),
        data: (data) => data == null
            ? EmptyState(
                icon: Icons.group_outlined,
                title: l10n.profileHouseholdEmptyTitle,
                message: l10n.profileHouseholdEmptyMessage,
              )
            : _HouseholdView(household: data),
      ),
    );
  }
}

class _HouseholdView extends ConsumerWidget {
  const _HouseholdView({required this.household});

  final Household household;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final members = ref.watch(householdMembersProvider(household.id));
    final currentUserId = ref.watch(householdRepositoryProvider).currentUserId;
    // Member display names and avatars, resolved by user id. Absent while it
    // loads (or for members whose profile the caller may not read), in which
    // case the row falls back to the generic avatar and role.
    final profiles =
        ref.watch(householdMemberProfilesProvider).value ??
        const <String, Profile>{};
    final isOwner =
        members.value?.any(
          (m) => m.userId == currentUserId && m.role == HouseholdRole.owner,
        ) ??
        false;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageInset,
        AppSpacing.s4,
        AppSpacing.pageInset,
        AppSpacing.s10,
      ),
      children: [
        _HouseholdHeader(
          household: household,
          canRename: isOwner,
          onRename: () => _showRename(context, ref, household),
        ),
        const SizedBox(height: AppSpacing.s5),
        SectionLabel(l10n.householdMembersTitle),
        const SizedBox(height: AppSpacing.s2),
        members.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(AppSpacing.s6),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => Text(
            l10n.householdErrorGeneric,
            style: AppTypography.caption.copyWith(color: colors.error),
          ),
          data: (roster) => CardList(
            children: [
              for (final member in roster)
                _MemberRow(
                  role: member.role,
                  isSelf: member.userId == currentUserId,
                  profile: profiles[member.userId],
                  canRemove: isOwner && member.userId != currentUserId,
                  onRemove: () => _showRemoveConfirm(
                    context,
                    ref,
                    householdId: household.id,
                    userId: member.userId,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s5),
        ZaikoPrimaryButton(
          label: l10n.profileInviteMember,
          icon: Icons.person_add_alt,
          onPressed: () => showInviteSheet(context, household.id),
        ),
        const SizedBox(height: AppSpacing.s3),
        TextButton.icon(
          onPressed: () => _showLeaveConfirm(context, ref, household.id),
          icon: Icon(Icons.logout, size: 18, color: colors.error),
          label: Text(
            l10n.householdLeave,
            style: AppTypography.bodyMedium.copyWith(color: colors.error),
          ),
          style: TextButton.styleFrom(
            minimumSize: const Size.fromHeight(AppSpacing.s12),
          ),
        ),
      ],
    );
  }

  Future<void> _showRename(
    BuildContext context,
    WidgetRef ref,
    Household household,
  ) async {
    final l10n = context.l10n;
    final controller = TextEditingController(text: household.name);
    final name = await showDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.householdRename),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(hintText: l10n.onboardingNameHint),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.of(dialogContext).pop(controller.text.trim()),
            child: Text(l10n.householdRenameSave),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty || name == household.name) return;
    await ref
        .read(householdManagementControllerProvider.notifier)
        .rename(householdId: household.id, name: name);
  }

  Future<void> _showRemoveConfirm(
    BuildContext context,
    WidgetRef ref, {
    required String householdId,
    required String userId,
  }) async {
    final l10n = context.l10n;
    final confirmed = await _confirm(
      context,
      title: l10n.householdRemoveMemberTitle,
      message: l10n.householdRemoveMemberMessage,
      confirmLabel: l10n.householdRemoveMember,
    );
    if (!confirmed) return;
    await ref
        .read(householdManagementControllerProvider.notifier)
        .removeMember(householdId: householdId, userId: userId);
  }

  Future<void> _showLeaveConfirm(
    BuildContext context,
    WidgetRef ref,
    String householdId,
  ) async {
    final l10n = context.l10n;
    final confirmed = await _confirm(
      context,
      title: l10n.householdLeaveTitle,
      message: l10n.householdLeaveMessage,
      confirmLabel: l10n.householdLeaveConfirm,
    );
    if (!confirmed) return;
    // Leaving flips membership to `none`; the router redirect handles the exit.
    await ref
        .read(householdManagementControllerProvider.notifier)
        .leave(householdId);
  }

  Future<bool> _confirm(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
  }) async {
    final l10n = context.l10n;
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}

/// Household name with an edit affordance for owners.
class _HouseholdHeader extends StatelessWidget {
  const _HouseholdHeader({
    required this.household,
    required this.canRename,
    required this.onRename,
  });

  final Household household;
  final bool canRename;
  final VoidCallback onRename;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          child: Text(
            household.name,
            style: AppTypography.screenTitle.copyWith(
              color: colors.textPrimary,
            ),
          ),
        ),
        if (canRename)
          IconButton(
            onPressed: onRename,
            icon: Icon(Icons.edit_outlined, size: 20, color: colors.accentText),
            tooltip: context.l10n.householdRename,
          ),
      ],
    );
  }
}

/// A single roster row: avatar, name/role, and (for owners) a remove action.
///
/// With a resolved [profile] it shows the member's real avatar and display name
/// (the current user is marked "(You)"); without one it falls back to the
/// generic avatar and role, so the roster still renders while profiles load.
class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.role,
    required this.isSelf,
    required this.profile,
    required this.canRemove,
    required this.onRemove,
  });

  final HouseholdRole role;
  final bool isSelf;
  final Profile? profile;
  final bool canRemove;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final roleLabel = _roleLabel(l10n, role);
    final memberProfile = profile;

    final String primary;
    final String? secondary;
    if (memberProfile != null) {
      primary = isSelf
          ? '${memberProfile.displayName} (${l10n.householdYou})'
          : memberProfile.displayName;
      secondary = roleLabel;
    } else {
      primary = isSelf ? l10n.householdYou : roleLabel;
      secondary = isSelf ? roleLabel : null;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3 + 2,
        vertical: AppSpacing.s3,
      ),
      child: Row(
        children: [
          if (memberProfile != null)
            ProfileAvatar(profile: memberProfile)
          else
            HouseholdAvatar(accent: isSelf),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  primary,
                  style: AppTypography.body.copyWith(color: colors.textPrimary),
                ),
                if (secondary != null)
                  Text(
                    secondary,
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          if (canRemove)
            IconButton(
              onPressed: onRemove,
              icon: Icon(
                Icons.remove_circle_outline,
                size: 20,
                color: colors.error,
              ),
              tooltip: l10n.householdRemoveMember,
            ),
        ],
      ),
    );
  }

  String _roleLabel(AppLocalizations l10n, HouseholdRole role) =>
      role == HouseholdRole.owner
      ? l10n.householdRoleOwner
      : l10n.householdRoleMember;
}
