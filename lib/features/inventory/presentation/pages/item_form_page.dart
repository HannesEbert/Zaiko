import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/zaiko_buttons.dart';
import '../../../auth/presentation/widgets/field_label.dart';
import '../../../food/application/food_providers.dart';
import '../../../food/domain/food.dart';
import '../../../food/domain/food_failure.dart';
import '../../application/inventory_providers.dart';
import '../../domain/category.dart';
import '../../domain/inventory_item.dart';
import '../../domain/inventory_unit.dart';
import '../../domain/storage_location.dart';
import '../inventory_error_message.dart';
import '../inventory_labels.dart';
import '../inventory_validators.dart';
import '../widgets/taxonomy_editor_sheet.dart';
import '../widgets/taxonomy_picker_sheet.dart';
import 'manage_categories_page.dart';
import 'manage_storage_locations_page.dart';

/// Full-screen form to add a new inventory item or edit an existing one — the
/// manual write path behind the add sheet and the detail page's edit button.
///
/// A null [item] is "add" mode; a non-null [item] pre-fills the fields for
/// editing. Both modes drive [InventoryItemController]; on success the page
/// pops and the realtime item stream reflects the change on its own.
///
/// The add mode can be seeded from the Open Food Facts flow: [product] links a
/// resolved catalog entry (its name pre-fills the field and its id is saved as
/// `food_id`), while [scannedBarcode] is the fallback for an unknown barcode —
/// on save a custom catalog product carrying it is created and linked.
class ItemFormPage extends ConsumerStatefulWidget {
  const ItemFormPage({
    this.item,
    this.initialName,
    this.product,
    this.scannedBarcode,
    super.key,
  });

  /// The item being edited, or null when adding a new one.
  final InventoryItem? item;

  /// Pre-filled name for "add again" quick-add from the add sheet.
  final String? initialName;

  /// The catalog product this item was resolved from (scan hit or search
  /// selection); its name pre-fills the form and its id is linked.
  final Food? product;

  /// A scanned barcode with no catalog match — the fallback path. Retained so a
  /// custom product carrying it can be created and linked on save.
  final String? scannedBarcode;

  /// Pushes the form onto the root navigator (over the bottom nav bar).
  /// Resolves to true once the item was saved, otherwise null (dismissed).
  static Future<bool?> open(
    BuildContext context, {
    InventoryItem? item,
    String? initialName,
    Food? product,
    String? scannedBarcode,
  }) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<bool>(
        builder: (_) => ItemFormPage(
          item: item,
          initialName: initialName,
          product: product,
          scannedBarcode: scannedBarcode,
        ),
      ),
    );
  }

  @override
  ConsumerState<ItemFormPage> createState() => _ItemFormPageState();
}

