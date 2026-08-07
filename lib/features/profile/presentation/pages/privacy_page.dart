import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../widgets/legal_text_section.dart';

/// The privacy policy: a static, localized explanation of what data Zaiko
/// stores and where.
///
/// Portfolio-level content, not a legally reviewed policy — the disclaimer says
/// as much. Reached from the profile tab.
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  /// Relative segment under the profile branch (`/profile/privacy`).
  static const String routeSegment = 'privacy';
  static const String routeName = 'profile-privacy';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profilePrivacy)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageInset,
          AppSpacing.s5,
          AppSpacing.pageInset,
          AppSpacing.s10,
        ),
        children: [
          Text(
            l10n.privacyDisclaimer,
            style: AppTypography.caption.copyWith(color: colors.textTertiary),
          ),
          const SizedBox(height: AppSpacing.s6),
          LegalTextSection(
            title: l10n.privacyDataTitle,
            body: l10n.privacyDataBody,
          ),
          LegalTextSection(
            title: l10n.privacyStorageTitle,
            body: l10n.privacyStorageBody,
          ),
          LegalTextSection(
            title: l10n.privacyConsentTitle,
            body: l10n.privacyConsentBody,
          ),
          LegalTextSection(
            title: l10n.privacyRightsTitle,
            body: l10n.privacyRightsBody,
            isLast: true,
          ),
        ],
      ),
    );
  }
}
