import 'package:flutter/material.dart';

/// App theme configuration and custom styling
class AppTheme {
  // Light theme - inspired by Brazilian colors and nature
  static final ThemeData lightTheme = ThemeData(
    primaryColor: const Color(0xFF2E7D32), // Green - nature
    primaryColorLight: const Color(0xFF4CAF50),
    primaryColorDark: const Color(0xFF1B5E20),
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2E7D32),
      secondary: Color(0xFFFF9800), // Orange - tapioca color
      surface: Color(0xFFF5F5F5),
    ),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF2E7D32),
      foregroundColor: Colors.white,
      elevation: 2,
    ),
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xFF2E7D32),
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: Colors.black87,
      ),
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: const Color(0xFF4CAF50),
    primaryColorLight: const Color(0xFF80E27E),
    primaryColorDark: const Color(0xFF087F23),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4CAF50),
      secondary: Color(0xFFFFB74D),
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1F1F1F),
      elevation: 2,
    ),
    cardTheme: CardTheme(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  // Custom text styles
  static TextStyle routeTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!.copyWith(
          fontWeight: FontWeight.w600,
        );
  }

  static TextStyle routeDescriptionStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(
          color: Colors.grey[600],
        );
  }

  // Custom colors
  static const Color sustainableGreen = Color(0xFF2E7D32);
  static const Color culturalOrange = Color(0xFFFF9800);
  static const Color accentYellow = Color(0xFFFFEB3B);
}