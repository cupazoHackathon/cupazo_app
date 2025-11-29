/// Configuración de flavors (variantes de la app)
enum Flavor { development, staging, production }

class FlavorConfig {
  static Flavor current = Flavor.development;

  static String get apiBaseUrl {
    switch (current) {
      case Flavor.development:
        return 'https://dev-api.example.com';
      case Flavor.staging:
        return 'https://staging-api.example.com';
      case Flavor.production:
        return 'https://api.example.com';
    }
  }
}
