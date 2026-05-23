import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Skala typograficzna (§11.3) oparta o font Inter.
abstract class AppTypography {
  static TextTheme textTheme(Color color, Color secondary) {
    final base = TextTheme(
      displayLarge: TextStyle(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.05,
      ),
      displayMedium: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w700,
        color: color,
        height: 1.1,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: color,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: secondary,
      ),
    );

    return GoogleFonts.interTextTheme(base);
  }
}
