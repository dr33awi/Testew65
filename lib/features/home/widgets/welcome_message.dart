// lib/features/home/widgets/welcome_message.dart

import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final timeData = _TimeData.current();
    
    return AppCard(
      type: CardType.quote,
      style: CardStyle.gradient,
      content: timeData.message,
      source: timeData.greeting,
      subtitle: timeData.timeString,
      gradientColors: timeData.gradient,
      showShadow: true,
      padding: const EdgeInsets.all(ThemeConstants.space6),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.25),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: Icon(
                  timeData.icon,
                  color: Colors.white,
                  size: ThemeConstants.icon2xl,
                ),
              ),
              
              ThemeConstants.space5.w,
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      timeData.greeting,
                      style: context.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.bold,
                      ).withShadow(),
                    ),
                    
                    ThemeConstants.space2.h,
                    
                    Text(
                      timeData.message,
                      style: context.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.95),
                        height: 1.5,
                        fontWeight: ThemeConstants.medium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          ThemeConstants.space4.h,
          
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space4,
              vertical: ThemeConstants.space2,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space1),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.access_time_rounded,
                    color: Colors.white,
                    size: ThemeConstants.iconSm,
                  ),
                ),
                
                ThemeConstants.space2.w,
                
                Text(
                  timeData.timeString,
                  style: context.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                  ),
                ),
                
                ThemeConstants.space3.w,
                
                Text(
                  timeData.dateString,
                  style: context.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeData {
  final String greeting;
  final String message;
  final IconData icon;
  final List<Color> gradient;
  final String timeString;
  final String dateString;

  const _TimeData({
    required this.greeting,
    required this.message,
    required this.icon,
    required this.gradient,
    required this.timeString,
    required this.dateString,
  });

  factory _TimeData.current() {
    final now = DateTime.now();
    final hour = now.hour;
    
    return _TimeData(
      greeting: _getGreeting(hour),
      message: _getMessage(hour),
      icon: _getIcon(hour),
      gradient: ThemeConstants.getTimeBasedGradient().colors,
      timeString: _formatTime(now),
      dateString: _formatDate(now),
    );
  }

  static String _getGreeting(int hour) {
    if (hour < 5) return 'ليلة مباركة';
    if (hour < 12) return 'صباح الخير';
    if (hour < 17) return 'نهارك سعيد';
    if (hour < 20) return 'مساء النور';
    return 'أمسية مباركة';
  }

  static String _getMessage(int hour) {
    if (hour < 5) return 'وقت مبارك للقيام والدعاء والاستغفار';
    if (hour < 8) return 'ابدأ يومك بأذكار الصباح وصلاة الفجر';
    if (hour < 12) return 'وقت مناسب لقراءة القرآن والذكر';
    if (hour < 15) return 'استمر في الذكر واغتنم هذا الوقت المبارك';
    if (hour < 18) return 'حان وقت أذكار المساء والاستغفار';
    if (hour < 21) return 'وقت الدعاء والتسبيح والحمد';
    return 'استعد للنوم بأذكار النوم والوتر';
  }

  static IconData _getIcon(int hour) {
    if (hour < 5) return Icons.nightlight_round;
    if (hour < 12) return Icons.wb_sunny;
    if (hour < 17) return Icons.light_mode;
    if (hour < 20) return Icons.wb_twilight;
    return Icons.nights_stay;
  }

  static String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }

  static String _formatDate(DateTime date) {
    const arabicMonths = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    const arabicDays = [
      'الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'
    ];
    
    final dayName = arabicDays[date.weekday % 7];
    final day = date.day;
    final month = arabicMonths[date.month - 1];
    
    return '$dayName، $day $month';
  }
}