// lib/features/home/widgets/color_helper.dart
import 'package:athkar_app/app/themes/theme_constants.dart';
import 'package:flutter/material.dart';

/// مساعد مبسط للألوان - الدوال الأساسية فقط
/// معظم الوظائف الآن متاحة مباشرة من context
class ColorHelper {
  ColorHelper._();

  /// ⚠️ مُهمل - استخدم context.getCategoryGradient() بدلاً منه
  @Deprecated('استخدم context.getCategoryGradient() بدلاً من ذلك')
  static LinearGradient getCategoryGradient(String categoryId) {
    // إبقاء للتوافق المؤقت - سيتم حذفه لاحقاً
    switch (categoryId) {
      case 'prayer_times':
        return const LinearGradient(
          colors: [ThemeConstants.primary, ThemeConstants.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'athkar':
        return const LinearGradient(
          colors: [ThemeConstants.accent, ThemeConstants.accentLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'quran':
        return const LinearGradient(
          colors: [ThemeConstants.tertiary, ThemeConstants.tertiaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'qibla':
        return const LinearGradient(
          colors: [ThemeConstants.primaryDark, ThemeConstants.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'tasbih':
        return const LinearGradient(
          colors: [ThemeConstants.accentDark, ThemeConstants.accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'dua':
        return const LinearGradient(
          colors: [ThemeConstants.tertiaryDark, ThemeConstants.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return ThemeConstants.primaryGradient;
    }
  }

  /// ⚠️ مُهمل - استخدم context.getCategoryColor() بدلاً منه
  @Deprecated('استخدم context.getCategoryColor() بدلاً من ذلك')
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

  // ===== الدوال المفيدة المتبقية =====

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

// ===== تعليق للمطورين =====
/*
ملاحظة: هذا الملف سيتم تبسيطه أو حذفه مستقبلاً

الدوال المُهملة:
- getCategoryGradient() -> استخدم context.getCategoryGradient()
- getCategoryColor() -> استخدم context.getCategoryColor()
- getContentGradient() -> استخدم context.getPrayerGradient()
- getProgressGradient() -> قيم إنشاء دالة في context
- getTimeBasedGradient() -> متاحة في context.getTimeBasedGradient()

الدوال المفيدة المتبقية:
- getImportanceColor()
- getContrastingTextColor()
- blendColors()
- getHarmoniousColors()
- applyOpacitySafely()
- getTransparentGradient()

خطة الإزالة:
1. إصلاح جميع الشاشات لاستخدام context بدلاً من ColorHelper
2. حذف الدوال المُهملة
3. نقل الدوال المفيدة إلى ColorExtensions أو ملف منفصل
4. حذف الملف نهائياً
*/