// lib/app/themes/core/systems/app_container_builder.dart - النسخة المنظفة (بدون تكرار)
import 'package:flutter/material.dart';
import 'package:athkar_app/app/themes/theme_constants.dart';
import 'app_color_system.dart';
import 'app_size_system.dart';
import 'app_shadow_system.dart';
import 'glass_effect.dart';

/// نظام بناء الحاويات الموحد - منظف من التكرار
class AppContainerBuilder {
  AppContainerBuilder._();

  // ===== دوال مساعدة داخلية - تجنب التكرار =====
  
  /// الحصول على اللون الفعال - دالة واحدة لكل المصنع
  static Color _getEffectiveColor(String? colorKey, Color? color) {
    if (color != null) return color;
    if (colorKey != null) return AppColorSystem.getColor(colorKey);
    return AppColorSystem.primary;
  }

  /// الحصول على الحشو الافتراضي
  static EdgeInsets _getDefaultPadding() => const EdgeInsets.all(ThemeConstants.space4);

  /// الحصول على نصف القطر الافتراضي
  static double _getDefaultRadius() => ThemeConstants.radiusMd;

  // ===== دالة البناء الأساسية الموحدة =====
  
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
          colors: gradientColors ?? [effectiveColor, AppColorSystem.getDarkColor(effectiveColor.toString())],
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
  }

  // ===== دوال البناء الداخلية - منطق موحد =====

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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? Border.all(color: color.withValues(alpha: 0.3)),
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
    return GlassEffect(
      padding: padding,
      borderRadius: BorderRadius.circular(borderRadius),
      shadows: shadows,
      alignment: (alignment is Alignment) ? alignment : Alignment.center,
      overlayColor: color.withValues(alpha: 0.1),
      child: child,
    );
  }

  static Widget _buildGlassGradientContainer({
    required Widget child,
    required List<Color> colors,
    required EdgeInsets padding,
    required double borderRadius,
    List<BoxShadow>? shadows,
    AlignmentGeometry? alignment,
  }) {
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
  }

  /// إنشاء تدرج زجاجي
  static List<Color> _createGlassGradient(Color baseColor) {
    return [
      baseColor.withValues(alpha: 0.95),
      AppColorSystem.getDarkColor(baseColor.toString()).withValues(alpha: 0.85),
    ];
  }

  // ===== Factory Methods مبسطة - تستخدم buildContainer =====

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

  // ===== حاويات متخصصة - تستخدم buildContainer =====

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

  /// حاوية للأزرار
  static Widget button({
    required Widget child,
    ComponentSize size = ComponentSize.md,
    String? colorKey,
    Color? backgroundColor,
    bool isOutlined = false,
    EdgeInsets? margin,
    VoidCallback? onTap,
  }) {
    final buttonSizes = AppSizeSystem.getButtonSizes(size);
    final style = isOutlined ? ContainerStyle.basic : ContainerStyle.gradient;
    
    return buildContainer(
      child: child,
      style: style,
      colorKey: colorKey,
      backgroundColor: backgroundColor,
      padding: buttonSizes.padding,
      margin: margin,
      borderRadius: buttonSizes.borderRadius,
      border: isOutlined ? Border.all(
        color: _getEffectiveColor(colorKey, backgroundColor),
        width: 1.5,
      ) : null,
      alignment: Alignment.center,
      onTap: onTap,
    );
  }

  /// حاوية للحوارات
  static Widget dialog({
    required Widget child,
    ComponentSize size = ComponentSize.lg,
    String? colorKey,
    EdgeInsets? margin,
    double? maxWidth,
  }) {
    final dialogSizes = AppSizeSystem.getDialogSizes(size);
    
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth ?? 400),
      child: buildContainer(
        child: child,
        style: ContainerStyle.glassGradient,
        colorKey: colorKey,
        padding: dialogSizes.padding,
        margin: margin,
        borderRadius: dialogSizes.borderRadius,
        shadows: AppShadowSystem.dialog,
      ),
    );
  }

  // ===== حاويات للمحتوى الإسلامي - مبسطة =====

  /// حاوية لعرض الأذكار
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

  /// حاوية لعرض اقتباس
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

/// أنماط الحاويات - مبسطة
enum ContainerStyle {
  basic,         // حاوية أساسية
  gradient,      // حاوية مع تدرج
  glass,         // حاوية زجاجية
  glassGradient, // حاوية زجاجية مع تدرج
}

/// Extension مبسط - بدون تكرار منطق البناء
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