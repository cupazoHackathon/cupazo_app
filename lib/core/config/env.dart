/// Configuración de entorno de la aplicación
class Env {
  // Supabase Configuration
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://xafdyalnzeaogyleyqjs.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhhZmR5YWxuemVhb2d5bGV5cWpzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQyOTU5MTYsImV4cCI6MjA3OTg3MTkxNn0.U0nzTeB3bUqhdppnyNKZY1DxUTO1OYFLUDGdAQYK7d8',
  );

  // Google OAuth Configuration
  static const String googleClientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
    defaultValue:
        '237504197430-1m76mnlg19499qaurstdesmblajdb3ck.apps.googleusercontent.com',
  );

  // Web Client ID - Necesario para obtener idToken
  // IMPORTANTE: Si tienes un Web Client ID diferente, úsalo aquí
  // Por defecto usa el mismo que el Client ID de Android
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue:
        '237504197430-1m76mnlg19499qaurstdesmblajdb3ck.apps.googleusercontent.com',
  );

  static const String googleClientSecret = String.fromEnvironment(
    'GOOGLE_CLIENT_SECRET',
    defaultValue: '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',
  );

  // General Configuration
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.example.com',
  );

  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  static bool get isProduction => environment == 'production';
  static bool get isDevelopment => environment == 'development';
}
