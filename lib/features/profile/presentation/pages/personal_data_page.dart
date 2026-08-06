import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/zaiko_card.dart';
import '../../../household/application/households_providers.dart';
import '../../application/profile_providers.dart';
import '../../domain/profile.dart';
import '../widgets/profile_avatar.dart';

/// Read-only overview of the user's stored data: avatar, name, email, household
/// and when they joined. Editing happens on the profile-edit page.
class PersonalDataPage extends ConsumerWidget {
  const PersonalDataPage({super.key});

  /// Relative segment under the profile branch (`/profile/personal-data`).
  static const String routeSegment = 'personal-data';
  static const String routeName = 'profile-personal-data';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final profileAsync = ref.watch(myProfileProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profilePersonalData)),
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
        data: (profile) => profile == null
            ? const SizedBox.shrink()
            : _Overview(profile: profile),
      ),
    );
  }
}

class _Overview extends ConsumerWidget {
  const _Overview({required this.profile});

  final Profile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final email = ref.watch(currentUserEmailProvider).value;
    final household = ref.watch(currentHouseholdProvider).value;
    final materialL10n = MaterialLocalizations.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageInset,
        AppSpacing.s6,
        AppSpacing.pageInset,
        AppSpacing.s10,
      ),
      children: [
        Center(
          child: Column(
            children: [
              ProfileAvatar(profile: profile, size: 72),
              const SizedBox(height: AppSpacing.s3),
              Text(
                profile.displayName,
                style: AppTypography.headline.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.s6),
        ZaikoCard(
          child: Column(
            children: [
              _DataRow(
                label: l10n.profileDisplayNameLabel,
                value: profile.displayName,
              ),
              _DataRow(label: l10n.profileEmailLabel, value: email ?? '—'),
              _DataRow(
                label: l10n.profileHousehold,
                value: household?.name ?? l10n.profilePersonalDataNoHousehold,
              ),
              _DataRow(
                label: l10n.profileMemberSince,
                value: materialL10n.formatMonthYear(profile.createdAt),
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A label/value line inside the overview card, with a hairline divider unless
/// it is the [isLast] row.
class _DataRow extends StatelessWidget {
  const _DataRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: isLast
          ? null
          : BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.borderSubtle)),
            ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3 + 2,
        vertical: AppSpacing.s3 + 1,
      ),
      child: Row(
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(color: colors.textSecondary),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTypography.bodyMedium.copyWith(
                color: colors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
