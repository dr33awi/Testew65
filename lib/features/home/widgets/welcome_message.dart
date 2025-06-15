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
    
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withValues(alpha: ThemeConstants.opacity20),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  gradient[0].withValues(alpha: context.isDarkMode ? ThemeConstants.opacity80 : ThemeConstants.opacity90),
                  gradient[1].withValues(alpha: context.isDarkMode ? ThemeConstants.opacity70 : ThemeConstants.opacity80),
                ],
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              border: Border.all(
                color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                width: ThemeConstants.borderLight,
              ),
            ),
            child: Stack(
              children: [
                // نمط زخرفي في الخلفية
                Positioned(
                  right: -30,
                  top: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: ThemeConstants.opacity10),
                    ),
                  ),
                ),
                
                Positioned(
                  left: -20,
                  bottom: -20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: ThemeConstants.opacity5),
                    ),
                  ),
                ),
                
                // المحتوى
                Padding(
                  padding: const EdgeInsets.all(ThemeConstants.space5),
                  child: Row(
                    children: [
                      // أيقونة متحركة
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0, end: 1),
                        duration: ThemeConstants.durationSlow,
                        curve: ThemeConstants.curveSmooth,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                                borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: ThemeConstants.opacity30),
                                  width: ThemeConstants.borderMedium,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: ThemeConstants.opacity10),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Icon(
                                icon,
                                color: Colors.white,
                                size: ThemeConstants.iconXl,
                              ),
                            ),
                          );
                        },
                      ),
                      
                      ThemeConstants.space4.w,
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              greeting,
                              style: context.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: ThemeConstants.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: ThemeConstants.opacity20),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                            ThemeConstants.space1.h,
                            Text(
                              message,
                              style: context.bodyLarge?.copyWith(
                                color: Colors.white.withValues(alpha: ThemeConstants.opacity90),
                                height: 1.4,
                              ),
                            ),
                            ThemeConstants.space2.h,
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ThemeConstants.space3,
                                vertical: ThemeConstants.space1,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                                borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: ThemeConstants.iconSm,
                                    color: Colors.white,
                                  ),
                                  ThemeConstants.space1.w,
                                  Text(
                                    _getCurrentTime(),
                                    style: context.bodySmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: ThemeConstants.semiBold,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 5) {
      return 'قيام الليل مبارك';
    } else if (hour < 12) {
      return 'صباح الخير والبركة';
    } else if (hour < 17) {
      return 'مساؤك خير';
    } else if (hour < 20) {
      return 'مساء النور';
    } else {
      return 'أمسية مباركة';
    }
  }

  String _getMessage(int hour) {
    if (hour < 5) {
      return 'وقت السحر والدعاء المستجاب';
    } else if (hour < 10) {
      return 'ابدأ يومك بأذكار الصباح';
    } else if (hour < 14) {
      return 'وقت مناسب لتلاوة القرآن الكريم';
    } else if (hour < 17) {
      return 'لا تنسَ أذكار المساء';
    } else if (hour < 20) {
      return 'وقت الدعاء والاستغفار';
    } else {
      return 'اختتم يومك بأذكار النوم';
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
      // ليل - درجات الأخضر الزيتي الداكن
      return [
        ThemeConstants.primaryDark,
        const Color(0xFF2A3425),
      ];
    } else if (hour < 8) {
      // فجر - مزيج من الأخضر والذهبي
      return [
        ThemeConstants.primary,
        ThemeConstants.secondary.withValues(alpha: ThemeConstants.opacity70),
      ];
    } else if (hour < 12) {
      // صباح - درجات ذهبية دافئة
      return [
        ThemeConstants.secondary,
        ThemeConstants.secondaryLight,
      ];
    } else if (hour < 17) {
      // ظهر - درجات الأخضر الزيتي
      return [
        ThemeConstants.primary,
        ThemeConstants.primaryLight,
      ];
    } else if (hour < 20) {
      // مغرب - مزيج دافئ
      return [
        ThemeConstants.tertiary,
        ThemeConstants.tertiaryLight,
      ];
    } else {
      // ليل - عودة للأخضر الداكن
      return [
        ThemeConstants.primaryDark,
        const Color(0xFF252921),
      ];
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }
}