/// Servicio de almacenamiento seguro
/// TODO: Instalar flutter_secure_storage y descomentar la implementación real
class StorageService {
  // Temporal: usando Map en memoria hasta instalar flutter_secure_storage
  // static const _storage = FlutterSecureStorage();

  // Implementación temporal con Map en memoria
  static final Map<String, String> _tempStorage = {};

  // Keys
  static const String _keyToken = 'auth_token';
  static const String _keyHasSeenWelcome = 'has_seen_welcome';
  static const String _keyHasCompletedOnboarding = 'has_completed_onboarding';

  // Token
  static Future<String?> getToken() async {
    // return await _storage.read(key: _keyToken);
    return _tempStorage[_keyToken];
  }

  static Future<void> saveToken(String token) async {
    // await _storage.write(key: _keyToken, value: token);
    _tempStorage[_keyToken] = token;
  }

  static Future<void> deleteToken() async {
    // await _storage.delete(key: _keyToken);
    _tempStorage.remove(_keyToken);
  }

  // Welcome
  static Future<bool> hasSeenWelcome() async {
    // final value = await _storage.read(key: _keyHasSeenWelcome);
    final value = _tempStorage[_keyHasSeenWelcome];
    return value == 'true';
  }

  static Future<void> setHasSeenWelcome(bool value) async {
    // await _storage.write(key: _keyHasSeenWelcome, value: value.toString());
    _tempStorage[_keyHasSeenWelcome] = value.toString();
  }

  // Onboarding
  static Future<bool> hasCompletedOnboarding() async {
    // final value = await _storage.read(key: _keyHasCompletedOnboarding);
    final value = _tempStorage[_keyHasCompletedOnboarding];
    return value == 'true';
  }

  static Future<void> setHasCompletedOnboarding(bool value) async {
    // await _storage.write(key: _keyHasCompletedOnboarding, value: value.toString());
    _tempStorage[_keyHasCompletedOnboarding] = value.toString();
  }
}
