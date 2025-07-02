// lib/app/themes/widgets/cards/card_types.dart - بنفس الأسماء الأصلية تماماً
import 'package:flutter/material.dart';

/// أنواع البطاقات - بنفس الأسماء الأصلية
enum CardType {
  normal,   // بطاقة عادية
  athkar,   // بطاقة أذكار
  quote,    // بطاقة اقتباس
  info,     // بطاقة معلومات
}

/// أنماط البطاقات - بنفس الأسماء الأصلية
enum CardStyle {
  normal,        // عادي
  gradient,      // متدرج
  glassmorphism, // زجاجي
}

/// إجراءات البطاقة - بنفس الاسم الأصلي
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

/// خصائص البطاقة - بنفس الاسم الأصلي CardProperties
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
  final Widget? trailing;
  
  // الألوان والتصميم
  final Color? primaryColor;
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  
  // التفاعل
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final List<CardAction>? actions;
  
  // خصائص إضافية
  final bool showShadow;
  
  // خصائص خاصة بالأذكار
  final int? currentCount;
  final int? totalCount;
  final bool? isFavorite;
  final String? source;
  final String? fadl;
  final VoidCallback? onFavoriteToggle;
  
  // خصائص خاصة بالمعلومات
  final String? value;
  final String? unit;

  const CardProperties({
    this.type = CardType.normal,
    this.style = CardStyle.normal,
    this.title,
    this.subtitle,
    this.content,
    this.child,
    this.icon,
    this.trailing,
    this.primaryColor,
    this.backgroundColor,
    this.gradientColors,
    this.borderRadius,
    this.padding,
    this.margin,
    this.onTap,
    this.onLongPress,
    this.actions,
    this.showShadow = true,
    this.currentCount,
    this.totalCount,
    this.isFavorite,
    this.source,
    this.fadl,
    this.onFavoriteToggle,
    this.value,
    this.unit,
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
    Widget? trailing,
    Color? primaryColor,
    Color? backgroundColor,
    List<Color>? gradientColors,
    double? borderRadius,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    List<CardAction>? actions,
    bool? showShadow,
    int? currentCount,
    int? totalCount,
    bool? isFavorite,
    String? source,
    String? fadl,
    VoidCallback? onFavoriteToggle,
    String? value,
    String? unit,
  }) {
    return CardProperties(
      type: type ?? this.type,
      style: style ?? this.style,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      content: content ?? this.content,
      child: child ?? this.child,
      icon: icon ?? this.icon,
      trailing: trailing ?? this.trailing,
      primaryColor: primaryColor ?? this.primaryColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      gradientColors: gradientColors ?? this.gradientColors,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      onTap: onTap ?? this.onTap,
      onLongPress: onLongPress ?? this.onLongPress,
      actions: actions ?? this.actions,
      showShadow: showShadow ?? this.showShadow,
      currentCount: currentCount ?? this.currentCount,
      totalCount: totalCount ?? this.totalCount,
      isFavorite: isFavorite ?? this.isFavorite,
      source: source ?? this.source,
      fadl: fadl ?? this.fadl,
      onFavoriteToggle: onFavoriteToggle ?? this.onFavoriteToggle,
      value: value ?? this.value,
      unit: unit ?? this.unit,
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

  /// التحقق من وجود بيانات المعلومات
  bool get hasInfoData {
    return value != null || title != null || icon != null;
  }

  /// التحقق من صحة البطاقة للعرض
  bool get isValid {
    switch (type) {
      case CardType.athkar:
        return hasAthkarData;
      case CardType.info:
        return title != null || subtitle != null || icon != null;
      default:
        return hasContent;
    }
  }
}