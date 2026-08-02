import 'dart:async';

import 'package:zaiko/features/household/domain/household.dart';
import 'package:zaiko/features/household/domain/household_member.dart';
import 'package:zaiko/features/household/domain/household_repository.dart';

/// In-memory [HouseholdRepository] for tests: no Supabase, fully controllable.
///
/// Records call counts for verification and lets tests script failures via the
/// `*Error` fields and the current household via [current].
class FakeHouseholdRepository implements HouseholdRepository {
  FakeHouseholdRepository({this.currentUserId = 'user-1'});

  @override
  String? currentUserId;

  /// The household [loadCurrentHousehold] returns; mutated by create/join/leave.
  Household? current;

  final StreamController<List<HouseholdMember>> _members =
      StreamController<List<HouseholdMember>>.broadcast();

  int createCalls = 0;
  int acceptCalls = 0;
  int inviteCalls = 0;
  int renameCalls = 0;
  int removeCalls = 0;
  int leaveCalls = 0;

  /// Codes passed to [acceptInvite], newest last.
  final List<String> acceptedCodes = [];

  /// Code returned by a successful [createInvite].
  String inviteCode = 'ABC123';

  HouseholdFailure? loadError;
  HouseholdFailure? createError;
  HouseholdFailure? acceptError;
  HouseholdFailure? inviteError;
  HouseholdFailure? renameError;
  HouseholdFailure? removeError;
  HouseholdFailure? leaveError;

  /// Pushes a roster onto [watchMembers].
  void emitMembers(List<HouseholdMember> members) => _members.add(members);

  void dispose() => _members.close();

  @override
  Future<Household?> loadCurrentHousehold() async {
    final error = loadError;
    if (error != null) throw error;
    return current;
  }

  @override
  Stream<List<HouseholdMember>> watchMembers(String householdId) =>
      _members.stream;

  @override
  Future<Household> createHousehold(String name) async {
    createCalls++;
    final error = createError;
    if (error != null) throw error;
    final household = Household(
      id: 'hh-1',
      name: name,
      createdAt: DateTime.utc(2026),
      createdBy: currentUserId,
    );
    current = household;
    return household;
  }

  @override
  Future<void> renameHousehold({
    required String householdId,
    required String name,
  }) async {
    renameCalls++;
    final error = renameError;
    if (error != null) throw error;
    current = current?.copyWith(name: name);
  }

  @override
  Future<String> createInvite(String householdId) async {
    inviteCalls++;
    final error = inviteError;
    if (error != null) throw error;
    return inviteCode;
  }

  @override
  Future<Household> acceptInvite(String code) async {
    acceptCalls++;
    acceptedCodes.add(code);
    final error = acceptError;
    if (error != null) throw error;
    final household = Household(
      id: 'hh-join',
      name: 'Joined',
      createdAt: DateTime.utc(2026),
    );
    current = household;
    return household;
  }

  @override
  Future<void> removeMember({
    required String householdId,
    required String userId,
  }) async {
    removeCalls++;
    final error = removeError;
    if (error != null) throw error;
  }

  @override
  Future<void> leaveHousehold(String householdId) async {
    leaveCalls++;
    final error = leaveError;
    if (error != null) throw error;
    current = null;
  }
}
