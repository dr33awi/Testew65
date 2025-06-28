// lib/app/themes/core/app_text_styles.dart - عربي فقط
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// نظام الخطوط الإسلامي العربي
class AppTextStyles {
  AppTextStyles._();
  
  // ========== الخطوط العربية ==========
  
  /// خط النص الأساسي العربي
  static const String primaryFontFamily = 'Tajawal';
  
  /// خط النصوص الدينية
  static const String secondaryFontFamily = 'Amiri Quran';
  
  /// خط الأرقام والعدادات
  static const String numbersFontFamily = 'Cairo';
  
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
  
  // ========== أحجام الخطوط المحسنة للعربية ==========
  
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
  
  // ========== ارتفاع الأسطر المحسن للعربية ==========
  
  static const double lineHeightTight = 1.2;    // للعناوين
  static const double lineHeightNormal = 1.5;   // للنصوص العادية
  static const double lineHeightRelaxed = 1.7;  // للنصوص الطويلة
  static const double lineHeightLoose = 2.0;    // للنصوص الدينية
  
  // ========== تباعد الأحرف المحسن للعربية ==========
  
  static const double letterSpacingTight = -0.3;
  static const double letterSpacingNormal = 0.0;
  static const double letterSpacingWide = 0.3;
  static const double letterSpacingWider = 0.6;
  
  // ========== العناوين الرئيسية ==========
  
  /// عنوان كبير جداً
  static const TextStyle displayLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size60,
    fontWeight: bold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: AppColors.textPrimary,
  );
  
  /// عنوان كبير
  static const TextStyle displayMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size48,
    fontWeight: bold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: AppColors.textPrimary,
  );
  
  /// عنوان متوسط
  static const TextStyle displaySmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size36,
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  // ========== العناوين الفرعية ==========
  
  /// عنوان رئيسي للشاشات
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size32,
    fontWeight: bold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// عنوان فرعي كبير
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size24,
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// عنوان فرعي صغير
  static const TextStyle headlineSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size20,
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  // ========== عناوين الأقسام ==========
  
  /// عنوان قسم كبير
  static const TextStyle titleLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size20,
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// عنوان قسم متوسط
  static const TextStyle titleMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size18,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// عنوان قسم صغير
  static const TextStyle titleSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size16,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  // ========== النصوص الأساسية ==========
  
  /// نص كبير
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size16,
    fontWeight: regular,
    height: lineHeightRelaxed,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// نص متوسط (النص الأساسي)
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size14,
    fontWeight: regular,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textPrimary,
  );
  
  /// نص صغير
  static const TextStyle bodySmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size12,
    fontWeight: regular,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textSecondary,
  );
  
  // ========== النصوص الإضافية ==========
  
  /// تسمية كبيرة
  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size14,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
    color: AppColors.textPrimary,
  );
  
  /// تسمية متوسطة
  static const TextStyle labelMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size12,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
    color: AppColors.textPrimary,
  );
  
  /// تسمية صغيرة
  static const TextStyle labelSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size10,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWider,
    color: AppColors.textSecondary,
  );
  
  // ========== النصوص التفسيرية ==========
  
  /// نص تفسيري
  static const TextStyle caption = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size12,
    fontWeight: regular,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textTertiary,
  );
  
  /// نص صغير جداً
  static const TextStyle overline = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size10,
    fontWeight: medium,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWider,
    color: AppColors.textTertiary,
  );
  
  // ========== النصوص الدينية المتخصصة ==========
  
  /// نص الآيات القرآنية
  static const TextStyle islamic = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: size18,
    fontWeight: regular,
    height: lineHeightLoose,
    letterSpacing: letterSpacingWide,
    color: AppColors.textReligious,
  );
  
  /// نص الأحاديث الشريفة
  static const TextStyle hadith = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size16,
    fontWeight: medium,
    height: lineHeightRelaxed,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textReligious,
    fontStyle: FontStyle.italic,
  );
  
  /// نص الأذكار
  static const TextStyle dhikr = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size16,
    fontWeight: medium,
    height: lineHeightRelaxed,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textReligious,
  );
  
  /// نص الأدعية
  static const TextStyle dua = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size16,
    fontWeight: medium,
    height: lineHeightRelaxed,
    letterSpacing: letterSpacingNormal,
    color: AppColors.textReligious,
  );
  
  /// نص للأرقام والأوقات
  static const TextStyle numbers = TextStyle(
    fontFamily: numbersFontFamily,
    fontSize: size20,
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.primary,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  
  /// نص للعدادات الكبيرة
  static const TextStyle counter = TextStyle(
    fontFamily: numbersFontFamily,
    fontSize: size36,
    fontWeight: bold,
    height: lineHeightTight,
    letterSpacing: letterSpacingTight,
    color: AppColors.primary,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  
  /// نص أوقات الصلاة
  static const TextStyle prayerTime = TextStyle(
    fontFamily: numbersFontFamily,
    fontSize: size24,
    fontWeight: bold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingNormal,
    color: AppColors.primary,
    fontFeatures: [FontFeature.tabularFigures()],
  );
  
  // ========== أنماط الأزرار ==========
  
  /// نص الأزرار الأساسية
  static const TextStyle button = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: size14,
    fontWeight: semiBold,
    height: lineHeightNormal,
    letterSpacing: letterSpacingWide,
    color: Colors.black,
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
    color: Colors.black,
  );
  
  // ========== دوال الإنشاء ==========
  
  /// إنشاء TextTheme
  static TextTheme get textTheme => const TextTheme(
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
  
  // ========== دوال مساعدة للنصوص العربية ==========
  
  /// الحصول على نمط النص المناسب للمحتوى الديني
  static TextStyle getReligiousTextStyle(String type) {
    switch (type) {
      case 'قران':
      case 'آية':
        return islamic;
      case 'حديث':
        return hadith;
      case 'ذكر':
      case 'اذكار':
        return dhikr;
      case 'دعاء':
        return dua;
      default:
        return bodyMedium;
    }
  }
  
  /// الحصول على نمط العداد المناسب
  static TextStyle getCounterStyle(int value) {
    if (value >= 1000) {
      return counter.copyWith(fontSize: size28);
    } else if (value >= 100) {
      return counter.copyWith(fontSize: size32);
    } else {
      return counter;
    }
  }
  
  /// نمط نص متجاوب حسب حجم الشاشة
  static TextStyle getResponsiveTextStyle(double screenWidth, TextStyle baseStyle) {
    double scaleFactor = 1.0;
    
    if (screenWidth < 360) {
      scaleFactor = 0.9; // شاشات صغيرة
    } else if (screenWidth > 600) {
      scaleFactor = 1.1; // شاشات كبيرة (تابلت)
    }
    
    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? size14) * scaleFactor,
    );
  }
}

