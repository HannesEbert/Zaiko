// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'households_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The app's [HouseholdRepository]. Overridden with a fake in tests.

@ProviderFor(householdRepository)
final householdRepositoryProvider = HouseholdRepositoryProvider._();

/// The app's [HouseholdRepository]. Overridden with a fake in tests.

final class HouseholdRepositoryProvider
    extends
        $FunctionalProvider<
          HouseholdRepository,
          HouseholdRepository,
          HouseholdRepository
        >
    with $Provider<HouseholdRepository> {
  /// The app's [HouseholdRepository]. Overridden with a fake in tests.
  HouseholdRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'householdRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$householdRepositoryHash();

  @$internal
  @override
  $ProviderElement<HouseholdRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HouseholdRepository create(Ref ref) {
    return householdRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HouseholdRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HouseholdRepository>(value),
    );
  }
}

String _$householdRepositoryHash() =>
    r'2f744add677a231dc33902e43653f5f70dac770c';

/// The current user's household, or `null` if they have none. Re-fetched when
/// invalidated after a create/join/leave.

@ProviderFor(currentHousehold)
final currentHouseholdProvider = CurrentHouseholdProvider._();

/// The current user's household, or `null` if they have none. Re-fetched when
/// invalidated after a create/join/leave.

final class CurrentHouseholdProvider
    extends
        $FunctionalProvider<
          AsyncValue<Household?>,
          Household?,
          FutureOr<Household?>
        >
    with $FutureModifier<Household?>, $FutureProvider<Household?> {
  /// The current user's household, or `null` if they have none. Re-fetched when
  /// invalidated after a create/join/leave.
  CurrentHouseholdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentHouseholdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentHouseholdHash();

  @$internal
  @override
  $FutureProviderElement<Household?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Household?> create(Ref ref) {
    return currentHousehold(ref);
  }
}

String _$currentHouseholdHash() => r'f372210aef99789f64a8595f1a40f58c215305cf';

/// Coarse membership state the router redirect reads synchronously.

@ProviderFor(householdMembership)
final householdMembershipProvider = HouseholdMembershipProvider._();

/// Coarse membership state the router redirect reads synchronously.

final class HouseholdMembershipProvider
    extends
        $FunctionalProvider<
          HouseholdMembership,
          HouseholdMembership,
          HouseholdMembership
        >
    with $Provider<HouseholdMembership> {
  /// Coarse membership state the router redirect reads synchronously.
  HouseholdMembershipProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'householdMembershipProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$householdMembershipHash();

  @$internal
  @override
  $ProviderElement<HouseholdMembership> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HouseholdMembership create(Ref ref) {
    return householdMembership(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HouseholdMembership value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HouseholdMembership>(value),
    );
  }
}

String _$householdMembershipHash() =>
    r'c7ed18d939a2fedcbd1d8e0cabbd7c3b78947431';

/// Live roster of the given household's members.

@ProviderFor(householdMembers)
final householdMembersProvider = HouseholdMembersFamily._();

/// Live roster of the given household's members.

