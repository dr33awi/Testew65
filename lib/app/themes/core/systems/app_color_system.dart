// lib/app/themes/core/systems/app_color_system.dart - المصدر الأساسي الموحد للألوان
import 'package:flutter/material.dart';

/// نظام الألوان الموحد - المصدر الأساسي الوحيد لجميع ألوان التطبيق
class AppColorSystem {
  AppColorSystem._();

  // ===== الألوان الأساسية للهوية البصرية =====
  static const Color primary = Color(0xFF5D7052); // أخضر زيتي أنيق
  static const Color primaryLight = Color(0xFF7A8B6F); // أخضر زيتي فاتح
  static const Color primaryDark = Color(0xFF445A3B); // أخضر زيتي داكن
  static const Color primarySoft = Color(0xFF8FA584); // أخضر زيتي ناعم

  static const Color accent = Color(0xFFB8860B); // ذهبي دافئ
  static const Color accentLight = Color(0xFFDAA520); // ذهبي فاتح
  static const Color accentDark = Color(0xFF996515); // ذهبي داكن

  static const Color tertiary = Color(0xFF8B6F47); // بني دافئ
  static const Color tertiaryLight = Color(0xFFA68B5B); // بني فاتح
  static const Color tertiaryDark = Color(0xFF6B5637); // بني داكن
  static const Color tertiarySoft = Color(0xFFB8A082); // بني ناعم

  // ===== الألوان الدلالية =====
  static const Color success = primary; // نفس الأساسي للتناسق
  static const Color successLight = primaryLight;
  static const Color error = Color(0xFFB85450); // أحمر مخملي ناعم
  static const Color warning = Color(0xFFD4A574); // برتقالي دافئ
  static const Color warningLight = Color(0xFFE8C899);
  static const Color info = Color(0xFF6B8E9F); // أزرق رمادي
  static const Color infoLight = Color(0xFF8FA9B8);

  // ===== خلفيات التطبيق =====
  static const Color appBackground = Color(0xFFF8F6F0); // بيج فاتح دافئ
  static const Color appBackgroundSecondary = Color(0xFFF2F0E8);
  static const Color darkAppBackground = Color(0xFF1C1F1B); // خلفية ليلية دافئة
  static const Color darkAppBackgroundSecondary = Color(0xFF252A24);

  // ===== ألوان الوضع الفاتح =====
  static const Color lightBackground = appBackground;
  static const Color lightSurface = Color(0xFFF5F3EB);
  static const Color lightCard = Color(0xFFFFFFFF);
  static const Color lightDivider = Color(0xFFE0DDD4);
  static const Color lightTextPrimary = Color(0xFF2D2D2D);
  static const Color lightTextSecondary = Color(0xFF5F5F5F);
  static const Color lightTextHint = Color(0xFF8F8F8F);

  // ===== ألوان الوضع الداكن =====
  static const Color darkBackground = Color(0xFF1C1F1B);
  static const Color darkSurface = Color(0xFF252A24);
  static const Color darkCard = Color(0xFF2E342D);
  static const Color darkDivider = Color(0xFF3C453B);
  static const Color darkTextPrimary = Color(0xFFF7F5F0);
  static const Color darkTextSecondary = Color(0xFFC0BDB0);
  static const Color darkTextHint = Color(0xFF8D8A80);

  // ===== ألوان خاصة بالميزات =====
  static const Color athkarBackground = Color(0xFFF0F4EC);
  static const Color prayerActive = primary;
  static const Color qiblaAccent = accent;
  static const Color tasbihAccent = tertiary;

