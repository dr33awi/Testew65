// lib/app/themes/widgets/utils/quote_helper.dart
import 'package:flutter/material.dart';
import '../../core/theme_extensions.dart';

/// مساعد موحد للتعامل مع الاقتباسات وألوانها وأيقوناتها
class QuoteHelper {
  QuoteHelper._();

  /// الحصول على تدرج الاقتباس للبطاقات
  static LinearGradient getQuoteGradient(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'verse':
      case 'آية':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.successColor.withValues(alpha: 0.9),
            context.successLightColor.withValues(alpha: 0.7),
          ],
        );
      case 'hadith':
      case 'حديث':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.accentColor.withValues(alpha: 0.9),
            context.accentLightColor.withValues(alpha: 0.7),
          ],
        );
      case 'dua':
      case 'دعاء':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.tertiaryColor.withValues(alpha: 0.9),
            context.tertiaryLightColor.withValues(alpha: 0.7),
          ],
        );
      case 'quote':
      case 'اقتباس':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.primaryColor.withValues(alpha: 0.9),
            context.primaryLightColor.withValues(alpha: 0.7),
          ],
        );
      default:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.primaryColor.withValues(alpha: 0.9),
            context.primaryLightColor.withValues(alpha: 0.7),
          ],
        );
    }
  }

  /// الحصول على تدرج المودال
  static LinearGradient getModalGradient(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'verse':
      case 'آية':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.successColor.withValues(alpha: 0.95),
            context.successLightColor.withValues(alpha: 0.9),
          ],
        );
      case 'hadith':
      case 'حديث':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.accentColor.withValues(alpha: 0.95),
            context.accentLightColor.withValues(alpha: 0.9),
          ],
        );
      case 'dua':
      case 'دعاء':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.tertiaryColor.withValues(alpha: 0.95),
            context.tertiaryLightColor.withValues(alpha: 0.9),
          ],
        );
      case 'quote':
      case 'اقتباس':
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.primaryColor.withValues(alpha: 0.95),
            context.primaryLightColor.withValues(alpha: 0.9),
          ],
        );
      default:
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            context.primaryColor.withValues(alpha: 0.95),
            context.primaryLightColor.withValues(alpha: 0.9),
          ],
        );
    }
  }

  /// الحصول على الألوان الأساسية للاقتباس
  static List<Color> getQuoteColors(BuildContext context, String type) {
    switch (type.toLowerCase()) {
      case 'verse':
      case 'آية':
        return [context.successColor, context.successLightColor];
      case 'hadith':
      case 'حديث':
        return [context.accentColor, context.accentLightColor];
      case 'dua':
      case 'دعاء':
        return [context.tertiaryColor, context.tertiaryLightColor];
      case 'quote':
      case 'اقتباس':
        return [context.primaryColor, context.primaryLightColor];
      default:
        return [context.primaryColor, context.primaryLightColor];
    }
  }

  /// الحصول على اللون الأساسي للاقتباس
  static Color getQuotePrimaryColor(BuildContext context, String type) {
    return getQuoteColors(context, type).first;
  }

  /// الحصول على اللون الثانوي للاقتباس
  static Color getQuoteSecondaryColor(BuildContext context, String type) {
    return getQuoteColors(context, type).last;
  }

  /// الحصول على أيقونة الاقتباس
  static IconData getQuoteIcon(String type) {
    switch (type.toLowerCase()) {
      case 'verse':
      case 'آية':
        return Icons.menu_book_rounded;
      case 'hadith':
      case 'حديث':
        return Icons.auto_stories_rounded;
      case 'dua':
      case 'دعاء':
        return Icons.pan_tool_rounded;
      case 'quote':
      case 'اقتباس':
        return Icons.format_quote_rounded;
      default:
        return Icons.auto_stories_rounded;
    }
  }

  /// الحصول على عنوان الاقتباس الرئيسي
  static String getQuoteTitle(String type) {
    switch (type.toLowerCase()) {
      case 'verse':
      case 'آية':
        return 'آية اليوم';
      case 'hadith':
      case 'حديث':
        return 'حديث اليوم';
      case 'dua':
      case 'دعاء':
        return 'دعاء اليوم';
      case 'quote':
      case 'اقتباس':
        return 'اقتباس اليوم';
      default:
        return 'اقتباس اليوم';
    }
  }

  /// الحصول على العنوان الفرعي للاقتباس
  static String getQuoteSubtitle(String type) {
    switch (type.toLowerCase()) {
      case 'verse':
      case 'آية':
        return 'من القرآن الكريم';
      case 'hadith':
      case 'حديث':
        return 'من السنة النبوية';
      case 'dua':
      case 'دعاء':
        return 'دعاء مأثور';
      case 'quote':
      case 'اقتباس':
        return 'اقتباس مختار';
      default:
        return 'اقتباس مختار';
    }
  }

  /// الحصول على العنوان التفصيلي للمودال
  static String getQuoteDetailTitle(String type) {
    switch (type.toLowerCase()) {
      case 'verse':
      case 'آية':
        return 'آية من القرآن الكريم';
      case 'hadith':
      case 'حديث':
        return 'حديث شريف';
      case 'dua':
      case 'دعاء':
        return 'دعاء مأثور';
      case 'quote':
      case 'اقتباس':
        return 'اقتباس مختار';
      default:
        return 'اقتباس مختار';
    }
  }

  /// الحصول على نص المشاركة
  static String getShareText(String type, String content, String source) {
    final emoji = getQuoteEmoji(type);
    final title = getQuoteDetailTitle(type);
    
    return '''$emoji $title $emoji

$content

📖 $source

📱 مشارك من تطبيق الأذكار''';
  }

  /// الحصول على إيموجي مناسب للنوع
  static String getQuoteEmoji(String type) {
    switch (type.toLowerCase()) {
      case 'verse':
      case 'آية':
        return '🕋';
      case 'hadith':
      case 'حديث':
        return '📿';
      case 'dua':
      case 'دعاء':
        return '🤲';
      case 'quote':
      case 'اقتباس':
        return '💎';
      default:
        return '✨';
    }
  }

  /// التحقق من صحة نوع الاقتباس
  static bool isValidQuoteType(String type) {
    const validTypes = {
      'verse', 'آية',
      'hadith', 'حديث', 
      'dua', 'دعاء',
      'quote', 'اقتباس'
    };
    
    return validTypes.contains(type.toLowerCase());
  }

  /// تطبيع نوع الاقتباس
  static String normalizeQuoteType(String type) {
    switch (type.toLowerCase()) {
      case 'آية':
        return 'verse';
      case 'حديث':
        return 'hadith';
      case 'دعاء':
        return 'dua';
      case 'اقتباس':
        return 'quote';
      default:
        return type.toLowerCase();
    }
  }

  /// الحصول على ترتيب العرض للأنواع
  static int getQuoteTypeOrder(String type) {
    switch (normalizeQuoteType(type)) {
      case 'verse':
        return 1;
      case 'hadith':
        return 2;
      case 'dua':
        return 3;
      case 'quote':
        return 4;
      default:
        return 5;
    }
  }

  /// مقارنة أنواع الاقتباسات للترتيب
  static int compareQuoteTypes(String type1, String type2) {
    return getQuoteTypeOrder(type1).compareTo(getQuoteTypeOrder(type2));
  }
}