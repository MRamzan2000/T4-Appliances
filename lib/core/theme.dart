import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    brightness: Brightness.dark,
    primaryColor: const Color(0xFF1A4C9A),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF1A4C9A),
      secondary: Color(0xFFc5a059),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Colors.white),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    fontFamily: 'Roboto',
  );
}