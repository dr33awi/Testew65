// lib/app/themes/core/systems/app_color_system.dart - النسخة المُحسنة
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

  // ===== خريطة الألوان الموحدة - مُبسطة =====
  static const Map<String, Color> _colorMap = {
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
    
    // فئات التطبيق الرئيسية
    'prayer_times': primary,
    'athkar': accent,
    'quran': tertiary,
    'qibla': primaryDark,
    'tasbih': accentDark,
    'dua': tertiaryDark,
    
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
    'sunrise': accentLight,
    'الشروق': accentLight,
    
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

  // خريطة الألوان الفاتحة
  static const Map<String, Color> _lightColorMap = {
    'morning': primaryLight,
    'الصباح': primaryLight,
    'evening': accentLight,
    'المساء': accentLight,
    'sleep': tertiaryLight,
    'النوم': tertiaryLight,
    'prayer': primarySoft,
    'بعد الصلاة': primarySoft,
    'fajr': primaryLight,
    'الفجر': primaryLight,
    'dhuhr': accentLight,
    'الظهر': accentLight,
    'maghrib': tertiaryLight,
    'المغرب': tertiaryLight,
    'verse': primaryLight,
    'آية': primaryLight,
    'hadith': accentLight,
    'حديث': accentLight,
    'success': successLight,
    'warning': warningLight,
    'info': infoLight,
  };

  // خريطة الألوان الداكنة
  static const Map<String, Color> _darkColorMap = {
    'morning': primaryDark,
    'الصباح': primaryDark,
    'evening': accentDark,
    'المساء': accentDark,
    'sleep': tertiaryDark,
    'النوم': tertiaryDark,
    'prayer': primary,
    'بعد الصلاة': primary,
    'fajr': primaryDark,
    'الفجر': primaryDark,
    'dhuhr': accentDark,
    'الظهر': accentDark,
    'maghrib': tertiaryDark,
    'المغرب': tertiaryDark,
    'verse': primaryDark,
    'آية': primaryDark,
    'hadith': accentDark,
    'حديث': accentDark,
    'success': primary,
    'error': error,
    'warning': warning,
    'info': info,
  };

  // ===== الدوال الأساسية الموحدة =====

  /// الحصول على اللون الأساسي - دالة واحدة لكل شيء
  static Color getColor(String key) {
    final normalizedKey = _normalizeKey(key);
    return _colorMap[normalizedKey] ?? primary;
  }

  /// الحصول على اللون الفاتح
  static Color getLightColor(String key) {
    final normalizedKey = _normalizeKey(key);
    return _lightColorMap[normalizedKey] ?? primaryLight;
  }

  /// الحصول على اللون الداكن
  static Color getDarkColor(String key) {
    final normalizedKey = _normalizeKey(key);
    return _darkColorMap[normalizedKey] ?? primaryDark;
  }

  // ===== Aliases للتوافق مع الكود الموجود =====
  
  /// للفئات
  static Color getCategoryColor(String key) => getColor(key);
  static Color getCategoryLightColor(String key) => getLightColor(key);
  static Color getCategoryDarkColor(String key) => getDarkColor(key);

  /// للصلوات
  static Color getPrayerColor(String prayerName) => getColor(prayerName);

  /// للاقتباسات
  static Color getQuoteColor(String quoteType) => getColor(quoteType);

  // ===== التدرجات اللونية =====

  /// تدرج أساسي لأي مفتاح
  static LinearGradient getGradient(String key) {
    final primaryColor = getColor(key);
    final darkColor = getDarkColor(key);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primaryColor, darkColor],
    );
  }

  // Aliases للتدرجات
  static LinearGradient getCategoryGradient(String key) => getGradient(key);
  static LinearGradient getPrayerGradient(String key) => getGradient(key);
  static LinearGradient getQuoteGradient(String key) => getGradient(key);

  /// تدرج فاتح
  static LinearGradient getLightGradient(String key) {
    final lightColor = getLightColor(key);
    final primaryColor = getColor(key);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [lightColor, primaryColor],
    );
  }

  /// تدرج ثلاثي
  static LinearGradient getTripleGradient(String key) {
    final lightColor = getLightColor(key);
    final primaryColor = getColor(key);
    final darkColor = getDarkColor(key);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [lightColor, primaryColor, darkColor],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  // ===== التدرجات الأساسية الثابتة =====
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
      return getGradient('fajr');
    } else if (hour < 12) {
      return const LinearGradient(
        colors: [primaryLight, primarySoft],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 15) {
      return getGradient('dhuhr');
    } else if (hour < 17) {
      return getGradient('asr');
    } else if (hour < 20) {
      return getGradient('maghrib');
    } else {
      return getGradient('isha');
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
    return _colorMap.containsKey(normalizedKey);
  }

  /// الحصول على جميع المفاتيح المتاحة
  static List<String> getAllKeys() {
    return _colorMap.keys.toList();
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

/// Extension موحد للاستخدام السهل
extension AppColorSystemExtension on String {
  /// الحصول على اللون الأساسي مباشرة من النص
  Color get color => AppColorSystem.getColor(this);
  Color get lightColor => AppColorSystem.getLightColor(this);
  Color get darkColor => AppColorSystem.getDarkColor(this);
  
  /// للتوافق مع الكود الموجود
  Color get categoryColor => AppColorSystem.getCategoryColor(this);
  Color get prayerColor => AppColorSystem.getPrayerColor(this);
  Color get quoteColor => AppColorSystem.getQuoteColor(this);
  
  /// التدرجات
  LinearGradient get gradient => AppColorSystem.getGradient(this);
  LinearGradient get categoryGradient => AppColorSystem.getCategoryGradient(this);
  LinearGradient get prayerGradient => AppColorSystem.getPrayerGradient(this);
  
  /// الحصول على لون الظل
  Color colorShadow([double opacity = 0.3]) => 
      AppColorSystem.getColor(this).withValues(alpha: opacity);
}