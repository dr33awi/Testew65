// lib/app/themes/core/systems/glass_effect.dart
import 'package:athkar_app/app/themes/theme_constants.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

/// نظام Glass Morphism موحد للتطبيق
/// يزيل التكرار ويوفر تأثيرات زجاجية متسقة
class GlassEffect extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color? overlayColor;
  final double borderOpacity;
  final double borderWidth;
  final BorderRadius? borderRadius;
  final List<BoxShadow>? shadows;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? width;
  final double? height;
  final Alignment alignment;
  final GlassIntensity intensity;

  const GlassEffect({
    super.key,
    required this.child,
    this.blur = 10,
    this.overlayColor,
    this.borderOpacity = 0.2,
    this.borderWidth = 1,
    this.borderRadius,
    this.shadows,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.alignment = Alignment.center,
    this.intensity = GlassIntensity.medium,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBlur = _getEffectiveBlur();
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(ThemeConstants.radiusLg);
    final effectiveOverlayColor = overlayColor ?? _getDefaultOverlayColor();
    
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: effectiveBlur,
            sigmaY: effectiveBlur,
          ),
          child: Container(
            padding: padding,
            alignment: alignment,
            decoration: BoxDecoration(
              color: effectiveOverlayColor,
              borderRadius: effectiveBorderRadius,
              border: Border.all(
                color: Colors.white.withValues(alpha: borderOpacity),
                width: borderWidth,
              ),
              boxShadow: shadows,
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  double _getEffectiveBlur() {
    switch (intensity) {
      case GlassIntensity.light:
        return blur * 0.5;
      case GlassIntensity.medium:
        return blur;
      case GlassIntensity.strong:
        return blur * 1.5;
      case GlassIntensity.extreme:
        return blur * 2.0;
    }
  }

  Color _getDefaultOverlayColor() {
    switch (intensity) {
      case GlassIntensity.light:
        return Colors.white.withValues(alpha: 0.05);
      case GlassIntensity.medium:
        return Colors.white.withValues(alpha: 0.1);
      case GlassIntensity.strong:
        return Colors.white.withValues(alpha: 0.15);
      case GlassIntensity.extreme:
        return Colors.white.withValues(alpha: 0.2);
    }
  }

  // ===== Factory Constructors =====

  /// Glass Effect خفيف للبطاقات
  factory GlassEffect.card({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double borderRadius = 16,
  }) {
    return GlassEffect(
      intensity: GlassIntensity.light,
      blur: 8,
      borderRadius: BorderRadius.circular(borderRadius),
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
      margin: margin,
      child: child,
    );
  }

  /// Glass Effect للحوارات
  factory GlassEffect.dialog({
    required Widget child,
    EdgeInsets? padding,
    double borderRadius = 20,
    List<BoxShadow>? shadows,
  }) {
    return GlassEffect(
      intensity: GlassIntensity.strong,
      blur: 15,
      borderRadius: BorderRadius.circular(borderRadius),
      borderOpacity: 0.3,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space6),
      shadows: shadows ?? [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
      child: child,
    );
  }

  /// Glass Effect للـ SnackBar
  factory GlassEffect.snackbar({
    required Widget child,
    EdgeInsets? padding,
    double borderRadius = 16,
  }) {
    return GlassEffect(
      intensity: GlassIntensity.medium,
      blur: 12,
      borderRadius: BorderRadius.circular(borderRadius),
      borderOpacity: 0.25,
      padding: padding ?? const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space3,
      ),
      child: child,
    );
  }

  /// Glass Effect للشريط العلوي
  factory GlassEffect.appBar({
    required Widget child,
    double? height,
  }) {
    return GlassEffect(
      intensity: GlassIntensity.light,
      blur: 6,
      borderRadius: BorderRadius.zero,
      borderOpacity: 0.1,
      height: height,
      child: child,
    );
  }

  /// Glass Effect للأزرار العائمة
  factory GlassEffect.floating({
    required Widget child,
    double borderRadius = 28,
    EdgeInsets? padding,
  }) {
    return GlassEffect(
      intensity: GlassIntensity.medium,
      blur: 10,
      borderRadius: BorderRadius.circular(borderRadius),
      borderOpacity: 0.3,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space3),
      shadows: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ],
      child: child,
    );
  }

  /// Glass Effect مخصص بالكامل
  factory GlassEffect.custom({
    required Widget child,
    double blur = 10,
    Color? overlayColor,
    double borderOpacity = 0.2,
    double borderWidth = 1,
    BorderRadius? borderRadius,
    List<BoxShadow>? shadows,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? width,
    double? height,
    GlassIntensity intensity = GlassIntensity.medium,
  }) {
    return GlassEffect(
      blur: blur,
      overlayColor: overlayColor,
      borderOpacity: borderOpacity,
      borderWidth: borderWidth,
      borderRadius: borderRadius,
      shadows: shadows,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      intensity: intensity,
      child: child,
    );
  }

  // ===== Static Helper Methods =====

  /// تطبيق Glass Effect على أي Widget بسرعة
  static Widget wrap(
    Widget child, {
    double blur = 10,
    Color? overlayColor,
    double borderOpacity = 0.2,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    GlassIntensity intensity = GlassIntensity.medium,
  }) {
    return GlassEffect(
      blur: blur,
      overlayColor: overlayColor,
      borderOpacity: borderOpacity,
      borderRadius: borderRadius ?? BorderRadius.circular(ThemeConstants.radiusLg),
      padding: padding,
      intensity: intensity,
      child: child,
    );
  }

  /// إنشاء حاوية زجاجية مع تدرج لوني
  static Widget withGradient(
    Widget child, {
    required List<Color> gradientColors,
    double blur = 10,
    double borderOpacity = 0.2,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    List<BoxShadow>? shadows,
  }) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(ThemeConstants.radiusLg);
    
    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: Stack(
        children: [
          // التدرج اللوني في الخلفية
          Container(
            decoration: BoxDecoration(
              borderRadius: effectiveBorderRadius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors,
              ),
              boxShadow: shadows,
            ),
          ),
          
          // التأثير الزجاجي
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: effectiveBorderRadius,
                border: Border.all(
                  color: Colors.white.withValues(alpha: borderOpacity),
                  width: 1,
                ),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  /// إنشاء حاوية زجاجية مع لون خلفية
  static Widget withColor(
    Widget child, {
    required Color backgroundColor,
    double blur = 10,
    double backgroundOpacity = 0.9,
    double borderOpacity = 0.2,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    List<BoxShadow>? shadows,
  }) {
    return withGradient(
      child,
      gradientColors: [
        backgroundColor.withValues(alpha: backgroundOpacity),
        backgroundColor.darken(0.1).withValues(alpha: backgroundOpacity * 0.8),
      ],
      blur: blur,
      borderOpacity: borderOpacity,
      borderRadius: borderRadius,
      padding: padding,
      shadows: shadows,
    );
  }
}

