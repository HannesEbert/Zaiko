import 'auth_status.dart';

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
/// Keeps the backend SDK's `AuthException` out of the UI layer so the
/// presentation code never depends on Supabase.
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

  /// Emits whenever the user opens a password-recovery deep link and a
  /// recovery session is established, so the UI can prompt for a new password.
  Stream<void> get passwordRecoveryEvents;

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

  /// Sends a password-reset email containing a deep link back into the app.
  /// Throws [AuthFailure] on failure.
  Future<void> sendPasswordResetEmail(String email);

  /// Sets a new password for the current (recovery) session. Throws
  /// [AuthFailure] on failure.
  Future<void> updatePassword(String newPassword);

  /// Ends the current session.
  Future<void> signOut();
}
