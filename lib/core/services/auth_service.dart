import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/env.dart';
import '../utils/logger.dart';

/// Servicio de autenticación usando Supabase y Google Sign-In
/// Basado en la implementación de VivloApp
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final SupabaseClient _supabase = Supabase.instance.client;


  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: Env.googleWebClientId,
  );

  User? get currentUser => _supabase.auth.currentUser;

  Session? get currentSession => _supabase.auth.currentSession;

  Future<AuthResponse> loginWithGoogle() async {
    try {
      AppLogger.info('Iniciando sesión con Google...');

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw 'Google Sign In cancelado por el usuario';
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No se encontró Access Token.';
      }
      if (idToken == null) {
        throw 'No se encontró ID Token.';
      }

      AppLogger.info('Tokens obtenidos, autenticando con Supabase...');

      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      AppLogger.info('Autenticación exitosa con Google');
      return response;
    } catch (e) {
      AppLogger.error('Error en login con Google', e);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      AppLogger.info('Cerrando sesión...');
      await _googleSignIn.signOut(); // Sign out from Google
      await _supabase.auth.signOut(); 
      AppLogger.info('Sesión cerrada correctamente');
    } catch (e) {
      AppLogger.error('Error al cerrar sesión', e);
      rethrow;
    }
  }

  // Helper to get user info
  User? getUser() {
    return _supabase.auth.currentUser;
  }
}
