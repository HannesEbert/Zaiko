import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n_extension.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../shared/widgets/header_icon_button.dart';
import '../../../../shared/widgets/zaiko_buttons.dart';
import '../../application/cook_timers.dart';
import '../../application/screen_wake_lock.dart';
import '../../domain/recipe.dart';
import '../../domain/recipe_step.dart';
import '../recipes_labels.dart';

/// Full-screen, step-by-step cooking view for a single recipe — the "phone set
/// aside" mode. Reached via [open] on the root navigator, so it covers the tab
/// bar; the screen is kept awake while it is on top.
///
/// Steps are paged through with a [PageView] (swipe) plus back/next buttons, a
/// "Step X/Y" counter and a progress bar. Each step carries a manual countdown
/// timer, and the recipe's ingredients are one tap away in a bottom sheet.
class CookModePage extends ConsumerStatefulWidget {
  const CookModePage({required this.recipe, super.key});

  final Recipe recipe;

  /// Pushes the cook mode onto the root navigator (over the bottom nav bar).
  static Future<void> open(BuildContext context, {required Recipe recipe}) {
    return Navigator.of(context, rootNavigator: true).push<void>(
      MaterialPageRoute<void>(builder: (_) => CookModePage(recipe: recipe)),
    );
  }

  @override
  ConsumerState<CookModePage> createState() => _CookModePageState();
}

class _CookModePageState extends ConsumerState<CookModePage> {
  final PageController _controller = PageController();
  // Resolved once here (ref is unavailable in dispose, where we release it).
  late final ScreenWakeLock _wakeLock = ref.read(screenWakeLockProvider);
  int _index = 0;

  List<RecipeStep> get _steps => widget.recipe.steps;

  @override
  void initState() {
    super.initState();
    // Keep the screen awake for the session; released again in dispose.
    _wakeLock.enable();
    // Pre-load the timers of steps that carry a recipe-defined duration. Done
    // after the first frame — a provider must not be mutated during build.
    final durations = <int, Duration>{
      for (final (index, step) in _steps.indexed)
        if (step.timerSeconds != null)
          index: Duration(seconds: step.timerSeconds!),
    };
    if (durations.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ref.read(cookTimersProvider.notifier).seed(durations);
      });
    }
  }

  @override
  void dispose() {
    _wakeLock.disable();
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Hold the timer controller alive for the page's whole lifetime without
    // rebuilding on ticks (the constant selector never changes). This keeps a
    // running timer going across swipes and disposes every ticker on pop.
    ref.watch(cookTimersProvider.select((_) => 0));

    if (_steps.isEmpty) {
      return _EmptyCookMode(onClose: () => Navigator.of(context).pop());
    }

    final total = _steps.length;
    final isLast = _index == total - 1;

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              label: context.l10n.recipesCookStep(_index + 1, total),
              onClose: () => Navigator.of(context).pop(),
              onIngredients: () =>
                  _showCookIngredientsSheet(context, widget.recipe),
            ),
            _ProgressBar(value: (_index + 1) / total),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: total,
                onPageChanged: (index) => setState(() => _index = index),
                itemBuilder: (context, index) => _StepView(
                  number: index + 1,
                  step: _steps[index],
                  stepIndex: index,
                ),
              ),
            ),
            _BottomBar(
              canGoBack: _index > 0,
              isLast: isLast,
              onBack: () => _goTo(_index - 1),
              onForward: isLast
                  ? () => Navigator.of(context).pop()
                  : () => _goTo(_index + 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.label,
    required this.onClose,
    required this.onIngredients,
  });

  final String label;
  final VoidCallback onClose;
  final VoidCallback onIngredients;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageInset,
        AppSpacing.s3,
        AppSpacing.pageInset,
        AppSpacing.s3,
      ),
      child: Row(
        children: [
          HeaderIconButton(
            icon: Icons.close,
            onTap: onClose,
            tooltip: l10n.commonBack,
          ),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium.copyWith(
                color: context.colors.textSecondary,
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
          ),
          HeaderIconButton(
            icon: Icons.receipt_long_outlined,
            onTap: onIngredients,
            tooltip: l10n.recipesIngredientsSection,
          ),
        ],
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.pageInset),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: LinearProgressIndicator(
          value: value,
          minHeight: 4,
          backgroundColor: colors.sunken,
          valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
        ),
      ),
    );
  }
}

