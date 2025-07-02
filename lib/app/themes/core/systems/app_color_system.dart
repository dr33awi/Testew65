// lib/app/themes/core/systems/app_color_system.dart - النسخة المحسنة
import 'package:flutter/material.dart';

/// نظام الألوان الموحد - النسخة المحسنة مع معالجة أخطاء أفضل
class AppColorSystem {
  AppColorSystem._();

  // ===== الألوان الأساسية للهوية البصرية =====
  static const Color primary = Color(0xFF5D7052);
  static const Color primaryLight = Color(0xFF7A8B6F);
  static const Color primaryDark = Color(0xFF445A3B);
  static const Color primarySoft = Color(0xFF8FA584);

  static const Color accent = Color(0xFFB8860B);
  static const Color accentLight = Color(0xFFDAA520);
  static const Color accentDark = Color(0xFF996515);

  static const Color tertiary = Color(0xFF8B6F47);
  static const Color tertiaryLight = Color(0xFFA68B5B);
  static const Color tertiaryDark = Color(0xFF6B5637);
  static const Color tertiarySoft = Color(0xFFB8A082);

  // ===== الألوان الدلالية =====
  static const Color success = primary;
  static const Color successLight = primaryLight;
  static const Color error = Color(0xFFB85450);
  static const Color warning = Color(0xFFD4A574);
  static const Color warningLight = Color(0xFFE8C899);
  static const Color info = Color(0xFF6B8E9F);
  static const Color infoLight = Color(0xFF8FA9B8);

  // ===== ألوان الوضع الفاتح =====
  static const Color lightBackground = Color(0xFFF8F6F0);
  static const Color lightSurface = Color(0xFFF5F3EB);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightDivider = Color(0xFFE0DDD4);
  static const Color lightTextPrimary = Color(0xFF2D2D2D);
  static const Color lightTextSecondary = Color(0xFF5F5F5F);

  // ===== ألوان الوضع الداكن =====
  static const Color darkBackground = Color(0xFF1C1F1B);
  static const Color darkSurface = Color(0xFF252A24);
  static const Color darkCard = Color(0xFF2E342D);
  static const Color darkDivider = Color(0xFF3C453B);
  static const Color darkTextPrimary = Color(0xFFF7F5F0);
  static const Color darkTextSecondary = Color(0xFFC0BDB0);

  // ===== خريطة الألوان الموحدة - مصدر واحد فقط =====
  static const Map<String, Color> _colorMap = {
    // فئات الأذكار
    'morning': primary,
    'الصباح': primary,
    'evening': accent,
    'المساء': accent,
    'sleep': tertiary,
    'النوم': tertiary,
    'prayer': primaryLight,
    'بعد الصلاة': primaryLight,
    'wakeup': primarySoft,
    'الاستيقاظ': primarySoft,
    
    // الصلوات
    'fajr': primary,
    'الفجر': primary,
    'dhuhr': accent,
    'الظهر': accent,
    'asr': primaryLight,
    'العصر': primaryLight,
    'maghrib': tertiary,
    'المغرب': tertiary,
    'isha': Color(0xFF3A453A),
    'العشاء': Color(0xFF3A453A),
    
    // الألوان الدلالية
    'success': success,
    'error': error,
    'warning': warning,
    'info': info,
    
    // أنواع الاقتباسات
    'verse': primary,
    'آية': primary,
    'hadith': accent,
    'حديث': accent,
    'dua': tertiary,
    'دعاء': tertiary,
  };

  // ===== الدوال الأساسية الموحدة - نسخة محسنة =====

  /// الدالة الأساسية للحصول على أي لون - مع معالجة محسنة للأخطاء
  static Color getColor(String key) {
    if (key.isEmpty) {
      assert(() {
        print('تحذير: مفتاح اللون فارغ، استخدام اللون الافتراضي');
        return true;
      }());
      return primary;
    }

    final normalizedKey = key.toLowerCase().trim();
    final color = _colorMap[normalizedKey];
    
    if (color == null) {
      // تسجيل تحذير في وضع التطوير فقط
      assert(() {
        print('تحذير: لون غير موجود "$key", استخدام اللون الافتراضي');
        return true;
      }());
    }
    
    return color ?? primary;
  }

