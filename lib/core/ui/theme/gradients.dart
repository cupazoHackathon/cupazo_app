import 'package:flutter/material.dart';
import 'colors.dart';

/// Sistema de Gradientes de Marca
/// Basado en el branding azul: #1605AC (azul fuerte principal), #1976D2 (azul secundario), #0D47A1 (azul profundo)
class AppGradients {
  AppGradients._();

  // ══════════════════════════════════════════════════════════════════════════
  // GRADIENTES PRINCIPALES - Para fondos y superficies hero
  // ══════════════════════════════════════════════════════════════════════════

  /// Gradiente primario vibrante: Azul fuerte → Azul secundario
  /// Uso: Splash, welcome hero, CTAs principales
  static const LinearGradient flameHero = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.primaryBlue, AppColors.secondaryBlue],
  );

  /// Gradiente energético: Azul profundo → Azul fuerte → Azul secundario
  /// Uso: Backgrounds completos, promo banners
  static const LinearGradient energyFlow = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.deepBlue, AppColors.primaryBlue, AppColors.secondaryBlue],
    stops: [0.0, 0.5, 1.0],
  );

  /// Gradiente suave difuminado para fondos (más sutil)
  /// Uso: Login, signup, forgot password backgrounds
  static const LinearGradient softAmbient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE3F2FD), // Azul claro suave
      Color(0xFFE1F5FE), // Azul cielo claro
      Color(0xFFF0F8FF), // Azul alice claro
    ],
  );
}
