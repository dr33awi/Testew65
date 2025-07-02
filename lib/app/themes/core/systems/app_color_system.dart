// lib/app/themes/core/systems/app_color_system.dart - بدون Extensions مكررة
import 'package:flutter/material.dart';

/// نظام الألوان الموحد - المصدر الأساسي الوحيد لجميع ألوان التطبيق
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

  // ===== الدوال الأساسية الموحدة - واحدة فقط لكل غرض =====

  /// الدالة الأساسية للحصول على أي لون
  static Color getColor(String key) {
    final normalizedKey = key.toLowerCase().trim();
    return _colorMap[normalizedKey] ?? primary;
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

  // ===== دوال مساعدة داخلية - تجنب التكرار =====
  
  /// تفتيح اللون - دالة واحدة لكل التطبيق
  static Color _lightenColor(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  /// تغميق اللون - دالة واحدة لكل التطبيق
  static Color _darkenColor(Color color, [double amount = 0.1]) {
    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }

  // ===== Aliases للتوافق مع الكود الموجود - بدون تكرار المنطق =====
  
  static Color getCategoryColor(String key) => getColor(key);
  static Color getCategoryLightColor(String key) => getLightColor(key);
  static Color getCategoryDarkColor(String key) => getDarkColor(key);
  static Color getPrayerColor(String prayerName) => getColor(prayerName);
  static Color getQuoteColor(String quoteType) => getColor(quoteType);

  // ===== التدرجات - منطق موحد =====

  /// تدرج أساسي - دالة واحدة
  static LinearGradient getGradient(String key) {
    final primaryColor = getColor(key);
    final darkColor = getDarkColor(key);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primaryColor, darkColor],
    );
  }

  // جميع دوال التدرج تستخدم نفس المنطق
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

  // ===== دوال السياق - منطق موحد =====

  static Color getBackground(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkBackground
        : lightBackground;
  }

  static Color getSurface(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkSurface
        : lightSurface;
  }

  static Color getCard(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkCard
        : lightCard;
  }

  static Color getTextPrimary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextPrimary
        : lightTextPrimary;
  }

  static Color getTextSecondary(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkTextSecondary
        : lightTextSecondary;
  }

  static Color getDivider(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkDivider
        : lightDivider;
  }

  // ===== دوال مساعدة =====

  static bool hasColor(String key) {
    final normalizedKey = key.toLowerCase().trim();
    return _colorMap.containsKey(normalizedKey);
  }

  static List<String> getAllKeys() => _colorMap.keys.toList();
}

