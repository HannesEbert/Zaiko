// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Trivial provider that confirms the `riverpod_generator` pipeline works.
///
/// Returns an empty sample list for now; it is replaced by a real,
/// repository-backed provider once the data layer lands.

@ProviderFor(sampleFoods)
final sampleFoodsProvider = SampleFoodsProvider._();

/// Trivial provider that confirms the `riverpod_generator` pipeline works.
///
/// Returns an empty sample list for now; it is replaced by a real,
/// repository-backed provider once the data layer lands.

final class SampleFoodsProvider
    extends $FunctionalProvider<List<Food>, List<Food>, List<Food>>
    with $Provider<List<Food>> {
  /// Trivial provider that confirms the `riverpod_generator` pipeline works.
  ///
  /// Returns an empty sample list for now; it is replaced by a real,
  /// repository-backed provider once the data layer lands.
  SampleFoodsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sampleFoodsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sampleFoodsHash();

  @$internal
  @override
  $ProviderElement<List<Food>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Food> create(Ref ref) {
    return sampleFoods(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Food> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Food>>(value),
    );
  }
}

String _$sampleFoodsHash() => r'a47f1d2bbf745a97238915708259571fb1461255';
