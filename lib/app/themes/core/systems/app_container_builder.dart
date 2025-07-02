// lib/app/themes/core/systems/app_container_builder.dart - النسخة المحسنة
import 'package:flutter/material.dart';
import 'package:athkar_app/app/themes/theme_constants.dart';
import 'app_color_system.dart';
import 'app_size_system.dart';
import 'app_shadow_system.dart';
import 'glass_effect.dart';

/// نظام بناء الحاويات الموحد - نسخة محسنة مع معالجة أخطاء
class AppContainerBuilder {
  AppContainerBuilder._();

  // ===== دوال مساعدة داخلية محسنة =====
  
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

  // ===== دالة البناء الأساسية الموحدة - محسنة =====
  
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
      // في حالة حدوث خطأ، إرجاع حاوية أساسية آمنة
      assert(() {
        print('خطأ في بناء الحاوية: $e');
        return true;
      }());
      
      return _buildFallbackContainer(child);
    }
  }

  /// حاوية احتياطية في حالة الأخطاء
  static Widget _buildFallbackContainer(Widget child) {
    return Container(
      padding: _getDefaultPadding(),
      decoration: BoxDecoration(
        color: AppColorSystem.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(_getDefaultRadius()),
        border: Border.all(
          color: AppColorSystem.primary.withOpacity(0.3),
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

  // ===== دوال البناء الداخلية - منطق محسن =====

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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(borderRadius),
        border: border ?? Border.all(color: color.withOpacity(0.3)),
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
        overlayColor: color.withOpacity(0.1),
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

  /// إنشاء تدرج زجاجي - محسن
  static List<Color> _createGlassGradient(Color baseColor) {
    try {
      return [
        baseColor.withOpacity(0.95),
        AppColorSystem.getDarkColor(baseColor.toString()).withOpacity(0.85),
      ];
    } catch (e) {
      return [
        AppColorSystem.primary.withOpacity(0.95),
        AppColorSystem.primaryDark.withOpacity(0.85),
      ];
    }
  }

  // ===== Factory Methods محسنة - تستخدم buildContainer =====

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

  // ===== حاويات متخصصة محسنة =====

  /// حاوية للبطاقات - محسنة
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

  /// حاوية للأزرار - محسنة
  static Widget button({
    required Widget child,
    ComponentSize size = ComponentSize.md,
    String? colorKey,
    Color? backgroundColor,
    bool isOutlined = false,
    EdgeInsets? margin,
    VoidCallback? onTap,
  }) {
    try {
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
    } catch (e) {
      return basic(child: child, onTap: onTap);
    }
  }

  /// حاوية للحوارات - محسنة
  static Widget dialog({
    required Widget child,
    ComponentSize size = ComponentSize.lg,
    String? colorKey,
    EdgeInsets? margin,
    double? maxWidth,
  }) {
    try {
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
    } catch (e) {
      return basic(child: child);
    }
  }

  // ===== حاويات للمحتوى الإسلامي - محسنة =====

  /// حاوية لعرض الأذكار
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

  /// حاوية متجاوبة - تتكيف مع حجم الشاشة
  static Widget responsive({
    required Widget child,
    required BuildContext context,
    String? colorKey,
    bool withGlass = false,
    VoidCallback? onTap,
  }) {
    try {
      final screenWidth = MediaQuery.sizeOf(context).width;
      
      EdgeInsets padding;
      double borderRadius;
      
      if (screenWidth < ThemeConstants.breakpointMobile) {
        padding = const EdgeInsets.all(ThemeConstants.space3);
        borderRadius = ThemeConstants.radiusMd;
      } else if (screenWidth < ThemeConstants.breakpointTablet) {
        padding = const EdgeInsets.all(ThemeConstants.space4);
        borderRadius = ThemeConstants.radiusLg;
      } else {
        padding = const EdgeInsets.all(ThemeConstants.space6);
        borderRadius = ThemeConstants.radiusXl;
      }
      
      return buildContainer(
        child: child,
        style: withGlass ? ContainerStyle.glassGradient : ContainerStyle.basic,
        colorKey: colorKey,
        padding: padding,
        borderRadius: borderRadius,
        onTap: onTap,
      );
    } catch (e) {
      return basic(child: child, onTap: onTap);
    }
  }

  /// حاوية للإشعارات
  static Widget notification({
    required Widget child,
    String type = 'info',
    EdgeInsets? padding,
    EdgeInsets? margin,
    VoidCallback? onDismiss,
  }) {
    try {
      final notificationColor = AppColorSystem.getColor(type);
      
      return buildContainer(
        child: child,
        style: ContainerStyle.basic,
        backgroundColor: notificationColor,
        padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
        margin: margin ?? const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space4,
          vertical: ThemeConstants.space2,
        ),
        borderRadius: ThemeConstants.radiusLg,
        shadows: AppShadowSystem.colored(color: notificationColor),
        onTap: onDismiss,
      );
    } catch (e) {
      return basic(child: child);
    }
  }

  /// حاوية للقوائم
  static Widget listItem({
    required Widget child,
    bool isSelected = false,
    String? colorKey,
    VoidCallback? onTap,
    EdgeInsets? margin,
  }) {
    try {
      final style = isSelected ? ContainerStyle.gradient : ContainerStyle.basic;
      final effectiveColor = colorKey != null 
          ? AppColorSystem.getColor(colorKey)
          : AppColorSystem.primary;
      
      return buildContainer(
        child: child,
        style: style,
        backgroundColor: effectiveColor,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space4,
          vertical: ThemeConstants.space3,
        ),
        margin: margin ?? const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space2,
          vertical: ThemeConstants.space1,
        ),
        borderRadius: ThemeConstants.radiusMd,
        showShadow: isSelected,
        onTap: onTap,
      );
    } catch (e) {
      return basic(child: child, onTap: onTap);
    }
  }

  // ===== دوال مساعدة إضافية =====

  /// إنشاء حاوية بتصميم مخصص بالكامل
  static Widget custom({
    required Widget child,
    required ContainerDecoration decoration,
    EdgeInsets? padding,
    EdgeInsets? margin,
    VoidCallback? onTap,
  }) {
    try {
      return buildContainer(
        child: child,
        style: decoration.style,
        backgroundColor: decoration.backgroundColor,
        gradientColors: decoration.gradientColors,
        padding: padding ?? decoration.padding,
        margin: margin,
        borderRadius: decoration.borderRadius,
        border: decoration.border,
        shadows: decoration.shadows,
        alignment: decoration.alignment,
        onTap: onTap,
      );
    } catch (e) {
      return basic(child: child, onTap: onTap);
    }
  }

  /// تطبيق انيميشن على الحاوية
  static Widget animated({
    required Widget child,
    required Duration duration,
    ContainerStyle style = ContainerStyle.basic,
    String? colorKey,
    VoidCallback? onTap,
  }) {
    try {
      return AnimatedContainer(
        duration: duration,
        curve: ThemeConstants.curveDefault,
        child: buildContainer(
          child: child,
          style: style,
          colorKey: colorKey,
          onTap: onTap,
        ),
      );
    } catch (e) {
      return basic(child: child, onTap: onTap);
    }
  }
}

