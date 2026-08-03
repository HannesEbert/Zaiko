import 'dart:async';

import 'package:zaiko/features/auth/domain/auth_repository.dart';
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
  final StreamController<void> _recoveryController =
      StreamController<void>.broadcast();

  int signInCalls = 0;
  int signUpCalls = 0;
  int signOutCalls = 0;
  int sendResetCalls = 0;
  int updatePasswordCalls = 0;

  /// When set, the next [signInWithPassword] throws this instead of succeeding.
  AuthFailure? signInError;

  /// When set, the next [signUp] throws this instead of succeeding.
  AuthFailure? signUpError;

  /// When set, the next [sendPasswordResetEmail] throws this.
  AuthFailure? sendResetError;

  /// When set, the next [updatePassword] throws this.
  AuthFailure? updatePasswordError;

  /// Result returned by a successful [signUp].
  SignUpOutcome signUpOutcome = SignUpOutcome.signedIn;

  /// Pushes a new status onto [statusChanges] and updates [currentStatus].
  void emit(AuthStatus status) {
    _status = status;
    _controller.add(status);
  }

  /// Simulates the user opening a password-recovery deep link.
  void emitPasswordRecovery() => _recoveryController.add(null);

  void dispose() {
    _controller.close();
    _recoveryController.close();
  }

  @override
  AuthStatus get currentStatus => _status;

  @override
  Stream<AuthStatus> get statusChanges => _controller.stream;

  @override
  Stream<void> get passwordRecoveryEvents => _recoveryController.stream;

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
  Future<void> sendPasswordResetEmail(String email) async {
    sendResetCalls++;
    final error = sendResetError;
    if (error != null) throw error;
  }

  @override
  Future<void> updatePassword(String newPassword) async {
    updatePasswordCalls++;
    final error = updatePasswordError;
    if (error != null) throw error;
  }

  @override
  Future<void> signOut() async {
    signOutCalls++;
    emit(AuthStatus.unauthenticated);
  }
}
