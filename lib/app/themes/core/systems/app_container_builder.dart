// ===== lib/app/themes/core/systems/app_container_builder.dart - مُصحح =====

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:athkar_app/app/themes/theme_constants.dart';
import 'app_color_system.dart';
import 'app_size_system.dart';
import 'app_shadow_system.dart';
import 'glass_effect.dart';

/// نظام بناء الحاويات الموحد - نسخة مُصححة مع معالجة أخطاء
class AppContainerBuilder {
  AppContainerBuilder._();

  // ===== دوال مساعدة داخلية مُصححة =====
  
  /// الحصول على اللون الفعال مع تحقق من الصحة
  static Color _getEffectiveColor(String? colorKey, Color? color) {
    try {
      if (color != null) return color;
      if (colorKey != null && colorKey.isNotEmpty) {
        return AppColorSystem.getColor(colorKey);
      }
      return AppColorSystem.primary;
    } catch (e) {
      return AppColorSystem.primary; // fallback آمن
    }
  }

  /// الحصول على الحشو الافتراضي
  static EdgeInsets _getDefaultPadding() => const EdgeInsets.all(ThemeConstants.space4);

  /// الحصول على نصف القطر الافتراضي
  static double _getDefaultRadius() => ThemeConstants.radiusMd;

  /// التحقق من صحة المعاملات
  static bool _validateParameters({
    Widget? child,
    double? borderRadius,
    EdgeInsets? padding,
    List<Color>? gradientColors,
  }) {
    if (child == null) return false;
    if (borderRadius != null && borderRadius < 0) return false;
    if (gradientColors != null && gradientColors.length < 2) return false;
    return true;
  }

  // ===== دالة البناء الأساسية الموحدة - مُصححة =====
  
  /// دالة واحدة موحدة لبناء جميع أنواع الحاويات مع معالجة أخطاء
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
      if (!_validateParameters(
        child: child,
        borderRadius: borderRadius,
        padding: padding,
        gradientColors: gradientColors,
      )) {
        return _buildFallbackContainer(child);
      }

      final effectiveColor = _getEffectiveColor(colorKey, backgroundColor);
      final effectivePadding = padding ?? _getDefaultPadding();
      final effectiveRadius = borderRadius ?? _getDefaultRadius();
      
      Widget container;
      
      switch (style) {
        case ContainerStyle.basic:
          container = _buildBasicContainer(
            child: child,
            color: effectiveColor,
            padding: effectivePadding,
            borderRadius: effectiveRadius,
            border: border,
            shadows: showShadow ? (shadows ?? AppShadowSystem.light) : null,
            alignment: alignment,
          );
          break;
          
        case ContainerStyle.gradient:
          container = _buildGradientContainer(
            child: child,
            colors: gradientColors ?? _createDefaultGradient(effectiveColor),
            padding: effectivePadding,
            borderRadius: effectiveRadius,
            shadows: showShadow ? (shadows ?? AppShadowSystem.colored(color: effectiveColor)) : null,
            alignment: alignment,
          );
          break;
          
        case ContainerStyle.glass:
          container = _buildGlassContainer(
            child: child,
            color: effectiveColor,
            padding: effectivePadding,
            borderRadius: effectiveRadius,
            shadows: showShadow ? (shadows ?? AppShadowSystem.glass(color: effectiveColor)) : null,
            alignment: alignment,
          );
          break;
          
        case ContainerStyle.glassGradient:
          container = _buildGlassGradientContainer(
            child: child,
            colors: gradientColors ?? _createGlassGradient(effectiveColor),
            padding: effectivePadding,
            borderRadius: effectiveRadius,
            shadows: showShadow ? (shadows ?? AppShadowSystem.colored(color: effectiveColor)) : null,
            alignment: alignment,
          );
          break;
      }

      // تطبيق الأبعاد والهوامش
      if (width != null || height != null || margin != null) {
        container = Container(
          width: width,
          height: height,
          margin: margin,
          child: container,
        );
      }

      // تطبيق التفاعل
      if (onTap != null || onLongPress != null) {
        container = GestureDetector(
          onTap: onTap,
          onLongPress: onLongPress,
          child: container,
        );
      }

