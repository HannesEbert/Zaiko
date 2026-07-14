import 'package:flutter/material.dart';

/// Deep-link target for household invitations (`/join/:code`).
///
/// Placeholder that surfaces the connection code carried by the link;
/// accepting the invite is wired up once households and Supabase auth exist.
class JoinHouseholdPage extends StatelessWidget {
  const JoinHouseholdPage({required this.connectionCode, super.key});

  /// Prefix shared by [routePath] and [location] so the path is defined once.
  static const String pathPrefix = '/join';
  static const String routePath = '$pathPrefix/:code';
  static const String routeName = 'join';

  /// Builds a concrete deep-link location for [code], e.g. `/join/ABC123`.
  static String location(String code) => '$pathPrefix/$code';

  /// The invite/connection code parsed from the deep link.
  final String connectionCode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Join household')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.group_add_outlined,
                size: 64,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'You have been invited to a household',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Connection code: $connectionCode',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
