// lib/app/themes/text_styles.dart
import 'package:flutter/material.dart';
import 'theme_constants.dart';

/// أنماط النصوص الموحدة للتطبيق - نظام تايبوغرافي حديث
class AppTextStyles {
  AppTextStyles._();

  // ===== Display Styles - عناوين كبيرة =====
  static const TextStyle display1 = TextStyle(
    fontSize: ThemeConstants.textSize7xl,
    fontWeight: ThemeConstants.black,
    height: 1.1,
    letterSpacing: -0.02,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle display2 = TextStyle(
    fontSize: ThemeConstants.textSize6xl,
    fontWeight: ThemeConstants.extraBold,
    height: 1.15,
    letterSpacing: -0.02,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle display3 = TextStyle(
    fontSize: ThemeConstants.textSize5xl,
    fontWeight: ThemeConstants.bold,
    height: 1.2,
    letterSpacing: -0.01,
    fontFamily: ThemeConstants.fontFamily,
  );

  // ===== Headline Styles - عناوين رئيسية =====
  static const TextStyle h1 = TextStyle(
    fontSize: ThemeConstants.textSize4xl,
    fontWeight: ThemeConstants.bold,
    height: 1.25,
    letterSpacing: -0.01,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: ThemeConstants.textSize3xl,
    fontWeight: ThemeConstants.semiBold,
    height: 1.3,
    letterSpacing: -0.005,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: ThemeConstants.textSize2xl,
    fontWeight: ThemeConstants.semiBold,
    height: 1.35,
    letterSpacing: 0,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: ThemeConstants.textSizeXl,
    fontWeight: ThemeConstants.semiBold,
    height: 1.4,
    letterSpacing: 0,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.medium,
    height: 1.45,
    letterSpacing: 0,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle h6 = TextStyle(
    fontSize: ThemeConstants.textSizeMd,
    fontWeight: ThemeConstants.medium,
    height: 1.5,
    letterSpacing: 0,
    fontFamily: ThemeConstants.fontFamily,
  );

  // ===== Body Styles - نصوص أساسية =====
  static const TextStyle body1 = TextStyle(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.regular,
    height: 1.6,
    letterSpacing: 0,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: ThemeConstants.textSizeMd,
    fontWeight: ThemeConstants.regular,
    height: 1.6,
    letterSpacing: 0,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle body3 = TextStyle(
    fontSize: ThemeConstants.textSizeSm,
    fontWeight: ThemeConstants.regular,
    height: 1.5,
    letterSpacing: 0,
    fontFamily: ThemeConstants.fontFamily,
  );

  // ===== Label Styles - تسميات =====
  static const TextStyle label1 = TextStyle(
    fontSize: ThemeConstants.textSizeMd,
    fontWeight: ThemeConstants.medium,
    height: 1.4,
    letterSpacing: 0.02,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle label2 = TextStyle(
    fontSize: ThemeConstants.textSizeSm,
    fontWeight: ThemeConstants.medium,
    height: 1.4,
    letterSpacing: 0.02,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle label3 = TextStyle(
    fontSize: ThemeConstants.textSizeXs,
    fontWeight: ThemeConstants.medium,
    height: 1.3,
    letterSpacing: 0.02,
    fontFamily: ThemeConstants.fontFamily,
  );

  // ===== Caption Styles - ملاحظات صغيرة =====
  static const TextStyle caption = TextStyle(
    fontSize: ThemeConstants.textSizeXs,
    fontWeight: ThemeConstants.regular,
    height: 1.4,
    letterSpacing: 0.01,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle overline = TextStyle(
    fontSize: ThemeConstants.textSizeXs,
    fontWeight: ThemeConstants.medium,
    height: 1.3,
    letterSpacing: 0.08,
    fontFamily: ThemeConstants.fontFamily,
  );

  // ===== Button Styles - أزرار =====
  static const TextStyle button = TextStyle(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.semiBold,
    height: 1.2,
    letterSpacing: 0.02,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: ThemeConstants.textSizeMd,
    fontWeight: ThemeConstants.semiBold,
    height: 1.2,
    letterSpacing: 0.02,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontSize: ThemeConstants.textSizeXl,
    fontWeight: ThemeConstants.semiBold,
    height: 1.2,
    letterSpacing: 0.02,
    fontFamily: ThemeConstants.fontFamily,
  );

  // ===== Special Styles - أنماط خاصة =====
  
  // القرآن الكريم
  static const TextStyle quran = TextStyle(
    fontSize: 24,
    fontWeight: ThemeConstants.regular,
    height: 2.2,
    letterSpacing: 0,
    fontFamily: ThemeConstants.fontFamilyQuran,
  );

  static const TextStyle quranLarge = TextStyle(
    fontSize: 28,
    fontWeight: ThemeConstants.regular,
    height: 2.4,
    letterSpacing: 0,
    fontFamily: ThemeConstants.fontFamilyQuran,
  );

  // الأذكار
  static const TextStyle athkar = TextStyle(
    fontSize: ThemeConstants.textSizeXl,
    fontWeight: ThemeConstants.regular,
    height: 1.9,
    letterSpacing: 0,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle athkarLarge = TextStyle(
    fontSize: ThemeConstants.textSize2xl,
    fontWeight: ThemeConstants.regular,
    height: 2.0,
    letterSpacing: 0,
    fontFamily: ThemeConstants.fontFamily,
  );

  // الأدعية
  static const TextStyle dua = TextStyle(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.regular,
    height: 1.8,
    letterSpacing: 0,
    fontFamily: ThemeConstants.fontFamily,
  );

  // أرقام كبيرة
  static const TextStyle numberLarge = TextStyle(
    fontSize: ThemeConstants.textSize6xl,
    fontWeight: ThemeConstants.bold,
    height: 1.0,
    letterSpacing: -0.02,
    fontFamily: ThemeConstants.fontFamilyEnglish,
  );

  static const TextStyle numberMedium = TextStyle(
    fontSize: ThemeConstants.textSize3xl,
    fontWeight: ThemeConstants.semiBold,
    height: 1.0,
    letterSpacing: -0.01,
    fontFamily: ThemeConstants.fontFamilyEnglish,
  );

  static const TextStyle numberSmall = TextStyle(
    fontSize: ThemeConstants.textSizeXl,
    fontWeight: ThemeConstants.medium,
    height: 1.0,
    letterSpacing: 0,
    fontFamily: ThemeConstants.fontFamilyEnglish,
  );

  // ===== إنشاء TextTheme للتطبيق =====
  static TextTheme createTextTheme({
    required Color color,
    Color? secondaryColor,
  }) {
    final Color effectiveSecondaryColor = secondaryColor ?? color.withValues(alpha: 0.7);
    
    return TextTheme(
      // Display styles
      displayLarge: display1.copyWith(color: color),
      displayMedium: display2.copyWith(color: color),
      displaySmall: display3.copyWith(color: color),
      
      // Headline styles
      headlineLarge: h1.copyWith(color: color),
      headlineMedium: h2.copyWith(color: color),
      headlineSmall: h3.copyWith(color: color),
      
      // Title styles
      titleLarge: h4.copyWith(color: color),
      titleMedium: h5.copyWith(color: color),
      titleSmall: h6.copyWith(color: color),
      
      // Body styles
      bodyLarge: body1.copyWith(color: color),
      bodyMedium: body2.copyWith(color: effectiveSecondaryColor),
      bodySmall: body3.copyWith(color: effectiveSecondaryColor),
      
      // Label styles
      labelLarge: label1.copyWith(color: color),
      labelMedium: label2.copyWith(color: effectiveSecondaryColor),
      labelSmall: label3.copyWith(color: effectiveSecondaryColor),
    );
  }

  // ===== دوال مساعدة للأنماط الديناميكية =====
  
  /// نص ديناميكي مع حجم مخصص
  static TextStyle dynamicText({
    required double fontSize,
    FontWeight? fontWeight,
    double? height,
    double? letterSpacing,
    String? fontFamily,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight ?? ThemeConstants.regular,
      height: height ?? 1.5,
      letterSpacing: letterSpacing ?? 0,
      fontFamily: fontFamily ?? ThemeConstants.fontFamily,
    );
  }

  /// نص متجاوب حسب حجم الشاشة
  static TextStyle responsive(
    BuildContext context,
    TextStyle baseStyle, {
    double? mobileFactor = 1.0,
    double? tabletFactor = 1.1,
    double? desktopFactor = 1.2,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    double factor = mobileFactor!;

    if (screenWidth >= ThemeConstants.breakpointDesktop) {
      factor = desktopFactor!;
    } else if (screenWidth >= ThemeConstants.breakpointTablet) {
      factor = tabletFactor!;
    }

    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 14) * factor,
    );
  }

  // ===== أنماط مخصصة حسب السياق =====
  
  /// نص للعناوين الرئيسية في الصفحات
  static TextStyle pageTitle(BuildContext context) {
    return h2.copyWith(
      color: ThemeConstants.textPrimary(context),
    );
  }

  /// نص للعناوين الفرعية
  static TextStyle sectionTitle(BuildContext context) {
    return h4.copyWith(
      color: ThemeConstants.textPrimary(context),
    );
  }

  /// نص للبطاقات
  static TextStyle cardTitle(BuildContext context) {
    return h5.copyWith(
      color: ThemeConstants.textPrimary(context),
    );
  }

  /// نص للمحتوى الرئيسي
  static TextStyle contentText(BuildContext context) {
    return body1.copyWith(
      color: ThemeConstants.textPrimary(context),
    );
  }

  /// نص للمعلومات الثانوية
  static TextStyle secondaryText(BuildContext context) {
    return body2.copyWith(
      color: ThemeConstants.textSecondary(context),
    );
  }

  /// نص للتلميحات
  static TextStyle hintText(BuildContext context) {
    return caption.copyWith(
      color: ThemeConstants.textHint(context),
    );
  }

  /// نص للأخطاء
  static TextStyle errorText(BuildContext context) {
    return caption.copyWith(
      color: ThemeConstants.error,
    );
  }

  /// نص للنجاح
  static TextStyle successText(BuildContext context) {
    return body2.copyWith(
      color: ThemeConstants.success,
      fontWeight: ThemeConstants.medium,
    );
  }

  /// نص للتحذيرات
  static TextStyle warningText(BuildContext context) {
    return body2.copyWith(
      color: ThemeConstants.warning,
      fontWeight: ThemeConstants.medium,
    );
  }

  /// نص للمعلومات
  static TextStyle infoText(BuildContext context) {
    return body2.copyWith(
      color: ThemeConstants.info,
    );
  }

  /// نص للروابط
  static TextStyle linkText(BuildContext context) {
    return body2.copyWith(
      color: ThemeConstants.primary,
      decoration: TextDecoration.underline,
      decorationColor: ThemeConstants.primary,
    );
  }

  /// نص للأسعار والعملات
  static TextStyle priceText(BuildContext context, {bool isLarge = false}) {
    return (isLarge ? numberLarge : numberMedium).copyWith(
      color: ThemeConstants.textPrimary(context),
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }

  /// نص للإحصائيات
  static TextStyle statText(BuildContext context, {bool isLarge = false}) {
    return (isLarge ? numberMedium : numberSmall).copyWith(
      color: ThemeConstants.primary,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }
}