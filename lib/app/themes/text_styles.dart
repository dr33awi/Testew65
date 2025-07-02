// lib/app/themes/text_styles.dart - مُبسط ومُوحد بعد إزالة التكرار

import 'package:athkar_app/app/themes/theme_constants.dart';
import 'package:athkar_app/app/themes/core/systems/app_color_system.dart';
import 'package:athkar_app/app/themes/core/helpers/theme_utils.dart'; // ✅ الأدوات الموحدة
import 'package:flutter/material.dart';

/// أنماط النصوص الموحدة للتطبيق - مُبسط ومُوحد
class AppTextStyles {
  AppTextStyles._();

  // ===== النمط الأساسي الموحد =====
  static const TextStyle _baseStyle = TextStyle(
    fontFamily: ThemeConstants.fontFamily,
  );

  // ===== أنماط العناوين - مبنية على النمط الأساسي =====
  static final TextStyle h1 = _baseStyle.copyWith(
    fontSize: ThemeConstants.textSize4xl,
    fontWeight: ThemeConstants.bold,
    height: 1.3,
  );

  static final TextStyle h2 = _baseStyle.copyWith(
    fontSize: ThemeConstants.textSize3xl,
    fontWeight: ThemeConstants.semiBold,
    height: 1.3,
  );

  static final TextStyle h3 = _baseStyle.copyWith(
    fontSize: ThemeConstants.textSize2xl,
    fontWeight: ThemeConstants.semiBold,
    height: 1.4,
  );

  static final TextStyle h4 = _baseStyle.copyWith(
    fontSize: ThemeConstants.textSizeXl,
    fontWeight: ThemeConstants.semiBold,
    height: 1.4,
  );

  static final TextStyle h5 = _baseStyle.copyWith(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.semiBold,
    height: 1.5,
  );

  // ===== أنماط النص الأساسي =====
  static final TextStyle body1 = _baseStyle.copyWith(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.regular,
    height: 1.6,
  );

  static final TextStyle body2 = _baseStyle.copyWith(
    fontSize: ThemeConstants.textSizeMd,
    fontWeight: ThemeConstants.regular,
    height: 1.6,
  );

  // ===== أنماط التسميات =====
  static final TextStyle label1 = _baseStyle.copyWith(
    fontSize: ThemeConstants.textSizeMd,
    fontWeight: ThemeConstants.medium,
    height: 1.4,
  );

  static final TextStyle label2 = _baseStyle.copyWith(
    fontSize: ThemeConstants.textSizeSm,
    fontWeight: ThemeConstants.medium,
    height: 1.4,
  );

  static final TextStyle caption = _baseStyle.copyWith(
    fontSize: ThemeConstants.textSizeXs,
    fontWeight: ThemeConstants.regular,
    height: 1.4,
  );

  // ===== أنماط الأزرار =====
  static final TextStyle button = _baseStyle.copyWith(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.semiBold,
    height: 1.2,
  );

  static final TextStyle buttonSmall = _baseStyle.copyWith(
    fontSize: ThemeConstants.textSizeMd,
    fontWeight: ThemeConstants.semiBold,
    height: 1.2,
  );

  // ===== أنماط خاصة بالمحتوى الإسلامي =====
  static const TextStyle quran = TextStyle(
    fontSize: 22,
    fontWeight: ThemeConstants.regular,
    height: 2.0,
    fontFamily: ThemeConstants.fontFamilyQuran,
  );

  static final TextStyle athkar = _baseStyle.copyWith(
    fontSize: ThemeConstants.textSizeXl,
    fontWeight: ThemeConstants.regular,
    height: 1.8,
  );

  static final TextStyle dua = _baseStyle.copyWith(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.regular,
    height: 1.7,
  );

  // ===== إنشاء TextTheme للتطبيق - مُوحد =====
  static TextTheme createTextTheme({
    required Color color,
    Color? secondaryColor,
  }) {
    final Color effectiveSecondaryColor = secondaryColor ?? 
        ThemeUtils.applyOpacity(color, 0.7); // ✅ استخدام ThemeUtils
    
    return TextTheme(
      // Display styles
      displayLarge: h1.copyWith(color: color),
      displayMedium: h2.copyWith(color: color),
      displaySmall: h3.copyWith(color: color),
      
      // Headline styles
      headlineLarge: h1.copyWith(color: color),
      headlineMedium: h2.copyWith(color: color),
      headlineSmall: h3.copyWith(color: color),
      
      // Title styles
      titleLarge: h4.copyWith(color: color),
      titleMedium: h5.copyWith(color: color),
      titleSmall: h5.copyWith(color: color, fontSize: ThemeConstants.textSizeMd),
      
      // Body styles
      bodyLarge: body1.copyWith(color: color),
      bodyMedium: body2.copyWith(color: effectiveSecondaryColor),
      bodySmall: caption.copyWith(color: effectiveSecondaryColor),
      
      // Label styles
      labelLarge: label1.copyWith(color: color),
      labelMedium: label2.copyWith(color: effectiveSecondaryColor),
      labelSmall: caption.copyWith(color: effectiveSecondaryColor),
    );
  }

  // ===== أنماط مخصصة حسب السياق - مُوحدة باستخدام ThemeUtils =====
  
  /// نص للعناوين الرئيسية في الصفحات
  static TextStyle pageTitle(BuildContext context) {
    return ThemeUtils.getTextStyleWithShadow(
      h2,
      AppColorSystem.getTextPrimary(context),
    );
  }

