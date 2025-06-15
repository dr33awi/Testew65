// lib/app/themes/text_styles.dart
import 'package:athkar_app/app/themes/theme_constants.dart';
import 'package:flutter/material.dart';

/// أنماط النصوص الموحدة للتطبيق
class AppTextStyles {
  AppTextStyles._();

  // ===== أنماط العناوين =====
  static const TextStyle h1 = TextStyle(
    fontSize: ThemeConstants.textSize4xl,
    fontWeight: ThemeConstants.bold,
    height: 1.3,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: ThemeConstants.textSize3xl,
    fontWeight: ThemeConstants.semiBold,
    height: 1.3,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: ThemeConstants.textSize2xl,
    fontWeight: ThemeConstants.semiBold,
    height: 1.4,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: ThemeConstants.textSizeXl,
    fontWeight: ThemeConstants.semiBold,
    height: 1.4,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.semiBold,
    height: 1.5,
    fontFamily: ThemeConstants.fontFamily,
  );

  // ===== أنماط النص الأساسي =====
  static const TextStyle body1 = TextStyle(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.regular,
    height: 1.6,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: ThemeConstants.textSizeMd,
    fontWeight: ThemeConstants.regular,
    height: 1.6,
    fontFamily: ThemeConstants.fontFamily,
  );

  // ===== أنماط التسميات =====
  static const TextStyle label1 = TextStyle(
    fontSize: ThemeConstants.textSizeMd,
    fontWeight: ThemeConstants.medium,
    height: 1.4,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle label2 = TextStyle(
    fontSize: ThemeConstants.textSizeSm,
    fontWeight: ThemeConstants.medium,
    height: 1.4,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle caption = TextStyle(
    fontSize: ThemeConstants.textSizeXs,
    fontWeight: ThemeConstants.regular,
    height: 1.4,
    fontFamily: ThemeConstants.fontFamily,
  );

  // ===== أنماط الأزرار =====
  static const TextStyle button = TextStyle(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.semiBold,
    height: 1.2,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: ThemeConstants.textSizeMd,
    fontWeight: ThemeConstants.semiBold,
    height: 1.2,
    fontFamily: ThemeConstants.fontFamily,
  );

  // ===== أنماط خاصة بالمحتوى الإسلامي =====
  static const TextStyle quran = TextStyle(
    fontSize: 22,
    fontWeight: ThemeConstants.regular,
    height: 2.0,
    fontFamily: ThemeConstants.fontFamilyQuran,
  );

  static const TextStyle athkar = TextStyle(
    fontSize: ThemeConstants.textSizeXl,
    fontWeight: ThemeConstants.regular,
    height: 1.8,
    fontFamily: ThemeConstants.fontFamily,
  );

  static const TextStyle dua = TextStyle(
    fontSize: ThemeConstants.textSizeLg,
    fontWeight: ThemeConstants.regular,
    height: 1.7,
    fontFamily: ThemeConstants.fontFamily,
  );

  // ===== إنشاء TextTheme للتطبيق =====
static TextTheme createTextTheme({
    required Color color,
    Color? secondaryColor,
  }) {
    final Color effectiveSecondaryColor = secondaryColor ?? color.withValues(alpha: 0.7);
    
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
      color: ThemeConstants.textSecondary(context).withValues(alpha: 0.7),
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
    );
  }
}