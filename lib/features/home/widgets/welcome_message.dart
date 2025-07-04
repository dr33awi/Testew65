// lib/features/home/widgets/enhanced_welcome_message.dart
import 'package:athkar_app/features/home/widgets/color_helper.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';

class WelcomeMessage extends StatefulWidget {
  const WelcomeMessage({super.key});

  @override
  State<WelcomeMessage> createState() => _WelcomeMessageState();
}

class _WelcomeMessageState extends State<WelcomeMessage>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _iconController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * math.pi,
    ).animate(CurvedAnimation(
      parent: _iconController,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = _getGreeting(hour);
    final message = _getMessage(hour);
    final icon = _getIcon(hour);
    final gradient = _getGradientColors(hour);
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient.map((c) => c.withValues(alpha: 0.9)).toList(),
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // خلفية زخرفية
                _buildDecorativeBackground(),
                
                // المحتوى الرئيسي
                Padding(
                  padding: const EdgeInsets.all(ThemeConstants.space6),
                  child: _buildContent(context, greeting, message, icon),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDecorativeBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          // نجوم متحركة
          ...List.generate(6, (index) {
            return AnimatedBuilder(
              animation: _iconController,
              builder: (context, child) {
                final offset = _rotationAnimation.value + (index * math.pi / 3);
                return Positioned(
                  top: 20 + (index * 15) + (math.sin(offset) * 10),
                  right: 20 + (index * 20) + (math.cos(offset) * 15),
                  child: Opacity(
                    opacity: 0.3 + (math.sin(offset) * 0.2),
                    child: Icon(
                      Icons.star,
                      size: 8 + (math.sin(offset) * 4),
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                );
              },
            );
          }),
          
          // دوائر زخرفية
          Positioned(
            top: -50,
            left: -50,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          Positioned(
            bottom: -30,
            right: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, String greeting, String message, IconData icon) {
    return Row(
      children: [
        // الأيقونة المتحركة
        AnimatedBuilder(
          animation: _iconController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotationAnimation.value * 0.1,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.3),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: ThemeConstants.icon2xl,
                ),
              ),
            );
          },
        ),
        
        ThemeConstants.space5.w,
        
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
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              
              ThemeConstants.space2.h,
              
              // الرسالة
              Text(
                message,
                style: context.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.95),
                  height: 1.5,
                  fontWeight: ThemeConstants.medium,
                ),
              ),
              
              ThemeConstants.space4.h,
              
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
            timeStr,
            style: context.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
            ),
          ),
          
          ThemeConstants.space3.w,
          
          // التاريخ
          Text(
            dateStr,
            style: context.labelMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting(int hour) {
    if (hour < 5) {
      return 'ليلة مباركة 🌙';
    } else if (hour < 12) {
      return 'صباح الخير 🌅';
    } else if (hour < 17) {
      return 'نهارك سعيد ☀️';
    } else if (hour < 20) {
      return 'مساء النور 🌇';
    } else {
      return 'أمسية مباركة 🌃';
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

  IconData _getIcon(int hour) {
    if (hour < 5) {
      return Icons.nightlight_round;
    } else if (hour < 8) {
      return Icons.wb_twilight;
    } else if (hour < 12) {
      return Icons.wb_sunny;
    } else if (hour < 17) {
      return Icons.light_mode;
    } else if (hour < 20) {
      return Icons.wb_twilight_sharp;
    } else {
      return Icons.nights_stay;
    }
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