// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HouseholdMember _$HouseholdMemberFromJson(Map<String, dynamic> json) =>
    _HouseholdMember(
      householdId: json['household_id'] as String,
      userId: json['user_id'] as String,
      role: $enumDecode(_$HouseholdRoleEnumMap, json['role']),
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );

Map<String, dynamic> _$HouseholdMemberToJson(_HouseholdMember instance) =>
    <String, dynamic>{
      'household_id': instance.householdId,
      'user_id': instance.userId,
      'role': _$HouseholdRoleEnumMap[instance.role]!,
      'joined_at': instance.joinedAt.toIso8601String(),
    };

const _$HouseholdRoleEnumMap = {
  HouseholdRole.owner: 'owner',
  HouseholdRole.member: 'member',
};
