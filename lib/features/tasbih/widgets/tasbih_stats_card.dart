// lib/features/tasbih/widgets/tasbih_stats_card.dart

import 'package:flutter/material.dart';
import '../../../app/themes/index.dart';

class TasbihStatsCard extends StatelessWidget {
  final int dailyCount;
  final int totalCount;
  final int dailyGoal;
  final double dailyGoalProgress;
  final bool isDailyGoalAchieved;
  final int currentStreak;
  final int longestStreak;

  const TasbihStatsCard({
    super.key,
    required this.dailyCount,
    required this.totalCount,
    required this.dailyGoal,
    required this.dailyGoalProgress,
    required this.isDailyGoalAchieved,
    required this.currentStreak,
    required this.longestStreak,
  });

  @override
  Widget build(BuildContext context) {
    return IslamicCard(
      gradient: isDailyGoalAchieved
          ? LinearGradient(
              colors: [
                context.successColor.withValues(alpha: 0.1),
                context.successColor.withValues(alpha: 0.05),
              ],
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDailyGoalAchieved
                        ? [context.successColor, context.successColor.darken(0.2)]
                        : [context.primaryColor, context.primaryColor.darken(0.2)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isDailyGoalAchieved ? Icons.emoji_events : Icons.today,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Spaces.smallH,
              Text(
                'الإحصائيات اليومية',
                style: context.titleStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              if (isDailyGoalAchieved)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: context.successColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'تم تحقيق الهدف!',
                    style: context.captionStyle.copyWith(
                      color: context.successColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          
          Spaces.medium,
          
          // شريط التقدم للهدف اليومي
          _buildDailyGoalProgress(context),
          
          Spaces.medium,
          
          // الإحصائيات الرئيسية
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'اليوم',
                  dailyCount.toString(),
                  Icons.today,
                  context.primaryColor,
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: _buildStatItem(
                  context,
                  'الإجمالي',
                  _formatNumber(totalCount),
                  Icons.all_inclusive,
                  context.infoColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          // السلاسل المتتالية
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'السلسلة الحالية',
                  '$currentStreak ${_getDaysLabel(currentStreak)}',
                  Icons.local_fire_department,
                  context.warningColor,
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: _buildStatItem(
                  context,
                  'أطول سلسلة',
                  '$longestStreak ${_getDaysLabel(longestStreak)}',
                  Icons.star,
                  context.secondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDailyGoalProgress(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'الهدف اليومي',
              style: context.bodyStyle.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$dailyCount / $dailyGoal',
              style: context.bodyStyle.copyWith(
                color: isDailyGoalAchieved 
                    ? context.successColor 
                    : context.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        
        Spaces.small,
        
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: context.borderColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: MediaQuery.of(context).size.width * 0.8 * dailyGoalProgress,
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDailyGoalAchieved
                        ? [context.successColor, context.successColor.lighten(0.2)]
                        : [context.primaryColor, context.primaryColor.lighten(0.2)],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
        
        Spaces.small,
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(dailyGoalProgress * 100).toStringAsFixed(0)}% مكتمل',
              style: context.captionStyle.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
            if (!isDailyGoalAchieved)
              Text(
                'باقي ${dailyGoal - dailyCount}',
                style: context.captionStyle.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: color,
                size: 18,
              ),
              Spaces.smallH,
              Text(
                label,
                style: context.captionStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Spaces.small,
          Text(
            value,
            style: context.titleStyle.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number < 1000) return number.toString();
    if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(1)}ك';
    }
    return '${(number / 1000000).toStringAsFixed(1)}م';
  }

  String _getDaysLabel(int days) {
    if (days == 0) return '';
    if (days == 1) return 'يوم';
    if (days == 2) return 'يومان';
    if (days <= 10) return 'أيام';
    return 'يوماً';
  }
}