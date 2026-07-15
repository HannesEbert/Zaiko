import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';

import '../fake_auth_repository.dart';

void main() {
  test(
    'authState seeds from currentStatus and follows the change stream',
    () async {
      final repository = FakeAuthRepository();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      addTearDown(repository.dispose);

      // Keep the provider (and its stream subscription) alive for the test.
      container.listen(authStateProvider, (_, _) {});

      expect(container.read(authStateProvider), AuthStatus.unauthenticated);

      repository.emit(AuthStatus.authenticated);
      await pumpEventQueue();

      expect(container.read(authStateProvider), AuthStatus.authenticated);
    },
  );
}
