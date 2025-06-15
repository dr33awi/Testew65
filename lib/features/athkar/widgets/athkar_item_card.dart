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
    // استخدام اللون من الثيم إذا لم يتم تمرير لون
    final effectiveColor = color ?? ThemeConstants.primary;
    
    return AnimatedPress(
      onTap: onTap,
      onLongPress: onLongPress,
      scaleFactor: 0.98,
      child: AnimatedContainer(
        duration: ThemeConstants.durationFast,
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          border: Border.all(
            color: isCompleted
                ? effectiveColor.withValues(alpha: 0.3)
                : context.dividerColor.withValues(alpha: 0.5),
            width: isCompleted ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isCompleted
                  ? effectiveColor.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: isCompleted ? 20 : 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // محتوى البطاقة
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
                            Text(
                              item.text,
                              style: context.bodyLarge?.copyWith(
                                fontSize: 18,
                                height: 1.8,
                                fontFamily: ThemeConstants.fontFamilyArabic,
                              ),
                            ),
                            
                            // الفضل
                            if (item.fadl != null) ...[
                              ThemeConstants.space3.h,
                              Container(
                                padding: const EdgeInsets.all(ThemeConstants.space3),
                                decoration: BoxDecoration(
                                  color: ThemeConstants.accentLight.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                                  border: Border.all(
                                    color: ThemeConstants.accent.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      size: ThemeConstants.iconSm,
                                      color: ThemeConstants.accent,
                                    ),
                                    ThemeConstants.space2.w,
                                    Expanded(
                                      child: Text(
                                        item.fadl!,
                                        style: context.bodySmall?.copyWith(
                                          color: context.textSecondaryColor,
                                          height: 1.5,
                                        ),
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
                          child: Text(
                            item.source!,
                            style: context.labelSmall?.copyWith(
                              color: context.textSecondaryColor,
                            ),
                          ),
                        ),
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
            
            // مؤشر الإكمال
            if (isCompleted)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: effectiveColor,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(ThemeConstants.radiusXl),
                    ),
                  ),
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
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: isCompleted
            ? effectiveColor.withValues(alpha: 0.2)
            : ThemeConstants.primaryLight.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: isCompleted
              ? effectiveColor.withValues(alpha: 0.3)
              : ThemeConstants.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Center(
        child: Text(
          '$number',
          style: context.labelLarge?.copyWith(
            color: isCompleted ? effectiveColor : ThemeConstants.primary,
            fontWeight: ThemeConstants.bold,
          ),
        ),
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
        color: isCompleted
            ? effectiveColor.withValues(alpha: 0.1)
            : context.surfaceColor,
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
          AnimatedContainer(
            duration: ThemeConstants.durationFast,
            width: 20,
            height: 20,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 2,
                  backgroundColor: context.dividerColor.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isCompleted ? effectiveColor : ThemeConstants.primary,
                  ),
                ),
                if (isCompleted)
                  Icon(
                    Icons.check,
                    size: 12,
                    color: effectiveColor,
                  ),
              ],
            ),
          ),
          
          ThemeConstants.space2.w,
          
          // النص
          Text(
            '$currentCount / ${item.count}',
            style: context.labelMedium?.copyWith(
              color: isCompleted ? effectiveColor : context.textPrimaryColor,
              fontWeight: isCompleted ? ThemeConstants.bold : ThemeConstants.medium,
            ),
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
            icon: Icons.favorite_outline,
            onTap: onFavoriteToggle!,
            tooltip: 'إضافة للمفضلة',
            color: context.textSecondaryColor,
          ),
        ],
        
        if (onShare != null) ...[
          if (onFavoriteToggle != null) ThemeConstants.space1.w,
          _ActionButton(
            icon: Icons.share_outlined,
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
        child: Padding(
          padding: const EdgeInsets.all(ThemeConstants.space2),
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