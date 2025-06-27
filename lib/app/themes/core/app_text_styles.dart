// lib/app/themes/core/app_text_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// نظام الخطوط وأنماط النصوص الموحد
class AppTextStyles {
  AppTextStyles._();
  
  // ========== الخطوط ==========
  
  /// خط النص الأساسي (العربي والإنجليزي)
  static const String primaryFontFamily = 'Cairo';
  
  /// خط النص الثانوي (للنصوص المميزة)
  static const String secondaryFontFamily = 'Amiri';
  
  /// خط الأرقام (للعدادات والأوقات)
  static const String numbersFontFamily = 'Roboto';
  
  // ========== أوزان الخطوط ==========
  
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;
  
  // ========== أحجام الخطوط ==========
  
  static const double size10 = 10.0;
  static const double size12 = 12.0;
  static const double size14 = 14.0;
  static const double size16 = 16.0;
  static const double size18 = 18.0;
  static const double size20 = 20.0;
  static const double size24 = 24.0;
  static const double size28 = 28.0;
  static const double size32 = 32.0;
  static const double size36 = 36.0;
  static const double size48 = 48.0;
  static const double size60 = 60.0;
  static const double size72 = 72.0;
  
  // ========== ارتفاع الأسطر ==========
  
  static const double lineHeightTight = 1.1;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.6;
  static const double lineHeightLoose = 1.8;
  
  // ========== تباعد الأحرف ==========
  
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.5;
  static const double letterSpacingWider = 1.0;
  
  // ========== العناوين الرئيسية ==========
  
  /// عنوان كبير جداً (للصفحات الرئيسية)
  static const TextStyle displayLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size72,
    fontWeight: bold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: AppColors.textPrimary,
  );
  
  /// عنوان كبير (للعدادات)
  static const TextStyle displayMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size60,
    fontWeight: bold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: AppColors.textPrimary,
  );
  
  /// عنوان متوسط (للإحصائيات)
  static const TextStyle displaySmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size48,
    fontWeight: semiBold,
    height: lineHeightTight,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  // ========== العناوين الفرعية ==========
  
  /// عنوان رئيسي للشاشات
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size36,
    fontWeight: bold,
    height: lineHeightTight,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// عنوان فرعي كبير
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size32,
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// عنوان فرعي صغير
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size28,
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  // ========== عناوين الأقسام ==========
  
  /// عنوان قسم كبير
  static const TextStyle titleLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size24,
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// عنوان قسم متوسط
  static const TextStyle titleMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size20,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// عنوان قسم صغير
  static const TextStyle titleSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size18,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  // ========== النصوص الأساسية ==========
  
  /// نص كبير (للمحتوى المهم)
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size18,
    fontWeight: regular,
    height: lineHeightRelaxed,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// نص متوسط (النص الأساسي)
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size16,
    fontWeight: regular,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// نص صغير (للتفاصيل)
  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size14,
    fontWeight: regular,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textSecondary,
  );
  
  // ========== النصوص الإضافية ==========
  
  /// تسمية كبيرة (للأزرار الكبيرة)
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size16,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
    color: AppColors.textPrimary,
  );
  
  /// تسمية متوسطة (للأزرار العادية)
  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size14,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
    color: AppColors.textPrimary,
  );
  
  /// تسمية صغيرة (للأزرار الصغيرة)
  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size12,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWider,
    color: AppColors.textSecondary,
  );
  
  // ========== النصوص التفسيرية ==========
  
  /// نص تفسيري (للملاحظات والهوامش)
  static const TextStyle caption = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size12,
    fontWeight: regular,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textTertiary,
  );
  
  /// نص صغير جداً (للحواشي)
  static const TextStyle overline = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size10,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWider,
    color: AppColors.textTertiary,
  );
  
  // ========== النصوص المخصصة ==========
  
  /// نص الآيات والأحاديث
  static const TextStyle islamic = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: size20,
    fontWeight: regular,
    height: lineHeightLoose,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// نص للأرقام والأوقات
  static const TextStyle numbers = TextStyle(
    fontFamily: numbersFontFamily,
    fontSize: size24,
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  
  /// نص للعدادات الكبيرة
  static const TextStyle counter = TextStyle(
    fontFamily: numbersFontFamily,
    fontSize: size48,
    fontWeight: bold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: AppColors.primary,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  
  // ========== أنماط الأزرار ==========
  
  /// نص الأزرار الأساسية
  static const TextStyle button = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size16,
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
    color: Colors.white,
  );
  
  /// نص الأزرار الثانوية
  static const TextStyle buttonSecondary = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size14,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
    color: AppColors.primary,
  );
  
  /// نص الأزرار الصغيرة
  static const TextStyle buttonSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size12,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWider,
    color: Colors.white,
  );
  
  // ========== دوال الإنشاء ==========
  
  /// إنشاء TextTheme للوضع الفاتح
  static TextTheme get lightTextTheme => const TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
  
  /// إنشاء TextTheme للوضع الداكن
  static TextTheme get darkTextTheme => lightTextTheme.copyWith(
    displayLarge: displayLarge.copyWith(color: AppColors.textPrimaryDark),
    displayMedium: displayMedium.copyWith(color: AppColors.textPrimaryDark),
    displaySmall: displaySmall.copyWith(color: AppColors.textPrimaryDark),
    headlineLarge: headlineLarge.copyWith(color: AppColors.textPrimaryDark),
    headlineMedium: headlineMedium.copyWith(color: AppColors.textPrimaryDark),
    headlineSmall: headlineSmall.copyWith(color: AppColors.textPrimaryDark),
    titleLarge: titleLarge.copyWith(color: AppColors.textPrimaryDark),
    titleMedium: titleMedium.copyWith(color: AppColors.textPrimaryDark),
    titleSmall: titleSmall.copyWith(color: AppColors.textPrimaryDark),
    bodyLarge: bodyLarge.copyWith(color: AppColors.textPrimaryDark),
    bodyMedium: bodyMedium.copyWith(color: AppColors.textPrimaryDark),
    bodySmall: bodySmall.copyWith(color: AppColors.textSecondaryDark),
    labelLarge: labelLarge.copyWith(color: AppColors.textPrimaryDark),
    labelMedium: labelMedium.copyWith(color: AppColors.textPrimaryDark),
    labelSmall: labelSmall.copyWith(color: AppColors.textSecondaryDark),
  );
}

