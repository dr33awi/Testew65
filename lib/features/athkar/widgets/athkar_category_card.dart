// lib/features/athkar/widgets/athkar_category_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/animations/animated_press.dart';
import '../models/athkar_model.dart';
import '../utils/category_utils.dart';

class AthkarCategoryCard extends StatelessWidget {
  final AthkarCategory category;
  final int progress;
  final VoidCallback onTap;

  const AthkarCategoryCard({
    super.key,
    required this.category,
    required this.progress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = progress >= 100;
    final categoryColor = CategoryUtils.getCategoryThemeColor(category.id);
    final categoryIcon = CategoryUtils.getCategoryIcon(category.id);
    final description = CategoryUtils.getCategoryDescription(category.id);
    
    return AnimatedPress(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      scaleFactor: 0.96,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          gradient: CategoryUtils.getCategoryGradient(category.id),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withValues(alpha: 0.25),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: [
            // نمط خلفية بسيط بدون خطوط أو دوائر
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
            
            // محذوف - لا نريد عرض شارة الإكمال
            
            // المحتوى الرئيسي
            Padding(
              padding: const EdgeInsets.all(ThemeConstants.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الأيقونة
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      categoryIcon,
                      color: Colors.white,
                      size: ThemeConstants.iconLg,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // التقدم الدائري
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // معلومات الفئة
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              category.title,
                              style: context.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: ThemeConstants.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            ThemeConstants.space1.h,
                            
                            Text(
                              description,
                              style: context.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                                fontSize: 12,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      
                      ThemeConstants.space3.w,
                      
                      // دائرة التقدم
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // الخلفية
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                            ),
                            
                            // دائرة التقدم
                            SizedBox(
                              width: 44,
                              height: 44,
                              child: CircularProgressIndicator(
                                value: progress / 100,
                                strokeWidth: 3,
                                backgroundColor: Colors.transparent,
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            
                            // النسبة المئوية أو أيقونة الإكمال
                            if (isCompleted)
                              const Icon(
                                Icons.check_rounded,
                                color: Colors.white,
                                size: 20,
                              )
                            else
                              Text(
                                '$progress%',
                                style: context.labelSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: ThemeConstants.bold,
                                  fontSize: 10,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  ThemeConstants.space3.h,
                  
                  // معلومات إضافية
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // عدد الأذكار
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ThemeConstants.space2,
                          vertical: ThemeConstants.space1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.format_list_numbered_rounded,
                              color: Colors.white.withValues(alpha: 0.9),
                              size: ThemeConstants.iconXs,
                            ),
                            ThemeConstants.space1.w,
                            Text(
                              '${category.athkar.length} ذكر',
                              style: context.labelSmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 11,
                                fontWeight: ThemeConstants.medium,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // وقت التنبيه (إذا كان متوفر ومطلوب عرضه)
                      if (category.notifyTime != null && CategoryUtils.shouldShowTime(category.id))
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: ThemeConstants.space2,
                            vertical: ThemeConstants.space1,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                color: Colors.white.withValues(alpha: 0.9),
                                size: ThemeConstants.iconXs,
                              ),
                              ThemeConstants.space1.w,
                              Text(
                                category.notifyTime!.format(context),
                                style: context.labelSmall?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 11,
                                  fontWeight: ThemeConstants.medium,
                                ),
                              ),
                            ],
                          ),
                        ),
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
}