// lib/app/themes/core/systems/app_color_system.dart - مصحح
import 'package:flutter/material.dart';
import 'package:athkar_app/app/themes/theme_constants.dart';

/// نظام الألوان الموحد للتطبيق
/// يزيل التكرار ويوحد منطق الألوان في مكان واحد
class AppColorSystem {
  AppColorSystem._();

  // ===== خريطة الألوان الأساسية =====
  static const Map<String, Color> _primaryColors = {
    // فئات الأذكار
    'morning': ThemeConstants.primary,
    'الصباح': ThemeConstants.primary,
    'أذكار الصباح': ThemeConstants.primary,
    'evening': ThemeConstants.accent,
    'المساء': ThemeConstants.accent,
    'أذكار المساء': ThemeConstants.accent,
    'sleep': ThemeConstants.tertiary,
    'النوم': ThemeConstants.tertiary,
    'أذكار النوم': ThemeConstants.tertiary,
    'prayer': ThemeConstants.primaryLight,
    'بعد الصلاة': ThemeConstants.primaryLight,
    'أذكار بعد الصلاة': ThemeConstants.primaryLight,
    'wakeup': ThemeConstants.primarySoft,
    'الاستيقاظ': ThemeConstants.primarySoft,
    'أذكار الاستيقاظ': ThemeConstants.primarySoft,
    'travel': ThemeConstants.accentDark,
    'السفر': ThemeConstants.accentDark,
    'أذكار السفر': ThemeConstants.accentDark,
    'eating': ThemeConstants.tertiaryLight,
    'الطعام': ThemeConstants.tertiaryLight,
    'أذكار الطعام': ThemeConstants.tertiaryLight,
    'general': ThemeConstants.tertiaryDark,
    'عامة': ThemeConstants.tertiaryDark,
    'أذكار عامة': ThemeConstants.tertiaryDark,
    
    // فئات التطبيق الرئيسية
    'prayer_times': ThemeConstants.primary,
    'athkar': ThemeConstants.accent,
    'quran': ThemeConstants.tertiary,
    'qibla': ThemeConstants.primaryDark,
    'tasbih': ThemeConstants.accentDark,
    'dua': ThemeConstants.tertiaryDark,
    
    // أنواع الاقتباسات
    'verse': ThemeConstants.primary,
    'آية': ThemeConstants.primary,
    'hadith': ThemeConstants.accent,
    'حديث': ThemeConstants.accent,
    'dua_quote': ThemeConstants.tertiary,
    'دعاء': ThemeConstants.tertiary,
    
    // الألوان الدلالية
    'success': ThemeConstants.success,
    'error': ThemeConstants.error,
    'warning': ThemeConstants.warning,
    'info': ThemeConstants.info,
  };

  // ===== خريطة الألوان الفاتحة =====
  static const Map<String, Color> _lightColors = {
    'morning': ThemeConstants.primaryLight,
    'الصباح': ThemeConstants.primaryLight,
    'أذكار الصباح': ThemeConstants.primaryLight,
    'evening': ThemeConstants.accentLight,
    'المساء': ThemeConstants.accentLight,
    'أذكار المساء': ThemeConstants.accentLight,
    'sleep': ThemeConstants.tertiaryLight,
    'النوم': ThemeConstants.tertiaryLight,
    'أذكار النوم': ThemeConstants.tertiaryLight,
    'prayer': ThemeConstants.primarySoft,
    'بعد الصلاة': ThemeConstants.primarySoft,
    'أذكار بعد الصلاة': ThemeConstants.primarySoft,
    'wakeup': ThemeConstants.primaryLight,
    'الاستيقاظ': ThemeConstants.primaryLight,
    'أذكار الاستيقاظ': ThemeConstants.primaryLight,
    'travel': ThemeConstants.accent,
    'السفر': ThemeConstants.accent,
    'أذكار السفر': ThemeConstants.accent,
    'eating': ThemeConstants.tertiary,
    'الطعام': ThemeConstants.tertiary,
    'أذكار الطعام': ThemeConstants.tertiary,
    'general': ThemeConstants.tertiary,
    'عامة': ThemeConstants.tertiary,
    'أذكار عامة': ThemeConstants.tertiary,
    
    // فئات التطبيق الرئيسية
    'prayer_times': ThemeConstants.primaryLight,
    'athkar': ThemeConstants.accentLight,
    'quran': ThemeConstants.tertiaryLight,
    'qibla': ThemeConstants.primary,
    'tasbih': ThemeConstants.accent,
    'dua': ThemeConstants.tertiary,
    
    // أنواع الاقتباسات
    'verse': ThemeConstants.primaryLight,
    'آية': ThemeConstants.primaryLight,
    'hadith': ThemeConstants.accentLight,
    'حديث': ThemeConstants.accentLight,
    'dua_quote': ThemeConstants.tertiaryLight,
    'دعاء': ThemeConstants.tertiaryLight,
    
    // الألوان الدلالية
    'success': ThemeConstants.successLight,
    'error': ThemeConstants.error,
    'warning': ThemeConstants.warningLight,
    'info': ThemeConstants.infoLight,
  };

