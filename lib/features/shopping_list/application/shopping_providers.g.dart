// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's [ShoppingRepository]. Overridden with a fake in tests.

@ProviderFor(shoppingRepository)
final shoppingRepositoryProvider = ShoppingRepositoryProvider._();

/// The app's [ShoppingRepository]. Overridden with a fake in tests.

final class ShoppingRepositoryProvider
    extends
        $FunctionalProvider<
          ShoppingRepository,
          ShoppingRepository,
          ShoppingRepository
        >
    with $Provider<ShoppingRepository> {
  /// The app's [ShoppingRepository]. Overridden with a fake in tests.
  ShoppingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shoppingRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shoppingRepositoryHash();

  @$internal
  @override
  $ProviderElement<ShoppingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ShoppingRepository create(Ref ref) {
    return shoppingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ShoppingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ShoppingRepository>(value),
    );
  }
}

String _$shoppingRepositoryHash() =>
    r'b4da9ba0e934ceab18e998cc054808cefca8402d';

/// The active household's shopping items, newest first, kept live. Emits an
/// empty list while the user has no household.

@ProviderFor(shoppingItems)
final shoppingItemsProvider = ShoppingItemsProvider._();

/// The active household's shopping items, newest first, kept live. Emits an
/// empty list while the user has no household.

final class ShoppingItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ShoppingItem>>,
          List<ShoppingItem>,
          Stream<List<ShoppingItem>>
        >
    with
        $FutureModifier<List<ShoppingItem>>,
        $StreamProvider<List<ShoppingItem>> {
  /// The active household's shopping items, newest first, kept live. Emits an
  /// empty list while the user has no household.
  ShoppingItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shoppingItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shoppingItemsHash();

  @$internal
  @override
  $StreamProviderElement<List<ShoppingItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ShoppingItem>> create(Ref ref) {
    return shoppingItems(ref);
  }
}

String _$shoppingItemsHash() => r'b449088eec19ff734b20ee7dab93b7ddd4285e2c';

/// Shopping items joined with their category, open items before checked ones.
/// Every display provider derives from this single source. The category
/// taxonomy is household-wide, so it is reused from the inventory providers.

@ProviderFor(resolvedShoppingItems)
final resolvedShoppingItemsProvider = ResolvedShoppingItemsProvider._();

/// Shopping items joined with their category, open items before checked ones.
/// Every display provider derives from this single source. The category
/// taxonomy is household-wide, so it is reused from the inventory providers.

final class ResolvedShoppingItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ResolvedShoppingItem>>,
          List<ResolvedShoppingItem>,
          FutureOr<List<ResolvedShoppingItem>>
        >
    with
        $FutureModifier<List<ResolvedShoppingItem>>,
        $FutureProvider<List<ResolvedShoppingItem>> {
  /// Shopping items joined with their category, open items before checked ones.
  /// Every display provider derives from this single source. The category
  /// taxonomy is household-wide, so it is reused from the inventory providers.
  ResolvedShoppingItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'resolvedShoppingItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$resolvedShoppingItemsHash();

  @$internal
  @override
  $FutureProviderElement<List<ResolvedShoppingItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ResolvedShoppingItem>> create(Ref ref) {
    return resolvedShoppingItems(ref);
  }
}

String _$resolvedShoppingItemsHash() =>
    r'b0a38bcde6c09cea4aed2e44d26ced52ace3dc73';

/// How many items are still open (not yet bought) — the header subtitle count.

@ProviderFor(shoppingOpenCount)
final shoppingOpenCountProvider = ShoppingOpenCountProvider._();

/// How many items are still open (not yet bought) — the header subtitle count.

final class ShoppingOpenCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  /// How many items are still open (not yet bought) — the header subtitle count.
  ShoppingOpenCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shoppingOpenCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shoppingOpenCountHash();

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    return shoppingOpenCount(ref);
  }
}

String _$shoppingOpenCountHash() => r'56ce5a21b35ab0fe30199c0289048cda21127b02';

/// The distinct categories present on the current list, ordered by name — the
/// source for the filter chips (only categories that actually appear).

@ProviderFor(shoppingFilterCategories)
final shoppingFilterCategoriesProvider = ShoppingFilterCategoriesProvider._();

/// The distinct categories present on the current list, ordered by name — the
/// source for the filter chips (only categories that actually appear).

final class ShoppingFilterCategoriesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          FutureOr<List<Category>>
        >
    with $FutureModifier<List<Category>>, $FutureProvider<List<Category>> {
  /// The distinct categories present on the current list, ordered by name — the
  /// source for the filter chips (only categories that actually appear).
  ShoppingFilterCategoriesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shoppingFilterCategoriesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shoppingFilterCategoriesHash();

  @$internal
  @override
  $FutureProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Category>> create(Ref ref) {
    return shoppingFilterCategories(ref);
  }
}

String _$shoppingFilterCategoriesHash() =>
    r'e2765cd17991cff4b18492d2bd7c33274d7798d4';

/// Drives add/edit/check/delete/clear for shopping items with loading/error
/// state. The list itself refreshes through the realtime [shoppingItemsProvider]
/// stream, so a mutation never needs a manual refresh — the stream re-emits.

@ProviderFor(ShoppingListController)
final shoppingListControllerProvider = ShoppingListControllerProvider._();

/// Drives add/edit/check/delete/clear for shopping items with loading/error
/// state. The list itself refreshes through the realtime [shoppingItemsProvider]
/// stream, so a mutation never needs a manual refresh — the stream re-emits.
final class ShoppingListControllerProvider
    extends $AsyncNotifierProvider<ShoppingListController, void> {
  /// Drives add/edit/check/delete/clear for shopping items with loading/error
  /// state. The list itself refreshes through the realtime [shoppingItemsProvider]
  /// stream, so a mutation never needs a manual refresh — the stream re-emits.
  ShoppingListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shoppingListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shoppingListControllerHash();

  @$internal
  @override
  ShoppingListController create() => ShoppingListController();
}

String _$shoppingListControllerHash() =>
    r'9253801f108e202aa2d5adf7b0f145c56e750ed0';

/// Drives add/edit/check/delete/clear for shopping items with loading/error
/// state. The list itself refreshes through the realtime [shoppingItemsProvider]
/// stream, so a mutation never needs a manual refresh — the stream re-emits.

abstract class _$ShoppingListController extends $AsyncNotifier<void> {
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
