import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/widgets/field_label.dart';
import '../../application/profile_providers.dart';
import '../../domain/dietary_options.dart';
import '../profile_error_message.dart';

/// Capture the user's dietary preferences: ticked allergens, diets and
/// dislikes plus a free-text note.
///
/// In E4.2 this only stores the choices (via [DietaryPreferencesController]);
/// applying them to recipe suggestions comes later. Selections are seeded once
/// from the current profile.
class DietaryPreferencesPage extends ConsumerStatefulWidget {
  const DietaryPreferencesPage({super.key});

  /// Relative segment under the profile branch (`/profile/dietary`).
  static const String routeSegment = 'dietary';
  static const String routeName = 'profile-dietary';

  @override
  ConsumerState<DietaryPreferencesPage> createState() =>
      _DietaryPreferencesPageState();
}

class _DietaryPreferencesPageState
    extends ConsumerState<DietaryPreferencesPage> {
  final Set<String> _allergens = {};
  final Set<String> _diets = {};
  final Set<String> _dislikes = {};
  final TextEditingController _note = TextEditingController();
  bool _seeded = false;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  void _toggle(Set<String> set, String key) {
    setState(() => set.contains(key) ? set.remove(key) : set.add(key));
  }

  Future<void> _submit() async {
    final ok = await ref
        .read(dietaryPreferencesControllerProvider.notifier)
        .save(
          allergens: _allergens.toList(),
          diets: _diets.toList(),
          dislikes: _dislikes.toList(),
          note: _note.text.trim().isEmpty ? null : _note.text.trim(),
        );

    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(context.l10n.dietarySavedSnack)));
      context.pop();
    } else {
      showProfileErrorSnackBar(
        context,
        ref,
        error: ref.read(dietaryPreferencesControllerProvider).error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final profileAsync = ref.watch(myProfileProvider);
    final isBusy = ref.watch(dietaryPreferencesControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileDietary)),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.pageInset),
            child: Text(
              l10n.profileErrorGeneric,
              style: AppTypography.body.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ),
        ),
        data: (profile) {
          if (profile == null) return const SizedBox.shrink();
          if (!_seeded) {
            _allergens.addAll(profile.allergens);
            _diets.addAll(profile.diets);
            _dislikes.addAll(profile.dislikes);
            _note.text = profile.dietaryNote ?? '';
            _seeded = true;
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.pageInset,
              AppSpacing.s5,
              AppSpacing.pageInset,
              AppSpacing.s10,
            ),
            children: [
              Text(
                l10n.dietarySubtitle,
                style: AppTypography.body.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.s6),
              _ChipGroup(
                title: l10n.dietaryAllergensTitle,
                options: DietaryOptions.allergens,
                selected: _allergens,
                labelFor: (key) => allergenLabel(l10n, key),
                onToggle: (key) => _toggle(_allergens, key),
              ),
              const SizedBox(height: AppSpacing.s6),
              _ChipGroup(
                title: l10n.dietaryDietsTitle,
                options: DietaryOptions.diets,
                selected: _diets,
                labelFor: (key) => dietLabel(l10n, key),
                onToggle: (key) => _toggle(_diets, key),
              ),
              const SizedBox(height: AppSpacing.s6),
              _ChipGroup(
                title: l10n.dietaryDislikesTitle,
                options: DietaryOptions.dislikes,
                selected: _dislikes,
                labelFor: (key) => dislikeLabel(l10n, key),
                onToggle: (key) => _toggle(_dislikes, key),
              ),
              const SizedBox(height: AppSpacing.s5),
              FieldLabel(l10n.dietaryNoteLabel),
              const SizedBox(height: AppSpacing.s1 + 2),
              TextField(
                controller: _note,
                enabled: !isBusy,
                minLines: 2,
                maxLines: 4,
                textInputAction: TextInputAction.newline,
                style: AppTypography.body.copyWith(
                  color: context.colors.textPrimary,
                ),
                decoration: InputDecoration(hintText: l10n.dietaryNoteHint),
              ),
              const SizedBox(height: AppSpacing.s6),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: isBusy ? null : _submit,
                  child: isBusy
                      ? const SizedBox.square(
                          dimension: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.commonSave),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// A titled group of multi-select chips.
class _ChipGroup extends StatelessWidget {
  const _ChipGroup({
    required this.title,
    required this.options,
    required this.selected,
    required this.labelFor,
    required this.onToggle,
  });

  final String title;
  final List<String> options;
  final Set<String> selected;
  final String Function(String key) labelFor;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(title),
        const SizedBox(height: AppSpacing.s3),
        Wrap(
          spacing: AppSpacing.s2,
          runSpacing: AppSpacing.s2,
          children: [
            for (final key in options)
              _PrefChip(
                label: labelFor(key),
                selected: selected.contains(key),
                onTap: () => onToggle(key),
              ),
          ],
        ),
      ],
    );
  }
}

/// A pill-shaped multi-select chip styled with the app tokens.
class _PrefChip extends StatelessWidget {
  const _PrefChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: selected ? colors.accentWash : colors.sunken,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s3 + 2,
            vertical: AppSpacing.s2 + 1,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                Icon(Icons.check, size: 15, color: colors.accentText),
                const SizedBox(width: AppSpacing.s1 + 2),
              ],
              Text(
                label,
                style: AppTypography.caption.copyWith(
                  fontSize: 14,
                  color: selected ? colors.accentText : colors.textSecondary,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Localized label for an allergen [key] from [DietaryOptions.allergens].
String allergenLabel(AppLocalizations l10n, String key) => switch (key) {
  'gluten' => l10n.dietaryAllergenGluten,
  'crustaceans' => l10n.dietaryAllergenCrustaceans,
  'eggs' => l10n.dietaryAllergenEggs,
  'fish' => l10n.dietaryAllergenFish,
  'peanuts' => l10n.dietaryAllergenPeanuts,
  'soy' => l10n.dietaryAllergenSoy,
  'milk' => l10n.dietaryAllergenMilk,
  'treeNuts' => l10n.dietaryAllergenTreeNuts,
  'celery' => l10n.dietaryAllergenCelery,
  'mustard' => l10n.dietaryAllergenMustard,
  'sesame' => l10n.dietaryAllergenSesame,
  'sulphites' => l10n.dietaryAllergenSulphites,
  'lupin' => l10n.dietaryAllergenLupin,
  'molluscs' => l10n.dietaryAllergenMolluscs,
  _ => key,
};

/// Localized label for a diet [key] from [DietaryOptions.diets].
String dietLabel(AppLocalizations l10n, String key) => switch (key) {
  'vegetarian' => l10n.dietaryDietVegetarian,
  'vegan' => l10n.dietaryDietVegan,
  'pescetarian' => l10n.dietaryDietPescetarian,
  'halal' => l10n.dietaryDietHalal,
  'kosher' => l10n.dietaryDietKosher,
  'glutenFree' => l10n.dietaryDietGlutenFree,
  'lactoseFree' => l10n.dietaryDietLactoseFree,
  'lowCarb' => l10n.dietaryDietLowCarb,
  _ => key,
};

/// Localized label for a dislike [key] from [DietaryOptions.dislikes].
String dislikeLabel(AppLocalizations l10n, String key) => switch (key) {
  'coriander' => l10n.dietaryDislikeCoriander,
  'olives' => l10n.dietaryDislikeOlives,
  'mushrooms' => l10n.dietaryDislikeMushrooms,
  'offal' => l10n.dietaryDislikeOffal,
  'blueCheese' => l10n.dietaryDislikeBlueCheese,
  _ => key,
};
