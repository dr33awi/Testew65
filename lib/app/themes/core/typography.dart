// lib/app/themes/core/typography.dart
import 'package:flutter/material.dart';

/// نظام الخطوط الموحد للتطبيق الإسلامي
/// يدعم النصوص العربية والإنجليزية مع خطوط خاصة للقرآن والحديث
class AppTypography {
  AppTypography._();

  // ==================== عائلات الخطوط ====================
  
  static const String fontFamilyDefault = 'Cairo';     // الخط الأساسي
  static const String fontFamilyArabic = 'Amiri';      // النصوص العربية
  static const String fontFamilyQuran = 'Uthmanic';    // نصوص القرآن
  static const String fontFamilyEnglish = 'Roboto';    // النصوص الإنجليزية

  // ==================== مقياس أحجام الخطوط ====================
  
  /// مقياس متدرج للأحجام (Type Scale)
  static const double size10 = 10.0;    // xs
  static const double size12 = 12.0;    // sm  
  static const double size14 = 14.0;    // md (base)
  static const double size16 = 16.0;    // lg
  static const double size18 = 18.0;    // xl
  static const double size20 = 20.0;    // 2xl
  static const double size24 = 24.0;    // 3xl
  static const double size32 = 32.0;    // 4xl
  static const double size48 = 48.0;    // 5xl

  // ==================== أوزان الخطوط ====================
  
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // ==================== ارتفاع الأسطر ====================
  
  static const double lineHeightTight = 1.1;     // للعناوين الكبيرة
  static const double lineHeightNormal = 1.3;    // للعناوين
  static const double lineHeightRelaxed = 1.5;   // للنصوص العادية
  static const double lineHeightLoose = 1.8;     // للنصوص العربية
  static const double lineHeightQuran = 2.0;     // لآيات القرآن

  // ==================== أنماط النصوص الأساسية ====================
  
  /// عناوين Display (للصفحات الرئيسية)
  static TextStyle get displayLarge => const TextStyle(
    fontSize: size48,
    fontWeight: bold,
    height: lineHeightTight,
    letterSpacing: -0.5,
    fontFamily: fontFamilyDefault,
  );

  static TextStyle get displayMedium => const TextStyle(
    fontSize: size32,
    fontWeight: bold,
    height: lineHeightTight,
    fontFamily: fontFamilyDefault,
  );

  static TextStyle get displaySmall => const TextStyle(
    fontSize: size24,
    fontWeight: bold,
    height: lineHeightNormal,
    fontFamily: fontFamilyDefault,
  );

  /// عناوين Headlines (للأقسام)
  static TextStyle get headlineLarge => const TextStyle(
    fontSize: size24,
    fontWeight: bold,
    height: lineHeightNormal,
    fontFamily: fontFamilyDefault,
  );

  static TextStyle get headlineMedium => const TextStyle(
    fontSize: size20,
    fontWeight: semiBold,
    height: lineHeightNormal,
    fontFamily: fontFamilyDefault,
  );

  static TextStyle get headlineSmall => const TextStyle(
    fontSize: size18,
    fontWeight: semiBold,
    height: lineHeightNormal,
    fontFamily: fontFamilyDefault,
  );

  /// عناوين Titles (للبطاقات والمكونات)
  static TextStyle get titleLarge => const TextStyle(
    fontSize: size16,
    fontWeight: semiBold,
    height: lineHeightNormal,
    fontFamily: fontFamilyDefault,
  );

  static TextStyle get titleMedium => const TextStyle(
    fontSize: size14,
    fontWeight: medium,
    height: lineHeightNormal,
    fontFamily: fontFamilyDefault,
  );

  static TextStyle get titleSmall => const TextStyle(
    fontSize: size12,
    fontWeight: medium,
    height: lineHeightNormal,
    fontFamily: fontFamilyDefault,
  );

  /// نصوص Body (للمحتوى الأساسي)
  static TextStyle get bodyLarge => const TextStyle(
    fontSize: size16,
    fontWeight: regular,
    height: lineHeightRelaxed,
    fontFamily: fontFamilyDefault,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontSize: size14,
    fontWeight: regular,
    height: lineHeightRelaxed,
    fontFamily: fontFamilyDefault,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontSize: size12,
    fontWeight: regular,
    height: lineHeightRelaxed,
    fontFamily: fontFamilyDefault,
  );

