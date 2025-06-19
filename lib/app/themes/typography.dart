// lib/app/themes/typography.dart
import 'package:flutter/material.dart';
import 'theme_constants.dart';

/// نظام الخطوط الموحد للتطبيق الإسلامي
class AppTypography {
  AppTypography._();

  // ==================== النصوص العامة ====================
  
  static const TextStyle heading = TextStyle(
    fontSize: ThemeConstants.fontSize3xl,
    fontWeight: ThemeConstants.fontBold,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.3,
  );
  
  static const TextStyle title = TextStyle(
    fontSize: ThemeConstants.fontSize2xl,
    fontWeight: ThemeConstants.fontSemiBold,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.4,
  );
  
  static const TextStyle subtitle = TextStyle(
    fontSize: ThemeConstants.fontSizeLg,
    fontWeight: ThemeConstants.fontMedium,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.4,
  );
  
  static const TextStyle body = TextStyle(
    fontSize: ThemeConstants.fontSizeSm,
    fontWeight: ThemeConstants.fontRegular,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: ThemeConstants.fontSizeMd,
    fontWeight: ThemeConstants.fontRegular,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.5,
  );
  
  static const TextStyle caption = TextStyle(
    fontSize: ThemeConstants.fontSizeXs,
    fontWeight: ThemeConstants.fontRegular,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.4,
  );
  
  static const TextStyle button = TextStyle(
    fontSize: ThemeConstants.fontSizeSm,
    fontWeight: ThemeConstants.fontSemiBold,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.2,
  );
  
  // ==================== النصوص الإسلامية ====================
  
  /// نص القرآن الكريم
  static const TextStyle quran = TextStyle(
    fontSize: ThemeConstants.fontSizeLg,
    fontWeight: ThemeConstants.fontRegular,
    fontFamily: ThemeConstants.fontQuran,
    height: 2.0,
    letterSpacing: 0.5,
  );
  
  static const TextStyle quranLarge = TextStyle(
    fontSize: ThemeConstants.fontSizeXl,
    fontWeight: ThemeConstants.fontRegular,
    fontFamily: ThemeConstants.fontQuran,
    height: 2.2,
    letterSpacing: 0.8,
  );
  
  /// نص الحديث الشريف
  static const TextStyle hadith = TextStyle(
    fontSize: ThemeConstants.fontSizeMd,
    fontWeight: ThemeConstants.fontRegular,
    fontFamily: ThemeConstants.fontArabic,
    height: 1.8,
    letterSpacing: 0.3,
  );
  
  /// نص الدعاء
  static const TextStyle dua = TextStyle(
    fontSize: ThemeConstants.fontSizeMd,
    fontWeight: ThemeConstants.fontMedium,
    fontFamily: ThemeConstants.fontArabic,
    height: 1.7,
    letterSpacing: 0.2,
  );
  
  /// نص التسبيح
  static const TextStyle tasbih = TextStyle(
    fontSize: ThemeConstants.fontSizeLg,
    fontWeight: ThemeConstants.fontSemiBold,
    fontFamily: ThemeConstants.fontArabic,
    height: 1.5,
  );
  
  /// أسماء الصلوات
  static const TextStyle prayerName = TextStyle(
    fontSize: ThemeConstants.fontSizeMd,
    fontWeight: ThemeConstants.fontSemiBold,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.3,
  );
  
  /// أوقات الصلوات
  static const TextStyle prayerTime = TextStyle(
    fontSize: ThemeConstants.fontSizeSm,
    fontWeight: ThemeConstants.fontMedium,
    fontFamily: ThemeConstants.fontPrimary,
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
      titleSmall: bodyLarge.copyWith(
        color: textColor, 
        fontWeight: ThemeConstants.fontMedium,
      ),
      
      bodyLarge: bodyLarge.copyWith(color: textColor),
      bodyMedium: body.copyWith(color: textColor),
      bodySmall: caption.copyWith(color: secondaryTextColor),
      
      labelLarge: button.copyWith(color: textColor),
      labelMedium: caption.copyWith(
        color: secondaryTextColor, 
        fontWeight: ThemeConstants.fontMedium,
      ),
      labelSmall: caption.copyWith(color: secondaryTextColor),
    );
  }
}

// ==================== Extensions للسهولة ====================

extension TextStyleExtensions on TextStyle {
  // الأوزان
  TextStyle get light => copyWith(fontWeight: ThemeConstants.fontLight);
  TextStyle get regular => copyWith(fontWeight: ThemeConstants.fontRegular);
  TextStyle get medium => copyWith(fontWeight: ThemeConstants.fontMedium);
  TextStyle get semiBold => copyWith(fontWeight: ThemeConstants.fontSemiBold);
  TextStyle get bold => copyWith(fontWeight: ThemeConstants.fontBold);
  
  // الألوان
  TextStyle withColor(Color color) => copyWith(color: color);
  
  // الخطوط
  TextStyle get arabic => copyWith(fontFamily: ThemeConstants.fontArabic);
  TextStyle get quranFont => copyWith(fontFamily: ThemeConstants.fontQuran);
  
  // الأحجام
  TextStyle withSize(double size) => copyWith(fontSize: size);
  TextStyle withHeight(double height) => copyWith(height: height);
}