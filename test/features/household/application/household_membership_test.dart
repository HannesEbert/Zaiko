import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/domain/household.dart';

import '../fake_household_repository.dart';

void main() {
  late FakeHouseholdRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeHouseholdRepository();
    container = ProviderContainer(
      overrides: [householdRepositoryProvider.overrideWithValue(repository)],
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
}
