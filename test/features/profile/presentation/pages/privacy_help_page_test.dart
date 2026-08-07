import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/profile/application/profile_providers.dart';
import 'package:zaiko/features/profile/presentation/pages/help_page.dart';
import 'package:zaiko/features/profile/presentation/pages/privacy_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

void main() {
  Future<void> pumpPage(WidgetTester tester, Widget page) async {
    await tester.binding.setSurfaceSize(const Size(500, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appVersionProvider.overrideWith((ref) => '9.9.9')],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: page,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('privacy page shows the disclaimer and sections', (tester) async {
    await pumpPage(tester, const PrivacyPage());

    expect(find.textContaining('portfolio project'), findsOneWidget);
    expect(find.text('What we store'), findsOneWidget);
    expect(find.text('Where it\'s stored'), findsOneWidget);
  });

  testWidgets('help page shows an FAQ, contact and the app version', (
    tester,
  ) async {
    await pumpPage(tester, const HelpPage());

    expect(find.text('How do I add an item?'), findsOneWidget);
    expect(find.widgetWithText(OutlinedButton, 'Email us'), findsOneWidget);
    expect(find.text('Zaiko 9.9.9'), findsOneWidget);
  });
}
