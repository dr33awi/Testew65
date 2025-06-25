// lib/app/themes/widgets/cards/app_card.dart - تصميم حديث محدث
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../theme_constants.dart';
import '../../core/theme_extensions.dart';

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

/// بطاقة موحدة لجميع الاستخدامات - تصميم حديث
class AppCard extends StatelessWidget {
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

  const AppCard({
    super.key,
    this.type = CardType.normal,
    this.style = CardStyle.gradient,
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

  @override
  Widget build(BuildContext context) {
    return _buildCard(context);
  }

  Widget _buildCard(BuildContext context) {
    final effectiveColor = primaryColor ?? context.primaryColor;
    final effectiveBorderRadius = borderRadius ?? ThemeConstants.radiusLg;
    
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space2,
      ),
      child: _buildCardContainer(context, effectiveColor, effectiveBorderRadius),
    );
  }

  Widget _buildCardContainer(BuildContext context, Color effectiveColor, double effectiveBorderRadius) {
    final gradientColors = _getGradientColors(context, effectiveColor);
    
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          boxShadow: showShadow ? [
            BoxShadow(
              color: effectiveColor.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: -5,
            ),
          ] : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(effectiveBorderRadius),
          child: Stack(
            children: [
              // الخلفية المتدرجة
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors.map((c) => 
                      c.withValues(alpha: 0.95)
                    ).toList(),
                  ),
                ),
              ),
              
              // تأثير التلميع المتحرك (فقط للكارد المهمة)
              if (type == CardType.athkar || type == CardType.quote)
                _buildShimmerEffect(),
              
              // الطبقة الزجاجية
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
              
              // المحتوى الرئيسي
              Padding(
                padding: padding ?? const EdgeInsets.all(ThemeConstants.space5),
                child: _buildContent(context),
              ),
              
