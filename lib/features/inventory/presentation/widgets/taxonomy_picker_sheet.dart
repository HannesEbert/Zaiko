import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/icon_tile.dart';

/// A selectable option in the taxonomy picker (a storage location or category),
/// reduced to the fields the picker renders.
class TaxonomyOption {
  const TaxonomyOption({
    required this.id,
    required this.name,
    this.color,
    this.icon,
  });

  final String id;
  final String name;
  final String? color;
  final String? icon;
}

/// The picker's result: the chosen option's [id], or null for "none". A null
/// *return* from [showTaxonomyPicker] means the sheet was dismissed without a
/// choice (e.g. the user went to the management screen) — the field is left as
/// is.
class TaxonomySelection {
  const TaxonomySelection(this.id);

  final String? id;
}

/// Opens a bottom sheet to pick one taxonomy option, create a new one inline,
/// or jump to the management screen.
///
/// [onCreate] runs the inline "+ new" flow and returns the created id (or null
/// if cancelled); [onManage] opens the management screen. Both are injected so
/// this sheet stays independent of the specific providers behind locations vs.
/// categories.
Future<TaxonomySelection?> showTaxonomyPicker({
  required BuildContext context,
  required String title,
  required List<TaxonomyOption> options,
  required String? selectedId,
  required Future<String?> Function(BuildContext context) onCreate,
  required VoidCallback onManage,
}) {
  return showModalBottomSheet<TaxonomySelection>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _TaxonomyPickerSheet(
      title: title,
      options: options,
      selectedId: selectedId,
      onCreate: onCreate,
      onManage: onManage,
    ),
  );
}

class _TaxonomyPickerSheet extends StatelessWidget {
  const _TaxonomyPickerSheet({
    required this.title,
    required this.options,
    required this.selectedId,
    required this.onCreate,
    required this.onManage,
  });

  final String title;
  final List<TaxonomyOption> options;
  final String? selectedId;
  final Future<String?> Function(BuildContext context) onCreate;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.lg),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AppSpacing.s2),
            const _Grabber(),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s5,
                0,
                AppSpacing.s5,
                AppSpacing.s2,
              ),
              child: Row(
                children: [
                  Text(
                    title,
                    style: AppTypography.headline.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s5),
                children: [
                  _OptionRow(
                    leading: Icon(
                      Icons.block,
                      size: 20,
                      color: colors.textTertiary,
                    ),
                    label: l10n.pickerNone,
                    selected: selectedId == null,
                    onTap: () => Navigator.of(
                      context,
                    ).pop(const TaxonomySelection(null)),
                  ),
                  for (final option in options)
                    _OptionRow(
                      leading: IconTile(
                        AppIcons.forKey(option.icon),
                        color: AppColors.categoryForKey(option.color),
                        size: 36,
                        iconSize: 18,
                      ),
                      label: option.name,
                      selected: option.id == selectedId,
                      onTap: () => Navigator.of(
                        context,
                      ).pop(TaxonomySelection(option.id)),
                    ),
                ],
              ),
            ),
            Divider(height: 1, color: colors.divider),
            _ActionRow(
              icon: Icons.add,
              label: l10n.pickerNew,
              onTap: () async {
                final createdId = await onCreate(context);
                if (createdId != null && context.mounted) {
                  Navigator.of(context).pop(TaxonomySelection(createdId));
                }
              },
            ),
            _ActionRow(
              icon: Icons.tune,
              label: l10n.pickerManage,
              onTap: () {
                Navigator.of(context).pop();
                onManage();
              },
            ),
            const SizedBox(height: AppSpacing.s2),
          ],
        ),
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.leading,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final Widget leading;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2 + 2),
        child: Row(
          children: [
            SizedBox(width: 36, height: 36, child: Center(child: leading)),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            if (selected) Icon(Icons.check, size: 18, color: colors.accentText),
          ],
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s5,
          vertical: AppSpacing.s3 + 2,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: colors.accentText),
            const SizedBox(width: AppSpacing.s3),
            Text(
              label,
              style: AppTypography.bodyMedium.copyWith(
                color: colors.accentText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 4,
      margin: const EdgeInsets.only(bottom: AppSpacing.s3),
      decoration: BoxDecoration(
        color: context.colors.borderStrong,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
    );
  }
}
