import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';

/// Placeholder sign-in screen.
///
/// Real Supabase authentication arrives later; for now the router's auth guard
/// sends unauthenticated users here.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static const String routePath = '/login';
  static const String routeName = 'login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign in')),
      body: Center(
        child: Text(
          'Welcome to ${AppConstants.appName}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
