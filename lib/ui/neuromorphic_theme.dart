import 'package:flutter/material.dart';

class NeuromorphicTheme {
  static const Color background = Color(0xFFFFF8F0);
  static const Color accent = Color(0xFFFF9800); // Orange
  static const Color shadowLight = Color(0xFFFFFFFF);
  static const Color shadowDark = Color(0xFFE0E0E0);
  static const Color text = Color(0xFF333333);

  static ThemeData get themeData => ThemeData(
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: background,
    primaryColor: accent,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: accent,
      secondary: accent,
      surface: background,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      iconTheme: IconThemeData(color: accent),
      titleTextStyle: TextStyle(
        color: accent,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: accent,
      foregroundColor: Colors.white,
      elevation: 8,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: text, fontSize: 16),
      bodyMedium: TextStyle(color: text, fontSize: 14),
      titleLarge: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 22),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: background,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
  );
}
