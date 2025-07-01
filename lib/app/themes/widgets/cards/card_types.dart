// lib/app/themes/widgets/cards/card_types.dart
import 'package:flutter/material.dart';

/// أنواع البطاقات
enum CardType {
  normal,      // بطاقة عادية
  athkar,      // بطاقة أذكار
  quote,       // بطاقة اقتباس
  completion,  // بطاقة إكمال
  info,        // بطاقة معلومات
  stat,        // بطاقة إحصائيات
}

/// أنماط البطاقات
enum CardStyle {
  normal,        // عادي
  gradient,      // متدرج
  glassmorphism, // زجاجي
  glassWelcome,  // زجاجي مع تأثير التلميع (للترحيب)
  outlined,      // محدد
  elevated,      // مرتفع
}

/// إجراءات البطاقة
class CardAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final bool isPrimary;

  const CardAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
    this.isPrimary = false,
  });
}

/// خصائص البطاقة الأساسية
class CardProperties {
  // النوع والأسلوب
  final CardType type;
  final CardStyle style;
  
  // المحتوى الأساسي
  final String? title;
  final String? subtitle;
  final String? content;
  final Widget? child;
  
  // الأيقونات والصور
  final IconData? icon;
  final Widget? leading;
  final Widget? trailing;
  final String? imageUrl;
  
  // الألوان والتصميم
  final Color? primaryColor;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final double? elevation;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  
  // التفاعل
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final List<CardAction>? actions;
  
  // خصائص إضافية
  final String? badge;
  final Color? badgeColor;
  final bool isSelected;
  final bool showShadow;
  
  // خصائص خاصة بالأذكار
  final int? currentCount;
  final int? totalCount;
  final bool? isFavorite;
  final String? source;
  final String? fadl;
  final VoidCallback? onFavoriteToggle;
  
  // خصائص خاصة بالإحصائيات
  final String? value;
  final String? unit;
  final double? progress;

  const CardProperties({
    this.type = CardType.normal,
    this.style = CardStyle.normal,
    this.title,
    this.subtitle,
    this.content,
    this.child,
    this.icon,
    this.leading,
    this.trailing,
    this.imageUrl,
    this.primaryColor,
    this.backgroundColor,
    this.gradientColors,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.actions,
    this.badge,
    this.badgeColor,
    this.isSelected = false,
    this.showShadow = true,
    this.currentCount,
    this.totalCount,
    this.isFavorite,
    this.source,
    this.fadl,
    this.onFavoriteToggle,
    this.value,
    this.unit,
    this.progress,
  });

  /// نسخ الخصائص مع تغييرات
  CardProperties copyWith({
    CardType? type,
    CardStyle? style,
    String? title,
    String? subtitle,
    String? content,
    Widget? child,
    IconData? icon,
    Widget? leading,
    Widget? trailing,
    String? imageUrl,
    Color? primaryColor,
    Color? backgroundColor,
    List<Color>? gradientColors,
    double? elevation,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    List<CardAction>? actions,
    String? badge,
    Color? badgeColor,
    bool? isSelected,
    bool? showShadow,
    int? currentCount,
    int? totalCount,
    bool? isFavorite,
    String? source,
    String? fadl,
    VoidCallback? onFavoriteToggle,
    String? value,
    String? unit,
    double? progress,
  }) {
    return CardProperties(
      type: type ?? this.type,
      style: style ?? this.style,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      content: content ?? this.content,
      child: child ?? this.child,
      icon: icon ?? this.icon,
      leading: leading ?? this.leading,
      trailing: trailing ?? this.trailing,
      imageUrl: imageUrl ?? this.imageUrl,
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      gradientColors: gradientColors ?? this.gradientColors,
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      actions: actions ?? this.actions,
      badge: badge ?? this.badge,
      badgeColor: badgeColor ?? this.badgeColor,
      isSelected: isSelected ?? this.isSelected,
      showShadow: showShadow ?? this.showShadow,
      currentCount: currentCount ?? this.currentCount,
      totalCount: totalCount ?? this.totalCount,
      isFavorite: isFavorite ?? this.isFavorite,
      source: source ?? this.source,
      fadl: fadl ?? this.fadl,
      onFavoriteToggle: onFavoriteToggle ?? this.onFavoriteToggle,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      progress: progress ?? this.progress,
    );
  }

  /// التحقق من وجود محتوى للعرض
  bool get hasContent {
    return title != null || 
           subtitle != null || 
           content != null || 
           icon != null ||
           child != null;
  }

  /// التحقق من وجود بيانات الأذكار
  bool get hasAthkarData {
    return content != null || 
           title != null ||
           currentCount != null ||
           totalCount != null;
  }

  /// التحقق من وجود بيانات الإحصائيات
  bool get hasStatData {
    return value != null || title != null || icon != null;
  }

  /// التحقق من صحة البطاقة للعرض
  bool get isValid {
    switch (type) {
      case CardType.athkar:
        return hasAthkarData;
      case CardType.stat:
        return hasStatData;
      case CardType.info:
        return title != null || subtitle != null || icon != null;
      default:
        return hasContent;
    }
  }
}