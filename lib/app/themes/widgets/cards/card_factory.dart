// lib/app/themes/widgets/cards/card_factory.dart - النسخة المبسطة
import 'package:flutter/material.dart';
import '../../theme_constants.dart';
import '../../core/theme_extensions.dart';
import 'card_types.dart';

/// Factory لإنشاء البطاقات - مبسط
class CardFactory {
  CardFactory._();

  /// بطاقة بسيطة
  static CardProperties simple({
    required String title,
    String? subtitle,
    IconData? icon,
    VoidCallback? onTap,
    Color? primaryColor,
  }) {
    return CardProperties(
      type: CardType.normal,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      primaryColor: primaryColor,
    );
  }

  /// بطاقة أذكار
  static CardProperties athkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    bool isFavorite = false,
    Color? primaryColor,
    VoidCallback? onTap,
    VoidCallback? onFavoriteToggle,
    List<CardAction>? actions,
  }) {
    return CardProperties(
      type: CardType.athkar,
      style: CardStyle.gradient,
      content: content,
      source: source,
      fadl: fadl,
      currentCount: currentCount,
      totalCount: totalCount,
      isFavorite: isFavorite,
      primaryColor: primaryColor,
      onTap: onTap,
      onFavoriteToggle: onFavoriteToggle,
      actions: actions,
    );
  }

  /// بطاقة اقتباس
  static CardProperties quote({
    required String quote,
    String? author,
    String? category,
    Color? primaryColor,
    List<Color>? gradientColors,
  }) {
    return CardProperties(
      type: CardType.quote,
      style: CardStyle.gradient,
      content: quote,
      source: author,
      subtitle: category,
      primaryColor: primaryColor,
      gradientColors: gradientColors,
    );
  }

  /// بطاقة معلومات
  static CardProperties info({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Color? iconColor,
    Widget? trailing,
  }) {
    return CardProperties(
      type: CardType.info,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      primaryColor: iconColor,
      trailing: trailing,
    );
  }

  /// بطاقة فئة زجاجية
  static CardProperties glassCategory({
    required String title,
    required IconData icon,
    required Color primaryColor,
    required VoidCallback onTap,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    return CardProperties(
      style: CardStyle.glassmorphism,
      title: title,
      icon: icon,
      primaryColor: primaryColor,
      gradientColors: [
        primaryColor.withValues(alpha: 0.95),
        primaryColor.darken(0.15).withValues(alpha: 0.90),
        primaryColor.darken(0.25).withValues(alpha: 0.85),
      ],
      onTap: onTap,
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space5),
      showShadow: true,
    );
  }
}

/// Factory للأذكار المتخصصة
class AthkarCardFactory {
  AthkarCardFactory._();

  /// بطاقة ذكر الصباح
  static CardProperties morningAthkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    VoidCallback? onTap,
    List<CardAction>? actions,
  }) {
    return CardFactory.athkar(
      content: content,
      source: source,
      fadl: fadl,
      currentCount: currentCount,
      totalCount: totalCount,
      onTap: onTap,
      actions: actions,
      primaryColor: ThemeConstants.primary,
    );
  }

  /// بطاقة ذكر المساء
  static CardProperties eveningAthkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    VoidCallback? onTap,
    List<CardAction>? actions,
  }) {
    return CardFactory.athkar(
      content: content,
      source: source,
      fadl: fadl,
      currentCount: currentCount,
      totalCount: totalCount,
      onTap: onTap,
      actions: actions,
      primaryColor: ThemeConstants.accent,
    );
  }

  /// بطاقة ذكر النوم
  static CardProperties sleepAthkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    VoidCallback? onTap,
    List<CardAction>? actions,
  }) {
    return CardFactory.athkar(
      content: content,
      source: source,
      fadl: fadl,
      currentCount: currentCount,
      totalCount: totalCount,
      onTap: onTap,
      actions: actions,
      primaryColor: ThemeConstants.tertiary,
    );
  }
}

/// Factory للاقتباسات المتخصصة
class QuoteCardFactory {
  QuoteCardFactory._();

  /// اقتباس قرآني
  static CardProperties verse({
    required String verse,
    String? surah,
    Color? primaryColor,
  }) {
    return CardFactory.quote(
      quote: verse,
      author: surah,
      category: 'آية قرآنية',
      primaryColor: primaryColor ?? ThemeConstants.primary,
      gradientColors: [
        primaryColor ?? ThemeConstants.primary,
        (primaryColor ?? ThemeConstants.primary).darken(0.2),
      ],
    );
  }

  /// حديث نبوي
  static CardProperties hadith({
    required String hadith,
    String? narrator,
    Color? primaryColor,
  }) {
    return CardFactory.quote(
      quote: hadith,
      author: narrator,
      category: 'حديث شريف',
      primaryColor: primaryColor ?? ThemeConstants.accent,
      gradientColors: [
        primaryColor ?? ThemeConstants.accent,
        (primaryColor ?? ThemeConstants.accent).darken(0.2),
      ],
    );
  }

  /// دعاء مأثور
  static CardProperties dua({
    required String dua,
    String? source,
    Color? primaryColor,
  }) {
    return CardFactory.quote(
      quote: dua,
      author: source,
      category: 'دعاء مأثور',
      primaryColor: primaryColor ?? ThemeConstants.tertiary,
      gradientColors: [
        primaryColor ?? ThemeConstants.tertiary,
        (primaryColor ?? ThemeConstants.tertiary).darken(0.2),
      ],
    );
  }
}

/// Factory للبطاقات الزجاجية
class GlassCardFactory {
  GlassCardFactory._();

  /// بطاقة فئة الأذكار
  static CardProperties athkarCategory({
    required String title,
    required String categoryId,
    required VoidCallback onTap,
  }) {
    final categoryColor = _getCategoryColor(categoryId);
    final categoryIcon = _getCategoryIcon(categoryId);
    
    return CardFactory.glassCategory(
      title: title,
      icon: categoryIcon,
      primaryColor: categoryColor,
      onTap: onTap,
    );
  }

  /// بطاقة ميزة رئيسية
  static CardProperties featureCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    Color? primaryColor,
  }) {
    return CardFactory.glassCategory(
      title: title,
      icon: icon,
      primaryColor: primaryColor ?? ThemeConstants.primary,
      onTap: onTap,
    );
  }

  /// الحصول على لون الفئة
  static Color _getCategoryColor(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
      case 'أذكار الصباح':
        return ThemeConstants.primary;
      case 'evening':
      case 'المساء':
      case 'أذكار المساء':
        return ThemeConstants.accent;
      case 'sleep':
      case 'النوم':
      case 'أذكار النوم':
        return ThemeConstants.tertiary;
      case 'prayer':
      case 'بعد الصلاة':
      case 'أذكار بعد الصلاة':
        return ThemeConstants.primaryLight;
      default:
        return ThemeConstants.primary;
    }
  }

  /// الحصول على أيقونة الفئة
  static IconData _getCategoryIcon(String categoryId) {
    switch (categoryId.toLowerCase()) {
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
      default:
        return Icons.menu_book_rounded;
    }
  }
}