import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/domain/household.dart';
import 'package:zaiko/features/household/domain/household_member.dart';
import 'package:zaiko/features/household/domain/household_role.dart';
import 'package:zaiko/features/profile/application/profile_providers.dart';
import 'package:zaiko/features/profile/domain/profile.dart';
import 'package:zaiko/features/profile/domain/profile_repository.dart';

import '../../household/fake_household_repository.dart';
import '../fake_profile_repository.dart';

void main() {
  late FakeProfileRepository profiles;

  Profile profile(String id, {String name = 'Dev', String? preset}) => Profile(
    id: id,
    displayName: name,
    avatarPreset: preset,
    createdAt: DateTime.utc(2026),
  );

  ProviderContainer makeContainer({
    AuthStatus status = AuthStatus.authenticated,
    FakeHouseholdRepository? household,
  }) {
    final container = ProviderContainer(
      overrides: [
        authStateProvider.overrideWithValue(status),
        profileRepositoryProvider.overrideWithValue(profiles),
        if (household != null)
          householdRepositoryProvider.overrideWithValue(household),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() => profiles = FakeProfileRepository());

  test('myProfile is null when the user is signed out', () async {
    final container = makeContainer(status: AuthStatus.unauthenticated);

    expect(await container.read(myProfileProvider.future), isNull);
    expect(profiles.loadCalls, 0);
  });

  test('myProfile loads the profile when authenticated', () async {
    profiles.profile = profile('user-1', name: 'Hannes');
    final container = makeContainer();

    final result = await container.read(myProfileProvider.future);

    expect(result?.displayName, 'Hannes');
    expect(profiles.loadCalls, 1);
  });

  test('currentUserEmail comes from the repository', () async {
    profiles.currentUserEmail = 'hannes@example.com';
    final container = makeContainer();

    expect(
      await container.read(currentUserEmailProvider.future),
      'hannes@example.com',
    );
  });

  test('saving updates the profile and refreshes myProfile', () async {
    profiles.profile = profile('user-1', name: 'Old');
    final container = makeContainer();
    container.listen(profileEditControllerProvider, (_, _) {});

    final ok = await container
        .read(profileEditControllerProvider.notifier)
        .save(displayName: 'New', avatarPreset: 'sprout');

    expect(ok, isTrue);
    expect(profiles.updateCalls, 1);
    expect(profiles.lastDisplayName, 'New');
    expect(profiles.lastAvatarPreset, 'sprout');
    expect(container.read(profileEditControllerProvider).hasError, isFalse);

    final refreshed = await container.read(myProfileProvider.future);
    expect(refreshed?.displayName, 'New');
    expect(refreshed?.avatarPreset, 'sprout');
  });

  test('a failed save surfaces as an error and returns false', () async {
    profiles.updateError = const ProfileFailure(
      ProfileFailureReason.unknown,
      'boom',
    );
    final container = makeContainer();
    container.listen(profileEditControllerProvider, (_, _) {});

    final ok = await container
        .read(profileEditControllerProvider.notifier)
        .save(displayName: 'New', avatarPreset: null);

    expect(ok, isFalse);
    expect(container.read(profileEditControllerProvider).hasError, isTrue);
  });

  test('householdMemberProfiles maps member ids to their profiles', () async {
    final household = FakeHouseholdRepository()
      ..current = Household(
        id: 'hh-1',
        name: 'Lindenhof',
        createdAt: DateTime.utc(2026),
      );
    profiles.others = [
      profile('user-1', name: 'Hannes'),
      profile('user-2', name: 'Mara'),
    ];
    addTearDown(household.dispose);
    final container = makeContainer(household: household);
    // Keep the provider (and its watched member stream) alive across the async
    // gap below, so it is not auto-disposed while waiting for the roster.
    container.listen(householdMemberProfilesProvider, (_, _) {});

    final future = container.read(householdMemberProfilesProvider.future);
    // Let currentHousehold resolve and the members stream subscribe before the
    // roster is pushed (the broadcast stream drops events with no listener).
    await Future<void>.delayed(const Duration(milliseconds: 10));
    household.emitMembers([
      HouseholdMember(
        householdId: 'hh-1',
        userId: 'user-1',
        role: HouseholdRole.owner,
        joinedAt: DateTime.utc(2026),
      ),
      HouseholdMember(
        householdId: 'hh-1',
        userId: 'user-2',
        role: HouseholdRole.member,
        joinedAt: DateTime.utc(2026),
      ),
    ]);

    final map = await future;
    expect(map.keys, containsAll(<String>['user-1', 'user-2']));
    expect(map['user-2']?.displayName, 'Mara');
  });

  test('appLocale maps the stored profile locale to a Locale', () async {
    profiles.profile = profile('user-1').copyWith(locale: 'de');
    final container = makeContainer();
    await container.read(myProfileProvider.future);

    expect(container.read(appLocaleProvider), const Locale('de'));
  });

  test('appLocale is null when the profile has no locale', () async {
    profiles.profile = profile('user-1');
    final container = makeContainer();
    await container.read(myProfileProvider.future);

    expect(container.read(appLocaleProvider), isNull);
  });

  test('setLocale persists the language and refreshes myProfile', () async {
    profiles.profile = profile('user-1');
    final container = makeContainer();
    container.listen(localeSettingControllerProvider, (_, _) {});

    final ok = await container
        .read(localeSettingControllerProvider.notifier)
        .setLocale('en');

    expect(ok, isTrue);
    expect(profiles.localeCalls, 1);
    expect(profiles.lastLocale, 'en');
    final refreshed = await container.read(myProfileProvider.future);
    expect(refreshed?.locale, 'en');
  });

  test('a failed setLocale surfaces as an error and returns false', () async {
    profiles
      ..profile = profile('user-1')
      ..localeError = const ProfileFailure(
        ProfileFailureReason.unknown,
        'boom',
      );
    final container = makeContainer();
    container.listen(localeSettingControllerProvider, (_, _) {});

    final ok = await container
        .read(localeSettingControllerProvider.notifier)
        .setLocale('en');

    expect(ok, isFalse);
    expect(container.read(localeSettingControllerProvider).hasError, isTrue);
  });

  test('saving dietary preferences stores them and refreshes', () async {
    profiles.profile = profile('user-1');
    final container = makeContainer();
    container.listen(dietaryPreferencesControllerProvider, (_, _) {});

    final ok = await container
        .read(dietaryPreferencesControllerProvider.notifier)
        .save(
          allergens: ['gluten'],
          diets: ['vegan'],
          dislikes: ['olives'],
          note: 'no spice',
        );

    expect(ok, isTrue);
    expect(profiles.dietaryCalls, 1);
    expect(profiles.lastAllergens, ['gluten']);
    final refreshed = await container.read(myProfileProvider.future);
    expect(refreshed?.diets, ['vegan']);
    expect(refreshed?.dietaryNote, 'no spice');
  });
}
