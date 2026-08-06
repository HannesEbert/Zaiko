import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/application/auth_providers.dart';
import '../../auth/domain/auth_status.dart';
import '../../household/application/households_providers.dart';
import '../data/supabase_profile_repository.dart';
import '../domain/profile.dart';
import '../domain/profile_repository.dart';

part 'profile_providers.g.dart';

/// The app's [ProfileRepository]. Overridden with a fake in tests.
@riverpod
ProfileRepository profileRepository(Ref ref) => SupabaseProfileRepository();

/// The current user's profile, or `null` while signed out.
///
/// Gated on [authStateProvider] like [currentHouseholdProvider]: while signed
/// out there is nothing to load, so it resolves to `null` without touching the
/// backend and refetches the moment a session appears.
@riverpod
Future<Profile?> myProfile(Ref ref) {
  if (ref.watch(authStateProvider) != AuthStatus.authenticated) {
    return Future<Profile?>.value(null);
  }
  return ref.watch(profileRepositoryProvider).loadMyProfile();
}

/// The current user's email (from `auth.users`), or `null` while signed out.
///
/// Auth-gated and async like [myProfileProvider] so a repository that cannot
/// reach the backend degrades to an error/`null` rather than throwing into the
/// widget tree.
@riverpod
Future<String?> currentUserEmail(Ref ref) async {
  if (ref.watch(authStateProvider) != AuthStatus.authenticated) return null;
  return ref.watch(profileRepositoryProvider).currentUserEmail;
}

/// Profiles of the current household's members, keyed by user id.
///
/// Resolves display names and avatars wherever a user id appears ("who did
/// what"). Empty when the user has no household.
@riverpod
Future<Map<String, Profile>> householdMemberProfiles(Ref ref) async {
  final household = await ref.watch(currentHouseholdProvider.future);
  if (household == null) return const {};
  final members = await ref.watch(
    householdMembersProvider(household.id).future,
  );
  final profiles = await ref
      .watch(profileRepositoryProvider)
      .loadProfiles(members.map((m) => m.userId));
  return {for (final profile in profiles) profile.id: profile};
}

/// Drives the profile-edit screen's save action with loading/error state.
///
/// A successful save invalidates [myProfileProvider] (and the member map) so the
/// account card and overview refresh; the screen never navigates by hand.
@riverpod
class ProfileEditController extends _$ProfileEditController {
  @override
  FutureOr<void> build() {}

  /// Saves the display name and avatar. Returns whether it succeeded.
  Future<bool> save({
    required String displayName,
    required String? avatarPreset,
  }) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(profileRepositoryProvider)
          .updateMyProfile(
            displayName: displayName,
            avatarPreset: avatarPreset,
          );
      ref.invalidate(myProfileProvider);
      ref.invalidate(householdMemberProfilesProvider);
      state = const AsyncData(null);
      return true;
    } on ProfileFailure catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}
