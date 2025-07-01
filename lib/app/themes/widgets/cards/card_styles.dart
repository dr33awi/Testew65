// lib/app/themes/widgets/cards/card_styles.dart - النسخة المبسطة
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme_constants.dart';
import '../../core/theme_extensions.dart';
import 'card_types.dart';

/// بناء أنماط البطاقات - مبسط
class CardStyleBuilder {
  CardStyleBuilder._();

  /// بناء النمط المطلوب
  static Widget buildStyled({
    required CardProperties properties,
    required Widget content,
    required BuildContext context,
  }) {
    final effectiveColor = properties.primaryColor ?? context.primaryColor;
    final effectiveBorderRadius = properties.borderRadius ?? ThemeConstants.radiusMd;
    
    switch (properties.style) {
      case CardStyle.gradient:
        return GradientCardStyle.build(
          properties: properties,
          content: content,
          context: context,
          color: effectiveColor,
          borderRadius: effectiveBorderRadius,
        );
      case CardStyle.glassmorphism:
        return GlassCardStyle.build(
          properties: properties,
          content: content,
          context: context,
          color: effectiveColor,
          borderRadius: effectiveBorderRadius,
        );
      default:
        return NormalCardStyle.build(
          properties: properties,
          content: content,
          context: context,
          color: effectiveColor,
          borderRadius: effectiveBorderRadius,
        );
    }
  }
}

/// النمط العادي
class NormalCardStyle {
  static Widget build({
    required CardProperties properties,
    required Widget content,
    required BuildContext context,
    required Color color,
    required double borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: properties.backgroundColor ?? context.cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.3),
        ),
        boxShadow: properties.showShadow ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: properties.onTap,
          onLongPress: properties.onLongPress,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: properties.padding ?? const EdgeInsets.all(ThemeConstants.space4),
            child: content,
          ),
        ),
      ),
    );
  }
}

/// النمط المتدرج
class GradientCardStyle {
  static Widget build({
    required CardProperties properties,
    required Widget content,
    required BuildContext context,
    required Color color,
    required double borderRadius,
  }) {
    final colors = properties.gradientColors ?? [color, color.darken(0.2)];
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        boxShadow: properties.showShadow ? [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: properties.onTap,
          onLongPress: properties.onLongPress,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: properties.padding ?? const EdgeInsets.all(ThemeConstants.space4),
            child: content,
          ),
        ),
      ),
    );
  }
}

/// النمط الزجاجي
class GlassCardStyle {
  static Widget build({
    required CardProperties properties,
    required Widget content,
    required BuildContext context,
    required Color color,
    required double borderRadius,
  }) {
    final effectiveGradientColors = properties.gradientColors ?? [
      color.withValues(alpha: 0.95),
      color.darken(0.15).withValues(alpha: 0.90),
      color.darken(0.25).withValues(alpha: 0.85),
    ];
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: effectiveGradientColors,
                stops: effectiveGradientColors.length == 3 
                    ? [0.0, 0.5, 1.0] 
                    : null,
              ),
              boxShadow: properties.showShadow ? [
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ] : null,
            ),
          ),
          
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
          ),
          
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(borderRadius),
            child: InkWell(
              onTap: properties.onTap,
              onLongPress: properties.onLongPress,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Container(
                padding: properties.padding ?? const EdgeInsets.all(ThemeConstants.space4),
                child: content,
              ),
            ),
          ),
        ],
      ),
    );
  }
}