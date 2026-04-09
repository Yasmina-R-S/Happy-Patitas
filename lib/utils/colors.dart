import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette (Vibrant and Modern)
  static const Color primary = Color(0xFF6C63FF); // Modern Purple/Blue
  static const Color secondary = Color(0xFFFF6584); // Vibrant Pink
  static const Color accent = Color(0xFF48CAE4); // Bright Cyan
  
  // Functional Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFB703);
  static const Color error = Color(0xFFFF4D4D);
  static const Color info = Color(0xFF2196F3);

  // Status Colors
  static const Color statusHappy = Color(0xFF4CAF50);
  static const Color statusResting = Color(0xFFFFB703);
  static const Color statusActive = Color(0xFF6C63FF);
  static const Color errorRed = Color(0xFFFF4D4D);

  // Backgrounds & Surfaces (Light)
  static const Color bgLight = Color(0xFFF8F9FE);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textMainLight = Color(0xFF2D3436);
  static const Color textSubLight = Color(0xFF636E72);

  // Backgrounds & Surfaces (Dark)
  static const Color bgDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color textMainDark = Color(0xFFF1F5F9);
  static const Color textSubDark = Color(0xFF94A3B8);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, Color(0xFF8E8AFF)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, Color(0xFFFF8FA3)],
  );

  // 🔧 Aliases para compatibilidad con código generado
  static const Color primaryBlue = primary;
  static const Color lightBlue = accent;
  static const Color ultraLightBlue = Color(0xFFE3F2FD);
}
