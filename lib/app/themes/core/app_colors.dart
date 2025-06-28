// lib/app/themes/core/app_colors.dart - عربي وداكن فقط
import 'package:flutter/material.dart';

/// نظام الألوان الإسلامي - الوضع الداكن فقط
class AppColors {
  AppColors._();
  
  // ========== الألوان الأساسية الإسلامية المحدثة ==========
  
  /// اللون الأساسي - الأخضر الزيتي الأنيق
  static const Color primary = Color(0xFF5D7052);
  static const Color primaryLight = Color(0xFF7A8E6F);
  static const Color primaryDark = Color(0xFF4A5A41);
  
  /// اللون الثانوي - الذهبي الدافئ
  static const Color secondary = Color(0xFFB8860B);
  static const Color secondaryLight = Color(0xFFDAA520);
  static const Color secondaryDark = Color(0xFF9A7209);
  
  /// اللون المساعد - البني الدافئ المتناسق
  static const Color accent = Color(0xFF8D5524);
  static const Color accentLight = Color(0xFFA0673A);
  static const Color accentDark = Color(0xFF6B401B);
  
  /// لون إضافي - الأزرق الرمادي الهادئ
  static const Color tertiary = Color(0xFF4F5D6B);
  static const Color tertiaryLight = Color(0xFF647080);
  static const Color tertiaryDark = Color(0xFF3E4A56);
  
  // ========== ألوان الحالة المتناسقة ==========
  
  static const Color success = Color(0xFF5D7052);    // أخضر زيتي (نفس الأساسي)
  static const Color warning = Color(0xFFB8860B);    // ذهبي دافئ (نفس الثانوي)
  static const Color error = Color(0xFFD04848);      // أحمر دافئ متناسق
  static const Color info = Color(0xFF4A86B8);       // أزرق هادئ متناسق
  
  // ========== النصوص للوضع الداكن فقط ==========
  
  static const Color textPrimary = Color(0xFFF5F5F0);      // أبيض دافئ
  static const Color textSecondary = Color(0xFFE0E0D6);    // رمادي فاتح دافئ
  static const Color textTertiary = Color(0xFFC4C4B8);     // رمادي متوسط دافئ
  static const Color textHint = Color(0xFFA8A898);         // رمادي داكن دافئ
  static const Color textDisabled = Color(0xFF8C8C7A);     // رمادي داكن جداً دافئ
  
  /// نصوص خاصة للمحتوى الديني
  static const Color textReligious = Color(0xFFF8F8F3);    // أبيض كريمي للنصوص المقدسة
  static const Color textArabic = Color(0xFFF5F5F0);       // للنصوص العربية
  
  // ========== الخلفيات الداكنة المحدثة ==========
  
  static const Color background = Color(0xFF1A1F1A);       // أخضر داكن جداً
  static const Color surface = Color(0xFF232A23);          // أخضر داكن للسطوح
  static const Color card = Color(0xFF2D352D);             // أخضر داكن للبطاقات
  
  /// خلفيات خاصة للمحتوى الديني
  static const Color quranBackground = Color(0xFF1E2A1E);    // أخضر زيتي داكن للقرآن
  static const Color dhikrBackground = Color(0xFF252E25);    // أخضر داكن للأذكار
  static const Color hadithBackground = Color(0xFF2A251E);   // بني داكن للأحاديث
  static const Color duaBackground = Color(0xFF2D2419);      // بني ذهبي داكن للأدعية
  
  // ========== الحدود والفواصل المحدثة ==========
  
  static const Color divider = Color(0xFF3A4239);           // أخضر رمادي للفواصل
  static const Color border = Color(0xFF4A524A);            // أخضر رمادي للحدود
  static const Color outline = Color(0xFF5A625A);           // أخضر رمادي للخطوط الخارجية
  
  // ========== ألوان الصلوات المحدثة ==========
  
