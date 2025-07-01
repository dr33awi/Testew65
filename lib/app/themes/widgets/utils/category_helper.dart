// lib/app/themes/widgets/utils/category_helper.dart
import 'package:flutter/material.dart';
import '../../core/theme_extensions.dart';

/// مساعد موحد للتعامل مع الفئات وألوانها وأيقوناتها
class CategoryHelper {
  CategoryHelper._();

  /// الحصول على لون الفئة الأساسي
  static Color getCategoryColor(BuildContext context, String categoryId) {
    switch (categoryId.toLowerCase()) {
      // فئات الأذكار
      case 'morning':
      case 'الصباح':
      case 'أذكار الصباح':
        return context.primaryColor;
      case 'evening':
      case 'المساء':
      case 'أذكار المساء':
        return context.accentColor;
      case 'sleep':
      case 'النوم':
      case 'أذكار النوم':
        return context.tertiaryColor;
      case 'prayer':
      case 'بعد الصلاة':
      case 'أذكار بعد الصلاة':
        return context.primaryLightColor;
      case 'wakeup':
      case 'الاستيقاظ':
      case 'أذكار الاستيقاظ':
        return context.primaryColor.lighten(0.1);
      case 'travel':
      case 'السفر':
      case 'أذكار السفر':
        return context.accentDarkColor;
      case 'eating':
      case 'الطعام':
      case 'أذكار الطعام':
        return context.tertiaryLightColor;
      case 'general':
      case 'عامة':
      case 'أذكار عامة':
        return context.tertiaryDarkColor;
      
      // فئات التطبيق الرئيسية
      case 'prayer_times':
        return context.primaryColor;
      case 'athkar':
        return context.accentColor;
      case 'quran':
        return context.tertiaryColor;
      case 'qibla':
        return context.primaryDarkColor;
      case 'tasbih':
        return context.accentDarkColor;
      case 'dua':
        return context.tertiaryDarkColor;
      
      default:
        return context.primaryColor;
    }
  }

