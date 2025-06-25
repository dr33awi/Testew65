// lib/features/home/widgets/welcome_message.dart - محسن ومضغوط
import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  static const List<String> _arabicMonths = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
  ];
  
  static const List<String> _arabicDays = [
    'الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'
  ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = _getGreeting(hour);
    final message = _getMessage(hour);
    final icon = _getGreetingIcon(hour);
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final dateStr = _getArabicDate(now);
    
    return AppCard(
      style: CardStyle.gradient,
      primaryColor: context.primaryColor,
      gradientColors: context.getTimeBasedGradient(dateTime: now).colors
          .map((c) => c.withValues(alpha: 0.9)).toList(),
      borderRadius: ThemeConstants.radius2xl,
      padding: const EdgeInsets.all(ThemeConstants.space5),
      showShadow: true,
      child: Row(
        children: [
          // الأيقونة
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: ThemeConstants.iconLg,
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space4),
          
          // النصوص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // التحية
                Text(
                  greeting,
                  style: context.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                    height: 1.2,
                  ),
                ),
                
                const SizedBox(height: ThemeConstants.space1),
                
                // الرسالة
                Text(
                  message,
                  style: context.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: ThemeConstants.space3),
                
                // الوقت والتاريخ
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space3,
                    vertical: ThemeConstants.space1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                      
                      const SizedBox(width: ThemeConstants.space1),
                      
                      Text(
                        timeStr,
                        style: context.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: ThemeConstants.bold,
                        ),
                      ),
                      
                      const SizedBox(width: ThemeConstants.space2),
                      
                      Text(
                        dateStr,
                        style: context.labelSmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 5) {
      return 'ليلة مباركة';
    } else if (hour < 12) {
      return 'صباح الخير';
    } else if (hour < 17) {
      return 'نهارك سعيد';
    } else if (hour < 20) {
      return 'مساء النور';
    } else {
      return 'أمسية مباركة';
    }
  }

  String _getMessage(int hour) {
    if (hour < 5) {
      return 'وقت مبارك للقيام والدعاء';
    } else if (hour < 8) {
      return 'ابدأ يومك بأذكار الصباح';
    } else if (hour < 12) {
      return 'وقت مناسب لقراءة القرآن';
    } else if (hour < 15) {
      return 'استمر في الذكر والدعاء';
    } else if (hour < 18) {
      return 'حان وقت أذكار المساء';
    } else if (hour < 21) {
      return 'وقت الدعاء والتسبيح';
    } else {
      return 'استعد بأذكار النوم';
    }
  }

  String _getArabicDate(DateTime date) {
    final dayName = _arabicDays[date.weekday % 7];
    final day = date.day;
    final month = _arabicMonths[date.month - 1];
    
    return '$dayName، $day $month';
  }

  IconData _getGreetingIcon(int hour) {
    if (hour < 5) {
      return Icons.nightlight_round;
    } else if (hour < 12) {
      return Icons.wb_sunny;
    } else if (hour < 17) {
      return Icons.light_mode;
    } else if (hour < 20) {
      return Icons.wb_twilight;
    } else {
      return Icons.nights_stay;
    }
  }
}