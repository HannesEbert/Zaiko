import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/profile/application/profile_providers.dart';
import 'package:zaiko/features/profile/domain/profile.dart';
import 'package:zaiko/features/profile/presentation/pages/settings_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../fake_profile_repository.dart';

void main() {
  late FakeProfileRepository profiles;

  setUp(() {
    profiles = FakeProfileRepository()
      ..profile = Profile(
        id: 'user-1',
        displayName: 'Hannes',
        locale: 'de',
        createdAt: DateTime.utc(2026),
      );
  });

  Future<void> pumpSettings(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWithValue(AuthStatus.authenticated),
          profileRepositoryProvider.overrideWithValue(profiles),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('shows the three language options', (tester) async {
    await pumpSettings(tester);

    expect(find.text('System'), findsOneWidget);
    expect(find.text('German'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);
  });

  testWidgets('marks the stored language with a check', (tester) async {
    await pumpSettings(tester);

    // 'de' is stored, so exactly one option (German) shows the check icon.
    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets('tapping a language persists the new choice', (tester) async {
    await pumpSettings(tester);

    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(profiles.localeCalls, 1);
    expect(profiles.lastLocale, 'en');
  });

  testWidgets('shows the appearance as dark and read-only', (tester) async {
    await pumpSettings(tester);

    // The appearance value renders, but there is no toggle to flip it.
    expect(find.text('Dark'), findsOneWidget);
    expect(find.byType(Switch), findsNothing);
  });
}
