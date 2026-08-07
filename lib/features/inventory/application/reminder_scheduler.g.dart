// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_scheduler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Keeps the OS's scheduled expiry reminders in sync with the inventory and the
/// user's reminder settings.
///
/// It watches [myProfileProvider] and [inventoryItemsProvider], so `build`
/// re-runs on every relevant change (app start, a saved setting, an inventory
/// edit). Each run clears the whole expiry id block and reschedules from the
/// pure [planExpiryReminders] plan — a full recompute, since iOS bakes a
/// notification's content at schedule time and cannot recompute at fire time.
///
/// Kept alive and activated once from the app root; it renders nothing.

@ProviderFor(ReminderScheduler)
final reminderSchedulerProvider = ReminderSchedulerProvider._();

/// Keeps the OS's scheduled expiry reminders in sync with the inventory and the
/// user's reminder settings.
///
/// It watches [myProfileProvider] and [inventoryItemsProvider], so `build`
/// re-runs on every relevant change (app start, a saved setting, an inventory
/// edit). Each run clears the whole expiry id block and reschedules from the
/// pure [planExpiryReminders] plan — a full recompute, since iOS bakes a
/// notification's content at schedule time and cannot recompute at fire time.
///
/// Kept alive and activated once from the app root; it renders nothing.
final class ReminderSchedulerProvider
    extends $AsyncNotifierProvider<ReminderScheduler, void> {
  /// Keeps the OS's scheduled expiry reminders in sync with the inventory and the
  /// user's reminder settings.
  ///
  /// It watches [myProfileProvider] and [inventoryItemsProvider], so `build`
  /// re-runs on every relevant change (app start, a saved setting, an inventory
  /// edit). Each run clears the whole expiry id block and reschedules from the
  /// pure [planExpiryReminders] plan — a full recompute, since iOS bakes a
  /// notification's content at schedule time and cannot recompute at fire time.
  ///
  /// Kept alive and activated once from the app root; it renders nothing.
  ReminderSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderSchedulerHash();

  @$internal
  @override
  ReminderScheduler create() => ReminderScheduler();
}

String _$reminderSchedulerHash() => r'ae98592f170f2c5fc4d5d8fb2eb52b291efd1d6d';

/// Keeps the OS's scheduled expiry reminders in sync with the inventory and the
/// user's reminder settings.
///
/// It watches [myProfileProvider] and [inventoryItemsProvider], so `build`
/// re-runs on every relevant change (app start, a saved setting, an inventory
/// edit). Each run clears the whole expiry id block and reschedules from the
/// pure [planExpiryReminders] plan — a full recompute, since iOS bakes a
/// notification's content at schedule time and cannot recompute at fire time.
///
/// Kept alive and activated once from the app root; it renders nothing.

abstract class _$ReminderScheduler extends $AsyncNotifier<void> {
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