/// درجات شدة التأثير الزجاجي
enum GlassIntensity {
  light,    // تأثير خفيف
  medium,   // تأثير متوسط (الافتراضي)
  strong,   // تأثير قوي
  extreme,  // تأثير شديد
}

/// Extension لتسهيل الاستخدام
extension GlassEffectExtension on Widget {
  /// تطبيق Glass Effect على أي Widget
  Widget glass({
    double blur = 10,
    Color? overlayColor,
    double borderOpacity = 0.2,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
    GlassIntensity intensity = GlassIntensity.medium,
  }) {
    return GlassEffect.wrap(
      this,
      blur: blur,
      overlayColor: overlayColor,
      borderOpacity: borderOpacity,
      borderRadius: borderRadius,
      padding: padding,
      intensity: intensity,
    );
  }

  /// تطبيق Glass Effect مع تدرج لوني
  Widget glassWithGradient({
    required List<Color> gradientColors,
    double blur = 10,
    double borderOpacity = 0.2,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
  }) {
    return GlassEffect.withGradient(
      this,
      gradientColors: gradientColors,
      blur: blur,
      borderOpacity: borderOpacity,
      borderRadius: borderRadius,
      padding: padding,
    );
  }

  /// تطبيق Glass Effect مع لون واحد
  Widget glassWithColor({
    required Color backgroundColor,
    double blur = 10,
    double backgroundOpacity = 0.9,
    double borderOpacity = 0.2,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
  }) {
    return GlassEffect.withColor(
      this,
      backgroundColor: backgroundColor,
      blur: blur,
      backgroundOpacity: backgroundOpacity,
      borderOpacity: borderOpacity,
      borderRadius: borderRadius,
      padding: padding,
    );
  }
}