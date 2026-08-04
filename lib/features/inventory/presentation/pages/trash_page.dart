import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../../../shared/widgets/icon_tile.dart';
import '../../application/inventory_providers.dart';
import '../../application/inventory_view.dart';
import '../inventory_labels.dart';

/// The 30-day trash: items removed from the inventory (used up or discarded),
/// with a restore action. Reached from the trash icon in the inventory header.
class TrashPage extends ConsumerWidget {
  const TrashPage({super.key});

  /// Pushes the page onto the root navigator (over the bottom nav bar).
  static Future<void> open(BuildContext context) {
    return Navigator.of(
      context,
      rootNavigator: true,
    ).push(MaterialPageRoute<void>(builder: (_) => const TrashPage()));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final trash = ref.watch(resolvedDeletedItemsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.trashTitle)),
      body: SafeArea(
        child: trash.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, _) => Center(child: Text(l10n.inventoryErrorGeneric)),
          data: (items) => ListView(
            padding: const EdgeInsets.all(AppSpacing.pageInset),
            children: [
              Text(
                l10n.trashSubtitle,
                style: AppTypography.caption.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s4),
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
                  child: Text(
                    l10n.trashEmpty,
                    style: AppTypography.body.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                )
              else
                CardList(
                  children: [
                    for (final resolved in items)
                      _TrashRow(
                        resolved: resolved,
                        onRestore: () => _restore(context, ref, resolved),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _restore(
    BuildContext context,
    WidgetRef ref,
    ResolvedItem resolved,
  ) async {
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final ok = await ref
        .read(inventoryItemControllerProvider.notifier)
        .restore(resolved.item.id);
    if (ok && context.mounted) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.itemRestoredSnack)));
    }
  }
}

class _TrashRow extends StatelessWidget {
  const _TrashRow({required this.resolved, required this.onRestore});

  final ResolvedItem resolved;
  final VoidCallback onRestore;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final item = resolved.item;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3 + 2,
        vertical: AppSpacing.s2 + 2,
      ),
      child: Row(
        children: [
          IconTile(
            AppIcons.forKey(resolved.category?.icon),
            color: AppColors.categoryForKey(resolved.category?.color),
            size: 40,
            iconSize: 20,
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTypography.bodyMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                Text(
                  formatQuantity(l10n, item.quantity, item.unit),
                  style: AppTypography.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: onRestore,
            icon: const Icon(Icons.restore, size: 16),
            label: Text(l10n.trashRestore),
            style: TextButton.styleFrom(foregroundColor: colors.accentText),
          ),
        ],
      ),
    );
  }
}
