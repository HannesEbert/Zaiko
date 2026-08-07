// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Profile {

 String get id;@JsonKey(name: 'display_name') String get displayName;@JsonKey(name: 'avatar_preset') String? get avatarPreset;@JsonKey(name: 'created_at') DateTime get createdAt; String? get locale; List<String> get allergens; List<String> get diets; List<String> get dislikes;@JsonKey(name: 'dietary_note') String? get dietaryNote;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarPreset, avatarPreset) || other.avatarPreset == avatarPreset)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.locale, locale) || other.locale == locale)&&const DeepCollectionEquality().equals(other.allergens, allergens)&&const DeepCollectionEquality().equals(other.diets, diets)&&const DeepCollectionEquality().equals(other.dislikes, dislikes)&&(identical(other.dietaryNote, dietaryNote) || other.dietaryNote == dietaryNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,avatarPreset,createdAt,locale,const DeepCollectionEquality().hash(allergens),const DeepCollectionEquality().hash(diets),const DeepCollectionEquality().hash(dislikes),dietaryNote);

@override
String toString() {
  return 'Profile(id: $id, displayName: $displayName, avatarPreset: $avatarPreset, createdAt: $createdAt, locale: $locale, allergens: $allergens, diets: $diets, dislikes: $dislikes, dietaryNote: $dietaryNote)';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'avatar_preset') String? avatarPreset,@JsonKey(name: 'created_at') DateTime createdAt, String? locale, List<String> allergens, List<String> diets, List<String> dislikes,@JsonKey(name: 'dietary_note') String? dietaryNote
});




}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? avatarPreset = freezed,Object? createdAt = null,Object? locale = freezed,Object? allergens = null,Object? diets = null,Object? dislikes = null,Object? dietaryNote = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarPreset: freezed == avatarPreset ? _self.avatarPreset : avatarPreset // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,allergens: null == allergens ? _self.allergens : allergens // ignore: cast_nullable_to_non_nullable
as List<String>,diets: null == diets ? _self.diets : diets // ignore: cast_nullable_to_non_nullable
as List<String>,dislikes: null == dislikes ? _self.dislikes : dislikes // ignore: cast_nullable_to_non_nullable
as List<String>,dietaryNote: freezed == dietaryNote ? _self.dietaryNote : dietaryNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Profile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Profile value)  $default,){
final _that = this;
switch (_that) {
case _Profile():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Profile value)?  $default,){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'avatar_preset')  String? avatarPreset, @JsonKey(name: 'created_at')  DateTime createdAt,  String? locale,  List<String> allergens,  List<String> diets,  List<String> dislikes, @JsonKey(name: 'dietary_note')  String? dietaryNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.displayName,_that.avatarPreset,_that.createdAt,_that.locale,_that.allergens,_that.diets,_that.dislikes,_that.dietaryNote);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'avatar_preset')  String? avatarPreset, @JsonKey(name: 'created_at')  DateTime createdAt,  String? locale,  List<String> allergens,  List<String> diets,  List<String> dislikes, @JsonKey(name: 'dietary_note')  String? dietaryNote)  $default,) {final _that = this;
switch (_that) {
case _Profile():
return $default(_that.id,_that.displayName,_that.avatarPreset,_that.createdAt,_that.locale,_that.allergens,_that.diets,_that.dislikes,_that.dietaryNote);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'display_name')  String displayName, @JsonKey(name: 'avatar_preset')  String? avatarPreset, @JsonKey(name: 'created_at')  DateTime createdAt,  String? locale,  List<String> allergens,  List<String> diets,  List<String> dislikes, @JsonKey(name: 'dietary_note')  String? dietaryNote)?  $default,) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.displayName,_that.avatarPreset,_that.createdAt,_that.locale,_that.allergens,_that.diets,_that.dislikes,_that.dietaryNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Profile implements Profile {
  const _Profile({required this.id, @JsonKey(name: 'display_name') required this.displayName, @JsonKey(name: 'avatar_preset') this.avatarPreset, @JsonKey(name: 'created_at') required this.createdAt, this.locale, final  List<String> allergens = const <String>[], final  List<String> diets = const <String>[], final  List<String> dislikes = const <String>[], @JsonKey(name: 'dietary_note') this.dietaryNote}): _allergens = allergens,_diets = diets,_dislikes = dislikes;
  factory _Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

@override final  String id;
@override@JsonKey(name: 'display_name') final  String displayName;
@override@JsonKey(name: 'avatar_preset') final  String? avatarPreset;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override final  String? locale;
 final  List<String> _allergens;
@override@JsonKey() List<String> get allergens {
  if (_allergens is EqualUnmodifiableListView) return _allergens;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allergens);
}

 final  List<String> _diets;
@override@JsonKey() List<String> get diets {
  if (_diets is EqualUnmodifiableListView) return _diets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_diets);
}

 final  List<String> _dislikes;
@override@JsonKey() List<String> get dislikes {
  if (_dislikes is EqualUnmodifiableListView) return _dislikes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dislikes);
}

@override@JsonKey(name: 'dietary_note') final  String? dietaryNote;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarPreset, avatarPreset) || other.avatarPreset == avatarPreset)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.locale, locale) || other.locale == locale)&&const DeepCollectionEquality().equals(other._allergens, _allergens)&&const DeepCollectionEquality().equals(other._diets, _diets)&&const DeepCollectionEquality().equals(other._dislikes, _dislikes)&&(identical(other.dietaryNote, dietaryNote) || other.dietaryNote == dietaryNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,avatarPreset,createdAt,locale,const DeepCollectionEquality().hash(_allergens),const DeepCollectionEquality().hash(_diets),const DeepCollectionEquality().hash(_dislikes),dietaryNote);

@override
String toString() {
  return 'Profile(id: $id, displayName: $displayName, avatarPreset: $avatarPreset, createdAt: $createdAt, locale: $locale, allergens: $allergens, diets: $diets, dislikes: $dislikes, dietaryNote: $dietaryNote)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'display_name') String displayName,@JsonKey(name: 'avatar_preset') String? avatarPreset,@JsonKey(name: 'created_at') DateTime createdAt, String? locale, List<String> allergens, List<String> diets, List<String> dislikes,@JsonKey(name: 'dietary_note') String? dietaryNote
});




}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? avatarPreset = freezed,Object? createdAt = null,Object? locale = freezed,Object? allergens = null,Object? diets = null,Object? dislikes = null,Object? dietaryNote = freezed,}) {
  return _then(_Profile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarPreset: freezed == avatarPreset ? _self.avatarPreset : avatarPreset // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,locale: freezed == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String?,allergens: null == allergens ? _self._allergens : allergens // ignore: cast_nullable_to_non_nullable
as List<String>,diets: null == diets ? _self._diets : diets // ignore: cast_nullable_to_non_nullable
as List<String>,dislikes: null == dislikes ? _self._dislikes : dislikes // ignore: cast_nullable_to_non_nullable
as List<String>,dietaryNote: freezed == dietaryNote ? _self.dietaryNote : dietaryNote // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