class _ItemFormPageState extends ConsumerState<ItemFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;

  late InventoryUnit _unit;
  late String? _categoryId;
  late String? _storageLocationId;
  late DateTime? _bestBefore;

  bool get _isEdit => widget.item != null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _nameController = TextEditingController(
      text: item?.name ?? widget.product?.name ?? widget.initialName ?? '',
    );
    // In add mode, seed the quantity and unit from the resolved product's
    // package size (e.g. 500 g) when Open Food Facts has one; otherwise fall
    // back to a single piece.
    _quantityController = TextEditingController(
      text: item != null
          ? _formatQuantity(item.quantity)
          : _formatQuantity(widget.product?.packagedAmount ?? 1),
    );
    _unit =
        InventoryUnit.fromKey(item?.unit ?? widget.product?.packagedUnit) ??
        InventoryUnit.piece;
    _categoryId = item?.categoryId;
    _storageLocationId = item?.storageLocationId;
    _bestBefore = item?.bestBefore;
  }

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
    final isBusy = ref.watch(inventoryItemControllerProvider).isLoading;

    final locations =
        ref.watch(storageLocationsProvider).asData?.value ?? const [];
    final categories = ref.watch(categoriesProvider).asData?.value ?? const [];
    final locationName = _locationName(locations, _storageLocationId);
    final categoryName = _categoryName(categories, _categoryId);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? l10n.itemFormEditTitle : l10n.itemFormAddTitle),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.pageInset),
            children: [
              if (widget.product case final product?) ...[
                _ProductHeader(product: product),
                const SizedBox(height: AppSpacing.s4),
              ],
              FieldLabel(l10n.itemFormNameLabel),
              const SizedBox(height: AppSpacing.s1 + 2),
              TextFormField(
                controller: _nameController,
                autofocus: !_isEdit,
                enabled: !isBusy,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                style: AppTypography.body.copyWith(color: colors.textPrimary),
                decoration: InputDecoration(hintText: l10n.itemFormNameHint),
                validator: (value) => InventoryValidators.name(l10n, value),
              ),
              const SizedBox(height: AppSpacing.s4),
              FieldLabel(l10n.itemFormQuantityLabel),
              const SizedBox(height: AppSpacing.s1 + 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 96,
                    child: TextFormField(
                      controller: _quantityController,
                      enabled: !isBusy,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                      ],
                      style: AppTypography.body.copyWith(
                        color: colors.textPrimary,
                      ),
                      validator: (value) =>
                          InventoryValidators.quantity(l10n, value),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s3),
                  Expanded(
                    child: _UnitChips(
                      selected: _unit,
                      enabled: !isBusy,
                      onSelected: (unit) => setState(() => _unit = unit),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s4),
              FieldLabel(l10n.itemFormLocationLabel),
              const SizedBox(height: AppSpacing.s1 + 2),
              _PickerField(
                value: locationName ?? l10n.itemFormNone,
                muted: locationName == null,
                onTap: isBusy ? null : _pickLocation,
              ),
              const SizedBox(height: AppSpacing.s4),
              FieldLabel(l10n.itemFormCategoryLabel),
              const SizedBox(height: AppSpacing.s1 + 2),
              _PickerField(
                value: categoryName ?? l10n.itemFormNone,
                muted: categoryName == null,
                onTap: isBusy ? null : _pickCategory,
              ),
              const SizedBox(height: AppSpacing.s4),
              FieldLabel(l10n.itemFormBestBeforeLabel),
              const SizedBox(height: AppSpacing.s1 + 2),
              _PickerField(
                value: _bestBefore == null
                    ? l10n.itemFormNone
                    : formatBestBefore(_bestBefore!),
                muted: _bestBefore == null,
                onClear: _bestBefore == null
                    ? null
                    : () => setState(() => _bestBefore = null),
                onTap: isBusy ? null : _pickBestBefore,
              ),
              const SizedBox(height: AppSpacing.s6),
              ZaikoPrimaryButton(
                label: _isEdit
                    ? l10n.itemFormSaveButton
                    : l10n.itemFormAddButton,
                isLoading: isBusy,
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickLocation() async {
    final l10n = context.l10n;
    final locations =
        ref.read(storageLocationsProvider).asData?.value ?? const [];
    final selection = await showTaxonomyPicker(
      context: context,
      title: l10n.pickerLocationTitle,
      selectedId: _storageLocationId,
      options: [
        for (final location in locations)
          TaxonomyOption(
            id: location.id,
            name: location.name,
            color: location.color,
            icon: location.icon,
          ),
      ],
      onCreate: (pickerContext) async {
        final draft = await showTaxonomyEditor(
          context: pickerContext,
          title: l10n.taxonomyNewLocationTitle,
          submitLabel: l10n.taxonomyCreateButton,
        );
        if (draft == null) return null;
        return ref
            .read(storageLocationControllerProvider.notifier)
            .add(name: draft.name, icon: draft.icon, color: draft.color);
      },
      onManage: () => ManageStorageLocationsPage.open(context),
    );
    if (selection != null) {
      setState(() => _storageLocationId = selection.id);
    }
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

  Future<void> _pickBestBefore() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _bestBefore ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 10),
    );
    if (picked != null) setState(() => _bestBefore = picked);
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final quantity = InventoryValidators.parseQuantity(
      _quantityController.text,
    )!;
    final name = _nameController.text.trim();
    final notifier = ref.read(inventoryItemControllerProvider.notifier);

    final bool ok;
    if (_isEdit) {
      ok = await notifier.save(
        id: widget.item!.id,
        name: name,
        quantity: quantity,
        unit: _unit.key,
        categoryId: _categoryId,
        storageLocationId: _storageLocationId,
        bestBefore: _bestBefore,
      );
    } else {
      ok = await notifier.add(
        name: name,
        quantity: quantity,
        unit: _unit.key,
        categoryId: _categoryId,
        storageLocationId: _storageLocationId,
        bestBefore: _bestBefore,
        foodId: await _linkedFoodId(name),
      );
    }

    if (!mounted) return;
    if (ok) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _isEdit ? l10n.itemFormSavedSnack : l10n.itemFormAddedSnack,
            ),
          ),
        );
      Navigator.of(context).pop(true);
    } else {
      final error = ref.read(inventoryItemControllerProvider).error;
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(inventoryErrorMessage(l10n, error))),
        );
    }
  }

  /// The `food_id` to link when adding: the resolved product's id, or — for the
  /// unknown-barcode fallback — a freshly created custom product carrying the
  /// barcode. Best-effort: if creating the custom product fails, the item is
  /// still added, just without a catalog link.
  Future<String?> _linkedFoodId(String name) async {
    final product = widget.product;
    if (product != null) return product.id;
    final barcode = widget.scannedBarcode;
    if (barcode == null) return null;
    try {
      final custom = await ref
          .read(productResolverProvider.notifier)
          .createCustom(name: name, barcode: barcode);
      return custom.id;
    } on FoodFailure {
      return null;
    }
  }
}

