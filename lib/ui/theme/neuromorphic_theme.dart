import 'package:flutter/material.dart';

class NeuromorphicTheme {
  // Color Palette - Airy, Minimalist Orange
  static const Color background = Color(0xFFFFF8F0);
  static const Color cardBackground = Color(0xFFFEFAF3);
  static const Color primary = Color(0xFFFF9800);
  static const Color primaryLight = Color(0xFFFFB74D);
  static const Color primaryDark = Color(0xFFF57C00);
  static const Color accent = Color(0xFFFF8F00);
  static const Color text = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  static const Color error = Color(0xFFE57373);
  static const Color success = Color(0xFF81C784);
  static const Color warning = Color(0xFFFFB74D);
  
  // Shadows for Neuromorphic effect
  static const Color shadowLight = Color(0xFFFFFFFF);
  static const Color shadowDark = Color(0xFFE8E0D6);
  
  static ThemeData get themeData => ThemeData(
    fontFamily: 'SF Pro Display',
    scaffoldBackgroundColor: background,
    primaryColor: primary,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: primary,
      secondary: accent,
      surface: cardBackground,
      error: error,
    ),
    
    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      iconTheme: IconThemeData(color: primary),
      titleTextStyle: TextStyle(
        color: primary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    
    // Card Theme
    cardTheme: const CardThemeData(
      color: cardBackground,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
    ),
    
    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shadowColor: shadowDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      labelStyle: const TextStyle(color: textSecondary),
      hintStyle: const TextStyle(color: textLight),
    ),
    
    // Text Theme
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: text,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: text,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: text,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: TextStyle(
        color: primary,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: primary,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      titleLarge: TextStyle(
        color: text,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: TextStyle(
        color: text,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: text,
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      bodyMedium: TextStyle(
        color: textSecondary,
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),
      bodySmall: TextStyle(
        color: textLight,
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),
    ),
    
    // Floating Action Button Theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 12,
    ),
  );

  static double _getResponsiveFontSize(BuildContext context, double baseSize) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth < 600) {
      return baseSize * 0.8;
    } else if (screenWidth < 1200) {
      return baseSize;
    } else {
      return baseSize * 1.2;
    }
  }
}

// Neuromorphic Box Decoration
class NeuBoxDecoration {
  static BoxDecoration get elevated => BoxDecoration(
    color: NeuromorphicTheme.cardBackground,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow(
        color: NeuromorphicTheme.shadowLight,
        offset: Offset(-8, -8),
        blurRadius: 16,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: NeuromorphicTheme.shadowDark,
        offset: Offset(8, 8),
        blurRadius: 16,
        spreadRadius: 1,
      ),
    ],
  );
  
  static BoxDecoration get pressed => BoxDecoration(
    color: NeuromorphicTheme.cardBackground,
    borderRadius: BorderRadius.circular(20),
    boxShadow: const [
      BoxShadow(
        color: NeuromorphicTheme.shadowDark,
        offset: Offset(2, 2),
        blurRadius: 4,
        spreadRadius: 0,
      ),
    ],
  );
}
