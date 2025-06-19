// lib/app/themes/simple/typography.dart
import 'package:flutter/material.dart';

/// نظام الخطوط المبسط للتطبيق الإسلامي
class AppTypography {
  AppTypography._();

  // ==================== عائلات الخطوط ====================
  
  static const String primaryFont = 'Cairo';      // الخط الأساسي
  static const String arabicFont = 'Amiri';       // النصوص العربية الطويلة
  static const String quranFont = 'Uthmanic';     // آيات القرآن
  
  // ==================== الأحجام ====================
  
  static const double sizeSmall = 12.0;
  static const double sizeMedium = 14.0;
  static const double sizeLarge = 16.0;
  static const double sizeXLarge = 18.0;
  static const double sizeXXLarge = 20.0;
  static const double sizeTitle = 24.0;
  static const double sizeHeading = 28.0;
  
  // ==================== الأوزان ====================
  
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  
  // ==================== النصوص العامة ====================
  
  static const TextStyle heading = TextStyle(
    fontSize: sizeHeading,
    fontWeight: bold,
    fontFamily: primaryFont,
    height: 1.3,
  );
  
  static const TextStyle title = TextStyle(
    fontSize: sizeTitle,
    fontWeight: semiBold,
    fontFamily: primaryFont,
    height: 1.4,
  );
  
  static const TextStyle subtitle = TextStyle(
    fontSize: sizeXLarge,
    fontWeight: medium,
    fontFamily: primaryFont,
    height: 1.4,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: sizeMedium,
    fontWeight: regular,
    fontFamily: primaryFont,
    height: 1.5,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: sizeLarge,
    fontWeight: regular,
    fontFamily: primaryFont,
    height: 1.5,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: sizeSmall,
    fontWeight: regular,
    fontFamily: primaryFont,
    height: 1.4,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: sizeMedium,
    fontWeight: semiBold,
    fontFamily: primaryFont,
    height: 1.2,
  );
  
  // ==================== النصوص الإسلامية ====================
  
  /// نص القرآن الكريم
  static const TextStyle quran = TextStyle(
    fontSize: sizeXLarge,
    fontWeight: regular,
    fontFamily: quranFont,
    height: 2.0,
    letterSpacing: 0.5,
  );
  
  static const TextStyle quranLarge = TextStyle(
    fontSize: sizeXXLarge,
    fontWeight: regular,
    fontFamily: quranFont,
    height: 2.2,
    letterSpacing: 0.8,
  );
  
  /// نص الحديث الشريف
  static const TextStyle hadith = TextStyle(
    fontSize: sizeLarge,
    fontWeight: regular,
    fontFamily: arabicFont,
    height: 1.8,
    letterSpacing: 0.3,
  );
  
  /// نص الدعاء
  static const TextStyle dua = TextStyle(
    fontSize: sizeLarge,
    fontWeight: medium,
    fontFamily: arabicFont,
    height: 1.7,
    letterSpacing: 0.2,
  );
  
  /// نص التسبيح
  static const TextStyle tasbih = TextStyle(
    fontSize: sizeXLarge,
    fontWeight: semiBold,
    fontFamily: arabicFont,
    height: 1.5,
  );
  
  /// أسماء الصلوات
  static const TextStyle prayerName = TextStyle(
    fontSize: sizeLarge,
    fontWeight: semiBold,
    fontFamily: primaryFont,
    height: 1.3,
  );
  
  /// أوقات الصلوات
  static const TextStyle prayerTime = TextStyle(
    fontSize: sizeMedium,
    fontWeight: medium,
    fontFamily: primaryFont,
    height: 1.2,
  );
  
  // ==================== إنشاء TextTheme ====================
  
  static TextTheme createTextTheme(Color textColor, Color secondaryTextColor) {
    return TextTheme(
      headlineLarge: heading.copyWith(color: textColor),
      headlineMedium: title.copyWith(color: textColor),
      headlineSmall: subtitle.copyWith(color: textColor),
      
      titleLarge: title.copyWith(color: textColor),
      titleMedium: subtitle.copyWith(color: textColor),
      titleSmall: bodyLarge.copyWith(color: textColor, fontWeight: medium),
      
      bodyLarge: bodyLarge.copyWith(color: textColor),
      bodyMedium: body.copyWith(color: textColor),
      bodySmall: caption.copyWith(color: secondaryTextColor),
      
      labelLarge: button.copyWith(color: textColor),
      labelMedium: caption.copyWith(color: secondaryTextColor, fontWeight: medium),
      labelSmall: caption.copyWith(color: secondaryTextColor),
    );
  }
}

// ==================== Extensions للسهولة ====================

extension TextStyleExtensions on TextStyle {
  // الأوزان
  TextStyle get light => copyWith(fontWeight: AppTypography.light);
  TextStyle get regular => copyWith(fontWeight: AppTypography.regular);
  TextStyle get medium => copyWith(fontWeight: AppTypography.medium);
  TextStyle get semiBold => copyWith(fontWeight: AppTypography.semiBold);
  TextStyle get bold => copyWith(fontWeight: AppTypography.bold);
  
  // الألوان
  TextStyle withColor(Color color) => copyWith(color: color);
  
  // الخطوط
  TextStyle get arabic => copyWith(fontFamily: AppTypography.arabicFont);
  TextStyle get quranFont => copyWith(fontFamily: AppTypography.quranFont);
  
  // الأحجام
  TextStyle withSize(double size) => copyWith(fontSize: size);
}