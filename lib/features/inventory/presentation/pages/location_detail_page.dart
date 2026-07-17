import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/card_list.dart';
import '../../../../shared/widgets/header_icon_button.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/pill_field.dart';
import '../inventory_demo_data.dart';
import '../widgets/inventory_item_row.dart';

/// Detail view of a single storage location (e.g. the fridge): back link,
/// title with item count, a filter action, search and the item list — the
/// design's "Kühlschrank" screen.
///
/// Content is demo data; every location currently shows the fridge item list
/// until the real data layer exists.
class LocationDetailPage extends StatelessWidget {
  const LocationDetailPage({required this.location, super.key});

  final StorageLocation location;

  /// Pushes the page on the tab's navigator, keeping the bottom bar visible
  /// as in the design.
  static void open(BuildContext context, StorageLocation location) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => LocationDetailPage(location: location),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

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
              title: location.name,
              subtitle: l10n.inventoryItemsCount(location.itemCount),
              trailing: HeaderIconButton(icon: Icons.filter_list, onTap: () {}),
            ),
            const SizedBox(height: AppSpacing.s5),
            PillField(
              icon: Icons.search,
              hint: l10n.locationSearchHint(location.name),
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.s6),
            CardList(
              children: [
                for (final item in InventoryDemoData.fridgeItems)
                  InventoryItemRow(item),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