  /// التحقق من وجود اللون قبل الحصول عليه
  static bool isValidColorKey(String key) {
    if (key.isEmpty) return false;
    final normalizedKey = key.toLowerCase().trim();
    return _colorMap.containsKey(normalizedKey);
  }

  /// الحصول على اللون مع fallback مخصص
  static Color getColorOrFallback(String key, Color fallback) {
    if (key.isEmpty) return fallback;
    
    final normalizedKey = key.toLowerCase().trim();
    return _colorMap[normalizedKey] ?? fallback;
  }

  /// الحصول على اللون الفاتح
  static Color getLightColor(String key) {
    final baseColor = getColor(key);
    return _lightenColor(baseColor);
  }

  /// الحصول على اللون الداكن
  static Color getDarkColor(String key) {
    final baseColor = getColor(key);
    return _darkenColor(baseColor);
  }

  // ===== دوال مساعدة داخلية محسنة =====
  
  /// تفتيح اللون - مع تحقق من صحة القيم
  static Color _lightenColor(Color color, [double amount = 0.1]) {
    try {
      final clampedAmount = amount.clamp(0.0, 1.0);
      final hsl = HSLColor.fromColor(color);
      final lightness = (hsl.lightness + clampedAmount).clamp(0.0, 1.0);
      return hsl.withLightness(lightness).toColor();
    } catch (e) {
      assert(() {
        print('خطأ في تفتيح اللون: $e');
        return true;
      }());
      return color; // إرجاع اللون الأصلي في حالة الخطأ
    }
  }

  /// تغميق اللون - مع تحقق من صحة القيم
  static Color _darkenColor(Color color, [double amount = 0.1]) {
    try {
      final clampedAmount = amount.clamp(0.0, 1.0);
      final hsl = HSLColor.fromColor(color);
      final lightness = (hsl.lightness - clampedAmount).clamp(0.0, 1.0);
      return hsl.withLightness(lightness).toColor();
    } catch (e) {
      assert(() {
        print('خطأ في تغميق اللون: $e');
        return true;
      }());
      return color; // إرجاع اللون الأصلي في حالة الخطأ
    }
  }

  // ===== Aliases للتوافق مع الكود الموجود - محسنة =====
  
  static Color getCategoryColor(String key) => getColor(key);
  static Color getCategoryLightColor(String key) => getLightColor(key);
  static Color getCategoryDarkColor(String key) => getDarkColor(key);
  static Color getPrayerColor(String prayerName) => getColor(prayerName);
  static Color getQuoteColor(String quoteType) => getColor(quoteType);

  // ===== التدرجات - منطق محسن =====

