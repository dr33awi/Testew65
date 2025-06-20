// lib/app/themes/typography.dart
import 'package:flutter/material.dart';
import 'theme_constants.dart';

/// نظام الخطوط الموحد للتطبيق الإسلامي - مبسط ونظيف
class AppTypography {
  AppTypography._();

  // ==================== النصوص العامة ====================
  
  /// عنوان كبير - للصفحات الرئيسية
  static const TextStyle heading = TextStyle(
    fontSize: ThemeConstants.fontSize4xl,
    fontWeight: ThemeConstants.fontBold,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.2,
    letterSpacing: -0.5,
  );
  
  /// عنوان متوسط - للأقسام المهمة
  static const TextStyle title = TextStyle(
    fontSize: ThemeConstants.fontSize2xl,
    fontWeight: ThemeConstants.fontSemiBold,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.3,
    letterSpacing: -0.25,
  );
  
  /// عنوان فرعي - للعناصر الفرعية
  static const TextStyle subtitle = TextStyle(
    fontSize: ThemeConstants.fontSizeLg,
    fontWeight: ThemeConstants.fontMedium,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.4,
  );
  
  /// نص عادي - الأكثر استخداماً
  static const TextStyle body = TextStyle(
    fontSize: ThemeConstants.fontSizeMd,
    fontWeight: ThemeConstants.fontRegular,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.5,
  );
  
  /// نص صغير - للتفاصيل والتوضيحات
  static const TextStyle caption = TextStyle(
    fontSize: ThemeConstants.fontSizeSm,
    fontWeight: ThemeConstants.fontRegular,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.4,
  );
  
  /// نص الأزرار والتسميات
  static const TextStyle button = TextStyle(
    fontSize: ThemeConstants.fontSizeMd,
    fontWeight: ThemeConstants.fontSemiBold,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.2,
    letterSpacing: 0.1,
  );
  
  // ==================== النصوص الإسلامية المتخصصة ====================
  
  /// نص القرآن الكريم - خط خاص وتباعد مناسب
  static const TextStyle quran = TextStyle(
    fontSize: ThemeConstants.fontSizeXl,
    fontWeight: ThemeConstants.fontRegular,
    fontFamily: ThemeConstants.fontQuran,
    height: 2.0,
    letterSpacing: 0.8,
  );
  
  /// نص القرآن الكبير - للتلاوة
  static const TextStyle quranLarge = TextStyle(
    fontSize: ThemeConstants.fontSize3xl,
    fontWeight: ThemeConstants.fontRegular,
    fontFamily: ThemeConstants.fontQuran,
    height: 2.2,
    letterSpacing: 1.0,
  );
  
  /// نص الحديث الشريف
  static const TextStyle hadith = TextStyle(
    fontSize: ThemeConstants.fontSizeLg,
    fontWeight: ThemeConstants.fontRegular,
    fontFamily: ThemeConstants.fontArabic,
    height: 1.8,
    letterSpacing: 0.3,
  );
  
  /// نص الدعاء والأذكار
  static const TextStyle dua = TextStyle(
    fontSize: ThemeConstants.fontSizeLg,
    fontWeight: ThemeConstants.fontMedium,
    fontFamily: ThemeConstants.fontArabic,
    height: 1.7,
    letterSpacing: 0.2,
  );
  
  /// نص التسبيح - بارز وواضح
  static const TextStyle tasbih = TextStyle(
    fontSize: ThemeConstants.fontSize2xl,
    fontWeight: ThemeConstants.fontSemiBold,
    fontFamily: ThemeConstants.fontArabic,
    height: 1.5,
    letterSpacing: 0.5,
  );
  
  /// أسماء الصلوات
  static const TextStyle prayerName = TextStyle(
    fontSize: ThemeConstants.fontSizeLg,
    fontWeight: ThemeConstants.fontSemiBold,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.3,
  );
  
  /// أوقات الصلوات - رقمية واضحة
  static const TextStyle prayerTime = TextStyle(
    fontSize: ThemeConstants.fontSizeMd,
    fontWeight: ThemeConstants.fontMedium,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.2,
    letterSpacing: 0.5,
  );
  
  /// أرقام العداد - كبيرة وبارزة
  static const TextStyle counter = TextStyle(
    fontSize: ThemeConstants.fontSize4xl,
    fontWeight: ThemeConstants.fontBold,
    fontFamily: ThemeConstants.fontPrimary,
    height: 1.0,
  );
  
  // ==================== إنشاء TextTheme للـ MaterialApp ====================
  
  /// إنشاء TextTheme كامل للتطبيق
  static TextTheme createTextTheme(Color textColor, Color secondaryTextColor) {
    return TextTheme(
      // العناوين الكبيرة
      displayLarge: heading.copyWith(color: textColor),
      displayMedium: heading.copyWith(
        color: textColor,
        fontSize: ThemeConstants.fontSize3xl,
      ),
      displaySmall: title.copyWith(color: textColor),
      
      // العناوين
      headlineLarge: title.copyWith(color: textColor),
      headlineMedium: subtitle.copyWith(color: textColor),
      headlineSmall: subtitle.copyWith(
        color: textColor,
        fontSize: ThemeConstants.fontSizeMd,
      ),
      
      // العناوين الفرعية
      titleLarge: title.copyWith(color: textColor),
      titleMedium: subtitle.copyWith(color: textColor),
      titleSmall: body.copyWith(
        color: textColor,
        fontWeight: ThemeConstants.fontMedium,
      ),
      
      // النصوص الأساسية
      bodyLarge: body.copyWith(
        color: textColor,
        fontSize: ThemeConstants.fontSizeLg,
      ),
      bodyMedium: body.copyWith(color: textColor),
      bodySmall: caption.copyWith(color: secondaryTextColor),
      
      // التسميات
      labelLarge: button.copyWith(color: textColor),
      labelMedium: button.copyWith(
        color: textColor,
        fontSize: ThemeConstants.fontSizeSm,
      ),
      labelSmall: caption.copyWith(
        color: secondaryTextColor,
        fontSize: ThemeConstants.fontSizeXs,
      ),
    );
  }
  