      return container;
    } catch (e) {
      // ✅ في حالة حدوث خطأ، إرجاع حاوية أساسية آمنة
      if (kDebugMode) {
        debugPrint('خطأ في بناء الحاوية: $e');
      }
      
      return _buildFallbackContainer(child);
    }
  }

  /// حاوية احتياطية في حالة الأخطاء
  static Widget _buildFallbackContainer(Widget child) {
    return Container(
      padding: _getDefaultPadding(),
      decoration: BoxDecoration(
        color: AppColorSystem.primary.withValues(alpha: 0.1), // ✅ مُصحح
        borderRadius: BorderRadius.circular(_getDefaultRadius()),
        border: Border.all(
          color: AppColorSystem.primary.withValues(alpha: 0.3), // ✅ مُصحح
          width: 1,
        ),
      ),
      child: child,
    );
  }

  /// إنشاء تدرج افتراضي
  static List<Color> _createDefaultGradient(Color baseColor) {
    try {
      return [
        baseColor,
        AppColorSystem.getDarkColor(baseColor.toString()),
      ];
    } catch (e) {
      return [AppColorSystem.primary, AppColorSystem.primaryDark];
    }
  }

  // ===== دوال البناء الداخلية - منطق مُصحح =====

  static Widget _buildBasicContainer({
    required Widget child,
    required Color color,
    required EdgeInsets padding,
    required double borderRadius,
    Border? border,
    List<BoxShadow>? shadows,
    AlignmentGeometry? alignment,
  }) {
    return Container(
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1), // ✅ مُصحح
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? Border.all(color: color.withValues(alpha: 0.3)), // ✅ مُصحح
        boxShadow: shadows,
      ),
      child: child,
    );
  }

  static Widget _buildGradientContainer({
    required Widget child,
    required List<Color> colors,
    required EdgeInsets padding,
    required double borderRadius,
    List<BoxShadow>? shadows,
    AlignmentGeometry? alignment,
  }) {
    return Container(
      padding: padding,
      alignment: alignment,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: shadows,
      ),
      child: child,
    );
  }

  static Widget _buildGlassContainer({
    required Widget child,
    required Color color,
    required EdgeInsets padding,
    required double borderRadius,
    List<BoxShadow>? shadows,
    AlignmentGeometry? alignment,
  }) {
    try {
      return GlassEffect(
        padding: padding,
        borderRadius: BorderRadius.circular(borderRadius),
        shadows: shadows,
        alignment: (alignment is Alignment) ? alignment : Alignment.center,
        overlayColor: color.withValues(alpha: 0.1), // ✅ مُصحح
        child: child,
      );
    } catch (e) {
      // fallback للحاوية العادية
      return _buildBasicContainer(
        child: child,
        color: color,
        padding: padding,
        borderRadius: borderRadius,
        shadows: shadows,
        alignment: alignment,
      );
    }
  }

  static Widget _buildGlassGradientContainer({
    required Widget child,
    required List<Color> colors,
    required EdgeInsets padding,
    required double borderRadius,
    List<BoxShadow>? shadows,
    AlignmentGeometry? alignment,
  }) {
    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: shadows,
          ),
          alignment: alignment,
          child: child,
        ),
      );
    } catch (e) {
      return _buildGradientContainer(
        child: child,
        colors: colors,
        padding: padding,
        borderRadius: borderRadius,
        shadows: shadows,
        alignment: alignment,
      );
    }
  }

  /// إنشاء تدرج زجاجي - مُصحح
  static List<Color> _createGlassGradient(Color baseColor) {
    try {
      return [
        baseColor.withValues(alpha: 0.95), // ✅ مُصحح
        AppColorSystem.getDarkColor(baseColor.toString()).withValues(alpha: 0.85), // ✅ مُصحح
      ];
    } catch (e) {
      return [
        AppColorSystem.primary.withValues(alpha: 0.95), // ✅ مُصحح
        AppColorSystem.primaryDark.withValues(alpha: 0.85), // ✅ مُصحح
      ];
    }
  }

  // ===== Factory Methods مُصححة =====

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

  // ===== حاويات متخصصة مُصححة =====

  /// حاوية للبطاقات
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
    try {
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
    } catch (e) {
      return basic(child: child, onTap: onTap);
    }
  }

  /// حاوية للأذكار
  static Widget athkar({
    required Widget child,
    String categoryType = 'morning',
    bool withGlass = true,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    try {
      return buildContainer(
        child: child,
        style: withGlass ? ContainerStyle.glassGradient : ContainerStyle.gradient,
        colorKey: categoryType,
        padding: padding ?? const EdgeInsets.all(ThemeConstants.space5),
        margin: margin,
        borderRadius: ThemeConstants.radiusXl,
        showShadow: true,
      );
    } catch (e) {
      return basic(child: child);
    }
  }

  /// حاوية لعرض اقتباس
  static Widget quote({
    required Widget child,
    String quoteType = 'verse',
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    try {
      return buildContainer(
        child: child,
        style: ContainerStyle.glassGradient,
        colorKey: quoteType,
        padding: padding ?? const EdgeInsets.all(ThemeConstants.space6),
        margin: margin,
        borderRadius: ThemeConstants.radius2xl,
        showShadow: true,
      );
    } catch (e) {
      return basic(child: child);
    }
  }
}

/// أنماط الحاويات
enum ContainerStyle {
  basic,         // حاوية أساسية
  gradient,      // حاوية مع تدرج
  glass,         // حاوية زجاجية
  glassGradient, // حاوية زجاجية مع تدرج
}

/// Extension مُصحح
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