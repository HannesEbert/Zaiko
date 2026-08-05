import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../../../shared/widgets/header_icon_button.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../../shared/widgets/zaiko_chip.dart';
import '../../application/shopping_providers.dart';
import '../../application/shopping_view.dart';
import '../shopping_error_message.dart';
import '../widgets/add_shopping_item_sheet.dart';
import '../widgets/shopping_item_row.dart';
import '../widgets/shopping_quick_add_field.dart';

/// Shopping tab: the household's collaborative shopping list. Data comes from
/// the Supabase-backed shopping providers, scoped to the active household and
/// synced in realtime, so every member sees the same list.
class ShoppingListPage extends ConsumerStatefulWidget {
  const ShoppingListPage({super.key});

  static const String routePath = '/shopping-list';
  static const String routeName = 'shopping-list';

  @override
  ConsumerState<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends ConsumerState<ShoppingListPage> {
  /// Selected category-filter chip; null means "all".
  String? _categoryId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final resolved = ref.watch(resolvedShoppingItemsProvider);
    final openCount = ref.watch(shoppingOpenCountProvider).asData?.value;
    final filterCategories =
        ref.watch(shoppingFilterCategoriesProvider).asData?.value ?? const [];
    final hasChecked =
        resolved.asData?.value.any((item) => item.item.checked) ?? false;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageInset,
            AppSpacing.s6,
            AppSpacing.pageInset,
            AppSpacing.s10,
          ),
          children: [
            PageHeader(
              title: l10n.shoppingTitle,
              subtitle: openCount == null
                  ? ''
                  : l10n.shoppingListCount(openCount),
              trailing: Row(
                children: [
                  if (hasChecked) ...[
                    HeaderIconButton(
                      icon: Icons.remove_done,
                      onTap: () => _clearChecked(context),
                      tooltip: l10n.shoppingClearCheckedTooltip,
                    ),
                    const SizedBox(width: AppSpacing.s3),
                  ],
                  HeaderIconButton(
                    icon: Icons.add,
                    filled: true,
                    onTap: () => showAddShoppingItemSheet(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s5),
            const ShoppingQuickAddField(),
            if (filterCategories.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.s4),
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  children: [
                    ZaikoChip(
                      label: l10n.commonAll,
                      selected: _categoryId == null,
                      onTap: () => setState(() => _categoryId = null),
                    ),
                    for (final category in filterCategories) ...[
                      const SizedBox(width: AppSpacing.s2),
                      ZaikoChip(
                        label: category.name,
                        selected: _categoryId == category.id,
                        onTap: () => setState(() => _categoryId = category.id),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.s6),
            resolved.when(
              loading: () => const _ShoppingLoading(),
              error: (_, _) => _ShoppingError(
                onRetry: () => ref.invalidate(shoppingItemsProvider),
              ),
              data: (items) => _ShoppingList(
                items: _filtered(items),
                totalCount: items.length,
                onEdit: (item) =>
                    showAddShoppingItemSheet(context, item: item.item),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// The items matching the selected category chip (all when none is selected).
  List<ResolvedShoppingItem> _filtered(List<ResolvedShoppingItem> items) {
    if (_categoryId == null) return items;
    return items.where((item) => item.item.categoryId == _categoryId).toList();
  }

  Future<void> _clearChecked(BuildContext context) async {
    final ok = await ref
        .read(shoppingListControllerProvider.notifier)
        .clearChecked();
    if (!ok && context.mounted) showShoppingErrorSnackBar(context, ref);
  }
}

/// The list body: open items, then a dimmed "done" section, or the empty state.
class _ShoppingList extends StatelessWidget {
  const _ShoppingList({
    required this.items,
    required this.totalCount,
    required this.onEdit,
  });

  final List<ResolvedShoppingItem> items;

  /// The unfiltered item count, to tell "list is empty" from "filter is empty".
  final int totalCount;
  final void Function(ResolvedShoppingItem item) onEdit;

  @override
  Widget build(BuildContext context) {
    if (totalCount == 0) return const _ShoppingEmpty();
    if (items.isEmpty) return const _ShoppingFilterEmpty();

    final open = items.where((item) => !item.item.checked).toList();
    final done = items.where((item) => item.item.checked).toList();

    return Column(
      children: [
        if (open.isNotEmpty)
          CardList(
            children: [
              for (final item in open)
                ShoppingItemRow(
                  item,
                  key: ValueKey(item.item.id),
                  onTap: () => onEdit(item),
                ),
            ],
          ),
        if (done.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s5),
          SectionLabel(context.l10n.shoppingDoneSection),
          const SizedBox(height: AppSpacing.s3),
          CardList(
            opacity: 0.6,
            children: [
              for (final item in done)
                ShoppingItemRow(
                  item,
                  key: ValueKey(item.item.id),
                  onTap: () => onEdit(item),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

class _ShoppingEmpty extends StatelessWidget {
  const _ShoppingEmpty();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
      child: Column(
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 40,
            color: colors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.s3),
          Text(
            l10n.shoppingEmptyTitle,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            l10n.shoppingEmptyMessage,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ShoppingFilterEmpty extends StatelessWidget {
  const _ShoppingFilterEmpty();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s5),
      child: Center(
        child: Text(
          context.l10n.shoppingEmptyMessage,
          textAlign: TextAlign.center,
          style: AppTypography.caption.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
      ),
    );
  }
}

class _ShoppingLoading extends StatelessWidget {
  const _ShoppingLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s10),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _ShoppingError extends StatelessWidget {
  const _ShoppingError({this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
      child: Column(
        children: [
          Icon(Icons.cloud_off_outlined, size: 32, color: colors.textTertiary),
          const SizedBox(height: AppSpacing.s2),
          Text(
            l10n.shoppingLoadError,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.s2),
            TextButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
          ],
        ],
      ),
    );
  }
}
