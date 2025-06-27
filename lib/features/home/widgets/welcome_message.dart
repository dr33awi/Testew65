// lib/features/home/widgets/welcome_message.dart - رسالة ترحيب مصغرة
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
            minHeight: 100, // تقليل من 140
            maxHeight: 130, // تقليل من 180
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg), // تقليل من radius2xl
            boxShadow: [
              BoxShadow(
                color: gradientColors.first.withValues(alpha: 0.2), // تقليل الشفافية
                blurRadius: 12, // تقليل من 20
                offset: const Offset(0, 6), // تقليل من 10
                spreadRadius: -3, // تقليل من -5
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
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
                            Colors.white.withValues(alpha: 0.08), // تقليل الشفافية
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
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                    ),
                  ),
                ),
                
                // المحتوى الرئيسي
                Padding(
                  padding: EdgeInsets.all(
                    isTablet ? ThemeConstants.space4 : ThemeConstants.space3, // تقليل المسافات
                  ),
                  child: _buildContent(context, now, greeting, message, icon, isTablet),
                ),
                
                // نقاط زخرفية مصغرة
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
        // الأيقونة المتحركة مصغرة
        Container(
          width: isTablet ? 60 : 45, // تقليل الحجم
          height: isTablet ? 60 : 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.2),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.4),
              width: 1.5, // تقليل سمك الحدود
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6, // تقليل الظل
                offset: const Offset(0, 3),
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
                    size: isTablet ? ThemeConstants.iconLg : ThemeConstants.iconMd, // تقليل حجم الأيقونة
                  ),
                ),
              );
            },
          ),
        ),
        
        SizedBox(width: isTablet ? ThemeConstants.space4 : ThemeConstants.space3), // تقليل المسافة
        
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
                  style: (isTablet ? context.headlineMedium : context.titleLarge)?.copyWith( // تقليل حجم النص
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                    height: 1.1,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        offset: const Offset(0, 1), // تقليل الظل
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: ThemeConstants.space1), // تقليل المسافة
              
              // الرسالة
              Text(
                message,
                style: (isTablet ? context.bodyMedium : context.bodySmall)?.copyWith( // تقليل حجم النص
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.2,
                  fontWeight: ThemeConstants.medium,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: isTablet ? ThemeConstants.space3 : ThemeConstants.space2), // تقليل المسافة
              
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
      spacing: ThemeConstants.space1, // تقليل المسافة
      runSpacing: ThemeConstants.space1,
      children: [
        // الوقت
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? ThemeConstants.space3 : ThemeConstants.space2, // تقليل المسافات
            vertical: isTablet ? ThemeConstants.space1 : ThemeConstants.space1,
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
                size: isTablet ? 14 : 12, // تقليل حجم الأيقونة
              ),
              
              SizedBox(width: ThemeConstants.space1),
              
              Text(
                timeStr,
                style: (isTablet ? context.labelMedium : context.labelSmall)?.copyWith( // تقليل حجم النص
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
            horizontal: isTablet ? ThemeConstants.space3 : ThemeConstants.space2,
            vertical: isTablet ? ThemeConstants.space1 : ThemeConstants.space1,
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
                size: isTablet ? 14 : 12,
              ),
              
              SizedBox(width: ThemeConstants.space1),
              
              Flexible(
                child: Text(
                  dateStr,
                  style: (isTablet ? context.labelMedium : context.labelSmall)?.copyWith(
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
          // دائرة زخرفية علوية يمين مصغرة
          Positioned(
            top: -15,
            right: -15,
            child: Container(
              width: 60, // تقليل الحجم
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08), // تقليل الشفافية
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1,
                ),
              ),
            ),
          ),
          
          // دائرة زخرفية سفلية يسار مصغرة
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 70, // تقليل الحجم
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ),
          ),
          
          // نقاط صغيرة متناثرة
          Positioned(
            top: 20,
            left: 30,
            child: Container(
              width: 3, // تقليل الحجم
              height: 3,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
          
          Positioned(
            bottom: 35,
            right: 45,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.25),
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