import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/domain/household.dart';
import 'package:zaiko/features/profile/application/profile_providers.dart';
import 'package:zaiko/features/profile/domain/profile.dart';
import 'package:zaiko/features/profile/presentation/pages/personal_data_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../../household/fake_household_repository.dart';
import '../../fake_profile_repository.dart';

void main() {
  testWidgets('shows the stored name, email and household', (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final profiles = FakeProfileRepository()
      ..profile = Profile(
        id: 'user-1',
        displayName: 'Hannes',
        createdAt: DateTime.utc(2026, 8),
      )
      ..currentUserEmail = 'hannes@example.com';
    final household = FakeHouseholdRepository()
      ..current = Household(
        id: 'hh-1',
        name: 'Lindenhof',
        createdAt: DateTime.utc(2026),
      );
    addTearDown(household.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWithValue(AuthStatus.authenticated),
          profileRepositoryProvider.overrideWithValue(profiles),
          householdRepositoryProvider.overrideWithValue(household),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PersonalDataPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hannes'), findsWidgets);
    expect(find.text('hannes@example.com'), findsOneWidget);
    expect(find.text('Lindenhof'), findsOneWidget);
    // "Member since" row value is the created month/year.
    expect(find.text('August 2026'), findsOneWidget);
  });
}
