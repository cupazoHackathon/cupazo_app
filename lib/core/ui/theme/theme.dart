import 'package:flutter/material.dart';
import 'colors.dart';

/// Tema de la aplicación
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Plus Jakarta Sans',
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primaryYellow,
        onPrimary: AppColors.deepBlack,
        secondary: AppColors.primaryPurple,
        onSecondary: AppColors.pureWhite,
        error: AppColors.error,
        onError: AppColors.pureWhite,
        surface: AppColors.surface,
        onSurface: AppColors.ink,
        outline: AppColors.line,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.ink,
        surfaceTintColor: Colors.transparent,
      ),
      // cardTheme removed to avoid type error
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryYellow,
          foregroundColor: AppColors.deepBlack,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.primaryPurple,
            width: 2,
          ),
        ),
        hintStyle: const TextStyle(color: AppColors.inkLighter, fontSize: 14),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Plus Jakarta Sans',
      scaffoldBackgroundColor: AppColors.deepBlack,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primaryYellow,
        onPrimary: AppColors.deepBlack,
        secondary: AppColors.primaryPurple,
        onSecondary: AppColors.pureWhite,
        error: AppColors.error,
        onError: AppColors.pureWhite,
        surface: const Color(0xFF1E1E1E),
        onSurface: AppColors.pureWhite,
        outline: AppColors.inkLight,
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.deepBlack,
        foregroundColor: AppColors.pureWhite,
      ),
    );
  }
}
