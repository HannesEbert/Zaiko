import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/widgets/header_icon_button.dart';
import '../../../../shared/widgets/page_header.dart';
import '../../../../shared/widgets/zaiko_chip.dart';
import '../../application/recipes_providers.dart';
import '../../domain/recipe_match.dart';
import '../recipe_error_message.dart';
import '../widgets/recipe_card.dart';
import 'recipe_detail_page.dart';
import 'recipe_form_page.dart';

/// Recipes tab: household recipes matched against the current inventory. Data
/// comes from the Supabase-backed recipe providers, scoped to the active
/// household. Recipes that use expiring/expired stock lead the list; the filter
/// chips narrow it to "almost complete" or "under 30 min".
class RecipesPage extends ConsumerWidget {
  const RecipesPage({super.key});

  static const String routePath = '/recipes';
  static const String routeName = 'recipes';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final matches = ref.watch(filteredRecipeMatchesProvider);
    final filter = ref.watch(recipeFilterControllerProvider);

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
              title: l10n.recipesTitle,
              subtitle: l10n.recipesSubtitle,
              trailing: HeaderIconButton(
                icon: Icons.add,
                filled: true,
                onTap: () => context.pushNamed(RecipeFormPage.newRouteName),
              ),
            ),
            const SizedBox(height: AppSpacing.s4),
            _FilterChips(
              selected: filter,
              onSelect: (kind) => ref
                  .read(recipeFilterControllerProvider.notifier)
                  .select(kind),
            ),
            const SizedBox(height: AppSpacing.s5),
            matches.when(
              loading: () => const _RecipesLoading(),
              error: (_, _) =>
                  _RecipesError(onRetry: () => ref.invalidate(recipesProvider)),
              data: (data) => _RecipesList(
                matches: data,
                filtered: filter != RecipeFilterKind.all,
                onOpen: (match) => context.pushNamed(
                  RecipeDetailPage.routeName,
                  pathParameters: {'recipeId': match.recipe.id},
                ),
                onAddToList: (match) => _addMissing(context, ref, match),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addMissing(
    BuildContext context,
    WidgetRef ref,
    RecipeMatch match,
  ) async {
    final count = match.missing.length;
    final ok = await ref
        .read(recipeControllerProvider.notifier)
        .addMissingToShoppingList(match.missing);
    if (!context.mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(context.l10n.recipesAddedToList(count))),
        );
    } else {
      showRecipeErrorSnackBar(context, ref);
    }
  }
}

/// The Alle / Fast vollständig / Unter 30 Min filter chips.
class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.selected, required this.onSelect});

  final RecipeFilterKind selected;
  final ValueChanged<RecipeFilterKind> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          for (final kind in RecipeFilterKind.values) ...[
            if (kind != RecipeFilterKind.values.first)
              const SizedBox(width: AppSpacing.s2),
            ZaikoChip(
              label: _filterLabel(l10n, kind),
              selected: selected == kind,
              onTap: () => onSelect(kind),
            ),
          ],
        ],
      ),
    );
  }

  String _filterLabel(AppLocalizations l10n, RecipeFilterKind kind) =>
      switch (kind) {
        RecipeFilterKind.all => l10n.commonAll,
        RecipeFilterKind.almostComplete => l10n.recipesFilterAlmostComplete,
        RecipeFilterKind.under30Min => l10n.recipesFilterUnder30,
      };
}

class _RecipesList extends StatelessWidget {
  const _RecipesList({
    required this.matches,
    required this.filtered,
    required this.onOpen,
    required this.onAddToList,
  });

  final List<RecipeMatch> matches;

  /// Whether a filter is active, to tell "no recipes" from "none match".
  final bool filtered;
  final void Function(RecipeMatch match) onOpen;
  final void Function(RecipeMatch match) onAddToList;

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return filtered ? const _RecipesFilterEmpty() : const _RecipesEmpty();
    }
    return Column(
      children: [
        for (final match in matches) ...[
          RecipeCard(
            match,
            key: ValueKey(match.recipe.id),
            onTap: () => onOpen(match),
            onAddToList: () => onAddToList(match),
          ),
          const SizedBox(height: AppSpacing.s3 + 2),
        ],
      ],
    );
  }
}

class _RecipesEmpty extends StatelessWidget {
  const _RecipesEmpty();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s10),
      child: Column(
        children: [
          Icon(Icons.menu_book_outlined, size: 40, color: colors.textTertiary),
          const SizedBox(height: AppSpacing.s3),
          Text(
            l10n.recipesEmptyTitle,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(color: colors.textPrimary),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(
            l10n.recipesEmptyMessage,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _RecipesFilterEmpty extends StatelessWidget {
  const _RecipesFilterEmpty();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s5),
      child: Center(
        child: Text(
          context.l10n.recipesEmptyMessage,
          textAlign: TextAlign.center,
          style: AppTypography.caption.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
      ),
    );
  }
}

class _RecipesLoading extends StatelessWidget {
  const _RecipesLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.s10),
      child: Center(
        child: SizedBox(
          width: 22,
          height: 22,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _RecipesError extends StatelessWidget {
  const _RecipesError({this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s6),
      child: Column(
        children: [
          Icon(Icons.cloud_off_outlined, size: 32, color: colors.textTertiary),
          const SizedBox(height: AppSpacing.s2),
          Text(
            l10n.recipesLoadError,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: colors.textSecondary),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: AppSpacing.s2),
            TextButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
          ],
        ],
      ),
    );
  }
}