/// Extension methods لأنماط النصوص
extension TextStyleExtensions on TextStyle {
  /// تطبيق وزن الخط
  TextStyle get thin => copyWith(fontWeight: AppTextStyles.thin);
  TextStyle get extraLight => copyWith(fontWeight: AppTextStyles.extraLight);
  TextStyle get light => copyWith(fontWeight: AppTextStyles.light);
  TextStyle get regular => copyWith(fontWeight: AppTextStyles.regular);
  TextStyle get medium => copyWith(fontWeight: AppTextStyles.medium);
  TextStyle get semiBold => copyWith(fontWeight: AppTextStyles.semiBold);
  TextStyle get bold => copyWith(fontWeight: AppTextStyles.bold);
  TextStyle get extraBold => copyWith(fontWeight: AppTextStyles.extraBold);
  TextStyle get black => copyWith(fontWeight: AppTextStyles.black);
  
  /// تطبيق الألوان
  TextStyle primary([Color? color]) => 
      copyWith(color: color ?? AppColors.primary);
  TextStyle secondary([Color? color]) => 
      copyWith(color: color ?? AppColors.secondary);
  TextStyle success([Color? color]) => 
      copyWith(color: color ?? AppColors.success);
  TextStyle warning([Color? color]) => 
      copyWith(color: color ?? AppColors.warning);
  TextStyle error([Color? color]) => 
      copyWith(color: color ?? AppColors.error);
  TextStyle info([Color? color]) => 
      copyWith(color: color ?? AppColors.info);
  
  /// تطبيق الشفافية
  TextStyle withOpacity(double opacity) => 
      copyWith(color: color?.withValues(alpha: opacity));
  
  /// تطبيق الظلال
  TextStyle withShadow({
    Color color = Colors.black,
    double opacity = 0.3,
    Offset offset = const Offset(0, 2),
    double blurRadius = 4,
  }) => copyWith(
    shadows: [
      Shadow(
        color: color.withValues(alpha: opacity),
        offset: offset,
        blurRadius: blurRadius,
      ),
    ],
  );
  
  /// تطبيق خط النصوص الإسلامية
  TextStyle get islamic => copyWith(
    fontFamily: AppTextStyles.secondaryFontFamily,
    height: AppTextStyles.lineHeightLoose,
  );
  
  /// تطبيق خط الأرقام
  TextStyle get numbers => copyWith(
    fontFamily: AppTextStyles.numbersFontFamily,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}