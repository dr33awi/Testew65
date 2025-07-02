// lib/app/themes/core/systems/app_container_builder.dart - مُصحح لحل جميع الأخطاء

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:athkar_app/app/themes/theme_constants.dart';
import 'app_color_system.dart';
import 'app_size_system.dart';
import 'app_shadow_system.dart';
import 'glass_effect.dart';
import '../helpers/theme_utils.dart';

/// نظام بناء الحاويات الموحد - مُبسط ومُصحح
class AppContainerBuilder {
  AppContainerBuilder._();

  // ===== دالة البناء الأساسية الموحدة - مُبسطة =====
  
  /// دالة واحدة موحدة لبناء جميع أنواع الحاويات
  static Widget buildContainer({
    required Widget child,
    ContainerStyle style = ContainerStyle.basic,
    String? colorKey,
    Color? backgroundColor,
    List<Color>? gradientColors,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? width,
    double? height,
    double? borderRadius,
    Border? border,
    List<BoxShadow>? shadows,
    AlignmentGeometry? alignment,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool showShadow = true,
  }) {
    try {
      // التحقق من صحة المعاملات
      if (!_validateInput(child, borderRadius, gradientColors)) {
        return _buildFallbackContainer(child);
      }

      // الحصول على القيم الفعالة - استخدام ThemeUtils
      final effectiveColor = _getEffectiveColor(colorKey, backgroundColor);
      final effectivePadding = padding ?? _getDefaultPadding();
      final effectiveRadius = ThemeUtils.safeRadius(borderRadius);
      final effectiveGradientColors = gradientColors ?? 
          ThemeUtils.createGradient(effectiveColor, type: ThemeGradientType.simple); // ✅ استخدام الاسم المُصحح
      
      // بناء الحاوية باستخدام ThemeUtils
      Widget container = ThemeUtils.buildStyledContainer(
        child: child,
        backgroundColor: style == ContainerStyle.basic ? effectiveColor.withValues(alpha: 0.1) : null, // ✅ استخدام withValues مباشرة
        gradientColors: style != ContainerStyle.basic ? effectiveGradientColors : null,
        borderRadius: effectiveRadius,
        padding: effectivePadding,
        margin: margin,
        shadows: showShadow ? (shadows ?? _getDefaultShadows(style, effectiveColor)) : null,
        border: border ?? _getDefaultBorder(style, effectiveColor),
        withGlassEffect: style == ContainerStyle.glass || style == ContainerStyle.glassGradient,
      );

      // تطبيق Glass Effect إذا كان مطلوباً
      if (style == ContainerStyle.glass || style == ContainerStyle.glassGradient) {
        container = _applyGlassEffect(container, effectiveColor, effectiveRadius);
      }

      // تطبيق الأبعاد والمحاذاة
      if (width != null || height != null || alignment != null) {
        container = Container(
          width: width,
          height: height,
          alignment: alignment,
          child: container,
        );
      }

      // تطبيق التفاعل
      return _applyInteraction(container, onTap, onLongPress);

    } catch (e) {
      if (kDebugMode) {
        debugPrint('خطأ في بناء الحاوية: $e');
      }
      return _buildFallbackContainer(child);
    }
  }

  // ===== دوال مساعدة مُبسطة =====
  
  /// التحقق من صحة المدخلات - موحد
  static bool _validateInput(Widget? child, double? borderRadius, List<Color>? gradientColors) {
    if (child == null) return false;
    if (borderRadius != null && borderRadius < 0) return false;
    if (gradientColors != null && gradientColors.length < 2) return false;
    return true;
  }

  /// الحصول على اللون الفعال - مُبسط
  static Color _getEffectiveColor(String? colorKey, Color? backgroundColor) {
    if (backgroundColor != null) return backgroundColor;
    if (colorKey != null && colorKey.isNotEmpty) {
      return AppColorSystem.getColor(colorKey);
    }
    return AppColorSystem.primary;
  }

