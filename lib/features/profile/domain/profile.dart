import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// A user's profile: their display name and chosen avatar.
///
/// One profile per auth user (id shared with `auth.users`). The email lives in
/// `auth.users`, not here, so it is never part of this entity. [avatarPreset] is
/// a preset key resolved app-side; `null` renders the default colour+initial
/// avatar.
@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'avatar_preset') String? avatarPreset,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
