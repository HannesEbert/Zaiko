import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/zaiko_buttons.dart';
import '../../../auth/presentation/widgets/field_label.dart';

/// The name + palette-key + icon-key values entered in the [showTaxonomyEditor]
/// sheet. `color`/`icon` are stable keys resolved via `AppColors`/`AppIcons`.
class TaxonomyDraft {
  const TaxonomyDraft({required this.name, this.color, this.icon});

  final String name;
  final String? color;
  final String? icon;
}

/// Opens the shared create/edit sheet for a storage location or category and
/// returns the entered [TaxonomyDraft], or null if the user cancelled.
///
/// Persisting the draft is the caller's job — this sheet only collects input,
/// so it stays agnostic of which taxonomy (location vs. category) it edits.
Future<TaxonomyDraft?> showTaxonomyEditor({
  required BuildContext context,
  required String title,
  required String submitLabel,
  TaxonomyDraft? initial,
}) {
  return showModalBottomSheet<TaxonomyDraft>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _TaxonomyEditorSheet(
      title: title,
      submitLabel: submitLabel,
      initial: initial,
    ),
  );
}

class _TaxonomyEditorSheet extends StatefulWidget {
  const _TaxonomyEditorSheet({
    required this.title,
    required this.submitLabel,
    this.initial,
  });

  final String title;
  final String submitLabel;
  final TaxonomyDraft? initial;

  @override
  State<_TaxonomyEditorSheet> createState() => _TaxonomyEditorSheetState();
}

class _TaxonomyEditorSheetState extends State<_TaxonomyEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController = TextEditingController(
    text: widget.initial?.name ?? '',
  );
  late String _color = widget.initial?.color ?? AppColors.paletteKeys.first;
  late String _icon = widget.initial?.icon ?? AppIcons.selectableKeys.first;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      TaxonomyDraft(
        name: _nameController.text.trim(),
        color: _color,
        icon: _icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final accent = AppColors.categoryForKey(_color);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.s5,
              AppSpacing.s2,
              AppSpacing.s5,
              AppSpacing.s5,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Grabber(),
                  Text(
                    widget.title,
                    style: AppTypography.headline.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  FieldLabel(l10n.taxonomyNameLabel),
                  const SizedBox(height: AppSpacing.s1 + 2),
                  TextFormField(
                    controller: _nameController,
                    autofocus: widget.initial == null,
                    textCapitalization: TextCapitalization.sentences,
                    textInputAction: TextInputAction.done,
                    style: AppTypography.body.copyWith(
                      color: colors.textPrimary,
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                        ? l10n.taxonomyNameEmpty
                        : null,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  FieldLabel(l10n.taxonomyColorLabel),
                  const SizedBox(height: AppSpacing.s2 + 2),
                  Wrap(
                    spacing: AppSpacing.s3,
                    runSpacing: AppSpacing.s3,
                    children: [
                      for (final key in AppColors.paletteKeys)
                        _ColorDot(
                          color: AppColors.categoryForKey(key),
                          selected: key == _color,
                          onTap: () => setState(() => _color = key),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  FieldLabel(l10n.taxonomyIconLabel),
                  const SizedBox(height: AppSpacing.s2 + 2),
                  Wrap(
                    spacing: AppSpacing.s3,
                    runSpacing: AppSpacing.s3,
                    children: [
                      for (final key in AppIcons.selectableKeys)
                        _IconChoice(
                          icon: AppIcons.forKey(key),
                          color: accent,
                          selected: key == _icon,
                          onTap: () => setState(() => _icon = key),
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  ZaikoPrimaryButton(
                    label: widget.submitLabel,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 36,
        height: 4,
        margin: const EdgeInsets.only(bottom: AppSpacing.s3),
        decoration: BoxDecoration(
          color: context.colors.borderStrong,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: selected
              ? Border.all(color: context.colors.textPrimary, width: 2.5)
              : null,
        ),
        child: selected
            ? Icon(Icons.check, size: 16, color: context.colors.onAccent)
            : null,
      ),
    );
  }
}

class _IconChoice extends StatelessWidget {
  const _IconChoice({
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: selected ? Border.all(color: color, width: 2) : null,
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }
}
