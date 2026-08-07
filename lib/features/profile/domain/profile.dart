import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';
part 'profile.g.dart';

/// A user's profile: display name, avatar and personal preferences.
///
/// One profile per auth user (id shared with `auth.users`). The email lives in
/// `auth.users`, not here, so it is never part of this entity. [avatarPreset] is
/// a preset key resolved app-side; `null` renders the default colour+initial
/// avatar.
///
/// [locale] is the chosen app-language code (`'de'`/`'en'`); `null` follows the
/// system. [allergens], [diets] and [dislikes] hold stable app-side preference
/// keys the user ticked, and [dietaryNote] is a free-text addition to the
/// dislikes.
///
/// [remindersEnabled], [reminderLeadDays] and [reminderTime] configure the
/// per-user local expiry reminders: whether they fire, how many days before a
/// best-before date to warn, and the daily `'HH:mm'` time-of-day for the digest.
@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    @JsonKey(name: 'display_name') required String displayName,
    @JsonKey(name: 'avatar_preset') String? avatarPreset,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    String? locale,
    @Default(<String>[]) List<String> allergens,
    @Default(<String>[]) List<String> diets,
    @Default(<String>[]) List<String> dislikes,
    @JsonKey(name: 'dietary_note') String? dietaryNote,
    @JsonKey(name: 'reminders_enabled') @Default(false) bool remindersEnabled,
    @JsonKey(name: 'reminder_lead_days') @Default(3) int reminderLeadDays,
    @JsonKey(name: 'reminder_time') @Default('20:00') String reminderTime,
  }) = _Profile;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);
}
