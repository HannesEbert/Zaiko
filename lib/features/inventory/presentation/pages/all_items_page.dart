import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../../../shared/widgets/header_icon_button.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/search_field.dart';
import '../../application/inventory_providers.dart';
import '../../application/inventory_query.dart';
import '../../application/inventory_view.dart';
import '../widgets/inventory_item_row.dart';
import '../widgets/inventory_message.dart';
import '../widgets/inventory_sort_sheet.dart';
import 'item_detail_page.dart';

/// Full-screen search over the whole inventory: a live text search plus the
/// shared sort picker, listing matching items across every storage location.
///
/// Reached from the inventory and home search pills and the "see all" link.
class AllItemsPage extends ConsumerStatefulWidget {
  const AllItemsPage({super.key});

  /// Pushes the page onto the root navigator (over the bottom nav bar), like the
  /// other inventory overlays.
  static Future<void> open(BuildContext context) {
    return Navigator.of(
      context,
      rootNavigator: true,
    ).push(MaterialPageRoute<void>(builder: (_) => const AllItemsPage()));
  }

  @override
  ConsumerState<AllItemsPage> createState() => _AllItemsPageState();
}

class _AllItemsPageState extends ConsumerState<AllItemsPage> {
  final _controller = TextEditingController();
  String _query = '';
  InventorySortMode _sort = InventorySortMode.recentlyAdded;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickSort() async {
    final picked = await showInventorySortSheet(context, _sort);
    if (picked != null) setState(() => _sort = picked);
  }

  void _openDetail(ResolvedItem resolved) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).push(MaterialPageRoute<void>(builder: (_) => ItemDetailPage(resolved)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final items = ref.watch(resolvedItemsProvider);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageInset,
            AppSpacing.s6,
            AppSpacing.pageInset,
            AppSpacing.s10,
          ),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_back,
                      size: 16,
                      color: colors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.commonBack,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s6),
            PageHeader(
              title: l10n.inventoryAllItemsTitle,
              subtitle: l10n.inventoryItemsCount(
                items.asData?.value.length ?? 0,
              ),
              trailing: HeaderIconButton(
                icon: Icons.filter_list,
                onTap: _pickSort,
              ),
            ),
            const SizedBox(height: AppSpacing.s5),
            SearchField(
              controller: _controller,
              hint: l10n.inventorySearchHint,
              autofocus: true,
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: AppSpacing.s6),
            items.when(
              loading: () => const InventoryLoading(),
              error: (_, _) => InventoryError(
                onRetry: () => ref.invalidate(inventoryItemsProvider),
              ),
              data: (resolved) {
                final results = sortResolvedItems(
                  filterResolvedItemsByQuery(resolved, _query),
                  _sort,
                );
                if (results.isEmpty) {
                  return InventoryEmptyLine(
                    _query.trim().isEmpty
                        ? l10n.inventoryRecentlyAddedEmpty
                        : l10n.inventorySearchEmpty,
                  );
                }
                return CardList(
                  children: [
                    for (final item in results)
                      InventoryItemRow(
                        item,
                        showLocation: true,
                        onTap: () => _openDetail(item),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
