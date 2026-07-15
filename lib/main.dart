import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';
import 'core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fail fast in debug if required configuration is missing (no-op in release).
  AppConfig.debugAssertValid();

  // Restores any persisted session so returning users skip the login screen.
  // The anon key is Supabase's "publishable" key (the two are interchangeable).
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    publishableKey: AppConfig.supabaseAnonKey,
  );

  runApp(const ProviderScope(child: ZaikoApp()));
}
