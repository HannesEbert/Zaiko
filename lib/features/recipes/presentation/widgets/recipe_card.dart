import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../../shared/widgets/zaiko_card.dart';
import '../recipes_demo_data.dart';

/// A recipe suggestion card: photo placeholder, title + meta, a match pill and
/// — when ingredients are missing — the missing chips plus a "Zur Liste" link.
class RecipeCard extends StatelessWidget {
  const RecipeCard(this.recipe, {super.key});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ZaikoCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PhotoPlaceholder(),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s3 + 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            style: AppTypography.headline.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            recipe.meta,
                            style: AppTypography.caption.copyWith(
                              color: colors.textSecondary,
                              fontFeatures: AppTypography.tabularFigures,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    StatusPill(recipe.matchLabel, tone: recipe.matchTone),
                  ],
                ),
                if (recipe.missing.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.s3),
                  _MissingRow(missing: recipe.missing),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MissingRow extends StatelessWidget {
  const _MissingRow({required this.missing});

  final List<String> missing;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        Text(
          context.l10n.recipesMissing,
          style: AppTypography.caption.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(width: AppSpacing.s2),
        Expanded(
          child: Wrap(
            spacing: AppSpacing.s2,
            runSpacing: AppSpacing.s1,
            children: [
              for (final ingredient in missing) StatusPill(ingredient),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.s2),
        Text(
          context.l10n.recipesAddToList,
          style: AppTypography.caption.copyWith(
            fontWeight: FontWeight.w500,
            color: colors.accentText,
          ),
        ),
      ],
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: 140,
      color: colors.sunken,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, size: 36, color: colors.borderStrong),
          const SizedBox(height: AppSpacing.s1 + 2),
          Text(
            context.l10n.recipesPhoto,
            style: AppTypography.caption.copyWith(
              fontSize: 12,
              color: colors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
