// TODO Implement this library.// lib/app/themes/simple/colors.dart
import 'package:flutter/material.dart';

/// ألوان التطبيق الإسلامي - نسخة مبسطة
class AppColors {
  AppColors._();

  // ==================== الألوان الأساسية ====================
  
  /// اللون الأساسي - أخضر زيتي هادئ
  static const Color primary = Color(0xFF2E7D57);
  static const Color primaryLight = Color(0xFF4CAF79);
  static const Color primaryDark = Color(0xFF1E5A3E);
  
  /// اللون الثانوي - ذهبي أنيق
  static const Color secondary = Color(0xFFD4AF37);
  static const Color secondaryLight = Color(0xFFE6C76A);
  static const Color secondaryDark = Color(0xFFB8941F);
  
  /// اللون الثالث - بني دافئ
  static const Color accent = Color(0xFF8B6B47);
  
  // ==================== ألوان الحالة ====================
  
  static const Color success = Color(0xFF2E7D57);
  static const Color error = Color(0xFFE74C3C);
  static const Color warning = Color(0xFFF39C12);
  static const Color info = Color(0xFF3498DB);
  
  // ==================== الوضع الفاتح ====================
  
  static const Color lightBackground = Color(0xFFFAFAF8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightBorder = Color(0xFFE8E8E8);
  
  static const Color lightText = Color(0xFF2C3E50);
  static const Color lightTextSecondary = Color(0xFF7F8C8D);
  static const Color lightTextHint = Color(0xFFBDC3C7);
  
  // ==================== الوضع الداكن ====================
  
  static const Color darkBackground = Color(0xFF1A1A1A);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkCard = Color(0xFF383838);
  static const Color darkBorder = Color(0xFF4A4A4A);
  
  static const Color darkText = Color(0xFFECF0F1);
  static const Color darkTextSecondary = Color(0xFFBDC3C7);
  static const Color darkTextHint = Color(0xFF7F8C8D);
  
  // ==================== ألوان الصلوات ====================
  
  static const Map<String, Color> prayerColors = {
    'fajr': Color(0xFF5DADE2),     // أزرق فجر
    'dhuhr': Color(0xFFF7DC6F),    // أصفر ظهر
    'asr': Color(0xFFE67E22),      // برتقالي عصر
    'maghrib': Color(0xFFAD7E6C),  // بني مغرب
    'isha': Color(0xFF8E44AD),     // بنفسجي عشاء
  };
  
  // ==================== الحصول على اللون المناسب ====================
  
  /// الحصول على لون النص المتباين
  static Color getContrastColor(Color background) {
    return background.computeLuminance() > 0.5 
        ? lightText 
        : darkText;
  }
  
  /// الحصول على لون الصلاة
  static Color getPrayerColor(String prayerName) {
    final normalizedName = prayerName.toLowerCase();
    
    switch (normalizedName) {
      case 'الفجر':
      case 'fajr':
        return prayerColors['fajr']!;
      case 'الظهر':
      case 'dhuhr':
        return prayerColors['dhuhr']!;
      case 'العصر':
      case 'asr':
        return prayerColors['asr']!;
      case 'المغرب':
      case 'maghrib':
        return prayerColors['maghrib']!;
      case 'العشاء':
      case 'isha':
        return prayerColors['isha']!;
      default:
        return primary;
    }
  }
  
  // ==================== ColorSchemes ====================
  
  static ColorScheme get lightColorScheme => ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
    primary: primary,
    secondary: secondary,
    tertiary: accent,
    surface: lightSurface,
    error: error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: lightText,
    onError: Colors.white,
  );
  
  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.dark,
    primary: primaryLight,
    secondary: secondaryLight,
    tertiary: accent,
    surface: darkSurface,
    error: error,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: darkText,
    onError: Colors.white,
  );
}