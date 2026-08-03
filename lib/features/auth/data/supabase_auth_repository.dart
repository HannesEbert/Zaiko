import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/auth_repository.dart';
import '../domain/auth_status.dart';

/// Deep link Supabase embeds in the reset email; opening it re-enters the app
/// and triggers a [AuthChangeEvent.passwordRecovery] event. The scheme is
/// registered natively (iOS `Info.plist`, Android manifest) and allow-listed in
/// the Supabase project's redirect URLs.
const String _passwordResetRedirect = 'zaiko://reset-password';

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
  Stream<void> get passwordRecoveryEvents => _auth.onAuthStateChange
      .where((state) => state.event == AuthChangeEvent.passwordRecovery)
      .map((_) {});

  @override
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) => _mapErrors(
    () => _auth.signInWithPassword(email: email, password: password),
  );

  @override
  Future<SignUpOutcome> signUp({
    required String email,
    required String password,
  }) => _mapErrors(() async {
    final response = await _auth.signUp(email: email, password: password);
    return response.session == null
        ? SignUpOutcome.emailConfirmationRequired
        : SignUpOutcome.signedIn;
  });

  @override
  Future<void> sendPasswordResetEmail(String email) => _mapErrors(
    () =>
        _auth.resetPasswordForEmail(email, redirectTo: _passwordResetRedirect),
  );

  @override
  Future<void> updatePassword(String newPassword) =>
      _mapErrors(() => _auth.updateUser(UserAttributes(password: newPassword)));

  @override
  Future<void> signOut() => _auth.signOut();

  /// Runs [op], translating Supabase's [AuthException] into a domain
  /// [AuthFailure] so callers never see the backend SDK's exception type.
  Future<T> _mapErrors<T>(Future<T> Function() op) async {
    try {
      return await op();
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    }
  }
}
