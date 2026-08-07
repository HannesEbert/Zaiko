import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../application/profile_providers.dart';
import '../widgets/legal_text_section.dart';

/// Help and support: a static FAQ, a contact action and the app version.
///
/// Content is localized and portfolio-level. The contact button opens the
/// user's mail app addressed to [AppConstants.supportEmail]; the version is
/// read from the running build.
class HelpPage extends ConsumerWidget {
  const HelpPage({super.key});

  /// Relative segment under the profile branch (`/profile/help`).
  static const String routeSegment = 'help';
  static const String routeName = 'profile-help';

  Future<void> _contact(BuildContext context, WidgetRef ref) async {
    final uri = Uri(scheme: 'mailto', path: AppConstants.supportEmail);
    final launched = await launchUrl(uri);
    if (!context.mounted || launched) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.helpContactError)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final version = ref.watch(appVersionProvider).value ?? '';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileHelp)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageInset,
          AppSpacing.s5,
          AppSpacing.pageInset,
          AppSpacing.s10,
        ),
        children: [
          LegalTextSection(title: l10n.helpFaqAddQ, body: l10n.helpFaqAddA),
          LegalTextSection(
            title: l10n.helpFaqExpiryQ,
            body: l10n.helpFaqExpiryA,
          ),
          LegalTextSection(
            title: l10n.helpFaqHouseholdQ,
            body: l10n.helpFaqHouseholdA,
          ),
          LegalTextSection(
            title: l10n.helpFaqOfflineQ,
            body: l10n.helpFaqOfflineA,
            isLast: true,
          ),
          const SizedBox(height: AppSpacing.s6),
          Text(
            l10n.helpContactTitle,
            style: AppTypography.bodyMedium.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.s2),
          Text(
            l10n.helpContactBody,
            style: AppTypography.body.copyWith(
              color: colors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppSpacing.s3),
          OutlinedButton.icon(
            onPressed: () => _contact(context, ref),
            icon: const Icon(Icons.mail_outline, size: 16),
            label: Text(l10n.helpContactButton),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(44),
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
          const SizedBox(height: AppSpacing.s8),
          Center(
            child: Text(
              l10n.profileVersion(version),
              style: AppTypography.caption.copyWith(
                fontSize: 12,
                color: colors.textTertiary,
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
