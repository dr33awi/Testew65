// lib/app/themes/core/helpers/quote_helper.dart - مساعد الاقتباسات الموحد
import 'package:flutter/material.dart';
import '../systems/app_color_system.dart';
import '../systems/app_icons_system.dart';
import '../theme_extensions.dart';

/// مساعد موحد للاقتباسات والنصوص الدينية
class QuoteHelper {
  QuoteHelper._();

  /// الحصول على ألوان الاقتباس حسب النوع
  static List<Color> getQuoteColors(BuildContext context, String type) {
    final baseColor = getQuotePrimaryColor(context, type);
    return [
      baseColor,
      baseColor.darken(0.2),
    ];
  }

  /// الحصول على اللون الأساسي للاقتباس
  static Color getQuotePrimaryColor(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'verse':
      case 'آية':
        return AppColorSystem.primary;
      case 'hadith':
      case 'حديث':
        return AppColorSystem.accent;
      case 'dua':
      case 'دعاء':
        return AppColorSystem.tertiary;
      default:
        return AppColorSystem.primary;
    }
  }

  /// الحصول على عنوان الاقتباس
  static String getQuoteTitle(String type) {
    switch (type.toLowerCase()) {
      case 'verse':
      case 'آية':
        return 'آية قرآنية';
      case 'hadith':
      case 'حديث':
        return 'حديث شريف';
      case 'dua':
      case 'دعاء':
        return 'دعاء مأثور';
      default:
        return 'نص ديني';
    }
  }

  /// الحصول على أيقونة الاقتباس
  static IconData getQuoteIcon(String type) {
    switch (type.toLowerCase()) {
      case 'verse':
      case 'آية':
        return AppIconsSystem.quran;
      case 'hadith':
      case 'حديث':
        return AppIconsSystem.athkar;
      case 'dua':
      case 'دعاء':
        return AppIconsSystem.dua;
      default:
        return AppIconsSystem.athkar;
    }
  }

  /// الحصول على لون النص الأساسي
  static Color getQuoteTextColor(BuildContext context, String type) {
    return Colors.white;
  }

  /// الحصول على لون النص الثانوي
  static Color getQuoteSecondaryTextColor(BuildContext context, String type) {
    return Colors.white.withValues(alpha: 0.9);
  }

  /// الحصول على لون الخلفية الشفافة
  static Color getQuoteOverlayColor(BuildContext context, String type) {
    return Colors.white.withValues(alpha: 0.15);
  }

  /// الحصول على لون الحدود
  static Color getQuoteBorderColor(BuildContext context, String type) {
    return Colors.white.withValues(alpha: 0.3);
  }

  /// الحصول على تدرج لوني للاقتباس
  static LinearGradient getQuoteGradient(BuildContext context, String type) {
    final colors = getQuoteColors(context, type);
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: colors.map((c) => c.withValues(alpha: 0.95)).toList(),
    );
  }

  /// الحصول على نمط النص المناسب للاقتباس
  static TextStyle getQuoteTextStyle(BuildContext context, String type, {
    bool isTitle = false,
    bool isTablet = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final baseStyle = isTitle 
        ? (isTablet ? textTheme.headlineSmall : textTheme.titleLarge)
        : (isTablet ? textTheme.titleMedium : textTheme.bodyLarge);
    
    return baseStyle?.copyWith(
      color: getQuoteTextColor(context, type),
      height: isTitle ? 1.3 : 1.7,
      fontWeight: isTitle ? FontWeight.bold : FontWeight.w500,
      shadows: [
        Shadow(
          color: Colors.black.withValues(alpha: 0.4),
          offset: const Offset(0, 2),
          blurRadius: 4,
        ),
      ],
    ) ?? TextStyle(color: getQuoteTextColor(context, type));
  }

  /// تحديد ما إذا كان النص قصيراً
  static bool isShortText(String text) {
    return text.length < 80;
  }

  /// تحديد أقصى عدد أسطر للعرض
  static int getMaxLines(String text, bool isExpanded) {
    if (isExpanded) return 10;
    return isShortText(text) ? 3 : 4;
  }

  /// الحصول على حجم الخط المناسب
  static double getFontSize(String text, bool isTablet, bool isTitle) {
    if (isTitle) {
      return isTablet ? 22 : 18;
    }
    
    if (isShortText(text)) {
      return isTablet ? 20 : 16;
    }
    
    return isTablet ? 18 : 14;
  }
}

/// Extension لتسهيل الاستخدام
extension QuoteExtension on String {
  /// الحصول على لون الاقتباس
  Color getQuoteColor(BuildContext context) => 
      QuoteHelper.getQuotePrimaryColor(context, this);
  
  /// الحصول على عنوان الاقتباس
  String get quoteTitle => QuoteHelper.getQuoteTitle(this);
  
  /// الحصول على أيقونة الاقتباس
  IconData get quoteIcon => QuoteHelper.getQuoteIcon(this);
  
  /// التحقق من كون النص قصيراً
  bool get isShortQuote => QuoteHelper.isShortText(this);
}