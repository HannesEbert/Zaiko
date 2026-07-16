import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../../shared/widgets/zaiko_buttons.dart';
import '../../../../shared/widgets/zaiko_card.dart';

/// Full-screen detail for a single inventory article.
///
/// Fields other than [title]/[subtitle] use demo values; editing them is wired
/// once the data layer exists. Pushed on the root navigator so it covers the
/// bottom navigation bar, matching the design.
class ItemDetailPage extends StatefulWidget {
  const ItemDetailPage({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int _quantity = 2;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(title: l10n.itemDetailHeader),
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
                    widget.title,
                    style: AppTypography.title.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    widget.subtitle,
                    style: AppTypography.caption.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s2 + 2),
                  const StatusPill(
                    'Läuft in 2 Tagen ab',
                    tone: StatusTone.warning,
                  ),
                  const SizedBox(height: AppSpacing.s4),
                  CardList(
                    children: [
                      _QuantityRow(
                        label: l10n.itemDetailQuantity,
                        quantity: _quantity,
                        onDecrement: () => setState(
                          () => _quantity = (_quantity - 1).clamp(0, 99),
                        ),
                        onIncrement: () => setState(
                          () => _quantity = (_quantity + 1).clamp(0, 99),
                        ),
                      ),
                      _DetailRow(
                        label: l10n.itemDetailLocation,
                        child: _ValueWithChevron(value: 'Kühlschrank'),
                      ),
                      _DetailRow(
                        label: l10n.itemDetailCategory,
                        child: const StatusPill(
                          'Milchprodukte',
                          tone: StatusTone.brand,
                        ),
                      ),
                      _DetailRow(
                        label: l10n.itemDetailBestBefore,
                        child: _ValueWithChevron(value: '17.07.2026'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s5),
                  ZaikoPrimaryButton(
                    label: l10n.itemDetailMarkConsumed,
                    icon: Icons.check,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: AppSpacing.s2 + 2),
                  ZaikoSecondaryButton(
                    label: l10n.itemDetailAddToList,
                    icon: Icons.shopping_cart_outlined,
                    onPressed: () {},
                  ),
                  const SizedBox(height: AppSpacing.s1),
                  TextButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
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
  const _TopBar({required this.title});

  final String title;

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
          _CircleButton(icon: Icons.edit_outlined, onTap: () {}),
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
  const _DetailRow({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    required this.quantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  final String label;
  final int quantity;
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
                    '$quantity',
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
