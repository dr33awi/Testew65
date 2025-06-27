// lib/app/themes/core/app_colors.dart
import 'package:flutter/material.dart';

/// نظام الألوان الموحد للتطبيق
class AppColors {
  AppColors._();
  
  // ========== الألوان الأساسية ==========
  
  /// اللون الأساسي للتطبيق (الأخضر الإسلامي)
  static const Color primary = Color(0xFF0D7377);
  static const Color primaryLight = Color(0xFF14A085);
  static const Color primaryDark = Color(0xFF004D40);
  
  /// اللون الثانوي (الذهبي)
  static const Color secondary = Color(0xFFFFB74D);
  static const Color secondaryLight = Color(0xFFFFCC80);
  static const Color secondaryDark = Color(0xFFFF8F00);
  
  /// اللون المساعد (البنفسجي الهادئ)
  static const Color accent = Color(0xFF6366F1);
  static const Color accentLight = Color(0xFF818CF8);
  static const Color accentDark = Color(0xFF4338CA);
  
  /// اللون الإضافي (الوردي الهادئ)
  static const Color tertiary = Color(0xFFEC4899);
  static const Color tertiaryLight = Color(0xFFF472B6);
  static const Color tertiaryDark = Color(0xDBE91E63);
  
  // ========== ألوان الحالة ==========
  
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);
  
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);
  
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);
  
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);
  
  // ========== الألوان المحايدة ==========
  
  /// النصوص
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textHint = Color(0xFFD1D5DB);
  static const Color textDisabled = Color(0xFFE5E7EB);
  
  /// الخلفيات - الوضع الفاتح
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  
  /// الحدود والفواصل
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFD1D5DB);
  static const Color outline = Color(0xFF9CA3AF);
  
  // ========== الألوان الداكنة ==========
  
  /// النصوص - الوضع الداكن
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textTertiaryDark = Color(0xFF9CA3AF);
  static const Color textHintDark = Color(0xFF6B7280);
  static const Color textDisabledDark = Color(0xFF4B5563);
  
  /// الخلفيات - الوضع الداكن
  static const Color backgroundDark = Color(0xFF111827);
  static const Color surfaceDark = Color(0xFF1F2937);
  static const Color cardDark = Color(0xFF374151);
  
  /// الحدود والفواصل - الوضع الداكن
  static const Color dividerDark = Color(0xFF374151);
  static const Color borderDark = Color(0xFF4B5563);
  static const Color outlineDark = Color(0xFF6B7280);
  
  // ========== ألوان الصلوات ==========
  
  static const Map<String, Color> prayerColors = {
    'fajr': Color(0xFF6366F1),      // بنفسجي للفجر
    'dhuhr': Color(0xFFF59E0B),     // ذهبي للظهر
    'asr': Color(0xFFFF8F00),       // برتقالي للعصر
    'maghrib': Color(0xFFEC4899),   // وردي للمغرب
    'isha': Color(0xFF6366F1),      // بنفسجي للعشاء
    'sunrise': Color(0xFFFBBF24),   // أصفر للشروق
  };
  
  // ========== ألوان الفئات ==========
  
  static const Map<String, Color> categoryColors = {
    'prayer_times': primary,
    'athkar': accent,
    'qibla': tertiary,
    'tasbih': success,
    'quran': secondary,
    'dua': warning,
    'favorites': error,
    'settings': info,
  };
  
  // ========== التدرجات اللونية ==========
  
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [secondary, secondaryDark],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentDark],
  );
  
  static const LinearGradient tertiaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [tertiary, tertiaryDark],
  );
  
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [success, successDark],
  );
  
  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [warning, warningDark],
  );
  
  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [error, errorDark],
  );
  
  static const LinearGradient infoGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [info, infoDark],
  );
  
  // ========== التدرجات حسب الوقت ==========
  
  /// تدرجات تتغير حسب وقت اليوم
  static LinearGradient getTimeBasedGradient({DateTime? dateTime}) {
    final now = dateTime ?? DateTime.now();
    final hour = now.hour;
    
    if (hour >= 5 && hour < 7) {
      // الفجر - بنفسجي وأزرق
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6366F1), Color(0xFF3B82F6)],
      );
    } else if (hour >= 7 && hour < 12) {
      // الصباح - ذهبي وأصفر
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFBBF24), Color(0xFFEAB308)],
      );
    } else if (hour >= 12 && hour < 15) {
      // الظهر - برتقالي وأحمر فاتح
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
      );
    } else if (hour >= 15 && hour < 18) {
      // العصر - برتقالي داكن
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFFF8F00), Color(0xFFEF4444)],
      );
    } else if (hour >= 18 && hour < 20) {
      // المغرب - وردي وبنفسجي
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
      );
    } else {
      // الليل - بنفسجي وأزرق داكن
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF6366F1), Color(0xFF1E40AF)],
      );
    }
  }
  
  // ========== دوال مساعدة ==========
  
  /// الحصول على لون الصلاة
  static Color getPrayerColor(String prayerName) {
    return prayerColors[prayerName.toLowerCase()] ?? primary;
  }
  
  /// الحصول على لون الفئة
  static Color getCategoryColor(String categoryId) {
    return categoryColors[categoryId] ?? primary;
  }
  
  /// دوال لتعديل الألوان
  static Color lighten(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }
  
  static Color darken(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
  
  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }
}

/// Extension methods للألوان
extension ColorExtensions on Color {
  /// تفتيح اللون
  Color lighten([double amount = 0.1]) => AppColors.lighten(this, amount);
  
  /// تغميق اللون
  Color darken([double amount = 0.1]) => AppColors.darken(this, amount);
  
  /// تحويل إلى MaterialColor
  MaterialColor toMaterialColor() {
    final Map<int, Color> swatch = {
      50: lighten(0.4),
      100: lighten(0.3),
      200: lighten(0.2),
      300: lighten(0.1),
      400: this,
      500: this,
      600: darken(0.1),
      700: darken(0.2),
      800: darken(0.3),
      900: darken(0.4),
    };
    return MaterialColor(red << 16 | green << 8 | blue, swatch);
  }
}