  static const Map<String, Color> prayerColors = {
    'الفجر': Color(0xFF6B7BA8),        // أزرق فجري هادئ
    'الشروق': Color(0xFFB8860B),       // ذهبي للشروق
    'الظهر': Color(0xFFD08C47),        // برتقالي دافئ للظهر
    'العصر': Color(0xFF8D5524),        // بني دافئ للعصر
    'المغرب': Color(0xFF9B6B9B),       // بنفسجي هادئ للمغرب
    'العشاء': Color(0xFF4F5D6B),       // أزرق رمادي للعشاء
  };
  
  // ========== ألوان الفئات المحدثة ==========
  
  static const Map<String, Color> categoryColors = {
    'اوقات_الصلاة': primary,          // أخضر زيتي
    'الاذكار': accent,                // بني دافئ
    'القبلة': tertiary,               // أزرق رمادي
    'التسبيح': secondary,             // ذهبي
    'القران': Color(0xFF4A6B4A),      // أخضر قرآني
    'الادعية': Color(0xFF8B7355),     // بني فاتح
    'المفضلة': Color(0xFFCC8E35),     // ذهبي فاتح
    'الاعدادات': Color(0xFF6B7BA8),   // أزرق هادئ
  };
  
  // ========== التدرجات المحدثة ==========
  
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
  