final class HouseholdMembersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HouseholdMember>>,
          List<HouseholdMember>,
          Stream<List<HouseholdMember>>
        >
    with
        $FutureModifier<List<HouseholdMember>>,
        $StreamProvider<List<HouseholdMember>> {
  /// Live roster of the given household's members.
  HouseholdMembersProvider._({
    required HouseholdMembersFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'householdMembersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$householdMembersHash();

  @override
  String toString() {
    return r'householdMembersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<HouseholdMember>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<HouseholdMember>> create(Ref ref) {
    final argument = this.argument as String;
    return householdMembers(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HouseholdMembersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$householdMembersHash() => r'0f089bafc9112cc7be78e56137283073d9b811ea';

/// Live roster of the given household's members.

final class HouseholdMembersFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<HouseholdMember>>, String> {
  HouseholdMembersFamily._()
    : super(
        retry: null,
        name: r'householdMembersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Live roster of the given household's members.

  HouseholdMembersProvider call(String householdId) =>
      HouseholdMembersProvider._(argument: householdId, from: this);

  @override
  String toString() => r'householdMembersProvider';
}

/// Invite code carried across a sign-in when an unauthenticated user opens a
/// join link. The onboarding screen reads it to pre-fill the join field.

@ProviderFor(PendingInviteCode)
final pendingInviteCodeProvider = PendingInviteCodeProvider._();

/// Invite code carried across a sign-in when an unauthenticated user opens a
/// join link. The onboarding screen reads it to pre-fill the join field.
final class PendingInviteCodeProvider
    extends $NotifierProvider<PendingInviteCode, String?> {
  /// Invite code carried across a sign-in when an unauthenticated user opens a
  /// join link. The onboarding screen reads it to pre-fill the join field.
  PendingInviteCodeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingInviteCodeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingInviteCodeHash();

  @$internal
  @override
  PendingInviteCode create() => PendingInviteCode();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$pendingInviteCodeHash() => r'2df786c4f3ddde7404cb853a28a3fed84f0cf13e';

/// Invite code carried across a sign-in when an unauthenticated user opens a
/// join link. The onboarding screen reads it to pre-fill the join field.

abstract class _$PendingInviteCode extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Drives the onboarding screen's create/join actions with loading/error state.
///
/// A successful action invalidates [currentHouseholdProvider]; the resulting
/// membership change flows through the router redirect, so the screen never
/// navigates by hand.

@ProviderFor(OnboardingController)
final onboardingControllerProvider = OnboardingControllerProvider._();

/// Drives the onboarding screen's create/join actions with loading/error state.
///
/// A successful action invalidates [currentHouseholdProvider]; the resulting
/// membership change flows through the router redirect, so the screen never
/// navigates by hand.
final class OnboardingControllerProvider
    extends $AsyncNotifierProvider<OnboardingController, void> {
  /// Drives the onboarding screen's create/join actions with loading/error state.
  ///
  /// A successful action invalidates [currentHouseholdProvider]; the resulting
  /// membership change flows through the router redirect, so the screen never
  /// navigates by hand.
  OnboardingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingControllerHash();

  @$internal
  @override
  OnboardingController create() => OnboardingController();
}

String _$onboardingControllerHash() =>
    r'4a3215ef4991a544c71aa8c6a65a15fe9ac9e885';

/// Drives the onboarding screen's create/join actions with loading/error state.
///
/// A successful action invalidates [currentHouseholdProvider]; the resulting
/// membership change flows through the router redirect, so the screen never
/// navigates by hand.

abstract class _$OnboardingController extends $AsyncNotifier<void> {
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

/// Generates an invite code for a household and exposes it (plus loading/error)
/// so the UI can render the code and its QR.

@ProviderFor(InviteController)
final inviteControllerProvider = InviteControllerProvider._();

/// Generates an invite code for a household and exposes it (plus loading/error)
/// so the UI can render the code and its QR.
final class InviteControllerProvider
    extends $AsyncNotifierProvider<InviteController, String?> {
  /// Generates an invite code for a household and exposes it (plus loading/error)
  /// so the UI can render the code and its QR.
  InviteControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inviteControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inviteControllerHash();

  @$internal
  @override
  InviteController create() => InviteController();
}

String _$inviteControllerHash() => r'8021d00d917856aae157eedcab5fc0ff063dd357';

/// Generates an invite code for a household and exposes it (plus loading/error)
/// so the UI can render the code and its QR.

abstract class _$InviteController extends $AsyncNotifier<String?> {
  FutureOr<String?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String?>, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String?>, String?>,
              AsyncValue<String?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Drives household management actions (rename, remove member, leave) with
/// loading/error state for the household page.

@ProviderFor(HouseholdManagementController)
final householdManagementControllerProvider =
    HouseholdManagementControllerProvider._();

/// Drives household management actions (rename, remove member, leave) with
/// loading/error state for the household page.
final class HouseholdManagementControllerProvider
    extends $AsyncNotifierProvider<HouseholdManagementController, void> {
  /// Drives household management actions (rename, remove member, leave) with
  /// loading/error state for the household page.
  HouseholdManagementControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'householdManagementControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$householdManagementControllerHash();

  @$internal
  @override
  HouseholdManagementController create() => HouseholdManagementController();
}

String _$householdManagementControllerHash() =>
    r'2a65e196a3579b710f3709db92356bbbfe1a22c9';

/// Drives household management actions (rename, remove member, leave) with
/// loading/error state for the household page.

abstract class _$HouseholdManagementController extends $AsyncNotifier<void> {
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
