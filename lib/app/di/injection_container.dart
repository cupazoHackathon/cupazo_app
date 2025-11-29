import '../../core/services/auth_service.dart';

/// Contenedor de inyección de dependencias
///
/// Configura y proporciona todas las dependencias de la aplicación
class InjectionContainer {
  /// Servicio de autenticación (singleton)
  static AuthService get authService => AuthService();

  /// Inicializa todas las dependencias
  static Future<void> init() async {
    // AuthService es un singleton, se inicializa automáticamente al acceder
    // Aquí puedes agregar otras inicializaciones si son necesarias

    // TODO: Agregar más servicios según se necesiten
    // Ejemplo: await _databaseService.init();
  }
}
