import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../../../shared/widgets/header_icon_button.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/pill_field.dart';
import '../../../../shared/widgets/zaiko_chip.dart';
import '../shopping_demo_data.dart';
import '../widgets/shopping_item_row.dart';

/// Shopping tab, following the design's "Einkauf" screen: header with an add
/// button, a quick-add field, category filter chips and the flat checklist.
///
/// Demo content (see [ShoppingDemoData]); checkboxes toggle locally and the
/// chips filter the list. The layout is ready to bind to the synced list once
/// it exists.
class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  static const String routePath = '/shopping-list';
  static const String routeName = 'shopping-list';

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  /// Selected category chip; null means "all".
  String? _category;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final items = _category == null
        ? ShoppingDemoData.items
        : ShoppingDemoData.items
              .where((item) => item.category == _category)
              .toList();

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
              subtitle: l10n.shoppingListCount(ShoppingDemoData.openCount),
              trailing: HeaderIconButton(
                icon: Icons.add,
                filled: true,
                onTap: () {},
              ),
            ),
            const SizedBox(height: AppSpacing.s5),
            PillField(
              icon: Icons.search,
              hint: l10n.shoppingAddHint,
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.s4),
            SizedBox(
              height: 36,
              child: ListView(
                scrollDirection: Axis.horizontal,
                clipBehavior: Clip.none,
                children: [
                  ZaikoChip(
                    label: l10n.commonAll,
                    selected: _category == null,
                    onTap: () => setState(() => _category = null),
                  ),
                  for (final category in ShoppingDemoData.categories) ...[
                    const SizedBox(width: AppSpacing.s2),
                    ZaikoChip(
                      label: category,
                      selected: _category == category,
                      onTap: () => setState(() => _category = category),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.s6),
            CardList(
              children: [
                for (final item in items)
                  ShoppingItemRow(item, key: ValueKey(item.name)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