  /// تدرج زيتي ذهبي مميز
  static const LinearGradient oliveGoldGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  /// تدرج دافئ للمساء
  static const LinearGradient warmEveningGradient = LinearGradient(
    colors: [accent, secondaryDark],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  /// تدرج هادئ للفجر
  static const LinearGradient calmDawnGradient = LinearGradient(
    colors: [tertiary, primaryLight],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  // ========== تدرجات الأوقات المحدثة ==========
  
  /// تدرج حسب وقت اليوم
  static LinearGradient getTimeBasedGradient({DateTime? dateTime}) {
    final now = dateTime ?? DateTime.now();
    final hour = now.hour;
    
    if (hour >= 5 && hour < 7) {
      // الفجر - تدرج هادئ
      return calmDawnGradient;
    } else if (hour >= 7 && hour < 12) {
      // الصباح - ذهبي
      return secondaryGradient;
    } else if (hour >= 12 && hour < 16) {
      // الظهر - دافئ
      return warmEveningGradient;
    } else if (hour >= 16 && hour < 18) {
      // العصر - أخضر زيتي
      return primaryGradient;
    } else if (hour >= 18 && hour < 20) {
      // المغرب - زيتي ذهبي
      return oliveGoldGradient;
    } else {
      // الليل - هادئ
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
    return luminance > 0.3 ? Color(0xFF1A1F1A) : textPrimary;
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
  
  /// الحصول على تدرج مناسب للمحتوى الديني
  static LinearGradient getReligiousGradient(String type) {
    switch (type) {
      case 'قران':
      case 'آية':
        return const LinearGradient(
          colors: [Color(0xFF4A6B4A), Color(0xFF3A5A3A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'ذكر':
      case 'اذكار':
        return primaryGradient;
      case 'حديث':
        return const LinearGradient(
          colors: [accent, accentDark],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'دعاء':
        return secondaryGradient;
      default:
        return primaryGradient;
    }
  }
  
  // ========== دوال التعديل المحدثة ==========
  
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
  
  /// تدفئة اللون (إضافة صبغة ذهبية خفيفة)
  static Color warm(Color color, [double amount = 0.05]) {
    final hsl = HSLColor.fromColor(color);
    final newHue = (hsl.hue + (30 * amount)).clamp(0.0, 360.0);
    return hsl.withHue(newHue).toColor();
  }
  
  /// تبريد اللون (إضافة صبغة زرقاء خفيفة)
  static Color cool(Color color, [double amount = 0.05]) {
    final hsl = HSLColor.fromColor(color);
    final newHue = (hsl.hue - (30 * amount)).clamp(0.0, 360.0);
    return hsl.withHue(newHue).toColor();
  }
  
  // ========== ألوان سريعة محدثة ==========
  
  static const Color islamicGreen = primary;             // أخضر زيتي
  static const Color islamicGold = secondary;            // ذهبي دافئ
  static const Color islamicBrown = accent;              // بني دافئ
  static const Color prayerNext = Color(0xFF7A8E6F);    // للصلاة القادمة
  static const Color dhikrComplete = Color(0xFF5D7052); // للأذكار المكتملة
  static const Color qiblaDirection = Color(0xFFB8860B);// لاتجاه القبلة
  
  // ========== ألوان إضافية للمناسبات والأوقات ==========
  
  /// ألوان المناسبات الإسلامية
  static const Map<String, Color> occasionColors = {
    'رمضان': Color(0xFF6B4E8D),        // بنفسجي رمضاني
    'الحج': Color(0xFF8B7355),         // بني حجازي
    'العيد': Color(0xFFCC8E35),        // ذهبي احتفالي
    'جمعة': Color(0xFF4A6B4A),        // أخضر جمعة
    'ليلة_القدر': Color(0xFF5A4F8D),  // بنفسجي ليلي
  };
  
  /// ألوان أوقات اليوم
  static const Map<String, Color> timeColors = {
    'فجر': Color(0xFF6B7BA8),         // أزرق فجري
    'ضحى': Color(0xFFDAA520),        // ذهبي ضحى
    'ظهيرة': Color(0xFFD08C47),      // برتقالي ظهيرة
    'عصر': Color(0xFF8D5524),        // بني عصر
    'مغيب': Color(0xFF9B6B9B),       // بنفسجي مغيب
    'ليل': Color(0xFF4F5D6B),        // أزرق ليلي
  };
  
  /// الحصول على لون المناسبة
  static Color getOccasionColor(String occasion) {
    return occasionColors[occasion] ?? primary;
  }
  
  /// الحصول على لون الوقت
  static Color getTimeColor(String timeOfDay) {
    return timeColors[timeOfDay] ?? primary;
  }
}

/// Extension methods للألوان المحدثة
extension ColorExtensions on Color {
  /// تفتيح اللون
  Color lighten([double amount = 0.1]) => AppColors.lighten(this, amount);
  
  /// تغميق اللون
  Color darken([double amount = 0.1]) => AppColors.darken(this, amount);
  
  /// تدفئة اللون
  Color warm([double amount = 0.05]) => AppColors.warm(this, amount);
  
  /// تبريد اللون
  Color cool([double amount = 0.05]) => AppColors.cool(this, amount);
  
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
  Color get contrastingTextColor => isLight ? AppColors.background : AppColors.textPrimary;
  
  /// الحصول على إصدار شفاف من اللون
  Color withAlpha(double alpha) => withValues(alpha: alpha);
  
  /// دمج اللون مع لون آخر
  Color blend(Color other, [double ratio = 0.5]) {
    return Color.lerp(this, other, ratio) ?? this;
  }
  
  /// الحصول على لون مكمل
  Color get complement {
    final hsl = HSLColor.fromColor(this);
    final complementHue = (hsl.hue + 180) % 360;
    return hsl.withHue(complementHue).toColor();
  }
  
  /// التحقق من التناسق مع الألوان الأساسية
  bool get isCompatibleWithTheme {
    final greenCompatible = _isCompatibleWith(AppColors.primary);
    final goldCompatible = _isCompatibleWith(AppColors.secondary);
    return greenCompatible || goldCompatible;
  }
  
  bool _isCompatibleWith(Color themeColor) {
    final thisHsl = HSLColor.fromColor(this);
    final themeHsl = HSLColor.fromColor(themeColor);
    final hueDifference = (thisHsl.hue - themeHsl.hue).abs();
    return hueDifference < 60 || hueDifference > 300; // ألوان متناسقة أو مكملة
  }
}