class _StepView extends StatelessWidget {
  const _StepView({
    required this.number,
    required this.step,
    required this.stepIndex,
  });

  final int number;
  final RecipeStep step;
  final int stepIndex;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageInset,
        AppSpacing.s6,
        AppSpacing.pageInset,
        AppSpacing.s8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number',
            style: AppTypography.display.copyWith(
              color: colors.accentText,
              fontFeatures: AppTypography.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.s4),
          Text(
            step.text,
            style: AppTypography.title.copyWith(color: colors.textPrimary),
          ),
          // Only steps with a recipe-defined duration get a timer.
          if (step.timerSeconds != null) ...[
            const SizedBox(height: AppSpacing.s8),
            _StepTimer(
              stepIndex: stepIndex,
              configuredSeconds: step.timerSeconds!,
            ),
          ],
        ],
      ),
    );
  }
}

/// The per-step countdown card, driven by [CookTimers] and keyed by step index.
class _StepTimer extends ConsumerWidget {
  const _StepTimer({required this.stepIndex, required this.configuredSeconds});

  final int stepIndex;

  /// The recipe-defined duration; shown until the controller is seeded, so the
  /// first frame already reads correctly (no fallback flash).
  final int configuredSeconds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final configured = Duration(seconds: configuredSeconds);
    final timer =
        ref.watch(cookTimersProvider.select((map) => map[stepIndex])) ??
        CookTimer(
          configured: configured,
          remaining: configured,
          status: CookTimerStatus.idle,
        );
    final controller = ref.read(cookTimersProvider.notifier);
    final isFinished = timer.status == CookTimerStatus.finished;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: colors.borderSubtle),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s5),
        child: Column(
          children: [
            Text(
              formatTimerDuration(timer.remaining),
              style: AppTypography.display.copyWith(
                color: isFinished ? colors.warning : colors.textPrimary,
                fontFeatures: AppTypography.tabularFigures,
              ),
            ),
            if (isFinished) ...[
              const SizedBox(height: AppSpacing.s2),
              Text(
                l10n.recipesCookTimerDone,
                style: AppTypography.bodyMedium.copyWith(color: colors.warning),
              ),
            ],
            const SizedBox(height: AppSpacing.s4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _AdjustGroup(
                  label: l10n.recipesFormStepTimerMinutes,
                  onRemove: () =>
                      controller.adjust(stepIndex, -kCookTimerMinuteStep),
                  onAdd: () =>
                      controller.adjust(stepIndex, kCookTimerMinuteStep),
                  removeTooltip: l10n.recipesCookTimerRemoveMinute,
                  addTooltip: l10n.recipesCookTimerAddMinute,
                ),
                _AdjustGroup(
                  label: l10n.recipesFormStepTimerSeconds,
                  onRemove: () =>
                      controller.adjust(stepIndex, -kCookTimerSecondStep),
                  onAdd: () =>
                      controller.adjust(stepIndex, kCookTimerSecondStep),
                  removeTooltip: l10n.recipesCookTimerRemoveSecond,
                  addTooltip: l10n.recipesCookTimerAddSecond,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s4),
            _TimerActions(
              status: timer.status,
              onStart: () => controller.start(
                stepIndex,
                notifTitle: l10n.recipesCookTimerDone,
                notifBody: l10n.recipesCookTimerNotificationBody,
              ),
              onPause: () => controller.pause(stepIndex),
              onReset: () => controller.reset(stepIndex),
            ),
          ],
        ),
      ),
    );
  }
}

/// A "− label +" cluster that steps a timer up or down (minutes or seconds).
class _AdjustGroup extends StatelessWidget {
  const _AdjustGroup({
    required this.label,
    required this.onRemove,
    required this.onAdd,
    required this.removeTooltip,
    required this.addTooltip,
  });

  final String label;
  final VoidCallback onRemove;
  final VoidCallback onAdd;
  final String removeTooltip;
  final String addTooltip;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        HeaderIconButton(
          icon: Icons.remove,
          onTap: onRemove,
          tooltip: removeTooltip,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s2),
          child: Text(
            label,
            style: AppTypography.caption.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ),
        HeaderIconButton(icon: Icons.add, onTap: onAdd, tooltip: addTooltip),
      ],
    );
  }
}

