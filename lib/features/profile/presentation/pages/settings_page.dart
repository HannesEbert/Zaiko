import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../../shared/widgets/setting_row.dart';
import '../../application/profile_providers.dart';
import '../profile_error_message.dart';

/// App settings: the language picker and a read-only appearance row.
///
/// Language is persisted to the profile and switches the UI immediately (see
/// [LocaleSettingController]/[appLocaleProvider]). Appearance is fixed to dark
/// for now, shown as information rather than a toggle.
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  /// Relative segment under the profile branch (`/profile/settings`).
  static const String routeSegment = 'settings';
  static const String routeName = 'profile-settings';

  /// The display label for a stored language [code] (`null` = follow system).
  static String languageLabel(AppLocalizations l10n, String? code) =>
      switch (code) {
        'de' => l10n.settingLanguageGerman,
        'en' => l10n.settingLanguageEnglish,
        _ => l10n.settingLanguageSystem,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final current = ref.watch(myProfileProvider).value?.locale;
    final isBusy = ref.watch(localeSettingControllerProvider).isLoading;

    Future<void> select(String? code) async {
      if (code == current || isBusy) return;
      final ok = await ref
          .read(localeSettingControllerProvider.notifier)
          .setLocale(code);
      if (!context.mounted || ok) return;
      showProfileErrorSnackBar(
        context,
        ref,
        error: ref.read(localeSettingControllerProvider).error,
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileSettings)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.pageInset,
          AppSpacing.s5,
          AppSpacing.pageInset,
          AppSpacing.s10,
        ),
        children: [
          SectionLabel(l10n.settingLanguage),
          const SizedBox(height: AppSpacing.s2),
          CardList(
            children: [
              for (final code in <String?>[null, 'de', 'en'])
                _LanguageRow(
                  label: languageLabel(l10n, code),
                  selected: code == current,
                  onTap: () => select(code),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.s5),
          SectionLabel(l10n.settingAppearance),
          const SizedBox(height: AppSpacing.s2),
          CardList(
            children: [
              SettingRow(
                icon: Icons.dark_mode_outlined,
                label: l10n.settingAppearance,
                value: l10n.settingAppearanceDark,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s1 + 2),
            child: Text(
              l10n.settingAppearanceHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.colors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A language option row that shows an accent check when [selected].
class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SettingRow(
      icon: Icons.language_outlined,
      label: label,
      onTap: onTap,
      trailing: selected
          ? Icon(Icons.check, size: 18, color: colors.accentText)
          : const SizedBox.shrink(),
    );
  }
}
