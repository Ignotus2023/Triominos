import 'package:flutter/material.dart';

abstract class AppColors {
  AppColors._();

  static const Color indigo50 = Color(0xFFEEF2FF);
  static const Color indigo100 = Color(0xFFE0E7FF);
  static const Color indigo300 = Color(0xFFA5B4FC);
  static const Color indigo400 = Color(0xFF818CF8);
  static const Color indigo500 = Color(0xFF6366F1);
  static const Color indigo600 = Color(0xFF4F46E5);
  static const Color indigo700 = Color(0xFF4338CA);
  static const Color indigo900 = Color(0xFF312E81);
  static const Color indigo950 = Color(0xFF1E1B4B);

  static const Color violet300 = Color(0xFFC4B5FD);
  static const Color violet400 = Color(0xFFA78BFA);
  static const Color violet500 = Color(0xFF8B5CF6);

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  static const Color lightBackground = Color(0xFFF5F3FF);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = indigo950;
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightGlassFill = Color(0xA6FFFFFF);
  static const Color lightGlassBorder = Color(0x66FFFFFF);
  static const Color lightShadow = Color(0x14312E81);

  static const Color darkBackground = Color(0xFF0F0A2E);
  static const Color darkSurface = indigo950;
  static const Color darkSurfaceElevated = Color(0xFF2A2660);
  static const Color darkText = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkGlassFill = Color(0x14FFFFFF);
  static const Color darkGlassBorder = Color(0x1FFFFFFF);
  static const Color darkShadow = Color(0x66000000);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [indigo500, indigo700],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient violetGradient = LinearGradient(
    colors: [violet400, indigo500],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient activePlayerGlow = LinearGradient(
    colors: [
      Color(0x33818CF8),
      Color(0x1A6366F1),
      Color(0x00000000),
    ],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const List<Color> avatarPalette = [
    Color(0xFF6366F1),
    Color(0xFFA78BFA),
    Color(0xFFEC4899),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFF06B6D4),
    Color(0xFFEF4444),
    Color(0xFF8B5CF6),
    Color(0xFF14B8A6),
    Color(0xFFF97316),
  ];
}