              // تأثير التفاعل
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  onLongPress: onLongPress,
                  borderRadius: BorderRadius.circular(effectiveBorderRadius),
                  splashColor: Colors.white.withValues(alpha: 0.2),
                  highlightColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              
              // عناصر إضافية
              if (badge != null) _buildBadge(context),
              if (isSelected) _buildSelectionIndicator(context),
              _buildDecorativeElements(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: -2.0, end: 2.0),
      duration: const Duration(seconds: 3),
      builder: (context, value, child) {
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
                (value - 0.3).clamp(0.0, 1.0),
                value.clamp(0.0, 1.0),
                (value + 0.3).clamp(0.0, 1.0),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDecorativeElements() {
    return Positioned.fill(
      child: Stack(
        children: [
          // دائرة زخرفية علوية
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
          ),
          
          // دائرة زخرفية سفلية
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ),
          ),
          
          // نقاط صغيرة متناثرة
          Positioned(
            top: 20,
            left: 30,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ),
          
          Positioned(
            bottom: 40,
            right: 50,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getGradientColors(BuildContext context, Color color) {
    if (gradientColors != null && gradientColors!.isNotEmpty) {
      return gradientColors!;
    }
    
    switch (style) {
      case CardStyle.gradient:
        return [color, color.darken(0.2)];
      case CardStyle.glassmorphism:
        return [
          color.withValues(alpha: 0.3),
          color.withValues(alpha: 0.1),
        ];
      case CardStyle.outlined:
      case CardStyle.elevated:
      case CardStyle.normal:
        return [
          color.withValues(alpha: 0.8),
          color.withValues(alpha: 0.6),
        ];
    }
  }

  Widget _buildContent(BuildContext context) {
    if (child != null) return child!;
    
    switch (type) {
      case CardType.athkar:
        return _buildAthkarContent(context);
      case CardType.quote:
        return _buildQuoteContent(context);
      case CardType.completion:
        return _buildCompletionContent(context);
      case CardType.info:
        return _buildInfoContent(context);
      case CardType.stat:
        return _buildStatContent(context);
      case CardType.normal:
        return _buildNormalContent(context);
    }
  }

  Widget _buildNormalContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null || leading != null || trailing != null)
          _buildHeader(context),
        if (subtitle != null) ...[
          if (title != null) const SizedBox(height: ThemeConstants.space2),
          Text(
            subtitle!,
            style: context.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
              fontWeight: ThemeConstants.medium,
              letterSpacing: 0.2,
            ),
          ),
        ],
        if (content != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          Text(
            content!,
            style: context.bodyLarge?.copyWith(
              color: Colors.white,
              fontSize: 16,
              height: 1.6,
              letterSpacing: 0.3,
            ),
          ),
        ],
        if (actions != null && actions!.isNotEmpty) ...[
          const SizedBox(height: ThemeConstants.space4),
          _buildActions(context),
        ],
      ],
    );
  }

  Widget _buildAthkarContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // الرأس مع العداد والأيقونات
        _buildAthkarHeader(context),
        
        const SizedBox(height: ThemeConstants.space3),
        
        // محتوى الذكر
        _buildAthkarBody(context),
        
        // المصدر
        if (source != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          _buildSource(context),
        ],
        
        // الفضل إن وُجد
        if (fadl != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          _buildFadlSection(context),
        ],
      ],
    );
  }

  Widget _buildQuoteContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (subtitle != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space3,
              vertical: ThemeConstants.space1,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Text(
              subtitle!,
              style: context.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ),
        
        if (subtitle != null) const SizedBox(height: ThemeConstants.space3),
        
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(ThemeConstants.space4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // علامة اقتباس في البداية
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(
                  Icons.format_quote,
                  size: 20,
                  color: Colors.white54,
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: ThemeConstants.space2),
                child: Text(
                  content ?? title ?? '',
                  textAlign: TextAlign.center,
                  style: context.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    height: 1.8,
                    fontWeight: ThemeConstants.medium,
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),
              
              // علامة اقتباس في النهاية
              Positioned(
                bottom: 0,
                left: 0,
                child: Transform.rotate(
                  angle: 3.14159,
                  child: const Icon(
                    Icons.format_quote,
                    size: 20,
                    color: Colors.white54,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        if (source != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          _buildSource(context),
        ],
      ],
    );
  }

  Widget _buildCompletionContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // الأيقونة المتحركة
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  icon ?? Icons.check_circle_outline,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            );
          },
        ),
        
        const SizedBox(height: ThemeConstants.space5),
        
        // العنوان
        if (title != null)
          Text(
            title!,
            style: context.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
              shadows: const [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        
        if (content != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          Text(
            content!,
            textAlign: TextAlign.center,
            style: context.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
        
        if (subtitle != null) ...[
          const SizedBox(height: ThemeConstants.space2),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            style: context.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
          ),
        ],
        
        if (actions != null && actions!.isNotEmpty) ...[
          const SizedBox(height: ThemeConstants.space6),
          _buildActions(context),
        ],
      ],
    );
  }

  Widget _buildInfoContent(BuildContext context) {
    return Row(
      children: [
        if (icon != null)
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
        
        if (icon != null) const SizedBox(width: ThemeConstants.space4),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: context.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                    fontSize: 18,
                    letterSpacing: 0.3,
                  ),
                ),
              if (subtitle != null) ...[
                const SizedBox(height: ThemeConstants.space1),
                Text(
                  subtitle!,
                  style: context.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: ThemeConstants.medium,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        if (trailing != null) trailing!,
      ],
    );
  }

  Widget _buildStatContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space2),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            if (onTap != null)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
          ],
        ),
        
        const SizedBox(height: ThemeConstants.space3),
        
        if (value != null)
          Text(
            value!,
            style: context.headlineLarge?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
              shadows: const [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        
        if (title != null) ...[
          const SizedBox(height: ThemeConstants.space1),
          Text(
            title!,
            style: context.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
              fontWeight: ThemeConstants.medium,
            ),
          ),
        ],
        
        if (progress != null) ...[
          const SizedBox(height: ThemeConstants.space3),
          ClipRRect(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            child: LinearProgressIndicator(
              value: progress!,
              minHeight: 6,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        if (leading != null)
          leading!
        else if (icon != null)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
        
        if ((leading != null || icon != null) && title != null)
          const SizedBox(width: ThemeConstants.space3),
        
        if (title != null)
          Expanded(
            child: Text(
              title!,
              style: context.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.bold,
                fontSize: 18,
                letterSpacing: 0.3,
                shadows: const [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        
        if (trailing != null) trailing!,
      ],
    );
  }

  Widget _buildAthkarHeader(BuildContext context) {
    return Row(
      children: [
        // عداد التكرار
        if (currentCount != null && totalCount != null)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Text(
              '${currentCount}/${totalCount}',
              style: context.labelMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        
        const Spacer(),
        
        // أيقونات الإجراءات
        if (actions != null && actions!.isNotEmpty)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: actions!.map((action) => 
              Container(
                margin: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  onPressed: action.onPressed,
                  icon: Icon(action.icon),
                  iconSize: 20,
                  color: Colors.white,
                  tooltip: action.label,
                ),
              ),
            ).toList(),
          ),
      ],
    );
  }

  Widget _buildAthkarBody(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeConstants.space5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Text(
        content ?? title ?? '',
        textAlign: TextAlign.center,
        style: context.bodyLarge?.copyWith(
          color: Colors.white,
          fontSize: 20,
          fontFamily: ThemeConstants.fontFamilyArabic,
          fontWeight: ThemeConstants.semiBold,
          height: 2.0,
          letterSpacing: 0.5,
          shadows: const [
            Shadow(
              color: Colors.black26,
              offset: Offset(0, 1),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSource(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space4,
          vertical: ThemeConstants.space2,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.4),
            width: 1,
          ),
        ),
        child: Text(
          source!,
          style: context.labelLarge?.copyWith(
            color: Colors.white,
            fontWeight: ThemeConstants.semiBold,
          ),
        ),
      ),
    );
  }

  Widget _buildFadlSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.star_outline,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: ThemeConstants.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الفضل',
                  style: context.labelMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  fadl!,
                  style: context.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.5,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    if (type == CardType.completion) {
      return Column(
        children: actions!.map((action) => Padding(
          padding: const EdgeInsets.only(bottom: ThemeConstants.space3),
          child: _buildActionButton(context, action, fullWidth: true),
        )).toList(),
      );
    }
    
    return Wrap(
      spacing: ThemeConstants.space2,
      runSpacing: ThemeConstants.space2,
      children: actions!.map((action) => _buildActionButton(context, action)).toList(),
    );
  }

  Widget _buildActionButton(BuildContext context, CardAction action, {bool fullWidth = false}) {
    if (action.isPrimary) {
      return SizedBox(
        width: fullWidth ? double.infinity : null,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                action.onPressed();
              },
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space4,
                  vertical: ThemeConstants.space3,
                ),
                child: Row(
                  mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      action.icon,
                      size: 18,
                      color: primaryColor ?? context.primaryColor,
                    ),
                    const SizedBox(width: ThemeConstants.space2),
                    Text(
                      action.label,
                      style: context.labelMedium?.copyWith(
                        color: primaryColor ?? context.primaryColor,
                        fontWeight: ThemeConstants.semiBold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          action.onPressed();
        },
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space3,
            vertical: ThemeConstants.space2,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                action.icon,
                color: Colors.white,
                size: 16,
              ),
              const SizedBox(width: ThemeConstants.space2),
              Text(
                action.label,
                style: context.labelMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.semiBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context) {
    return Positioned(
      top: ThemeConstants.space2,
      left: ThemeConstants.space2,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space3,
          vertical: ThemeConstants.space1,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          badge!,
          style: context.labelSmall?.copyWith(
            color: primaryColor ?? context.primaryColor,
            fontWeight: ThemeConstants.semiBold,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionIndicator(BuildContext context) {
    return Positioned(
      top: ThemeConstants.space2,
      right: ThemeConstants.space2,
      child: Container(
        padding: const EdgeInsets.all(ThemeConstants.space1),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.check,
          color: primaryColor ?? context.primaryColor,
          size: 16,
        ),
      ),
    );
  }

  // Factory constructors
  factory AppCard.simple({
    required String title,
    String? subtitle,
    IconData? icon,
    VoidCallback? onTap,
    Color? primaryColor,
  }) {
    return AppCard(
      type: CardType.normal,
      style: CardStyle.gradient,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      primaryColor: primaryColor,
    );
  }

  factory AppCard.athkar({
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
    return AppCard(
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

  factory AppCard.quote({
    required String quote,
    String? author,
    String? category,
    Color? primaryColor,
    List<Color>? gradientColors,
  }) {
    return AppCard(
      type: CardType.quote,
      style: CardStyle.gradient,
      content: quote,
      source: author,
      subtitle: category,
      primaryColor: primaryColor,
      gradientColors: gradientColors,
    );
  }

  factory AppCard.completion({
    required String title,
    required String message,
    String? subMessage,
    IconData icon = Icons.check_circle_outline,
    Color? primaryColor,
    List<CardAction> actions = const [],
  }) {
    return AppCard(
      type: CardType.completion,
      title: title,
      content: message,
      subtitle: subMessage,
      icon: icon,
      primaryColor: primaryColor,
      actions: actions,
      style: CardStyle.gradient,
      padding: const EdgeInsets.all(ThemeConstants.space6),
    );
  }

  factory AppCard.info({
    required String title,
    required String subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Color? iconColor,
    Widget? trailing,
  }) {
    return AppCard(
      type: CardType.info,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      primaryColor: iconColor,
      trailing: trailing,
      style: CardStyle.gradient,
    );
  }

  factory AppCard.stat({
    required String title,
    required String value,
    required IconData icon,
    Color? color,
    VoidCallback? onTap,
    double? progress,
  }) {
    return AppCard(
      type: CardType.stat,
      title: title,
      value: value,
      icon: icon,
      primaryColor: color,
      onTap: onTap,
      progress: progress,
      style: CardStyle.gradient,
    );
  }
}