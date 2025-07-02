// lib/app/themes/core/systems/app_container_builder.dart - النسخة المُنظفة والمُحسنة
import 'package:flutter/material.dart';
import 'package:athkar_app/app/themes/theme_constants.dart';
import 'app_color_system.dart';
import 'app_size_system.dart';
import 'app_shadow_system.dart';
import 'glass_effect.dart';

/// نظام بناء الحاويات الموحد - مُنظف ومُحسن
/// يوفر طرق سهلة ومتسقة لإنشاء الحاويات المختلفة
class AppContainerBuilder {
  AppContainerBuilder._();

  // ===== الحاويات الأساسية =====

  /// حاوية أساسية مع إعدادات افتراضية ذكية
  static Widget basic({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? width,
    double? height,
    Color? backgroundColor,
    double? borderRadius,
    Border? border,
    List<BoxShadow>? shadows,
    AlignmentGeometry? alignment,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
      alignment: alignment,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius != null 
            ? BorderRadius.circular(borderRadius) 
            : BorderRadius.circular(ThemeConstants.radiusMd),
        border: border,
        boxShadow: shadows,
      ),
      child: child,
    );
  }

  /// حاوية مع تدرج لوني
  static Widget gradient({
    required Widget child,
    required List<Color> colors,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? width,
    double? height,
    double? borderRadius,
    List<BoxShadow>? shadows,
    AlignmentGeometry begin = Alignment.topLeft,
    AlignmentGeometry end = Alignment.bottomRight,
    List<double>? stops,
    AlignmentGeometry? alignment,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
      alignment: alignment,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors,
          stops: stops,
        ),
        borderRadius: borderRadius != null 
            ? BorderRadius.circular(borderRadius) 
            : BorderRadius.circular(ThemeConstants.radiusMd),
        boxShadow: shadows ?? AppShadowSystem.medium,
      ),
      child: child,
    );
  }

  /// حاوية زجاجية (Glass Morphism)
  static Widget glass({
    required Widget child,
    Color? backgroundColor,
    double blur = 10,
    double borderOpacity = 0.2,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? width,
    double? height,
    double? borderRadius,
    List<BoxShadow>? shadows,
    GlassIntensity intensity = GlassIntensity.medium,
    AlignmentGeometry? alignment,
  }) {
    return Container(
      margin: margin,
      alignment: alignment,
      child: GlassEffect(
        blur: blur,
        borderOpacity: borderOpacity,
        borderRadius: borderRadius != null 
            ? BorderRadius.circular(borderRadius) 
            : BorderRadius.circular(ThemeConstants.radiusLg),
        padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
        width: width,
        height: height,
        shadows: shadows,
        intensity: intensity,
        child: child,
      ),
    );
  }

  /// حاوية زجاجية مع تدرج لوني
  static Widget glassGradient({
    required Widget child,
    required List<Color> colors,
    double blur = 10,
    double borderOpacity = 0.2,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? width,
    double? height,
    double? borderRadius,
    List<BoxShadow>? shadows,
    AlignmentGeometry? alignment,
  }) {
    return Container(
      margin: margin,
      alignment: alignment,
      child: GlassEffect.withGradient(
        child: child,
        gradientColors: colors,
        blur: blur,
        borderOpacity: borderOpacity,
        borderRadius: borderRadius != null 
            ? BorderRadius.circular(borderRadius) 
            : BorderRadius.circular(ThemeConstants.radiusLg),
        padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
        shadows: shadows,
      ),
    );
  }

  // ===== حاويات متخصصة للمكونات =====

  /// حاوية للبطاقات
  static Widget card({
    required Widget child,
    ComponentSize size = ComponentSize.md,
    Color? backgroundColor,
    String? colorKey,
    bool withShadow = true,
    bool withGlass = false,
    EdgeInsets? margin,
    AlignmentGeometry? alignment,
  }) {
    final cardSizes = size.cardSizes;
    final effectiveColor = backgroundColor ?? 
        (colorKey != null ? AppColorSystem.getColor(colorKey) : null);
    
    if (withGlass) {
      return glassGradient(
        colors: colorKey != null 
            ? [
                AppColorSystem.getColor(colorKey).withValues(alpha: 0.9),
                AppColorSystem.getDarkColor(colorKey).withValues(alpha: 0.7),
              ]
            : [
                Colors.white.withValues(alpha: 0.9),
                Colors.white.withValues(alpha: 0.7),
              ],
        padding: cardSizes.padding,
        margin: margin,
        borderRadius: cardSizes.borderRadius,
        shadows: withShadow ? AppShadowSystem.card : null,
        alignment: alignment,
        child: child,
      );
    }

    if (effectiveColor != null) {
      return gradient(
        colors: colorKey != null 
            ? [
                AppColorSystem.getColor(colorKey),
                AppColorSystem.getDarkColor(colorKey),
              ]
            : [effectiveColor, effectiveColor],
        padding: cardSizes.padding,
        margin: margin,
        borderRadius: cardSizes.borderRadius,
        shadows: withShadow ? AppShadowSystem.colored(color: effectiveColor) : null,
        alignment: alignment,
        child: child,
      );
    }

    return basic(
      padding: cardSizes.padding,
      margin: margin,
      borderRadius: cardSizes.borderRadius,
      shadows: withShadow ? AppShadowSystem.card : null,
      alignment: alignment,
      child: child,
    );
  }

  /// حاوية للأزرار
  static Widget button({
    required Widget child,
    ComponentSize size = ComponentSize.md,
    Color? backgroundColor,
    String? colorKey,
    bool withShadow = true,
    bool isOutlined = false,
    EdgeInsets? margin,
    VoidCallback? onTap,
    AlignmentGeometry? alignment,
  }) {
    final buttonSizes = size.buttonSizes;
    final effectiveColor = backgroundColor ?? 
        (colorKey != null ? AppColorSystem.getColor(colorKey) : null);
    
    Widget container;
    
    if (isOutlined) {
      container = basic(
        padding: buttonSizes.padding,
        margin: margin,
        borderRadius: buttonSizes.borderRadius,
        border: Border.all(
          color: effectiveColor ?? Colors.grey,
          width: 1.5,
        ),
        shadows: withShadow ? AppShadowSystem.button : null,
        alignment: alignment ?? Alignment.center,
        child: child,
      );
    } else if (effectiveColor != null) {
      container = gradient(
        colors: colorKey != null 
            ? [
                AppColorSystem.getColor(colorKey),
                AppColorSystem.getDarkColor(colorKey),
              ]
            : [effectiveColor, effectiveColor],
        padding: buttonSizes.padding,
        margin: margin,
        borderRadius: buttonSizes.borderRadius,
        shadows: withShadow ? AppShadowSystem.colored(color: effectiveColor) : null,
        alignment: alignment ?? Alignment.center,
        child: child,
      );
    } else {
      container = basic(
        padding: buttonSizes.padding,
        margin: margin,
        backgroundColor: Colors.grey.shade200,
        borderRadius: buttonSizes.borderRadius,
        shadows: withShadow ? AppShadowSystem.button : null,
        alignment: alignment ?? Alignment.center,
        child: child,
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }
    
    return container;
  }

  /// حاوية للحوارات
  static Widget dialog({
    required Widget child,
    ComponentSize size = ComponentSize.lg,
    String? colorKey,
    bool withGlass = true,
    EdgeInsets? margin,
    double? maxWidth,
    AlignmentGeometry? alignment,
  }) {
    final dialogSizes = size.dialogSizes;
    
    if (withGlass && colorKey != null) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? 400,
        ),
        child: glassGradient(
          colors: [
            AppColorSystem.getColor(colorKey).withValues(alpha: 0.9),
            AppColorSystem.getDarkColor(colorKey).withValues(alpha: 0.7),
          ],
          padding: dialogSizes.padding,
          margin: margin,
          borderRadius: dialogSizes.borderRadius,
          shadows: AppShadowSystem.dialog,
          alignment: alignment,
          child: child,
        ),
      );
    }
    
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth ?? 400,
      ),
      child: glass(
        padding: dialogSizes.padding,
        margin: margin,
        borderRadius: dialogSizes.borderRadius,
        shadows: AppShadowSystem.dialog,
        intensity: GlassIntensity.strong,
        alignment: alignment,
        child: child,
      ),
    );
  }

  /// حاوية للإدخال
  static Widget input({
    required Widget child,
    ComponentSize size = ComponentSize.md,
    Color? backgroundColor,
    Color? borderColor,
    bool isFocused = false,
    bool hasError = false,
    EdgeInsets? margin,
    AlignmentGeometry? alignment,
  }) {
    final inputSizes = size.inputSizes;
    final effectiveBorderColor = hasError 
        ? AppColorSystem.error
        : isFocused 
            ? (borderColor ?? AppColorSystem.primary)
            : Colors.grey.shade300;
    
    return basic(
      padding: inputSizes.padding,
      margin: margin,
      backgroundColor: backgroundColor ?? Colors.grey.shade50,
      borderRadius: inputSizes.borderRadius,
      border: Border.all(
        color: effectiveBorderColor,
        width: isFocused ? 2 : 1,
      ),
      alignment: alignment,
      child: child,
    );
  }

  // ===== حاويات للحالات الخاصة =====

  /// حاوية للحالة الفارغة
  static Widget empty({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    AlignmentGeometry? alignment,
  }) {
    return basic(
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space8),
      margin: margin,
      backgroundColor: Colors.grey.shade50,
      borderRadius: borderRadius ?? ThemeConstants.radiusLg,
      border: Border.all(
        color: Colors.grey.shade200,
        style: BorderStyle.solid,
      ),
      alignment: alignment ?? Alignment.center,
      child: child,
    );
  }

  /// حاوية للتحميل
  static Widget loading({
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? backgroundColor,
    double? borderRadius,
    AlignmentGeometry? alignment,
  }) {
    return basic(
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space6),
      margin: margin,
      backgroundColor: backgroundColor ?? Colors.white.withValues(alpha: 0.95),
      borderRadius: borderRadius ?? ThemeConstants.radiusLg,
      shadows: AppShadowSystem.medium,
      alignment: alignment ?? Alignment.center,
      child: child,
    );
  }

  /// حاوية للإشعارات
  static Widget notification({
    required Widget child,
    required String type, // 'success', 'error', 'warning', 'info'
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    bool withGlass = false,
    AlignmentGeometry? alignment,
  }) {
    final color = AppColorSystem.getColor(type);
    
    if (withGlass) {
      return glassGradient(
        colors: [
          color.withValues(alpha: 0.9),
          color.darken(0.1).withValues(alpha: 0.7),
        ],
        padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
        margin: margin,
        borderRadius: borderRadius ?? ThemeConstants.radiusLg,
        shadows: AppShadowSystem.colored(color: color),
        alignment: alignment,
        child: child,
      );
    }
    
    return gradient(
      colors: [color, color.darken(0.1)],
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
      margin: margin,
      borderRadius: borderRadius ?? ThemeConstants.radiusLg,
      shadows: AppShadowSystem.colored(color: color),
      alignment: alignment,
      child: child,
    );
  }

  // ===== دوال مساعدة للتخصيص =====

  /// إنشاء حاوية مخصصة بالكامل
  static Widget custom({
    required Widget child,
    ContainerStyle style = ContainerStyle.basic,
    ComponentSize size = ComponentSize.md,
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
  }) {
    Widget container;
    
    switch (style) {
      case ContainerStyle.basic:
        container = basic(
          child: child,
          padding: padding,
          margin: margin,
          width: width,
          height: height,
          backgroundColor: backgroundColor,
          borderRadius: borderRadius,
          border: border,
          shadows: shadows,
          alignment: alignment,
        );
        break;
        
      case ContainerStyle.gradient:
        container = gradient(
          child: child,
          colors: gradientColors ?? 
              (colorKey != null 
                  ? [
                      AppColorSystem.getColor(colorKey),
                      AppColorSystem.getDarkColor(colorKey),
                    ]
                  : [Colors.grey, Colors.grey.shade700]),
          padding: padding,
          margin: margin,
          width: width,
          height: height,
          borderRadius: borderRadius,
          shadows: shadows,
          alignment: alignment,
        );
        break;
        
      case ContainerStyle.glass:
        container = glass(
          child: child,
          backgroundColor: backgroundColor,
          padding: padding,
          margin: margin,
          width: width,
          height: height,
          borderRadius: borderRadius,
          shadows: shadows,
          alignment: alignment,
        );
        break;
        
      case ContainerStyle.glassGradient:
        container = glassGradient(
          child: child,
          colors: gradientColors ?? 
              (colorKey != null 
                  ? [
                      AppColorSystem.getColor(colorKey).withValues(alpha: 0.9),
                      AppColorSystem.getDarkColor(colorKey).withValues(alpha: 0.7),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.9),
                      Colors.white.withValues(alpha: 0.7),
                    ]),
          padding: padding,
          margin: margin,
          width: width,
          height: height,
          borderRadius: borderRadius,
          shadows: shadows,
          alignment: alignment,
        );
        break;
    }
    
    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: container,
      );
    }
    
    return container;
  }

  // ===== حاويات خاصة للأذكار والمحتوى الإسلامي =====

  /// حاوية لعرض الأذكار
  static Widget athkar({
    required Widget child,
    String categoryType = 'morning',
    bool withGlass = true,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    if (withGlass) {
      return glassGradient(
        colors: [
          AppColorSystem.getColor(categoryType).withValues(alpha: 0.95),
          AppColorSystem.getDarkColor(categoryType).withValues(alpha: 0.85),
          AppColorSystem.getDarkColor(categoryType).withValues(alpha: 0.75),
        ],
        padding: padding ?? const EdgeInsets.all(ThemeConstants.space5),
        margin: margin,
        borderRadius: ThemeConstants.radiusXl,
        shadows: AppShadowSystem.colored(
          color: AppColorSystem.getColor(categoryType),
          intensity: ShadowIntensity.medium,
        ),
        child: child,
      );
    }

    return gradient(
      colors: [
        AppColorSystem.getColor(categoryType),
        AppColorSystem.getDarkColor(categoryType),
      ],
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space5),
      margin: margin,
      borderRadius: ThemeConstants.radiusXl,
      shadows: AppShadowSystem.colored(
        color: AppColorSystem.getColor(categoryType),
      ),
      child: child,
    );
  }

  /// حاوية لعرض آية أو حديث
  static Widget quote({
    required Widget child,
    String quoteType = 'verse',
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return glassGradient(
      colors: [
        AppColorSystem.getColor(quoteType).withValues(alpha: 0.9),
        AppColorSystem.getDarkColor(quoteType).withValues(alpha: 0.7),
      ],
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space6),
      margin: margin,
      borderRadius: ThemeConstants.radius2xl,
      shadows: AppShadowSystem.colored(
        color: AppColorSystem.getColor(quoteType),
        intensity: ShadowIntensity.strong,
      ),
      child: child,
    );
  }
}