  /// الحصول على الحشو الافتراضي
  static EdgeInsets _getDefaultPadding() => const EdgeInsets.all(ThemeConstants.space4);

  /// الحصول على الظلال الافتراضية
  static List<BoxShadow> _getDefaultShadows(ContainerStyle style, Color color) {
    switch (style) {
      case ContainerStyle.basic:
        return AppShadowSystem.light;
      case ContainerStyle.gradient:
        return AppShadowSystem.colored(color: color);
      case ContainerStyle.glass:
      case ContainerStyle.glassGradient:
        return AppShadowSystem.glass(color: color);
    }
  }

  /// الحصول على الحدود الافتراضية
  static Border? _getDefaultBorder(ContainerStyle style, Color color) {
    switch (style) {
      case ContainerStyle.basic:
        return Border.all(color: color.withValues(alpha: 0.3), width: ThemeConstants.borderLight); // ✅ استخدام withValues مباشرة
      case ContainerStyle.glass:
      case ContainerStyle.glassGradient:
        return Border.all(color: Colors.white.withValues(alpha: 0.3));
      default:
        return null;
    }
  }

  /// تطبيق Glass Effect
  static Widget _applyGlassEffect(Widget container, Color color, double radius) {
    try {
      return GlassEffect(
        borderRadius: BorderRadius.circular(radius),
        overlayColor: color.withValues(alpha: 0.1),
        child: container,
      );
    } catch (e) {
      return container; // fallback للحاوية العادية
    }
  }

  /// تطبيق التفاعل
  static Widget _applyInteraction(Widget container, VoidCallback? onTap, VoidCallback? onLongPress) {
    if (onTap != null || onLongPress != null) {
      return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: container,
      );
    }
    return container;
  }

  /// حاوية احتياطية في حالة الأخطاء - مُبسطة
  static Widget _buildFallbackContainer(Widget child) {
    return ThemeUtils.buildStyledContainer(
      child: child,
      backgroundColor: AppColorSystem.primary.withValues(alpha: 0.1), // ✅ استخدام withValues مباشرة
      borderRadius: ThemeConstants.radiusMd,
      padding: _getDefaultPadding(),
      border: Border.all(color: AppColorSystem.primary.withValues(alpha: 0.3)), // ✅ استخدام withValues مباشرة
    );
  }

  // ===== Factory Methods مُبسطة - بدون تكرار =====

  /// حاوية أساسية
  static Widget basic({
    required Widget child,
    String? colorKey,
    Color? backgroundColor,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    VoidCallback? onTap,
  }) {
    return buildContainer(
      child: child,
      style: ContainerStyle.basic,
      colorKey: colorKey,
      backgroundColor: backgroundColor,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
    );
  }

  /// حاوية مع تدرج
  static Widget gradient({
    required Widget child,
    String? colorKey,
    Color? backgroundColor,
    List<Color>? gradientColors,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    VoidCallback? onTap,
  }) {
    return buildContainer(
      child: child,
      style: ContainerStyle.gradient,
      colorKey: colorKey,
      backgroundColor: backgroundColor,
      gradientColors: gradientColors,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
    );
  }

  /// حاوية زجاجية
  static Widget glass({
    required Widget child,
    String? colorKey,
    Color? backgroundColor,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    VoidCallback? onTap,
  }) {
    return buildContainer(
      child: child,
      style: ContainerStyle.glass,
      colorKey: colorKey,
      backgroundColor: backgroundColor,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
    );
  }

  /// حاوية زجاجية مع تدرج
  static Widget glassGradient({
    required Widget child,
    String? colorKey,
    Color? backgroundColor,
    List<Color>? gradientColors,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    VoidCallback? onTap,
  }) {
    return buildContainer(
      child: child,
      style: ContainerStyle.glassGradient,
      colorKey: colorKey,
      backgroundColor: backgroundColor,
      gradientColors: gradientColors,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
    );
  }

  // ===== حاويات متخصصة مُبسطة =====

  /// حاوية للبطاقات - استخدام النظام الموحد
  static Widget card({
    required Widget child,
    ComponentSize size = ComponentSize.md,
    String? colorKey,
    Color? backgroundColor,
    bool withShadow = true,
    bool withGlass = false,
    EdgeInsets? margin,
    VoidCallback? onTap,
  }) {
    final cardSizes = AppSizeSystem.getCardSizes(size);
    final style = withGlass ? ContainerStyle.glassGradient : ContainerStyle.basic;
    
    return buildContainer(
      child: child,
      style: style,
      colorKey: colorKey,
      backgroundColor: backgroundColor,
      padding: cardSizes.padding,
      margin: margin,
      borderRadius: cardSizes.borderRadius,
      showShadow: withShadow,
      onTap: onTap,
    );
  }

  /// حاوية للأذكار - استخدام النظام الموحد
  static Widget athkar({
    required Widget child,
    String categoryType = 'morning',
    bool withGlass = true,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return buildContainer(
      child: child,
      style: withGlass ? ContainerStyle.glassGradient : ContainerStyle.gradient,
      colorKey: categoryType,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space5),
      margin: margin,
      borderRadius: ThemeConstants.radiusXl,
      showShadow: true,
    );
  }

  /// حاوية لعرض اقتباس - استخدام النظام الموحد
  static Widget quote({
    required Widget child,
    String quoteType = 'verse',
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return buildContainer(
      child: child,
      style: ContainerStyle.glassGradient,
      colorKey: quoteType,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space6),
      margin: margin,
      borderRadius: ThemeConstants.radius2xl,
      showShadow: true,
    );
  }
}

