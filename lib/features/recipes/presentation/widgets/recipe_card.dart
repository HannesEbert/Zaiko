import 'package:flutter/material.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/status_pill.dart';
import '../../../../shared/widgets/zaiko_card.dart';
import '../../domain/recipe_match.dart';
import '../recipes_labels.dart';

/// A recipe suggestion card: photo placeholder, title + meta, a match pill,
/// an "use up soon" badge when it covers expiring stock, and — when ingredients
/// are missing — the missing chips plus a working "To list" action.
///
/// Tapping the card opens the recipe; tapping "To list" adds the missing
/// ingredients to the shopping list via [onAddToList].
class RecipeCard extends StatelessWidget {
  const RecipeCard(
    this.match, {
    required this.onTap,
    required this.onAddToList,
    super.key,
  });

  final RecipeMatch match;
  final VoidCallback onTap;
  final VoidCallback onAddToList;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return ZaikoCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _PhotoPlaceholder(),
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
                            match.recipe.title,
                            style: AppTypography.headline.copyWith(
                              color: colors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            recipeMetaLabel(l10n, match.recipe),
                            style: AppTypography.caption.copyWith(
                              color: colors.textSecondary,
                              fontFeatures: AppTypography.tabularFigures,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s2),
                    StatusPill(
                      recipeMatchLabel(l10n, match),
                      tone: match.isComplete
                          ? StatusTone.success
                          : StatusTone.warning,
                    ),
                  ],
                ),
                if (match.usesExpiring) ...[
                  const SizedBox(height: AppSpacing.s3),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: StatusPill(
                      l10n.recipesUsesExpiring,
                      tone: StatusTone.error,
                    ),
                  ),
                ],
                if (match.missing.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.s3),
                  _MissingRow(
                    missing: [for (final i in match.missing) i.name],
                    onAddToList: onAddToList,
                  ),
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
  const _MissingRow({required this.missing, required this.onAddToList});

  final List<String> missing;
  final VoidCallback onAddToList;

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
        InkWell(
          onTap: onAddToList,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s1,
              vertical: 2,
            ),
            child: Text(
              context.l10n.recipesAddToList,
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w500,
                color: colors.accentText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  const _PhotoPlaceholder();

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
