import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/supabase_household_repository.dart';
import '../domain/household.dart';
import '../domain/household_member.dart';
import '../domain/household_repository.dart';

part 'households_providers.g.dart';

/// Whether the current user belongs to a household.
///
/// Drives the onboarding redirect. [unknown] while the first load is in flight
/// so the router does not bounce the user to onboarding before the answer is
/// known (which would flash the wrong screen on a restored session).
enum HouseholdMembership { unknown, none, joined }

/// The app's [HouseholdRepository]. Overridden with a fake in tests.
@riverpod
HouseholdRepository householdRepository(Ref ref) =>
    SupabaseHouseholdRepository();

/// The current user's household, or `null` if they have none. Re-fetched when
/// invalidated after a create/join/leave.
@riverpod
Future<Household?> currentHousehold(Ref ref) =>
    ref.watch(householdRepositoryProvider).loadCurrentHousehold();

/// Coarse membership state the router redirect reads synchronously.
@riverpod
HouseholdMembership householdMembership(Ref ref) {
  final household = ref.watch(currentHouseholdProvider);
  return switch (household) {
    AsyncData(:final value) =>
      value == null ? HouseholdMembership.none : HouseholdMembership.joined,
    // On a transient load error, don't force onboarding — stay [unknown].
    _ => HouseholdMembership.unknown,
  };
}

/// Live roster of the given household's members.
@riverpod
Stream<List<HouseholdMember>> householdMembers(Ref ref, String householdId) =>
    ref.watch(householdRepositoryProvider).watchMembers(householdId);

/// Invite code carried across a sign-in when an unauthenticated user opens a
/// join link. The onboarding screen reads it to pre-fill the join field.
@riverpod
class PendingInviteCode extends _$PendingInviteCode {
  @override
  String? build() => null;

  void set(String code) => state = code;
  void clear() => state = null;
}

/// Drives the onboarding screen's create/join actions with loading/error state.
///
/// A successful action invalidates [currentHouseholdProvider]; the resulting
/// membership change flows through the router redirect, so the screen never
/// navigates by hand.
@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  FutureOr<void> build() {}

  /// Creates a household named [name]. Returns whether it succeeded.
  Future<bool> createHousehold(String name) =>
      _run(() => ref.read(householdRepositoryProvider).createHousehold(name));

  /// Joins the household for invite [code]. Returns whether it succeeded.
  Future<bool> joinByCode(String code) =>
      _run(() => ref.read(householdRepositoryProvider).acceptInvite(code));

  Future<bool> _run(Future<Object?> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      ref.invalidate(currentHouseholdProvider);
      state = const AsyncData(null);
      return true;
    } on HouseholdFailure catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

/// Generates an invite code for a household and exposes it (plus loading/error)
/// so the UI can render the code and its QR.
@riverpod
class InviteController extends _$InviteController {
  @override
  FutureOr<String?> build() => null;

  /// Creates a fresh invite for [householdId], replacing any previous code.
  Future<void> createInvite(String householdId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(householdRepositoryProvider).createInvite(householdId),
    );
  }
}

/// Drives household management actions (rename, remove member, leave) with
/// loading/error state for the household page.
@riverpod
class HouseholdManagementController extends _$HouseholdManagementController {
  @override
  FutureOr<void> build() {}

  /// Renames the household. Returns whether it succeeded.
  Future<bool> rename({required String householdId, required String name}) =>
      _run(() async {
        await ref
            .read(householdRepositoryProvider)
            .renameHousehold(householdId: householdId, name: name);
        ref.invalidate(currentHouseholdProvider);
      });

  /// Removes another member. The live roster updates on its own.
  Future<bool> removeMember({
    required String householdId,
    required String userId,
  }) => _run(
    () => ref
        .read(householdRepositoryProvider)
        .removeMember(householdId: householdId, userId: userId),
  );

  /// Leaves the household. The membership change redirects to onboarding.
  Future<bool> leave(String householdId) => _run(() async {
    await ref.read(householdRepositoryProvider).leaveHousehold(householdId);
    ref.invalidate(currentHouseholdProvider);
  });

  Future<bool> _run(Future<void> Function() action) async {
    state = const AsyncLoading();
    try {
      await action();
      state = const AsyncData(null);
      return true;
    } on HouseholdFailure catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}
