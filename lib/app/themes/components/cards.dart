// lib/app/themes/components/cards.dart
import 'package:athkar_app/app/themes/core/typography.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import '../core/colors.dart';
import '../core/spacing.dart';
import '../core/gradients.dart';
import '../extensions/theme_extensions.dart';

/// نظام البطاقات الموحد للتطبيق الإسلامي
/// يوفر أنواع مختلفة من البطاقات مع تأثيرات بصرية متقدمة
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final AppCardType type;
  final AppCardStyle style;
  final Color? customColor;
  final LinearGradient? customGradient;
  final bool useHero;
  final String? heroTag;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.onTap,
    this.onLongPress,
    this.type = AppCardType.standard,
    this.style = AppCardStyle.elevated,
    this.customColor,
    this.customGradient,
    this.useHero = false,
    this.heroTag,
  });

  /// بطاقة أساسية بسيطة
  factory AppCard.basic({
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
  }) {
    return AppCard(
      type: AppCardType.basic,
      style: AppCardStyle.flat,
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }

  /// بطاقة مرفوعة مع ظل
  factory AppCard.elevated({
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
  }) {
    return AppCard(
      type: AppCardType.standard,
      style: AppCardStyle.elevated,
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }

  /// بطاقة مع تدرج لوني
  factory AppCard.gradient({
    required Widget child,
    required LinearGradient gradient,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
  }) {
    return AppCard(
      type: AppCardType.gradient,
      style: AppCardStyle.gradient,
      customGradient: gradient,
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }

  /// بطاقة بتأثير الزجاج المضبب
  factory AppCard.glass({
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
  }) {
    return AppCard(
      type: AppCardType.glass,
      style: AppCardStyle.glass,
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }

  /// بطاقة للصلوات
  factory AppCard.prayer({
    required Widget child,
    required String prayerName,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
  }) {
    return AppCard(
      type: AppCardType.prayer,
      style: AppCardStyle.gradient,
      customGradient: AppGradients.getPrayerGradient(prayerName),
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }

  /// بطاقة للأذكار
  factory AppCard.athkar({
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
  }) {
    return AppCard(
      type: AppCardType.athkar,
      style: AppCardStyle.gradient,
      customGradient: AppGradients.athkar,
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }

  /// بطاقة للقرآن
  factory AppCard.quran({
    required Widget child,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
  }) {
    return AppCard(
      type: AppCardType.quran,
      style: AppCardStyle.gradient,
      customGradient: AppGradients.tertiary,
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }

  /// بطاقة hero للانتقالات
  factory AppCard.hero({
    required Widget child,
    required String heroTag,
    EdgeInsetsGeometry? padding,
    VoidCallback? onTap,
  }) {
    return AppCard(
      useHero: true,
      heroTag: heroTag,
      padding: padding,
      onTap: onTap,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget cardChild = _buildCardContent(context);

    // تطبيق Hero إذا كان مطلوباً
    if (useHero && heroTag != null) {
      cardChild = Hero(
        tag: heroTag!,
        child: cardChild,
      );
    }

    return cardChild;
  }

  Widget _buildCardContent(BuildContext context) {
    final decoration = _buildDecoration(context);
    final effectivePadding = padding ?? _getDefaultPadding();
    final effectiveMargin = margin ?? _getDefaultMargin();

    Widget content = Container(
      width: width,
      height: height,
      margin: effectiveMargin,
      padding: effectivePadding,
      decoration: decoration,
      child: child,
    );

    // تطبيق تأثير الزجاج المضبب
    if (style == AppCardStyle.glass) {
      content = ClipRRect(
        borderRadius: _getBorderRadius(context),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: content,
        ),
      );
    }

    // تطبيق التفاعل
    if (onTap != null || onLongPress != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: _getBorderRadius(context),
          splashColor: _getSplashColor(context),
          highlightColor: _getHighlightColor(context),
          child: content,
        ),
      );
    }

    return content;
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    return BoxDecoration(
      color: _getBackgroundColor(context),
      gradient: _getGradient(context),
      borderRadius: _getBorderRadius(context),
      border: _getBorder(context),
      boxShadow: _getBoxShadow(context),
    );
  }

  Color? _getBackgroundColor(BuildContext context) {
    if (style == AppCardStyle.gradient || style == AppCardStyle.glass) {
      return null;
    }
    
    if (customColor != null) return customColor;
    
    return switch (type) {
      AppCardType.basic => Colors.transparent,
      AppCardType.standard => context.cardColor,
      AppCardType.prayer => null,
      AppCardType.athkar => AppColors.athkarBackground,
      AppCardType.quran => context.cardColor,
      AppCardType.gradient => null,
      AppCardType.glass => context.cardColor.withValues(alpha: 0.1),
    };
  }

  LinearGradient? _getGradient(BuildContext context) {
    if (customGradient != null) return customGradient;
    
    return switch (style) {
      AppCardStyle.gradient => _getTypeGradient(context),
      AppCardStyle.glass => AppGradients.transparent(
        context.cardColor.withValues(alpha: 0.2),
      ),
      _ => null,
    };
  }

  LinearGradient? _getTypeGradient(BuildContext context) {
    return switch (type) {
      AppCardType.prayer => context.primaryGradient,
      AppCardType.athkar => AppGradients.athkar,
      AppCardType.quran => context.tertiaryGradient,
      AppCardType.gradient => context.primaryGradient,
      _ => null,
    };
  }

  BorderRadius _getBorderRadius(BuildContext context) {
    return switch (type) {
      AppCardType.basic => context.radiusMd,
      AppCardType.prayer => context.radiusXl,
      AppCardType.athkar => context.radiusXl,
      AppCardType.quran => context.radiusXl,
      _ => context.radiusXxl,
    };
  }

  Border? _getBorder(BuildContext context) {
    if (style == AppCardStyle.glass) {
      return Border.all(
        color: Colors.white.withValues(alpha: 0.2),
        width: AppSpacing.borderThin,
      );
    }
    
    if (style == AppCardStyle.flat || type == AppCardType.basic) {
      return Border.all(
        color: context.dividerColor.withValues(alpha: 0.3),
        width: AppSpacing.borderThin,
      );
    }
    
    return null;
  }

  List<BoxShadow>? _getBoxShadow(BuildContext context) {
    return switch (style) {
      AppCardStyle.flat => null,
      AppCardStyle.elevated => context.shadowMd,
      AppCardStyle.gradient => _getGradientShadow(context),
      AppCardStyle.glass => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    };
  }

  List<BoxShadow> _getGradientShadow(BuildContext context) {
    final shadowColor = customGradient?.colors.first ?? context.primaryColor;
    return [
      BoxShadow(
        color: shadowColor.withValues(alpha: 0.3),
        blurRadius: 20,
        offset: const Offset(0, 8),
        spreadRadius: 2,
      ),
    ];
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    return switch (type) {
      AppCardType.basic => AppSpacing.allMd,
      AppCardType.prayer => AppSpacing.allLg,
      AppCardType.athkar => AppSpacing.allLg,
      AppCardType.quran => AppSpacing.allLg,
      _ => AppSpacing.allLg,
    };
  }

  EdgeInsetsGeometry _getDefaultMargin() {
    return switch (type) {
      AppCardType.basic => EdgeInsets.zero,
      _ => AppSpacing.allMd,
    };
  }

  Color _getSplashColor(BuildContext context) {
    if (customGradient != null) {
      return customGradient!.colors.first.withValues(alpha: 0.1);
    }
    return context.primaryColor.withValues(alpha: 0.1);
  }

  Color _getHighlightColor(BuildContext context) {
    if (customGradient != null) {
      return customGradient!.colors.first.withValues(alpha: 0.05);
    }
    return context.primaryColor.withValues(alpha: 0.05);
  }
}

/// أنواع البطاقات
enum AppCardType {
  basic,      // بطاقة أساسية
  standard,   // بطاقة عادية
  prayer,     // بطاقة الصلوات
  athkar,     // بطاقة الأذكار
  quran,      // بطاقة القرآن
  gradient,   // بطاقة مع تدرج
  glass,      // بطاقة زجاجية
}

/// أنماط البطاقات
enum AppCardStyle {
  flat,       // مسطحة
  elevated,   // مرفوعة
  gradient,   // تدرج لوني
  glass,      // زجاجية
}

/// بطاقة إحصائيات سريعة
class AppStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;
  final LinearGradient? gradient;
  final VoidCallback? onTap;
  final String? subtitle;

  const AppStatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
    this.gradient,
    this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.primaryColor;
    final effectiveGradient = gradient ?? GradientExtensions(effectiveColor).gradientTo(
      effectiveColor.lighten(0.2),
    );

    return AppCard.gradient(
      gradient: effectiveGradient,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.titleMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ),
              Container(
                padding: AppSpacing.allSm,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: context.radiusMd,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: context.iconMd,
                ),
              ),
            ],
          ),
          AppSpacing.heightMd,
          Text(
            value,
            style: context.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: AppTypography.bold,
            ),
          ),
          if (subtitle != null) ...[
            AppSpacing.heightXs,
            Text(
              subtitle!,
              style: context.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// بطاقة الصلاة مع التفاصيل
class AppPrayerCard extends StatelessWidget {
  final String prayerName;
  final String prayerTime;
  final String? timeRemaining;
  final bool isNext;
  final bool isActive;
  final VoidCallback? onTap;

  const AppPrayerCard({
    super.key,
    required this.prayerName,
    required this.prayerTime,
    this.timeRemaining,
    this.isNext = false,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    context.getPrayerColor(prayerName);
    final prayerIcon = context.getPrayerIcon(prayerName);
    
    return AppCard.prayer(
      prayerName: prayerName,
      onTap: onTap,
      child: Row(
        children: [
          // أيقونة الصلاة
          Container(
            padding: AppSpacing.allMd,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: context.radiusLg,
            ),
            child: Icon(
              prayerIcon,
              color: Colors.white,
              size: context.iconLg,
            ),
          ),
          
          AppSpacing.widthLg,
          
          // تفاصيل الصلاة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      prayerName,
                      style: context.prayerNameStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    if (isNext)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: context.radiusSm,
                        ),
                        child: Text(
                          'التالية',
                          style: context.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: AppTypography.semiBold,
                          ),
                        ),
                      ),
                  ],
                ),
                
                AppSpacing.heightXs,
                
                Text(
                  prayerTime,
                  style: context.prayerTimeStyle.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: AppTypography.size16,
                  ),
                ),
                
                if (timeRemaining != null) ...[
                  AppSpacing.heightXs,
                  Text(
                    'باقي $timeRemaining',
                    style: context.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// بطاقة الآية أو الحديث
class AppIslamicTextCard extends StatelessWidget {
  final String text;
  final String? source;
  final AppIslamicTextType type;
  final VoidCallback? onTap;
  final VoidCallback? onShare;
  final VoidCallback? onBookmark;
  final bool isBookmarked;

  const AppIslamicTextCard({
    super.key,
    required this.text,
    this.source,
    required this.type,
    this.onTap,
    this.onShare,
    this.onBookmark,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = _getTextStyle(context);
    final cardGradient = _getCardGradient(context);
    
    return AppCard.gradient(
      gradient: cardGradient,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // النص الرئيسي
          Container(
            padding: AppSpacing.allLg,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: context.radiusLg,
            ),
            child: Text(
              text,
              style: textStyle,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
          ),
          
          if (source != null) ...[
            AppSpacing.heightMd,
            Text(
              source!,
              style: context.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          
          // أزرار الإجراءات
          if (onShare != null || onBookmark != null) ...[
            AppSpacing.heightMd,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (onShare != null)
                  _buildActionButton(
                    context: context,
                    icon: Icons.share,
                    onTap: onShare!,
                  ),
                
                if (onShare != null && onBookmark != null)
                  AppSpacing.widthMd,
                
                if (onBookmark != null)
                  _buildActionButton(
                    context: context,
                    icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    onTap: onBookmark!,
                    isActive: isBookmarked,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  TextStyle _getTextStyle(BuildContext context) {
    return switch (type) {
      AppIslamicTextType.quran => context.quranTextStyle,
      AppIslamicTextType.hadith => context.hadithTextStyle,
      AppIslamicTextType.dua => context.duaTextStyle,
    };
  }

  LinearGradient _getCardGradient(BuildContext context) {
    return switch (type) {
      AppIslamicTextType.quran => context.tertiaryGradient,
      AppIslamicTextType.hadith => context.secondaryGradient,
      AppIslamicTextType.dua => context.primaryGradient,
    };
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isActive 
            ? Colors.white.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.2),
        borderRadius: context.radiusMd,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
          size: context.iconSm,
        ),
        onPressed: onTap,
        padding: AppSpacing.allSm,
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
      ),
    );
  }
}

/// نوع النص الإسلامي
enum AppIslamicTextType {
  quran,    // قرآن
  hadith,   // حديث
  dua,      // دعاء
}