  /// نصوص Labels (للأزرار والتسميات)
  static TextStyle get labelLarge => const TextStyle(
    fontSize: size14,
    fontWeight: medium,
    height: lineHeightNormal,
    fontFamily: fontFamilyDefault,
  );

  static TextStyle get labelMedium => const TextStyle(
    fontSize: size12,
    fontWeight: medium,
    height: lineHeightNormal,
    fontFamily: fontFamilyDefault,
  );

  static TextStyle get labelSmall => const TextStyle(
    fontSize: size10,
    fontWeight: medium,
    height: lineHeightNormal,
    fontFamily: fontFamilyDefault,
  );

  // ==================== أنماط النصوص العربية ====================
  
  /// عناوين عربية
  static TextStyle get arabicDisplayLarge => displayLarge.copyWith(
    fontFamily: fontFamilyArabic,
    height: lineHeightLoose,
  );

  static TextStyle get arabicHeadlineLarge => headlineLarge.copyWith(
    fontFamily: fontFamilyArabic,
    height: lineHeightLoose,
  );

  static TextStyle get arabicTitleLarge => titleLarge.copyWith(
    fontFamily: fontFamilyArabic,
    height: lineHeightLoose,
  );

  static TextStyle get arabicBodyLarge => bodyLarge.copyWith(
    fontFamily: fontFamilyArabic,
    height: lineHeightLoose,
  );

  // ==================== أنماط النصوص الدينية ====================
  
  /// نص القرآن الكريم
  static TextStyle get quranText => const TextStyle(
    fontSize: size18,
    fontWeight: regular,
    height: lineHeightQuran,
    fontFamily: fontFamilyQuran,
    letterSpacing: 0.5,
  );

  static TextStyle get quranTextLarge => quranText.copyWith(
    fontSize: size20,
  );

  static TextStyle get quranTextSmall => quranText.copyWith(
    fontSize: size16,
  );

  /// نص الحديث الشريف
  static TextStyle get hadithText => const TextStyle(
    fontSize: size16,
    fontWeight: regular,
    height: lineHeightLoose,
    fontFamily: fontFamilyArabic,
    letterSpacing: 0.3,
  );

  static TextStyle get hadithTextLarge => hadithText.copyWith(
    fontSize: size18,
  );

  /// نص الدعاء
  static TextStyle get duaText => const TextStyle(
    fontSize: size16,
    fontWeight: medium,
    height: lineHeightLoose,
    fontFamily: fontFamilyArabic,
    letterSpacing: 0.2,
  );

  static TextStyle get duaTextLarge => duaText.copyWith(
    fontSize: size18,
    fontWeight: semiBold,
  );

  /// أسماء الصلوات
  static TextStyle get prayerNameText => const TextStyle(
    fontSize: size16,
    fontWeight: semiBold,
    height: lineHeightNormal,
    fontFamily: fontFamilyArabic,
  );

  /// أوقات الصلوات
  static TextStyle get prayerTimeText => const TextStyle(
    fontSize: size14,
    fontWeight: medium,
    height: lineHeightNormal,
    fontFamily: fontFamilyDefault,
  );

  // ==================== أنماط خاصة بالمكونات ====================
  
  /// نص الأزرار
  static TextStyle get buttonText => const TextStyle(
    fontSize: size14,
    fontWeight: semiBold,
    height: lineHeightNormal,
    fontFamily: fontFamilyDefault,
  );

  static TextStyle get buttonTextLarge => buttonText.copyWith(
    fontSize: size16,
  );

  static TextStyle get buttonTextSmall => buttonText.copyWith(
    fontSize: size12,
  );

  /// نص التلميحات
  static TextStyle get hintText => const TextStyle(
    fontSize: size14,
    fontWeight: regular,
    height: lineHeightNormal,
    fontFamily: fontFamilyDefault,
  );