  // ===== خريطة الألوان الداكنة =====
  static const Map<String, Color> _darkColors = {
    'morning': ThemeConstants.primaryDark,
    'الصباح': ThemeConstants.primaryDark,
    'أذكار الصباح': ThemeConstants.primaryDark,
    'evening': ThemeConstants.accentDark,
    'المساء': ThemeConstants.accentDark,
    'أذكار المساء': ThemeConstants.accentDark,
    'sleep': ThemeConstants.tertiaryDark,
    'النوم': ThemeConstants.tertiaryDark,
    'أذكار النوم': ThemeConstants.tertiaryDark,
    'prayer': ThemeConstants.primary,
    'بعد الصلاة': ThemeConstants.primary,
    'أذكار بعد الصلاة': ThemeConstants.primary,
    'wakeup': ThemeConstants.primary,
    'الاستيقاظ': ThemeConstants.primary,
    'أذكار الاستيقاظ': ThemeConstants.primary,
    'travel': ThemeConstants.accentDark,
    'السفر': ThemeConstants.accentDark,
    'أذكار السفر': ThemeConstants.accentDark,
    'eating': ThemeConstants.tertiaryDark,
    'الطعام': ThemeConstants.tertiaryDark,
    'أذكار الطعام': ThemeConstants.tertiaryDark,
    'general': ThemeConstants.tertiaryDark,
    'عامة': ThemeConstants.tertiaryDark,
    'أذكار عامة': ThemeConstants.tertiaryDark,
    
    // فئات التطبيق الرئيسية
    'prayer_times': ThemeConstants.primaryDark,
    'athkar': ThemeConstants.accentDark,
    'quran': ThemeConstants.tertiaryDark,
    'qibla': ThemeConstants.primaryDark,
    'tasbih': ThemeConstants.accentDark,
    'dua': ThemeConstants.tertiaryDark,
    
    // أنواع الاقتباسات
    'verse': ThemeConstants.primaryDark,
    'آية': ThemeConstants.primaryDark,
    'hadith': ThemeConstants.accentDark,
    'حديث': ThemeConstants.accentDark,
    'dua_quote': ThemeConstants.tertiaryDark,
    'دعاء': ThemeConstants.tertiaryDark,
    
    // الألوان الدلالية
    'success': ThemeConstants.primary,
    'error': ThemeConstants.error,
    'warning': ThemeConstants.warning,
    'info': ThemeConstants.info,
  };

  // ===== الدوال الأساسية =====

  /// الحصول على اللون الأساسي
  static Color getPrimaryColor(String key) {
    final normalizedKey = _normalizeKey(key);
    return _primaryColors[normalizedKey] ?? ThemeConstants.primary;
  }

  /// الحصول على اللون الفاتح
  static Color getLightColor(String key) {
    final normalizedKey = _normalizeKey(key);
    return _lightColors[normalizedKey] ?? ThemeConstants.primaryLight;
  }