/// A compact header shown above the form when adding from a resolved catalog
/// product: its image (when available) and brand, confirming the scan/search
/// hit at a glance.
class _ProductHeader extends StatelessWidget {
  const _ProductHeader({required this.product});

  final Food product;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final imageUrl = product.imageUrl;
    final placeholder = Icon(
      Icons.inventory_2_outlined,
      size: 22,
      color: colors.textTertiary,
    );

    return Row(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: colors.sunken,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          child: imageUrl == null
              ? placeholder
              : Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => placeholder,
                ),
        ),
        const SizedBox(width: AppSpacing.s3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.bodyMedium.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              if (product.brand != null)
                Text(
                  product.brand!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

String _formatQuantity(num quantity) =>
    quantity % 1 == 0 ? quantity.toInt().toString() : quantity.toString();

String? _locationName(List<StorageLocation> locations, String? id) {
  if (id == null) return null;
  for (final location in locations) {
    if (location.id == id) return location.name;
  }
  return null;
}

String? _categoryName(List<Category> categories, String? id) {
  if (id == null) return null;
  for (final category in categories) {
    if (category.id == id) return category.name;
  }
  return null;
}

/// Row of selectable unit chips (g / kg / ml / l / pcs / pack).
class _UnitChips extends StatelessWidget {
  const _UnitChips({
    required this.selected,
    required this.enabled,
    required this.onSelected,
  });

  final InventoryUnit selected;
  final bool enabled;
  final ValueChanged<InventoryUnit> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Wrap(
      spacing: AppSpacing.s2,
      runSpacing: AppSpacing.s2,
      children: [
        for (final unit in InventoryUnit.values)
          _Chip(
            label: inventoryUnitLabel(l10n, unit),
            selected: unit == selected,
            onTap: enabled ? () => onSelected(unit) : null,
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: selected ? colors.accent : colors.sunken,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s3 + 2,
            vertical: AppSpacing.s2,
          ),
          child: Text(
            label,
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w500,
              color: selected ? colors.onAccent : colors.textStrong,
            ),
          ),
        ),
      ),
    );
  }
}

/// A field-styled row that opens a picker (location, category or date). Shows a
/// clear button when [onClear] is set.
class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.value,
    required this.muted,
    required this.onTap,
    this.onClear,
  });

  final String value;
  final bool muted;
  final VoidCallback? onTap;
  final VoidCallback? onClear;

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
              if (onClear != null)
                GestureDetector(
                  onTap: onClear,
                  child: Icon(
                    Icons.close,
                    size: 18,
                    color: colors.textTertiary,
                  ),
                )
              else
                Icon(Icons.chevron_right, size: 18, color: colors.borderStrong),
            ],
          ),
        ),
      ),
    );
  }
}
