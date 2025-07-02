// lib/app/themes/widgets/cards/card_factory.dart - نسخة منظفة (بدون تكرار)
import 'package:flutter/material.dart';
import '../../theme_constants.dart';
import '../../core/systems/app_color_system.dart';
import '../../core/systems/app_icons_system.dart';
import 'card_types.dart';

/// Factory واحد لجميع البطاقات - منظف من التكرار
class CardFactory {
  CardFactory._();

  // ===== دوال مساعدة داخلية - تجنب التكرار =====
  
  /// الحصول على اللون بذكاء - دالة واحدة لكل المصنع
  static Color _getEffectiveColor({
    Color? providedColor,
    String? categoryType,
    String? quoteType,
    Color fallback = AppColorSystem.primary,
  }) {
    if (providedColor != null) return providedColor;
    
    if (categoryType != null) {
      return AppColorSystem.getCategoryColor(categoryType);
    }
    
    if (quoteType != null) {
      return AppColorSystem.getQuoteColor(quoteType);
    }
    
    return fallback;
  }

  /// إنشاء تدرج ذكي - دالة واحدة
  static List<Color> _createGradientColors(Color baseColor, [List<Color>? provided]) {
    if (provided != null && provided.isNotEmpty) return provided;
    
    return [
      baseColor,
      AppColorSystem.getDarkColor(baseColor.toString()),
    ];
  }

  // ===== Factory Methods الأساسية - منطق موحد =====

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
      primaryColor: primaryColor ?? AppColorSystem.primary,
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
    String? categoryType,
    VoidCallback? onTap,
    VoidCallback? onFavoriteToggle,
    List<CardAction>? actions,
  }) {
    final effectiveColor = _getEffectiveColor(
      providedColor: primaryColor,
      categoryType: categoryType,
      fallback: AppColorSystem.primary,
    );

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
    String? quoteType,
  }) {
    final effectiveColor = _getEffectiveColor(
      providedColor: primaryColor,
      quoteType: quoteType,
      fallback: AppColorSystem.primary,
    );

    return CardProperties(
      type: CardType.quote,
      style: CardStyle.gradient,
      content: quote,
      source: author,
      subtitle: category,
      primaryColor: effectiveColor,
      gradientColors: _createGradientColors(effectiveColor, gradientColors),
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
      primaryColor: iconColor ?? AppColorSystem.primary,
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
      gradientColors: _createGlassGradientColors(primaryColor),
      onTap: onTap,
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space5),
      showShadow: true,
    );
  }

  /// دالة مساعدة للتدرج الزجاجي
  static List<Color> _createGlassGradientColors(Color baseColor) {
    return [
      baseColor.withValues(alpha: 0.95),
      AppColorSystem.getDarkColor(baseColor.toString()).withValues(alpha: 0.90),
      AppColorSystem.getDarkColor(baseColor.toString()).withValues(alpha: 0.85),
    ];
  }

  // ===== Factory Methods مبسطة - استخدام الدوال الموحدة =====

  /// أذكار الصباح
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
      categoryType: 'morning', // يحدد اللون تلقائياً
    );
  }

  /// أذكار المساء
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
      categoryType: 'evening', // يحدد اللون تلقائياً
    );
  }

  /// أذكار النوم
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
      categoryType: 'sleep', // يحدد اللون تلقائياً
    );
  }

  /// آية قرآنية
  static CardProperties verse({
    required String verse,
    String? surah,
    Color? primaryColor,
  }) {
    return quote(
      quote: verse,
      author: surah,
      category: 'آية قرآنية',
      primaryColor: primaryColor,
      quoteType: 'verse', // يحدد اللون تلقائياً
    );
  }

  /// حديث نبوي
  static CardProperties hadith({
    required String hadith,
    String? narrator,
    Color? primaryColor,
  }) {
    return quote(
      quote: hadith,
      author: narrator,
      category: 'حديث شريف',
      primaryColor: primaryColor,
      quoteType: 'hadith', // يحدد اللون تلقائياً
    );
  }

  /// دعاء مأثور
  static CardProperties dua({
    required String dua,
    String? source,
    Color? primaryColor,
  }) {
    return quote(
      quote: dua,
      author: source,
      category: 'دعاء مأثور',
      primaryColor: primaryColor,
      quoteType: 'dua', // يحدد اللون تلقائياً
    );
  }

  /// بطاقة فئة أذكار - استخدام الدوال الموحدة
  static CardProperties athkarCategory({
    required String title,
    required String categoryId,
    required VoidCallback onTap,
  }) {
    return glassCategory(
      title: title,
      icon: AppIconsSystem.getCategoryIcon(categoryId), // من النظام الموحد
      primaryColor: AppColorSystem.getCategoryColor(categoryId), // من النظام الموحد
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
}