// lib/app/themes/helpers/theme_helpers.dart
import 'package:flutter/material.dart';
import '../theme_constants.dart';

/// مساعدات لتسهيل العمل مع الثيم
class ThemeHelpers {
  ThemeHelpers._();

  /// الحصول على تدرج لوني حسب الفئة - محدث للألوان الجديدة
  static LinearGradient getCategoryGradient(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'prayer_times':
      case 'prayer':
        return ThemeConstants.prayerGradient;
      case 'athkar':
        return ThemeConstants.athkarGradient;
      case 'quran':
        return ThemeConstants.tertiaryGradient;
      case 'qibla':
        return ThemeConstants.qiblaGradient;
      case 'tasbih':
        return ThemeConstants.tasbihGradient;
      case 'dua':
        return LinearGradient(
          colors: [ThemeConstants.primarySoft, ThemeConstants.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return ThemeConstants.primaryGradient;
    }
  }

  /// الحصول على تدرج لوني حسب نوع المحتوى - محدث
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
        return ThemeConstants.athkarGradient;
      default:
        return ThemeConstants.primaryGradient;
    }
  }

  /// الحصول على تدرج لوني حسب حالة التقدم
  static LinearGradient getProgressGradient(double progress) {
    if (progress < 0.3) {
      return LinearGradient(
        colors: [ThemeConstants.error.withValues(alpha: 0.8), ThemeConstants.warning],
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
      return ThemeConstants.accentGradient;
    } else if (hour < 15) {
      // ظهر
      return ThemeConstants.primaryGradient;
    } else if (hour < 17) {
      // عصر
      return LinearGradient(
        colors: [ThemeConstants.primaryLight, ThemeConstants.primarySoft],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour < 20) {
      // مغرب
      return ThemeConstants.tertiaryGradient;
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
    switch (categoryId.toLowerCase()) {
      case 'prayer_times':
      case 'prayer':
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

  /// ألوان الصلوات المحدثة للطابع الجديد
  static Color getPrayerColor(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'الفجر':
      case 'fajr':
        return const Color(0xFF6B8E9F); // أزرق رمادي هادئ للفجر
      case 'الظهر':
      case 'dhuhr':
        return const Color(0xFFB8860B); // ذهبي دافئ للظهر
      case 'العصر':
      case 'asr':
        return const Color(0xFFD4A574); // برتقالي دافئ للعصر
      case 'المغرب':
      case 'maghrib':
        return const Color(0xFF8B6F47); // بني دافئ للمغرب
      case 'العشاء':
      case 'isha':
        return const Color(0xFF5D7052); // أخضر زيتي للعشاء
      default:
        return ThemeConstants.primary;
    }
  }

  static LinearGradient prayerGradient(String prayerName) {
    final color = getPrayerColor(prayerName);
    Color secondColor;
    
    switch (prayerName.toLowerCase()) {
      case 'الفجر':
      case 'fajr':
        secondColor = const Color(0xFF8FA9B8);
        break;
      case 'الظهر':
      case 'dhuhr':
        secondColor = const Color(0xFFDAA520);
        break;
      case 'العصر':
      case 'asr':
        secondColor = const Color(0xFFE8C899);
        break;
      case 'المغرب':
      case 'maghrib':
        secondColor = const Color(0xFFA68B5B);
        break;
      case 'العشاء':
      case 'isha':
        secondColor = const Color(0xFF7A8B6F);
        break;
      default:
        secondColor = color.withValues(alpha: 0.8);
    }
    
    return LinearGradient(
      colors: [color, secondColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static IconData getPrayerIcon(String prayerName) {
    switch (prayerName.toLowerCase()) {
      case 'الفجر':
      case 'fajr':
        return Icons.wb_twilight;
      case 'الظهر':
      case 'dhuhr':
        return Icons.wb_sunny;
      case 'العصر':
      case 'asr':
        return Icons.wb_cloudy;
      case 'المغرب':
      case 'maghrib':
        return Icons.wb_twilight;
      case 'العشاء':
      case 'isha':
        return Icons.nights_stay;
      default:
        return Icons.access_time;
    }
  }
}

/// Extensions مفيدة للمساحات
extension SpacingExtensions on num {
  Widget get verticalSpace => SizedBox(height: toDouble());
  Widget get horizontalSpace => SizedBox(width: toDouble());
  Widget get sliverSpace => SliverToBoxAdapter(child: SizedBox(height: toDouble()));
}

/// Extensions للألوان
extension ColorExtensions on Color {
  /// تغميق اللون
  Color darken(double amount) {
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  /// تفتيح اللون
  Color lighten(double amount) {
    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }

  /// زيادة التشبع
  Color saturate(double amount) {
    final hsl = HSLColor.fromColor(this);
    final hslSaturated = hsl.withSaturation((hsl.saturation + amount).clamp(0.0, 1.0));
    return hslSaturated.toColor();
  }

  /// تقليل التشبع
  Color desaturate(double amount) {
    final hsl = HSLColor.fromColor(this);
    final hslDesaturated = hsl.withSaturation((hsl.saturation - amount).clamp(0.0, 1.0));
    return hslDesaturated.toColor();
  }
}