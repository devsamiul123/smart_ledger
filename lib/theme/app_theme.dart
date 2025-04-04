import 'package:flutter/material.dart';

class AppTheme {
  // Light theme colors
  static final ColorScheme _lightColorScheme = ColorScheme.light(
    primary: Colors.blue,
    secondary: Colors.blueAccent,
    surface: Colors.white,
    background: Colors.grey[50]!,
    error: Colors.red,
  );

  // Dark theme colors
  static final ColorScheme _darkColorScheme = ColorScheme.dark(
    primary: Colors.blue[300]!,
    secondary: Colors.blueAccent[200]!,
    surface: Color(0xFF121212),
    background: Colors.black,
    error: Colors.red[300]!,
  );

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _lightColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: _lightColorScheme.primary,
      foregroundColor: _lightColorScheme.onPrimary,
      elevation: 0,
    ),
    scaffoldBackgroundColor: _lightColorScheme.background,
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: _lightColorScheme.primaryContainer,
      labelTextStyle: MaterialStateProperty.all(
        TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _darkColorScheme,
    appBarTheme: AppBarTheme(
      backgroundColor: _darkColorScheme.surface,
      foregroundColor: _darkColorScheme.onSurface,
      elevation: 0,
    ),
    scaffoldBackgroundColor: _darkColorScheme.background,
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: _darkColorScheme.primaryContainer,
      labelTextStyle: MaterialStateProperty.all(
        TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}