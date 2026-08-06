import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

part 'screen_wake_lock.g.dart';

/// Keeps the device screen awake for as long as a screen needs it — used by the
/// cook mode so the recipe stays readable with the phone set aside.
///
/// Injected behind an interface (rather than calling [WakelockPlus] directly)
/// so widget tests can substitute a no-op and never touch the platform channel.
abstract interface class ScreenWakeLock {
  /// Prevents the screen from sleeping until [disable] is called.
  Future<void> enable();

  /// Releases the wake lock, letting the screen sleep normally again.
  Future<void> disable();
}

/// The production [ScreenWakeLock], backed by the `wakelock_plus` plugin.
class WakelockScreenWakeLock implements ScreenWakeLock {
  const WakelockScreenWakeLock();

  @override
  Future<void> enable() => WakelockPlus.enable();

  @override
  Future<void> disable() => WakelockPlus.disable();
}

/// The app's [ScreenWakeLock]. Overridden with a fake in tests.
@riverpod
ScreenWakeLock screenWakeLock(Ref ref) => const WakelockScreenWakeLock();
