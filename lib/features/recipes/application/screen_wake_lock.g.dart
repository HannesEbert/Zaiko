// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_wake_lock.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's [ScreenWakeLock]. Overridden with a fake in tests.

@ProviderFor(screenWakeLock)
final screenWakeLockProvider = ScreenWakeLockProvider._();

/// The app's [ScreenWakeLock]. Overridden with a fake in tests.

final class ScreenWakeLockProvider
    extends $FunctionalProvider<ScreenWakeLock, ScreenWakeLock, ScreenWakeLock>
    with $Provider<ScreenWakeLock> {
  /// The app's [ScreenWakeLock]. Overridden with a fake in tests.
  ScreenWakeLockProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'screenWakeLockProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$screenWakeLockHash();

  @$internal
  @override
  $ProviderElement<ScreenWakeLock> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ScreenWakeLock create(Ref ref) {
    return screenWakeLock(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ScreenWakeLock value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ScreenWakeLock>(value),
    );
  }
}

String _$screenWakeLockHash() => r'35e84411612e2dd87872251306ba855b5f7ce9d5';
