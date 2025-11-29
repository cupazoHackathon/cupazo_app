import 'package:flutter/material.dart';

/// Tipografía de la aplicación usando Plus Jakarta Sans
/// Fuente: Plus Jakarta Sans - Geométrica, moderna, un poco redondeada
class AppTypography {
  static const String _fontFamily = 'Plus Jakarta Sans';

  // Display - Headers grandes
  static const TextStyle displayL = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 34,
    fontWeight: FontWeight.bold, // Bold para headers grandes
    letterSpacing: -1,
    height: 1.2,
  );

  static const TextStyle displayM = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold, // Bold para headers
    letterSpacing: -0.5,
    height: 1.2,
  );

  // Titles - Headers
  static const TextStyle title = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600, // SemiBold para títulos
    height: 1.3,
  );

  static const TextStyle subtitle = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600, // SemiBold para subtítulos
    height: 1.3,
  );

  // Body - Textos largos
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal, // Regular para textos largos
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal, // Regular para textos pequeños
    height: 1.4,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500, // Medium para captions
    height: 1.3,
  );

  // Numeric - Ideal para ETAs, presión, glucosa
  static const TextStyle price = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold, // Bold para números importantes
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle eta = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600, // SemiBold para ETAs
    height: 1.2,
  );

  // Botones - SemiBold
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold para botones
    height: 1.4,
  );

  // Flutter TextTheme mapping
  static const TextStyle headline1 = displayL;
  static const TextStyle headline2 = displayM;
  static const TextStyle headline3 = title;
  static const TextStyle headline4 = subtitle;
  static const TextStyle body1 = body;
  static const TextStyle body2 = bodySmall;
  static const TextStyle captionStyle = caption;
}
