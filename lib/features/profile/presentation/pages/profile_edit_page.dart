import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/widgets/field_label.dart';
import '../../application/profile_providers.dart';
import '../profile_error_message.dart';
import '../widgets/avatar_picker.dart';
import '../widgets/profile_avatar.dart';

/// Edit the current user's profile: display name and avatar.
///
/// Reached from the account card. Email and password changes are handled by the
/// auth feature and only surfaced here as a hint. Saving delegates to the
/// [ProfileEditController]; on success it pops back to the profile tab.
class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  /// Relative segment under the profile branch (`/profile/edit`).
  static const String routeSegment = 'edit';
  static const String routeName = 'profile-edit';

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final TextEditingController _nameController = TextEditingController();
  String? _selectedPreset;
  bool _seeded = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profileAsync = ref.watch(myProfileProvider);
    final email = ref.watch(currentUserEmailProvider).value;
    final isBusy = ref.watch(profileEditControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileManageAccount)),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.pageInset),
            child: Text(
              l10n.profileErrorGeneric,
              style: AppTypography.body.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
        ),
        data: (profile) {
          if (profile == null) return const SizedBox.shrink();
          if (!_seeded) {
            _nameController.text = profile.displayName;
            _selectedPreset = profile.avatarPreset;
            _seeded = true;
          }

          final initial = ProfileAvatar.initialOf(
            _nameController.text.isEmpty
                ? profile.displayName
                : _nameController.text,
          );
          final canSave = _nameController.text.trim().isNotEmpty && !isBusy;

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageInset,
              AppSpacing.s5,
              AppSpacing.pageInset,
              AppSpacing.s10,
            ),
            children: [
              FieldLabel(l10n.profileAvatarSectionTitle),
              const SizedBox(height: AppSpacing.s3),
              AvatarPicker(
                initial: initial,
                userId: profile.id,
                selectedPreset: _selectedPreset,
                onSelected: (key) => setState(() => _selectedPreset = key),
              ),
              const SizedBox(height: AppSpacing.s5),
              FieldLabel(l10n.profileDisplayNameLabel),
              const SizedBox(height: AppSpacing.s1 + 2),
              TextField(
                controller: _nameController,
                enabled: !isBusy,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.done,
                style: AppTypography.body.copyWith(
                  color: context.colors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: l10n.profileDisplayNameLabel,
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.s5),
              FieldLabel(l10n.profileEmailLabel),
              const SizedBox(height: AppSpacing.s1 + 2),
              _ReadOnlyField(value: email ?? '—'),
              const SizedBox(height: AppSpacing.s2),
              Text(
                l10n.profileEmailChangeHint,
                style: AppTypography.caption.copyWith(
                  color: context.colors.textTertiary,
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: canSave ? _submit : null,
                  child: isBusy
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.commonSave),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    final ok = await ref
        .read(profileEditControllerProvider.notifier)
        .save(
          displayName: _nameController.text.trim(),
          avatarPreset: _selectedPreset,
        );

    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      showProfileErrorSnackBar(context, ref);
    }
  }
}

/// A disabled, read-only rendering of a value in the same box style as the
/// editable fields, used for the email row.
class _ReadOnlyField extends StatelessWidget {
  const _ReadOnlyField({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3 + 2,
        vertical: AppSpacing.s3,
      ),
      decoration: BoxDecoration(
        color: colors.field,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Text(
        value,
        style: AppTypography.body.copyWith(color: colors.textSecondary),
      ),
    );
  }
}
