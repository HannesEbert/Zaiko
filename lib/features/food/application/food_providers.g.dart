// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Resolves products from Open Food Facts. Overridden with a fake in tests.

@ProviderFor(foodLookupRepository)
final foodLookupRepositoryProvider = FoodLookupRepositoryProvider._();

/// Resolves products from Open Food Facts. Overridden with a fake in tests.

final class FoodLookupRepositoryProvider
    extends
        $FunctionalProvider<
          FoodLookupRepository,
          FoodLookupRepository,
          FoodLookupRepository
        >
    with $Provider<FoodLookupRepository> {
  /// Resolves products from Open Food Facts. Overridden with a fake in tests.
  FoodLookupRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodLookupRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodLookupRepositoryHash();

  @$internal
  @override
  $ProviderElement<FoodLookupRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FoodLookupRepository create(Ref ref) {
    return foodLookupRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FoodLookupRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FoodLookupRepository>(value),
    );
  }
}

String _$foodLookupRepositoryHash() =>
    r'be5843738f4b0110b4989d73c8a37760328c3867';

/// The household-visible product catalog (`foods` table). Overridden in tests.

@ProviderFor(foodCatalogRepository)
final foodCatalogRepositoryProvider = FoodCatalogRepositoryProvider._();

/// The household-visible product catalog (`foods` table). Overridden in tests.

final class FoodCatalogRepositoryProvider
    extends
        $FunctionalProvider<
          FoodCatalogRepository,
          FoodCatalogRepository,
          FoodCatalogRepository
        >
    with $Provider<FoodCatalogRepository> {
  /// The household-visible product catalog (`foods` table). Overridden in tests.
  FoodCatalogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'foodCatalogRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$foodCatalogRepositoryHash();

  @$internal
  @override
  $ProviderElement<FoodCatalogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FoodCatalogRepository create(Ref ref) {
    return foodCatalogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FoodCatalogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FoodCatalogRepository>(value),
    );
  }
}

String _$foodCatalogRepositoryHash() =>
    r'd6c70f2ebb470efdf6f1111bb08a854a4bd600c8';

/// Orchestrates product resolution for the add flow: Open Food Facts lookup
/// plus caching into the shared `foods` catalog. Methods return the resolved
/// [Food] (or null / an empty list on a catalog miss) and throw [FoodFailure]
/// on transport errors, which the UI maps to a message.
///
/// Kept alive: it is only reached through `ref.read(...notifier)` and never
/// watched, so an autoDispose notifier could be disposed during the OFF request
/// and its post-`await` `ref.read` of the catalog repository would then throw.

@ProviderFor(ProductResolver)
final productResolverProvider = ProductResolverProvider._();

/// Orchestrates product resolution for the add flow: Open Food Facts lookup
/// plus caching into the shared `foods` catalog. Methods return the resolved
/// [Food] (or null / an empty list on a catalog miss) and throw [FoodFailure]
/// on transport errors, which the UI maps to a message.
///
/// Kept alive: it is only reached through `ref.read(...notifier)` and never
/// watched, so an autoDispose notifier could be disposed during the OFF request
/// and its post-`await` `ref.read` of the catalog repository would then throw.
final class ProductResolverProvider
    extends $NotifierProvider<ProductResolver, void> {
  /// Orchestrates product resolution for the add flow: Open Food Facts lookup
  /// plus caching into the shared `foods` catalog. Methods return the resolved
  /// [Food] (or null / an empty list on a catalog miss) and throw [FoodFailure]
  /// on transport errors, which the UI maps to a message.
  ///
  /// Kept alive: it is only reached through `ref.read(...notifier)` and never
  /// watched, so an autoDispose notifier could be disposed during the OFF request
  /// and its post-`await` `ref.read` of the catalog repository would then throw.
  ProductResolverProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productResolverProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productResolverHash();

  @$internal
  @override
  ProductResolver create() => ProductResolver();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$productResolverHash() => r'914801bc0906423dd4f33efb0c2eeb79d4fdbb2e';

/// Orchestrates product resolution for the add flow: Open Food Facts lookup
/// plus caching into the shared `foods` catalog. Methods return the resolved
/// [Food] (or null / an empty list on a catalog miss) and throw [FoodFailure]
/// on transport errors, which the UI maps to a message.
///
/// Kept alive: it is only reached through `ref.read(...notifier)` and never
/// watched, so an autoDispose notifier could be disposed during the OFF request
/// and its post-`await` `ref.read` of the catalog repository would then throw.

abstract class _$ProductResolver extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
