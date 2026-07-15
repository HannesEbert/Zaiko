import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/auth_status.dart';

/// Outcome of a sign-up attempt.
///
/// When the Supabase project requires email confirmation, sign-up succeeds but
/// no session is created yet — the UI must tell the user to check their inbox.
enum SignUpOutcome {
  /// A session was established; the user is signed in.
  signedIn,

  /// The account was created but must be confirmed via email first.
  emailConfirmationRequired,
}

/// Domain-level authentication error with a user-presentable [message].
///
/// Keeps Supabase's [AuthException] out of the UI layer so the presentation
/// code never depends on the backend SDK.
class AuthFailure implements Exception {
  const AuthFailure(this.message);

  /// Human-readable reason, safe to show to the user.
  final String message;

  @override
  String toString() => 'AuthFailure: $message';
}

/// Abstraction over the authentication backend.
///
/// The app depends on this interface, not on Supabase directly, so tests can
/// substitute a fake and the backend can be swapped without touching callers.
abstract interface class AuthRepository {
  /// Whether a session currently exists, evaluated synchronously.
  AuthStatus get currentStatus;

  /// Emits whenever the authentication state changes (sign-in, sign-out,
  /// token refresh, restored session).
  Stream<AuthStatus> get statusChanges;

  /// Signs in with email and password. Throws [AuthFailure] on invalid
  /// credentials or network errors.
  Future<void> signInWithPassword({
    required String email,
    required String password,
  });

  /// Registers a new account. Returns whether the user is signed in or must
  /// confirm their email first. Throws [AuthFailure] on failure.
  Future<SignUpOutcome> signUp({
    required String email,
    required String password,
  });

  /// Ends the current session.
  Future<void> signOut();
}

/// [AuthRepository] backed by Supabase's GoTrue auth.
class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository([GoTrueClient? auth])
    : _auth = auth ?? Supabase.instance.client.auth;

  final GoTrueClient _auth;

  @override
  AuthStatus get currentStatus => _auth.currentSession == null
      ? AuthStatus.unauthenticated
      : AuthStatus.authenticated;

  @override
  Stream<AuthStatus> get statusChanges => _auth.onAuthStateChange.map(
    (state) => state.session == null
        ? AuthStatus.unauthenticated
        : AuthStatus.authenticated,
  );

  @override
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }

  @override
  Future<SignUpOutcome> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _auth.signUp(email: email, password: password);
      return response.session == null
          ? SignUpOutcome.emailConfirmationRequired
          : SignUpOutcome.signedIn;
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();
}
