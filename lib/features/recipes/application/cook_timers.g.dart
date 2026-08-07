// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cook_timers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Holds one manually started countdown per cook-mode step, keyed by step
/// index. Timers are [seed]ed from the recipe's per-step durations; steps the
/// user never touched read as [kInitialCookTimer].
///
/// Kept alive by the [CookModePage] for its whole lifetime, so a running timer
/// survives swiping between steps; on leaving the mode the page unmounts, this
/// autoDisposes, and [build]'s `onDispose` cancels every outstanding ticker.

@ProviderFor(CookTimers)
final cookTimersProvider = CookTimersProvider._();

/// Holds one manually started countdown per cook-mode step, keyed by step
/// index. Timers are [seed]ed from the recipe's per-step durations; steps the
/// user never touched read as [kInitialCookTimer].
///
/// Kept alive by the [CookModePage] for its whole lifetime, so a running timer
/// survives swiping between steps; on leaving the mode the page unmounts, this
/// autoDisposes, and [build]'s `onDispose` cancels every outstanding ticker.
final class CookTimersProvider
    extends $NotifierProvider<CookTimers, Map<int, CookTimer>> {
  /// Holds one manually started countdown per cook-mode step, keyed by step
  /// index. Timers are [seed]ed from the recipe's per-step durations; steps the
  /// user never touched read as [kInitialCookTimer].
  ///
  /// Kept alive by the [CookModePage] for its whole lifetime, so a running timer
  /// survives swiping between steps; on leaving the mode the page unmounts, this
  /// autoDisposes, and [build]'s `onDispose` cancels every outstanding ticker.
  CookTimersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cookTimersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cookTimersHash();

  @$internal
  @override
  CookTimers create() => CookTimers();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<int, CookTimer> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<int, CookTimer>>(value),
    );
  }
}

String _$cookTimersHash() => r'af9b2482e027a222c98a69e1c5d7f2f16b1a5db9';

/// Holds one manually started countdown per cook-mode step, keyed by step
/// index. Timers are [seed]ed from the recipe's per-step durations; steps the
/// user never touched read as [kInitialCookTimer].
///
/// Kept alive by the [CookModePage] for its whole lifetime, so a running timer
/// survives swiping between steps; on leaving the mode the page unmounts, this
/// autoDisposes, and [build]'s `onDispose` cancels every outstanding ticker.

abstract class _$CookTimers extends $Notifier<Map<int, CookTimer>> {
  Map<int, CookTimer> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<Map<int, CookTimer>, Map<int, CookTimer>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<int, CookTimer>, Map<int, CookTimer>>,
              Map<int, CookTimer>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
