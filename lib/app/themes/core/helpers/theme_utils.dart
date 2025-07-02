// lib/app/themes/core/helpers/theme_utils.dart - مُصحح لحل تعارض GradientType

import 'package:flutter/material.dart';
import '../../theme_constants.dart';
// ✅ إزالة الاستيراد غير المستخدم
// import '../systems/app_color_system.dart';

/// أدوات مساعدة موحدة لتجنب التكرار في الثيم
class ThemeUtils {
  ThemeUtils._();

  // ===== دوال الألوان الموحدة =====

  /// الحصول على لون سياقي (فاتح/داكن) بدون تكرار
  static Color getContextualColor(
    BuildContext context, {
    required Color lightColor,
    required Color darkColor,
  }) {
    return Theme.of(context).brightness == Brightness.dark 
        ? darkColor 
        : lightColor;
  }

  /// الحصول على لون النص المتباين - موحد
  static Color getContrastingTextColor(Color backgroundColor) {
    try {
      return ThemeData.estimateBrightnessForColor(backgroundColor) == Brightness.dark
          ? Colors.white
          : Colors.black87;
    } catch (e) {
      return Colors.white;
    }
  }

  /// تطبيق شفافية آمنة - موحد
  static Color applyOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity.clamp(0.0, 1.0));
  }

  /// تفتيح اللون - موحد
  static Color lightenColor(Color color, [double amount = 0.1]) {
    try {
      final clampedAmount = amount.clamp(0.0, 1.0);
      final hsl = HSLColor.fromColor(color);
      final lightness = (hsl.lightness + clampedAmount).clamp(0.0, 1.0);
      return hsl.withLightness(lightness).toColor();
    } catch (e) {
      return color;
    }
  }

  /// تغميق اللون - موحد
  static Color darkenColor(Color color, [double amount = 0.1]) {
    try {
      final clampedAmount = amount.clamp(0.0, 1.0);
      final hsl = HSLColor.fromColor(color);
      final lightness = (hsl.lightness - clampedAmount).clamp(0.0, 1.0);
      return hsl.withLightness(lightness).toColor();
    } catch (e) {
      return color;
    }
  }

  // ===== دوال التخطيط الموحدة =====

  /// الحصول على padding متجاوب - موحد
  static EdgeInsets getResponsivePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    
    if (width < ThemeConstants.breakpointMobile) {
      return const EdgeInsets.all(ThemeConstants.space4);
    } else if (width < ThemeConstants.breakpointTablet) {
      return const EdgeInsets.all(ThemeConstants.space6);
    } else {
      return const EdgeInsets.all(ThemeConstants.space8);
    }
  }

  /// الحصول على margin متجاوب - موحد
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    
    if (width < ThemeConstants.breakpointMobile) {
      return const EdgeInsets.all(ThemeConstants.space2);
    } else if (width < ThemeConstants.breakpointTablet) {
      return const EdgeInsets.all(ThemeConstants.space3);
    } else {
      return const EdgeInsets.all(ThemeConstants.space4);
    }
  }

  // ===== دوال بناء الحاويات الموحدة =====

  /// بناء حاوية مع ديكور موحد - يقلل التكرار
  static Container buildStyledContainer({
    required Widget child,
    Color? backgroundColor,
    List<Color>? gradientColors,
    double? borderRadius,
    List<BoxShadow>? shadows,
    EdgeInsets? padding,
    EdgeInsets? margin,
    Border? border,
    bool withGlassEffect = false,
  }) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: gradientColors == null ? backgroundColor : null,
        gradient: gradientColors != null 
          ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradientColors,
            )
          : null,
        borderRadius: BorderRadius.circular(borderRadius ?? ThemeConstants.radiusMd),
        boxShadow: shadows,
        border: border ?? (withGlassEffect 
          ? Border.all(color: Colors.white.withValues(alpha: 0.2))
          : null),
      ),
      child: child,
    );
  }

  /// إنشاء تدرج لوني موحد
  static List<Color> createGradient(Color baseColor, {
    ThemeGradientType type = ThemeGradientType.lightToDark, // ✅ اسم مختلف لتجنب التعارض
    double intensity = 0.2,
  }) {
    switch (type) {
      case ThemeGradientType.lightToDark:
        return [
          lightenColor(baseColor, intensity),
          baseColor,
          darkenColor(baseColor, intensity),
        ];
      case ThemeGradientType.transparent:
        return [
          applyOpacity(baseColor, 0.9),
          applyOpacity(baseColor, 0.7),
        ];
      case ThemeGradientType.simple:
        return [baseColor, darkenColor(baseColor, intensity)];
    }
  }

  // ===== دوال النصوص الموحدة =====

  /// الحصول على نمط نص مع ظل موحد
  static TextStyle getTextStyleWithShadow(
    TextStyle baseStyle, 
    Color textColor, {
    bool withShadow = false,
    double shadowOpacity = 0.3,
  }) {
    return baseStyle.copyWith(
      color: textColor,
      shadows: withShadow ? [
        Shadow(
          color: Colors.black.withValues(alpha: shadowOpacity),
          offset: const Offset(0, 1),
          blurRadius: 2,
        ),
      ] : null,
    );
  }

  /// الحصول على لون نص مناسب للخلفية
  static Color getAdaptiveTextColor(
    BuildContext context,
    Color backgroundColor, {
    bool isSecondary = false,
  }) {
    final contrastColor = getContrastingTextColor(backgroundColor);
    return isSecondary 
        ? applyOpacity(contrastColor, 0.7)
        : contrastColor;
  }

  // ===== دوال التحقق والتحويل الموحدة =====

  /// التحقق من صحة القيم - موحد
  static bool isValidOpacity(double? value) {
    return value != null && value >= 0.0 && value <= 1.0;
  }

  static bool isValidRadius(double? value) {
    return value != null && value >= 0.0;
  }

  static bool isValidSize(double? value) {
    return value != null && value > 0.0;
  }

  /// تحويل آمن للقيم
  static double safeOpacity(double? value, [double defaultValue = 0.5]) {
    return isValidOpacity(value) ? value! : defaultValue;
  }

  static double safeRadius(double? value, [double defaultValue = ThemeConstants.radiusMd]) {
    return isValidRadius(value) ? value! : defaultValue;
  }

  static double safeSize(double? value, [double defaultValue = 24.0]) {
    return isValidSize(value) ? value! : defaultValue;
  }

  // ===== دوال مساعدة للأجهزة =====

  /// التحقق من نوع الجهاز - موحد
  static ThemeDeviceType getDeviceType(BuildContext context) { // ✅ اسم مختلف لتجنب التعارض
    final width = MediaQuery.sizeOf(context).width;
    
    if (width < ThemeConstants.breakpointMobile) {
      return ThemeDeviceType.mobile;
    } else if (width < ThemeConstants.breakpointTablet) {
      return ThemeDeviceType.tablet;
    } else {
      return ThemeDeviceType.desktop;
    }
  }

  /// الحصول على عدد الأعمدة المناسب
  static int getResponsiveColumns(BuildContext context, {
    int mobileColumns = 1,
    int tabletColumns = 2,
    int desktopColumns = 3,
  }) {
    switch (getDeviceType(context)) {
      case ThemeDeviceType.mobile:
        return mobileColumns;
      case ThemeDeviceType.tablet:
        return tabletColumns;
      case ThemeDeviceType.desktop:
        return desktopColumns;
    }
  }

  // ===== Cache للتحسين =====
  static final Map<String, Color> _colorCache = {};
  static final Map<String, EdgeInsets> _paddingCache = {};

  /// الحصول على لون مع cache
  static Color getCachedColor(String key, Color Function() generator) {
    return _colorCache.putIfAbsent(key, generator);
  }

  /// مسح الcache
  static void clearCache() {
    _colorCache.clear();
    _paddingCache.clear();
  }

  // ===== دوال إنشاء سريعة =====

  /// إنشاء EdgeInsets سريع
  static EdgeInsets createPadding({
    double? all,
    double? horizontal,
    double? vertical,
    double? left,
    double? top,
    double? right,
    double? bottom,
  }) {
    if (all != null) return EdgeInsets.all(all);
    
    if (horizontal != null || vertical != null) {
      return EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      );
    }
    
    return EdgeInsets.only(
      left: left ?? 0,
      top: top ?? 0,
      right: right ?? 0,
      bottom: bottom ?? 0,
    );
  }

  /// إنشاء BorderRadius سريع
  static BorderRadius createBorderRadius({
    double? all,
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) {
    if (all != null) return BorderRadius.circular(all);
    
    return BorderRadius.only(
      topLeft: Radius.circular(topLeft ?? 0),
      topRight: Radius.circular(topRight ?? 0),
      bottomLeft: Radius.circular(bottomLeft ?? 0),
      bottomRight: Radius.circular(bottomRight ?? 0),
    );
  }
}

// ===== Enums مساعدة - أسماء مختلفة لتجنب التعارض =====

enum ThemeGradientType { // ✅ اسم مختلف لتجنب التعارض مع auto_color_helper
  lightToDark,
  transparent,
  simple,
}

enum ThemeDeviceType { // ✅ اسم مختلف لتجنب التعارض
  mobile,
  tablet,
  desktop,
}

// ===== Extensions مساعدة موحدة =====

extension ColorUtilsExtension on Color {
  /// شفافية آمنة
  Color opacity(double opacity) => ThemeUtils.applyOpacity(this, opacity);
  
  /// ألوان جاهزة بشفافيات مختلفة
  Color get subtle => opacity(0.1);
  Color get light => opacity(0.3);
  Color get medium => opacity(0.6);
  Color get strong => opacity(0.8);
  
  /// تفتيح وتغميق
  Color lighten([double amount = 0.1]) => ThemeUtils.lightenColor(this, amount);
  Color darken([double amount = 0.1]) => ThemeUtils.darkenColor(this, amount);
  
  /// لون النص المتباين
  Color get contrastingText => ThemeUtils.getContrastingTextColor(this);
}

// ✅ إزالة ContextUtilsExtension من هنا لتجنب التعارض