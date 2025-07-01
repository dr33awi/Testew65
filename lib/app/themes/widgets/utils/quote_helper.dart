// lib/app/themes/utils/quote_helper.dart
import 'package:flutter/material.dart';
import '../../core/theme_extensions.dart';

/// مساعد موحد للتعامل مع ألوان الاقتباسات اليومية
class QuoteHelper {
  QuoteHelper._();

  /// الحصول على لون الاقتباس الأساسي - نفس نمط CategoryHelper
  static Color getQuotePrimaryColor(BuildContext context, String quoteType) {
    switch (quoteType.toLowerCase()) {
      case 'verse':
      case 'آية':
        return context.accentColor; // نفس لون الأذكار - أخضر
      case 'hadith':
      case 'حديث':
        return context.primaryColor; // نفس لون أساسي - بني/ذهبي
      case 'dua':
      case 'دعاء':
        return context.tertiaryColor; // نفس لون ثالثي - بيج/كريمي
      default:
        return context.primaryColor;
    }
  }

  /// الحصول على اللون الفاتح للاقتباس
  static Color getQuoteLightColor(BuildContext context, String quoteType) {
    switch (quoteType.toLowerCase()) {
      case 'verse':
      case 'آية':
        return context.accentLightColor; // أخضر فاتح
      case 'hadith':
      case 'حديث':
        return context.primaryLightColor; // ذهبي فاتح
      case 'dua':
      case 'دعاء':
        return context.tertiaryLightColor; // بيج فاتح
      default:
        return context.primaryLightColor;
    }
  }

  /// الحصول على اللون الداكن للاقتباس
  static Color getQuoteDarkColor(BuildContext context, String quoteType) {
    switch (quoteType.toLowerCase()) {
      case 'verse':
      case 'آية':
        return context.accentDarkColor; // أخضر داكن
      case 'hadith':
      case 'حديث':
        return context.primaryDarkColor; // ذهبي داكن
      case 'dua':
      case 'دعاء':
        return context.tertiaryDarkColor; // بيج داكن
      default:
        return context.primaryDarkColor;
    }
  }

  /// الحصول على قائمة ألوان متدرجة للاقتباس
  static List<Color> getQuoteColors(BuildContext context, String quoteType) {
    final baseColor = getQuotePrimaryColor(context, quoteType);
    final darkColor = getQuoteDarkColor(context, quoteType);
    
    return [
      baseColor,
      darkColor,
    ];
  }

  /// الحصول على تدرج لوني للاقتباس
  static LinearGradient getQuoteGradient(BuildContext context, String quoteType) {
    final colors = getQuoteColors(context, quoteType);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors,
    );
  }

  /// الحصول على تدرج لوني مع شفافية
  static LinearGradient getQuoteGradientWithOpacity(
    BuildContext context, 
    String quoteType, {
    double opacity = 0.9,
  }) {
    final colors = getQuoteColors(context, quoteType);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors.map((color) => 
        color.withValues(alpha: opacity)
      ).toList(),
    );
  }

  /// الحصول على أيقونة الاقتباس
  static IconData getQuoteIcon(String quoteType) {
    switch (quoteType.toLowerCase()) {
      case 'verse':
      case 'آية':
        return Icons.menu_book_rounded; // أيقونة كتاب للآيات
      case 'hadith':
      case 'حديث':
        return Icons.format_quote_rounded; // أيقونة اقتباس للأحاديث
      case 'dua':
      case 'دعاء':
        return Icons.pan_tool_rounded; // أيقونة يد للدعاء
      default:
        return Icons.auto_awesome_rounded;
    }
  }

  /// الحصول على وصف نوع الاقتباس
  static String getQuoteTypeDescription(String quoteType) {
    switch (quoteType.toLowerCase()) {
      case 'verse':
      case 'آية':
        return 'آية قرآنية كريمة';
      case 'hadith':
      case 'حديث':
        return 'حديث نبوي شريف';
      case 'dua':
      case 'دعاء':
        return 'دعاء مأثور';
      default:
        return 'اقتباس ديني';
    }
  }

  /// الحصول على لون النص المناسب للخلفية
  static Color getQuoteTextColor(BuildContext context, String quoteType) {
    // دائماً نستخدم الأبيض للنصوص على الخلفيات الملونة
    return Colors.white;
  }

  /// الحصول على لون النص الثانوي
  static Color getQuoteSecondaryTextColor(BuildContext context, String quoteType) {
    return Colors.white.withValues(alpha: 0.9);
  }

  /// الحصول على لون الحدود
  static Color getQuoteBorderColor(BuildContext context, String quoteType) {
    return Colors.white.withValues(alpha: 0.2);
  }

  /// الحصول على لون الخلفية الشفافة للعناصر الداخلية
  static Color getQuoteOverlayColor(BuildContext context, String quoteType) {
    return Colors.white.withValues(alpha: 0.15);
  }

  /// التحقق من نوع الاقتباس
  static bool isValidQuoteType(String quoteType) {
    const validTypes = {'verse', 'hadith', 'dua', 'آية', 'حديث', 'دعاء'};
    return validTypes.contains(quoteType.toLowerCase());
  }

  /// الحصول على عنوان مناسب للاقتباس
  static String getQuoteTitle(String quoteType) {
    switch (quoteType.toLowerCase()) {
      case 'verse':
      case 'آية':
        return 'آية اليوم';
      case 'hadith':
      case 'حديث':
        return 'حديث اليوم';
      case 'dua':
      case 'دعاء':
        return 'دعاء اليوم';
      default:
        return 'اقتباس اليوم';
    }
  }

  /// الحصول على لون الظل للبطاقة
  static Color getQuoteShadowColor(BuildContext context, String quoteType) {
    final baseColor = getQuotePrimaryColor(context, quoteType);
    return baseColor.withValues(alpha: 0.3);
  }
}