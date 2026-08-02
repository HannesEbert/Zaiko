import 'package:freezed_annotation/freezed_annotation.dart';

part 'household.freezed.dart';
part 'household.g.dart';

/// A household: the top of the ownership chain. Inventory items, shopping items
/// and (later) recipes belong to a household, and every member shares them.
///
/// A user belongs to at most one household (see ADR-0011).
@freezed
abstract class Household with _$Household {
  const factory Household({
    required String id,
    required String name,
    @JsonKey(name: 'created_at') required DateTime createdAt,

    /// The user who created the household. Kept for audit only; nulled out if
    /// that user's account is deleted, so it may be absent for old households.
    @JsonKey(name: 'created_by') String? createdBy,
  }) = _Household;

  factory Household.fromJson(Map<String, dynamic> json) =>
      _$HouseholdFromJson(json);
}
