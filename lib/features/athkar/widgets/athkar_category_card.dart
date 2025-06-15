// lib/features/athkar/widgets/athkar_category_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/animations/animated_press.dart';
import '../models/athkar_model.dart';

class AthkarCategoryCard extends StatelessWidget {
  final AthkarCategory category;
  final int progress;
  final VoidCallback onTap;
  final VoidCallback? onNotificationToggle;

  const AthkarCategoryCard({
    super.key,
    required this.category,
    required this.progress,
    required this.onTap,
    this.onNotificationToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = progress >= 100;
    
    // استخدام ألوان الثيم بناءً على نوع الفئة
    final themeColor = _getCategoryThemeColor(category.id);
    
    return AnimatedPress(
      onTap: onTap,
      scaleFactor: 0.95,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              themeColor.withValues(alpha: 0.9),
              themeColor,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          boxShadow: [
            BoxShadow(
              color: themeColor.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // نمط في الخلفية
            Positioned.fill(
              child: CustomPaint(
                painter: _PatternPainter(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            
            // المحتوى
            Padding(
              padding: const EdgeInsets.all(ThemeConstants.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الرأس
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // الأيقونة
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                        ),
                        child: Icon(
                          category.icon,
                          color: Colors.white,
                          size: ThemeConstants.iconMd,
                        ),
                      ),
                      
                      // زر التنبيه
                      if (onNotificationToggle != null && category.notifyTime != null)
                        _NotificationButton(
                          onTap: onNotificationToggle!,
                          isEnabled: false, // TODO: الحصول على الحالة الفعلية
                        ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // العنوان
                  Text(
                    category.title,
                    style: context.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                    ),
                  ),
                  
                  // الوصف
                  if (category.description != null) ...[
                    ThemeConstants.space1.h,
                    Text(
                      category.description!,
                      style: context.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  
                  ThemeConstants.space3.h,
                  
                  // شريط التقدم
                  _ProgressBar(
                    progress: progress,
                    isCompleted: isCompleted,
                  ),
                  
                  ThemeConstants.space2.h,
                  
                  // معلومات إضافية
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // عدد الأذكار
                      Row(
                        children: [
                          Icon(
                            Icons.format_list_numbered,
                            color: Colors.white.withValues(alpha: 0.7),
                            size: ThemeConstants.iconXs,
                          ),
                          ThemeConstants.space1.w,
                          Text(
                            '${category.athkar.length} ذكر',
                            style: context.labelSmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                      
                      // وقت التنبيه
                      if (category.notifyTime != null)
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.white.withValues(alpha: 0.7),
                              size: ThemeConstants.iconXs,
                            ),
                            ThemeConstants.space1.w,
                            Text(
                              category.notifyTime!.format(context),
                              style: context.labelSmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // شارة الإكمال
            if (isCompleted)
              Positioned(
                top: ThemeConstants.space2,
                left: ThemeConstants.space2,
                child: Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.check,
                    color: category.color,
                    size: ThemeConstants.iconSm,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// زر التنبيه
class _NotificationButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isEnabled;

  const _NotificationButton({
    required this.onTap,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.2),
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
            isEnabled
                ? Icons.notifications_active
                : Icons.notifications_off_outlined,
            color: Colors.white,
            size: ThemeConstants.iconSm,
          ),
        ),
      ),
    );
  }
}

// شريط التقدم
class _ProgressBar extends StatelessWidget {
  final int progress;
  final bool isCompleted;

  const _ProgressBar({
    required this.progress,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // النسبة المئوية
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isCompleted ? 'مكتمل' : 'التقدم',
              style: context.labelSmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontWeight: ThemeConstants.medium,
              ),
            ),
            Text(
              '$progress%',
              style: context.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.bold,
              ),
            ),
          ],
        ),
        
        ThemeConstants.space1.h,
        
        // الشريط
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(2),
          ),
          child: AnimatedFractionallySizedBox(
            duration: ThemeConstants.durationNormal,
            widthFactor: progress / 100,
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// رسام النمط
class _PatternPainter extends CustomPainter {
  final Color color;

  _PatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const radius = 40.0;
    
    // رسم دوائر منتشرة
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.1),
      radius,
      paint,
    );
    
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.8),
      radius * 0.7,
      paint,
    );
    
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      radius * 0.5,
      paint..color = color.withValues(alpha: 0.05),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}