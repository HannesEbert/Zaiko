import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaiko/core/theme/app_theme.dart';
import 'package:zaiko/features/auth/application/auth_providers.dart';
import 'package:zaiko/features/auth/domain/auth_status.dart';
import 'package:zaiko/features/household/application/households_providers.dart';
import 'package:zaiko/features/household/domain/household.dart';
import 'package:zaiko/features/household/domain/household_member.dart';
import 'package:zaiko/features/household/domain/household_role.dart';
import 'package:zaiko/features/profile/application/profile_providers.dart';
import 'package:zaiko/features/profile/domain/profile.dart';
import 'package:zaiko/features/profile/presentation/pages/household_link_page.dart';
import 'package:zaiko/l10n/app_localizations.dart';

import '../../../household/fake_household_repository.dart';
import '../../fake_profile_repository.dart';

void main() {
  testWidgets('roster shows member display names, marking the current user', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(500, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final household = FakeHouseholdRepository(currentUserId: 'user-1')
      ..current = Household(
        id: 'hh-1',
        name: 'Lindenhof',
        createdAt: DateTime.utc(2026),
      );
    addTearDown(household.dispose);
    final profiles = FakeProfileRepository(currentUserId: 'user-1')
      ..others = [
        Profile(
          id: 'user-1',
          displayName: 'Hannes',
          createdAt: DateTime.utc(2026),
        ),
        Profile(
          id: 'user-2',
          displayName: 'Mara',
          createdAt: DateTime.utc(2026),
        ),
      ];

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWithValue(AuthStatus.authenticated),
          householdRepositoryProvider.overrideWithValue(household),
          profileRepositoryProvider.overrideWithValue(profiles),
        ],
        child: MaterialApp(
          theme: AppTheme.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const HouseholdLinkPage(),
        ),
      ),
    );

    // Let currentHousehold resolve and both member-stream subscriptions attach
    // before pushing the roster (the broadcast stream drops events with no
    // listener), then let the profile lookup resolve.
    await tester.pump(const Duration(milliseconds: 50));
    household.emitMembers([
      HouseholdMember(
        householdId: 'hh-1',
        userId: 'user-1',
        role: HouseholdRole.owner,
        joinedAt: DateTime.utc(2026),
      ),
      HouseholdMember(
        householdId: 'hh-1',
        userId: 'user-2',
        role: HouseholdRole.member,
        joinedAt: DateTime.utc(2026),
      ),
    ]);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Hannes (You)'), findsOneWidget);
    expect(find.text('Mara'), findsOneWidget);
  });
}
