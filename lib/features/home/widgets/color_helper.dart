// lib/features/home/widgets/color_helper.dart

import 'package:flutter/material.dart';
import '../../../app/themes/theme_constants.dart';

/// مساعد موحد للألوان - مستقل وقابل لإعادة الاستخدام
class ColorHelper {
  ColorHelper._();

  // ===== خرائط الألوان الثابتة =====
  
  static const Map<String, List<Color>> _categoryGradients = {
    'prayer_times': [ThemeConstants.primary, ThemeConstants.primaryLight],
    'athkar': [ThemeConstants.accent, ThemeConstants.accentLight],
    'quran': [ThemeConstants.tertiary, ThemeConstants.tertiaryLight],
    'qibla': [ThemeConstants.primaryDark, ThemeConstants.primary],
    'tasbih': [ThemeConstants.accentDark, ThemeConstants.accent],
    'dua': [ThemeConstants.tertiaryDark, ThemeConstants.tertiary],
    'hadith': [ThemeConstants.success, ThemeConstants.successLight],
    'names': [ThemeConstants.info, ThemeConstants.infoLight],
    'calendar': [ThemeConstants.warning, ThemeConstants.warningLight],
    'settings': [Color(0xFF6B7280), Color(0xFF9CA3AF)],
  };

  static const Map<String, List<Color>> _contentGradients = {
    'verse': [ThemeConstants.primary, ThemeConstants.primaryLight],
    'آية': [ThemeConstants.primary, ThemeConstants.primaryLight],
    'hadith': [ThemeConstants.accent, ThemeConstants.accentLight],
    'حديث': [ThemeConstants.accent, ThemeConstants.accentLight],
    'dua': [ThemeConstants.tertiary, ThemeConstants.tertiaryLight],
    'دعاء': [ThemeConstants.tertiary, ThemeConstants.tertiaryLight],
    'athkar': [ThemeConstants.accentDark, ThemeConstants.accent],
    'أذكار': [ThemeConstants.accentDark, ThemeConstants.accent],
    'tasbih': [ThemeConstants.success, ThemeConstants.successLight],
    'تسبيح': [ThemeConstants.success, ThemeConstants.successLight],
    'quote': [ThemeConstants.info, ThemeConstants.infoLight],
    'اقتباس': [ThemeConstants.info, ThemeConstants.infoLight],
  };

  static const Map<String, Color> _categoryColors = {
    'prayer_times': ThemeConstants.primary,
    'athkar': ThemeConstants.accent,
    'quran': ThemeConstants.tertiary,
    'qibla': ThemeConstants.primaryDark,
    'tasbih': ThemeConstants.accentDark,
    'dua': ThemeConstants.tertiaryDark,
    'hadith': ThemeConstants.success,
    'names': ThemeConstants.info,
    'calendar': ThemeConstants.warning,
    'settings': Color(0xFF6B7280),
    'favorites': Color(0xFFEF4444),
    'history': Color(0xFF8B5CF6),
    'about': Color(0xFF06B6D4),
  };

  static const Map<String, Color> _importanceColors = {
    'high': ThemeConstants.error,
    'عالي': ThemeConstants.error,
    'critical': ThemeConstants.error,
    'حرج': ThemeConstants.error,
    'medium': ThemeConstants.warning,
    'متوسط': ThemeConstants.warning,
    'normal': ThemeConstants.warning,
    'عادي': ThemeConstants.warning,
    'low': ThemeConstants.info,
    'منخفض': ThemeConstants.info,
    'minor': ThemeConstants.info,
    'بسيط': ThemeConstants.info,
    'success': ThemeConstants.success,
    'نجح': ThemeConstants.success,
    'completed': ThemeConstants.success,
    'مكتمل': ThemeConstants.success,
  };

  static const Map<String, Color> _moodColors = {
    'happy': Color(0xFFFEF3C7),
    'سعيد': Color(0xFFFEF3C7),
    'peaceful': Color(0xFFDCFCE7),
    'هادئ': Color(0xFFDCFCE7),
    'focused': Color(0xFFDDD6FE),
    'مركز': Color(0xFFDDD6FE),
    'grateful': Color(0xFFFDE68A),
    'ممتن': Color(0xFFFDE68A),
    'contemplative': Color(0xFFE0E7FF),
    'متأمل': Color(0xFFE0E7FF),
    'energetic': Color(0xFFFECDD3),
    'نشيط': Color(0xFFFECDD3),
  };

  // ===== الدوال الرئيسية =====
  
