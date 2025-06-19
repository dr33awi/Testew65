// lib/app/themes/core/colors.dart
import 'package:flutter/material.dart';

/// نظام الألوان الموحد للتطبيق الإسلامي
/// جميع الألوان في مكان واحد لسهولة الصيانة
class AppColors {
  AppColors._();

  // ==================== الألوان الأساسية ====================
  
  /// اللون الأساسي - أخضر زيتي أنيق
  static const Color primary = Color(0xFF5D7052);
  static const Color primaryLight = Color(0xFF7A8B6F);
  static const Color primaryDark = Color(0xFF445A3B);
  static const Color primarySoft = Color(0xFF8FA584);
  
  /// اللون الثانوي - ذهبي دافئ
  static const Color secondary = Color(0xFFB8860B);
  static const Color secondaryLight = Color(0xFFDAA520);
  static const Color secondaryDark = Color(0xFF996515);
  
  /// اللون الثالث - بني دافئ
  static const Color tertiary = Color(0xFF8B6F47);
  static const Color tertiaryLight = Color(0xFFA68B5B);
  static const Color tertiaryDark = Color(0xFF6B5637);

  // ==================== الألوان الدلالية ====================
  
  static const Color success = primary;
  static const Color successLight = primaryLight;
  static const Color error = Color(0xFFB85450);
  static const Color errorLight = Color(0xFFC76B67);
  static const Color warning = Color(0xFFD4A574);
  static const Color warningLight = Color(0xFFE8C899);
  static const Color info = Color(0xFF6B8E9F);
  static const Color infoLight = Color(0xFF8FA9B8);

  // ==================== الوضع الفاتح ====================
  
  static const Color lightBackground = Color(0xFFFAFAF8);
  static const Color lightSurface = Color(0xFFF5F5F0);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightDivider = Color(0xFFE0DDD4);
  static const Color lightTextPrimary = Color(0xFF2D2D2D);
  static const Color lightTextSecondary = Color(0xFF5F5F5F);
  static const Color lightTextHint = Color(0xFF8F8F8F);

  // ==================== الوضع الداكن ====================
  
  static const Color darkBackground = Color(0xFF1A1F1A);
  static const Color darkSurface = Color(0xFF242B24);
  static const Color darkCard = Color(0xFF2D352D);
  static const Color darkDivider = Color(0xFF3A453A);
  static const Color darkTextPrimary = Color(0xFFF5F5F0);
  static const Color darkTextSecondary = Color(0xFFBDBDB0);
  static const Color darkTextHint = Color(0xFF8A8A80);

  // ==================== ألوان خاصة بالميزات ====================
  
  /// ألوان الصلوات
  static const Map<String, Color> prayerColors = {
    'fajr': Color(0xFF6B8E9F),      // أزرق رمادي هادئ
    'dhuhr': Color(0xFFB8860B),     // ذهبي دافئ
    'asr': Color(0xFFD4A574),       // برتقالي دافئ
    'maghrib': Color(0xFF8B6F47),   // بني دافئ
    'isha': Color(0xFF5D7052),      // أخضر زيتي
  };

  /// ألوان إضافية للميزات
  static const Color athkarBackground = Color(0xFFF0F4EC);
  static const Color qiblaAccent = secondary;
  static const Color tasbihAccent = tertiary;

  // ==================== ألوان مساعدة ====================
  
  static const Color backgroundOverlay = Color(0x80000000);
  static const Color cardOverlay = Color(0x10000000);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);

  // ==================== المساعدات ====================
  
  /// الحصول على لون الصلاة
  static Color getPrayerColor(String prayerName) {
    final normalizedName = prayerName.toLowerCase();
    
    // التحقق من الأسماء العربية
    switch (normalizedName) {
      case 'الفجر':
        return prayerColors['fajr']!;
      case 'الظهر':
        return prayerColors['dhuhr']!;
      case 'العصر':
        return prayerColors['asr']!;
      case 'المغرب':
        return prayerColors['maghrib']!;
      case 'العشاء':
        return prayerColors['isha']!;
      default:
        return prayerColors[normalizedName] ?? primary;
    }
  }

  /// الحصول على لون متباين للنص
  static Color getContrastingTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5 
        ? lightTextPrimary 
        : darkTextPrimary;
  }

  /// دمج لونين بنسبة معينة
  static Color blendColors(Color color1, Color color2, double ratio) {
    ratio = ratio.clamp(0.0, 1.0);
    
    return Color.lerp(color1, color2, ratio) ?? color1;
  }

  /// تطبيق شفافية على لون
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity.clamp(0.0, 1.0));
  }

  // ==================== ColorScheme للثيمات ====================
  
  /// ColorScheme للوضع الفاتح
  static ColorScheme get lightColorScheme => ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.light,
    primary: primary,
    secondary: secondary,
    tertiary: tertiary,
    surface: lightSurface,
    surfaceContainerHighest: lightCard,
    error: error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: lightTextPrimary,
    onError: Colors.white,
    outline: lightDivider,
    shadow: withOpacity(Colors.black, 0.1),
  );

  /// ColorScheme للوضع الداكن
  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
    seedColor: primary,
    brightness: Brightness.dark,
    primary: primaryLight,
    secondary: secondaryLight,
    tertiary: tertiaryLight,
    surface: darkSurface,
    surfaceContainerHighest: darkCard,
    error: errorLight,
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: darkTextPrimary,
    onError: Colors.black,
    outline: darkDivider,
    shadow: withOpacity(Colors.black, 0.3),
  );
}

/// Extension للألوان مع تأثيرات
extension ColorExtensions on Color {
  /// تغميق اللون
  Color darken(double amount) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  /// تفتيح اللون
  Color lighten(double amount) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  /// زيادة التشبع
  Color saturate(double amount) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withSaturation((hsl.saturation + amount).clamp(0.0, 1.0)).toColor();
  }

  /// تقليل التشبع
  Color desaturate(double amount) {
    final hsl = HSLColor.fromColor(this);
    return hsl.withSaturation((hsl.saturation - amount).clamp(0.0, 1.0)).toColor();
  }

  /// مع شفافية آمنة
  Color withOpacitySafe(double opacity) {
    return withValues(alpha: opacity.clamp(0.0, 1.0));
  }
}