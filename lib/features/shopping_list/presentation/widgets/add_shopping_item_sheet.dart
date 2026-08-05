import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/widgets/field_label.dart';
import '../../../inventory/application/inventory_providers.dart';
import '../../../inventory/presentation/pages/manage_categories_page.dart';
import '../../../inventory/presentation/widgets/taxonomy_editor_sheet.dart';
import '../../../inventory/presentation/widgets/taxonomy_picker_sheet.dart';
import '../../application/shopping_providers.dart';
import '../../domain/shopping_item.dart';
import '../shopping_error_message.dart';

/// Opens the "add to list" / "edit item" bottom sheet. Passing an [item] edits
/// it; passing null creates a new one. Resolves once the sheet is dismissed;
/// the list refreshes itself through the realtime stream.
Future<void> showAddShoppingItemSheet(
  BuildContext context, {
  ShoppingItem? item,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AddShoppingItemSheet(item: item),
  );
}

class _AddShoppingItemSheet extends ConsumerStatefulWidget {
  const _AddShoppingItemSheet({this.item});

  final ShoppingItem? item;

  @override
  ConsumerState<_AddShoppingItemSheet> createState() =>
      _AddShoppingItemSheetState();
}

class _AddShoppingItemSheetState extends ConsumerState<_AddShoppingItemSheet> {
  late final TextEditingController _nameController = TextEditingController(
    text: widget.item?.name ?? '',
  );
  late final TextEditingController _quantityController = TextEditingController(
    text: widget.item?.quantity ?? '',
  );
  late String? _categoryId = widget.item?.categoryId;

  bool get _isEdit => widget.item != null;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final isBusy = ref.watch(shoppingListControllerProvider).isLoading;
    final categories = ref.watch(categoriesProvider).asData?.value ?? const [];
    final categoryName = categories
        .where((category) => category.id == _categoryId)
        .map((category) => category.name)
        .firstOrNull;

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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Grabber(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _isEdit ? l10n.shoppingEditTitle : l10n.shoppingAddTitle,
                      style: AppTypography.headline.copyWith(
                        color: colors.textPrimary,
                      ),
                    ),
                    _CloseButton(onTap: () => Navigator.of(context).pop()),
                  ],
                ),
                const SizedBox(height: AppSpacing.s4),
                FieldLabel(l10n.itemFormNameLabel),
                const SizedBox(height: AppSpacing.s1 + 2),
                TextField(
                  controller: _nameController,
                  autofocus: !_isEdit,
                  enabled: !isBusy,
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                  style: AppTypography.body.copyWith(color: colors.textPrimary),
                  decoration: InputDecoration(hintText: l10n.itemFormNameHint),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: AppSpacing.s4),
                FieldLabel(l10n.shoppingQuantityLabel),
                const SizedBox(height: AppSpacing.s1 + 2),
                TextField(
                  controller: _quantityController,
                  enabled: !isBusy,
                  textCapitalization: TextCapitalization.sentences,
                  style: AppTypography.body.copyWith(color: colors.textPrimary),
                  decoration: InputDecoration(
                    hintText: l10n.shoppingQuantityHint,
                  ),
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: AppSpacing.s4),
                FieldLabel(l10n.itemFormCategoryLabel),
                const SizedBox(height: AppSpacing.s1 + 2),
                _PickerField(
                  value: categoryName ?? l10n.itemFormNone,
                  muted: categoryName == null,
                  onTap: isBusy ? null : _pickCategory,
                ),
                const SizedBox(height: AppSpacing.s5),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: isBusy ? null : _submit,
                    child: Text(
                      _isEdit
                          ? l10n.shoppingSaveButton
                          : l10n.shoppingAddButton,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickCategory() async {
    final l10n = context.l10n;
    final categories = ref.read(categoriesProvider).asData?.value ?? const [];
    final selection = await showTaxonomyPicker(
      context: context,
      title: l10n.pickerCategoryTitle,
      selectedId: _categoryId,
      options: [
        for (final category in categories)
          TaxonomyOption(
            id: category.id,
            name: category.name,
            color: category.color,
            icon: category.icon,
          ),
      ],
      onCreate: (pickerContext) async {
        final draft = await showTaxonomyEditor(
          context: pickerContext,
          title: l10n.taxonomyNewCategoryTitle,
          submitLabel: l10n.taxonomyCreateButton,
        );
        if (draft == null) return null;
        return ref
            .read(categoryControllerProvider.notifier)
            .add(name: draft.name, icon: draft.icon, color: draft.color);
      },
      onManage: () => ManageCategoriesPage.open(context),
    );
    if (selection != null) {
      setState(() => _categoryId = selection.id);
    }
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    final quantity = _quantityController.text.trim();
    final controller = ref.read(shoppingListControllerProvider.notifier);

    final ok = _isEdit
        ? await controller.save(
            id: widget.item!.id,
            name: name,
            quantity: quantity.isEmpty ? null : quantity,
            categoryId: _categoryId,
          )
        : await controller.add(
            name: name,
            quantity: quantity.isEmpty ? null : quantity,
            categoryId: _categoryId,
          );

    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      showShoppingErrorSnackBar(context, ref);
    }
  }
}

/// A read-only, tappable field that shows the current picker selection.
class _PickerField extends StatelessWidget {
  const _PickerField({required this.value, required this.muted, this.onTap});

  final String value;
  final bool muted;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.field,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          height: AppSpacing.s12,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: colors.borderSubtle),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: AppTypography.body.copyWith(
                    color: muted ? colors.textTertiary : colors.textPrimary,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, size: 18, color: colors.borderStrong),
            ],
          ),
        ),
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.sunken,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(Icons.close, size: 15, color: colors.textSecondary),
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
