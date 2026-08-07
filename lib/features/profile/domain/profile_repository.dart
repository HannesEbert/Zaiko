import 'profile.dart';

/// Why a [ProfileRepository] operation failed.
///
/// Mapped from backend errors at the data boundary so the UI can show a
/// localized message instead of a raw `PostgrestException`.
enum ProfileFailureReason {
  /// The user is not allowed to read or write the target profile (RLS).
  notAllowed,

  /// Any other backend or network error.
  unknown,
}

/// Domain-level profile error with a [reason] and a user-presentable [message]
/// fallback. Keeps Supabase exceptions out of the UI layer.
class ProfileFailure implements Exception {
  const ProfileFailure(this.reason, this.message);

  /// The categorized cause, used to pick a localized message.
  final ProfileFailureReason reason;

  /// Human-readable reason, used when no specific localized message applies.
  final String message;

  @override
  String toString() => 'ProfileFailure(${reason.name}): $message';
}

/// Abstraction over profile storage.
///
/// The app depends on this interface, not on Supabase directly, so tests can
/// substitute a fake and the backend can be swapped without touching callers.
abstract interface class ProfileRepository {
  /// The signed-in user's id, or `null` if there is no session.
  String? get currentUserId;

  /// The signed-in user's email, or `null` if there is no session. Sourced from
  /// `auth.users`, not the profile row.
  String? get currentUserEmail;

  /// Loads the current user's profile, creating it if the signup trigger has
  /// not yet done so. Throws [ProfileFailure] on backend errors.
  Future<Profile> loadMyProfile();

  /// Updates the current user's display name and avatar. Passing a `null`
  /// [avatarPreset] clears it, reverting to the default avatar. Throws
  /// [ProfileFailure] on failure.
  Future<void> updateMyProfile({
    required String displayName,
    String? avatarPreset,
  });

  /// Updates the current user's app-language preference. A `null` [locale]
  /// clears it, reverting to following the system language. Throws
  /// [ProfileFailure] on failure.
  Future<void> updateMyLocale(String? locale);

  /// Updates the current user's dietary preferences: the ticked [allergens],
  /// [diets] and [dislikes] keys plus an optional free-text [note]. Throws
  /// [ProfileFailure] on failure.
  Future<void> updateMyDietaryPreferences({
    required List<String> allergens,
    required List<String> diets,
    required List<String> dislikes,
    String? note,
  });

  /// Loads the profiles for [userIds] (typically the caller's household
  /// members), so names and avatars resolve wherever a user id appears. Ids the
  /// caller may not read are simply absent from the result.
  Future<List<Profile>> loadProfiles(Iterable<String> userIds);
}
