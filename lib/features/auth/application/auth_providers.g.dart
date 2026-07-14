// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Placeholder authentication state.
///
/// Always reports [AuthStatus.unauthenticated] for now; the router's redirect
/// already guards on it, so wiring in real Supabase auth later is a matter of
/// replacing this provider's body — no router changes required.

@ProviderFor(authState)
final authStateProvider = AuthStateProvider._();

/// Placeholder authentication state.
///
/// Always reports [AuthStatus.unauthenticated] for now; the router's redirect
/// already guards on it, so wiring in real Supabase auth later is a matter of
/// replacing this provider's body — no router changes required.

final class AuthStateProvider
    extends $FunctionalProvider<AuthStatus, AuthStatus, AuthStatus>
    with $Provider<AuthStatus> {
  /// Placeholder authentication state.
  ///
  /// Always reports [AuthStatus.unauthenticated] for now; the router's redirect
  /// already guards on it, so wiring in real Supabase auth later is a matter of
  /// replacing this provider's body — no router changes required.
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

String _$authStateHash() => r'f29ded214736b8cd56711f3ad2d6f548dc1ab8ea';
