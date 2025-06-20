// lib/features/home/widgets/welcome_message.dart
import 'package:flutter/material.dart';
import 'dart:ui';

// ✅ استيراد النظام المبسط الجديد فقط
import '../../../app/themes/index.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = _getGreeting(hour);
    final message = _getMessage(hour);
    final gradient = _getGradientColors(hour);
    
    return IslamicCard.gradient(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradient.map((c) => c.withValues(alpha: 0.9)).toList(),
      ),
      child: _buildContent(context, greeting, message),
    );
  }

  Widget _buildContent(BuildContext context, String greeting, String message) {
    final hour = DateTime.now().hour;
    final icon = _getGreetingIcon(hour);
    
    return Row(
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
            size: 40,
          ),
        ),
        
        Spaces.mediumH,
        
        // النصوص
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // التحية
              Text(
                greeting,
                style: context.titleStyle.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
              
              Spaces.small,
              
              // الرسالة
              Text(
                message,
                style: context.bodyStyle.copyWith(
                  color: Colors.white.withValues(alpha: 0.95),
                ),
                maxLines: 3,
              ),
              
              Spaces.medium,
              
              // معلومات الوقت والتاريخ
              _buildTimeInfo(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInfo(BuildContext context) {
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final dateStr = _getArabicDate(now);
    
    return Container(
      padding: context.mediumPadding.paddingAll,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
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
            padding: context.smallPadding.paddingAll,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
          
          Spaces.smallH,
          
          // الوقت
          Text(
            timeStr,
            style: context.subtitleStyle.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.fontBold,
            ),
          ),
          
          Spaces.smallH,
          
          // التاريخ
          Text(
            dateStr,
            style: context.captionStyle.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
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

  List<Color> _getGradientColors(int hour) {
    // تدرجات لونية حسب الوقت باستخدام النظام المبسط
    if (hour < 5) {
      return [ThemeConstants.primaryDark, ThemeConstants.darkCard]; // ليل
    } else if (hour < 8) {
      return [ThemeConstants.primaryDark, ThemeConstants.primary]; // فجر
    } else if (hour < 12) {
      return [ThemeConstants.success, ThemeConstants.primaryLight]; // صباح
    } else if (hour < 15) {
      return [ThemeConstants.primary, ThemeConstants.primaryLight]; // ظهر
    } else if (hour < 17) {
      return [ThemeConstants.warning, ThemeConstants.secondary]; // عصر
    } else if (hour < 20) {
      return [ThemeConstants.secondary, ThemeConstants.secondaryLight]; // مغرب
    } else {
      return [ThemeConstants.primaryDark, ThemeConstants.primary]; // مساء
    }
  }

  String _getArabicDate(DateTime date) {
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