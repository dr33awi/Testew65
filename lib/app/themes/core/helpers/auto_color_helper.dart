// ===== lib/app/themes/core/helpers/auto_color_helper.dart - مُصحح =====

import 'package:flutter/material.dart';
import '../systems/app_color_system.dart';

/// مساعد للحصول على ألوان متناسقة تلقائياً - نسخة مُصححة
class AutoColorHelper {
  AutoColorHelper._();

  /// إنشاء لوحة ألوان متناسقة من لون واحد - ✅ مُصحح
  static Map<String, Color> createPalette(Color baseColor) {
    try {
      final hsl = HSLColor.fromColor(baseColor);
      
      return {
        'primary': baseColor,
        'light': _adjustLightness(hsl, 0.2).toColor(),
        'dark': _adjustLightness(hsl, -0.2).toColor(),
        'soft': baseColor.withValues(alpha: 0.7), // ✅ مُصحح
        'contrast': _getContrastingTextColor(baseColor),
        'complementary': _getComplementaryColor(hsl).toColor(),
        'analogous1': _adjustHue(hsl, 30).toColor(),
        'analogous2': _adjustHue(hsl, -30).toColor(),
      };
    } catch (e) {
      // إرجاع لوحة افتراضية في حالة الخطأ
      return {
        'primary': AppColorSystem.primary,
        'light': AppColorSystem.primaryLight,
        'dark': AppColorSystem.primaryDark,
        'soft': AppColorSystem.primarySoft,
        'contrast': Colors.white,
        'complementary': AppColorSystem.accent,
        'analogous1': AppColorSystem.tertiary,
        'analogous2': AppColorSystem.info,
      };
    }
  }

  /// اقتراح ألوان متكاملة
  static List<Color> suggestComplementaryColors(Color baseColor) {
    try {
      final hsl = HSLColor.fromColor(baseColor);
      
      return [
        _getComplementaryColor(hsl).toColor(), // مكمل (180 درجة)
        _adjustHue(hsl, 120).toColor(), // ثلاثي (120 درجة)
        _adjustHue(hsl, 240).toColor(), // ثلاثي (240 درجة)
        _adjustSaturation(hsl, -0.3).toColor(), // أهدأ
        _adjustLightness(hsl, 0.3).toColor(), // أفتح
      ];
    } catch (e) {
      return [
        AppColorSystem.accent,
        AppColorSystem.tertiary,
        AppColorSystem.info,
        AppColorSystem.warning,
        AppColorSystem.success,
      ];
    }
  }

  /// إنشاء تدرج لوني ذكي
  static LinearGradient createSmartGradient(Color baseColor, {
    GradientDirection direction = GradientDirection.topLeftToBottomRight,
    GradientType type = GradientType.analogous,
  }) {
    try {
      final colors = _getGradientColors(baseColor, type);
      final alignment = _getGradientAlignment(direction);
      
      return LinearGradient(
        begin: alignment.begin,
        end: alignment.end,
        colors: colors,
      );
    } catch (e) {
      return AppColorSystem.primaryGradient;
    }
  }

  /// تحليل لون لمعرفة خصائصه
  static ColorAnalysis analyzeColor(Color color) {
    try {
      final hsl = HSLColor.fromColor(color);
      final luminance = color.computeLuminance();
      
      return ColorAnalysis(
        color: color,
        hue: hsl.hue,
        saturation: hsl.saturation,
        lightness: hsl.lightness,
        luminance: luminance,
        temperature: _getColorTemperature(hsl.hue),
        mood: _getColorMood(hsl.hue, hsl.saturation, hsl.lightness),
        accessibility: _getAccessibilityRating(luminance),
      );
    } catch (e) {
      return ColorAnalysis.fallback(color);
    }
  }

  // ===== دوال مساعدة داخلية =====

  static HSLColor _adjustHue(HSLColor hsl, double degrees) {
    final newHue = (hsl.hue + degrees) % 360;
    return hsl.withHue(newHue);
  }

  static HSLColor _adjustSaturation(HSLColor hsl, double amount) {
    final newSaturation = (hsl.saturation + amount).clamp(0.0, 1.0);
    return hsl.withSaturation(newSaturation);
  }

  static HSLColor _adjustLightness(HSLColor hsl, double amount) {
    final newLightness = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(newLightness);
  }

  static HSLColor _getComplementaryColor(HSLColor hsl) {
    return _adjustHue(hsl, 180);
  }

