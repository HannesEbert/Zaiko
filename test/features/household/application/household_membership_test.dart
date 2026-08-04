import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/domain/household.dart';

import '../fake_household_repository.dart';

void main() {
  late FakeHouseholdRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeHouseholdRepository();
    container = ProviderContainer(
      overrides: [
        // Membership is only meaningful once signed in; the household load is
        // gated on auth, so tests must provide a session to reach the repository.
        authStateProvider.overrideWithValue(AuthStatus.authenticated),
        householdRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(repository.dispose);
  });

  test('is unknown while the household load is in flight', () {
    // Read synchronously, before the async load resolves.
    expect(
      container.read(householdMembershipProvider),
      HouseholdMembership.unknown,
    );
  });

  test('resolves to none when the user has no household', () async {
    await container.read(currentHouseholdProvider.future);

    expect(
      container.read(householdMembershipProvider),
      HouseholdMembership.none,
    );
  });

  test('resolves to joined after a household is created', () async {
    await container.read(currentHouseholdProvider.future);
    expect(
      container.read(householdMembershipProvider),
      HouseholdMembership.none,
    );

    repository.current = Household(
      id: 'hh-1',
      name: 'Lindenhof',
      createdAt: DateTime.utc(2026),
    );
    container.invalidate(currentHouseholdProvider);
    await container.read(currentHouseholdProvider.future);

    expect(
      container.read(householdMembershipProvider),
      HouseholdMembership.joined,
    );
  });

  test('stays unknown and does not load the household while signed out', () {
    // Regression: a signed-out load resolved to `none` and stranded a returning
    // member on onboarding for the instant between sign-in and the refetch. The
    // load is gated on auth, so signed out it never touches the repository and
    // membership stays `unknown` (never a stale `none`).
    final signedOut = ProviderContainer(
      overrides: [
        authStateProvider.overrideWithValue(AuthStatus.unauthenticated),
        householdRepositoryProvider.overrideWithValue(repository),
      ],
    );
    addTearDown(signedOut.dispose);

    expect(
      signedOut.read(householdMembershipProvider),
      HouseholdMembership.unknown,
    );
    expect(repository.loadCalls, 0);
  });

  test('loads the household once authenticated', () async {
    await container.read(currentHouseholdProvider.future);
    expect(repository.loadCalls, 1);
  });
}
