// lib/features/home/widgets/welcome_message.dart - مُحدث بالـ widgets الموحدة
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
    
    // ✅ استخدام AppCard الموحد للترحيب
    return AppCard(
      style: CardStyle.gradient,
      primaryColor: context.primaryColor,
      gradientColors: context.getTimeBasedGradient(dateTime: now).colors
          .map((c) => c.withValues(alpha: 0.9)).toList(),
      borderRadius: ThemeConstants.radius3xl,
      padding: const EdgeInsets.all(ThemeConstants.space6),
      showShadow: true,
      // محتوى مخصص للترحيب
      child: Row(
        children: [
          // الأيقونة
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: ThemeConstants.icon2xl,
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space5),
          
          // النصوص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // التحية
                Text(
                  greeting,
                  style: context.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                    shadows: const [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: ThemeConstants.space2),
                
                // الرسالة
                Text(
                  message,
                  style: context.bodyLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.95),
                    height: 1.5,
                    fontWeight: ThemeConstants.medium,
                  ),
                ),
                
                const SizedBox(height: ThemeConstants.space4),
                
                // معلومات الوقت والتاريخ
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
                      // أيقونة الوقت
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
                      
                      const SizedBox(width: ThemeConstants.space2),
                      
                      // الوقت
                      Text(
                        timeStr,
                        style: context.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: ThemeConstants.bold,
                        ),
                      ),
                      
                      const SizedBox(width: ThemeConstants.space3),
                      
                      // التاريخ
                      Text(
                        dateStr,
                        style: context.labelMedium?.copyWith(
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
      return 'وقت مبارك للقيام والدعاء والاستغفار';
    } else if (hour < 8) {
      return 'ابدأ يومك بأذكار الصباح وصلاة الفجر';
    } else if (hour < 12) {
      return 'وقت مناسب لقراءة القرآن والذكر';
    } else if (hour < 15) {
      return 'استمر في الذكر واغتنم هذا الوقت المبارك';
    } else if (hour < 18) {
      return 'حان وقت أذكار المساء والاستغفار';
    } else if (hour < 21) {
      return 'وقت الدعاء والتسبيح والحمد';
    } else {
      return 'استعد للنوم بأذكار النوم والوتر';
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