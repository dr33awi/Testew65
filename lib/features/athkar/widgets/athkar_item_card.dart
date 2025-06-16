// lib/features/athkar/widgets/athkar_item_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/animations/animated_press.dart';
import '../models/athkar_model.dart';

class AthkarItemCard extends StatelessWidget {
  final AthkarItem item;
  final int currentCount;
  final bool isCompleted;
  final int number;
  final Color? color;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onShare;

  const AthkarItemCard({
    super.key,
    required this.item,
    required this.currentCount,
    required this.isCompleted,
    required this.number,
    this.color,
    required this.onTap,
    required this.onLongPress,
    this.onFavoriteToggle,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? ThemeConstants.primary;
    
    return AnimatedPress(
      onTap: onTap,
      onLongPress: onLongPress,
      scaleFactor: 0.98,
      child: AnimatedContainer(
        duration: ThemeConstants.durationFast,
        decoration: BoxDecoration(
          gradient: isCompleted 
              ? LinearGradient(
                  colors: [
                    effectiveColor.withValues(alpha: 0.05),
                    effectiveColor.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isCompleted ? null : context.cardColor,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          border: Border.all(
            color: effectiveColor.withValues(alpha: isCompleted ? 0.4 : 0.3),
            width: isCompleted ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: effectiveColor.withValues(alpha: isCompleted ? 0.2 : 0.1),
              blurRadius: isCompleted ? 16 : 8,
              offset: const Offset(0, 4),
              spreadRadius: isCompleted ? 1 : 0,
            ),
          ],
        ),
        child: Stack(
          children: [
            // خلفية بسيطة للبطاقات المكتملة
            if (isCompleted)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          effectiveColor.withValues(alpha: 0.05),
                          effectiveColor.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
            
            // مؤشر الإكمال العلوي
            if (isCompleted)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        effectiveColor.lighten(0.1),
                        effectiveColor,
                        effectiveColor.darken(0.1),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(ThemeConstants.radiusXl),
                    ),
                  ),
                ),
              ),
            
            // المحتوى الرئيسي
            Padding(
              padding: const EdgeInsets.all(ThemeConstants.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الرأس
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // رقم الذكر
                      _buildNumberBadge(context),
                      
                      ThemeConstants.space3.w,
                      
                      // محتوى الذكر
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // النص الرئيسي
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(ThemeConstants.space4),
                              decoration: BoxDecoration(
                                color: isCompleted 
                                    ? effectiveColor.withValues(alpha: 0.1)
                                    : context.isDarkMode 
                                        ? effectiveColor.withValues(alpha: 0.08)
                                        : effectiveColor.withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                                border: Border.all(
                                  color: effectiveColor.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                item.text,
                                style: context.bodyLarge?.copyWith(
                                  fontSize: 18,
                                  height: 2.0,
                                  fontFamily: ThemeConstants.fontFamilyArabic,
                                  color: isCompleted 
                                      ? effectiveColor.darken(0.2)
                                      : context.textPrimaryColor,
                                  fontWeight: isCompleted 
                                      ? ThemeConstants.medium 
                                      : ThemeConstants.regular,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            
                            // الفضل
                            if (item.fadl != null) ...[
                              ThemeConstants.space3.h,
                              Container(
                                padding: const EdgeInsets.all(ThemeConstants.space3),
                                decoration: BoxDecoration(
                                  color: ThemeConstants.accent.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                                  border: Border.all(
                                    color: ThemeConstants.accent.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(ThemeConstants.space1),
                                      decoration: BoxDecoration(
                                        color: ThemeConstants.accent.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                                      ),
                                      child: Icon(
                                        Icons.star_rounded,
                                        size: ThemeConstants.iconSm,
                                        color: ThemeConstants.accent,
                                      ),
                                    ),
                                    ThemeConstants.space2.w,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'الفضل',
                                            style: context.labelMedium?.copyWith(
                                              color: ThemeConstants.accent,
                                              fontWeight: ThemeConstants.semiBold,
                                            ),
                                          ),
                                          ThemeConstants.space1.h,
                                          Text(
                                            item.fadl!,
                                            style: context.bodySmall?.copyWith(
                                              color: context.textSecondaryColor,
                                              height: 1.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  ThemeConstants.space4.h,
                  
                  // الفوتر
                  Row(
                    children: [
                      // المصدر
                      if (item.source != null) ...[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: ThemeConstants.space3,
                              vertical: ThemeConstants.space2,
                            ),
                            decoration: BoxDecoration(
                              color: context.textSecondaryColor.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                              border: Border.all(
                                color: context.textSecondaryColor.withValues(alpha: 0.15),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.source_rounded,
                                  size: ThemeConstants.iconXs,
                                  color: context.textSecondaryColor,
                                ),
                                ThemeConstants.space1.w,
                                Flexible(
                                  child: Text(
                                    item.source!,
                                    style: context.labelSmall?.copyWith(
                                      color: context.textSecondaryColor,
                                      fontWeight: ThemeConstants.medium,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ThemeConstants.space3.w,
                      ] else
                        const Spacer(),
                      
                      // العداد
                      _buildCounter(context),
                      
                      // الإجراءات
                      if (onShare != null || onFavoriteToggle != null) ...[
                        ThemeConstants.space3.w,
                        _buildActions(context),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberBadge(BuildContext context) {
    final effectiveColor = color ?? ThemeConstants.primary;
    
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        gradient: isCompleted
            ? LinearGradient(
                colors: [effectiveColor.lighten(0.1), effectiveColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: isCompleted ? null : effectiveColor.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: effectiveColor.withValues(alpha: isCompleted ? 0.6 : 0.3),
          width: isCompleted ? 2 : 1,
        ),
        boxShadow: isCompleted ? [
          BoxShadow(
            color: effectiveColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isCompleted)
            Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: ThemeConstants.iconMd,
            )
          else
            Text(
              '$number',
              style: context.labelLarge?.copyWith(
                color: effectiveColor,
                fontWeight: ThemeConstants.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCounter(BuildContext context) {
    final effectiveColor = color ?? ThemeConstants.primary;
    final progress = currentCount / item.count;
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space3,
        vertical: ThemeConstants.space2,
      ),
      decoration: BoxDecoration(
        gradient: isCompleted
            ? LinearGradient(
                colors: [
                  effectiveColor.withValues(alpha: 0.15),
                  effectiveColor.withValues(alpha: 0.1),
                ],
              )
            : null,
        color: isCompleted ? null : context.surfaceColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        border: Border.all(
          color: isCompleted
              ? effectiveColor.withValues(alpha: 0.3)
              : context.dividerColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // أيقونة التقدم
          SizedBox(
            width: 24,
            height: 24,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // دائرة الخلفية
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: context.dividerColor.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                ),
                
                // دائرة التقدم
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 2,
                    backgroundColor: Colors.transparent,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isCompleted ? effectiveColor : ThemeConstants.primary,
                    ),
                  ),
                ),
                
                // أيقونة الحالة
                if (isCompleted)
                  Icon(
                    Icons.check_rounded,
                    size: 12,
                    color: effectiveColor,
                  )
                else if (currentCount > 0)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: ThemeConstants.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
          
          ThemeConstants.space2.w,
          
          // النص
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$currentCount / ${item.count}',
                style: context.labelMedium?.copyWith(
                  color: isCompleted ? effectiveColor : context.textPrimaryColor,
                  fontWeight: isCompleted ? ThemeConstants.bold : ThemeConstants.medium,
                ),
              ),
              if (!isCompleted && currentCount > 0)
                Text(
                  'اضغط للمتابعة',
                  style: context.labelSmall?.copyWith(
                    color: context.textSecondaryColor,
                    fontSize: 9,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onFavoriteToggle != null) ...[
          _ActionButton(
            icon: Icons.favorite_outline_rounded,
            onTap: onFavoriteToggle!,
            tooltip: 'إضافة للمفضلة',
            color: context.textSecondaryColor,
          ),
        ],
        
        if (onShare != null) ...[
          if (onFavoriteToggle != null) ThemeConstants.space2.w,
          _ActionButton(
            icon: Icons.share_rounded,
            onTap: onShare!,
            tooltip: 'مشاركة',
            color: context.textSecondaryColor,
          ),
        ],
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final Color color;

  const _ActionButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        child: Container(
          padding: const EdgeInsets.all(ThemeConstants.space2),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: ThemeConstants.iconSm,
            color: color,
          ),
        ),
      ),
    );
  }
}