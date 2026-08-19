import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Background Colors
  static const Color background = Color(0xFF0A0D14);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceCard = Color(0xFF1A2235);
  static const Color surfaceElevated = Color(0xFF1E2B42);

  // Primary Accent
  static const Color primary = Color(0xFF00C7BE);
  static const Color primaryLight = Color(0xFF4DDFDA);
  static const Color primaryDark = Color(0xFF008F89);

  // Secondary Accent
  static const Color secondary = Color(0xFF6C63FF);
  static const Color secondaryLight = Color(0xFF9C95FF);

  // Status Colors
  static const Color good = Color(0xFF00C896);
  static const Color warning = Color(0xFFFFB547);
  static const Color danger = Color(0xFFFF5E7D);
  static const Color info = Color(0xFF4EA8DE);

  // Heart/Cardio
  static const Color heart = Color(0xFFFF4567);
  static const Color heartLight = Color(0xFFFF7A96);

  // Lung
  static const Color lung = Color(0xFF00BFFF);
  static const Color lungLight = Color(0xFF73D8FF);

  // Brain
  static const Color brain = Color(0xFFBF5FFF);

  // Liver
  static const Color liver = Color(0xFFFF8C42);

  // Kidney
  static const Color kidney = Color(0xFFFFD166);

  // Gut
  static const Color gut = Color(0xFF06D6A0);

  // Immune
  static const Color immune = Color(0xFF118AB2);

  // Text Colors
  static const Color textPrimary = Color(0xFFEDF2FF);
  static const Color textSecondary = Color(0xFF8B9BC8);
  static const Color textMuted = Color(0xFF4A5568);
  static const Color textLabel = Color(0xFF718096);

  // Gradient Colors
  static const Gradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00C7BE), Color(0xFF6C63FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient heartGradient = LinearGradient(
    colors: [Color(0xFFFF4567), Color(0xFFFF8A9B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient lungGradient = LinearGradient(
    colors: [Color(0xFF00BFFF), Color(0xFF73D8FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient brainGradient = LinearGradient(
    colors: [Color(0xFFBF5FFF), Color(0xFFE0AAFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Gradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A0D14), Color(0xFF111827)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        surface: AppColors.surface,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
      ),
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.w700,
          ),
          displayMedium: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
          displaySmall: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          headlineMedium: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          titleLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          titleMedium: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          bodyMedium: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          labelLarge: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