/// أنماط الحاويات
enum ContainerStyle {
  basic,         // حاوية أساسية
  gradient,      // حاوية مع تدرج
  glass,         // حاوية زجاجية
  glassGradient, // حاوية زجاجية مع تدرج
}

/// Extension مُبسط - استخدام النظام الموحد
extension AppContainerExtension on Widget {
  /// تطبيق حاوية أساسية
  Widget container({
    String? colorKey,
    Color? backgroundColor,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    VoidCallback? onTap,
  }) {
    return AppContainerBuilder.basic(
      child: this,
      colorKey: colorKey,
      backgroundColor: backgroundColor,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
    );
  }
  
  /// تطبيق حاوية مع تدرج
  Widget gradientContainer({
    String? colorKey,
    Color? backgroundColor,
    List<Color>? gradientColors,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    VoidCallback? onTap,
  }) {
    return AppContainerBuilder.gradient(
      child: this,
      colorKey: colorKey,
      backgroundColor: backgroundColor,
      gradientColors: gradientColors,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
    );
  }
  
  /// تطبيق حاوية زجاجية
  Widget glassContainer({
    String? colorKey,
    Color? backgroundColor,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    VoidCallback? onTap,
  }) {
    return AppContainerBuilder.glass(
      child: this,
      colorKey: colorKey,
      backgroundColor: backgroundColor,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      onTap: onTap,
    );
  }
  
  /// تطبيق حاوية للبطاقة
  Widget cardContainer({
    ComponentSize size = ComponentSize.md,
    String? colorKey,
    bool withGlass = false,
    EdgeInsets? margin,
    VoidCallback? onTap,
  }) {
    return AppContainerBuilder.card(
      child: this,
      size: size,
      colorKey: colorKey,
      withGlass: withGlass,
      margin: margin,
      onTap: onTap,
    );
  }

  /// تطبيق حاوية للأذكار
  Widget athkarContainer({
    String categoryType = 'morning',
    bool withGlass = true,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return AppContainerBuilder.athkar(
      child: this,
      categoryType: categoryType,
      withGlass: withGlass,
      padding: padding,
      margin: margin,
    );
  }

  /// تطبيق حاوية للاقتباسات
  Widget quoteContainer({
    String quoteType = 'verse',
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return AppContainerBuilder.quote(
      child: this,
      quoteType: quoteType,
      padding: padding,
      margin: margin,
    );
  }
}