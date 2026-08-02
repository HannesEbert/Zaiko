import 'household.dart';
import 'household_member.dart';

/// Why a [HouseholdRepository] operation failed.
///
/// Mapped from backend errors at the data boundary so the UI can show a
/// specific, localized message instead of a raw `PostgrestException`.
enum HouseholdFailureReason {
  /// The user already belongs to a household (one household per user).
  alreadyInHousehold,

  /// The invite code does not exist.
  inviteNotFound,

  /// The invite code has already been used.
  inviteUsed,

  /// The invite code has expired.
  inviteExpired,

  /// The user is not a member of the household they acted on.
  notMember,

  /// Any other backend or network error.
  unknown,
}

/// Domain-level household error with a [reason] and a user-presentable
/// [message] fallback. Keeps Supabase exceptions out of the UI layer.
class HouseholdFailure implements Exception {
  const HouseholdFailure(this.reason, this.message);

  /// The categorized cause, used to pick a localized message.
  final HouseholdFailureReason reason;

  /// Human-readable reason, used when no specific localized message applies.
  final String message;

  @override
  String toString() => 'HouseholdFailure(${reason.name}): $message';
}

/// Abstraction over household storage and membership.
///
/// The app depends on this interface, not on Supabase directly, so tests can
/// substitute a fake and the backend can be swapped without touching callers.
abstract interface class HouseholdRepository {
  /// The signed-in user's id, or `null` if there is no session. Used by the UI
  /// to mark the current member and gate owner-only actions.
  String? get currentUserId;

  /// The household the current user belongs to, or `null` if they have none.
  /// Throws [HouseholdFailure] on backend errors.
  Future<Household?> loadCurrentHousehold();

  /// Emits the household's member roster whenever it changes.
  Stream<List<HouseholdMember>> watchMembers(String householdId);

  /// Creates a household with [name], enrolling the caller as its owner, and
  /// returns it. Throws [HouseholdFailure] on failure.
  Future<Household> createHousehold(String name);

  /// Renames the household. Owner-only (enforced by RLS).
  Future<void> renameHousehold({
    required String householdId,
    required String name,
  });

  /// Creates a short-lived invite for the household and returns its code.
  Future<String> createInvite(String householdId);

  /// Consumes an invite [code], joining its household, and returns it. Throws
  /// [HouseholdFailure] with a specific [HouseholdFailureReason] when the code
  /// is invalid, used, expired, or the user already has a household.
  Future<Household> acceptInvite(String code);

  /// Removes another member from the household. Owner-only (enforced by RLS).
  Future<void> removeMember({
    required String householdId,
    required String userId,
  });

  /// Removes the current user from the household. If they were the last member
  /// the household is deleted; if they were the last owner, succession promotes
  /// the longest-standing member (both handled by a DB trigger).
  Future<void> leaveHousehold(String householdId);
}
