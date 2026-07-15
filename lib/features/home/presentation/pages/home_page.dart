import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/l10n/l10n_extension.dart';
import '../../../../shared/widgets/empty_state.dart';

/// Landing page of the app: a household overview / dashboard.
///
/// Placeholder for now — expiring items, quick stats and shortcuts arrive with
/// the home dashboard feature issue.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routePath = '/home';
  static const String routeName = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: EmptyState(
        icon: Icons.dashboard_outlined,
        title: context.l10n.homeEmptyTitle,
        message: context.l10n.homeEmptyMessage,
      ),
    );
  }
}
