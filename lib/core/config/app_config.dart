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

  /// Fails fast in debug builds when a required value is missing, so a
  /// misconfigured run surfaces immediately with a clear message instead of at
  /// the first network call. In release builds the `assert`s are stripped, so
  /// this is a no-op.
  static void debugAssertValid() {
    assert(
      supabaseUrl.isNotEmpty,
      'SUPABASE_URL is empty. Run with '
      '--dart-define-from-file=config/app_config.json '
      '(copy config/app_config.example.json to config/app_config.json first).',
    );
    assert(
      supabaseAnonKey.isNotEmpty,
      'SUPABASE_ANON_KEY is empty. See config/app_config.example.json.',
    );
    assert(
      offUserAgent.isNotEmpty,
      'OFF_USER_AGENT is empty. See config/app_config.example.json.',
    );
  }
}