  /// نص الحقول
  static TextStyle get inputText => const TextStyle(
    fontSize: size14,
    fontWeight: regular,
    height: lineHeightNormal,
    fontFamily: fontFamilyDefault,
  );

  /// نص التسميات
  static TextStyle get labelText => const TextStyle(
    fontSize: size12,
    fontWeight: medium,
    height: lineHeightNormal,
    fontFamily: fontFamilyDefault,
  );

  /// نص الأخطاء
  static TextStyle get errorText => const TextStyle(
    fontSize: size12,
    fontWeight: regular,
    height: lineHeightNormal,
    fontFamily: fontFamilyDefault,
  );

  // ==================== TextTheme للثيمات ====================
  
  /// إنشاء TextTheme للوضع الفاتح
  static TextTheme buildLightTextTheme(Color primaryTextColor, Color secondaryTextColor) {
    return TextTheme(
      // Display styles
      displayLarge: displayLarge.copyWith(color: primaryTextColor),
      displayMedium: displayMedium.copyWith(color: primaryTextColor),
      displaySmall: displaySmall.copyWith(color: primaryTextColor),
      
      // Headline styles
      headlineLarge: headlineLarge.copyWith(color: primaryTextColor),
      headlineMedium: headlineMedium.copyWith(color: primaryTextColor),
      headlineSmall: headlineSmall.copyWith(color: primaryTextColor),
      
      // Title styles
      titleLarge: titleLarge.copyWith(color: primaryTextColor),
      titleMedium: titleMedium.copyWith(color: primaryTextColor),
      titleSmall: titleSmall.copyWith(color: primaryTextColor),
      
      // Body styles
      bodyLarge: bodyLarge.copyWith(color: primaryTextColor),
      bodyMedium: bodyMedium.copyWith(color: primaryTextColor),
      bodySmall: bodySmall.copyWith(color: secondaryTextColor),
      
      // Label styles
      labelLarge: labelLarge.copyWith(color: primaryTextColor),
      labelMedium: labelMedium.copyWith(color: secondaryTextColor),
      labelSmall: labelSmall.copyWith(color: secondaryTextColor),
    );
  }

  /// إنشاء TextTheme للوضع الداكن
  static TextTheme buildDarkTextTheme(Color primaryTextColor, Color secondaryTextColor) {
    return buildLightTextTheme(primaryTextColor, secondaryTextColor);
  }

  // ==================== مساعدات للتخصيص ====================
  
  /// تطبيق لون على أي نمط نص
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// تطبيق حجم على أي نمط نص
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  /// تطبيق وزن على أي نمط نص
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// تطبيق عائلة خط على أي نمط نص
  static TextStyle withFamily(TextStyle style, String fontFamily) {
    return style.copyWith(fontFamily: fontFamily);
  }
}

/// Extension لتسهيل تعديل أنماط النصوص
extension TextStyleExtensions on TextStyle {
  /// تطبيق أوزان مختلفة
  TextStyle get light => copyWith(fontWeight: AppTypography.light);
  TextStyle get regular => copyWith(fontWeight: AppTypography.regular);
  TextStyle get medium => copyWith(fontWeight: AppTypography.medium);
  TextStyle get semiBold => copyWith(fontWeight: AppTypography.semiBold);
  TextStyle get bold => copyWith(fontWeight: AppTypography.bold);
  TextStyle get extraBold => copyWith(fontWeight: AppTypography.extraBold);

  /// تطبيق ألوان
  TextStyle withColor(Color color) => copyWith(color: color);
  
  /// تطبيق أحجام
  TextStyle withSize(double size) => copyWith(fontSize: size);
  
  /// تطبيق عائلة خط
  TextStyle arabic() => copyWith(fontFamily: AppTypography.fontFamilyArabic);
  TextStyle quran() => copyWith(fontFamily: AppTypography.fontFamilyQuran);
  TextStyle english() => copyWith(fontFamily: AppTypography.fontFamilyEnglish);
  
  /// تطبيق ارتفاع سطر
  TextStyle withHeight(double height) => copyWith(height: height);
  
  /// تطبيق تباعد الأحرف
  TextStyle withLetterSpacing(double spacing) => copyWith(letterSpacing: spacing);
}