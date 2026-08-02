import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/domain/household_repository.dart';

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

  Future<void> settle() => container.read(inviteControllerProvider.future);

  test('exposes the generated code on success', () async {
    repository.inviteCode = 'ZK1234';
    await settle();

    await container
        .read(inviteControllerProvider.notifier)
        .createInvite('hh-1');

    expect(repository.inviteCalls, 1);
    expect(
      container.read(inviteControllerProvider),
      const AsyncData<String?>('ZK1234'),
    );
  });

  test('ends in error state when generation fails', () async {
    repository.inviteError = const HouseholdFailure(
      HouseholdFailureReason.notMember,
      'not a member',
    );
    await settle();

    await container
        .read(inviteControllerProvider.notifier)
        .createInvite('hh-1');

    expect(
      container.read(inviteControllerProvider),
      isA<AsyncError<String?>>(),
    );
  });
}
