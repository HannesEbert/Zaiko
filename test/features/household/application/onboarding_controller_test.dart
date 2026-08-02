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

  Future<void> settle() => container.read(onboardingControllerProvider.future);

  group('createHousehold', () {
    test('creates the household and ends in data state', () async {
      await settle();

      final ok = await container
          .read(onboardingControllerProvider.notifier)
          .createHousehold('Lindenhof');

      expect(ok, isTrue);
      expect(repository.createCalls, 1);
      expect(
        container.read(onboardingControllerProvider),
        const AsyncData<void>(null),
      );
    });

    test('returns false and records the failure', () async {
      repository.createError = const HouseholdFailure(
        HouseholdFailureReason.unknown,
        'boom',
      );
      await settle();

      final ok = await container
          .read(onboardingControllerProvider.notifier)
          .createHousehold('Lindenhof');

      expect(ok, isFalse);
      expect(
        container.read(onboardingControllerProvider),
        isA<AsyncError<void>>(),
      );
    });
  });

  group('joinByCode', () {
    test('forwards the code and ends in data state', () async {
      await settle();

      final ok = await container
          .read(onboardingControllerProvider.notifier)
          .joinByCode('XYZ789');

      expect(ok, isTrue);
      expect(repository.acceptedCodes, ['XYZ789']);
      expect(
        container.read(onboardingControllerProvider),
        const AsyncData<void>(null),
      );
    });

    test('records an alreadyInHousehold failure', () async {
      repository.acceptError = const HouseholdFailure(
        HouseholdFailureReason.alreadyInHousehold,
        'already in a household',
      );
      await settle();

      final ok = await container
          .read(onboardingControllerProvider.notifier)
          .joinByCode('XYZ789');

      expect(ok, isFalse);
      final state = container.read(onboardingControllerProvider);
      expect(state, isA<AsyncError<void>>());
      expect(
        (state.error! as HouseholdFailure).reason,
        HouseholdFailureReason.alreadyInHousehold,
      );
    });
  });
}
