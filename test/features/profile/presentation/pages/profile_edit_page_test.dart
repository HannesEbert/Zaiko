import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/profile/application/profile_providers.dart';
import 'package:zaiko/features/profile/domain/profile.dart';
import 'package:zaiko/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../fake_profile_repository.dart';

void main() {
  late FakeProfileRepository profiles;

  setUp(() {
    profiles = FakeProfileRepository()
      ..profile = Profile(
        id: 'user-1',
        displayName: 'Hannes',
        createdAt: DateTime.utc(2026),
      );
  });

  // Pumps a launcher that pushes the edit page onto a GoRouter (the page uses
  // context.pop() on save, so it needs a real router to return to).
  Future<void> pumpEditPage(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => context.push('/edit'),
                child: const Text('open'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/edit',
          builder: (context, state) => const ProfileEditPage(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWithValue(AuthStatus.authenticated),
          profileRepositoryProvider.overrideWithValue(profiles),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('prefills the name and saves the edited display name', (
    tester,
  ) async {
    await pumpEditPage(tester);

    expect(find.text('Hannes'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Mara');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(profiles.updateCalls, 1);
    expect(profiles.lastDisplayName, 'Mara');
    expect(profiles.lastAvatarPreset, isNull);
    // Popped back to the launcher.
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('selecting a preset avatar saves its key', (tester) async {
    await pumpEditPage(tester);

    // The first preset ('sprout') renders the eco glyph in the picker.
    await tester.tap(find.byIcon(Icons.eco));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(profiles.updateCalls, 1);
    expect(profiles.lastAvatarPreset, 'sprout');
  });
}
