import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/supabase_auth_repository.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_status.dart';

part 'auth_providers.g.dart';

/// The app's [AuthRepository]. Overridden with a fake in tests.
@riverpod
AuthRepository authRepository(Ref ref) => SupabaseAuthRepository();

/// Stream of authentication state changes from the repository.
@riverpod
Stream<AuthStatus> authStatusChanges(Ref ref) =>
    ref.watch(authRepositoryProvider).statusChanges;

/// Current [AuthStatus] the router's redirect guard reads.
///
/// Seeds from the synchronously available session ([AuthRepository.currentStatus])
/// so a restored session is honoured on the very first frame, then stays in sync
/// via [authStatusChangesProvider]. Replacing the placeholder provider keeps the
/// router unchanged — the guard still reads this one value.
@riverpod
AuthStatus authState(Ref ref) =>
    ref.watch(authStatusChangesProvider).value ??
    ref.watch(authRepositoryProvider).currentStatus;

/// Drives the login screen's async actions, exposing loading/error state.
///
/// Widgets watch this for the button spinner and error message; a successful
/// sign-in flows through [authStatusChangesProvider], so the router redirects
/// without any manual navigation here.
@riverpod
class LoginController extends _$LoginController {
  // Synchronous build → the initial state is `AsyncData`, not `AsyncLoading`,
  // so the form is enabled and interactive on the first frame.
  @override
  FutureOr<void> build() {}

  /// Signs in with email and password. Surfaces failures as [AsyncError].
  Future<void> signIn({required String email, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signInWithPassword(email: email, password: password),
    );
  }

  /// Registers a new account. Returns the [SignUpOutcome] on success (so the UI
  /// can prompt for email confirmation), or `null` if it failed — in which case
  /// the error is reflected in [state].
  Future<SignUpOutcome?> signUp({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    try {
      final outcome = await ref
          .read(authRepositoryProvider)
          .signUp(email: email, password: password);
      state = const AsyncData(null);
      return outcome;
    } on AuthFailure catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}

/// Emits when the user opens a password-recovery deep link.
@riverpod
Stream<void> passwordRecoveryEvents(Ref ref) =>
    ref.watch(authRepositoryProvider).passwordRecoveryEvents;

/// Whether a password-recovery flow is in progress.
///
/// Flips to `true` when a recovery deep link arrives (via
/// [passwordRecoveryEventsProvider]); the router reads this to route the
/// recovery session to the reset-password screen instead of home/onboarding.
/// [complete] clears it once the new password has been set.
@riverpod
class PasswordRecoveryActive extends _$PasswordRecoveryActive {
  @override
  bool build() {
    ref.listen(passwordRecoveryEventsProvider, (_, next) {
      if (next.hasValue) state = true;
    });
    return false;
  }

  /// Ends the recovery flow, letting the router redirect normally again.
  void complete() => state = false;
}

/// Drives the "forgot password" and "set new password" screens, exposing
/// loading/error state the same way [LoginController] does.
@riverpod
class PasswordResetController extends _$PasswordResetController {
  // Synchronous build → the initial state is `AsyncData`, so the form is
  // enabled on the first frame.
  @override
  FutureOr<void> build() {}

  /// Sends a reset email. Returns `true` on success so the page can confirm
  /// and pop; failures are reflected in [state].
  Future<bool> sendResetEmail(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).sendPasswordResetEmail(email),
    );
    return !state.hasError;
  }

  /// Sets a new password for the recovery session. On success it clears the
  /// recovery flag and signs the user out, so the router returns them to the
  /// login screen to sign in with the new password. Returns `true` on success.
  Future<bool> updatePassword(String newPassword) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).updatePassword(newPassword),
    );
    if (state.hasError) return false;
    ref.read(passwordRecoveryActiveProvider.notifier).complete();
    await ref.read(authRepositoryProvider).signOut();
    return true;
  }
}
