// lib/features/home/widgets/welcome_message.dart - محدث بالنظام الموحد الإسلامي
import 'package:flutter/material.dart';

// ✅ استيراد النظام الموحد الإسلامي - الوحيد المسموح
import '../../../app/themes/index.dart';

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
      duration: AppTheme.durationSlow,
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
    final gradientColor = _getTimeBasedColor(hour);
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return AppCard(
          useGradient: true,
          color: gradientColor,
          margin: EdgeInsets.zero,
          padding: context.isMobile ? AppTheme.space3.padding : AppTheme.space4.padding,
          child: Row(
            children: [
              // الأيقونة المتحركة
              Container(
                width: context.isMobile ? 50 : 60,
                height: context.isMobile ? 50 : 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: AppTheme.shadowSm,
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: AppTheme.durationSlow,
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Transform.rotate(
                        angle: value * 0.1,
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: context.isMobile ? AppTheme.iconMd : AppTheme.iconLg,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              AppTheme.space3.w,
              
              // النصوص
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // التحية
                    Text(
                      greeting,
                      style: (context.isMobile ? AppTheme.titleLarge : AppTheme.headlineMedium).copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.bold,
                        height: 1.1,
                      ),
                    ),
                    
                    AppTheme.space1.h,
                    
                    // الرسالة
                    Text(
                      message,
                      style: (context.isMobile ? AppTheme.bodySmall : AppTheme.bodyMedium).copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.2,
                        fontWeight: AppTheme.medium,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    AppTheme.space2.h,
                    
                    // معلومات الوقت والتاريخ
                    _buildTimeInfo(context, now),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimeInfo(BuildContext context, DateTime now) {
    final timeStr = AppTheme.formatPrayerTime(now, use24Hour: true);
    final dateStr = _getArabicDate(now);
    
    return Wrap(
      spacing: AppTheme.space1,
      runSpacing: AppTheme.space1,
      children: [
        // الوقت
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.isMobile ? AppTheme.space2 : AppTheme.space3,
            vertical: AppTheme.space1,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: AppTheme.radiusFull.radius,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time,
                color: Colors.white,
                size: AppTheme.iconSm,
              ),
              
              AppTheme.space1.w,
              
              Text(
                timeStr,
                style: AppTheme.numbersStyle.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.bold,
                  fontSize: context.isMobile ? 12 : 14,
                ),
              ),
            ],
          ),
        ),
        
        // التاريخ
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: context.isMobile ? AppTheme.space2 : AppTheme.space3,
            vertical: AppTheme.space1,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: AppTheme.radiusFull.radius,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today,
                color: Colors.white.withValues(alpha: 0.9),
                size: AppTheme.iconSm,
              ),
              
              AppTheme.space1.w,
              
              Flexible(
                child: Text(
                  dateStr,
                  style: AppTheme.labelMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontWeight: AppTheme.medium,
                    fontSize: context.isMobile ? 12 : 14,
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

  Color _getTimeBasedColor(int hour) {
    if (hour >= 5 && hour < 7) {
      return AppTheme.primary; // الفجر
    } else if (hour >= 7 && hour < 12) {
      return AppTheme.primary; // الصباح
    } else if (hour >= 12 && hour < 15) {
      return AppTheme.secondary; // الظهر
    } else if (hour >= 15 && hour < 18) {
      return AppTheme.accent; // العصر
    } else if (hour >= 18 && hour < 20) {
      return AppTheme.tertiary; // المغرب
    } else {
      return AppTheme.primaryDark; // الليل
    }
  }
}