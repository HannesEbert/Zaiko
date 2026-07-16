import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/pill_field.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../shopping_demo_data.dart';
import '../widgets/shopping_item_row.dart';

/// Shopping tab: the household's collaborative shopping list.
///
/// Demo content (see [ShoppingDemoData]); checkboxes toggle locally. The layout
/// is ready to bind to the synced list once it exists.
class ShoppingListPage extends StatelessWidget {
  const ShoppingListPage({super.key});

  static const String routePath = '/shopping-list';
  static const String routeName = 'shopping-list';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.pageInset,
            AppSpacing.s3 + 2,
            AppSpacing.pageInset,
            AppSpacing.s10,
          ),
          children: [
            PageHeader(
              title: l10n.shoppingTitle,
              subtitle: l10n.shoppingProgress(
                ShoppingDemoData.doneCount,
                ShoppingDemoData.totalCount,
              ),
              trailing: const _HeaderActions(),
            ),
            const SizedBox(height: AppSpacing.s3),
            _ProgressBar(value: ShoppingDemoData.progress),
            const SizedBox(height: AppSpacing.s3 + 2),
            PillField(
              icon: Icons.add,
              hint: l10n.shoppingAddHint,
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.s4),
            for (final section in ShoppingDemoData.openSections) ...[
              SectionLabel(section.title),
              const SizedBox(height: AppSpacing.s2),
              CardList(
                children: [
                  for (final item in section.items) ShoppingItemRow(item),
                ],
              ),
              const SizedBox(height: AppSpacing.s4),
            ],
            SectionLabel(
              l10n.shoppingDoneSection(ShoppingDemoData.doneCount),
              trailing: Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: context.colors.textTertiary,
              ),
            ),
            const SizedBox(height: AppSpacing.s2),
            CardList(
              opacity: 0.75,
              children: [
                for (final item in ShoppingDemoData.doneItems)
                  ShoppingItemRow(item, initialChecked: true),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderActions extends StatelessWidget {
  const _HeaderActions();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        SizedBox(
          width: 52,
          height: 32,
          child: Stack(
            children: [
              UserAvatar(
                initial: 'H',
                size: 32,
                borderColor: colors.pageBackground,
              ),
              Positioned(
                left: 20,
                child: UserAvatar(
                  initial: 'M',
                  size: 32,
                  accent: false,
                  borderColor: colors.pageBackground,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s2),
        _CircleAction(icon: Icons.ios_share, onTap: () {}),
      ],
    );
  }
}

class _CircleAction extends StatelessWidget {
  const _CircleAction({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.card,
      shape: CircleBorder(side: BorderSide(color: colors.borderSubtle)),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 17, color: colors.textStrong),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: LinearProgressIndicator(
        value: value,
        minHeight: 4,
        backgroundColor: colors.borderSubtle,
        valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
      ),
    );
  }
}