  /// الحصول على تدرج لوني حسب الفئة
  static LinearGradient getCategoryGradient(String categoryId) {
    final colors = _categoryGradients[categoryId.toLowerCase()] ?? 
                  [ThemeConstants.primary, ThemeConstants.primaryLight];
    
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// الحصول على تدرج لوني حسب نوع المحتوى
  static LinearGradient getContentGradient(String contentType) {
    final colors = _contentGradients[contentType.toLowerCase()] ?? 
                  [ThemeConstants.primary, ThemeConstants.primaryLight];
    
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// الحصول على لون أساسي حسب الفئة
  static Color getCategoryColor(String categoryId) {
    return _categoryColors[categoryId.toLowerCase()] ?? ThemeConstants.primary;
  }

  /// الحصول على لون حسب مستوى الأهمية
  static Color getImportanceColor(String level) {
    return _importanceColors[level.toLowerCase()] ?? ThemeConstants.primary;
  }

  /// الحصول على لون حسب الحالة المزاجية
  static Color getMoodColor(String mood) {
    return _moodColors[mood.toLowerCase()] ?? ThemeConstants.primary.withValues(alpha: 0.1);
  }

  /// الحصول على تدرج لوني حسب حالة التقدم
  static LinearGradient getProgressGradient(double progress) {
    List<Color> colors;
    
    if (progress < 0.3) {
      colors = [
        ThemeConstants.error.withValues(alpha: 0.8), 
        ThemeConstants.warning,
      ];
    } else if (progress < 0.7) {
      colors = [
        ThemeConstants.warning, 
        ThemeConstants.accent,
      ];
    } else {
      colors = [
        ThemeConstants.success, 
        ThemeConstants.primary,
      ];
    }
    
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// الحصول على تدرج لوني حسب الوقت
  static LinearGradient getTimeBasedGradient({DateTime? dateTime}) {
    final time = dateTime ?? DateTime.now();
    final hour = time.hour;
    
    List<Color> colors;
    
    if (hour < 5) {
      // ليل عميق
      colors = [ThemeConstants.darkBackground, ThemeConstants.darkCard];
    } else if (hour < 8) {
      // فجر
      colors = [ThemeConstants.primaryDark, ThemeConstants.primary];
    } else if (hour < 12) {
      // صباح
      colors = [ThemeConstants.accent, ThemeConstants.accentLight];
    } else if (hour < 15) {
      // ظهر
      colors = [ThemeConstants.primary, ThemeConstants.primaryLight];
    } else if (hour < 17) {
      // عصر
      colors = [ThemeConstants.primaryLight, ThemeConstants.primarySoft];
    } else if (hour < 20) {
      // مغرب
      colors = [ThemeConstants.tertiary, ThemeConstants.tertiaryLight];
    } else {
      // عشاء ومساء
      colors = [ThemeConstants.primaryDark, ThemeConstants.darkSurface];
    }
    
    return LinearGradient(
      colors: colors,
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }

  /// الحصول على تدرج لوني حسب نوع الصلاة
  static LinearGradient getPrayerGradient(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'fajr':
      case 'الفجر':
        return LinearGradient(
          colors: [ThemeConstants.primaryDark, ThemeConstants.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'dhuhr':
      case 'الظهر':
        return LinearGradient(
          colors: [ThemeConstants.accent, ThemeConstants.accentLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'asr':
      case 'العصر':
        return LinearGradient(
          colors: [ThemeConstants.primaryLight, ThemeConstants.primarySoft],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'maghrib':
      case 'المغرب':
        return LinearGradient(
          colors: [ThemeConstants.tertiary, ThemeConstants.tertiaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'isha':
      case 'العشاء':
        return LinearGradient(
          colors: [ThemeConstants.darkCard, ThemeConstants.darkBackground],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'sunrise':
      case 'الشروق':
        return LinearGradient(
          colors: [ThemeConstants.accentLight, ThemeConstants.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [ThemeConstants.primary, ThemeConstants.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  /// الحصول على تدرج لوني حسب الفصل
  static LinearGradient getSeasonGradient({DateTime? date}) {
    final now = date ?? DateTime.now();
    final month = now.month;
    
    List<Color> colors;
    
    if (month >= 12 || month <= 2) {
      // شتاء
      colors = [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)];
    } else if (month >= 3 && month <= 5) {
      // ربيع
      colors = [ThemeConstants.success, ThemeConstants.successLight];
    } else if (month >= 6 && month <= 8) {
      // صيف
      colors = [ThemeConstants.warning, ThemeConstants.warningLight];
    } else {
      // خريف
      colors = [ThemeConstants.tertiary, ThemeConstants.tertiaryLight];
    }
    
    return LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// الحصول على ألوان متناسقة للرسوم البيانية
  static List<Color> getChartColors({int count = 5}) {
    final baseColors = [
      ThemeConstants.primary,
      ThemeConstants.accent,
      ThemeConstants.tertiary,
      ThemeConstants.success,
      ThemeConstants.info,
      ThemeConstants.warning,
      ThemeConstants.error,
    ];
    
    if (count <= baseColors.length) {
      return baseColors.take(count).toList();
    }
    
    // إنشاء ألوان إضافية إذا احتجنا أكثر
    final colors = <Color>[];
    for (int i = 0; i < count; i++) {
      final baseColor = baseColors[i % baseColors.length];
      final variation = (i / baseColors.length) * 0.3;
      colors.add(baseColor.withValues(alpha: 1.0 - variation));
    }
    
    return colors;
  }

  /// الحصول على لون متباين للنص
  static Color getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  /// الحصول على تدرج لوني للخلفية حسب السياق
  static LinearGradient getContextualGradient(BuildContext context, String type) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    switch (type.toLowerCase()) {
      case 'success':
        return LinearGradient(
          colors: isDark
              ? [ThemeConstants.success.withValues(alpha: 0.2), ThemeConstants.success.withValues(alpha: 0.1)]
              : [ThemeConstants.success.withValues(alpha: 0.1), ThemeConstants.success.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'error':
        return LinearGradient(
          colors: isDark
              ? [ThemeConstants.error.withValues(alpha: 0.2), ThemeConstants.error.withValues(alpha: 0.1)]
              : [ThemeConstants.error.withValues(alpha: 0.1), ThemeConstants.error.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'warning':
        return LinearGradient(
          colors: isDark
              ? [ThemeConstants.warning.withValues(alpha: 0.2), ThemeConstants.warning.withValues(alpha: 0.1)]
              : [ThemeConstants.warning.withValues(alpha: 0.1), ThemeConstants.warning.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'info':
        return LinearGradient(
          colors: isDark
              ? [ThemeConstants.info.withValues(alpha: 0.2), ThemeConstants.info.withValues(alpha: 0.1)]
              : [ThemeConstants.info.withValues(alpha: 0.1), ThemeConstants.info.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: isDark
              ? [ThemeConstants.primary.withValues(alpha: 0.2), ThemeConstants.primary.withValues(alpha: 0.1)]
              : [ThemeConstants.primary.withValues(alpha: 0.1), ThemeConstants.primary.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  /// تدرج لوني للكروت التفاعلية
  static LinearGradient getInteractiveCardGradient(BuildContext context, {
    required bool isPressed,
    required bool isHovered,
    Color? baseColor,
  }) {
    final color = baseColor ?? ThemeConstants.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    double opacity = 0.05;
    if (isPressed) {
      opacity = 0.15;
    } else if (isHovered) {
      opacity = 0.1;
    }
    
    return LinearGradient(
      colors: [
        color.withValues(alpha: opacity),
        color.withValues(alpha: opacity * 0.5),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// الحصول على ألوان للتقويم الهجري
  static Map<String, Color> getHijriCalendarColors() {
    return {
      'muharram': const Color(0xFF1F2937),
      'safar': const Color(0xFF374151),
      'rabi_al_awwal': ThemeConstants.success,
      'rabi_al_thani': ThemeConstants.successLight,
      'jumada_al_awwal': ThemeConstants.primary,
      'jumada_al_thani': ThemeConstants.primaryLight,
      'rajab': ThemeConstants.accent,
      'shaban': ThemeConstants.accentLight,
      'ramadan': ThemeConstants.tertiary,
      'shawwal': ThemeConstants.tertiaryLight,
      'dhu_al_qidah': ThemeConstants.info,
      'dhu_al_hijjah': ThemeConstants.infoLight,
    };
  }

  /// دوال مساعدة للألوان الديناميكية
  static Color interpolateColors(Color startColor, Color endColor, double t) {
    return Color.lerp(startColor, endColor, t.clamp(0.0, 1.0))!;
  }

  /// إنشاء تدرج لوني مخصص
  static LinearGradient createCustomGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      colors: colors,
      stops: stops,
      begin: begin,
      end: end,
    );
  }

  /// الحصول على مجموعة ألوان متدرجة
  static List<Color> generateColorSeries(Color baseColor, int count) {
    final colors = <Color>[];
    for (int i = 0; i < count; i++) {
      final factor = i / (count - 1);
      colors.add(Color.lerp(baseColor.withValues(alpha: 0.3), baseColor, factor)!);
    }
    return colors;
  }
}