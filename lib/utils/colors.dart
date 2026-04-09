import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFF90CAF9);
  static const Color ultraLightBlue = Color(0xFFE8F4FD);
  static const Color pureWhite = Color(0xFFFFFFFF);

  // Functional Colors
  static const Color accentBlue = Color(0xFF42A5F5);
  static const Color statusHappy = Color(0xFF4CAF50);
  static const Color statusResting = Color(0xFFFFA000);
  static const Color statusActive = Color(0xFF2196F3);
  static const Color errorRed = Color(0xFFD32F2F);

  // Backgrounds & Surfaces (Light)
  static const Color bgLight = Color(0xFFF8FBFE);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textMainLight = Color(0xFF1A1A1A);
  static const Color textSubLight = Color(0xFF757575);

  // Backgrounds & Surfaces (Dark)
  static const Color bgDark = Color(0xFF0A121E);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textMainDark = Color(0xFFF1F5F9);
  static const Color textSubDark = Color(0xFF94A3B8);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [
      primaryBlue,
      lightBlue,
      ultraLightBlue,
      pureWhite,
    ],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [
      Color(0xFF0F172A),
      Color(0xFF1E293B),
      Color(0xFF334155),
    ],
  );
}
