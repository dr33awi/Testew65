// lib/features/tasbih/widgets/dhikr_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../models/dhikr_model.dart';

class DhikrCard extends StatelessWidget {
  final DhikrItem dhikr;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onDelete;
  final bool showFavoriteButton;

  const DhikrCard({
    super.key,
    required this.dhikr,
    required this.isSelected,
    required this.onTap,
    this.onFavoriteToggle,
    this.onDelete,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isSelected 
                ? dhikr.primaryColor.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: isSelected ? 12 : 8,
            offset: Offset(0, isSelected ? 6 : 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: isSelected 
                  ? LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: dhikr.gradient,
                    )
                  : null,
              color: !isSelected ? context.cardColor : null,
              borderRadius: BorderRadius.circular(16),
              border: isSelected 
                  ? Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    )
                  : Border.all(
                      color: context.dividerColor.withValues(alpha: 0.2),
                      width: 1,
                    ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الرأس مع التصنيف والمفضلة
                  Row(
                    children: [
                      // تصنيف الذكر
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Colors.white.withValues(alpha: 0.2)
                              : dhikr.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              dhikr.category.icon,
                              size: 14,
                              color: isSelected 
                                  ? Colors.white
                                  : dhikr.primaryColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              dhikr.isCustom ? 'مخصص' : dhikr.category.title,
                              style: context.labelSmall?.copyWith(
                                color: isSelected 
                                    ? Colors.white
                                    : dhikr.primaryColor,
                                fontWeight: ThemeConstants.medium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // العدد المقترح
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? Colors.white.withValues(alpha: 0.2)
                              : context.textSecondaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${dhikr.recommendedCount}×',
                          style: context.labelSmall?.copyWith(
                            color: isSelected 
                                ? Colors.white
                                : context.textSecondaryColor,
                            fontWeight: ThemeConstants.semiBold,
                          ),
                        ),
                      ),
                      
                      // زر المفضلة
                      if (showFavoriteButton && onFavoriteToggle != null) ...[
                        const SizedBox(width: 8),
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: onFavoriteToggle,
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.favorite_outline, // يجب تغييرها حسب حالة المفضلة
                                size: 20,
                                color: isSelected 
                                    ? Colors.white.withValues(alpha: 0.8)
                                    : context.textSecondaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                      
                      // زر الحذف للأذكار المخصصة
                      if (dhikr.isCustom && onDelete != null) ...[
                        const SizedBox(width: 8),
                        Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            onTap: onDelete,
                            borderRadius: BorderRadius.circular(20),
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                Icons.delete_outline,
                                size: 20,
                                color: isSelected 
                                    ? Colors.white.withValues(alpha: 0.8)
                                    : ThemeConstants.error,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  ThemeConstants.space3.h,
                  
                  // نص الذكر
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Colors.white.withValues(alpha: 0.15)
                          : dhikr.primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                            ? Colors.white.withValues(alpha: 0.3)
                            : dhikr.primaryColor.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Text(
                      dhikr.text,
                      style: context.bodyLarge?.copyWith(
                        color: isSelected 
                            ? Colors.white
                            : context.textPrimaryColor,
                        fontWeight: ThemeConstants.medium,
                        height: 1.8,
                        fontFamily: ThemeConstants.fontFamilyArabic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  // الترجمة (إذا وُجدت)
                  if (dhikr.translation != null) ...[
                    ThemeConstants.space2.h,
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Colors.white.withValues(alpha: 0.1)
                            : context.textSecondaryColor.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        dhikr.translation!,
                        style: context.bodySmall?.copyWith(
                          color: isSelected 
                              ? Colors.white.withValues(alpha: 0.8)
                              : context.textSecondaryColor,
                          fontStyle: FontStyle.italic,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                  
                  // الفضل (إذا وُجد)
                  if (dhikr.virtue != null) ...[
                    ThemeConstants.space3.h,
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Colors.white.withValues(alpha: 0.1)
                            : ThemeConstants.accent.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected 
                              ? Colors.white.withValues(alpha: 0.2)
                              : ThemeConstants.accent.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: isSelected 
                                ? Colors.white
                                : ThemeConstants.accent,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الفضل',
                                  style: context.labelSmall?.copyWith(
                                    color: isSelected 
                                        ? Colors.white
                                        : ThemeConstants.accent,
                                    fontWeight: ThemeConstants.semiBold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  dhikr.virtue!,
                                  style: context.bodySmall?.copyWith(
                                    color: isSelected 
                                        ? Colors.white.withValues(alpha: 0.8)
                                        : context.textSecondaryColor,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  // مؤشر الاختيار
                  if (isSelected) ...[
                    ThemeConstants.space3.h,
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'مُحدد حالياً',
                            style: context.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: ThemeConstants.semiBold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}