/// أنماط الحاويات المختلفة
enum ContainerStyle {
  basic,         // حاوية أساسية
  gradient,      // حاوية مع تدرج
  glass,         // حاوية زجاجية
  glassGradient, // حاوية زجاجية مع تدرج
}

/// Extension لتسهيل الاستخدام - مُحسن
extension AppContainerExtension on Widget {
  /// تطبيق حاوية أساسية
  Widget container({
    EdgeInsets? padding,
    EdgeInsets? margin,
    Color? backgroundColor,
    double? borderRadius,
    List<BoxShadow>? shadows,
    VoidCallback? onTap,
  }) {
    return AppContainerBuilder.basic(
      child: this,
      padding: padding,
      margin: margin,
      backgroundColor: backgroundColor,
      borderRadius: borderRadius,
      shadows: shadows,
    ).let((container) => onTap != null 
        ? GestureDetector(onTap: onTap, child: container)
        : container);
  }
  
  /// تطبيق حاوية مع تدرج
  Widget gradientContainer({
    required List<Color> colors,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    VoidCallback? onTap,
  }) {
    return AppContainerBuilder.gradient(
      child: this,
      colors: colors,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
    ).let((container) => onTap != null 
        ? GestureDetector(onTap: onTap, child: container)
        : container);
  }
  
  /// تطبيق حاوية مع تدرج بناءً على مفتاح لوني
  Widget categoryContainer({
    required String colorKey,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    VoidCallback? onTap,
  }) {
    return AppContainerBuilder.gradient(
      child: this,
      colors: [
        AppColorSystem.getColor(colorKey),
        AppColorSystem.getDarkColor(colorKey),
      ],
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
    ).let((container) => onTap != null 
        ? GestureDetector(onTap: onTap, child: container)
        : container);
  }
  
  /// تطبيق حاوية زجاجية
  Widget glassContainer({
    double blur = 10,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? borderRadius,
    VoidCallback? onTap,
  }) {
    return AppContainerBuilder.glass(
      child: this,
      blur: blur,
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
    ).let((container) => onTap != null 
        ? GestureDetector(onTap: onTap, child: container)
        : container);
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
    ).let((container) => onTap != null 
        ? GestureDetector(onTap: onTap, child: container)
        : container);
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

/// Extension مساعدة
extension WidgetExtension on Widget {
  T let<T>(T Function(Widget) operation) => operation(this);
}

/// Extension للألوان - محلي لتجنب التضارب
extension _ColorHelper on Color {
  Color darken([double amount = 0.1]) {
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}