import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../food/presentation/food_error_message.dart';
import '../../../food/presentation/pages/barcode_scanner_page.dart';
import '../../../food/presentation/pages/product_search_page.dart';
import '../../application/inventory_providers.dart';
import '../pages/item_form_page.dart';

/// How many quick "add again" chips the sheet shows at most.
const int _quickAddLimit = 6;

/// How the user chose to add an item: scan a barcode, search the product
/// database, or enter it manually (optionally pre-filled with a [name] from an
/// "add again" chip).
enum _AddItemAction { scan, search, manual }

/// The sheet's outcome — the chosen [action] plus the optional quick-add
/// [name].
class _AddItemChoice {
  const _AddItemChoice(this.action, {this.name});

  final _AddItemAction action;
  final String? name;
}

/// Shows the "Artikel hinzufügen" modal bottom sheet with the three ways to add
/// an item plus quick "add again" chips, then runs the chosen flow: barcode
/// scan, product search, or the manual form.
Future<void> showAddItemSheet(BuildContext context) async {
  final choice = await showModalBottomSheet<_AddItemChoice>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _AddItemSheet(),
  );
  if (choice == null || !context.mounted) return;
  switch (choice.action) {
    case _AddItemAction.manual:
      await ItemFormPage.open(context, initialName: choice.name);
    case _AddItemAction.scan:
      await _runScanFlow(context);
    case _AddItemAction.search:
      await _runSearchFlow(context);
  }
}

/// Scans a barcode, then opens the add form pre-filled from the resolved
/// product — or, on a miss or lookup error, falls back to the manual form with
/// the barcode retained and a short explanation.
Future<void> _runScanFlow(BuildContext context) async {
  final outcome = await BarcodeScannerPage.open(context);
  if (outcome == null || !context.mounted) return;
  if (outcome.product != null) {
    await ItemFormPage.open(context, product: outcome.product);
    return;
  }
  final l10n = context.l10n;
  final message = outcome.failure != null
      ? foodErrorMessage(l10n, outcome.failure)
      : l10n.scanNotFoundSnack;
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
  await ItemFormPage.open(context, scannedBarcode: outcome.barcode);
}

/// Searches the product database, then opens the add form pre-filled from the
/// chosen product.
Future<void> _runSearchFlow(BuildContext context) async {
  final product = await ProductSearchPage.open(context);
  if (product == null || !context.mounted) return;
  await ItemFormPage.open(context, product: product);
}

class _AddItemSheet extends ConsumerWidget {
  const _AddItemSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;

    // Recently added product names, de-duplicated, for the quick "add again"
    // chips. Empty until the data loads or when the inventory is empty.
    final recentNames = <String>{
      ...?ref
          .watch(recentlyAddedItemsProvider)
          .asData
          ?.value
          .map((resolved) => resolved.item.name),
    }.take(_quickAddLimit).toList();

    return Container(
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
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.s3),
                  decoration: BoxDecoration(
                    color: colors.borderStrong,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.addItemTitle,
                    style: AppTypography.headline.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  _CloseButton(onTap: () => Navigator.of(context).pop()),
                ],
              ),
              const SizedBox(height: AppSpacing.s4),
              CardList(
                children: [
                  _AddOption(
                    icon: Icons.qr_code_scanner_outlined,
                    title: l10n.addItemScanTitle,
                    subtitle: l10n.addItemScanSubtitle,
                    onTap: () => Navigator.of(
                      context,
                    ).pop(const _AddItemChoice(_AddItemAction.scan)),
                  ),
                  _AddOption(
                    icon: Icons.search_outlined,
                    title: l10n.addItemSearchTitle,
                    subtitle: l10n.addItemSearchSubtitle,
                    onTap: () => Navigator.of(
                      context,
                    ).pop(const _AddItemChoice(_AddItemAction.search)),
                  ),
                  _AddOption(
                    icon: Icons.edit_outlined,
                    title: l10n.addItemManualTitle,
                    subtitle: l10n.addItemManualSubtitle,
                    onTap: () => Navigator.of(
                      context,
                    ).pop(const _AddItemChoice(_AddItemAction.manual)),
                  ),
                ],
              ),
              if (recentNames.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.s5),
                SectionLabel(l10n.addItemAddAgain),
                const SizedBox(height: AppSpacing.s2 + 2),
                Wrap(
                  spacing: AppSpacing.s2,
                  runSpacing: AppSpacing.s2,
                  children: [
                    for (final product in recentNames)
                      _QuickAddChip(
                        label: product,
                        onTap: () => Navigator.of(context).pop(
                          _AddItemChoice(_AddItemAction.manual, name: product),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AddOption extends StatelessWidget {
  const _AddOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s3 + 2),
        child: Row(
          children: [
            IconTile(icon, size: 44, iconSize: 22, accent: true),
            const SizedBox(width: AppSpacing.s3 + 2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.bodyMedium.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, size: 18, color: colors.borderStrong),
          ],
        ),
      ),
    );
  }
}

class _QuickAddChip extends StatelessWidget {
  const _QuickAddChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.sunken,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s3 + 2,
            vertical: AppSpacing.s2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 13, color: colors.textStrong),
              const SizedBox(width: AppSpacing.s1 + 2),
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.textStrong,
                ),
              ),
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
