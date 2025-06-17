// lib/app/themes/helpers/color_helper.dart
import 'package:athkar_app/app/themes/theme_constants.dart';
import 'package:flutter/material.dart';

/// مساعد لتوحيد الألوان في جميع أنحاء التطبيق
class ColorHelper {
  ColorHelper._();

  /// الحصول على تدرج لوني حسب الفئة
  static LinearGradient getCategoryGradient(String categoryId) {
    switch (categoryId) {
      case 'prayer_times':
        return LinearGradient(
          colors: [ThemeConstants.primary, ThemeConstants.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'athkar':
        return LinearGradient(
          colors: [ThemeConstants.accent, ThemeConstants.accentLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'quran':
        return LinearGradient(
          colors: [ThemeConstants.tertiary, ThemeConstants.tertiaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'qibla':
        return LinearGradient(
          colors: [ThemeConstants.primaryDark, ThemeConstants.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'tasbih':
        return LinearGradient(
          colors: [ThemeConstants.accentDark, ThemeConstants.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'dua':
        return LinearGradient(
          colors: [ThemeConstants.tertiaryDark, ThemeConstants.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return ThemeConstants.primaryGradient;
    }
  }

  /// الحصول على تدرج لوني حسب نوع المحتوى
  static LinearGradient getContentGradient(String contentType) {
    switch (contentType.toLowerCase()) {
      case 'verse':
      case 'آية':
        return LinearGradient(
          colors: [ThemeConstants.primary, ThemeConstants.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'hadith':
      case 'حديث':
        return LinearGradient(
          colors: [ThemeConstants.accent, ThemeConstants.accentLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'dua':
      case 'دعاء':
        return LinearGradient(
          colors: [ThemeConstants.tertiary, ThemeConstants.tertiaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'athkar':
      case 'أذكار':
        return LinearGradient(
          colors: [ThemeConstants.accentDark, ThemeConstants.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
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
      return LinearGradient(
        colors: [ThemeConstants.warning, ThemeConstants.accent],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      return LinearGradient(
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
    
    if (hour < 5) {
      // ليل
      return LinearGradient(
        colors: [ThemeConstants.darkBackground, ThemeConstants.darkCard],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 8) {
      // فجر
      return LinearGradient(
        colors: [ThemeConstants.primaryDark, ThemeConstants.primary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 12) {
      // صباح
      return LinearGradient(
        colors: [ThemeConstants.accent, ThemeConstants.accentLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 15) {
      // ظهر
      return LinearGradient(
        colors: [ThemeConstants.primary, ThemeConstants.primaryLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 17) {
      // عصر
      return LinearGradient(
        colors: [ThemeConstants.primaryLight, ThemeConstants.primarySoft],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 20) {
      // مغرب
      return LinearGradient(
        colors: [ThemeConstants.tertiary, ThemeConstants.tertiaryLight],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      // مساء
      return LinearGradient(
        colors: [ThemeConstants.primaryDark, ThemeConstants.primary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  /// الحصول على لون أساسي حسب الفئة
  static Color getCategoryColor(String categoryId) {
    switch (categoryId) {
      case 'prayer_times':
        return ThemeConstants.primary;
      case 'athkar':
        return ThemeConstants.accent;
      case 'quran':
        return ThemeConstants.tertiary;
      case 'qibla':
        return ThemeConstants.primaryDark;
      case 'tasbih':
        return ThemeConstants.accentDark;
      case 'dua':
        return ThemeConstants.tertiaryDark;
      default:
        return ThemeConstants.primary;
    }
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