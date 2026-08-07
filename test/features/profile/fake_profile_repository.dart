import 'package:zaiko/features/profile/domain/profile.dart';
import 'package:zaiko/features/profile/domain/profile_repository.dart';

/// In-memory [ProfileRepository] for tests: no Supabase, fully controllable.
///
/// Records call counts and the last update for verification, and lets tests
/// script failures via the `*Error` fields and the returned data via [profile]
/// and [others].
class FakeProfileRepository implements ProfileRepository {
  FakeProfileRepository({
    this.currentUserId = 'user-1',
    this.currentUserEmail = 'dev@zaiko.local',
  });

  @override
  String? currentUserId;

  @override
  String? currentUserEmail;

  /// The profile [loadMyProfile] returns; updated by [updateMyProfile].
  Profile? profile;

  /// Profiles [loadProfiles] resolves from, filtered by the requested ids.
  List<Profile> others = [];

  int loadCalls = 0;
  int updateCalls = 0;
  int loadProfilesCalls = 0;
  int localeCalls = 0;
  int dietaryCalls = 0;

  String? lastDisplayName;
  String? lastAvatarPreset;
  String? lastLocale;
  List<String>? lastAllergens;
  List<String>? lastDiets;
  List<String>? lastDislikes;
  String? lastNote;

  ProfileFailure? loadError;
  ProfileFailure? updateError;
  ProfileFailure? loadProfilesError;
  ProfileFailure? localeError;
  ProfileFailure? dietaryError;

  @override
  Future<Profile> loadMyProfile() async {
    loadCalls++;
    final error = loadError;
    if (error != null) throw error;
    return profile ??= Profile(
      id: currentUserId ?? 'user-1',
      displayName: 'Dev',
      createdAt: DateTime.utc(2026),
    );
  }

  @override
  Future<void> updateMyProfile({
    required String displayName,
    String? avatarPreset,
  }) async {
    updateCalls++;
    lastDisplayName = displayName;
    lastAvatarPreset = avatarPreset;
    final error = updateError;
    if (error != null) throw error;
    final current = profile;
    profile =
        (current ??
                Profile(
                  id: currentUserId ?? 'user-1',
                  displayName: displayName,
                  createdAt: DateTime.utc(2026),
                ))
            .copyWith(displayName: displayName, avatarPreset: avatarPreset);
  }

  @override
  Future<void> updateMyLocale(String? locale) async {
    localeCalls++;
    lastLocale = locale;
    final error = localeError;
    if (error != null) throw error;
    final current = profile;
    if (current != null) profile = current.copyWith(locale: locale);
  }

  @override
  Future<void> updateMyDietaryPreferences({
    required List<String> allergens,
    required List<String> diets,
    required List<String> dislikes,
    String? note,
  }) async {
    dietaryCalls++;
    lastAllergens = allergens;
    lastDiets = diets;
    lastDislikes = dislikes;
    lastNote = note;
    final error = dietaryError;
    if (error != null) throw error;
    final current = profile;
    if (current != null) {
      profile = current.copyWith(
        allergens: allergens,
        diets: diets,
        dislikes: dislikes,
        dietaryNote: note,
      );
    }
  }

  @override
  Future<List<Profile>> loadProfiles(Iterable<String> userIds) async {
    loadProfilesCalls++;
    final error = loadProfilesError;
    if (error != null) throw error;
    final ids = userIds.toSet();
    return others.where((p) => ids.contains(p.id)).toList();
  }
}