  // ==================== دوال مساعدة للألوان ====================
  
  /// الحصول على نص بلون أساسي
  static TextStyle withPrimaryColor(TextStyle style, BuildContext context) {
    return style.copyWith(color: ThemeConstants.primary);
  }
  
  /// الحصول على نص بلون ثانوي
  static TextStyle withSecondaryColor(TextStyle style, BuildContext context) {
    return style.copyWith(color: ThemeConstants.secondary);
  }
  
  /// الحصول على نص بلون النجاح
  static TextStyle withSuccessColor(TextStyle style, BuildContext context) {
    return style.copyWith(color: ThemeConstants.success);
  }
  
  /// الحصول على نص بلون الخطأ
  static TextStyle withErrorColor(TextStyle style, BuildContext context) {
    return style.copyWith(color: ThemeConstants.error);
  }
  
  /// الحصول على نص بلون التحذير
  static TextStyle withWarningColor(TextStyle style, BuildContext context) {
    return style.copyWith(color: ThemeConstants.warning);
  }
  
  /// الحصول على نص بلون المعلومات
  static TextStyle withInfoColor(TextStyle style, BuildContext context) {
    return style.copyWith(color: ThemeConstants.info);
  }
  
  /// الحصول على نص باللون المناسب للثيم
  static TextStyle withThemeColor(TextStyle style, BuildContext context) {
    return style.copyWith(
      color: ThemeConstants.getTextColor(context),
    );
  }
  
  /// الحصول على نص باللون الثانوي للثيم
  static TextStyle withSecondaryThemeColor(TextStyle style, BuildContext context) {
    return style.copyWith(
      color: ThemeConstants.getSecondaryTextColor(context),
    );
  }
}


// ==================== Extensions للسهولة ====================

/// Extension methods لتسهيل التعامل مع TextStyle
extension TextStyleExtensions on TextStyle {
  // الأوزان
  TextStyle get light => copyWith(fontWeight: ThemeConstants.fontLight);
  TextStyle get regular => copyWith(fontWeight: ThemeConstants.fontRegular);
  TextStyle get medium => copyWith(fontWeight: ThemeConstants.fontMedium);
  TextStyle get semiBold => copyWith(fontWeight: ThemeConstants.fontSemiBold);
  TextStyle get bold => copyWith(fontWeight: ThemeConstants.fontBold);
  
  // الألوان
  TextStyle withColor(Color color) => copyWith(color: color);
  TextStyle get primary => copyWith(color: ThemeConstants.primary);
  TextStyle get secondary => copyWith(color: ThemeConstants.secondary);
  TextStyle get success => copyWith(color: ThemeConstants.success);
  TextStyle get error => copyWith(color: ThemeConstants.error);
  TextStyle get warning => copyWith(color: ThemeConstants.warning);
  TextStyle get info => copyWith(color: ThemeConstants.info);
  
  // الخطوط
  TextStyle get arabicFont => copyWith(fontFamily: ThemeConstants.fontArabic);
  TextStyle get quranFont => copyWith(fontFamily: ThemeConstants.fontQuran);
  TextStyle get primaryFont => copyWith(fontFamily: ThemeConstants.fontPrimary);
  
  // الأحجام
  TextStyle withSize(double size) => copyWith(fontSize: size);
  TextStyle get xs => copyWith(fontSize: ThemeConstants.fontSizeXs);
  TextStyle get sm => copyWith(fontSize: ThemeConstants.fontSizeSm);
  TextStyle get md => copyWith(fontSize: ThemeConstants.fontSizeMd);
  TextStyle get lg => copyWith(fontSize: ThemeConstants.fontSizeLg);
  TextStyle get xl => copyWith(fontSize: ThemeConstants.fontSizeXl);
  TextStyle get xxl => copyWith(fontSize: ThemeConstants.fontSize2xl);
  TextStyle get xxxl => copyWith(fontSize: ThemeConstants.fontSize3xl);
  
  // التباعد
  TextStyle withHeight(double height) => copyWith(height: height);
  TextStyle withLetterSpacing(double spacing) => copyWith(letterSpacing: spacing);
  
  // الشفافية
  TextStyle withOpacity(double opacity) => copyWith(
    color: color?.withValues(alpha: opacity) ?? Colors.black.withValues(alpha: opacity),
  );
  
  // تأثيرات خاصة
  TextStyle get underlined => copyWith(decoration: TextDecoration.underline);
  TextStyle get strikethrough => copyWith(decoration: TextDecoration.lineThrough);
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  
  // للنصوص الإسلامية
  TextStyle get forQuran => copyWith(
    fontFamily: ThemeConstants.fontQuran,
    height: 2.0,
    letterSpacing: 0.8,
  );
  
  TextStyle get forHadith => copyWith(
    fontFamily: ThemeConstants.fontArabic,
    height: 1.8,
    letterSpacing: 0.3,
  );
  
  TextStyle get forDua => copyWith(
    fontFamily: ThemeConstants.fontArabic,
    height: 1.7,
    letterSpacing: 0.2,
  );
}