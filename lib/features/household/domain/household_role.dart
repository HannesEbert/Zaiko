import 'package:json_annotation/json_annotation.dart';

/// A member's role within a household.
///
/// Persisted as a stable string (`owner`/`member`) so the enum can be reordered
/// without breaking stored data — the values mirror the `role` check constraint
/// on `household_members`.
enum HouseholdRole {
  /// Can invite members, remove them, and rename the household.
  @JsonValue('owner')
  owner,

  /// Can view the household and leave it.
  @JsonValue('member')
  member,
}
