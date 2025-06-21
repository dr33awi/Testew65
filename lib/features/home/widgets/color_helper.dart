// lib/features/home/widgets/color_helper.dart
import 'package:athkar_app/app/themes/theme_constants.dart';
import 'package:flutter/material.dart';

/// مساعد لتوحيد الألوان في جميع أنحاء التطبيق
class ColorHelper {
  ColorHelper._();

  // تدرجات الفئات محفوظة للأداء
  static const Map<String, List<Color>> _categoryGradients = {
    'prayer_times': [ThemeConstants.primary, ThemeConstants.primaryLight],
    'athkar': [ThemeConstants.accent, ThemeConstants.accentLight],
    'quran': [ThemeConstants.tertiary, ThemeConstants.tertiaryLight],
    'qibla': [ThemeConstants.primaryDark, ThemeConstants.primary],
    'tasbih': [ThemeConstants.accentDark, ThemeConstants.accent],
    'dua': [ThemeConstants.tertiaryDark, ThemeConstants.tertiary],
  };

  static const Map<String, Color> _categoryColors = {
    'prayer_times': ThemeConstants.primary,
    'athkar': ThemeConstants.accent,
    'quran': ThemeConstants.tertiary,
    'qibla': ThemeConstants.primaryDark,
    'tasbih': ThemeConstants.accentDark,
    'dua': ThemeConstants.tertiaryDark,
  };

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
    switch (contentType.toLowerCase()) {
      case 'verse':
      case 'آية':
        return getCategoryGradient('quran');
      case 'hadith':
      case 'حديث':
        return getCategoryGradient('athkar');
      case 'dua':
      case 'دعاء':
        return getCategoryGradient('dua');
      case 'athkar':
      case 'أذكار':
        return getCategoryGradient('athkar');
      default:
        return ThemeConstants.primaryGradient;
    }
  }

  /// الحصول على تدرج لوني حسب حالة التقدم
  static LinearGradient getProgressGradient(double progress) {
    if (progress < 0.3) {
      return LinearGradient(
        colors: [ThemeConstants.error.withOpacity(0.8), ThemeConstants.warning],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (progress < 0.7) {
      return const LinearGradient(
        colors: [ThemeConstants.warning, ThemeConstants.accent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return const LinearGradient(
        colors: [ThemeConstants.success, ThemeConstants.primary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
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
      // مغرب
      colors = [ThemeConstants.tertiary, ThemeConstants.tertiaryLight];
    } else {
      // مساء
      colors = [ThemeConstants.primaryDark, ThemeConstants.primary];
    }
    
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
    switch (level.toLowerCase()) {
      case 'high':
      case 'عالي':
        return ThemeConstants.error;
      case 'medium':
      case 'متوسط':
        return ThemeConstants.warning;
      case 'low':
      case 'منخفض':
        return ThemeConstants.info;
      case 'success':
      case 'نجح':
        return ThemeConstants.success;
      default:
        return ThemeConstants.primary;
    }
  }

  /// الحصول على لون النص المتباين
  static Color getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  /// دمج لونين بنسبة معينة
  static Color blendColors(Color color1, Color color2, double ratio) {
    ratio = ratio.clamp(0.0, 1.0);
    
    return Color.fromARGB(
      ((1 - ratio) * color1.alpha + ratio * color2.alpha).round(),
      ((1 - ratio) * color1.red + ratio * color2.red).round(),
      ((1 - ratio) * color1.green + ratio * color2.green).round(),
      ((1 - ratio) * color1.blue + ratio * color2.blue).round(),
    );
  }

  /// الحصول على مجموعة ألوان متناسقة
  static List<Color> getHarmoniousColors(Color baseColor, {int count = 3}) {
    final hsl = HSLColor.fromColor(baseColor);
    final colors = <Color>[];
    
    for (int i = 0; i < count; i++) {
      final newHue = (hsl.hue + (i * 360 / count)) % 360;
      colors.add(hsl.withHue(newHue).toColor());
    }
    
    return colors;
  }

  /// تطبيق شفافية على لون مع الحفاظ على قوة اللون
  static Color applyOpacitySafely(Color color, double opacity) {
    opacity = opacity.clamp(0.0, 1.0);
    return color.withValues(alpha: opacity);
  }

  /// الحصول على تدرج شفاف
  static LinearGradient getTransparentGradient(Color color, {
    Alignment begin = Alignment.topCenter,
    Alignment end = Alignment.bottomCenter,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [
        color.withValues(alpha: 0.0),
        color.withValues(alpha: 0.3),
        color.withValues(alpha: 0.7),
        color,
      ],
      stops: const [0.0, 0.3, 0.7, 1.0],
    );
  }
}