/// Extension methods لأنماط النصوص
extension TextStyleExtensions on TextStyle {
  // ========== أوزان الخطوط ==========
  
  TextStyle get thin => copyWith(fontWeight: AppTextStyles.thin);
  TextStyle get light => copyWith(fontWeight: AppTextStyles.light);
  TextStyle get regular => copyWith(fontWeight: AppTextStyles.regular);
  TextStyle get medium => copyWith(fontWeight: AppTextStyles.medium);
  TextStyle get semiBold => copyWith(fontWeight: AppTextStyles.semiBold);
  TextStyle get bold => copyWith(fontWeight: AppTextStyles.bold);
  
  // ========== الألوان ==========
  
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
  
  // ========== التأثيرات ==========
  
  /// تطبيق الشفافية
  TextStyle withOpacity(double opacity) => 
      copyWith(color: color?.withValues(alpha: opacity));
  
  /// تطبيق الظلال
  TextStyle withShadow({
    Color shadowColor = Colors.black,
    double opacity = 0.3,
    Offset offset = const Offset(0, 1),
    double blurRadius = 2,
  }) => copyWith(
    shadows: [
      Shadow(
        color: shadowColor.withValues(alpha: opacity),
        offset: offset,
        blurRadius: blurRadius,
      ),
    ],
  );
  
  // ========== أنماط خاصة ==========
  
  /// تطبيق خط النصوص الإسلامية
  TextStyle get islamic => copyWith(
    fontFamily: AppTextStyles.secondaryFontFamily,
    height: AppTextStyles.lineHeightLoose,
    letterSpacing: AppTextStyles.letterSpacingWide,
  );
  
  /// تطبيق خط الأرقام
  TextStyle get numbers => copyWith(
    fontFamily: AppTextStyles.numbersFontFamily,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
  
  /// نمط للنصوص العربية
  TextStyle get arabic => copyWith(
    height: AppTextStyles.lineHeightRelaxed,
    letterSpacing: AppTextStyles.letterSpacingNormal,
  );
  
  /// نمط للعناوين المهمة
  TextStyle get important => copyWith(
    fontWeight: AppTextStyles.bold,
    color: AppColors.primary,
  );
}