/// أنماط الحاويات - كما هو
enum ContainerStyle {
  basic,         // حاوية أساسية
  gradient,      // حاوية مع تدرج
  glass,         // حاوية زجاجية
  glassGradient, // حاوية زجاجية مع تدرج
}

/// تصميم حاوية مخصص
class ContainerDecoration {
  final ContainerStyle style;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final EdgeInsets? padding;
  final double? borderRadius;
  final Border? border;
  final List<BoxShadow>? shadows;
  final AlignmentGeometry? alignment;

  const ContainerDecoration({
    this.style = ContainerStyle.basic,
    this.backgroundColor,
    this.gradientColors,
    this.padding,
    this.borderRadius,
    this.border,
    this.shadows,
    this.alignment,
  });

  /// إنشاء تصميم بسيط
  factory ContainerDecoration.simple({
    Color? backgroundColor,
    EdgeInsets? padding,
    double? borderRadius,
  }) {
    return ContainerDecoration(
      style: ContainerStyle.basic,
      backgroundColor: backgroundColor,
      padding: padding,
      borderRadius: borderRadius,
    );
  }

  /// إنشاء تصميم متدرج
  factory ContainerDecoration.gradient({
    required List<Color> colors,
    EdgeInsets? padding,
    double? borderRadius,
    List<BoxShadow>? shadows,
  }) {
    return ContainerDecoration(
      style: ContainerStyle.gradient,
      gradientColors: colors,
      padding: padding,
      borderRadius: borderRadius,
      shadows: shadows,
    );
  }

  /// إنشاء تصميم زجاجي
  factory ContainerDecoration.glass({
    Color? backgroundColor,
    EdgeInsets? padding,
    double? borderRadius,
  }) {
    return ContainerDecoration(
      style: ContainerStyle.glass,
      backgroundColor: backgroundColor,
      padding: padding,
      borderRadius: borderRadius,
    );
  }
}

/// Extension محسن - بدون تكرار منطق البناء
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

  /// تطبيق حاوية متجاوبة
  Widget responsiveContainer({
    required BuildContext context,
    String? colorKey,
    bool withGlass = false,
    VoidCallback? onTap,
  }) {
    return AppContainerBuilder.responsive(
      child: this,
      context: context,
      colorKey: colorKey,
      withGlass: withGlass,
      onTap: onTap,
    );
  }

  /// تطبيق حاوية مخصصة
  Widget customContainer({
    required ContainerDecoration decoration,
    EdgeInsets? padding,
    EdgeInsets? margin,
    VoidCallback? onTap,
  }) {
    return AppContainerBuilder.custom(
      child: this,
      decoration: decoration,
      padding: padding,
      margin: margin,
      onTap: onTap,
    );
  }

  /// تطبيق حاوية متحركة
  Widget animatedContainer({
    required Duration duration,
    ContainerStyle style = ContainerStyle.basic,
    String? colorKey,
    VoidCallback? onTap,
  }) {
    return AppContainerBuilder.animated(
      child: this,
      duration: duration,
      style: style,
      colorKey: colorKey,
      onTap: onTap,
    );
  }
}