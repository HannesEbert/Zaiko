import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/config/app_config.dart';

void main() {
  // Fail fast in debug if required configuration is missing (no-op in release).
  AppConfig.debugAssertValid();

  runApp(const ProviderScope(child: ZaikoApp()));
}
