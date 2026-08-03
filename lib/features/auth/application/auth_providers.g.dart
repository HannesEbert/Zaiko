// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's [AuthRepository]. Overridden with a fake in tests.

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

/// The app's [AuthRepository]. Overridden with a fake in tests.

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  /// The app's [AuthRepository]. Overridden with a fake in tests.
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'bc15bbdb628da40420c2f4da00f826675e52fd29';

/// Stream of authentication state changes from the repository.

@ProviderFor(authStatusChanges)
final authStatusChangesProvider = AuthStatusChangesProvider._();

/// Stream of authentication state changes from the repository.

final class AuthStatusChangesProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthStatus>,
          AuthStatus,
          Stream<AuthStatus>
        >
    with $FutureModifier<AuthStatus>, $StreamProvider<AuthStatus> {
  /// Stream of authentication state changes from the repository.
  AuthStatusChangesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStatusChangesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStatusChangesHash();

  @$internal
  @override
  $StreamProviderElement<AuthStatus> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AuthStatus> create(Ref ref) {
    return authStatusChanges(ref);
  }
}

String _$authStatusChangesHash() => r'07a5e1870589bac070725deed99b1a1efcf4d945';

/// Current [AuthStatus] the router's redirect guard reads.
///
/// Seeds from the synchronously available session ([AuthRepository.currentStatus])
/// so a restored session is honoured on the very first frame, then stays in sync
/// via [authStatusChangesProvider]. Replacing the placeholder provider keeps the
/// router unchanged — the guard still reads this one value.

@ProviderFor(authState)
final authStateProvider = AuthStateProvider._();

/// Current [AuthStatus] the router's redirect guard reads.
///
/// Seeds from the synchronously available session ([AuthRepository.currentStatus])
/// so a restored session is honoured on the very first frame, then stays in sync
/// via [authStatusChangesProvider]. Replacing the placeholder provider keeps the
/// router unchanged — the guard still reads this one value.

final class AuthStateProvider
    extends $FunctionalProvider<AuthStatus, AuthStatus, AuthStatus>
    with $Provider<AuthStatus> {
  /// Current [AuthStatus] the router's redirect guard reads.
  ///
  /// Seeds from the synchronously available session ([AuthRepository.currentStatus])
  /// so a restored session is honoured on the very first frame, then stays in sync
  /// via [authStatusChangesProvider]. Replacing the placeholder provider keeps the
  /// router unchanged — the guard still reads this one value.
  AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  $ProviderElement<AuthStatus> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthStatus create(Ref ref) {
    return authState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthStatus>(value),
    );
  }
}

String _$authStateHash() => r'bd9037d40560aa2a475deb25d2168ba0a463a355';

/// Drives the login screen's async actions, exposing loading/error state.
///
/// Widgets watch this for the button spinner and error message; a successful
/// sign-in flows through [authStatusChangesProvider], so the router redirects
/// without any manual navigation here.

@ProviderFor(LoginController)
final loginControllerProvider = LoginControllerProvider._();

/// Drives the login screen's async actions, exposing loading/error state.
///
/// Widgets watch this for the button spinner and error message; a successful
/// sign-in flows through [authStatusChangesProvider], so the router redirects
/// without any manual navigation here.
final class LoginControllerProvider
    extends $AsyncNotifierProvider<LoginController, void> {
  /// Drives the login screen's async actions, exposing loading/error state.
  ///
  /// Widgets watch this for the button spinner and error message; a successful
  /// sign-in flows through [authStatusChangesProvider], so the router redirects
  /// without any manual navigation here.
  LoginControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loginControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();
}

String _$loginControllerHash() => r'0d9a02076569e9724dfa98dd37c0d011e79ea433';

/// Drives the login screen's async actions, exposing loading/error state.
///
/// Widgets watch this for the button spinner and error message; a successful
/// sign-in flows through [authStatusChangesProvider], so the router redirects
/// without any manual navigation here.

abstract class _$LoginController extends $AsyncNotifier<void> {
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

/// Emits when the user opens a password-recovery deep link.

@ProviderFor(passwordRecoveryEvents)
final passwordRecoveryEventsProvider = PasswordRecoveryEventsProvider._();

/// Emits when the user opens a password-recovery deep link.

final class PasswordRecoveryEventsProvider
    extends $FunctionalProvider<AsyncValue<void>, void, Stream<void>>
    with $FutureModifier<void>, $StreamProvider<void> {
  /// Emits when the user opens a password-recovery deep link.
  PasswordRecoveryEventsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passwordRecoveryEventsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passwordRecoveryEventsHash();

  @$internal
  @override
  $StreamProviderElement<void> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<void> create(Ref ref) {
    return passwordRecoveryEvents(ref);
  }
}

String _$passwordRecoveryEventsHash() =>
    r'531bde3f7df567631bfe4abe8803422a93a07210';

/// Whether a password-recovery flow is in progress.
///
/// Flips to `true` when a recovery deep link arrives (via
/// [passwordRecoveryEventsProvider]); the router reads this to route the
/// recovery session to the reset-password screen instead of home/onboarding.
/// [complete] clears it once the new password has been set.

@ProviderFor(PasswordRecoveryActive)
final passwordRecoveryActiveProvider = PasswordRecoveryActiveProvider._();

/// Whether a password-recovery flow is in progress.
///
/// Flips to `true` when a recovery deep link arrives (via
/// [passwordRecoveryEventsProvider]); the router reads this to route the
/// recovery session to the reset-password screen instead of home/onboarding.
/// [complete] clears it once the new password has been set.
final class PasswordRecoveryActiveProvider
    extends $NotifierProvider<PasswordRecoveryActive, bool> {
  /// Whether a password-recovery flow is in progress.
  ///
  /// Flips to `true` when a recovery deep link arrives (via
  /// [passwordRecoveryEventsProvider]); the router reads this to route the
  /// recovery session to the reset-password screen instead of home/onboarding.
  /// [complete] clears it once the new password has been set.
  PasswordRecoveryActiveProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passwordRecoveryActiveProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passwordRecoveryActiveHash();

  @$internal
  @override
  PasswordRecoveryActive create() => PasswordRecoveryActive();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$passwordRecoveryActiveHash() =>
    r'3fe090532dc9c5044b6e09196a39d5c90747970b';

/// Whether a password-recovery flow is in progress.
///
/// Flips to `true` when a recovery deep link arrives (via
/// [passwordRecoveryEventsProvider]); the router reads this to route the
/// recovery session to the reset-password screen instead of home/onboarding.
/// [complete] clears it once the new password has been set.

abstract class _$PasswordRecoveryActive extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Drives the "forgot password" and "set new password" screens, exposing
/// loading/error state the same way [LoginController] does.

@ProviderFor(PasswordResetController)
final passwordResetControllerProvider = PasswordResetControllerProvider._();

/// Drives the "forgot password" and "set new password" screens, exposing
/// loading/error state the same way [LoginController] does.
final class PasswordResetControllerProvider
    extends $AsyncNotifierProvider<PasswordResetController, void> {
  /// Drives the "forgot password" and "set new password" screens, exposing
  /// loading/error state the same way [LoginController] does.
  PasswordResetControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passwordResetControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passwordResetControllerHash();

  @$internal
  @override
  PasswordResetController create() => PasswordResetController();
}

String _$passwordResetControllerHash() =>
    r'5e925821b4fdc09168a2e48bcd4f47fded58e7a6';

/// Drives the "forgot password" and "set new password" screens, exposing
/// loading/error state the same way [LoginController] does.

abstract class _$PasswordResetController extends $AsyncNotifier<void> {
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
