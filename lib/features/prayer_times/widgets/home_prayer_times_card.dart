// lib/features/prayer_times/widgets/home_prayer_times_card.dart - بطاقة مواقيت حديثة ومتجاوبة
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../services/prayer_times_service.dart';
import '../models/prayer_time_model.dart';

class PrayerTimesCard extends StatefulWidget {
  const PrayerTimesCard({super.key});

  @override
  State<PrayerTimesCard> createState() => _PrayerTimesCardState();
}

class _PrayerTimesCardState extends State<PrayerTimesCard>
    with TickerProviderStateMixin {
  
  // Animation Controllers
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late AnimationController _fadeController;
  
  // Animations
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _fadeAnimation;
  
  // Service
  late PrayerTimesService _prayerService;

  // State
  DailyPrayerTimes? _dailyTimes;
  PrayerTime? _nextPrayer;
  PrayerLocation? _location;
  bool _isLoading = true;
  bool _isLoadingLocation = false;
  String? _errorMessage;
  
  // Subscriptions
  StreamSubscription<DailyPrayerTimes>? _timesSubscription;
  StreamSubscription<PrayerTime?>? _nextPrayerSubscription;
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeService();
    _startClockTimer();
  }

  void _setupAnimations() {
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutCubic,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _progressController.forward();
    _fadeController.forward();
  }

  void _startClockTimer() {
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  void _initializeService() {
    try {
      _prayerService = getIt<PrayerTimesService>();
      
      _timesSubscription = _prayerService.prayerTimesStream.listen(
        (times) {
          if (mounted) {
            setState(() {
              _dailyTimes = times;
              _location = times.location;
              _isLoading = false;
              _isLoadingLocation = false;
              _errorMessage = null;
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _errorMessage = 'فشل في تحميل مواقيت الصلاة';
              _isLoading = false;
              _isLoadingLocation = false;
            });
          }
        },
      );
      
      _nextPrayerSubscription = _prayerService.nextPrayerStream.listen(
        (prayer) {
          if (mounted) {
            setState(() {
              _nextPrayer = prayer;
            });
          }
        },
      );
      
      _loadInitialData();
    } catch (e) {
      setState(() {
        _errorMessage = 'خطأ في تهيئة خدمة مواقيت الصلاة';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadInitialData() async {
    try {
      final cachedTimes = await _prayerService.getCachedPrayerTimes(DateTime.now());
      if (cachedTimes != null && mounted) {
        setState(() {
          _dailyTimes = cachedTimes;
          _nextPrayer = cachedTimes.nextPrayer;
          _location = cachedTimes.location;
          _isLoading = false;
        });
      }
      
      await _updatePrayerTimes();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'فشل في تحميل مواقيت الصلاة';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updatePrayerTimes() async {
    if (_isLoadingLocation) return;
    
    setState(() {
      _isLoadingLocation = true;
      _errorMessage = null;
    });

    try {
      if (_prayerService.currentLocation == null) {
        await _prayerService.getCurrentLocation();
      }
      
      await _prayerService.updatePrayerTimes();
      
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'فشل في تحديث الموقع أو مواقيت الصلاة';
          _isLoadingLocation = false;
        });
        
        AppSnackBar.showError(
          context: context,
          message: 'فشل في تحديث الموقع. تحقق من إعدادات الموقع.',
          action: SnackBarAction(
            label: 'إعادة المحاولة',
            textColor: Colors.white,
            onPressed: _updatePrayerTimes,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    _fadeController.dispose();
    _timesSubscription?.cancel();
    _nextPrayerSubscription?.cancel();
    _clockTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        
        return FadeTransition(
          opacity: _fadeAnimation,
          child: Container(
            constraints: BoxConstraints(
              minHeight: isTablet ? 180 : 160,
              maxHeight: isTablet ? 220 : 200,
            ),
            child: _buildContent(context, isTablet),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, bool isTablet) {
    if (_isLoading) {
      return _buildLoadingState(isTablet);
    }

    if (_errorMessage != null && _dailyTimes == null) {
      return _buildErrorState(isTablet);
    }

    if (_dailyTimes == null) {
      return _buildEmptyState(isTablet);
    }

    final nextPrayer = _nextPrayer ?? _dailyTimes!.nextPrayer;
    if (nextPrayer == null) {
      return _buildEmptyState(isTablet);
    }

    return _buildPrayerCard(context, nextPrayer, isTablet);
  }

  Widget _buildPrayerCard(BuildContext context, PrayerTime nextPrayer, bool isTablet) {
    final prayerColor = context.getPrayerColor(nextPrayer.nameAr);
    final gradientColors = [
      prayerColor,
      prayerColor.darken(0.3),
    ];
    
    return GestureDetector(
      onTap: _navigateToPrayerTimes,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          boxShadow: [
            BoxShadow(
              color: prayerColor.withValues(alpha: 0.3),
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
              
              // تأثير التلميع
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
                  ),
                ),
              ),
              
              // المحتوى الرئيسي
              Padding(
                padding: EdgeInsets.all(
                  isTablet ? ThemeConstants.space5 : ThemeConstants.space4,
                ),
                child: Column(
                  children: [
                    _buildMainHeader(context, nextPrayer, isTablet),
                    
                    SizedBox(height: isTablet ? ThemeConstants.space4 : ThemeConstants.space3),
                    
                    _buildPrayerTimeline(context, isTablet),
                  ],
                ),
              ),
              
              // عناصر زخرفية
              _buildDecorativeElements(),
              
              // تأثير التفاعل
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _navigateToPrayerTimes,
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                  splashColor: Colors.white.withValues(alpha: 0.1),
                  highlightColor: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainHeader(BuildContext context, PrayerTime nextPrayer, bool isTablet) {
    return Row(
      children: [
        // أيقونة المسجد المتحركة
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                width: isTablet ? 60 : 50,
                height: isTablet ? 60 : 50,
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
                child: Icon(
                  Icons.mosque_rounded,
                  color: Colors.white,
                  size: isTablet ? 30 : 26,
                ),
              ),
            );
          },
        ),
        
        SizedBox(width: isTablet ? ThemeConstants.space4 : ThemeConstants.space3),
        
        // معلومات الموقع والصلاة
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  'مواقيت الصلاة',
                  style: (isTablet ? context.titleLarge : context.titleMedium)?.copyWith(
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
              
              const SizedBox(height: 4),
              
              Row(
                children: [
                  Icon(
                    Icons.location_on_rounded,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 14,
                  ),
                  
                  const SizedBox(width: 4),
                  
                  Expanded(
                    child: Text(
                      _location?.displayName ?? 'جاري تحديد الموقع...',
                      style: context.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: isTablet ? 13 : 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // معلومات الصلاة القادمة
        _buildNextPrayerInfo(context, nextPrayer, isTablet),
      ],
    );
  }

  Widget _buildNextPrayerInfo(BuildContext context, PrayerTime nextPrayer, bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? ThemeConstants.space4 : ThemeConstants.space3,
        vertical: isTablet ? ThemeConstants.space3 : ThemeConstants.space2,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                context.getPrayerIcon(nextPrayer.nameAr),
                color: Colors.white,
                size: isTablet ? 18 : 16,
              ),
              
              SizedBox(width: isTablet ? 6 : 4),
              
              Text(
                nextPrayer.nameAr,
                style: (isTablet ? context.labelLarge : context.labelMedium)?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
            ],
          ),
          
          SizedBox(height: isTablet ? 6 : 4),
          
          Text(
            _formatTime(nextPrayer.time),
            style: (isTablet ? context.titleMedium : context.titleSmall)?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          
          SizedBox(height: isTablet ? 4 : 2),
          
          _buildTimeRemaining(context, nextPrayer, isTablet),
        ],
      ),
    );
  }

  Widget _buildTimeRemaining(BuildContext context, PrayerTime nextPrayer, bool isTablet) {
    final remainingTime = nextPrayer.remainingTimeText;
    
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 8 : 6,
        vertical: isTablet ? 3 : 2,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
      ),
      child: Text(
        remainingTime,
        style: context.labelSmall?.copyWith(
          color: Colors.white.withValues(alpha: 0.9),
          fontSize: isTablet ? 10 : 9,
          fontWeight: ThemeConstants.medium,
        ),
      ),
    );
  }

  Widget _buildPrayerTimeline(BuildContext context, bool isTablet) {
    if (_dailyTimes == null) return const SizedBox.shrink();
    
    final mainPrayers = _dailyTimes!.prayers.where((prayer) => 
      prayer.type != PrayerType.sunrise
    ).toList();

    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Container(
          height: isTablet ? 60 : 50,
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 8 : 4),
          child: Stack(
            children: [
              // خط التقدم الخلفي
              Positioned(
                top: isTablet ? 16 : 14,
                left: isTablet ? 16 : 12,
                right: isTablet ? 16 : 12,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              ),
              
              // خط التقدم النشط
              Positioned(
                top: isTablet ? 16 : 14,
                left: isTablet ? 16 : 12,
                child: AnimatedContainer(
                  duration: ThemeConstants.durationNormal,
                  width: _calculateProgressWidth(context, mainPrayers, isTablet),
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.5),
                        blurRadius: 4,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              
              // نقاط الصلوات
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: mainPrayers.map((prayer) => 
                  _buildTimelinePoint(context, prayer, isTablet)
                ).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelinePoint(BuildContext context, PrayerTime prayer, bool isTablet) {
    final isActive = prayer.isNext;
    final isPassed = prayer.isPassed;
    final size = isTablet ? 18.0 : 16.0;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: ThemeConstants.durationNormal,
          width: isActive ? size + 4 : size,
          height: isActive ? size + 4 : size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPassed || isActive 
                ? Colors.white 
                : Colors.white.withValues(alpha: 0.4),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
              width: 2,
            ),
            boxShadow: isActive ? [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ] : null,
          ),
          child: Center(
            child: Icon(
              isPassed && !isActive 
                  ? Icons.check_rounded 
                  : context.getPrayerIcon(prayer.nameAr),
              color: isPassed || isActive 
                  ? context.getPrayerColor(prayer.nameAr) 
                  : Colors.white,
              size: isActive ? (isTablet ? 12 : 10) : (isTablet ? 10 : 8),
            ),
          ),
        ),
        
        SizedBox(height: isTablet ? 6 : 4),
        
        Text(
          prayer.nameAr,
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.7),
            fontWeight: isActive ? ThemeConstants.semiBold : ThemeConstants.regular,
            fontSize: isTablet ? 10 : 9,
          ),
        ),
        
        Text(
          _formatTimeShort(prayer.time),
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: isActive ? 0.9 : 0.6),
            fontSize: isTablet ? 8 : 7,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  Widget _buildDecorativeElements() {
    return Positioned.fill(
      child: Stack(
        children: [
          // دائرة زخرفية علوية
          Positioned(
            top: -30,
            right: -30,
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
          
          // دائرة زخرفية سفلية
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.03),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(bool isTablet) {
    return Container(
      height: isTablet ? 180 : 160,
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLoading.circular(
            size: LoadingSize.medium,
            color: context.primaryColor,
          ),
          SizedBox(height: isTablet ? ThemeConstants.space3 : ThemeConstants.space2),
          Text(
            'جاري تحميل المواقيت...',
            style: context.bodyMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(bool isTablet) {
    return AppCard.info(
      title: _errorMessage ?? 'خطأ في تحميل المواقيت',
      subtitle: 'اضغط للمحاولة مرة أخرى',
      icon: Icons.error_outline,
      iconColor: context.errorColor,
      onTap: _updatePrayerTimes,
    );
  }

  Widget _buildEmptyState(bool isTablet) {
    return AppCard.info(
      title: _isLoadingLocation 
          ? 'جاري تحديد الموقع...'
          : 'لم يتم تحديد الموقع',
      subtitle: _isLoadingLocation
          ? 'الرجاء الانتظار'
          : 'اضغط لتحديد موقعك وعرض مواقيت الصلاة',
      icon: _isLoadingLocation ? Icons.hourglass_empty : Icons.location_on,
      iconColor: context.primaryColor,
      onTap: _updatePrayerTimes,
    );
  }

  void _navigateToPrayerTimes() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/prayer-times').catchError((error) {
      if (context.mounted) {
        AppSnackBar.showInfo(
          context: context,
          message: 'هذه الميزة قيد التطوير',
        );
      }
      return null;
    });
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }

  String _formatTimeShort(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute';
  }

  double _calculateProgressWidth(BuildContext context, List<PrayerTime> prayers, bool isTablet) {
    if (prayers.isEmpty) return 0.0;
    
    final containerWidth = MediaQuery.of(context).size.width - (isTablet ? 120 : 80);
    final now = DateTime.now();
    
    int currentPrayerIndex = 0;
    for (int i = 0; i < prayers.length; i++) {
      if (prayers[i].isPassed) {
        currentPrayerIndex = i;
      } else {
        break;
      }
    }
    
    if (currentPrayerIndex == 0 && !prayers[0].isPassed) {
      return 0;
    }
    
    if (prayers.every((prayer) => prayer.isPassed)) {
      return containerWidth * _progressAnimation.value;
    }
    
    double progress;
    if (currentPrayerIndex < prayers.length - 1) {
      final currentPrayer = prayers[currentPrayerIndex];
      final nextPrayer = prayers[currentPrayerIndex + 1];
      final totalDuration = nextPrayer.time.difference(currentPrayer.time);
      final elapsed = now.difference(currentPrayer.time);
      
      if (totalDuration.inSeconds > 0) {
        final sectionProgress = (elapsed.inSeconds / totalDuration.inSeconds).clamp(0.0, 1.0);
        progress = currentPrayerIndex + sectionProgress;
      } else {
        progress = currentPrayerIndex.toDouble();
      }
    } else {
      progress = currentPrayerIndex.toDouble();
    }
    
    return (containerWidth / (prayers.length - 1)) * progress * _progressAnimation.value;
  }
}

extension PrayerLocationDisplayExtension on PrayerLocation {
  String get displayName {
    if (cityName != null && countryName != null) {
      return '$cityName، $countryName';
    } else if (cityName != null) {
      return cityName!;
    } else if (countryName != null) {
      return countryName!;
    } else {
      return 'موقع غير محدد';
    }
  }
}