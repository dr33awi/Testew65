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
      margin: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space3,
      ),
      child: AppCard(
        padding: const EdgeInsets.all(ThemeConstants.space5),
        style: CardStyle.elevated,
        elevation: 4,
        child: Column(
          children: [
            // الرأس
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(ThemeConstants.space2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      ),
                      child: Icon(
                        Icons.trending_up_rounded,
                        color: color,
                        size: ThemeConstants.iconMd,
                      ),
                    ),
                    ThemeConstants.space3.w,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'التقدم الإجمالي',
                          style: context.titleMedium?.copyWith(
                            fontWeight: ThemeConstants.semiBold,
                          ),
                        ),
                        Text(
                          'استمر في التقدم والأجر',
                          style: context.bodySmall?.copyWith(
                            color: context.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                
                // النسبة المئوية
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space3,
                    vertical: ThemeConstants.space2,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                    border: Border.all(
                      color: color.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    '$progress%',
                    style: context.titleLarge?.copyWith(
                      color: color,
                      fontWeight: ThemeConstants.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            ThemeConstants.space4.h,
            
            // شريط التقدم المحسن
            Container(
              height: 12,
              decoration: BoxDecoration(
                color: context.dividerColor.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
              ),
              child: Stack(
                children: [
                  // الخلفية مع تدرج خفيف
                  Container(
                    height: 12,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          context.isDarkMode 
                              ? Colors.white.withValues(alpha: 0.05)
                              : Colors.black.withValues(alpha: 0.05),
                          Colors.transparent,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                    ),
                  ),
                  
                  // شريط التقدم
                  AnimatedContainer(
                    duration: ThemeConstants.durationSlow,
                    curve: ThemeConstants.curveDefault,
                    height: 12,
                    width: (MediaQuery.of(context).size.width - (ThemeConstants.space4 * 2) - (ThemeConstants.space5 * 2)) * (progress / 100),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.lighten(0.1),
                          color,
                          color.darken(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                      boxShadow: [
                        BoxShadow(
                          color: color.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  
                  // تأثير لمعان
                  AnimatedContainer(
                    duration: ThemeConstants.durationSlow,
                    curve: ThemeConstants.curveDefault,
                    height: 12,
                    width: (MediaQuery.of(context).size.width - (ThemeConstants.space4 * 2) - (ThemeConstants.space5 * 2)) * (progress / 100),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.2),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                    ),
                  ),
                ],
              ),
            ),
            
            ThemeConstants.space4.h,
            
            // الإحصائيات
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.check_circle_rounded,
                    label: 'مكتمل',
                    value: '$completedCount',
                    color: ThemeConstants.success,
                  ),
                ),
                
                ThemeConstants.space3.w,
                
                Expanded(
                  child: _StatCard(
                    icon: Icons.pending_rounded,
                    label: 'متبقي',
                    value: '${totalCount - completedCount}',
                    color: ThemeConstants.warning,
                  ),
                ),
                
                ThemeConstants.space3.w,
                
                Expanded(
                  child: _StatCard(
                    icon: Icons.list_rounded,
                    label: 'الكل',
                    value: '$totalCount',
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: ThemeConstants.iconMd,
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
      ),
    );
  }
}