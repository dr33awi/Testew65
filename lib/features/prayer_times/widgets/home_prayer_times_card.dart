// lib/features/prayer_times/widgets/home_prayer_times_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'dart:ui';
import '../../../app/themes/app_theme.dart';
import '../../../app/routes/app_router.dart';
import '../../../app/di/service_locator.dart';
import '../services/prayer_times_service.dart';
import '../models/prayer_time_model.dart';

class PrayerTimesCard extends StatefulWidget {
  const PrayerTimesCard({super.key});

  @override
  State<PrayerTimesCard> createState() => _PrayerTimesCardState();
}

class _PrayerTimesCardState extends State<PrayerTimesCard> with TickerProviderStateMixin {
  late final PrayerTimesService _prayerService;
  late AnimationController _animationController;
  late AnimationController _shimmerController;
  late Animation<double> _progressAnimation;
  late Animation<double> _shimmerAnimation;
  
  DailyPrayerTimes? _dailyTimes;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeService();
    _setupAnimations();
  }

  void _initializeService() {
    _prayerService = getIt<PrayerTimesService>();
    
    _prayerService.prayerTimesStream.listen((times) {
      if (mounted) {
        setState(() {
          _dailyTimes = times;
          _isLoading = false;
        });
        _updateProgressAnimation();
      }
    });
    
    if (_prayerService.currentLocation != null) {
      _prayerService.updatePrayerTimes();
    } else {
      setState(() => _isLoading = false);
    }
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.linear,
    ));
  }

  void _updateProgressAnimation() {
    if (_dailyTimes != null) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  void _navigateToPrayerTimes() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, AppRouter.prayerTimes);
  }

  String _getTimeRemaining(PrayerTime? nextPrayer) {
    if (nextPrayer == null) return '';
    
    final now = DateTime.now();
    final duration = nextPrayer.time.difference(now);
    
    if (duration.isNegative) return 'حان الآن';
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return 'بعد ${hours}س ${minutes}د';
    } else {
      return 'بعد ${minutes} دقيقة';
    }
  }

  double _getDayProgress() {
    if (_dailyTimes == null) return 0;
    
    final now = DateTime.now();
    final prayers = _dailyTimes!.prayers.where((p) => 
      p.type != PrayerType.sunrise && 
      p.type != PrayerType.midnight && 
      p.type != PrayerType.lastThird
    ).toList();
    
    int passedPrayers = prayers.where((p) => p.isPassed).length;
    return passedPrayers / prayers.length;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingCard(context);
    }
    
    if (_dailyTimes == null) {
      return _buildNoLocationCard(context);
    }
    
    return _buildPrayerTimesCard(context);
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      margin: ThemeConstants.space4.horizontal,
      height: 320,
      child: AnimatedBuilder(
        animation: _shimmerAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.surfaceVariant,
                  context.surfaceVariant.lighten(0.05),
                  context.surfaceVariant,
                ],
                stops: [
                  _shimmerAnimation.value - 1,
                  _shimmerAnimation.value,
                  _shimmerAnimation.value + 1,
                ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoLocationCard(BuildContext context) {
    return Container(
      margin: ThemeConstants.space4.horizontal,
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: ThemeConstants.opacity15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _navigateToPrayerTimes,
              borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      context.primaryColor.withValues(alpha: context.isDarkMode ? ThemeConstants.opacity70 : ThemeConstants.opacity80),
                      context.primaryColor.darken(0.1).withValues(alpha: context.isDarkMode ? ThemeConstants.opacity60 : ThemeConstants.opacity70),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                    width: ThemeConstants.borderLight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.location_off,
                        color: Colors.white,
                        size: ThemeConstants.icon3xl,
                      ),
                    ),
                    ThemeConstants.space4.h,
                    Text(
                      'لم يتم تحديد الموقع',
                      style: context.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.bold,
                      ),
                    ),
                    ThemeConstants.space2.h,
                    Text(
                      'اضغط لتحديد موقعك وعرض مواقيت الصلاة',
                      style: context.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: ThemeConstants.opacity90),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerTimesCard(BuildContext context) {
    final prayers = _getPrayersForDisplay();
    final nextPrayer = _dailyTimes!.nextPrayer;
    final currentPrayer = _dailyTimes!.currentPrayer;
    
    return Container(
      margin: ThemeConstants.space4.horizontal,
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: ThemeConstants.opacity15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _navigateToPrayerTimes,
              borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      context.cardColor.withValues(alpha: context.isDarkMode ? ThemeConstants.opacity90 : ThemeConstants.opacity95),
                      context.cardColor.darken(0.05).withValues(alpha: context.isDarkMode ? ThemeConstants.opacity85 : ThemeConstants.opacity90),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: ThemeConstants.opacity30),
                    width: ThemeConstants.borderLight,
                  ),
                ),
                child: Stack(
                  children: [
                    // نمط زخرفي
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              context.primaryColor.withValues(alpha: ThemeConstants.opacity5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    // المحتوى
                    Padding(
                      padding: const EdgeInsets.all(ThemeConstants.space5),
                      child: Column(
                        children: [
                          // الهيدر
                          _buildHeader(context, nextPrayer),
                          
                          ThemeConstants.space4.h,
                          
                          // بطاقة الصلاة القادمة
                          if (nextPrayer != null)
                            _buildNextPrayerSection(context, nextPrayer, currentPrayer),
                          
                          const Spacer(),
                          
                          // الصلوات
                          _buildPrayersTimeline(context, prayers),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PrayerTime? nextPrayer) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: ThemeConstants.primaryGradient),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  ),
                  child: Icon(
                    ThemeConstants.iconPrayer,
                    color: Colors.white,
                    size: ThemeConstants.iconSm,
                  ),
                ),
                ThemeConstants.space2.w,
                Text(
                  'مواقيت الصلاة',
                  style: context.titleLarge?.copyWith(
                    fontWeight: ThemeConstants.bold,
                    color: context.primaryColor,
                  ),
                ),
              ],
            ),
            if (_dailyTimes!.location.cityName != null) ...[
              ThemeConstants.space1.h,
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: ThemeConstants.iconXs,
                    color: context.textSecondaryColor,
                  ),
                  ThemeConstants.space1.w,
                  Text(
                    _dailyTimes!.location.cityName!,
                    style: context.bodySmall?.copyWith(
                      color: context.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        
        // الساعة الرقمية
        StreamBuilder(
          stream: Stream.periodic(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            final now = DateTime.now();
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: ThemeConstants.space3,
                vertical: ThemeConstants.space2,
              ),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: ThemeConstants.opacity10),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: ThemeConstants.iconSm,
                    color: context.primaryColor,
                  ),
                  ThemeConstants.space1.w,
                  Text(
                    '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                    style: context.titleSmall?.copyWith(
                      fontWeight: ThemeConstants.bold,
                      color: context.primaryColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildNextPrayerSection(BuildContext context, PrayerTime nextPrayer, PrayerTime? currentPrayer) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: ThemeConstants.primaryGradient,
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: ThemeConstants.opacity20),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // الأيقونة
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            ),
            child: Icon(
              ThemeConstants.getPrayerIcon(nextPrayer.type.name),
              color: Colors.white,
              size: ThemeConstants.iconLg,
            ),
          ),
          
          ThemeConstants.space4.w,
          
          // المعلومات
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الصلاة القادمة',
                  style: context.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: ThemeConstants.opacity70),
                  ),
                ),
                Text(
                  nextPrayer.nameAr,
                  style: context.titleLarge?.copyWith(
                    fontWeight: ThemeConstants.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // الوقت
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(nextPrayer.time),
                style: context.headlineSmall?.copyWith(
                  fontWeight: ThemeConstants.bold,
                  color: Colors.white,
                ),
              ),
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Text(
                    _getTimeRemaining(nextPrayer),
                    style: context.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: ThemeConstants.opacity70),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrayersTimeline(BuildContext context, List<PrayerTime> prayers) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: context.surfaceVariant.withValues(alpha: ThemeConstants.opacity50),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
      child: Stack(
        children: [
          // خط التقدم
          Positioned.fill(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: TimelineProgressPainter(
                        progress: _getDayProgress() * _progressAnimation.value,
                        color: context.primaryColor,
                        backgroundColor: context.dividerColor.withValues(alpha: ThemeConstants.opacity30),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          
          // الصلوات
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: prayers.map((prayer) => _buildPrayerItem(context, prayer)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerItem(BuildContext context, PrayerTime prayer) {
    final isNext = prayer.isNext;
    final isPassed = prayer.isPassed;
    
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // النقطة
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isPassed || isNext
                  ? context.primaryColor
                  : context.surfaceColor,
              border: Border.all(
                color: isPassed || isNext
                    ? context.primaryColor
                    : context.dividerColor,
                width: 2,
              ),
              boxShadow: isNext ? [
                BoxShadow(
                  color: context.primaryColor.withValues(alpha: ThemeConstants.opacity30),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ] : null,
            ),
            child: Icon(
              isPassed && !isNext
                  ? Icons.check
                  : ThemeConstants.getPrayerIcon(prayer.type.name),
              color: isPassed || isNext
                  ? Colors.white
                  : context.textSecondaryColor,
              size: ThemeConstants.iconXs,
            ),
          ),
          
          ThemeConstants.space1.h,
          
          // الاسم
          Text(
            prayer.nameAr,
            style: context.labelSmall?.copyWith(
              color: isNext
                  ? context.primaryColor
                  : context.textSecondaryColor,
              fontWeight: isNext ? ThemeConstants.semiBold : null,
            ),
          ),
          
          // الوقت
          Text(
            _formatTime(prayer.time),
            style: context.labelSmall?.copyWith(
              color: isNext
                  ? context.primaryColor
                  : context.textSecondaryColor.withValues(alpha: ThemeConstants.opacity70),
              fontWeight: ThemeConstants.bold,
            ),
          ),
        ],
      ),
    );
  }

  List<PrayerTime> _getPrayersForDisplay() {
    if (_dailyTimes == null) return [];
    
    return _dailyTimes!.prayers.where((prayer) =>
      prayer.type != PrayerType.sunrise &&
      prayer.type != PrayerType.midnight &&
      prayer.type != PrayerType.lastThird
    ).toList();
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute';
  }
}

// رسام خط التقدم
class TimelineProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  TimelineProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // خط الخلفية
    paint.color = backgroundColor;
    canvas.drawLine(
      Offset(20, size.height / 2),
      Offset(size.width - 20, size.height / 2),
      paint,
    );

    // خط التقدم
    if (progress > 0) {
      paint.color = color;
      paint.strokeWidth = 3;
      canvas.drawLine(
        Offset(20, size.height / 2),
        Offset(20 + (size.width - 40) * progress, size.height / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(TimelineProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}