  static Color _getContrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  static List<Color> _getGradientColors(Color baseColor, GradientType type) {
    final hsl = HSLColor.fromColor(baseColor);
    
    switch (type) {
      case GradientType.analogous:
        return [
          baseColor,
          _adjustHue(hsl, 30).toColor(),
        ];
      case GradientType.complementary:
        return [
          baseColor,
          _getComplementaryColor(hsl).toColor(),
        ];
      case GradientType.monochromatic:
        return [
          _adjustLightness(hsl, 0.2).toColor(),
          baseColor,
          _adjustLightness(hsl, -0.2).toColor(),
        ];
      case GradientType.triadic:
        return [
          baseColor,
          _adjustHue(hsl, 120).toColor(),
          _adjustHue(hsl, 240).toColor(),
        ];
    }
  }

  static GradientAlignment _getGradientAlignment(GradientDirection direction) {
    switch (direction) {
      case GradientDirection.topToBottom:
        return const GradientAlignment(Alignment.topCenter, Alignment.bottomCenter);
      case GradientDirection.leftToRight:
        return const GradientAlignment(Alignment.centerLeft, Alignment.centerRight);
      case GradientDirection.topLeftToBottomRight:
        return const GradientAlignment(Alignment.topLeft, Alignment.bottomRight);
      case GradientDirection.topRightToBottomLeft:
        return const GradientAlignment(Alignment.topRight, Alignment.bottomLeft);
    }
  }

  static ColorTemperature _getColorTemperature(double hue) {
    if (hue >= 0 && hue < 60) return ColorTemperature.warm; // أحمر-أصفر
    if (hue >= 60 && hue < 180) return ColorTemperature.cool; // أصفر-أخضر-سماوي
    if (hue >= 180 && hue < 240) return ColorTemperature.cool; // سماوي-أزرق
    return ColorTemperature.warm; // أزرق-بنفسجي-أحمر
  }

  static ColorMood _getColorMood(double hue, double saturation, double lightness) {
    if (lightness > 0.8) return ColorMood.cheerful;
    if (lightness < 0.2) return ColorMood.dramatic;
    if (saturation > 0.8) return ColorMood.energetic;
    if (saturation < 0.3) return ColorMood.calm;
    
    if (hue >= 0 && hue < 60) return ColorMood.energetic; // أحمر-أصفر
    if (hue >= 60 && hue < 120) return ColorMood.natural; // أصفر-أخضر
    if (hue >= 120 && hue < 240) return ColorMood.calm; // أخضر-أزرق
    return ColorMood.mysterious; // أزرق-بنفسجي-أحمر
  }

  static AccessibilityRating _getAccessibilityRating(double luminance) {
    if (luminance > 0.7 || luminance < 0.1) return AccessibilityRating.poor;
    if (luminance > 0.5 || luminance < 0.2) return AccessibilityRating.fair;
    return AccessibilityRating.good;
  }
}

// ===== أنواع البيانات المساعدة =====

enum GradientDirection {
  topToBottom,
  leftToRight,
  topLeftToBottomRight,
  topRightToBottomLeft,
}

enum GradientType {
  analogous,
  complementary,
  monochromatic,
  triadic,
}

enum ColorTemperature { warm, cool }
enum ColorMood { energetic, calm, cheerful, dramatic, natural, mysterious }
enum AccessibilityRating { good, fair, poor }

class GradientAlignment {
  final Alignment begin;
  final Alignment end;
  
  const GradientAlignment(this.begin, this.end);
}

class ColorAnalysis {
  final Color color;
  final double hue;
  final double saturation;
  final double lightness;
  final double luminance;
  final ColorTemperature temperature;
  final ColorMood mood;
  final AccessibilityRating accessibility;

  const ColorAnalysis({
    required this.color,
    required this.hue,
    required this.saturation,
    required this.lightness,
    required this.luminance,
    required this.temperature,
    required this.mood,
    required this.accessibility,
  });

  factory ColorAnalysis.fallback(Color color) {
    return ColorAnalysis(
      color: color,
      hue: 0,
      saturation: 0,
      lightness: 0.5,
      luminance: 0.5,
      temperature: ColorTemperature.warm,
      mood: ColorMood.natural,
      accessibility: AccessibilityRating.fair,
    );
  }

  String get description {
    final temp = temperature == ColorTemperature.warm ? 'دافئ' : 'بارد';
    final moodText = {
      ColorMood.energetic: 'نشيط',
      ColorMood.calm: 'هادئ',
      ColorMood.cheerful: 'مبهج',
      ColorMood.dramatic: 'درامي',
      ColorMood.natural: 'طبيعي',
      ColorMood.mysterious: 'غامض',
    }[mood] ?? 'طبيعي';
    
    return 'لون $temp و$moodText';
  }
}