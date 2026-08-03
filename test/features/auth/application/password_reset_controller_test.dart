import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_repository.dart';

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
      container.read(passwordResetControllerProvider.future);

  group('sendResetEmail', () {
    test('forwards the email and reports success', () async {
      await settleInitialBuild();

      final sent = await container
          .read(passwordResetControllerProvider.notifier)
          .sendResetEmail('user@example.com');

      expect(sent, isTrue);
      expect(repository.sendResetCalls, 1);
      expect(
        container.read(passwordResetControllerProvider),
        const AsyncData<void>(null),
      );
    });

    test(
      'reports failure and records error when the repository throws',
      () async {
        repository.sendResetError = const AuthFailure('rate limit exceeded');
        await settleInitialBuild();

        final sent = await container
            .read(passwordResetControllerProvider.notifier)
            .sendResetEmail('user@example.com');

        expect(sent, isFalse);
        expect(
          container.read(passwordResetControllerProvider),
          isA<AsyncError<void>>(),
        );
      },
    );
  });

  group('updatePassword', () {
    test(
      'sets the password, clears recovery, and signs out on success',
      () async {
        // Enter a recovery flow first so we can assert it is cleared.
        container.listen(passwordRecoveryActiveProvider, (_, _) {});
        repository.emitPasswordRecovery();
        await pumpEventQueue();
        expect(container.read(passwordRecoveryActiveProvider), isTrue);
        await settleInitialBuild();

        final updated = await container
            .read(passwordResetControllerProvider.notifier)
            .updatePassword('newSecret123');

        expect(updated, isTrue);
        expect(repository.updatePasswordCalls, 1);
        expect(repository.signOutCalls, 1);
        expect(container.read(passwordRecoveryActiveProvider), isFalse);
      },
    );

    test(
      'reports failure and does not sign out when the repository throws',
      () async {
        repository.updatePasswordError = const AuthFailure('session expired');
        await settleInitialBuild();

        final updated = await container
            .read(passwordResetControllerProvider.notifier)
            .updatePassword('newSecret123');

        expect(updated, isFalse);
        expect(repository.signOutCalls, 0);
        expect(
          container.read(passwordResetControllerProvider),
          isA<AsyncError<void>>(),
        );
      },
    );
  });

  group('passwordRecoveryActive', () {
    test(
      'is false initially, true on a recovery event, false after complete',
      () async {
        container.listen(passwordRecoveryActiveProvider, (_, _) {});

        expect(container.read(passwordRecoveryActiveProvider), isFalse);

        repository.emitPasswordRecovery();
        await pumpEventQueue();
        expect(container.read(passwordRecoveryActiveProvider), isTrue);

        container.read(passwordRecoveryActiveProvider.notifier).complete();
        expect(container.read(passwordRecoveryActiveProvider), isFalse);
      },
    );
  });
}
