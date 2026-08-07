import 'dart:async';

import 'package:flutter/widgets.dart' show Locale;
import 'package:package_info_plus/package_info_plus.dart';
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

/// The app language derived from the current user's profile, or `null` to
/// follow the system.
///
/// Feeds `MaterialApp.locale`: mapping the stored `'de'`/`'en'` code to a
/// [Locale] (and anything else, including signed-out `null`, to `null`) means a
/// saved-then-invalidated profile flips the UI language without any extra
/// plumbing.
@riverpod
Locale? appLocale(Ref ref) {
  final code = ref.watch(myProfileProvider).value?.locale;
  return switch (code) {
    'de' => const Locale('de'),
    'en' => const Locale('en'),
    _ => null,
  };
}

/// The running app's version string (e.g. `0.1.0`), read from the platform
/// bundle so the displayed version always matches the build.
@riverpod
Future<String> appVersion(Ref ref) async {
  final info = await PackageInfo.fromPlatform();
  return info.version;
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

/// Persists the app-language setting, refreshing [myProfileProvider] (and thus
/// [appLocaleProvider]) so the UI switches language immediately on success.
@riverpod
class LocaleSettingController extends _$LocaleSettingController {
  @override
  FutureOr<void> build() {}

  /// Saves the language [locale] (`null` follows the system). Returns whether
  /// it succeeded.
  Future<bool> setLocale(String? locale) async {
    state = const AsyncLoading();
    try {
      await ref.read(profileRepositoryProvider).updateMyLocale(locale);
      ref.invalidate(myProfileProvider);
      state = const AsyncData(null);
      return true;
    } on ProfileFailure catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

/// Persists the expiry-reminder settings, refreshing [myProfileProvider] on
/// success.
///
/// The `invalidate` is the coupling that makes the reminder scheduler
/// recompute: it watches [myProfileProvider], so a saved setting reschedules
/// the notifications without this controller knowing the scheduler exists.
@riverpod
class ReminderSettingsController extends _$ReminderSettingsController {
  @override
  FutureOr<void> build() {}

  /// Saves whether reminders are [enabled], the [leadDays] warning window and
  /// the daily [reminderTime] (`'HH:mm'`). Returns whether it succeeded.
  Future<bool> save({
    required bool enabled,
    required int leadDays,
    required String reminderTime,
  }) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(profileRepositoryProvider)
          .updateMyReminderSettings(
            enabled: enabled,
            leadDays: leadDays,
            reminderTime: reminderTime,
          );
      ref.invalidate(myProfileProvider);
      state = const AsyncData(null);
      return true;
    } on ProfileFailure catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

/// Drives the dietary-preferences screen's save action with loading/error
/// state, refreshing [myProfileProvider] on success.
@riverpod
class DietaryPreferencesController extends _$DietaryPreferencesController {
  @override
  FutureOr<void> build() {}

  /// Saves the ticked preference keys and free-text [note]. Returns whether it
  /// succeeded.
  Future<bool> save({
    required List<String> allergens,
    required List<String> diets,
    required List<String> dislikes,
    required String? note,
  }) async {
    state = const AsyncLoading();
    try {
      await ref
          .read(profileRepositoryProvider)
          .updateMyDietaryPreferences(
            allergens: allergens,
            diets: diets,
            dislikes: dislikes,
            note: note,
          );
      ref.invalidate(myProfileProvider);
      state = const AsyncData(null);
      return true;
    } on ProfileFailure catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}
