// lib/app/themes/widgets/cards/card_factory.dart - إصلاح الاستدعاءات المحذوفة
import 'package:flutter/material.dart';
import '../../theme_constants.dart';
import '../../core/theme_extensions.dart';
import '../../core/systems/app_color_system.dart';
import 'card_types.dart';

/// Factory واحد فقط لجميع البطاقات - بسيط ونظيف
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

  /// بطاقة أذكار - موحدة لجميع الأنواع
  static CardProperties athkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    bool isFavorite = false,
    Color? primaryColor,
    String? categoryType, // لتحديد اللون تلقائياً
    VoidCallback? onTap,
    VoidCallback? onFavoriteToggle,
    List<CardAction>? actions,
  }) {
    // تحديد اللون تلقائياً حسب النوع إذا لم يُحدد
    Color effectiveColor = primaryColor ?? AppColorSystem.primary;
    if (primaryColor == null && categoryType != null) {
      effectiveColor = AppColorSystem.getCategoryColor(categoryType);
    }

    return CardProperties(
      type: CardType.athkar,
      style: CardStyle.gradient,
      content: content,
      source: source,
      fadl: fadl,
      currentCount: currentCount,
      totalCount: totalCount,
      isFavorite: isFavorite,
      primaryColor: effectiveColor,
      onTap: onTap,
      onFavoriteToggle: onFavoriteToggle,
      actions: actions,
    );
  }

  /// بطاقة اقتباس - موحدة لجميع الأنواع
  static CardProperties quote({
    required String quote,
    String? author,
    String? category,
    Color? primaryColor,
    List<Color>? gradientColors,
    String? quoteType, // verse, hadith, dua
  }) {
    // تحديد اللون تلقائياً حسب النوع
    Color effectiveColor = primaryColor ?? AppColorSystem.primary;
    if (primaryColor == null && quoteType != null) {
      switch (quoteType.toLowerCase()) {
        case 'verse':
        case 'آية':
          effectiveColor = AppColorSystem.primary;
          break;
        case 'hadith':
        case 'حديث':
          effectiveColor = AppColorSystem.accent;
          break;
        case 'dua':
        case 'دعاء':
          effectiveColor = AppColorSystem.tertiary;
          break;
      }
    }

    return CardProperties(
      type: CardType.quote,
      style: CardStyle.gradient,
      content: quote,
      source: author,
      subtitle: category,
      primaryColor: effectiveColor,
      gradientColors: gradientColors ?? [
        effectiveColor,
        effectiveColor.darken(0.2),
      ],
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

  // ===== Factory Methods مبسطة للاستخدام السريع =====

  /// أذكار الصباح - استخدام athkar() مع نوع محدد
  static CardProperties morningAthkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    VoidCallback? onTap,
    List<CardAction>? actions,
  }) {
    return athkar(
      content: content,
      source: source,
      fadl: fadl,
      currentCount: currentCount,
      totalCount: totalCount,
      onTap: onTap,
      actions: actions,
      primaryColor: AppColorSystem.primary,
      categoryType: 'morning',
    );
  }

  /// أذكار المساء - استخدام athkar() مع نوع محدد
  static CardProperties eveningAthkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    VoidCallback? onTap,
    List<CardAction>? actions,
  }) {
    return athkar(
      content: content,
      source: source,
      fadl: fadl,
      currentCount: currentCount,
      totalCount: totalCount,
      onTap: onTap,
      actions: actions,
      primaryColor: AppColorSystem.accent,
      categoryType: 'evening',
    );
  }

  /// أذكار النوم - استخدام athkar() مع نوع محدد
  static CardProperties sleepAthkar({
    required String content,
    String? source,
    String? fadl,
    int currentCount = 0,
    int totalCount = 1,
    VoidCallback? onTap,
    List<CardAction>? actions,
  }) {
    return athkar(
      content: content,
      source: source,
      fadl: fadl,
      currentCount: currentCount,
      totalCount: totalCount,
      onTap: onTap,
      actions: actions,
      primaryColor: AppColorSystem.tertiary,
      categoryType: 'sleep',
    );
  }

  /// آية قرآنية - استخدام quote() مع نوع محدد
  static CardProperties verse({
    required String verse,
    String? surah,
    Color? primaryColor,
  }) {
    return quote(
      quote: verse,
      author: surah,
      category: 'آية قرآنية',
      primaryColor: primaryColor ?? AppColorSystem.primary,
      quoteType: 'verse',
    );
  }

  /// حديث نبوي - استخدام quote() مع نوع محدد
  static CardProperties hadith({
    required String hadith,
    String? narrator,
    Color? primaryColor,
  }) {
    return quote(
      quote: hadith,
      author: narrator,
      category: 'حديث شريف',
      primaryColor: primaryColor ?? AppColorSystem.accent,
      quoteType: 'hadith',
    );
  }

  /// دعاء مأثور - استخدام quote() مع نوع محدد
  static CardProperties dua({
    required String dua,
    String? source,
    Color? primaryColor,
  }) {
    return quote(
      quote: dua,
      author: source,
      category: 'دعاء مأثور',
      primaryColor: primaryColor ?? AppColorSystem.tertiary,
      quoteType: 'dua',
    );
  }

  /// بطاقة فئة أذكار - استخدام glassCategory() مع تحديد تلقائي للون والأيقونة
  static CardProperties athkarCategory({
    required String title,
    required String categoryId,
    required VoidCallback onTap,
  }) {
    return glassCategory(
      title: title,
      icon: _getCategoryIcon(categoryId),
      primaryColor: _getCategoryColor(categoryId),
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
    return glassCategory(
      title: title,
      icon: icon,
      primaryColor: primaryColor ?? AppColorSystem.primary,
      onTap: onTap,
    );
  }

  // ===== دوال مساعدة خاصة =====
  
  /// الحصول على لون الفئة - مبسط
  static Color _getCategoryColor(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
        return AppColorSystem.primary;
      case 'evening':
      case 'المساء':
        return AppColorSystem.accent;
      case 'sleep':
      case 'النوم':
        return AppColorSystem.tertiary;
      case 'prayer':
      case 'بعد الصلاة':
        return AppColorSystem.primaryLight;
      default:
        return AppColorSystem.primary;
    }
  }

  /// الحصول على أيقونة الفئة - مبسط
  static IconData _getCategoryIcon(String categoryId) {
    switch (categoryId.toLowerCase()) {
      case 'morning':
      case 'الصباح':
        return Icons.wb_sunny_rounded;
      case 'evening':
      case 'المساء':
        return Icons.nights_stay_rounded;
      case 'sleep':
      case 'النوم':
        return Icons.bedtime_rounded;
      case 'prayer':
      case 'بعد الصلاة':
        return Icons.mosque_rounded;
      default:
        return Icons.menu_book_rounded;
    }
  }
}