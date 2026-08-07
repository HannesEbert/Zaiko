import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/profile.dart';
import '../domain/profile_repository.dart';

/// [ProfileRepository] backed by Supabase Postgres.
///
/// Reads are gated by RLS (own profile plus household co-members). Every backend
/// exception is translated to a [ProfileFailure] so callers never see a raw
/// `PostgrestException`.
class SupabaseProfileRepository implements ProfileRepository {
  SupabaseProfileRepository([SupabaseClient? client])
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  String? get currentUserId => _client.auth.currentUser?.id;

  @override
  String? get currentUserEmail => _client.auth.currentUser?.email;

  @override
  Future<Profile> loadMyProfile() async {
    final uid = _requireUserId();
    try {
      final row = await _client
          .from('profiles')
          .select()
          .eq('id', uid)
          .maybeSingle();
      if (row != null) return Profile.fromJson(row);

      // The signup trigger should have created the row; recover if it is
      // missing (e.g. a session predating the profiles migration).
      final inserted = await _client
          .from('profiles')
          .insert({'id': uid, 'display_name': _defaultDisplayName()})
          .select()
          .single();
      return Profile.fromJson(inserted);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> updateMyProfile({
    required String displayName,
    String? avatarPreset,
  }) async {
    final uid = _requireUserId();
    try {
      await _client
          .from('profiles')
          .update({'display_name': displayName, 'avatar_preset': avatarPreset})
          .eq('id', uid);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> updateMyLocale(String? locale) async {
    final uid = _requireUserId();
    try {
      await _client.from('profiles').update({'locale': locale}).eq('id', uid);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> updateMyDietaryPreferences({
    required List<String> allergens,
    required List<String> diets,
    required List<String> dislikes,
    String? note,
  }) async {
    final uid = _requireUserId();
    try {
      await _client
          .from('profiles')
          .update({
            'allergens': allergens,
            'diets': diets,
            'dislikes': dislikes,
            'dietary_note': note,
          })
          .eq('id', uid);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<List<Profile>> loadProfiles(Iterable<String> userIds) async {
    final ids = userIds.toList();
    if (ids.isEmpty) return const [];
    try {
      final rows = await _client.from('profiles').select().inFilter('id', ids);
      return rows.map(Profile.fromJson).toList();
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  /// Email local part, the same default the signup trigger uses.
  String _defaultDisplayName() {
    final email = currentUserEmail;
    if (email == null || email.isEmpty) return 'User';
    return email.split('@').first;
  }

  String _requireUserId() {
    final uid = currentUserId;
    if (uid == null) {
      throw const ProfileFailure(
        ProfileFailureReason.unknown,
        'No authenticated user.',
      );
    }
    return uid;
  }

  ProfileFailure _mapError(PostgrestException e) {
    final reason = switch (e.code) {
      '42501' => ProfileFailureReason.notAllowed,
      _ => ProfileFailureReason.unknown,
    };
    return ProfileFailure(reason, e.message);
  }
}
