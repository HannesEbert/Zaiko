import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/household.dart';
import '../domain/household_member.dart';
import '../domain/household_repository.dart';

/// [HouseholdRepository] backed by Supabase Postgres.
///
/// Reads are gated by RLS (a user only ever sees their own household), and the
/// two membership-changing paths that clients may not write directly — creating
/// an invite and joining one — go through the `create_household_invite` and
/// `accept_household_invite` RPCs. Every backend exception is translated to a
/// [HouseholdFailure] so callers never see a raw `PostgrestException`.
class SupabaseHouseholdRepository implements HouseholdRepository {
  SupabaseHouseholdRepository([SupabaseClient? client])
    : _client = client ?? Supabase.instance.client;

  final SupabaseClient _client;

  @override
  String? get currentUserId => _client.auth.currentUser?.id;

  @override
  Future<Household?> loadCurrentHousehold() async {
    try {
      // RLS narrows `households` to the caller's single household, if any.
      final row = await _client
          .from('households')
          .select()
          .limit(1)
          .maybeSingle();
      return row == null ? null : Household.fromJson(row);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Stream<List<HouseholdMember>> watchMembers(String householdId) => _client
      .from('household_members')
      .stream(primaryKey: ['household_id', 'user_id'])
      .eq('household_id', householdId)
      .order('joined_at')
      .map((rows) => rows.map(HouseholdMember.fromJson).toList());

  @override
  Future<Household> createHousehold(String name) async {
    final uid = _requireUserId();
    try {
      // The on_household_created trigger enrols the caller as owner and seeds
      // the default storage locations; read the row back once membership makes
      // it visible under RLS.
      await _client.from('households').insert({
        'name': name,
        'created_by': uid,
      });
      final household = await loadCurrentHousehold();
      if (household == null) {
        throw const HouseholdFailure(
          HouseholdFailureReason.unknown,
          'Household was created but could not be loaded.',
        );
      }
      return household;
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> renameHousehold({
    required String householdId,
    required String name,
  }) async {
    try {
      await _client
          .from('households')
          .update({'name': name})
          .eq('id', householdId);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<String> createInvite(String householdId) async {
    try {
      final code = await _client.rpc<String>(
        'create_household_invite',
        params: {'hid': householdId},
      );
      return code;
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<Household> acceptInvite(String code) async {
    try {
      final householdId = await _client.rpc<String>(
        'accept_household_invite',
        params: {'invite_code': code},
      );
      final row = await _client
          .from('households')
          .select()
          .eq('id', householdId)
          .single();
      return Household.fromJson(row);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> removeMember({
    required String householdId,
    required String userId,
  }) async {
    try {
      await _client
          .from('household_members')
          .delete()
          .eq('household_id', householdId)
          .eq('user_id', userId);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  @override
  Future<void> leaveHousehold(String householdId) async {
    final uid = _requireUserId();
    try {
      await _client
          .from('household_members')
          .delete()
          .eq('household_id', householdId)
          .eq('user_id', uid);
    } on PostgrestException catch (e) {
      throw _mapError(e);
    }
  }

  String _requireUserId() {
    final uid = currentUserId;
    if (uid == null) {
      throw const HouseholdFailure(
        HouseholdFailureReason.unknown,
        'No authenticated user.',
      );
    }
    return uid;
  }

  /// Translates a Postgres error into a categorized [HouseholdFailure] using the
  /// custom SQLSTATEs raised by the invite RPCs.
  HouseholdFailure _mapError(PostgrestException e) {
    final reason = switch (e.code) {
      'ZKH01' => HouseholdFailureReason.alreadyInHousehold,
      'ZKH02' => HouseholdFailureReason.inviteNotFound,
      'ZKH03' => HouseholdFailureReason.inviteUsed,
      'ZKH04' => HouseholdFailureReason.inviteExpired,
      '42501' => HouseholdFailureReason.notMember,
      _ => HouseholdFailureReason.unknown,
    };
    return HouseholdFailure(reason, e.message);
  }
}