  // ===== خريطة الألوان للفئات والاقتباسات =====
  static const Map<String, Color> _categoryColors = {
    // فئات الأذكار
    'morning': primary,
    'الصباح': primary,
    'أذكار الصباح': primary,
    'evening': accent,
    'المساء': accent,
    'أذكار المساء': accent,
    'sleep': tertiary,
    'النوم': tertiary,
    'أذكار النوم': tertiary,
    'prayer': primaryLight,
    'بعد الصلاة': primaryLight,
    'أذكار بعد الصلاة': primaryLight,
    'wakeup': primarySoft,
    'الاستيقاظ': primarySoft,
    'أذكار الاستيقاظ': primarySoft,
    'travel': accentDark,
    'السفر': accentDark,
    'أذكار السفر': accentDark,
    'eating': tertiaryLight,
    'الطعام': tertiaryLight,
    'أذكار الطعام': tertiaryLight,
    'general': tertiaryDark,
    'عامة': tertiaryDark,
    'أذكار عامة': tertiaryDark,
    
    // فئات التطبيق الرئيسية
    'prayer_times': primary,
    'athkar': accent,
    'quran': tertiary,
    'qibla': primaryDark,
    'tasbih': accentDark,
    'dua': tertiaryDark,
    
    // أنواع الاقتباسات
    'verse': primary,
    'آية': primary,
    'hadith': accent,
    'حديث': accent,
    'dua_quote': tertiary,
    'دعاء': tertiary,
    
    // الألوان الدلالية
    'success': success,
    'error': error,
    'warning': warning,
    'info': info,
  };

  static const Map<String, Color> _categoryLightColors = {
    'morning': primaryLight,
    'الصباح': primaryLight,
    'أذكار الصباح': primaryLight,
    'evening': accentLight,
    'المساء': accentLight,
    'أذكار المساء': accentLight,
    'sleep': tertiaryLight,
    'النوم': tertiaryLight,
    'أذكار النوم': tertiaryLight,
    'prayer': primarySoft,
    'بعد الصلاة': primarySoft,
    'أذكار بعد الصلاة': primarySoft,
    'wakeup': primaryLight,
    'الاستيقاظ': primaryLight,
    'أذكار الاستيقاظ': primaryLight,
    'travel': accent,
    'السفر': accent,
    'أذكار السفر': accent,
    'eating': tertiary,
    'الطعام': tertiary,
    'أذكار الطعام': tertiary,
    'general': tertiary,
    'عامة': tertiary,
    'أذكار عامة': tertiary,
    
    'prayer_times': primaryLight,
    'athkar': accentLight,
    'quran': tertiaryLight,
    'qibla': primary,
    'tasbih': accent,
    'dua': tertiary,
    
    'verse': primaryLight,
    'آية': primaryLight,
    'hadith': accentLight,
    'حديث': accentLight,
    'dua_quote': tertiaryLight,
    'دعاء': tertiaryLight,
    
    'success': successLight,
    'error': error,
    'warning': warningLight,
    'info': infoLight,
  };

  static const Map<String, Color> _categoryDarkColors = {
    'morning': primaryDark,
    'الصباح': primaryDark,
    'أذكار الصباح': primaryDark,
    'evening': accentDark,
    'المساء': accentDark,
    'أذكار المساء': accentDark,
    'sleep': tertiaryDark,
    'النوم': tertiaryDark,
    'أذكار النوم': tertiaryDark,
    'prayer': primary,
    'بعد الصلاة': primary,
    'أذكار بعد الصلاة': primary,
    'wakeup': primary,
    'الاستيقاظ': primary,
    'أذكار الاستيقاظ': primary,
    'travel': accentDark,
    'السفر': accentDark,
    'أذكار السفر': accentDark,
    'eating': tertiaryDark,
    'الطعام': tertiaryDark,
    'أذكار الطعام': tertiaryDark,
    'general': tertiaryDark,
    'عامة': tertiaryDark,
    'أذكار عامة': tertiaryDark,
    
    'prayer_times': primaryDark,
    'athkar': accentDark,
    'quran': tertiaryDark,
    'qibla': primaryDark,
    'tasbih': accentDark,
    'dua': tertiaryDark,
    
    'verse': primaryDark,
    'آية': primaryDark,
    'hadith': accentDark,
    'حديث': accentDark,
    'dua_quote': tertiaryDark,
    'دعاء': tertiaryDark,
    
    'success': primary,
    'error': error,
    'warning': warning,
    'info': info,
  };

