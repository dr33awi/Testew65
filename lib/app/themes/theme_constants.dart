// lib/app/themes/theme_constants.dart
import 'package:flutter/material.dart';

/// ثوابت الثيم الموحد للتطبيق الإسلامي
/// جميع القيم الثابتة في مكان واحد
class ThemeConstants {
  ThemeConstants._();

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
  
  static const Color success = Color(0xFF27AE60);
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
  
  // ==================== المسافات والأحجام ====================
  
  /// المسافات الأساسية
  static const double spaceXs = 4.0;
  static const double spaceSm = 8.0;
  static const double spaceMd = 16.0;
  static const double spaceLg = 24.0;
  static const double spaceXl = 32.0;
  static const double space2xl = 48.0;
  
  /// الزوايا المدورة
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 20.0;
  
  /// أحجام الأيقونات
  static const double iconSm = 18.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  
  /// أحجام الأزرار
  static const double buttonHeightSm = 36.0;
  static const double buttonHeightMd = 48.0;
  static const double buttonHeightLg = 56.0;
  
  // ==================== الخطوط ====================
  
  /// عائلات الخطوط
  static const String fontPrimary = 'Cairo';
  static const String fontArabic = 'Amiri';
  static const String fontQuran = 'Uthmanic';
  
  /// أحجام الخطوط
  static const double fontSizeXs = 12.0;
  static const double fontSizeSm = 14.0;
  static const double fontSizeMd = 16.0;
  static const double fontSizeLg = 18.0;
  static const double fontSizeXl = 20.0;
  static const double fontSize2xl = 24.0;
  static const double fontSize3xl = 28.0;
  
  /// أوزان الخطوط
  static const FontWeight fontLight = FontWeight.w300;
  static const FontWeight fontRegular = FontWeight.w400;
  static const FontWeight fontMedium = FontWeight.w500;
  static const FontWeight fontSemiBold = FontWeight.w600;
  static const FontWeight fontBold = FontWeight.w700;
  
  // ==================== الظلال ====================
  
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      offset: const Offset(0, 1),
      blurRadius: 2,
    ),
  ];
  
  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      offset: const Offset(0, 4),
      blurRadius: 8,
    ),
  ];
  
  static List<BoxShadow> get shadowLg => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      offset: const Offset(0, 8),
      blurRadius: 16,
    ),
  ];
  
  // ==================== التدرجات ====================
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // ==================== المدد الزمنية ====================
  
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);
  
  // ==================== الدوال المساعدة ====================
  
  /// الحصول على لون النص المتباين
  static Color getContrastColor(Color background) {
    return background.computeLuminance() > 0.5 ? lightText : darkText;
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
  
  /// إنشاء ColorScheme للوضع الفاتح
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
  
  /// إنشاء ColorScheme للوضع الداكن
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