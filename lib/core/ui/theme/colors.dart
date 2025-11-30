import 'package:flutter/material.dart';

/// Colores de la aplicación basados en el ícono de Cupazo
class AppColors {
  // Brand Palette - Vibrant & Modern
  static const Color primaryYellow = Color(0xFFFFD600); // Vibrant Yellow
  static const Color primaryPurple = Color(0xFF6C63FF); // Modern Purple Accent
  static const Color deepBlack = Color(0xFF121212); // Modern Dark
  static const Color pureWhite = Color(0xFFFFFFFF);

  // Secondary & Accents
  static const Color secondaryOrange = Color(
    0xFFFF6B6B,
  ); // Vibrant Coral/Orange
  static const Color secondaryTeal = Color(0xFF4ECDC4); // Fresh Teal
  static const Color secondaryBlue = Color(0xFF45B7D1); // Fresh Blue

  // Neutrals
  static const Color ink = Color(0xFF1A1A1A);
  static const Color inkLight = Color(0xFF4A4A4A);
  static const Color inkLighter = Color(0xFF8F9BB3);
  static const Color background = Color(
    0xFFF7F9FC,
  ); // Cool light gray background
  static const Color surface = Color(0xFFFFFFFF);
  static const Color line = Color(0xFFE4E9F2);

  // Status
  static const Color success = Color(0xFF00E096);
  static const Color warning = Color(0xFFFFAA00);
  static const Color error = Color(0xFFFF3D71);
  static const Color info = Color(0xFF2E5BFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryYellow, Color(0xFFFFE55C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [primaryPurple, Color(0xFF8F89FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: const Color(0xFF9AA5B1).withOpacity(0.1),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  // Legacy compatibility (mapping to new colors)
  static const Color inkMuted = inkLight;
  static const Color inkSoft = inkLighter;
  static const Color surfaceMuted = background;
  static const Color surfaceHint = line;
  static const Color secondaryYellow = Color(0xFFFBC02D); // Darker yellow
  static const Color primaryBlueLegacy = secondaryBlue;
  static const Color lightBlue = Color(0xFFE3F2FD);
  static const Color statusSuccess = success;
  static const Color statusWarning = warning;
  static const Color statusError = error;

  // Missing legacy mappings
  static const Color accentDanger = error;
  static const Color accentPrimary = primaryYellow;
  static const Color onPrimary =
      deepBlack; // Assuming text on primary yellow is black
  static const Color accentSecondary =
      secondaryOrange; // Mapping to new secondary
}
