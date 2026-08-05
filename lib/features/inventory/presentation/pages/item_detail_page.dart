import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../../shared/widgets/zaiko_buttons.dart';
import '../../../../shared/widgets/zaiko_card.dart';
import '../../application/inventory_providers.dart';
import '../../application/inventory_view.dart';
import '../inventory_error_message.dart';
import '../inventory_labels.dart';
import 'item_form_page.dart';

/// Full-screen detail for a single inventory article.
///
/// Wires the E1.2 write path: the quantity stepper persists each change (0 =
/// used up → trash), "consumed"/"remove" move the item to the trash, and the
/// edit button opens [ItemFormPage]. Pushed on the root navigator so it covers
/// the bottom navigation bar, matching the design.
class ItemDetailPage extends ConsumerStatefulWidget {
  const ItemDetailPage(this.resolved, {super.key});

  final ResolvedItem resolved;

  @override
  ConsumerState<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends ConsumerState<ItemDetailPage> {
  late int _count = widget.resolved.item.count;

  String get _itemId => widget.resolved.item.id;

  Future<void> _changeCount(int delta) async {
    final next = (_count + delta).clamp(0, 99);
    if (next == _count) return;
    // Reaching zero means "used up": move to the trash instead of storing 0.
    if (next == 0) {
      await _moveToTrash();
      return;
    }
    setState(() => _count = next);
    final ok = await ref
        .read(inventoryItemControllerProvider.notifier)
        .setCount(id: _itemId, count: next);
    if (!ok && mounted) _showError();
  }

  Future<void> _moveToTrash() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l10n = context.l10n;
    final ok = await ref
        .read(inventoryItemControllerProvider.notifier)
        .consume(_itemId);
    if (!mounted) return;
    if (ok) {
      navigator.pop();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.itemMovedToTrash)));
    } else {
      _showError();
    }
  }

  Future<void> _edit() async {
    final saved = await ItemFormPage.open(
      context,
      item: widget.resolved.item.copyWith(count: _count),
    );
    // After a successful edit the list reflects the change; leave the (now
    // stale) detail snapshot and return to it.
    if (saved == true && mounted) Navigator.of(context).pop();
  }

  void _showError() {
    final error = ref.read(inventoryItemControllerProvider).error;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(inventoryErrorMessage(context.l10n, error))),
      );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final resolved = widget.resolved;
    final item = resolved.item;

    final expiryLabel = expiryDetailLabel(l10n, item.bestBefore);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(title: l10n.itemDetailHeader, onEdit: _edit),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.pageInset,
                  AppSpacing.s1,
                  AppSpacing.pageInset,
                  AppSpacing.s6,
                ),
                children: [
                  const _PhotoPlaceholder(),
                  const SizedBox(height: AppSpacing.s4),
                  Text(
                    item.name,
                    style: AppTypography.title.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    formatQuantity(
                      count: _count,
                      quantity: item.quantity,
                      unit: item.unit,
                    ),
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  // Items without a best-before date show no expiry status.
                  if (expiryLabel != null) ...[
                    const SizedBox(height: AppSpacing.s2 + 2),
                    StatusPill(expiryLabel, tone: expiryTone(resolved.status)),
                  ],
                  const SizedBox(height: AppSpacing.s4),
                  CardList(
                    children: [
                      _QuantityRow(
                        label: l10n.itemDetailQuantity,
                        count: _count,
                        onDecrement: () => _changeCount(-1),
                        onIncrement: () => _changeCount(1),
                      ),
                      _DetailRow(
                        label: l10n.itemDetailLocation,
                        onTap: _edit,
                        child: _ValueWithChevron(
                          value:
                              resolved.location?.name ?? l10n.itemDetailNoDate,
                        ),
                      ),
                      _DetailRow(
                        label: l10n.itemDetailCategory,
                        onTap: _edit,
                        child: resolved.category == null
                            ? _ValueWithChevron(value: l10n.itemDetailNoDate)
                            : StatusPill(
                                resolved.category!.name,
                                tone: StatusTone.brand,
                              ),
                      ),
                      _DetailRow(
                        label: l10n.itemDetailBestBefore,
                        onTap: _edit,
                        child: _ValueWithChevron(
                          value: item.bestBefore == null
                              ? l10n.itemDetailNoDate
                              : formatBestBefore(item.bestBefore!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  ZaikoPrimaryButton(
                    label: l10n.itemDetailMarkConsumed,
                    icon: Icons.check,
                    onPressed: _moveToTrash,
                  ),
                  const SizedBox(height: AppSpacing.s2 + 2),
                  ZaikoSecondaryButton(
                    label: l10n.itemDetailAddToList,
                    icon: Icons.shopping_cart_outlined,
                    onPressed: () {},
                  ),
                  const SizedBox(height: AppSpacing.s1),
                  TextButton.icon(
                    onPressed: _moveToTrash,
                    icon: Icon(
                      Icons.delete_outline,
                      size: 16,
                      color: colors.error,
                    ),
                    label: Text(l10n.itemDetailRemove),
                    style: TextButton.styleFrom(
                      foregroundColor: colors.error,
                      textStyle: AppTypography.caption.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onEdit});

  final String title;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.pageInset,
        vertical: AppSpacing.s2 + 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleButton(
            icon: Icons.chevron_left,
            onTap: () => Navigator.of(context).pop(),
          ),
          Text(
            title,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.textSecondary,
            ),
          ),
          _CircleButton(icon: Icons.edit_outlined, onTap: onEdit),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

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
          child: Icon(icon, size: 18, color: colors.textPrimary),
        ),
      ),
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ZaikoCard(
      child: SizedBox(
        height: 150,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 44, color: colors.borderStrong),
            const SizedBox(height: AppSpacing.s2),
            Text(
              context.l10n.itemDetailPhoto,
              style: AppTypography.caption.copyWith(
                fontSize: 12,
                color: colors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.child, this.onTap});

  final String label;
  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s3 + 2,
          vertical: AppSpacing.s3 + 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTypography.body.copyWith(
                color: context.colors.textStrong,
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _ValueWithChevron extends StatelessWidget {
  const _ValueWithChevron({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: colors.textPrimary,
            fontFeatures: AppTypography.tabularFigures,
          ),
        ),
        const SizedBox(width: AppSpacing.s1 + 2),
        Icon(Icons.chevron_right, size: 16, color: colors.textTertiary),
      ],
    );
  }
}

class _QuantityRow extends StatelessWidget {
  const _QuantityRow({
    required this.label,
    required this.count,
    required this.onDecrement,
    required this.onIncrement,
  });

  final String label;
  final int count;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3 + 2,
        vertical: AppSpacing.s2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.body.copyWith(color: colors.textStrong),
          ),
          Container(
            height: 38,
            decoration: BoxDecoration(
              border: Border.all(color: colors.borderSubtle),
              borderRadius: BorderRadius.circular(AppRadius.sm + 2),
            ),
            child: Row(
              children: [
                _StepButton(icon: Icons.remove, onTap: onDecrement),
                SizedBox(
                  width: 24,
                  child: Text(
                    '$count',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.textPrimary,
                      fontFeatures: AppTypography.tabularFigures,
                    ),
                  ),
                ),
                _StepButton(icon: Icons.add, onTap: onIncrement),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 38,
        height: 38,
        child: Icon(icon, size: 16, color: context.colors.textStrong),
      ),
    );
  }
}
