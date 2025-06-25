// lib/features/home/widgets/welcome_message.dart - رسالة ترحيب حديثة ومرنة
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';

class WelcomeMessage extends StatefulWidget {
  const WelcomeMessage({super.key});

  @override
  State<WelcomeMessage> createState() => _WelcomeMessageState();
}

class _WelcomeMessageState extends State<WelcomeMessage> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;
  
  static const List<String> _arabicMonths = [
    'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
    'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
  ];
  
  static const List<String> _arabicDays = [
    'الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'
  ];

  @override
  void initState() {
    super.initState();
    _setupShimmerAnimation();
  }

  void _setupShimmerAnimation() {
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final hour = now.hour;
    final greeting = _getGreeting(hour);
    final message = _getMessage(hour);
    final icon = _getGreetingIcon(hour);
    final gradientColors = context.getTimeBasedGradient(dateTime: now).colors;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        
        return Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            minHeight: 140,
            maxHeight: 180,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: -5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            child: Stack(
              children: [
                // الخلفية المتدرجة
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors.map((c) => 
                        c.withValues(alpha: 0.95)
                      ).toList(),
                    ),
                  ),
                ),
                
                // تأثير التلميع المتحرك
                AnimatedBuilder(
                  animation: _shimmerAnimation,
                  builder: (context, child) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.transparent,
                            Colors.white.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                          stops: [
                            (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                            _shimmerAnimation.value.clamp(0.0, 1.0),
                            (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                
                // الطبقة الزجاجية
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                    ),
                  ),
                ),
                
                // المحتوى الرئيسي
                Padding(
                  padding: EdgeInsets.all(
                    isTablet ? ThemeConstants.space6 : ThemeConstants.space4,
                  ),
                  child: _buildContent(context, now, greeting, message, icon, isTablet),
                ),
                
                // نقاط زخرفية
                _buildDecorativeElements(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, DateTime now, String greeting, 
                      String message, IconData icon, bool isTablet) {
    return Row(
      children: [
        // الأيقونة المتحركة
        Container(
          width: isTablet ? 80 : 60,
          height: isTablet ? 80 : 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.2),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Transform.rotate(
                  angle: value * 0.1,
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: isTablet ? ThemeConstants.icon2xl : ThemeConstants.iconLg,
                  ),
                ),
              );
            },
          ),
        ),
        
        SizedBox(width: isTablet ? ThemeConstants.space5 : ThemeConstants.space4),
        
        // النصوص
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // التحية
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  greeting,
                  style: (isTablet ? context.headlineLarge : context.headlineSmall)?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                    height: 1.1,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: isTablet ? ThemeConstants.space2 : ThemeConstants.space1),
              
              // الرسالة
              Text(
                message,
                style: (isTablet ? context.bodyLarge : context.bodyMedium)?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.3,
                  fontWeight: ThemeConstants.medium,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: isTablet ? ThemeConstants.space4 : ThemeConstants.space3),
              
              // معلومات الوقت والتاريخ
              _buildTimeInfo(context, now, isTablet),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInfo(BuildContext context, DateTime now, bool isTablet) {
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final dateStr = _getArabicDate(now);
    
    return Wrap(
      spacing: ThemeConstants.space2,
      runSpacing: ThemeConstants.space1,
      children: [
        // الوقت
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? ThemeConstants.space4 : ThemeConstants.space3,
            vertical: isTablet ? ThemeConstants.space2 : ThemeConstants.space1,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time_rounded,
                color: Colors.white,
                size: isTablet ? 16 : 14,
              ),
              
              SizedBox(width: isTablet ? ThemeConstants.space2 : ThemeConstants.space1),
              
              Text(
                timeStr,
                style: (isTablet ? context.labelLarge : context.labelMedium)?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),
        ),
        
        // التاريخ
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? ThemeConstants.space4 : ThemeConstants.space3,
            vertical: isTablet ? ThemeConstants.space2 : ThemeConstants.space1,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_rounded,
                color: Colors.white.withValues(alpha: 0.9),
                size: isTablet ? 16 : 14,
              ),
              
              SizedBox(width: isTablet ? ThemeConstants.space2 : ThemeConstants.space1),
              
              Flexible(
                child: Text(
                  dateStr,
                  style: (isTablet ? context.labelLarge : context.labelMedium)?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: ThemeConstants.medium,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDecorativeElements() {
    return Positioned.fill(
      child: Stack(
        children: [
          // دائرة زخرفية علوية يمين
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
          ),
          
          // دائرة زخرفية سفلية يسار
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
          ),
          
          // نقاط صغيرة متناثرة
          Positioned(
            top: 30,
            left: 40,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ),
          
          Positioned(
            bottom: 50,
            right: 60,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.3),
              ),
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
      return 'ابدأ يومك بذكر الله وأذكار الصباح';
    } else if (hour < 12) {
      return 'وقت مناسب لقراءة القرآن والذكر';
    } else if (hour < 15) {
      return 'استمر في الذكر والدعاء والتسبيح';
    } else if (hour < 18) {
      return 'حان وقت أذكار المساء المباركة';
    } else if (hour < 21) {
      return 'وقت مبارك للدعاء والتسبيح';
    } else {
      return 'استعد بأذكار النوم والاستغفار';
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