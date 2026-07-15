import 'dart:async';

import 'package:zaiko/features/auth/data/auth_repository.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';

/// In-memory [AuthRepository] for tests: no Supabase, fully controllable.
///
/// Records call counts for verification and lets tests script failures via
/// [signInError]/[signUpError] and the sign-up result via [signUpOutcome].
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({AuthStatus initialStatus = AuthStatus.unauthenticated})
    : _status = initialStatus;

  AuthStatus _status;
  final StreamController<AuthStatus> _controller =
      StreamController<AuthStatus>.broadcast();

  int signInCalls = 0;
  int signUpCalls = 0;
  int signOutCalls = 0;

  /// When set, the next [signInWithPassword] throws this instead of succeeding.
  AuthFailure? signInError;

  /// When set, the next [signUp] throws this instead of succeeding.
  AuthFailure? signUpError;

  /// Result returned by a successful [signUp].
  SignUpOutcome signUpOutcome = SignUpOutcome.signedIn;

  /// Pushes a new status onto [statusChanges] and updates [currentStatus].
  void emit(AuthStatus status) {
    _status = status;
    _controller.add(status);
  }

  void dispose() => _controller.close();

  @override
  AuthStatus get currentStatus => _status;

  @override
  Stream<AuthStatus> get statusChanges => _controller.stream;

  @override
  Future<void> signInWithPassword({
    required String email,
    required String password,
  }) async {
    signInCalls++;
    final error = signInError;
    if (error != null) throw error;
    emit(AuthStatus.authenticated);
  }

  @override
  Future<SignUpOutcome> signUp({
    required String email,
    required String password,
  }) async {
    signUpCalls++;
    final error = signUpError;
    if (error != null) throw error;
    if (signUpOutcome == SignUpOutcome.signedIn) {
      emit(AuthStatus.authenticated);
    }
    return signUpOutcome;
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
    emit(AuthStatus.unauthenticated);
  }
}
