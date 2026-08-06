import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/header_icon_button.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/section_label.dart';
import '../../../../shared/widgets/zaiko_buttons.dart';
import '../../../../shared/widgets/zaiko_card.dart';
import '../../application/recipes_providers.dart';
import '../../domain/recipe.dart';
import '../../domain/recipe_ingredient.dart';
import '../../domain/recipe_match.dart';
import '../../domain/recipe_step.dart';
import '../recipe_error_message.dart';
import '../recipes_labels.dart';
import 'cook_mode_page.dart';
import 'recipe_form_page.dart';

/// A single recipe: ingredients (with an in-stock indicator) and the
/// step-by-step preparation. Reached as a go_router sub-route under the recipes
/// tab, so it keeps the bottom navigation. Edit and delete live in the header.
class RecipeDetailPage extends ConsumerWidget {
  const RecipeDetailPage({required this.recipeId, super.key});

  final String recipeId;

  /// Route name (`/recipes/:recipeId`).
  static const String routeName = 'recipe-detail';

  /// Sub-route segment under the recipes tab.
  static const String routeSegment = ':recipeId';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matches = ref.watch(recipeMatchesProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: matches.when(
          loading: () => const Center(
            child: SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          error: (_, _) => _NotFound(onBack: () => context.pop()),
          data: (data) {
            final match = _find(data, recipeId);
            if (match == null) return _NotFound(onBack: () => context.pop());
            return _RecipeBody(match: match);
          },
        ),
      ),
    );
  }

  RecipeMatch? _find(List<RecipeMatch> matches, String id) {
    for (final match in matches) {
      if (match.recipe.id == id) return match;
    }
    return null;
  }
}

class _RecipeBody extends ConsumerWidget {
  const _RecipeBody({required this.match});

  final RecipeMatch match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final recipe = match.recipe;
    final missingIds = {for (final i in match.missing) i.id};

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageInset,
        AppSpacing.s6,
        AppSpacing.pageInset,
        AppSpacing.s10,
      ),
      children: [
        _BackLink(onTap: () => context.pop()),
        const SizedBox(height: AppSpacing.s6),
        PageHeader(
          title: recipe.title,
          subtitle: recipeMetaLabel(l10n, recipe),
          trailing: Row(
            children: [
              HeaderIconButton(
                icon: Icons.edit_outlined,
                onTap: () => context.pushNamed(
                  RecipeFormPage.editRouteName,
                  pathParameters: {'recipeId': recipe.id},
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              HeaderIconButton(
                icon: Icons.delete_outline,
                onTap: () => _confirmDelete(context, ref, recipe),
              ),
            ],
          ),
        ),
        if (match.usesExpiring) ...[
          const SizedBox(height: AppSpacing.s4),
          Row(
            children: [
              Icon(Icons.schedule, size: 16, color: colors.error),
              const SizedBox(width: AppSpacing.s2),
              Text(
                l10n.recipesUsesExpiring,
                style: AppTypography.caption.copyWith(color: colors.error),
              ),
            ],
          ),
        ],
        if (recipe.steps.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s6),
          ZaikoPrimaryButton(
            label: l10n.recipesCookStart,
            icon: Icons.local_fire_department_outlined,
            onPressed: () => CookModePage.open(context, recipe: recipe),
          ),
        ],
        const SizedBox(height: AppSpacing.s6),
        SectionLabel(l10n.recipesIngredientsSection),
        const SizedBox(height: AppSpacing.s3),
        if (recipe.ingredients.isEmpty)
          _EmptyLine(l10n.recipesIngredientsEmpty)
        else
          ZaikoCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final ingredient in recipe.ingredients)
                  _IngredientRow(
                    ingredient: ingredient,
                    inStock: !missingIds.contains(ingredient.id),
                  ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.s6),
        SectionLabel(l10n.recipesStepsSection),
        const SizedBox(height: AppSpacing.s3),
        if (recipe.steps.isEmpty)
          _EmptyLine(l10n.recipesStepsEmpty)
        else
          for (final (index, step) in recipe.steps.indexed) ...[
            _StepRow(number: index + 1, step: step),
            if (index != recipe.steps.length - 1)
              const SizedBox(height: AppSpacing.s3),
          ],
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Recipe recipe,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.recipesDeleteTitle),
        content: Text(l10n.recipesDeleteMessage(recipe.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.recipesDeleteAction),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    final ok = await ref
        .read(recipeControllerProvider.notifier)
        .delete(recipe.id);
    if (!context.mounted) return;
    if (ok) {
      context.pop();
    } else {
      showRecipeErrorSnackBar(context, ref);
    }
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({required this.ingredient, required this.inStock});

  final RecipeIngredient ingredient;
  final bool inStock;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s3 + 2,
        vertical: AppSpacing.s3,
      ),
      child: Row(
        children: [
          Icon(
            inStock ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 18,
            color: inStock ? colors.success : colors.textTertiary,
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: Text(
              ingredient.name,
              style: AppTypography.body.copyWith(color: colors.textPrimary),
            ),
          ),
          if (ingredient.amount != null && ingredient.amount!.isNotEmpty) ...[
            const SizedBox(width: AppSpacing.s2),
            Text(
              ingredient.amount!,
              style: AppTypography.caption.copyWith(
                color: colors.textSecondary,
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({required this.number, required this.step});

  final int number;
  final RecipeStep step;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final timerSeconds = step.timerSeconds;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.accentMuted,
            shape: BoxShape.circle,
          ),
          child: Text(
            '$number',
            style: AppTypography.caption.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.accentText,
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s3),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.text,
                  style: AppTypography.body.copyWith(color: colors.textPrimary),
                ),
                if (timerSeconds != null) ...[
                  const SizedBox(height: AppSpacing.s1),
                  _StepTimerBadge(seconds: timerSeconds),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// A small "⏱ MM:SS" badge shown on a step that has a recipe-defined timer.
class _StepTimerBadge extends StatelessWidget {
  const _StepTimerBadge({required this.seconds});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.timer_outlined, size: 14, color: colors.textSecondary),
        const SizedBox(width: 4),
        Text(
          formatTimerDuration(Duration(seconds: seconds)),
          style: AppTypography.caption.copyWith(
            color: colors.textSecondary,
            fontFeatures: AppTypography.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _BackLink extends StatelessWidget {
  const _BackLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back, size: 16, color: colors.textSecondary),
            const SizedBox(width: 6),
            Text(
              context.l10n.commonBack,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyLine extends StatelessWidget {
  const _EmptyLine(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTypography.caption.copyWith(color: context.colors.textTertiary),
    );
  }
}

class _NotFound extends StatelessWidget {
  const _NotFound({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.pageInset),
      child: Column(
        children: [
          _BackLink(onTap: onBack),
          const SizedBox(height: AppSpacing.s10),
          Text(
            context.l10n.recipesErrorNotFound,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}
