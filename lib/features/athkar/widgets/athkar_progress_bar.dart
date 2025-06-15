// lib/features/athkar/widgets/athkar_progress_bar.dart
import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';

class AthkarProgressBar extends StatelessWidget {
  final int progress;
  final Color color;
  final int completedCount;
  final int totalCount;

  const AthkarProgressBar({
    super.key,
    required this.progress,
    required this.color,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        boxShadow: ThemeConstants.shadowSm,
      ),
      child: Column(
        children: [
          // العنوان والنسبة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.timeline_rounded,
                    color: color,
                    size: ThemeConstants.iconMd,
                  ),
                  ThemeConstants.space2.w,
                  Text(
                    'التقدم الإجمالي',
                    style: context.titleMedium?.copyWith(
                      fontWeight: ThemeConstants.semiBold,
                    ),
                  ),
                ],
              ),
              
              // النسبة المئوية
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space3,
                  vertical: ThemeConstants.space1,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                ),
                child: Text(
                  '$progress%',
                  style: context.labelLarge?.copyWith(
                    color: color,
                    fontWeight: ThemeConstants.bold,
                  ),
                ),
              ),
            ],
          ),
          
          ThemeConstants.space3.h,
          
          // شريط التقدم
          AnimatedContainer(
            duration: ThemeConstants.durationNormal,
            height: 8,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
              child: LinearProgressIndicator(
                value: progress / 100,
                backgroundColor: context.dividerColor.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 8,
              ),
            ),
          ),
          
          ThemeConstants.space3.h,
          
          // الإحصائيات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                icon: Icons.check_circle_outline,
                label: 'مكتمل',
                value: '$completedCount',
                color: ThemeConstants.success,
              ),
              
              Container(
                width: 1,
                height: 30,
                color: context.dividerColor,
              ),
              
              _StatItem(
                icon: Icons.pending_outlined,
                label: 'متبقي',
                value: '${totalCount - completedCount}',
                color: ThemeConstants.warning,
              ),
              
              Container(
                width: 1,
                height: 30,
                color: context.dividerColor,
              ),
              
              _StatItem(
                icon: Icons.format_list_numbered,
                label: 'الكل',
                value: '$totalCount',
                color: context.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: ThemeConstants.iconSm,
        ),
        ThemeConstants.space1.h,
        Text(
          value,
          style: context.titleMedium?.copyWith(
            color: color,
            fontWeight: ThemeConstants.bold,
          ),
        ),
        Text(
          label,
          style: context.labelSmall?.copyWith(
            color: context.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}