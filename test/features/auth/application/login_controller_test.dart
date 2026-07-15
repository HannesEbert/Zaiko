import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/data/auth_repository.dart';

import '../fake_auth_repository.dart';

void main() {
  late FakeAuthRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeAuthRepository();
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
    addTearDown(repository.dispose);
  });

  Future<void> settleInitialBuild() =>
      container.read(loginControllerProvider.future);

  group('signIn', () {
    test('forwards credentials and ends in data state on success', () async {
      await settleInitialBuild();

      await container
          .read(loginControllerProvider.notifier)
          .signIn(email: 'user@example.com', password: 'secret123');

      expect(repository.signInCalls, 1);
      expect(
        container.read(loginControllerProvider),
        const AsyncData<void>(null),
      );
    });

    test('ends in error state when the repository throws', () async {
      repository.signInError = const AuthFailure('Invalid login credentials');
      await settleInitialBuild();

      await container
          .read(loginControllerProvider.notifier)
          .signIn(email: 'user@example.com', password: 'wrong');

      expect(container.read(loginControllerProvider), isA<AsyncError<void>>());
      expect(container.read(loginControllerProvider).error, isA<AuthFailure>());
    });
  });

  group('signUp', () {
    test('returns signedIn outcome and clears loading on success', () async {
      await settleInitialBuild();

      final outcome = await container
          .read(loginControllerProvider.notifier)
          .signUp(email: 'new@example.com', password: 'secret123');

      expect(outcome, SignUpOutcome.signedIn);
      expect(repository.signUpCalls, 1);
      expect(
        container.read(loginControllerProvider),
        const AsyncData<void>(null),
      );
    });

    test('surfaces email confirmation requirement', () async {
      repository.signUpOutcome = SignUpOutcome.emailConfirmationRequired;
      await settleInitialBuild();

      final outcome = await container
          .read(loginControllerProvider.notifier)
          .signUp(email: 'new@example.com', password: 'secret123');

      expect(outcome, SignUpOutcome.emailConfirmationRequired);
    });

    test('returns null and records error when the repository throws', () async {
      repository.signUpError = const AuthFailure('User already registered');
      await settleInitialBuild();

      final outcome = await container
          .read(loginControllerProvider.notifier)
          .signUp(email: 'taken@example.com', password: 'secret123');

      expect(outcome, isNull);
      expect(container.read(loginControllerProvider), isA<AsyncError<void>>());
    });
  });
}
