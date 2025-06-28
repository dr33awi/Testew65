// lib/app/themes/core/app_colors.dart - عربي وداكن فقط
import 'package:flutter/material.dart';

/// نظام الألوان الإسلامي - الوضع الداكن فقط
class AppColors {
  AppColors._();
  
  // ========== الألوان الأساسية الإسلامية ==========
  
  /// اللون الأساسي - الأخضر الإسلامي التقليدي
  static const Color primary = Color(0xFF10B981);
  static const Color primaryLight = Color(0xFF34D399);
  static const Color primaryDark = Color(0xFF059669);
  
  /// اللون الثانوي - الذهبي الإسلامي
  static const Color secondary = Color(0xFFF59E0B);
  static const Color secondaryLight = Color(0xFFFBBF24);
  static const Color secondaryDark = Color(0xFFD97706);
  
  /// اللون المساعد - البنفسجي الهادئ
  static const Color accent = Color(0xFF8B5CF6);
  static const Color accentLight = Color(0xFFA78BFA);
  static const Color accentDark = Color(0xFF7C3AED);
  
  /// لون إضافي - البني الدافئ الإسلامي
  static const Color tertiary = Color(0xFFA16207);
  static const Color tertiaryLight = Color(0xFFCA8A04);
  static const Color tertiaryDark = Color(0xFF92400E);
  
  // ========== ألوان الحالة ==========
  
  static const Color success = Color(0xFF10B981);    // أخضر إسلامي
  static const Color warning = Color(0xFFF59E0B);    // ذهبي
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  
  // ========== النصوص للوضع الداكن فقط ==========
  
  static const Color textPrimary = Color(0xFFF9FAFB);
  static const Color textSecondary = Color(0xFFD1D5DB);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textHint = Color(0xFF6B7280);
  static const Color textDisabled = Color(0xFF4B5563);
  
  /// نصوص خاصة للمحتوى الديني
  static const Color textReligious = Color(0xFFFFFFFF);   // أبيض للنصوص المقدسة
  static const Color textArabic = Color(0xFFF9FAFB);      // للنصوص العربية
  
  // ========== الخلفيات الداكنة فقط ==========
  
  static const Color background = Color(0xFF111827);
  static const Color surface = Color(0xFF1F2937);
  static const Color card = Color(0xFF374151);
  
  /// خلفيات خاصة للمحتوى الديني
  static const Color quranBackground = Color(0xFF1E3A2E);    // أخضر داكن للقرآن
  static const Color dhikrBackground = Color(0xFF1A2E1A);    // أخضر داكن أغمق للأذكار
  static const Color hadithBackground = Color(0xFF2D1B69);   // بنفسجي داكن للأحاديث
  static const Color duaBackground = Color(0xFF92400E);      // بني داكن للأدعية
  
  // ========== الحدود والفواصل ==========
  
  static const Color divider = Color(0xFF4B5563);
  static const Color border = Color(0xFF6B7280);
  static const Color outline = Color(0xFF9CA3AF);
  
  // ========== ألوان الصلوات ==========
  
  static const Map<String, Color> prayerColors = {
    'الفجر': Color(0xFF8B5CF6),        // بنفسجي للفجر
    'الشروق': Color(0xFFF59E0B),       // ذهبي للشروق
    'الظهر': Color(0xFFEF4444),        // أحمر للظهر (حرارة الشمس)
    'العصر': Color(0xFFF97316),        // برتقالي للعصر
    'المغرب': Color(0xFFEC4899),       // وردي للمغرب
    'العشاء': Color(0xFF6366F1),       // بنفسجي داكن للعشاء
  };
  
  // ========== ألوان الفئات ==========
  
  static const Map<String, Color> categoryColors = {
    'اوقات_الصلاة': primary,
    'الاذكار': accent,
    'القبلة': tertiary,
    'التسبيح': success,
    'القران': secondary,
    'الادعية': warning,
    'المفضلة': error,
    'الاعدادات': info,
  };
  
  // ========== التدرجات ==========
  
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient tertiaryGradient = LinearGradient(
    colors: [tertiary, tertiaryDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // ========== تدرجات الأوقات ==========
  
  /// تدرج حسب وقت اليوم
  static LinearGradient getTimeBasedGradient({DateTime? dateTime}) {
    final now = dateTime ?? DateTime.now();
    final hour = now.hour;
    
    if (hour >= 6 && hour < 12) {
      // الصباح - ذهبي
      return secondaryGradient;
    } else if (hour >= 12 && hour < 18) {
      // النهار - أخضر
      return primaryGradient;
    } else {
      // المساء والليل - بني دافئ
      return tertiaryGradient;
    }
  }
  
  // ========== دوال مساعدة ==========
  
  /// الحصول على لون الصلاة
  static Color getPrayerColor(String prayerName) {
    return prayerColors[prayerName] ?? primary;
  }
  
  /// الحصول على لون الفئة
  static Color getCategoryColor(String categoryId) {
    return categoryColors[categoryId] ?? primary;
  }
  
  /// الحصول على لون النص المناسب للخلفية
  static Color getTextColorForBackground(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.3 ? Color(0xFF111827) : textPrimary;
  }
  
  /// الحصول على خلفية مناسبة للمحتوى الديني
  static Color getReligiousBackground(String type) {
    switch (type) {
      case 'قران':
      case 'آية':
        return quranBackground;
      case 'ذكر':
      case 'اذكار':
        return dhikrBackground;
      case 'حديث':
        return hadithBackground;
      case 'دعاء':
        return duaBackground;
      default:
        return surface;
    }
  }
  
  // ========== دوال التعديل ==========
  
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
  
  // ========== ألوان سريعة ==========
  
  static const Color islamicGreen = primary;
  static const Color islamicGold = secondary;
  static const Color islamicBrown = tertiary;
  static const Color prayerNext = Color(0xFF22C55E);        // للصلاة القادمة
  static const Color dhikrComplete = Color(0xFF10B981);     // للأذكار المكتملة
  static const Color qiblaDirection = Color(0xFFF59E0B);    // لاتجاه القبلة
}

/// Extension methods للألوان
extension ColorExtensions on Color {
  /// تفتيح اللون
  Color lighten([double amount = 0.1]) => AppColors.lighten(this, amount);
  
  /// تغميق اللون
  Color darken([double amount = 0.1]) => AppColors.darken(this, amount);
  
  /// تحويل إلى MaterialColor
  MaterialColor toMaterialColor() {
    final Map<int, Color> swatch = {};
    final base = HSLColor.fromColor(this);
    
    for (int i = 1; i <= 9; i++) {
      final lightness = (0.9 - (i * 0.1)).clamp(0.0, 1.0);
      swatch[i * 100] = base.withLightness(lightness).toColor();
    }
    swatch[500] = this;
    
    return MaterialColor(red << 16 | green << 8 | blue, swatch);
  }
  
  /// التحقق من كون اللون فاتح أم داكن
  bool get isLight => computeLuminance() > 0.5;
  bool get isDark => !isLight;
  
  /// الحصول على لون النص المناسب
  Color get contrastingTextColor => isLight ? Color(0xFF111827) : AppColors.textPrimary;
}