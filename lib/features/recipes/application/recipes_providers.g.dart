// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipes_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's [RecipeRepository]. Overridden with a fake in tests.

@ProviderFor(recipeRepository)
final recipeRepositoryProvider = RecipeRepositoryProvider._();

/// The app's [RecipeRepository]. Overridden with a fake in tests.

final class RecipeRepositoryProvider
    extends
        $FunctionalProvider<
          RecipeRepository,
          RecipeRepository,
          RecipeRepository
        >
    with $Provider<RecipeRepository> {
  /// The app's [RecipeRepository]. Overridden with a fake in tests.
  RecipeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecipeRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RecipeRepository create(Ref ref) {
    return recipeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeRepository>(value),
    );
  }
}

String _$recipeRepositoryHash() => r'877f3da437d973d58e45acc74eaa3d194a9c6d23';

/// The active household's recipes, newest first. Emits an empty list while the
/// user has no household. Re-fetched (not streamed) because ingredients are an
/// embedded resource; the [RecipeController] invalidates this after each write.

@ProviderFor(recipes)
final recipesProvider = RecipesProvider._();

/// The active household's recipes, newest first. Emits an empty list while the
/// user has no household. Re-fetched (not streamed) because ingredients are an
/// embedded resource; the [RecipeController] invalidates this after each write.

final class RecipesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Recipe>>,
          List<Recipe>,
          FutureOr<List<Recipe>>
        >
    with $FutureModifier<List<Recipe>>, $FutureProvider<List<Recipe>> {
  /// The active household's recipes, newest first. Emits an empty list while the
  /// user has no household. Re-fetched (not streamed) because ingredients are an
  /// embedded resource; the [RecipeController] invalidates this after each write.
  RecipesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipesHash();

  @$internal
  @override
  $FutureProviderElement<List<Recipe>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Recipe>> create(Ref ref) {
    return recipes(ref);
  }
}

String _$recipesHash() => r'9bc954d2b4602cdb70d2d51b5a593eb07e7004b4';

/// Every recipe matched against the household's current stock, most useful
/// first: recipes that use expiring/expired items lead (then by how much they
/// use up), then the ones missing the fewest ingredients, then by title.

@ProviderFor(recipeMatches)
final recipeMatchesProvider = RecipeMatchesProvider._();

/// Every recipe matched against the household's current stock, most useful
/// first: recipes that use expiring/expired items lead (then by how much they
/// use up), then the ones missing the fewest ingredients, then by title.

final class RecipeMatchesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecipeMatch>>,
          List<RecipeMatch>,
          FutureOr<List<RecipeMatch>>
        >
    with
        $FutureModifier<List<RecipeMatch>>,
        $FutureProvider<List<RecipeMatch>> {
  /// Every recipe matched against the household's current stock, most useful
  /// first: recipes that use expiring/expired items lead (then by how much they
  /// use up), then the ones missing the fewest ingredients, then by title.
  RecipeMatchesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeMatchesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeMatchesHash();

  @$internal
  @override
  $FutureProviderElement<List<RecipeMatch>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RecipeMatch>> create(Ref ref) {
    return recipeMatches(ref);
  }
}

String _$recipeMatchesHash() => r'8b0461bcf3e912868016e240d27727bd5249ec14';

/// The selected recipe-list filter. Held in a provider (not local widget state)
/// so the filtering logic is testable in isolation.

@ProviderFor(RecipeFilterController)
final recipeFilterControllerProvider = RecipeFilterControllerProvider._();

/// The selected recipe-list filter. Held in a provider (not local widget state)
/// so the filtering logic is testable in isolation.
final class RecipeFilterControllerProvider
    extends $NotifierProvider<RecipeFilterController, RecipeFilterKind> {
  /// The selected recipe-list filter. Held in a provider (not local widget state)
  /// so the filtering logic is testable in isolation.
  RecipeFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeFilterControllerHash();

  @$internal
  @override
  RecipeFilterController create() => RecipeFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecipeFilterKind value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecipeFilterKind>(value),
    );
  }
}

String _$recipeFilterControllerHash() =>
    r'9bf2cdc085a211b3010fe898ce3fbb5cb5832cfc';

/// The selected recipe-list filter. Held in a provider (not local widget state)
/// so the filtering logic is testable in isolation.

abstract class _$RecipeFilterController extends $Notifier<RecipeFilterKind> {
  RecipeFilterKind build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<RecipeFilterKind, RecipeFilterKind>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RecipeFilterKind, RecipeFilterKind>,
              RecipeFilterKind,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// [recipeMatches] narrowed by the active [RecipeFilterKind].

@ProviderFor(filteredRecipeMatches)
final filteredRecipeMatchesProvider = FilteredRecipeMatchesProvider._();

/// [recipeMatches] narrowed by the active [RecipeFilterKind].

final class FilteredRecipeMatchesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RecipeMatch>>,
          List<RecipeMatch>,
          FutureOr<List<RecipeMatch>>
        >
    with
        $FutureModifier<List<RecipeMatch>>,
        $FutureProvider<List<RecipeMatch>> {
  /// [recipeMatches] narrowed by the active [RecipeFilterKind].
  FilteredRecipeMatchesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredRecipeMatchesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredRecipeMatchesHash();

  @$internal
  @override
  $FutureProviderElement<List<RecipeMatch>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<RecipeMatch>> create(Ref ref) {
    return filteredRecipeMatches(ref);
  }
}

String _$filteredRecipeMatchesHash() =>
    r'8e6ad7e10081c314ea78ac57448106fdff0f9bfa';

/// Drives create/edit/delete for recipes plus the "add missing to shopping
/// list" action, with loading/error state.
///
/// Kept alive: the UI only reaches it through `ref.read(...notifier)` and never
/// watches it, so an autoDispose controller would be disposed during the async
/// mutation and its post-`await` `ref.invalidate` would never fire (the recipe
/// list is a one-shot load, so it must be invalidated explicitly).

@ProviderFor(RecipeController)
final recipeControllerProvider = RecipeControllerProvider._();

/// Drives create/edit/delete for recipes plus the "add missing to shopping
/// list" action, with loading/error state.
///
/// Kept alive: the UI only reaches it through `ref.read(...notifier)` and never
/// watches it, so an autoDispose controller would be disposed during the async
/// mutation and its post-`await` `ref.invalidate` would never fire (the recipe
/// list is a one-shot load, so it must be invalidated explicitly).
final class RecipeControllerProvider
    extends $AsyncNotifierProvider<RecipeController, void> {
  /// Drives create/edit/delete for recipes plus the "add missing to shopping
  /// list" action, with loading/error state.
  ///
  /// Kept alive: the UI only reaches it through `ref.read(...notifier)` and never
  /// watches it, so an autoDispose controller would be disposed during the async
  /// mutation and its post-`await` `ref.invalidate` would never fire (the recipe
  /// list is a one-shot load, so it must be invalidated explicitly).
  RecipeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recipeControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recipeControllerHash();

  @$internal
  @override
  RecipeController create() => RecipeController();
}

String _$recipeControllerHash() => r'92a0be862484800cb09a3624ca62826e39520912';

/// Drives create/edit/delete for recipes plus the "add missing to shopping
/// list" action, with loading/error state.
///
/// Kept alive: the UI only reaches it through `ref.read(...notifier)` and never
/// watches it, so an autoDispose controller would be disposed during the async
/// mutation and its post-`await` `ref.invalidate` would never fire (the recipe
/// list is a one-shot load, so it must be invalidated explicitly).

abstract class _$RecipeController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
