// lib/app/themes/widgets/cards/card_factory.dart
import 'package:flutter/material.dart';
import '../../theme_constants.dart';
import '../../core/theme_extensions.dart';
import 'card_types.dart';

/// Factory لإنشاء البطاقات المختلفة
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

  /// بطاقة إكمال
  static CardProperties completion({
    required String title,
    required String message,
    String? subMessage,
    IconData icon = Icons.check_circle_outline,
    Color? primaryColor,
    List<CardAction> actions = const [],
  }) {
    return CardProperties(
      type: CardType.completion,
      style: CardStyle.gradient,
      title: title,
      content: message,
      subtitle: subMessage,
      icon: icon,
      primaryColor: primaryColor,
      actions: actions,
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

  /// بطاقة إحصائيات
  static CardProperties stat({
    required String title,
    required String value,
    required IconData icon,
    Color? color,
    VoidCallback? onTap,
    double? progress,
  }) {
    return CardProperties(
      type: CardType.stat,
      style: CardStyle.gradient,
      title: title,
      value: value,
      icon: icon,
      primaryColor: color,
      onTap: onTap,
      progress: progress,
    );
  }

  /// بطاقة ترحيب زجاجية
  static CardProperties glassWelcome({
    required String title,
    String? subtitle,
    required Color primaryColor,
    required VoidCallback onTap,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    return CardProperties(
      style: CardStyle.glassWelcome,
      title: title,
      subtitle: subtitle,
      primaryColor: primaryColor,
      gradientColors: [
        primaryColor,
        primaryColor.darken(0.2),
      ],
      onTap: onTap,
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.all(ThemeConstants.space5),
      showShadow: true,
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

  /// بطاقة ذكر بعد الصلاة
  static CardProperties prayerAthkar({
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
      primaryColor: ThemeConstants.primaryLight,
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

  /// بطاقة ترحيب رئيسية
  static CardProperties welcomeCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? primaryColor,
  }) {
    return CardFactory.glassWelcome(
      title: title,
      subtitle: subtitle,
      onTap: onTap,
      primaryColor: primaryColor ?? ThemeConstants.primary,
    );
  }

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
      default:
        return Icons.menu_book_rounded;
    }
  }
}

/// Factory للبطاقات المتخصصة
class SpecializedCardFactory {
  SpecializedCardFactory._();

  /// بطاقة إنجاز
  static CardProperties achievement({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onShare,
    required VoidCallback onRestart,
    Color? primaryColor,
  }) {
    return CardFactory.completion(
      title: title,
      message: description,
      subMessage: 'جعلها الله في ميزان حسناتك',
      icon: icon,
      primaryColor: primaryColor ?? ThemeConstants.success,
      actions: [
        CardAction(
          icon: Icons.refresh_rounded,
          label: 'إعادة البدء',
          onPressed: onRestart,
          isPrimary: true,
        ),
        CardAction(
          icon: Icons.share_rounded,
          label: 'مشاركة',
          onPressed: onShare,
        ),
      ],
    );
  }

  /// بطاقة إحصائية للتقدم
  static CardProperties progressStat({
    required String title,
    required int completed,
    required int total,
    required IconData icon,
    VoidCallback? onTap,
    Color? primaryColor,
  }) {
    final percentage = total > 0 ? (completed / total * 100).round() : 0;
    final progress = total > 0 ? completed / total : 0.0;
    
    return CardFactory.stat(
      title: title,
      value: '$percentage%',
      icon: icon,
      color: primaryColor ?? ThemeConstants.primary,
      onTap: onTap,
      progress: progress,
    );
  }

  /// بطاقة معلومات سريعة
  static CardProperties quickInfo({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Color? iconColor,
    String? badge,
  }) {
    return CardProperties(
      type: CardType.info,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      primaryColor: iconColor ?? ThemeConstants.info,
      badge: badge,
    );
  }

  /// بطاقة إعداد
  static CardProperties setting({
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
    Widget? trailing,
    bool isEnabled = true,
  }) {
    return CardProperties(
      type: CardType.info,
      style: CardStyle.normal,
      title: title,
      subtitle: description,
      icon: icon,
      onTap: isEnabled ? onTap : null,
      primaryColor: isEnabled ? ThemeConstants.primary : ThemeConstants.lightTextHint,
      trailing: trailing,
    );
  }

  /// بطاقة تنبيه
  static CardProperties notice({
    required String title,
    required String message,
    required IconData icon,
    VoidCallback? onAction,
    String? actionLabel,
    Color? backgroundColor,
  }) {
    final actions = onAction != null && actionLabel != null ? [
      CardAction(
        icon: Icons.check,
        label: actionLabel,
        onPressed: onAction,
        isPrimary: true,
      ),
    ] : <CardAction>[];

    return CardProperties(
      type: CardType.info,
      style: CardStyle.outlined,
      title: title,
      content: message,
      icon: icon,
      primaryColor: backgroundColor ?? ThemeConstants.warning,
      actions: actions,
    );
  }
}

/// Factory للبطاقات التفاعلية
class InteractiveCardFactory {
  InteractiveCardFactory._();

  /// بطاقة قابلة للنقر مع معاينة
  static CardProperties clickablePreview({
    required String title,
    required String preview,
    required VoidCallback onTap,
    IconData? icon,
    String? subtitle,
    Color? primaryColor,
  }) {
    return CardProperties(
      type: CardType.normal,
      style: CardStyle.elevated,
      title: title,
      subtitle: subtitle,
      content: preview,
      icon: icon,
      onTap: onTap,
      primaryColor: primaryColor ?? ThemeConstants.primary,
      showShadow: true,
    );
  }

  /// بطاقة مع عداد تفاعلي
  static CardProperties interactiveCounter({
    required String title,
    required String content,
    required int currentCount,
    required int targetCount,
    required VoidCallback onIncrement,
    required VoidCallback onReset,
    Color? primaryColor,
    String? source,
  }) {
    return CardProperties(
      type: CardType.athkar,
      style: CardStyle.gradient,
      title: title,
      content: content,
      currentCount: currentCount,
      totalCount: targetCount,
      source: source,
      onTap: onIncrement,
      onLongPress: onReset,
      primaryColor: primaryColor ?? ThemeConstants.primary,
      actions: [
        CardAction(
          icon: Icons.add_circle_outline,
          label: 'زيادة',
          onPressed: onIncrement,
        ),
        CardAction(
          icon: Icons.refresh,
          label: 'إعادة تعيين',
          onPressed: onReset,
        ),
      ],
    );
  }

  /// بطاقة مع خيارات متعددة
  static CardProperties multiAction({
    required String title,
    String? subtitle,
    String? content,
    required List<CardAction> actions,
    IconData? icon,
    Color? primaryColor,
  }) {
    return CardProperties(
      type: CardType.normal,
      style: CardStyle.gradient,
      title: title,
      subtitle: subtitle,
      content: content,
      icon: icon,
      primaryColor: primaryColor ?? ThemeConstants.primary,
      actions: actions,
    );
  }

  /// بطاقة قابلة للطي
  static CardProperties expandable({
    required String title,
    required String summary,
    required String fullContent,
    required bool isExpanded,
    required VoidCallback onToggle,
    IconData? icon,
    Color? primaryColor,
  }) {
    return CardProperties(
      type: CardType.normal,
      style: CardStyle.normal,
      title: title,
      content: isExpanded ? fullContent : summary,
      icon: icon,
      onTap: onToggle,
      primaryColor: primaryColor ?? ThemeConstants.primary,
      trailing: Icon(
        isExpanded ? Icons.expand_less : Icons.expand_more,
        color: primaryColor ?? ThemeConstants.primary,
      ),
    );
  }
}