  /// الحصول على اللون الفاتح للفئة
  static Color getCategoryLightColor(BuildContext context, String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
      case 'أذكار الصباح':
      case 'prayer_times':
        return context.primaryLightColor;
      case 'evening':
      case 'المساء':
      case 'أذكار المساء':
      case 'athkar':
        return context.accentLightColor;
      case 'sleep':
      case 'النوم':
      case 'أذكار النوم':
      case 'quran':
        return context.tertiaryLightColor;
      case 'prayer':
      case 'بعد الصلاة':
      case 'أذكار بعد الصلاة':
        return context.primaryColor;
      case 'wakeup':
      case 'الاستيقاظ':
      case 'أذكار الاستيقاظ':
        return context.primaryLightColor;
      case 'travel':
      case 'السفر':
      case 'أذكار السفر':
      case 'tasbih':
        return context.accentColor;
      case 'eating':
      case 'الطعام':
      case 'أذكار الطعام':
        return context.tertiaryColor;
      case 'general':
      case 'عامة':
      case 'أذكار عامة':
      case 'dua':
        return context.tertiaryColor;
      case 'qibla':
        return context.primaryColor;
      default:
        return context.primaryLightColor;
    }
  }

  /// الحصول على تدرج لوني للفئة
  static LinearGradient getCategoryGradient(BuildContext context, String categoryId) {
    final baseColor = getCategoryColor(context, categoryId);
    final lightColor = getCategoryLightColor(context, categoryId);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [baseColor, lightColor],
    );
  }

  /// الحصول على تدرج لوني مع شفافية
  static LinearGradient getCategoryGradientWithOpacity(
    BuildContext context, 
    String categoryId, {
    double opacity = 0.9,
  }) {
    final baseColor = getCategoryColor(context, categoryId);
    final lightColor = getCategoryLightColor(context, categoryId);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        baseColor.withValues(alpha: opacity),
        lightColor.withValues(alpha: opacity * 0.8),
      ],
    );
  }

  /// الحصول على أيقونة الفئة
  static IconData getCategoryIcon(String categoryId) {
    switch (categoryId.toLowerCase()) {
      // فئات الأذكار
      case 'morning':
      case 'الصباح':
      case 'أذكار الصباح':
        return Icons.wb_sunny_rounded;
      case 'evening':
      case 'المساء':
      case 'أذكار المساء':
        return Icons.nights_stay_rounded;
      case 'sleep':
      case 'النوم':
      case 'أذكار النوم':
        return Icons.bedtime_rounded;
      case 'prayer':
      case 'بعد الصلاة':
      case 'أذكار بعد الصلاة':
        return Icons.mosque_rounded;
      case 'wakeup':
      case 'الاستيقاظ':
      case 'أذكار الاستيقاظ':
        return Icons.wb_sunny_outlined;
      case 'travel':
      case 'السفر':
      case 'أذكار السفر':
        return Icons.luggage_rounded;
      case 'eating':
      case 'الطعام':
      case 'أذكار الطعام':
        return Icons.restaurant_rounded;
      case 'general':
      case 'عامة':
      case 'أذكار عامة':
        return Icons.auto_awesome_rounded;
      
      // فئات التطبيق الرئيسية
      case 'prayer_times':
        return Icons.mosque;
      case 'athkar':
        return Icons.auto_awesome;
      case 'quran':
        return Icons.menu_book_rounded;
      case 'qibla':
        return Icons.explore;
      case 'tasbih':
        return Icons.radio_button_checked;
      case 'dua':
        return Icons.pan_tool_rounded;
      
      default:
        return Icons.menu_book_rounded;
    }
  }

  /// الحصول على وصف الفئة
  static String getCategoryDescription(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
      case 'أذكار الصباح':
        return 'أذكار للقراءة في الصباح';
      case 'evening':
      case 'المساء':
      case 'أذكار المساء':
        return 'أذكار للقراءة في المساء';
      case 'sleep':
      case 'النوم':
      case 'أذكار النوم':
        return 'أذكار قبل النوم';
      case 'prayer':
      case 'بعد الصلاة':
      case 'أذكار بعد الصلاة':
        return 'أذكار بعد كل صلاة';
      case 'wakeup':
      case 'الاستيقاظ':
      case 'أذكار الاستيقاظ':
        return 'أذكار عند الاستيقاظ';
      case 'travel':
      case 'السفر':
      case 'أذكار السفر':
        return 'أذكار للمسافر';
      case 'eating':
      case 'الطعام':
      case 'أذكار الطعام':
        return 'أذكار قبل وبعد الطعام';
      case 'general':
      case 'عامة':
      case 'أذكار عامة':
        return 'أذكار متنوعة';
      case 'prayer_times':
        return 'مواقيت الصلاة والأذان';
      case 'athkar':
        return 'جميع الأذكار اليومية';
      case 'quran':
        return 'القرآن الكريم والتلاوة';
      case 'qibla':
        return 'تحديد اتجاه القبلة';
      case 'tasbih':
        return 'المسبحة الرقمية للتسبيح';
      case 'dua':
        return 'الأدعية المأثورة';
      default:
        return 'فئة من فئات التطبيق';
    }
  }

  /// التحقق من أن الفئة يجب تفعيلها تلقائياً للإشعارات
  static bool shouldAutoEnable(String categoryId) {
    const autoEnabledCategories = {
      'morning', 'الصباح', 'أذكار الصباح',
      'evening', 'المساء', 'أذكار المساء',
      'sleep', 'النوم', 'أذكار النوم',
    };
    
    final normalizedId = categoryId.toLowerCase().trim();
    return autoEnabledCategories.any((category) => 
        normalizedId.contains(category.toLowerCase()) || 
        category.toLowerCase().contains(normalizedId));
  }

  /// الحصول على الوقت الافتراضي للتذكير
  static TimeOfDay getDefaultReminderTime(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
      case 'أذكار الصباح':
        return const TimeOfDay(hour: 6, minute: 0);
      case 'evening':
      case 'المساء':
      case 'أذكار المساء':
        return const TimeOfDay(hour: 18, minute: 0);
      case 'sleep':
      case 'النوم':
      case 'أذكار النوم':
        return const TimeOfDay(hour: 22, minute: 0);
      case 'wakeup':
      case 'الاستيقاظ':
      case 'أذكار الاستيقاظ':
        return const TimeOfDay(hour: 5, minute: 30);
      case 'prayer':
      case 'بعد الصلاة':
      case 'أذكار بعد الصلاة':
        return const TimeOfDay(hour: 12, minute: 0);
      case 'eating':
      case 'الطعام':
      case 'أذكار الطعام':
        return const TimeOfDay(hour: 19, minute: 0);
      case 'travel':
      case 'السفر':
      case 'أذكار السفر':
        return const TimeOfDay(hour: 8, minute: 0);
      case 'general':
      case 'عامة':
      case 'أذكار عامة':
        return const TimeOfDay(hour: 14, minute: 0);
      default:
        return const TimeOfDay(hour: 9, minute: 0);
    }
  }

  /// التحقق من أن الفئة متعلقة بالأذكار
  static bool isAthkarCategory(String categoryId) {
    const athkarCategories = {
      'morning', 'الصباح', 'أذكار الصباح',
      'evening', 'المساء', 'أذكار المساء',
      'sleep', 'النوم', 'أذكار النوم',
      'prayer', 'بعد الصلاة', 'أذكار بعد الصلاة',
      'wakeup', 'الاستيقاظ', 'أذكار الاستيقاظ',
      'travel', 'السفر', 'أذكار السفر',
      'eating', 'الطعام', 'أذكار الطعام',
      'general', 'عامة', 'أذكار عامة',
      'athkar',
    };
    
    final normalizedId = categoryId.toLowerCase().trim();
    return athkarCategories.any((category) => 
        normalizedId.contains(category.toLowerCase()) || 
        category.toLowerCase().contains(normalizedId));
  }

  /// التحقق من أن الفئة متعلقة بالميزات الرئيسية
  static bool isMainFeatureCategory(String categoryId) {
    const mainFeatures = {
      'prayer_times', 'athkar', 'quran', 'qibla', 'tasbih', 'dua'
    };
    
    return mainFeatures.contains(categoryId.toLowerCase());
  }
}