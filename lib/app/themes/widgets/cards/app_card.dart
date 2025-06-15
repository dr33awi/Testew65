// lib/app/themes/widgets/cards/app_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../theme_constants.dart';
import '../../core/theme_extensions.dart';

/// أنواع البطاقات
enum CardType {
  normal,      // بطاقة عادية
  filled,      // بطاقة ممتلئة
  outlined,    // بطاقة بحدود
  elevated,    // بطاقة مرتفعة
  gradient,    // بطاقة بتدرج
  glass,       // بطاقة زجاجية
  interactive, // بطاقة تفاعلية
  image,       // بطاقة بصورة
}

/// أنماط البطاقات الخاصة
enum CardStyle {
  none,
  athkar,      // بطاقة أذكار
  quote,       // بطاقة اقتباس
  stat,        // بطاقة إحصائيات
  info,        // بطاقة معلومات
  feature,     // بطاقة ميزة
  notification,// بطاقة إشعار
  achievement, // بطاقة إنجاز
}

/// إجراءات البطاقة
class CardAction {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final bool isPrimary;
  final bool isDestructive;

  const CardAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
    this.isPrimary = false,
    this.isDestructive = false,
  });
}

/// بطاقة موحدة بتصميم عصري 2025
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
  final String? imagePath;
  final String? imageUrl;
  
  // الألوان والتصميم
  final Color? backgroundColor;
  final List<Color>? gradientColors;
  final Color? borderColor;
  final double? elevation;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? height;
  final double? width;
  
  // التفاعل
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final List<CardAction>? actions;
  
  // خصائص إضافية
  final String? badge;
  final Color? badgeColor;
  final bool isSelected;
  final bool isDisabled;
  final bool animate;
  final Duration? animationDuration;
  final bool showShadow;
  
  // خصائص خاصة بالأنماط
  final String? source;
  final int? count;
  final double? progress;
  final String? value;
  final String? unit;

  const AppCard({
    super.key,
    this.type = CardType.normal,
    this.style = CardStyle.none,
    this.title,
    this.subtitle,
    this.content,
    this.child,
    this.icon,
    this.leading,
    this.trailing,
    this.imagePath,
    this.imageUrl,
    this.backgroundColor,
    this.gradientColors,
    this.borderColor,
    this.elevation,
    this.borderRadius,
    this.padding,
    this.margin,
    this.height,
    this.width,
    this.onTap,
    this.onLongPress,
    this.actions,
    this.badge,
    this.badgeColor,
    this.isSelected = false,
    this.isDisabled = false,
    this.animate = true,
    this.animationDuration,
    this.showShadow = true,
    this.source,
    this.count,
    this.progress,
    this.value,
    this.unit,
  });

  @override
  Widget build(BuildContext context) {
    Widget card = _buildCard(context);
    
    if (animate && !isDisabled) {
      return AnimationConfiguration.synchronized(
        duration: animationDuration ?? ThemeConstants.durationNormal,
        child: SlideAnimation(
          horizontalOffset: 30,
          curve: ThemeConstants.curveSmooth,
          child: FadeInAnimation(
            curve: ThemeConstants.curveDefault,
            child: card,
          ),
        ),
      );
    }
    
    return card;
  }

  Widget _buildCard(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? _getDefaultBorderRadius();
    final effectiveElevation = elevation ?? _getDefaultElevation();
    final effectivePadding = padding ?? _getDefaultPadding();
    final effectiveMargin = margin ?? _getDefaultMargin();
    
    Widget cardContent = _buildContent(context);
    
    // Apply opacity if disabled
    if (isDisabled) {
      cardContent = Opacity(
        opacity: ThemeConstants.opacity50,
        child: cardContent,
      );
    }
    
    // Build container based on type
    switch (type) {
      case CardType.glass:
        return _buildGlassCard(context, cardContent, effectiveBorderRadius, effectiveMargin);
      case CardType.gradient:
        return _buildGradientCard(context, cardContent, effectiveBorderRadius, effectiveMargin);
      case CardType.outlined:
        return _buildOutlinedCard(context, cardContent, effectiveBorderRadius, effectiveMargin);
      case CardType.elevated:
        return _buildElevatedCard(context, cardContent, effectiveBorderRadius, effectiveMargin, effectiveElevation);
      case CardType.filled:
        return _buildFilledCard(context, cardContent, effectiveBorderRadius, effectiveMargin);
      case CardType.interactive:
        return _buildInteractiveCard(context, cardContent, effectiveBorderRadius, effectiveMargin);
      case CardType.image:
        return _buildImageCard(context, cardContent, effectiveBorderRadius, effectiveMargin);
      case CardType.normal:
      default:
        return _buildNormalCard(context, cardContent, effectiveBorderRadius, effectiveMargin);
    }
  }

  Widget _buildNormalCard(BuildContext context, Widget content, double radius, EdgeInsetsGeometry margin) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      child: Material(
        color: backgroundColor ?? context.cardColor,
        borderRadius: BorderRadius.circular(radius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          onLongPress: isDisabled ? null : onLongPress,
          borderRadius: BorderRadius.circular(radius),
          child: content,
        ),
      ),
    );
  }

  Widget _buildFilledCard(BuildContext context, Widget content, double radius, EdgeInsetsGeometry margin) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.primaryColor.withValues(alpha: ThemeConstants.opacity10),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          onLongPress: isDisabled ? null : onLongPress,
          borderRadius: BorderRadius.circular(radius),
          child: content,
        ),
      ),
    );
  }

  Widget _buildOutlinedCard(BuildContext context, Widget content, double radius, EdgeInsetsGeometry margin) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: isSelected 
              ? context.primaryColor 
              : borderColor ?? context.outlineColor,
          width: isSelected ? ThemeConstants.borderMedium : ThemeConstants.borderLight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          onLongPress: isDisabled ? null : onLongPress,
          borderRadius: BorderRadius.circular(radius),
          child: content,
        ),
      ),
    );
  }

  Widget _buildElevatedCard(BuildContext context, Widget content, double radius, EdgeInsetsGeometry margin, double elev) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: showShadow ? BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: ThemeConstants.shadowForElevation(elev),
      ) : null,
      child: Material(
        color: backgroundColor ?? context.cardColor,
        borderRadius: BorderRadius.circular(radius),
        elevation: showShadow ? 0 : elev,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          onLongPress: isDisabled ? null : onLongPress,
          borderRadius: BorderRadius.circular(radius),
          child: content,
        ),
      ),
    );
  }

  Widget _buildGradientCard(BuildContext context, Widget content, double radius, EdgeInsetsGeometry margin) {
    final colors = gradientColors ?? ThemeConstants.primaryGradient;
    
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: showShadow ? ThemeConstants.coloredShadow(colors[0]) : null,
      ),
      child: Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          onLongPress: isDisabled ? null : onLongPress,
          borderRadius: BorderRadius.circular(radius),
          splashColor: Colors.white.withValues(alpha: ThemeConstants.opacity20),
          highlightColor: Colors.white.withValues(alpha: ThemeConstants.opacity10),
          child: content,
        ),
      ),
    );
  }

  Widget _buildGlassCard(BuildContext context, Widget content, double radius, EdgeInsetsGeometry margin) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor?.withValues(alpha: ThemeConstants.opacity10) ?? 
               context.cardColor.withValues(alpha: ThemeConstants.opacity10),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
          width: ThemeConstants.borderLight,
        ),
        boxShadow: showShadow ? [
          BoxShadow(
            color: Colors.black.withValues(alpha: ThemeConstants.opacity10),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ] : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ColorFilter.mode(
            Colors.white.withValues(alpha: ThemeConstants.opacity10),
            BlendMode.overlay,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isDisabled ? null : onTap,
              onLongPress: isDisabled ? null : onLongPress,
              borderRadius: BorderRadius.circular(radius),
              splashColor: Colors.white.withValues(alpha: ThemeConstants.opacity20),
              child: content,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveCard(BuildContext context, Widget content, double radius, EdgeInsetsGeometry margin) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: isSelected ? 1 : 0),
      duration: ThemeConstants.durationFast,
      builder: (context, value, child) {
        return Container(
          width: width,
          height: height,
          margin: margin,
          transform: Matrix4.identity()
            ..scale(1 - (value * 0.02)),
          decoration: BoxDecoration(
            color: Color.lerp(
              backgroundColor ?? context.cardColor,
              context.primaryColor.withValues(alpha: ThemeConstants.opacity10),
              value,
            ),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: Color.lerp(
                Colors.transparent,
                context.primaryColor,
                value,
              )!,
              width: ThemeConstants.borderMedium,
            ),
            boxShadow: showShadow ? [
              BoxShadow(
                color: Color.lerp(
                  Colors.black.withValues(alpha: ThemeConstants.opacity10),
                  context.primaryColor.withValues(alpha: ThemeConstants.opacity30),
                  value,
                )!,
                blurRadius: 20 + (value * 10),
                offset: Offset(0, 10 + (value * 5)),
              ),
            ] : null,
          ),
          child: Material(
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            borderRadius: BorderRadius.circular(radius),
            child: InkWell(
              onTap: isDisabled ? null : onTap,
              onLongPress: isDisabled ? null : onLongPress,
              borderRadius: BorderRadius.circular(radius),
              child: child,
            ),
          ),
        );
      },
      child: content,
    );
  }

  Widget _buildImageCard(BuildContext context, Widget content, double radius, EdgeInsetsGeometry margin) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: showShadow ? ThemeConstants.shadowMd : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                fit: BoxFit.cover,
              )
            else if (imageUrl != null)
              Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: context.surfaceVariant,
                  child: Icon(
                    Icons.broken_image,
                    color: context.textSecondaryColor,
                  ),
                ),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: ThemeConstants.opacity60),
                  ],
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isDisabled ? null : onTap,
                onLongPress: isDisabled ? null : onLongPress,
                child: content,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (child != null) return child!;
    
    switch (style) {
      case CardStyle.athkar:
        return _buildAthkarContent(context);
      case CardStyle.quote:
        return _buildQuoteContent(context);
      case CardStyle.stat:
        return _buildStatContent(context);
      case CardStyle.info:
        return _buildInfoContent(context);
      case CardStyle.feature:
        return _buildFeatureContent(context);
      case CardStyle.notification:
        return _buildNotificationContent(context);
      case CardStyle.achievement:
        return _buildAchievementContent(context);
      case CardStyle.none:
      default:
        return _buildDefaultContent(context);
    }
  }

  Widget _buildDefaultContent(BuildContext context) {
    return Padding(
      padding: padding ?? _getDefaultPadding(),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null || leading != null || trailing != null)
                _buildHeader(context),
              if (subtitle != null) ...[
                if (title != null) ThemeConstants.space2.h,
                Text(
                  subtitle!,
                  style: context.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (content != null) ...[
                ThemeConstants.space3.h,
                Text(
                  content!,
                  style: context.bodyLarge,
                ),
              ],
              if (actions != null && actions!.isNotEmpty) ...[
                ThemeConstants.space4.h,
                _buildActions(context),
              ],
            ],
          ),
          if (badge != null)
            Positioned(
              top: 0,
              right: 0,
              child: _buildBadge(context),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        if (leading != null)
          leading!
        else if (icon != null)
          Container(
            padding: ThemeConstants.space3.all,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: ThemeConstants.opacity10),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Icon(
              icon,
              color: context.primaryColor,
              size: ThemeConstants.iconMd,
            ),
          ),
        
        if ((leading != null || icon != null) && title != null)
          ThemeConstants.space3.w,
        
        if (title != null)
          Expanded(
            child: Text(
              title!,
              style: context.titleMedium?.semiBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        
        if (trailing != null) trailing!,
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    return Wrap(
      spacing: ThemeConstants.space2,
      runSpacing: ThemeConstants.space2,
      children: actions!.map((action) => _buildActionButton(context, action)).toList(),
    );
  }

  Widget _buildActionButton(BuildContext context, CardAction action) {
    final effectiveColor = action.color ?? 
                          (action.isDestructive ? ThemeConstants.error : context.primaryColor);
    
    if (action.isPrimary) {
      return FilledButton.icon(
        onPressed: isDisabled ? null : () {
          HapticFeedback.lightImpact();
          action.onPressed();
        },
        icon: Icon(action.icon, size: ThemeConstants.iconSm),
        label: Text(action.label),
        style: FilledButton.styleFrom(
          backgroundColor: effectiveColor,
          foregroundColor: effectiveColor.contrastingTextColor,
          minimumSize: const Size(0, 40),
          padding: EdgeInsets.symmetric(
            horizontal: ThemeConstants.space4,
            vertical: ThemeConstants.space2,
          ),
        ),
      );
    }
    
    return OutlinedButton.icon(
      onPressed: isDisabled ? null : () {
        HapticFeedback.lightImpact();
        action.onPressed();
      },
      icon: Icon(action.icon, size: ThemeConstants.iconSm),
      label: Text(action.label),
      style: OutlinedButton.styleFrom(
        foregroundColor: effectiveColor,
        side: BorderSide(color: effectiveColor),
        minimumSize: const Size(0, 36),
        padding: EdgeInsets.symmetric(
          horizontal: ThemeConstants.space3,
          vertical: ThemeConstants.space1_5,
        ),
      ),
    );
  }

  Widget _buildBadge(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ThemeConstants.space2,
        vertical: ThemeConstants.space1,
      ),
      decoration: BoxDecoration(
        color: badgeColor ?? context.primaryColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
      ),
      child: Text(
        badge!,
        style: context.labelSmall?.copyWith(
          color: (badgeColor ?? context.primaryColor).contrastingTextColor,
          fontWeight: ThemeConstants.semiBold,
        ),
      ),
    );
  }

  // Style-specific content builders
  Widget _buildAthkarContent(BuildContext context) {
    return Padding(
      padding: padding ?? _getDefaultPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (count != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space3,
                    vertical: ThemeConstants.space1,
                  ),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: ThemeConstants.opacity10),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                  ),
                  child: Text(
                    'التكرار: $count',
                    style: context.labelMedium?.copyWith(
                      color: context.primaryColor,
                      fontWeight: ThemeConstants.semiBold,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          
          if (count != null) ThemeConstants.space3.h,
          
          Container(
            padding: ThemeConstants.space5.all,
            decoration: BoxDecoration(
              color: context.surfaceVariant,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            ),
            child: Text(
              content ?? title ?? '',
              textAlign: TextAlign.center,
              style: context.athkarStyle,
            ),
          ),
          
          if (source != null) ...[
            ThemeConstants.space3.h,
            Center(
              child: Text(
                source!,
                style: context.labelMedium?.copyWith(
                  color: context.textSecondaryColor,
                ),
              ),
            ),
          ],
          
          if (actions != null && actions!.isNotEmpty) ...[
            ThemeConstants.space4.h,
            _buildActions(context),
          ],
        ],
      ),
    );
  }

  Widget _buildQuoteContent(BuildContext context) {
    return Padding(
      padding: padding ?? _getDefaultPadding(),
      child: Column(
        children: [
          Icon(
            Icons.format_quote,
            size: ThemeConstants.icon2xl,
            color: context.primaryColor.withValues(alpha: ThemeConstants.opacity30),
          ),
          ThemeConstants.space3.h,
          Text(
            content ?? title ?? '',
            textAlign: TextAlign.center,
            style: context.titleLarge?.copyWith(
              height: 1.8,
              fontStyle: FontStyle.italic,
            ),
          ),
          if (source != null) ...[
            ThemeConstants.space4.h,
            Text(
              '— $source',
              style: context.labelLarge?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatContent(BuildContext context) {
    return Padding(
      padding: padding ?? _getDefaultPadding(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: context.primaryColor,
              size: ThemeConstants.iconLg,
            ),
          ThemeConstants.space2.h,
          if (value != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value!,
                  style: context.displaySmall?.copyWith(
                    color: context.primaryColor,
                    fontWeight: ThemeConstants.bold,
                  ),
                ),
                if (unit != null) ...[
                  ThemeConstants.space1.w,
                  Text(
                    unit!,
                    style: context.titleMedium?.copyWith(
                      color: context.textSecondaryColor,
                    ),
                  ),
                ],
              ],
            ),
          if (title != null) ...[
            ThemeConstants.space2.h,
            Text(
              title!,
              style: context.titleMedium,
            ),
          ],
          if (progress != null) ...[
            ThemeConstants.space3.h,
            ClipRRect(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
              child: LinearProgressIndicator(
                value: progress!,
                minHeight: 6,
                backgroundColor: context.dividerColor,
                valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoContent(BuildContext context) {
    return Padding(
      padding: padding ?? _getDefaultPadding(),
      child: Row(
        children: [
          if (icon != null)
            Container(
              width: ThemeConstants.avatarMd,
              height: ThemeConstants.avatarMd,
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: ThemeConstants.opacity10),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
              child: Icon(
                icon,
                color: context.primaryColor,
                size: ThemeConstants.iconMd,
              ),
            ),
          
          if (icon != null) ThemeConstants.space3.w,
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: context.titleSmall?.semiBold,
                  ),
                if (subtitle != null) ...[
                  ThemeConstants.space1.h,
                  Text(
                    subtitle!,
                    style: context.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          
          if (trailing != null) trailing!,
        ],
      ),
    );
  }

  Widget _buildFeatureContent(BuildContext context) {
    return Padding(
      padding: padding ?? _getDefaultPadding(),
      child: Column(
        children: [
          if (icon != null)
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors ?? ThemeConstants.primaryGradient,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: ThemeConstants.iconXl,
              ),
            ),
          ThemeConstants.space4.h,
          if (title != null)
            Text(
              title!,
              style: context.titleLarge?.semiBold,
              textAlign: TextAlign.center,
            ),
          if (subtitle != null) ...[
            ThemeConstants.space2.h,
            Text(
              subtitle!,
              style: context.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotificationContent(BuildContext context) {
    Color notifColor;
    IconData notifIcon;
    
    if (icon != null) {
      notifIcon = icon!;
      notifColor = backgroundColor ?? context.primaryColor;
    } else {
      notifIcon = Icons.notifications;
      notifColor = ThemeConstants.info;
    }
    
    return Padding(
      padding: padding ?? _getDefaultPadding(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: ThemeConstants.space2.all,
            decoration: BoxDecoration(
              color: notifColor.withValues(alpha: ThemeConstants.opacity10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              notifIcon,
              color: notifColor,
              size: ThemeConstants.iconSm,
            ),
          ),
          ThemeConstants.space3.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: context.titleSmall?.semiBold,
                  ),
                if (content != null) ...[
                  ThemeConstants.space1.h,
                  Text(
                    content!,
                    style: context.bodyMedium,
                  ),
                ],
                if (subtitle != null) ...[
                  ThemeConstants.space2.h,
                  Text(
                    subtitle!,
                    style: context.labelSmall?.copyWith(
                      color: context.textSecondaryColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }

  Widget _buildAchievementContent(BuildContext context) {
    return Padding(
      padding: padding ?? _getDefaultPadding(),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      ThemeConstants.warning.withValues(alpha: ThemeConstants.opacity30),
                      ThemeConstants.warning.withValues(alpha: ThemeConstants.opacity10),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Icon(
                icon ?? Icons.emoji_events,
                color: ThemeConstants.warning,
                size: ThemeConstants.icon2xl,
              ),
            ],
          ),
          ThemeConstants.space4.h,
          if (title != null)
            Text(
              title!,
              style: context.titleLarge?.bold,
              textAlign: TextAlign.center,
            ),
          if (subtitle != null) ...[
            ThemeConstants.space2.h,
            Text(
              subtitle!,
              style: context.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
          if (actions != null && actions!.isNotEmpty) ...[
            ThemeConstants.space4.h,
            _buildActions(context),
          ],
        ],
      ),
    );
  }

  // Default values getters
  double _getDefaultBorderRadius() {
    switch (type) {
      case CardType.glass:
        return ThemeConstants.radius2xl;
      case CardType.interactive:
      case CardType.image:
        return ThemeConstants.radiusXl;
      default:
        return ThemeConstants.radiusLg;
    }
  }

  double _getDefaultElevation() {
    switch (type) {
      case CardType.elevated:
        return ThemeConstants.elevationLg;
      case CardType.interactive:
        return ThemeConstants.elevationMd;
      default:
        return ThemeConstants.elevationSm;
    }
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    switch (style) {
      case CardStyle.quote:
      case CardStyle.feature:
      case CardStyle.achievement:
        return ThemeConstants.space6.all;
      case CardStyle.athkar:
        return ThemeConstants.space5.all;
      default:
        return ThemeConstants.space4.all;
    }
  }

  EdgeInsetsGeometry _getDefaultMargin() {
    return EdgeInsets.symmetric(
      horizontal: ThemeConstants.space4,
      vertical: ThemeConstants.space2,
    );
  }

  // Factory constructors for common use cases
  factory AppCard.simple({
    required String title,
    String? subtitle,
    String? content,
    IconData? icon,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return AppCard(
      type: CardType.normal,
      title: title,
      subtitle: subtitle,
      content: content,
      icon: icon,
      onTap: onTap,
      trailing: trailing,
    );
  }

  factory AppCard.filled({
    required String title,
    String? subtitle,
    IconData? icon,
    VoidCallback? onTap,
    Color? backgroundColor,
  }) {
    return AppCard(
      type: CardType.filled,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      backgroundColor: backgroundColor,
    );
  }

  factory AppCard.gradient({
    required String title,
    String? subtitle,
    IconData? icon,
    VoidCallback? onTap,
    List<Color>? colors,
  }) {
    return AppCard(
      type: CardType.gradient,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      gradientColors: colors,
    );
  }

  factory AppCard.glass({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
  }) {
    return AppCard(
      type: CardType.glass,
      child: child,
      onTap: onTap,
      padding: padding,
    );
  }

  factory AppCard.athkar({
    required String content,
    String? source,
    int? count,
    VoidCallback? onTap,
    List<CardAction>? actions,
    Widget? trailing,
  }) {
    return AppCard(
      style: CardStyle.athkar,
      content: content,
      source: source,
      count: count,
      onTap: onTap,
      actions: actions,
      trailing: trailing,
    );
  }

  factory AppCard.quote({
    required String quote,
    String? author,
    VoidCallback? onTap,
  }) {
    return AppCard(
      style: CardStyle.quote,
      content: quote,
      source: author,
      onTap: onTap,
    );
  }

  factory AppCard.stat({
    required String title,
    required String value,
    String? unit,
    IconData? icon,
    double? progress,
    VoidCallback? onTap,
  }) {
    return AppCard(
      style: CardStyle.stat,
      title: title,
      value: value,
      unit: unit,
      icon: icon,
      progress: progress,
      onTap: onTap,
    );
  }

  factory AppCard.info({
    required String title,
    String? subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return AppCard(
      style: CardStyle.info,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      trailing: trailing,
    );
  }

  factory AppCard.feature({
    required String title,
    String? subtitle,
    required IconData icon,
    VoidCallback? onTap,
    List<Color>? gradientColors,
  }) {
    return AppCard(
      style: CardStyle.feature,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      gradientColors: gradientColors,
    );
  }

  factory AppCard.notification({
    required String title,
    required String content,
    String? time,
    IconData? icon,
    Color? color,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return AppCard(
      style: CardStyle.notification,
      title: title,
      content: content,
      subtitle: time,
      icon: icon,
      backgroundColor: color,
      onTap: onTap,
      trailing: trailing,
    );
  }

  factory AppCard.achievement({
    required String title,
    String? description,
    IconData? icon,
    List<CardAction>? actions,
  }) {
    return AppCard(
      style: CardStyle.achievement,
      title: title,
      subtitle: description,
      icon: icon,
      actions: actions,
    );
  }

  factory AppCard.image({
    required String? imagePath,
    String? imageUrl,
    required Widget child,
    VoidCallback? onTap,
    double? height,
  }) {
    return AppCard(
      type: CardType.image,
      imagePath: imagePath,
      imageUrl: imageUrl,
      child: child,
      onTap: onTap,
      height: height,
    );
  }
}