  // ===== التدرجات الأساسية =====
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

  // ===== تدرجات الخلفيات =====
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [appBackground, appBackgroundSecondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [darkAppBackground, darkAppBackgroundSecondary, darkCard],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.6, 1.0],
  );

  static const LinearGradient athkarBackgroundGradient = LinearGradient(
    colors: [Color(0xFFF5F3EB), athkarBackground],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkAthkarBackgroundGradient = LinearGradient(
    colors: [darkSurface, darkCard],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ===== تدرجات الصلوات =====
  static const LinearGradient fajrGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient dhuhrGradient = LinearGradient(
    colors: [accentLight, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient asrGradient = LinearGradient(
    colors: [primarySoft, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient maghribGradient = LinearGradient(
    colors: [tertiaryLight, tertiary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ishaGradient = LinearGradient(
    colors: [Color(0xFF3A453A), Color(0xFF2D352D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunriseGradient = LinearGradient(
    colors: [warningLight, accentLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ===== الدوال الأساسية =====

  /// الحصول على اللون الأساسي للفئة/النوع
  static Color getCategoryColor(String key) {
    final normalizedKey = _normalizeKey(key);
    return _categoryColors[normalizedKey] ?? primary;
  }

  /// الحصول على اللون الفاتح للفئة/النوع
  static Color getCategoryLightColor(String key) {
    final normalizedKey = _normalizeKey(key);
    return _categoryLightColors[normalizedKey] ?? primaryLight;
  }

  /// الحصول على اللون الداكن للفئة/النوع
  static Color getCategoryDarkColor(String key) {
    final normalizedKey = _normalizeKey(key);
    return _categoryDarkColors[normalizedKey] ?? primaryDark;
  }

  /// الحصول على تدرج لوني للفئة/النوع
  static LinearGradient getCategoryGradient(String key) {
    final primaryColor = getCategoryColor(key);
    final darkColor = getCategoryDarkColor(key);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primaryColor, darkColor],
    );
  }

  /// الحصول على تدرج لوني فاتح
  static LinearGradient getCategoryLightGradient(String key) {
    final primaryColor = getCategoryColor(key);
    final lightColor = getCategoryLightColor(key);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [lightColor, primaryColor],
    );
  }

  /// الحصول على تدرج لوني ثلاثي
  static LinearGradient getCategoryTripleGradient(String key) {
    final lightColor = getCategoryLightColor(key);
    final primaryColor = getCategoryColor(key);
    final darkColor = getCategoryDarkColor(key);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [lightColor, primaryColor, darkColor],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  /// الحصول على تدرج لوني مع شفافية
  static LinearGradient getCategoryGradientWithOpacity(String key, {double opacity = 0.9}) {
    final primaryColor = getCategoryColor(key);
    final darkColor = getCategoryDarkColor(key);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor.withValues(alpha: opacity),
        darkColor.withValues(alpha: opacity * 0.8),
      ],
    );
  }

  // ===== دوال الصلوات =====

  /// الحصول على لون الصلاة
  static Color getPrayerColor(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
      case 'الفجر':
        return primary;
      case 'dhuhr':
      case 'الظهر':
        return accent;
      case 'asr':
      case 'العصر':
        return primaryLight;
      case 'maghrib':
      case 'المغرب':
        return tertiary;
      case 'isha':
      case 'العشاء':
        return const Color(0xFF3A453A);
      case 'sunrise':
      case 'الشروق':
        return accentLight;
      default:
        return primary;
    }
  }

  /// الحصول على تدرج الصلاة
  static LinearGradient getPrayerGradient(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
      case 'الفجر':
        return fajrGradient;
      case 'dhuhr':
      case 'الظهر':
        return dhuhrGradient;
      case 'asr':
      case 'العصر':
        return asrGradient;
      case 'maghrib':
      case 'المغرب':
        return maghribGradient;
      case 'isha':
      case 'العشاء':
        return ishaGradient;
      case 'sunrise':
      case 'الشروق':
        return sunriseGradient;
      default:
        return primaryGradient;
    }
  }

  // ===== دوال الألوان حسب السياق =====

  /// الحصول على لون الخلفية حسب الثيم
  static Color getBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkAppBackground
        : appBackground;
  }

  /// الحصول على لون السطح حسب الثيم
  static Color getSurface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurface
        : lightSurface;
  }

  /// الحصول على لون البطاقة حسب الثيم
  static Color getCard(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkCard
        : lightCard;
  }

  /// الحصول على لون النص الأساسي حسب الثيم
  static Color getTextPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextPrimary
        : lightTextPrimary;
  }

  /// الحصول على لون النص الثانوي حسب الثيم
  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextSecondary
        : lightTextSecondary;
  }

  /// الحصول على لون الفاصل حسب الثيم
  static Color getDivider(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkDivider
        : lightDivider;
  }

  // ===== دوال التدرجات حسب السياق =====

  /// الحصول على تدرج خلفية التطبيق
  static LinearGradient getAppBackgroundGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackgroundGradient
        : backgroundGradient;
  }

  /// الحصول على تدرج خلفية الأذكار
  static LinearGradient getAthkarBackgroundGradient(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkAthkarBackgroundGradient
        : athkarBackgroundGradient;
  }

  /// الحصول على تدرج حسب الوقت
  static LinearGradient getTimeBasedGradient() {
    final hour = DateTime.now().hour;
    
    if (hour < 5) {
      return const LinearGradient(
        colors: [darkCard, darkBackground],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 8) {
      return fajrGradient;
    } else if (hour < 12) {
      return const LinearGradient(
        colors: [primaryLight, primarySoft],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 15) {
      return dhuhrGradient;
    } else if (hour < 17) {
      return asrGradient;
    } else if (hour < 20) {
      return maghribGradient;
    } else {
      return ishaGradient;
    }
  }

  // ===== دوال مساعدة =====

  /// تطبيع المفتاح للبحث
  static String _normalizeKey(String key) {
    return key.toLowerCase().trim();
  }

  /// التحقق من وجود مفتاح
  static bool hasColor(String key) {
    final normalizedKey = _normalizeKey(key);
    return _categoryColors.containsKey(normalizedKey);
  }

  /// الحصول على جميع المفاتيح المتاحة
  static List<String> getAllKeys() {
    return _categoryColors.keys.toList();
  }

  /// الحصول على ألوان عشوائية للتجربة
  static Color getRandomColor() {
    final keys = _categoryColors.keys.toList();
    final randomKey = keys[DateTime.now().millisecondsSinceEpoch % keys.length];
    return _categoryColors[randomKey]!;
  }

  /// إنشاء تدرج مخصص
  static LinearGradient customGradient({
    required List<Color> colors,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    List<double>? stops,
  }) {
    return LinearGradient(
      colors: colors,
      begin: begin,
      end: end,
      stops: stops,
    );
  }
}

/// Extension لتسهيل الاستخدام
extension AppColorSystemExtension on String {
  /// الحصول على اللون الأساسي مباشرة من النص
  Color get categoryColor => AppColorSystem.getCategoryColor(this);
  
  /// الحصول على اللون الفاتح
  Color get categoryLightColor => AppColorSystem.getCategoryLightColor(this);
  
  /// الحصول على اللون الداكن  
  Color get categoryDarkColor => AppColorSystem.getCategoryDarkColor(this);
  
  /// الحصول على التدرج اللوني
  LinearGradient get categoryGradient => AppColorSystem.getCategoryGradient(this);
  
  /// الحصول على لون الظل
  Color categoryShadowColor([double opacity = 0.3]) => 
      AppColorSystem.getCategoryColor(this).withValues(alpha: opacity);
}