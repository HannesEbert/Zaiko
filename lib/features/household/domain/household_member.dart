import 'package:freezed_annotation/freezed_annotation.dart';

import 'household_role.dart';

part 'household_member.freezed.dart';
part 'household_member.g.dart';

/// A user's membership in a household, with their [role] and when they joined.
///
/// Identity beyond [userId] (display name, avatar) arrives with the `profiles`
/// table in a later feature; until then the UI marks the current user and shows
/// others generically by role.
@freezed
abstract class HouseholdMember with _$HouseholdMember {
  const factory HouseholdMember({
    @JsonKey(name: 'household_id') required String householdId,
    @JsonKey(name: 'user_id') required String userId,
    required HouseholdRole role,
    @JsonKey(name: 'joined_at') required DateTime joinedAt,
  }) = _HouseholdMember;

  factory HouseholdMember.fromJson(Map<String, dynamic> json) =>
      _$HouseholdMemberFromJson(json);
}