/// The status-dependent action buttons of a step timer: start / pause+reset /
/// resume+reset / reset.
class _TimerActions extends StatelessWidget {
  const _TimerActions({
    required this.status,
    required this.onStart,
    required this.onPause,
    required this.onReset,
  });

  final CookTimerStatus status;
  final VoidCallback onStart;
  final VoidCallback onPause;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final resetButton = ZaikoSecondaryButton(
      label: l10n.recipesCookTimerReset,
      icon: Icons.refresh,
      onPressed: onReset,
    );

    return switch (status) {
      CookTimerStatus.idle => ZaikoPrimaryButton(
        label: l10n.recipesCookTimerStart,
        icon: Icons.play_arrow,
        onPressed: onStart,
      ),
      CookTimerStatus.finished => resetButton,
      CookTimerStatus.running => Row(
        children: [
          Expanded(
            child: ZaikoPrimaryButton(
              label: l10n.recipesCookTimerPause,
              icon: Icons.pause,
              onPressed: onPause,
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(child: resetButton),
        ],
      ),
      CookTimerStatus.paused => Row(
        children: [
          Expanded(
            child: ZaikoPrimaryButton(
              label: l10n.recipesCookTimerResume,
              icon: Icons.play_arrow,
              onPressed: onStart,
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(child: resetButton),
        ],
      ),
    };
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.canGoBack,
    required this.isLast,
    required this.onBack,
    required this.onForward,
  });

  final bool canGoBack;
  final bool isLast;
  final VoidCallback onBack;
  final VoidCallback onForward;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.pageInset,
        AppSpacing.s3,
        AppSpacing.pageInset,
        AppSpacing.s5,
      ),
      child: Row(
        children: [
          Expanded(
            child: ZaikoSecondaryButton(
              label: l10n.commonBack,
              icon: Icons.arrow_back,
              onPressed: canGoBack ? onBack : null,
            ),
          ),
          const SizedBox(width: AppSpacing.s3),
          Expanded(
            child: ZaikoPrimaryButton(
              label: isLast ? l10n.recipesCookFinish : l10n.recipesCookNext,
              icon: isLast ? Icons.check : Icons.arrow_forward,
              onPressed: onForward,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyCookMode extends StatelessWidget {
  const _EmptyCookMode({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.pageInset),
                child: HeaderIconButton(
                  icon: Icons.close,
                  onTap: onClose,
                  tooltip: context.l10n.commonBack,
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.pageInset),
                  child: Text(
                    context.l10n.recipesCookEmpty,
                    textAlign: TextAlign.center,
                    style: AppTypography.body.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shows the recipe's ingredients in a modal sheet, reachable from any step so
/// the cook can check quantities without leaving the current step.
Future<void> _showCookIngredientsSheet(BuildContext context, Recipe recipe) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => _IngredientsSheet(recipe: recipe),
  );
}

class _IngredientsSheet extends StatelessWidget {
  const _IngredientsSheet({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        margin: const EdgeInsets.all(AppSpacing.s3),
        decoration: BoxDecoration(
          color: colors.card,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: colors.borderSubtle),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.s5,
                AppSpacing.s5,
                AppSpacing.s5,
                AppSpacing.s3,
              ),
              child: Text(
                l10n.recipesIngredientsSection,
                style: AppTypography.headline.copyWith(
                  color: colors.textPrimary,
                ),
              ),
            ),
            if (recipe.ingredients.isEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s5,
                  0,
                  AppSpacing.s5,
                  AppSpacing.s5,
                ),
                child: Text(
                  l10n.recipesIngredientsEmpty,
                  style: AppTypography.caption.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s5,
                    0,
                    AppSpacing.s5,
                    AppSpacing.s5,
                  ),
                  itemCount: recipe.ingredients.length,
                  separatorBuilder: (_, _) =>
                      Divider(height: 1, thickness: 1, color: colors.divider),
                  itemBuilder: (context, index) {
                    final ingredient = recipe.ingredients[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.s3,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              ingredient.name,
                              style: AppTypography.body.copyWith(
                                color: colors.textPrimary,
                              ),
                            ),
                          ),
                          if (ingredient.amount != null &&
                              ingredient.amount!.isNotEmpty) ...[
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
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
