/// Application configuration, sourced from compile-time environment values.
///
/// Values are injected at build/run time via `--dart-define-from-file`
/// (see `config/app_config.example.json`), never read from committed source.
///
/// Note on secrecy: the Supabase **anon** key is safe to ship — access is
/// gated by row-level security. The `service_role` key must never be wired in
/// here or anywhere in the app. Keeping configuration out of source keeps
/// environments swappable and makes an accidental secret commit impossible by
/// construction (the real `config/app_config.json` is git-ignored).
abstract final class AppConfig {
  const AppConfig._();

  /// Supabase project URL, e.g. `https://your-project-ref.supabase.co`.
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  /// Supabase anon (public) key — safe to ship, protected by row-level
  /// security.
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );

  /// User-Agent sent to the Open Food Facts API. Their usage guidelines
  /// require an identifying User-Agent, e.g. `Zaiko/0.1 (contact@example.com)`.
  static const String offUserAgent = String.fromEnvironment('OFF_USER_AGENT');

  /// Fails fast in debug builds when the configuration is missing or still
  /// holds the template placeholders, so a misconfigured run surfaces
  /// immediately with a clear message instead of at the first network call
  /// (e.g. a confusing `Failed to fetch` against `your-project-ref`). In
  /// release builds the `assert` is stripped, so this is a no-op.
  static void debugAssertValid() {
    final error = validate(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
      userAgent: offUserAgent,
    );
    assert(error == null, error);
  }

  /// Validates the three required config values, returning a human-readable
  /// description of the first problem found, or `null` when all are set.
  ///
  /// Pure and parameterised so it can be unit-tested without `--dart-define`
  /// injection. Rejects both empty values and the leftover template
  /// placeholders from `config/app_config.example.json`.
  static String? validate({
    required String url,
    required String anonKey,
    required String userAgent,
  }) {
    const setupHint =
        'Run with --dart-define-from-file=config/app_config.json and fill in '
        'your real Supabase values (copy config/app_config.example.json first).';

    if (url.isEmpty) return 'SUPABASE_URL is empty. $setupHint';
    if (url.contains('your-project-ref')) {
      return 'SUPABASE_URL is still the placeholder. $setupHint';
    }
    if (anonKey.isEmpty) return 'SUPABASE_ANON_KEY is empty. $setupHint';
    if (anonKey.contains('your-supabase-anon-key')) {
      return 'SUPABASE_ANON_KEY is still the placeholder. $setupHint';
    }
    if (userAgent.isEmpty) return 'OFF_USER_AGENT is empty. $setupHint';
    if (userAgent.contains('your-contact@')) {
      return 'OFF_USER_AGENT is still the placeholder. $setupHint';
    }
    return null;
  }
}