  /// نص للعناوين الفرعية
  static TextStyle sectionTitle(BuildContext context) {
    return ThemeUtils.getTextStyleWithShadow(
      h4,
      AppColorSystem.getTextPrimary(context),
    );
  }

  /// نص للمحتوى الرئيسي
  static TextStyle contentText(BuildContext context) {
    return ThemeUtils.getTextStyleWithShadow(
      body1,
      AppColorSystem.getTextPrimary(context),
    );
  }

  /// نص للمعلومات الثانوية
  static TextStyle secondaryText(BuildContext context) {
    return ThemeUtils.getTextStyleWithShadow(
      body2,
      AppColorSystem.getTextSecondary(context),
    );
  }

  /// نص للتلميحات
  static TextStyle hintText(BuildContext context) {
    return ThemeUtils.getTextStyleWithShadow(
      caption,
      ThemeUtils.applyOpacity(AppColorSystem.getTextSecondary(context), 0.7), // ✅ استخدام ThemeUtils
    );
  }

  // ===== أنماط الحالات - مُوحدة =====
  
  /// نص للأخطاء
  static TextStyle errorText(BuildContext context) {
    return ThemeUtils.getTextStyleWithShadow(
      caption,
      AppColorSystem.error,
    );
  }

  /// نص للنجاح
  static TextStyle successText(BuildContext context) {
    return ThemeUtils.getTextStyleWithShadow(
      body2.copyWith(fontWeight: ThemeConstants.medium),
      AppColorSystem.success,
    );
  }

  /// نص للتحذيرات
  static TextStyle warningText(BuildContext context) {
    return ThemeUtils.getTextStyleWithShadow(
      body2.copyWith(fontWeight: ThemeConstants.medium),
      AppColorSystem.warning,
    );
  }

  /// نص للمعلومات
  static TextStyle infoText(BuildContext context) {
    return ThemeUtils.getTextStyleWithShadow(
      body2,
      AppColorSystem.info,
    );
  }

  /// نص للروابط
  static TextStyle linkText(BuildContext context) {
    return body2.copyWith(
      color: AppColorSystem.primary,
      decoration: TextDecoration.underline,
    );
  }

  // ===== أنماط متخصصة للمحتوى الإسلامي - مُحسنة =====

  /// نص للآيات القرآنية مع تخصيص
  static TextStyle verseText(BuildContext context, {bool withShadow = true}) {
    return ThemeUtils.getTextStyleWithShadow(
      quran,
      AppColorSystem.getTextPrimary(context),
      withShadow: withShadow,
    );
  }

  /// نص للأذكار مع تخصيص
  static TextStyle athkarText(BuildContext context, {bool withShadow = true}) {
    return ThemeUtils.getTextStyleWithShadow(
      athkar,
      Colors.white, // الأذكار عادة على خلفية ملونة
      withShadow: withShadow,
      shadowOpacity: 0.5,
    );
  }

  /// نص للأدعية مع تخصيص
  static TextStyle duaText(BuildContext context, {bool withShadow = false}) {
    return ThemeUtils.getTextStyleWithShadow(
      dua,
      AppColorSystem.getTextPrimary(context),
      withShadow: withShadow,
    );
  }

  // ===== دوال مساعدة لإنشاء أنماط مخصصة =====

  /// إنشاء نمط نص مع لون مخصص
  static TextStyle withColor(TextStyle baseStyle, Color color) {
    return baseStyle.copyWith(color: color);
  }

  /// إنشاء نمط نص مع حجم مخصص
  static TextStyle withSize(TextStyle baseStyle, double fontSize) {
    return baseStyle.copyWith(fontSize: fontSize);
  }

  /// إنشاء نمط نص مع وزن مخصص
  static TextStyle withWeight(TextStyle baseStyle, FontWeight fontWeight) {
    return baseStyle.copyWith(fontWeight: fontWeight);
  }

  /// إنشاء نمط نص مع ظل مخصص - استخدام ThemeUtils
  static TextStyle withShadow(
    TextStyle baseStyle, 
    Color textColor, {
    bool hasShadow = true,
    double shadowOpacity = 0.3,
  }) {
    return ThemeUtils.getTextStyleWithShadow(
      baseStyle,
      textColor,
      withShadow: hasShadow,
      shadowOpacity: shadowOpacity,
    );
  }

  // ===== أنماط متجاوبة =====

  /// الحصول على حجم نص متجاوب
  static double getResponsiveFontSize(BuildContext context, double baseFontSize) {
    final deviceType = ThemeUtils.getDeviceType(context);
    
    switch (deviceType) {
      case ThemeDeviceType.mobile: // ✅ استخدام الاسم المُصحح
        return baseFontSize;
      case ThemeDeviceType.tablet: // ✅ استخدام الاسم المُصحح
        return baseFontSize * 1.1;
      case ThemeDeviceType.desktop: // ✅ استخدام الاسم المُصحح
        return baseFontSize * 1.2;
    }
  }

  /// نمط نص متجاوب
  static TextStyle responsive(
    BuildContext context, 
    TextStyle baseStyle,
  ) {
    final responsiveSize = getResponsiveFontSize(
      context, 
      baseStyle.fontSize ?? ThemeConstants.textSizeMd,
    );
    
    return baseStyle.copyWith(fontSize: responsiveSize);
  }
}