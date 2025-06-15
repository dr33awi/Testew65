// lib/features/home/widgets/welcome_message.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = _getGreeting(hour);
    final message = _getMessage(hour);
    final icon = _getIcon(hour);
    final gradient = _getGradientColors(hour);
    
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.all(ThemeConstants.space5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient.map((c) => c.withOpacity(0.8)).toList(),
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  // الأيقونة
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.3),
                          Colors.white.withOpacity(0.1),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: gradient[0].withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: Colors.white,
                      size: ThemeConstants.iconXl,
                    ),
                  ),
                  
                  ThemeConstants.space4.w,
                  
                  // النصوص
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          greeting,
                          style: context.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: ThemeConstants.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        ThemeConstants.space1.h,
                        Text(
                          message,
                          style: context.bodyLarge?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            height: 1.4,
                          ),
                        ),
                        ThemeConstants.space2.h,
                        _buildTimeDisplay(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeDisplay(BuildContext context) {
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final dateStr = _getArabicDate(now);
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space3,
            vertical: ThemeConstants.space1,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
          ),
          child: Row(
            children: [
              Icon(
                Icons.access_time,
                color: Colors.white,
                size: ThemeConstants.iconSm,
              ),
              ThemeConstants.space1.w,
              Text(
                timeStr,
                style: context.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
            ],
          ),
        ),
        ThemeConstants.space2.w,
        Text(
          dateStr,
          style: context.labelMedium?.copyWith(
            color: Colors.white.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  String _getGreeting(int hour) {
    if (hour < 5) {
      return 'أهلاً بك في قيام الليل';
    } else if (hour < 12) {
      return 'صباح الخير والبركة';
    } else if (hour < 17) {
      return 'مساء النور';
    } else if (hour < 20) {
      return 'مساء الخير';
    } else {
      return 'أمسية مباركة';
    }
  }

  String _getMessage(int hour) {
    if (hour < 5) {
      return 'وقت مبارك لقيام الليل والدعاء';
    } else if (hour < 10) {
      return 'لا تنس أذكار الصباح وصلاة الضحى';
    } else if (hour < 14) {
      return 'وقت مناسب لقراءة القرآن والذكر';
    } else if (hour < 17) {
      return 'حان وقت أذكار المساء';
    } else if (hour < 20) {
      return 'وقت الدعاء والاستغفار';
    } else {
      return 'لا تنس أذكار النوم والوتر';
    }
  }

  IconData _getIcon(int hour) {
    if (hour < 5) {
      return Icons.nights_stay;
    } else if (hour < 12) {
      return Icons.wb_sunny;
    } else if (hour < 17) {
      return Icons.wb_twilight;
    } else if (hour < 20) {
      return Icons.wb_twilight_sharp;
    } else {
      return Icons.nightlight_round;
    }
  }

  List<Color> _getGradientColors(int hour) {
    if (hour < 5) {
      return [ThemeConstants.primaryDark, ThemeConstants.darkCard];
    } else if (hour < 8) {
      return [ThemeConstants.primary, ThemeConstants.primaryLight];
    } else if (hour < 12) {
      return [ThemeConstants.accent, ThemeConstants.accentLight];
    } else if (hour < 17) {
      return [ThemeConstants.primaryLight, ThemeConstants.primarySoft];
    } else if (hour < 20) {
      return [ThemeConstants.tertiary, ThemeConstants.tertiaryLight];
    } else {
      return [ThemeConstants.primaryDark, ThemeConstants.primary];
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
}