// lib/app/themes/core/app_colors.dart (محسن)
import 'package:flutter/material.dart';

/// نظام الألوان الإسلامي المحسن - مع الحفاظ على الأسماء الأصلية
class AppColors {
  AppColors._();
  
  // ========== الألوان الأساسية المحسنة ==========
  
  /// اللون الأساسي - الأخضر الإسلامي التقليدي (محسن)
  static const Color primary = Color(0xFF059669);      // تم تحسينه من 0xFF0D7377
  static const Color primaryLight = Color(0xFF10B981); // محسن للوضوح
  static const Color primaryDark = Color(0xFF047857);  // أغمق قليلاً
  
  /// اللون الثانوي - الذهبي الإسلامي (محسن)
  static const Color secondary = Color(0xFFD97706);     // تم تحسينه من 0xFFFFB74D
  static const Color secondaryLight = Color(0xFFF59E0B);
  static const Color secondaryDark = Color(0xFFB45309);
  
  /// اللون المساعد - البنفسجي الهادئ (كما هو)
  static const Color accent = Color(0xFF6366F1);
  static const Color accentLight = Color(0xFF818CF8);
  static const Color accentDark = Color(0xFF4338CA);
  
  /// لون إضافي جديد - البني الدافئ الإسلامي
  static const Color tertiary = Color(0xFF92400E);
  static const Color tertiaryLight = Color(0xFFA16207);
  static const Color tertiaryDark = Color(0xFF78350F);
  
  // ========== ألوان الحالة المحسنة ==========
  
  static const Color success = Color(0xFF059669);    // استخدام الأخضر الإسلامي
  static const Color warning = Color(0xFFD97706);    // استخدام الذهبي
  static const Color error = Color(0xFFDC2626);      // أحمر محسن
  static const Color info = Color(0xFF2563EB);       // كما هو
  
  // ========== النصوص المحسنة للقراءة ==========
  
  /// النصوص العادية
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF4B5563);   // محسن للوضوح
  static const Color textTertiary = Color(0xFF6B7280);    // محسن
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);
  
  /// نصوص خاصة للمحتوى الديني (جديد)
  static const Color textReligious = Color(0xFF111827);   // أغمق للنصوص المقدسة
  static const Color textArabic = Color(0xFF1F2937);      // للنصوص العربية
  
  /// النصوص للوضع الداكن (محسنة)
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textTertiaryDark = Color(0xFF9CA3AF);
  static const Color textHintDark = Color(0xFF6B7280);
  static const Color textDisabledDark = Color(0xFF4B5563);
  static const Color textReligiousDark = Color(0xFFFFFFFF); // أبيض للنصوص المقدسة
  
  // ========== الخلفيات المحسنة ==========
  
  /// الوضع الفاتح
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  
  /// الوضع الداكن (ألوان دافئة إسلامية)
  static const Color backgroundDark = Color(0xFF1A1F2E);   // أزرق داكن دافئ
  static const Color surfaceDark = Color(0xFF242937);      // محسن للعيون
  static const Color cardDark = Color(0xFF2D3347);         // متباين أكثر
  
  /// خلفيات خاصة للمحتوى الديني (جديد)
  static const Color quranBackground = Color(0xFFFEF3C7);  // كريمي للقرآن
  static const Color dhikrBackground = Color(0xFFD1FAE5);  // أخضر فاتح للأذكار
  
  // ========== الحدود والفواصل ==========
  
  static const Color divider = Color(0xFFE5E7EB);
  static const Color border = Color(0xFFD1D5DB);
  static const Color outline = Color(0xFF9CA3AF);
  
  static const Color dividerDark = Color(0xFF374151);
  static const Color borderDark = Color(0xFF4B5563);
  static const Color outlineDark = Color(0xFF6B7280);
  
  // ========== ألوان الصلوات المحسنة ==========
  
  static const Map<String, Color> prayerColors = {
    'fajr': Color(0xFF6366F1),      // بنفسجي للفجر
    'sunrise': Color(0xFFF59E0B),   // ذهبي للشروق
    'dhuhr': Color(0xFFEF4444),     // أحمر للظهر (حرارة الشمس)
    'asr': Color(0xFFD97706),       // برتقالي للعصر
    'maghrib': Color(0xFFEC4899),   // وردي للمغرب
    'isha': Color(0xFF4338CA),      // بنفسجي داكن للعشاء
  };
  
  // ========== ألوان الفئات المحسنة ==========
  
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
  
  // ========== التدرجات المحسنة والمبسطة ==========
  
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
  
  // ========== تدرجات الأوقات المبسطة ==========
  
  /// تدرج حسب وقت اليوم (مبسط ومحسن)
  static LinearGradient getTimeBasedGradient({DateTime? dateTime}) {
    final now = dateTime ?? DateTime.now();
    final hour = now.hour;
    
    // مبسط جداً: 3 أوقات فقط
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
  
  // ========== دوال مساعدة محسنة ==========
  
  /// الحصول على لون الصلاة
  static Color getPrayerColor(String prayerName) {
    return prayerColors[prayerName.toLowerCase()] ?? primary;
  }
  
  /// الحصول على لون الفئة
  static Color getCategoryColor(String categoryId) {
    return categoryColors[categoryId] ?? primary;
  }
  
  /// الحصول على لون النص المناسب للخلفية
  static Color getTextColorForBackground(Color backgroundColor) {
    // حساب السطوع
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? textPrimary : textPrimaryDark;
  }
  
  /// الحصول على خلفية مناسبة للمحتوى الديني
  static Color getReligiousBackground(String type, {bool isDark = false}) {
    if (isDark) {
      return surfaceDark;
    }
    
    switch (type.toLowerCase()) {
      case 'quran':
      case 'ayah':
        return quranBackground;
      case 'dhikr':
      case 'adhkar':
        return dhikrBackground;
      default:
        return surfaceLight;
    }
  }
  
  // ========== دوال التعديل المبسطة ==========
  
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
  
  // ========== ألوان سريعة للاستخدام المباشر ==========
  
  /// للاستخدام السريع في الواجهات
  static const Color islamicGreen = primary;
  static const Color islamicGold = secondary;
  static const Color islamicBrown = tertiary;
  static const Color prayerNext = Color(0xFF10B981);    // للصلاة القادمة
  static const Color dhikrComplete = Color(0xFF059669); // للأذكار المكتملة
  static const Color qiblaDirection = Color(0xFFD97706); // لاتجاه القبلة
}

/// Extension methods للألوان (محسنة ومبسطة)
extension ColorExtensions on Color {
  /// تفتيح اللون
  Color lighten([double amount = 0.1]) => AppColors.lighten(this, amount);
  
  /// تغميق اللون
  Color darken([double amount = 0.1]) => AppColors.darken(this, amount);
  
  /// تحويل إلى MaterialColor (محسن)
  MaterialColor toMaterialColor() {
    final Map<int, Color> swatch = {};
    final base = HSLColor.fromColor(this);
    
    for (int i = 1; i <= 9; i++) {
      final lightness = (0.9 - (i * 0.1)).clamp(0.0, 1.0);
      swatch[i * 100] = base.withLightness(lightness).toColor();
    }
    swatch[500] = this; // اللون الأساسي
    
    return MaterialColor(red << 16 | green << 8 | blue, swatch);
  }
  
  /// التحقق من كون اللون فاتح أم داكن
  bool get isLight => computeLuminance() > 0.5;
  bool get isDark => !isLight;
  
  /// الحصول على لون النص المناسب
  Color get contrastingTextColor => isLight ? AppColors.textPrimary : AppColors.textPrimaryDark;
}