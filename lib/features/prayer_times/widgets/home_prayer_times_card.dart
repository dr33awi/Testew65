// lib/features/prayer_times/widgets/home_prayer_times_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
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
      duration: const Duration(milliseconds: 2000),
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
      curve: ThemeConstants.curveSmooth,
    ));
    
    _shimmerAnimation = Tween<double>(
      begin: -1,
      end: 2,
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
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
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
                  context.cardColor,
                  context.cardColor.lighten(0.05),
                  context.cardColor,
                ],
                stops: [
                  0.0,
                  _shimmerAnimation.value,
                  1.0,
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppLoading.circular(size: LoadingSize.large),
                  ThemeConstants.space3.h,
                  Text(
                    'جاري تحميل مواقيت الصلاة...',
                    style: context.bodyLarge?.copyWith(
                      color: context.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNoLocationCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      height: 320,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              ThemeConstants.primary,
              ThemeConstants.primaryDark,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: ThemeConstants.primary.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _navigateToPrayerTimes,
              borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
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
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  
                  // المحتوى
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.location_off,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        ThemeConstants.space4.h,
                        Text(
                          'لم يتم تحديد الموقع',
                          style: context.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: ThemeConstants.bold,
                          ),
                        ),
                        ThemeConstants.space2.h,
                        Text(
                          'اضغط لتحديد موقعك وعرض مواقيت الصلاة',
                          style: context.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
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

  Widget _buildPrayerTimesCard(BuildContext context) {
    final prayers = _getPrayersForDisplay();
    final nextPrayer = _dailyTimes!.nextPrayer;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: nextPrayer != null
                ? [
                    _getPrayerColor(nextPrayer.type),
                    _getPrayerColor(nextPrayer.type).darken(0.1),
                  ]
                : [
                    ThemeConstants.primary,
                    ThemeConstants.primaryDark,
                  ],
          ),
          boxShadow: [
            BoxShadow(
              color: context.primaryColor.withOpacity(0.2),
              blurRadius: 25,
              offset: const Offset(0, 15),
              spreadRadius: -5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _navigateToPrayerTimes,
              borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // الرأس
                    _buildHeader(context, nextPrayer),
                    
                    // بطاقة الصلاة القادمة
                    if (nextPrayer != null)
                      _buildNextPrayerSection(context, nextPrayer),
                    
                    // Timeline للصلوات
                    _buildPrayerTimeline(context, prayers),
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
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.radius3xl),
        ),
      ),
      child: Row(
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
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.mosque,
                      color: Colors.white,
                      size: ThemeConstants.iconMd,
                    ),
                  ),
                  ThemeConstants.space3.w,
                  Text(
                    'مواقيت الصلاة',
                    style: context.titleLarge?.copyWith(
                      fontWeight: ThemeConstants.bold,
                      color: Colors.white,
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
                      size: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    ThemeConstants.space1.w,
                    Text(
                      _dailyTimes!.location.cityName!,
                      style: context.labelMedium?.copyWith(
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          
          // الساعة الرقمية
          _buildDigitalClock(context),
        ],
      ),
    );
  }

  Widget _buildDigitalClock(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final now = DateTime.now();
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space3,
            vertical: ThemeConstants.space2,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: Colors.white,
              ),
              ThemeConstants.space1.w,
              Text(
                '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}',
                style: context.titleSmall?.copyWith(
                  fontWeight: ThemeConstants.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNextPrayerSection(BuildContext context, PrayerTime nextPrayer) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        ThemeConstants.space4,
        0,
        ThemeConstants.space4,
        ThemeConstants.space4,
      ),
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // الأيقونة
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            ),
            child: Icon(
              _getPrayerIcon(nextPrayer.type),
              color: Colors.white,
              size: 32,
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
                  style: context.labelMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                Text(
                  nextPrayer.nameAr,
                  style: context.headlineSmall?.copyWith(
                    fontWeight: ThemeConstants.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          
          // الوقت والعد التنازلي
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(nextPrayer.time),
                style: context.headlineMedium?.copyWith(
                  fontWeight: ThemeConstants.bold,
                  color: Colors.white,
                ),
              ),
              StreamBuilder(
                stream: Stream.periodic(const Duration(seconds: 1)),
                builder: (context, snapshot) {
                  return Text(
                    'بعد ${_getTimeRemaining(nextPrayer)}',
                    style: context.labelSmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
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

  Widget _buildPrayerTimeline(BuildContext context, List<PrayerTime> prayers) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              // خط الزمن الأساسي
              Positioned(
                top: 45,
                left: 20,
                right: 20,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
              
              // مؤشر التقدم
              Positioned(
                top: 45,
                left: 20,
                child: Container(
                  width: (MediaQuery.of(context).size.width - 80) * _getDayProgress() * _progressAnimation.value,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.5),
                        blurRadius: 4,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
              
              // الصلوات
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: prayers.map((prayer) => _buildTimelineItem(context, prayer)).toList(),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, PrayerTime prayer) {
    final isActive = prayer.isNext;
    final isPassed = prayer.isPassed;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // النقطة على الخط
        AnimatedContainer(
          duration: ThemeConstants.durationNormal,
          width: isActive ? 40 : 32,
          height: isActive ? 40 : 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPassed || isActive
                ? Colors.white
                : Colors.white.withOpacity(0.3),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            isPassed && !isActive
                ? Icons.check
                : _getPrayerIcon(prayer.type),
            color: isPassed || isActive
                ? _getPrayerColor(prayer.type)
                : Colors.white.withOpacity(0.7),
            size: isActive ? 20 : 16,
          ),
        ),
        
        ThemeConstants.space2.h,
        
        // اسم الصلاة
        Text(
          prayer.nameAr,
          style: TextStyle(
            fontSize: 11,
            color: isActive
                ? Colors.white
                : Colors.white.withOpacity(isPassed ? 0.6 : 0.8),
            fontWeight: isActive ? ThemeConstants.semiBold : null,
          ),
        ),
        
        ThemeConstants.space1.h,
        
        // الوقت
        Text(
          _formatTime(prayer.time),
          style: TextStyle(
            fontSize: 10,
            color: Colors.white.withOpacity(isActive ? 1.0 : 0.7),
            fontWeight: ThemeConstants.medium,
          ),
        ),
      ],
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

  Color _getPrayerColor(PrayerType type) {
    return ThemeConstants.getPrayerColor(type.toString());
  }

  IconData _getPrayerIcon(PrayerType type) {
    return ThemeConstants.getPrayerIcon(type.toString());
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute';
  }

  String _getTimeRemaining(PrayerTime? nextPrayer) {
    if (nextPrayer == null) return '';
    
    final now = DateTime.now();
    final duration = nextPrayer.time.difference(now);
    
    if (duration.isNegative) return 'حان الآن';
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    
    if (hours > 0) {
      return '$hours ساعة و $minutes دقيقة';
    } else {
      return '$minutes دقيقة';
    }
  }

  double _getDayProgress() {
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    return currentMinutes / 1440;
  }
}