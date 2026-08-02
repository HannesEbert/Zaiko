import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/domain/household.dart';
import 'package:zaiko/features/household/domain/household_repository.dart';

import '../fake_household_repository.dart';

void main() {
  late FakeHouseholdRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeHouseholdRepository()
      ..current = Household(
        id: 'hh-1',
        name: 'Lindenhof',
        createdAt: DateTime.utc(2026),
      );
    container = ProviderContainer(
      overrides: [householdRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    addTearDown(repository.dispose);
  });

  Future<void> settle() =>
      container.read(householdManagementControllerProvider.future);

  test('rename forwards the new name and succeeds', () async {
    await settle();

    final ok = await container
        .read(householdManagementControllerProvider.notifier)
        .rename(householdId: 'hh-1', name: 'Neuer Hof');

    expect(ok, isTrue);
    expect(repository.renameCalls, 1);
    expect(repository.current?.name, 'Neuer Hof');
  });

  test('removeMember forwards the ids and succeeds', () async {
    await settle();

    final ok = await container
        .read(householdManagementControllerProvider.notifier)
        .removeMember(householdId: 'hh-1', userId: 'user-2');

    expect(ok, isTrue);
    expect(repository.removeCalls, 1);
  });

  test('leave clears the current household', () async {
    await settle();

    final ok = await container
        .read(householdManagementControllerProvider.notifier)
        .leave('hh-1');

    expect(ok, isTrue);
    expect(repository.leaveCalls, 1);
    expect(repository.current, isNull);
  });

  test('returns false and records the failure', () async {
    repository.leaveError = const HouseholdFailure(
      HouseholdFailureReason.unknown,
      'boom',
    );
    await settle();

    final ok = await container
        .read(householdManagementControllerProvider.notifier)
        .leave('hh-1');

    expect(ok, isFalse);
    expect(
      container.read(householdManagementControllerProvider),
      isA<AsyncError<void>>(),
    );
  });
}
