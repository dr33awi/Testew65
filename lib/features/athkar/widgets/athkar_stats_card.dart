// lib/features/athkar/widgets/athkar_stats_card.dart
import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';

class AthkarStatsCard extends StatelessWidget {
  final int totalCategories;
  final int completedToday;
  final int streak;
  final VoidCallback? onViewDetails;

  const AthkarStatsCard({
    super.key,
    required this.totalCategories,
    required this.completedToday,
    required this.streak,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        gradient: ThemeConstants.primaryGradient,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // نمط في الخلفية - بدون فقاعات
          Positioned.fill(
            child: CustomPaint(
              painter: _BackgroundPainter(),
            ),
          ),
          
          // المحتوى
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.space5),
            child: Column(
              children: [
                // الرأس
                Row(
                  children: [
                    // الأيقونة
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.insights_rounded,
                        color: Colors.white,
                        size: ThemeConstants.iconLg,
                      ),
                    ),
                    
                    ThemeConstants.space4.w,
                    
                    // العنوان
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'إحصائياتك اليوم',
                            style: context.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: ThemeConstants.bold,
                            ),
                          ),
                          Text(
                            _getMotivationalMessage(),
                            style: context.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                ThemeConstants.space5.h,
                
                // الإحصائيات
                Row(
                  children: [
                    // الأذكار المكتملة
                    Expanded(
                      child: _StatItem(
                        icon: Icons.check_circle_outline,
                        value: '$completedToday/$totalCategories',
                        label: 'أكملت اليوم',
                      ),
                    ),
                    
                    // الفاصل
                    Container(
                      width: 1,
                      height: 50,
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                    
                    // سلسلة الأيام
                    Expanded(
                      child: _StatItem(
                        icon: Icons.local_fire_department_rounded,
                        value: '$streak',
                        label: streak == 1 ? 'يوم متتالي' : 'أيام متتالية',
                        hasStreak: streak > 0,
                      ),
                    ),
                  ],
                ),
                
                if (onViewDetails != null) ...[
                  ThemeConstants.space4.h,
                  
                  // زر عرض التفاصيل
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onViewDetails!,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: context.primaryColor,
                        minimumSize: const Size(0, 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                        ),
                      ),
                      icon: Icon(
                        Icons.arrow_forward,
                        size: ThemeConstants.iconSm,
                        color: context.primaryColor,
                      ),
                      label: Text(
                        'عرض التفاصيل',
                        style: context.labelLarge?.copyWith(
                          color: context.primaryColor,
                          fontWeight: ThemeConstants.semiBold,
                        ),
                      ),
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

  String _getMotivationalMessage() {
    if (completedToday == totalCategories) {
      return 'ما شاء الله! أكملت جميع الأذكار';
    } else if (completedToday > totalCategories / 2) {
      return 'أحسنت! أكمل البقية';
    } else if (completedToday > 0) {
      return 'بداية موفقة، استمر';
    } else {
      return 'ابدأ يومك بالأذكار';
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool hasStreak;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    this.hasStreak = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // الأيقونة مع الحركة للـ streak
        AnimatedContainer(
          duration: ThemeConstants.durationNormal,
          transform: hasStreak
              ? (Matrix4.identity()..scale(1.1))
              : Matrix4.identity(),
          child: Icon(
            icon,
            color: Colors.white,
            size: hasStreak ? ThemeConstants.iconLg : ThemeConstants.iconMd,
          ),
        ),
        
        ThemeConstants.space2.h,
        
        // القيمة
        AnimatedDefaultTextStyle(
          duration: ThemeConstants.durationNormal,
          style: context.headlineSmall!.copyWith(
            color: Colors.white,
            fontWeight: ThemeConstants.bold,
            fontSize: hasStreak ? 28 : 24,
          ),
          child: Text(value),
        ),
        
        // التسمية
        Text(
          label,
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

// رسام الخلفية - بدون فقاعات
class _BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // رسم خطوط قطرية
    const spacing = 30.0;
    
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i - size.height, size.height),
        paint,
      );
    }
    
    // رسم إطار خفيف
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(ThemeConstants.radiusXl)),
      paint..style = PaintingStyle.stroke,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}