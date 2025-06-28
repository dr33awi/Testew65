// lib/app/themes/unified_theme.dart
import 'package:flutter/material.dart';

/// Theme data extracted from existing UI design.
/// All colors, text styles and card shapes mirror the
/// currently implemented look of the app.
class UnifiedTheme {
  UnifiedTheme._();

  // ===== Colors =====
  static const Color primary = Color(0xFF5D7052);
  static const Color primaryLight = Color(0xFF7A8B6F);
  static const Color primaryDark = Color(0xFF445A3B);
  static const Color accent = Color(0xFFB8860B);
  static const Color accentLight = Color(0xFFDAA520);
  static const Color accentDark = Color(0xFF996515);

  static const Color backgroundLight = Color(0xFFFAFAF8);
  static const Color surfaceLight = Color(0xFFF5F5F0);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color dividerLight = Color(0xFFE0DDD4);
  static const Color textPrimaryLight = Color(0xFF2D2D2D);
  static const Color textSecondaryLight = Color(0xFF5F5F5F);

  static const Color backgroundDark = Color(0xFF1A1F1A);
  static const Color surfaceDark = Color(0xFF242B24);
  static const Color cardDark = Color(0xFF2D352D);
  static const Color dividerDark = Color(0xFF3A453A);
  static const Color textPrimaryDark = Color(0xFFF5F5F0);
  static const Color textSecondaryDark = Color(0xFFBDBDB0);

  static const Color error = Color(0xFFB85450);

  // ===== Typography =====
  static const String fontFamily = 'Cairo';

  static const TextStyle h4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );

  static TextTheme createTextTheme(Color primaryColor, Color secondaryColor) {
    return TextTheme(
      titleLarge: h4.copyWith(color: primaryColor),
      bodyLarge: body.copyWith(color: primaryColor),
      bodyMedium: body.copyWith(color: secondaryColor),
      labelLarge: label.copyWith(color: primaryColor),
      labelMedium: label.copyWith(color: secondaryColor),
    );
  }

  // ===== Card Decoration =====
  static BoxDecoration cardDecoration(Color color, {double radius = 16}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    );
  }

  static BoxDecoration outlinedCard(Color color,
      {double radius = 16, required Color borderColor}) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor.withOpacity(0.2)),
    );
  }

  // ===== ThemeData =====
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primary,
    scaffoldBackgroundColor: backgroundLight,
    cardColor: cardLight,
    textTheme: createTextTheme(textPrimaryLight, textSecondaryLight),
    dividerColor: dividerLight,
    fontFamily: fontFamily,
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: primaryLight,
    scaffoldBackgroundColor: backgroundDark,
    cardColor: cardDark,
    textTheme: createTextTheme(textPrimaryDark, textSecondaryDark),
    dividerColor: dividerDark,
    fontFamily: fontFamily,
    useMaterial3: true,
  );
}
