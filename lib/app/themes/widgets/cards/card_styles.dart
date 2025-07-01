// lib/app/themes/widgets/cards/card_styles.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../theme_constants.dart';
import '../../core/theme_extensions.dart';
import 'card_types.dart';

/// بناء أنماط البطاقات
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
      case CardStyle.glassWelcome:
        return GlassWelcomeCardStyle.build(
          properties: properties,
          content: content,
          context: context,
          color: effectiveColor,
          borderRadius: effectiveBorderRadius,
        );
      case CardStyle.outlined:
        return OutlinedCardStyle.build(
          properties: properties,
          content: content,
          context: context,
          color: effectiveColor,
          borderRadius: effectiveBorderRadius,
        );
      case CardStyle.elevated:
        return ElevatedCardStyle.build(
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

/// النمط الزجاجي للترحيب مع تأثير التلميع
class GlassWelcomeCardStyle extends StatefulWidget {
  final CardProperties properties;
  final Widget content;
  final Color color;
  final double borderRadius;

  const GlassWelcomeCardStyle({
    super.key,
    required this.properties,
    required this.content,
    required this.color,
    required this.borderRadius,
  });

  static Widget build({
    required CardProperties properties,
    required Widget content,
    required BuildContext context,
    required Color color,
    required double borderRadius,
  }) {
    return GlassWelcomeCardStyle(
      properties: properties,
      content: content,
      color: color,
      borderRadius: borderRadius,
    );
  }

  @override
  State<GlassWelcomeCardStyle> createState() => _GlassWelcomeCardStyleState();
}

class _GlassWelcomeCardStyleState extends State<GlassWelcomeCardStyle>
    with SingleTickerProviderStateMixin {
  AnimationController? _shimmerController;
  Animation<double>? _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _setupShimmerAnimation();
  }

  void _setupShimmerAnimation() {
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController!,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shimmerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveGradientColors = widget.properties.gradientColors ?? [
      widget.color.withValues(alpha: 0.9),
      widget.color.darken(0.2),
    ];
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: effectiveGradientColors.map((c) => 
                  c.withValues(alpha: 0.9)
                ).toList(),
              ),
            ),
          ),
          
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
          ),
          
          Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            child: InkWell(
              onTap: widget.properties.onTap,
              onLongPress: widget.properties.onLongPress,
              borderRadius: BorderRadius.circular(widget.borderRadius),
              splashColor: Colors.white.withValues(alpha: 0.2),
              highlightColor: Colors.white.withValues(alpha: 0.1),
              child: Container(
                padding: widget.properties.padding ?? const EdgeInsets.all(ThemeConstants.space5),
                child: widget.content,
              ),
            ),
          ),
          
          _buildDecorativeElements(),
          
          if (_shimmerAnimation != null)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _shimmerAnimation!,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                        stops: [
                          (_shimmerAnimation!.value - 0.3).clamp(0.0, 1.0),
                          _shimmerAnimation!.value.clamp(0.0, 1.0),
                          (_shimmerAnimation!.value + 0.3).clamp(0.0, 1.0),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDecorativeElements() {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// النمط المحدد
class OutlinedCardStyle {
  static Widget build({
    required CardProperties properties,
    required Widget content,
    required BuildContext context,
    required Color color,
    required double borderRadius,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: properties.backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: color,
          width: 2,
        ),
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

/// النمط المرتفع
class ElevatedCardStyle {
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
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
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