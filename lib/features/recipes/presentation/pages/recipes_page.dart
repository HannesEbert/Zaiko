import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/zaiko_chip.dart';
import '../recipes_demo_data.dart';
import '../widgets/recipe_card.dart';

/// Recipes tab: suggestions cookable with what's in stock.
///
/// Demo content (see [RecipesDemoData]); the filter chips select locally. Ready
/// to bind to inventory-derived suggestions once they exist.
class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});

  static const String routePath = '/recipes';
  static const String routeName = 'recipes';

  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  int _selectedFilter = 0;

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
              title: l10n.recipesTitle,
              subtitle: l10n.recipesSubtitle,
            ),
            const SizedBox(height: AppSpacing.s3),
            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: RecipesDemoData.filters.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppSpacing.s2),
                itemBuilder: (context, index) => ZaikoChip(
                  label: RecipesDemoData.filters[index],
                  selected: _selectedFilter == index,
                  onTap: () => setState(() => _selectedFilter = index),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s4),
            for (final recipe in RecipesDemoData.recipes) ...[
              RecipeCard(recipe),
              const SizedBox(height: AppSpacing.s3 + 2),
            ],
          ],
        ),
      ),
    );
  }
}
