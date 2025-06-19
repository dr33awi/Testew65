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
  };

  static const Map<String, Color> _categoryColors = {
    'prayer_times': ThemeConstants.primary,
    'athkar': ThemeConstants.accent,
    'quran': ThemeConstants.tertiary,
    'qibla': ThemeConstants.primaryDark,
    'tasbih': ThemeConstants.accentDark,
    'dua': ThemeConstants.tertiaryDark,
  };

  static const Map<String, Color> _importanceColors = {
    'high': ThemeConstants.error,
    'عالي': ThemeConstants.error,
    'medium': ThemeConstants.warning,
    'متوسط': ThemeConstants.warning,
    'low': ThemeConstants.info,
    'منخفض': ThemeConstants.info,
    'success': ThemeConstants.success,
    'نجح': ThemeConstants.success,
  };

  // ===== الدوال الرئيسية =====
  
  /// الحصول على تدرج لوني حسب الفئة
  static LinearGradient getCategoryGradient(String categoryId) {
    final colors = _categoryGradients[categoryId] ?? 
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
    return _categoryColors[categoryId] ?? ThemeConstants.primary;
  }

  /// الحصول على لون حسب مستوى الأهمية
  static Color getImportanceColor(String level) {
    return _importanceColors[level.toLowerCase()] ?? ThemeConstants.primary;
  }

  /// الحصول على تدرج لوني حسب حالة التقدم
  static LinearGradient getProgressGradient(double progress) {
    List<Color> colors;
    
    if (progress < 0.3) {
      colors = [
        ThemeConstants.error.withOpacity(0.8), 
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
      // ليل
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
      // مغر