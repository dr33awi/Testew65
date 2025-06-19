// lib/features/home/widgets/welcome_message.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';
import 'color_helper.dart';

/// رسالة ترحيب محسنة ومبسطة
class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final timeData = _TimeData.current();
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: timeData.gradient.map((c) => c.withValues(alpha: 0.9)).toList(),
        ),
        boxShadow: [
          BoxShadow(
            color: timeData.gradient[0].withValues(alpha: 0.3),
            blurRadius: 25,
            offset: const Offset(0, 15),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
            ),
            child: Padding(
              padding: const EdgeInsets.all(ThemeConstants.space6),
              child: _WelcomeContent(timeData: timeData),
            ),
          ),
        ),
      ),
    );
  }
}

/// محتوى رسالة الترحيب
class _WelcomeContent extends StatelessWidget {
  final _TimeData timeData;

  const _WelcomeContent({required this.timeData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // الأيقونة الثابتة
        _buildIcon(),
        
        ThemeConstants.space5.w,
        
        // المحتوى النصي
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // التحية
              _buildGreeting(context),
              
              ThemeConstants.space2.h,
              
              // الرسالة
              _buildMessage(context),
              
              ThemeConstants.space4.h,
              
              // معلومات الوقت
              _buildTimeInfo(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.2),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(
        timeData.icon,
        color: Colors.white,
        size: ThemeConstants.icon2xl,
      ),
    );
  }

  Widget _buildGreeting(BuildContext context) {
    return Text(
      timeData.greeting,
      style: context.headlineMedium?.copyWith(
        color: Colors.white,
        fontWeight: ThemeConstants.bold,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.3),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Text(
      timeData.message,
      style: context.bodyLarge?.copyWith(
        color: Colors.white.withValues(alpha: 0.95),
        height: 1.5,
        fontWeight: ThemeConstants.medium,
      ),
    );
  }

  Widget _buildTimeInfo(BuildContext context) {
    return Container(
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
            child: Icon(
              Icons.access_time_rounded,
              color: Colors.white,
              size: ThemeConstants.iconSm,
            ),
          ),
          
          ThemeConstants.space2.w,
          
          // الوقت
          Text(
            timeData.timeString,
            style: context.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
            ),
          ),
          
          ThemeConstants.space3.w,
          
          // التاريخ
          Text(
            timeData.dateString,
            style: context.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }
}

/// نموذج بيانات الوقت المحسن
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

  /// إنشاء بيانات الوقت الحالي
  factory _TimeData.current() {
    final now = DateTime.now();
    final hour = now.hour;
    
    return _TimeData(
      greeting: _getGreeting(hour),
      message: _getMessage(hour),
      icon: _getIcon(hour),
      gradient: _getGradientColors(hour),
      timeString: _formatTime(now),
      dateString: _formatDate(now),
    );
  }

  // ===== دوال الحصول على البيانات =====
  
  static String _getGreeting(int hour) {
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

  static String _getMessage(int hour) {
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

  static IconData _getIcon(int hour) {
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

  static List<Color> _getGradientColors(int hour) {
    return ColorHelper.getTimeBasedGradient().colors;
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