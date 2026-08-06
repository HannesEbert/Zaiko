import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/widgets/field_label.dart';
import '../../application/recipes_providers.dart';
import '../../domain/recipe.dart';
import '../../domain/recipe_draft.dart';
import '../../domain/recipe_step.dart';
import '../recipe_error_message.dart';

/// Create or edit a recipe. Passing an [recipeId] edits it; passing null
/// creates a new one. Title, time, servings, a dynamic ingredient list and a
/// dynamic step list; on save it delegates to the [RecipeController].
class RecipeFormPage extends ConsumerStatefulWidget {
  const RecipeFormPage({this.recipeId, super.key});

  /// The recipe being edited, or null when creating.
  final String? recipeId;

  /// Route name for creating (`/recipes/new`).
  static const String newRouteName = 'recipe-new';

  /// Route segment for creating, under the recipes tab.
  static const String newRouteSegment = 'new';

  /// Route name for editing (`/recipes/:recipeId/edit`).
  static const String editRouteName = 'recipe-edit';

  /// Route segment for editing, under the recipe detail route.
  static const String editRouteSegment = 'edit';

  @override
  ConsumerState<RecipeFormPage> createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends ConsumerState<RecipeFormPage> {
  late final TextEditingController _titleController;
  late final TextEditingController _minutesController;
  late final TextEditingController _servingsController;
  late final List<_IngredientField> _ingredients;
  late final List<_StepField> _steps;

  bool get _isEdit => widget.recipeId != null;

  @override
  void initState() {
    super.initState();
    final recipe = _existingRecipe();
    _titleController = TextEditingController(text: recipe?.title ?? '');
    _minutesController = TextEditingController(
      text: recipe?.totalMinutes?.toString() ?? '',
    );
    _servingsController = TextEditingController(
      text: recipe?.servings?.toString() ?? '',
    );
    _ingredients = recipe == null || recipe.ingredients.isEmpty
        ? [_IngredientField()]
        : [
            for (final ingredient in recipe.ingredients)
              _IngredientField(
                name: ingredient.name,
                amount: ingredient.amount,
              ),
          ];
    _steps = recipe == null || recipe.steps.isEmpty
        ? [_StepField()]
        : [
            for (final step in recipe.steps)
              _StepField(text: step.text, timerSeconds: step.timerSeconds),
          ];
  }

  /// The recipe being edited, looked up in the already-loaded list (edit is only
  /// reachable from the detail page, so the list is cached).
  Recipe? _existingRecipe() {
    final id = widget.recipeId;
    if (id == null) return null;
    final recipes = ref.read(recipesProvider).asData?.value ?? const [];
    for (final recipe in recipes) {
      if (recipe.id == id) return recipe;
    }
    return null;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _minutesController.dispose();
    _servingsController.dispose();
    for (final field in _ingredients) {
      field.dispose();
    }
    for (final field in _steps) {
      field.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isBusy = ref.watch(recipeControllerProvider).isLoading;
    final canSave = _titleController.text.trim().isNotEmpty && !isBusy;

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
            _Header(
              title: _isEdit ? l10n.recipesEditTitle : l10n.recipesNewTitle,
              onClose: () => context.pop(),
            ),
            const SizedBox(height: AppSpacing.s6),
            FieldLabel(l10n.recipesFormTitleLabel),
            const SizedBox(height: AppSpacing.s1 + 2),
            TextField(
              controller: _titleController,
              enabled: !isBusy,
              autofocus: !_isEdit,
              textCapitalization: TextCapitalization.sentences,
              style: AppTypography.body.copyWith(
                color: context.colors.textPrimary,
              ),
              decoration: InputDecoration(hintText: l10n.recipesFormTitleHint),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: AppSpacing.s4),
            Row(
              children: [
                Expanded(
                  child: _NumberField(
                    label: l10n.recipesFormMinutesLabel,
                    controller: _minutesController,
                    enabled: !isBusy,
                  ),
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: _NumberField(
                    label: l10n.recipesFormServingsLabel,
                    controller: _servingsController,
                    enabled: !isBusy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s5),
            FieldLabel(l10n.recipesIngredientsSection),
            const SizedBox(height: AppSpacing.s2),
            for (final (index, field) in _ingredients.indexed) ...[
              _IngredientRow(
                field: field,
                enabled: !isBusy,
                onRemove: _ingredients.length == 1
                    ? null
                    : () => setState(
                        () => _ingredients.removeAt(index).dispose(),
                      ),
              ),
              const SizedBox(height: AppSpacing.s2),
            ],
            _AddLine(
              label: l10n.recipesFormAddIngredient,
              onTap: isBusy
                  ? null
                  : () => setState(() => _ingredients.add(_IngredientField())),
            ),
            const SizedBox(height: AppSpacing.s5),
            FieldLabel(l10n.recipesStepsSection),
            const SizedBox(height: AppSpacing.s2),
            for (final (index, field) in _steps.indexed) ...[
              _StepRow(
                number: index + 1,
                field: field,
                enabled: !isBusy,
                onToggleTimer: () =>
                    setState(() => field.withTimer = !field.withTimer),
                onRemove: _steps.length == 1
                    ? null
                    : () => setState(() => _steps.removeAt(index).dispose()),
              ),
              const SizedBox(height: AppSpacing.s2),
            ],
            _AddLine(
              label: l10n.recipesFormAddStep,
              onTap: isBusy
                  ? null
                  : () => setState(() => _steps.add(_StepField())),
            ),
            const SizedBox(height: AppSpacing.s6),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: canSave ? _submit : null,
                child: Text(
                  _isEdit ? l10n.recipesSaveButton : l10n.recipesCreateButton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final draft = RecipeDraft(
      title: _titleController.text.trim(),
      totalMinutes: int.tryParse(_minutesController.text.trim()),
      servings: int.tryParse(_servingsController.text.trim()),
      ingredients: [
        for (final field in _ingredients)
          if (field.name.text.trim().isNotEmpty)
            RecipeIngredientDraft(
              name: field.name.text.trim(),
              amount: field.amount.text.trim().isEmpty
                  ? null
                  : field.amount.text.trim(),
            ),
      ],
      steps: [
        for (final field in _steps)
          if (field.text.text.trim().isNotEmpty)
            RecipeStep(
              text: field.text.text.trim(),
              timerSeconds: field.timerSeconds,
            ),
      ],
    );

    final controller = ref.read(recipeControllerProvider.notifier);
    final ok = _isEdit
        ? await controller.save(id: widget.recipeId!, draft: draft)
        : await controller.create(draft);

    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      showRecipeErrorSnackBar(context, ref);
    }
  }
}

/// A name + amount controller pair for one ingredient row.
class _IngredientField {
  _IngredientField({String? name, String? amount})
    : name = TextEditingController(text: name ?? ''),
      amount = TextEditingController(text: amount ?? '');

  final TextEditingController name;
  final TextEditingController amount;

  void dispose() {
    name.dispose();
    amount.dispose();
  }
}

class _IngredientRow extends StatelessWidget {
  const _IngredientRow({
    required this.field,
    required this.enabled,
    this.onRemove,
  });

  final _IngredientField field;
  final bool enabled;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            controller: field.name,
            enabled: enabled,
            textCapitalization: TextCapitalization.sentences,
            style: AppTypography.body.copyWith(color: colors.textPrimary),
            decoration: InputDecoration(
              hintText: l10n.recipesFormIngredientNameHint,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.s2),
        Expanded(
          flex: 2,
          child: TextField(
            controller: field.amount,
            enabled: enabled,
            style: AppTypography.body.copyWith(color: colors.textPrimary),
            decoration: InputDecoration(hintText: l10n.recipesFormAmountHint),
          ),
        ),
        _RemoveButton(onTap: enabled ? onRemove : null),
      ],
    );
  }
}

/// A step's text controller plus its optional-timer state (mirrors
/// [_IngredientField]). [timerSeconds] is null unless the timer is on and a
/// duration was entered.
class _StepField {
  _StepField({String? text, int? timerSeconds})
    : text = TextEditingController(text: text ?? ''),
      withTimer = timerSeconds != null,
      minutes = TextEditingController(
        text: timerSeconds == null ? '' : (timerSeconds ~/ 60).toString(),
      ),
      seconds = TextEditingController(
        text: timerSeconds == null ? '' : (timerSeconds % 60).toString(),
      );

  final TextEditingController text;
  bool withTimer;
  final TextEditingController minutes;
  final TextEditingController seconds;

  /// The configured timer in seconds, or null when the timer is off or empty.
  int? get timerSeconds {
    if (!withTimer) return null;
    final min = int.tryParse(minutes.text.trim()) ?? 0;
    final sec = int.tryParse(seconds.text.trim()) ?? 0;
    final total = min * 60 + sec;
    return total > 0 ? total : null;
  }

  void dispose() {
    text.dispose();
    minutes.dispose();
    seconds.dispose();
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.number,
    required this.field,
    required this.enabled,
    required this.onToggleTimer,
    this.onRemove,
  });

  final int number;
  final _StepField field;
  final bool enabled;
  final VoidCallback onToggleTimer;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s3),
              child: Text(
                '$number.',
                style: AppTypography.bodyMedium.copyWith(
                  color: colors.textSecondary,
                  fontFeatures: AppTypography.tabularFigures,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: TextField(
                controller: field.text,
                enabled: enabled,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                style: AppTypography.body.copyWith(color: colors.textPrimary),
                decoration: InputDecoration(
                  hintText: l10n.recipesFormStepHint(number),
                ),
              ),
            ),
            _RemoveButton(onTap: enabled ? onRemove : null),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.s6),
          child: Row(
            children: [
              Switch.adaptive(
                value: field.withTimer,
                onChanged: enabled ? (_) => onToggleTimer() : null,
              ),
              const SizedBox(width: AppSpacing.s1),
              Text(
                l10n.recipesFormStepTimerToggle,
                style: AppTypography.body.copyWith(color: colors.textSecondary),
              ),
              if (field.withTimer) ...[
                const SizedBox(width: AppSpacing.s3),
                SizedBox(
                  width: 64,
                  child: _TimerPartField(
                    controller: field.minutes,
                    hint: l10n.recipesFormStepTimerMinutes,
                    enabled: enabled,
                  ),
                ),
                const SizedBox(width: AppSpacing.s2),
                SizedBox(
                  width: 64,
                  child: _TimerPartField(
                    controller: field.seconds,
                    hint: l10n.recipesFormStepTimerSeconds,
                    enabled: enabled,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// A narrow digits-only field for a step timer's minutes or seconds.
class _TimerPartField extends StatelessWidget {
  const _TimerPartField({
    required this.controller,
    required this.hint,
    required this.enabled,
  });

  final TextEditingController controller;
  final String hint;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: AppTypography.body.copyWith(color: context.colors.textPrimary),
      decoration: InputDecoration(hintText: hint),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.label,
    required this.controller,
    required this.enabled,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        const SizedBox(height: AppSpacing.s1 + 2),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: AppTypography.body.copyWith(color: context.colors.textPrimary),
          decoration: const InputDecoration(hintText: '–'),
        ),
      ],
    );
  }
}

class _AddLine extends StatelessWidget {
  const _AddLine({required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s1,
            vertical: AppSpacing.s2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add, size: 18, color: colors.accentText),
              const SizedBox(width: AppSpacing.s1 + 2),
              Text(
                label,
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.accentText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  const _RemoveButton({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return IconButton(
      onPressed: onTap,
      icon: Icon(
        Icons.remove_circle_outline,
        size: 20,
        color: onTap == null ? colors.borderStrong : colors.textTertiary,
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTypography.title.copyWith(color: colors.textPrimary),
        ),
        Material(
          color: colors.sunken,
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onClose,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 30,
              height: 30,
              child: Icon(Icons.close, size: 15, color: colors.textSecondary),
            ),
          ),
        ),
      ],
    );
  }
}
