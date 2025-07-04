// lib/features/home/widgets/welcome_message.dart - محسن للأداء

import 'package:athkar_app/features/home/widgets/color_helper.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';

class WelcomeMessage extends StatefulWidget {
  const WelcomeMessage({super.key});

  @override
  State<WelcomeMessage> createState() => _WelcomeMessageState();
}

class _WelcomeMessageState extends State<WelcomeMessage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  
  // حفظ البيانات لتجنب إعادة الحساب
  late String _greeting;
  late String _message;
  late IconData _icon;
  late List<Color> _gradientColors;
  late String _timeString;
  late String _dateString;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _setupAnimation();
  }

  void _initializeData() {
    final hour = DateTime.now().hour;
    final now = DateTime.now();
    
    _greeting = _getGreeting(hour);
    _message = _getMessage(hour);
    _icon = _getIcon(hour);
    _gradientColors = _getGradientColors(hour);
    _timeString = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    _dateString = _getArabicDate(now);
  }

  void _setupAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _gradientColors.map((c) => c.withValues(alpha: 0.9)).toList(),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(ThemeConstants.space5),
        child: Row(
          children: [
            // الأيقونة المبسطة
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.2),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Icon(
                _icon,
                color: Colors.white,
                size: 36,
              ),
            ),
            
            ThemeConstants.space4.w,
            
            // النصوص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // التحية
                  Text(
                    _greeting,
                    style: context.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  
                  ThemeConstants.space2.h,
                  
                  // الرسالة
                  Text(
                    _message,
                    style: context.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.4,
                    ),
                  ),
                  
                  ThemeConstants.space3.h,
                  
                  // معلومات الوقت
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ThemeConstants.space3,
                      vertical: ThemeConstants.space2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                        ThemeConstants.space2.w,
                        Text(
                          _timeString,
                          style: context.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: ThemeConstants.bold,
                          ),
                        ),
                        ThemeConstants.space2.w,
                        Text(
                          _dateString,
                          style: context.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
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
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 5) return 'ليلة مباركة 🌙';
    if (hour < 12) return 'صباح الخير 🌅';
    if (hour < 17) return 'نهارك سعيد ☀️';
    if (hour < 20) return 'مساء النور 🌇';
    return 'أمسية مباركة 🌃';
  }

  String _getMessage(int hour) {
    if (hour < 5) return 'وقت مبارك للقيام والدعاء والاستغفار';
    if (hour < 8) return 'ابدأ يومك بأذكار الصباح وصلاة الفجر';
    if (hour < 12) return 'وقت مناسب لقراءة القرآن والذكر';
    if (hour < 15) return 'استمر في الذكر واغتنم هذا الوقت المبارك';
    if (hour < 18) return 'حان وقت أذكار المساء والاستغفار';
    if (hour < 21) return 'وقت الدعاء والتسبيح والحمد';
    return 'استعد للنوم بأذكار النوم والوتر';
  }

  IconData _getIcon(int hour) {
    if (hour < 5) return Icons.nightlight_round;
    if (hour < 8) return Icons.wb_twilight;
    if (hour < 12) return Icons.wb_sunny;
    if (hour < 17) return Icons.light_mode;
    if (hour < 20) return Icons.wb_twilight_sharp;
    return Icons.nights_stay;
  }

  List<Color> _getGradientColors(int hour) {
    final gradient = ColorHelper.getTimeBasedGradient();
    return gradient.colors;
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