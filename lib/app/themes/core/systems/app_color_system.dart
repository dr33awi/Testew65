// lib/app/themes/core/systems/app_color_system.dart - النسخة الكاملة والمحسنة
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// نظام الألوان الموحد الكامل - النسخة المتقدمة
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
  static const Color errorLight = Color(0xFFD32F2F);
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
    'general': Color(0xFF8FA584),
    'عامة': Color(0xFF8FA584),
    
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
    'sunrise': Color(0xFFFFD700),
    'الشروق': Color(0xFFFFD700),
    
    // الميزات الرئيسية
    'prayer_times': Color(0xFF6B8E9F),
    'مواقيت الصلاة': Color(0xFF6B8E9F),
    'qibla': Color(0xFF795548),
    'القبلة': Color(0xFF795548),
    'tasbih': Color(0xFF9C27B0),
    'المسبحة': Color(0xFF9C27B0),
    'quran': Color(0xFF2E7D32),
    'القرآن': Color(0xFF2E7D32),
    'hadith': Color(0xFFF57C00),
    'الحديث': Color(0xFFF57C00),
    'dua': Color(0xFF1976D2),
    'الدعاء': Color(0xFF1976D2),
    
    // الألوان الدلالية
    'success': success,
    'نجح': success,
    'error': error,
    'خطأ': error,
    'warning': warning,
    'تحذير': warning,
    'info': info,
    'معلومات': info,
    
    // أنواع الاقتباسات
    'verse': primary,
    'آية': primary,
    'quote': accent,
    'اقتباس': accent,
    
    // الحالات العاطفية
    'happy': Color(0xFFFFD700),
    'سعيد': Color(0xFFFFD700),
    'calm': primary,
    'هادئ': primary,
    'focused': info,
    'مركز': info,
    'grateful': accent,
    'شاكر': accent,
    'peaceful': tertiary,
    'مطمئن': tertiary,
    
    // أوقات اليوم
    'dawn': Color(0xFF4A5568),
    'الفجر_الوقت': Color(0xFF4A5568),
    'noon': Color(0xFFED8936),
    'الظهيرة': Color(0xFFED8936),
    'afternoon': Color(0xFFD69E2E),
    'العصر_الوقت': Color(0xFFD69E2E),
    'sunset': Color(0xFFE53E3E),
    'المغرب_الوقت': Color(0xFFE53E3E),
    'night': Color(0xFF2D3748),
    'الليل': Color(0xFF2D3748),
    
    // المواسم
    'spring': Color(0xFF4CAF50),
    'الربيع': Color(0xFF4CAF50),
    'summer': Color(0xFFFF9800),
    'الصيف': Color(0xFFFF9800),
    'autumn': Color(0xFF795548),
    'الخريف': Color(0xFF795548),
    'winter': Color(0xFF607D8B),
    'الشتاء': Color(0xFF607D8B),
  };

  // ===== الدوال الأساسية الموحدة =====

  /// الدالة الأساسية للحصول على أي لون - مع معالجة محسنة للأخطاء
  static Color getColor(String key) {
    if (key.isEmpty) {
      if (kDebugMode) {
        debugPrint('تحذير: مفتاح اللون فارغ، استخدام اللون الافتراضي');
      }
      return primary;
    }

    final normalizedKey = key.toLowerCase().trim();
    final color = _colorMap[normalizedKey];
    
    if (color == null && kDebugMode) {
      debugPrint('تحذير: لون غير موجود "$key", استخدام اللون الافتراضي');
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

  // ===== دوال مساعدة داخلية مُصححة =====
  
  /// تفتيح اللون - مع تحقق من صحة القيم
  static Color _lightenColor(Color color, [double amount = 0.1]) {
    try {
      final clampedAmount = amount.clamp(0.0, 1.0);
      final hsl = HSLColor.fromColor(color);
      final lightness = (hsl.lightness + clampedAmount).clamp(0.0, 1.0);
      return hsl.withLightness(lightness).toColor();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('خطأ في تفتيح اللون: $e');
      }
      return color;
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
      if (kDebugMode) {
        debugPrint('خطأ في تغميق اللون: $e');
      }
      return color;
    }
  }

  // ===== Aliases للتوافق مع الكود الموجود =====
  
  static Color getCategoryColor(String key) => getColor(key);
  static Color getCategoryLightColor(String key) => getLightColor(key);
  static Color getCategoryDarkColor(String key) => getDarkColor(key);
  static Color getPrayerColor(String prayerName) => getColor(prayerName);
  static Color getQuoteColor(String quoteType) => getColor(quoteType);

  // ===== التدرجات - منطق مُصحح =====

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
      if (kDebugMode) {
        debugPrint('خطأ في إنشاء التدرج: $e');
      }
      
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [primary, primaryDark],
      );
    }
  }

  // جميع دوال التدرج تستخدم نفس المنطق المُصحح
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
      return getGradient(key);
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

  static const LinearGradient successGradient = LinearGradient(
    colors: [successLight, success],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient errorGradient = LinearGradient(
    colors: [errorLight, error],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ===== دوال السياق - مُصححة مع معالجة null =====

  static Color getBackground(BuildContext context) {
    try {
      return Theme.of(context).brightness == Brightness.dark
          ? darkBackground
          : lightBackground;
    } catch (e) {
      return lightBackground;
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

  // ===== التدرجات المتقدمة والديناميكية =====

  /// الحصول على تدرج لوني حسب الوقت
  static LinearGradient getTimeBasedGradient() {
    final hour = DateTime.now().hour;
    
    if (hour < 5) {
      // ليل
      return const LinearGradient(
        colors: [Color(0xFF2C3E50), Color(0xFF3A4E61)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 12) {
      // صباح
      return const LinearGradient(
        colors: [primary, primaryLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 17) {
      // نهار
      return const LinearGradient(
        colors: [accent, accentLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 20) {
      // مساء
      return const LinearGradient(
        colors: [tertiary, tertiaryLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      // ليل
      return const LinearGradient(
        colors: [primaryDark, tertiary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  /// الحصول على لون حسب الحالة العاطفية
  static Color getMoodColor(String mood) {
    return getColor(mood);
  }

  /// الحصول على لون للإشعارات
  static Color getNotificationColor(String type) {
    switch (type.toLowerCase()) {
      case 'prayer':
      case 'صلاة':
        return primary;
      case 'athkar':
      case 'أذكار':
        return accent;
      case 'reminder':
      case 'تذكير':
        return info;
      case 'achievement':
      case 'إنجاز':
        return success;
      case 'warning':
      case 'تحذير':
        return warning;
      default:
        return primary;
    }
  }

  /// إنشاء لوحة ألوان مخصصة للمواسم
  static Map<String, Color> getSeasonalColors() {
    final month = DateTime.now().month;
    
    if (month >= 3 && month <= 5) {
      // ربيع
      return {
        'primary': getColor('spring'),
        'secondary': const Color(0xFF8BC34A),
        'accent': const Color(0xFFCDDC39),
      };
    } else if (month >= 6 && month <= 8) {
      // صيف
      return {
        'primary': getColor('summer'),
        'secondary': const Color(0xFFFFC107),
        'accent': const Color(0xFFFFEB3B),
      };
    } else if (month >= 9 && month <= 11) {
      // خريف
      return {
        'primary': getColor('autumn'),
        'secondary': const Color(0xFFFF7043),
        'accent': const Color(0xFFFF5722),
      };
    } else {
      // شتاء
      return {
        'primary': getColor('winter'),
        'secondary': const Color(0xFF546E7A),
        'accent': const Color(0xFF455A64),
      };
    }
  }

  /// الحصول على لون للحالة الحالية
  static Color getCurrentStateColor() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 12) {
      return getCategoryColor('morning');
    } else if (hour >= 12 && hour < 18) {
      return primary;
    } else if (hour >= 18 && hour < 21) {
      return getCategoryColor('evening');
    } else {
      return getCategoryColor('sleep');
    }
  }

  // ===== دوال إمكانية الوصول =====

  /// الحصول على لون متوافق مع إمكانية الوصول
  static Color getAccessibleColor({
    required Color foreground,
    required Color background,
    double targetContrast = 4.5,
  }) {
    final contrast = _calculateContrast(foreground, background);
    
    if (contrast >= targetContrast) {
      return foreground;
    }
    
    // تعديل اللون لتحسين التباين
    final hsl = HSLColor.fromColor(foreground);
    
    if (background.computeLuminance() > 0.5) {
      // خلفية فاتحة - جعل النص أغمق
      return hsl.withLightness(0.2).toColor();
    } else {
      // خلفية داكنة - جعل النص أفتح
      return hsl.withLightness(0.9).toColor();
    }
  }

  /// حساب نسبة التباين بين لونين
  static double _calculateContrast(Color color1, Color color2) {
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();
    
    final brightest = luminance1 > luminance2 ? luminance1 : luminance2;
    final darkest = luminance1 > luminance2 ? luminance2 : luminance1;
    
    return (brightest + 0.05) / (darkest + 0.05);
  }

  /// إنشاء مجموعة ألوان متدرجة
  static List<Color> createColorScale({
    required Color baseColor,
    int steps = 5,
    double lightnessDelta = 0.15,
  }) {
    final hsl = HSLColor.fromColor(baseColor);
    final colors = <Color>[];
    
    for (int i = 0; i < steps; i++) {
      final lightness = (hsl.lightness + (i - steps ~/ 2) * lightnessDelta)
          .clamp(0.0, 1.0);
      colors.add(hsl.withLightness(lightness).toColor());
    }
    
    return colors;
  }

  // ===== دوال مساعدة مُصححة =====

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
        'soft': baseColor.withValues(alpha: 0.7),
        'contrast': _getContrastingTextColor(baseColor),
      };
    } catch (e) {
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
      return Colors.white;
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
      return _getContrastingTextColor(backgroundColor);
    } else if (whiteContrast) {
      return Colors.white;
    } else if (blackContrast) {
      return Colors.black87;
    } else {
      return _getContrastingTextColor(backgroundColor);
    }
  }

  // ===== دوال التحليل والإحصائيات =====

  /// الحصول على إحصائيات الألوان
  static Map<String, int> getColorStats() {
    final categories = <String, int>{};
    
    for (final key in _colorMap.keys) {
      if (key.contains('morning') || key.contains('الصباح')) {
        categories['morning'] = (categories['morning'] ?? 0) + 1;
      } else if (key.contains('evening') || key.contains('المساء')) {
        categories['evening'] = (categories['evening'] ?? 0) + 1;
      } else if (key.contains('prayer') || key.contains('صلاة')) {
        categories['prayer'] = (categories['prayer'] ?? 0) + 1;
      }
      // يمكن إضافة المزيد من التصنيفات
    }
    
    return categories;
  }

  /// اختبار جودة النظام اللوني
  static bool validateColorSystem() {
    try {
      // التحقق من وجود الألوان الأساسية
      final requiredColors = ['morning', 'evening', 'sleep', 'prayer'];
      for (final color in requiredColors) {
        if (!hasColor(color)) {
          if (kDebugMode) {
            debugPrint('لون مطلوب مفقود: $color');
          }
          return false;
        }
      }
      
      // التحقق من التباين
      if (!hasGoodContrast(lightTextPrimary, lightBackground)) {
        if (kDebugMode) {
          debugPrint('تباين ضعيف في الوضع الفاتح');
        }
        return false;
      }
      
      if (!hasGoodContrast(darkTextPrimary, darkBackground)) {
        if (kDebugMode) {
          debugPrint('تباين ضعيف في الوضع الداكن');
        }
        return false;
      }
      
      return true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('خطأ في التحقق من النظام اللوني: $e');
      }
      return false;
    }
  }

  // ===== دوال cache للأداء =====
  static final Map<String, Color> _lightColorCache = {};
  static final Map<String, Color> _darkColorCache = {};
  static final Map<String, LinearGradient> _gradientCache = {};

  /// الحصول على لون فاتح مع cache
  static Color getLightColorCached(String key) {
    return _lightColorCache.putIfAbsent(key, () => getLightColor(key));
  }

  /// الحصول على لون داكن مع cache
  static Color getDarkColorCached(String key) {
    return _darkColorCache.putIfAbsent(key, () => getDarkColor(key));
  }

  /// الحصول على تدرج مع cache
  static LinearGradient getGradientCached(String key) {
    return _gradientCache.putIfAbsent(key, () => getGradient(key));
  }

  /// مسح الcache
  static void clearCache() {
    _lightColorCache.clear();
    _darkColorCache.clear();
    _gradientCache.clear();
  }
}