  /// الحصول على اللون الداكن
  static Color getDarkColor(String key) {
    final normalizedKey = _normalizeKey(key);
    return _darkColors[normalizedKey] ?? ThemeConstants.primaryDark;
  }

  /// الحصول على تدرج لوني أساسي
  static LinearGradient getGradient(String key) {
    final primary = getPrimaryColor(key);
    final dark = getDarkColor(key);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [primary, dark],
    );
  }

  /// الحصول على تدرج لوني مع الفاتح
  static LinearGradient getLightGradient(String key) {
    final primary = getPrimaryColor(key);
    final light = getLightColor(key);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [light, primary],
    );
  }

  /// الحصول على تدرج لوني ثلاثي
  static LinearGradient getTripleGradient(String key) {
    final light = getLightColor(key);
    final primary = getPrimaryColor(key);
    final dark = getDarkColor(key);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [light, primary, dark],
      stops: const [0.0, 0.5, 1.0],
    );
  }

  /// الحصول على تدرج لوني مع شفافية
  static LinearGradient getGradientWithOpacity(String key, {double opacity = 0.9}) {
    final primary = getPrimaryColor(key);
    final dark = getDarkColor(key);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primary.withValues(alpha: opacity),
        dark.withValues(alpha: opacity * 0.8),
      ],
    );
  }

  /// الحصول على لون الظل المناسب
  static Color getShadowColor(String key, {double opacity = 0.3}) {
    final primary = getPrimaryColor(key);
    return primary.withValues(alpha: opacity);
  }

  /// الحصول على لون الحدود المناسب
  static Color getBorderColor(String key, {double opacity = 0.2}) {
    return Colors.white.withValues(alpha: opacity);
  }

  /// الحصول على لون الخلفية الشفافة
  static Color getOverlayColor(String key, {double opacity = 0.15}) {
    return Colors.white.withValues(alpha: opacity);
  }

  // ===== دوال مساعدة =====

  /// تطبيع المفتاح للبحث
  static String _normalizeKey(String key) {
    return key.toLowerCase().trim();
  }

  /// التحقق من وجود مفتاح
  static bool hasColor(String key) {
    final normalizedKey = _normalizeKey(key);
    return _primaryColors.containsKey(normalizedKey);
  }

  /// الحصول على جميع المفاتيح المتاحة
  static List<String> getAllKeys() {
    return _primaryColors.keys.toList();
  }

  /// الحصول على ألوان عشوائية للتجربة
  static Color getRandomColor() {
    final keys = _primaryColors.keys.toList();
    final randomKey = keys[DateTime.now().millisecondsSinceEpoch % keys.length];
    return _primaryColors[randomKey]!;
  }

  // ===== دوال للتوافق مع الكود الموجود =====

  /// للتوافق مع CategoryHelper
  @Deprecated('استخدم getPrimaryColor بدلاً منها')
  static Color getCategoryColor(BuildContext context, String categoryId) {
    return getPrimaryColor(categoryId);
  }

  /// للتوافق مع QuoteHelper  
  @Deprecated('استخدم getPrimaryColor بدلاً منها')
  static Color getQuotePrimaryColor(BuildContext context, String quoteType) {
    return getPrimaryColor(quoteType);
  }

  /// للتوافق مع ThemeConstants
  @Deprecated('استخدم getPrimaryColor بدلاً منها')
  static Color getPrayerColor(String name) {
    return getPrimaryColor(name);
  }
}

/// Extension للسهولة في الاستخدام
extension AppColorSystemExtension on String {
  /// الحصول على اللون الأساسي مباشرة من النص
  Color get primaryColor => AppColorSystem.getPrimaryColor(this);
  
  /// الحصول على اللون الفاتح
  Color get lightColor => AppColorSystem.getLightColor(this);
  
  /// الحصول على اللون الداكن  
  Color get darkColor => AppColorSystem.getDarkColor(this);
  
  /// الحصول على التدرج اللوني
  LinearGradient get gradient => AppColorSystem.getGradient(this);
  
  /// الحصول على لون الظل
  Color shadowColor([double opacity = 0.3]) => AppColorSystem.getShadowColor(this, opacity: opacity);
}