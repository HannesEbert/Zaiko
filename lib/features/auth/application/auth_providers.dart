import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_repository.dart';
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
