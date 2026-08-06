// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's [ProfileRepository]. Overridden with a fake in tests.

@ProviderFor(profileRepository)
final profileRepositoryProvider = ProfileRepositoryProvider._();

/// The app's [ProfileRepository]. Overridden with a fake in tests.

final class ProfileRepositoryProvider
    extends
        $FunctionalProvider<
          ProfileRepository,
          ProfileRepository,
          ProfileRepository
        >
    with $Provider<ProfileRepository> {
  /// The app's [ProfileRepository]. Overridden with a fake in tests.
  ProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProfileRepository create(Ref ref) {
    return profileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProfileRepository>(value),
    );
  }
}

String _$profileRepositoryHash() => r'c03ca8ef417fbca0a61f5a623a29f11427772f41';

/// The current user's profile, or `null` while signed out.
///
/// Gated on [authStateProvider] like [currentHouseholdProvider]: while signed
/// out there is nothing to load, so it resolves to `null` without touching the
/// backend and refetches the moment a session appears.

@ProviderFor(myProfile)
final myProfileProvider = MyProfileProvider._();

/// The current user's profile, or `null` while signed out.
///
/// Gated on [authStateProvider] like [currentHouseholdProvider]: while signed
/// out there is nothing to load, so it resolves to `null` without touching the
/// backend and refetches the moment a session appears.

final class MyProfileProvider
    extends
        $FunctionalProvider<AsyncValue<Profile?>, Profile?, FutureOr<Profile?>>
    with $FutureModifier<Profile?>, $FutureProvider<Profile?> {
  /// The current user's profile, or `null` while signed out.
  ///
  /// Gated on [authStateProvider] like [currentHouseholdProvider]: while signed
  /// out there is nothing to load, so it resolves to `null` without touching the
  /// backend and refetches the moment a session appears.
  MyProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myProfileProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myProfileHash();

  @$internal
  @override
  $FutureProviderElement<Profile?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Profile?> create(Ref ref) {
    return myProfile(ref);
  }
}

String _$myProfileHash() => r'83642b39b7cdbc43f82407f930fea610d5439856';

/// The current user's email (from `auth.users`), or `null` while signed out.
///
/// Auth-gated and async like [myProfileProvider] so a repository that cannot
/// reach the backend degrades to an error/`null` rather than throwing into the
/// widget tree.

@ProviderFor(currentUserEmail)
final currentUserEmailProvider = CurrentUserEmailProvider._();

/// The current user's email (from `auth.users`), or `null` while signed out.
///
/// Auth-gated and async like [myProfileProvider] so a repository that cannot
/// reach the backend degrades to an error/`null` rather than throwing into the
/// widget tree.

final class CurrentUserEmailProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// The current user's email (from `auth.users`), or `null` while signed out.
  ///
  /// Auth-gated and async like [myProfileProvider] so a repository that cannot
  /// reach the backend degrades to an error/`null` rather than throwing into the
  /// widget tree.
  CurrentUserEmailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserEmailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserEmailHash();

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    return currentUserEmail(ref);
  }
}

String _$currentUserEmailHash() => r'961afe76bc5e411e5c4699a3cc16a2dfb613bf86';

/// Profiles of the current household's members, keyed by user id.
///
/// Resolves display names and avatars wherever a user id appears ("who did
/// what"). Empty when the user has no household.

@ProviderFor(householdMemberProfiles)
final householdMemberProfilesProvider = HouseholdMemberProfilesProvider._();

/// Profiles of the current household's members, keyed by user id.
///
/// Resolves display names and avatars wherever a user id appears ("who did
/// what"). Empty when the user has no household.

final class HouseholdMemberProfilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, Profile>>,
          Map<String, Profile>,
          FutureOr<Map<String, Profile>>
        >
    with
        $FutureModifier<Map<String, Profile>>,
        $FutureProvider<Map<String, Profile>> {
  /// Profiles of the current household's members, keyed by user id.
  ///
  /// Resolves display names and avatars wherever a user id appears ("who did
  /// what"). Empty when the user has no household.
  HouseholdMemberProfilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'householdMemberProfilesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$householdMemberProfilesHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, Profile>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, Profile>> create(Ref ref) {
    return householdMemberProfiles(ref);
  }
}

String _$householdMemberProfilesHash() =>
    r'11bced50fce22eea66e5241b2edfa9e9c72e074f';

/// Drives the profile-edit screen's save action with loading/error state.
///
/// A successful save invalidates [myProfileProvider] (and the member map) so the
/// account card and overview refresh; the screen never navigates by hand.

@ProviderFor(ProfileEditController)
final profileEditControllerProvider = ProfileEditControllerProvider._();

/// Drives the profile-edit screen's save action with loading/error state.
///
/// A successful save invalidates [myProfileProvider] (and the member map) so the
/// account card and overview refresh; the screen never navigates by hand.
final class ProfileEditControllerProvider
    extends $AsyncNotifierProvider<ProfileEditController, void> {
  /// Drives the profile-edit screen's save action with loading/error state.
  ///
  /// A successful save invalidates [myProfileProvider] (and the member map) so the
  /// account card and overview refresh; the screen never navigates by hand.
  ProfileEditControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'profileEditControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$profileEditControllerHash();

  @$internal
  @override
  ProfileEditController create() => ProfileEditController();
}

String _$profileEditControllerHash() =>
    r'1f6c6e1beb25152245a69c4676b4215a361b715e';

/// Drives the profile-edit screen's save action with loading/error state.
///
/// A successful save invalidates [myProfileProvider] (and the member map) so the
/// account card and overview refresh; the screen never navigates by hand.

abstract class _$ProfileEditController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
