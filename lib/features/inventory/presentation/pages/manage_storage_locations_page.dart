import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/zaiko_buttons.dart';
import '../../application/inventory_providers.dart';
import '../../domain/inventory_item.dart';
import '../../domain/storage_location.dart';
import '../inventory_error_message.dart';
import '../widgets/taxonomy_editor_sheet.dart';
import '../widgets/taxonomy_manage_list.dart';

/// Manage screen for the household's storage locations: create, rename/re-style
/// and delete them. Deleting a location leaves its items in place; they simply
/// lose their location (the schema's `on delete set null`).
class ManageStorageLocationsPage extends ConsumerWidget {
  const ManageStorageLocationsPage({super.key});

  /// Pushes the page onto the root navigator (over the bottom nav bar).
  static Future<void> open(BuildContext context) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        builder: (_) => const ManageStorageLocationsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final locations = ref.watch(storageLocationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.manageLocationsTitle)),
      body: SafeArea(
        child: locations.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.inventoryErrorGeneric)),
          data: (list) => ListView(
            padding: const EdgeInsets.all(AppSpacing.pageInset),
            children: [
              TaxonomyManageList(
                items: [
                  for (final location in list)
                    TaxonomyManageItem(
                      id: location.id,
                      name: location.name,
                      editable: true,
                      color: location.color,
                      icon: location.icon,
                    ),
                ],
                emptyLabel: l10n.manageLocationsEmpty,
                onEdit: (item) => _edit(context, ref, list, item),
                onDelete: (item) => _delete(context, ref, item),
              ),
              const SizedBox(height: AppSpacing.s5),
              ZaikoPrimaryButton(
                label: l10n.manageAddLocation,
                icon: Icons.add,
                onPressed: () => _add(context, ref),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final draft = await showTaxonomyEditor(
      context: context,
      title: l10n.taxonomyNewLocationTitle,
      submitLabel: l10n.taxonomyCreateButton,
    );
    if (draft == null || !context.mounted) return;
    final id = await ref
        .read(storageLocationControllerProvider.notifier)
        .add(name: draft.name, icon: draft.icon, color: draft.color);
    if (id == null && context.mounted) _showError(context, ref);
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    List<StorageLocation> list,
    TaxonomyManageItem item,
  ) async {
    final l10n = context.l10n;
    final draft = await showTaxonomyEditor(
      context: context,
      title: l10n.taxonomyEditLocationTitle,
      submitLabel: l10n.taxonomySaveButton,
      initial: TaxonomyDraft(
        name: item.name,
        color: item.color,
        icon: item.icon,
      ),
    );
    if (draft == null || !context.mounted) return;
    final ok = await ref
        .read(storageLocationControllerProvider.notifier)
        .save(
          id: item.id,
          name: draft.name,
          icon: draft.icon,
          color: draft.color,
        );
    if (!ok && context.mounted) _showError(context, ref);
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    TaxonomyManageItem item,
  ) async {
    final l10n = context.l10n;
    final affected = _itemsUsing(ref, item.id);
    final confirmed = await confirmTaxonomyDelete(
      context,
      title: l10n.manageDeleteLocationTitle,
      affectedCount: affected,
    );
    if (!confirmed || !context.mounted) return;
    final ok = await ref
        .read(storageLocationControllerProvider.notifier)
        .delete(item.id);
    if (!ok && context.mounted) _showError(context, ref);
  }

  int _itemsUsing(WidgetRef ref, String locationId) {
    final items = ref.read(inventoryItemsProvider).asData?.value ?? const [];
    return items
        .where((InventoryItem item) => item.storageLocationId == locationId)
        .length;
  }

  void _showError(BuildContext context, WidgetRef ref) {
    final error = ref.read(storageLocationControllerProvider).error;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(inventoryErrorMessage(context.l10n, error))),
      );
  }
}
