import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/auth_status.dart';

part 'auth_providers.g.dart';

/// Placeholder authentication state.
///
/// Always reports [AuthStatus.unauthenticated] for now; the router's redirect
/// already guards on it, so wiring in real Supabase auth later is a matter of
/// replacing this provider's body — no router changes required.
@riverpod
AuthStatus authState(Ref ref) => AuthStatus.unauthenticated;
