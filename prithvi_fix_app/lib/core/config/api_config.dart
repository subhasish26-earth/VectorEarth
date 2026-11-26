/// Central API & Database Configuration for Prithvi Fix App
class ApiConfig {
  /// Production Vercel API URL connected directly to your PostgreSQL DB
  static String baseUrl = 'https://vectorearth.vercel.app/api';

  /// Toggle between Live API and offline-resilient local demo state.
  static bool useLiveBackend = true;

  /// Supabase project configuration
  static String supabaseUrl = 'https://thrjlknicwmsrabzohwz.supabase.co';
  static String supabaseAnonKey = '';

  /// Set the live Vercel base URL
  static void setVercelUrl(String url) {
    var cleaned = url.trim();
    if (cleaned.endsWith('/')) {
      cleaned = cleaned.substring(0, cleaned.length - 1);
    }
    if (!cleaned.endsWith('/api')) {
      cleaned = '$cleaned/api';
    }
    baseUrl = cleaned;
    useLiveBackend = true;
  }

  /// Set direct Supabase credentials
  static void setSupabaseCredentials({
    required String projectUrl,
    required String anonKey,
  }) {
    supabaseUrl = projectUrl.trim();
    supabaseAnonKey = anonKey.trim();
    useLiveBackend = true;
  }
}