  /// تدرج أساسي - مع معالجة أخطاء
  static LinearGradient getGradient(String key) {
    try {
      final primaryColor = getColor(key);
      final darkColor = getDarkColor(key);
      
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primaryColor, darkColor],
      );
    } catch (e) {
      assert(() {
        print('خطأ في إنشاء التدرج: $e');
        return true;
      }());
      
      // تدرج احتياطي
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primary, primaryDark],
      );
    }
  }

  // جميع دوال التدرج تستخدم نفس المنطق المحسن
  static LinearGradient getCategoryGradient(String key) => getGradient(key);
  static LinearGradient getPrayerGradient(String key) => getGradient(key);
  static LinearGradient getQuoteGradient(String key) => getGradient(key);

  /// تدرج فاتح
  static LinearGradient getLightGradient(String key) {
    try {
      final lightColor = getLightColor(key);
      final primaryColor = getColor(key);
      
      return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [lightColor, primaryColor],
      );
    } catch (e) {
      return getGradient(key); // استخدام التدرج العادي كاحتياطي
    }
  }

  // ===== التدرجات الثابتة =====
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentLight, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient tertiaryGradient = LinearGradient(
    colors: [tertiaryLight, tertiary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ===== دوال السياق - محسنة مع معالجة null =====

  static Color getBackground(BuildContext context) {
    try {
      return Theme.of(context).brightness == Brightness.dark
          ? darkBackground
          : lightBackground;
    } catch (e) {
      return lightBackground; // افتراضي آمن
    }
  }

  static Color getSurface(BuildContext context) {
    try {
      return Theme.of(context).brightness == Brightness.dark
          ? darkSurface
          : lightSurface;
    } catch (e) {
      return lightSurface;
    }
  }

  static Color getCard(BuildContext context) {
    try {
      return Theme.of(context).brightness == Brightness.dark
          ? darkCard
          : lightCard;
    } catch (e) {
      return lightCard;
    }
  }

  static Color getTextPrimary(BuildContext context) {
    try {
      return Theme.of(context).brightness == Brightness.dark
          ? darkTextPrimary
          : lightTextPrimary;
    } catch (e) {
      return lightTextPrimary;
    }
  }

  static Color getTextSecondary(BuildContext context) {
    try {
      return Theme.of(context).brightness == Brightness.dark
          ? darkTextSecondary
          : lightTextSecondary;
    } catch (e) {
      return lightTextSecondary;
    }
  }

  static Color getDivider(BuildContext context) {
    try {
      return Theme.of(context).brightness == Brightness.dark
          ? darkDivider
          : lightDivider;
    } catch (e) {
      return lightDivider;
    }
  }

  // ===== دوال مساعدة محسنة =====

  static bool hasColor(String key) {
    if (key.isEmpty) return false;
    final normalizedKey = key.toLowerCase().trim();
    return _colorMap.containsKey(normalizedKey);
  }

  static List<String> getAllKeys() => List.unmodifiable(_colorMap.keys);

  /// الحصول على جميع الألوان المتاحة
  static Map<String, Color> getAllColors() => Map.unmodifiable(_colorMap);

  /// البحث عن ألوان بكلمة مفتاحية
  static List<String> searchColors(String searchTerm) {
    if (searchTerm.isEmpty) return [];
    
    final term = searchTerm.toLowerCase().trim();
    return _colorMap.keys
        .where((key) => key.contains(term))
        .toList();
  }

  /// إنشاء لوحة ألوان من لون أساسي
  static Map<String, Color> createColorPalette(Color baseColor) {
    try {
      return {
        'primary': baseColor,
        'light': _lightenColor(baseColor, 0.2),
        'dark': _darkenColor(baseColor, 0.2),
        'soft': baseColor.withOpacity(0.7),
        'contrast': _getContrastingTextColor(baseColor),
      };
    } catch (e) {
      // إرجاع لوحة افتراضية في حالة الخطأ
      return {
        'primary': primary,
        'light': primaryLight,
        'dark': primaryDark,
        'soft': primarySoft,
        'contrast': Colors.white,
      };
    }
  }

  /// الحصول على لون النص المتباين
  static Color _getContrastingTextColor(Color color) {
    try {
      return ThemeData.estimateBrightnessForColor(color) == Brightness.dark
          ? Colors.white
          : Colors.black87;
    } catch (e) {
      return Colors.white; // افتراضي آمن
    }
  }

  /// التحقق من تباين الألوان
  static bool hasGoodContrast(Color foreground, Color background) {
    try {
      final fgLuminance = foreground.computeLuminance();
      final bgLuminance = background.computeLuminance();
      
      final contrast = (fgLuminance + 0.05) / (bgLuminance + 0.05);
      return contrast >= 4.5; // معيار WCAG للتباين
    } catch (e) {
      return false;
    }
  }

  /// اقتراح لون نص مناسب
  static Color suggestTextColor(Color backgroundColor) {
    final whiteContrast = hasGoodContrast(Colors.white, backgroundColor);
    final blackContrast = hasGoodContrast(Colors.black87, backgroundColor);
    
    if (whiteContrast && blackContrast) {
      // إذا كان كلاهما مناسب، اختر الأفضل
      return _getContrastingTextColor(backgroundColor);
    } else if (whiteContrast) {
      return Colors.white;
    } else if (blackContrast) {
      return Colors.black87;
    } else {
      // لا يوجد تباين جيد، استخدم الافتراضي
      return _getContrastingTextColor(backgroundColor);
    }
  }
}