// lib/features/prayer_times/widgets/home_prayer_times_card.dart (محدث بالنظام الموحد)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:async';
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
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
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

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeService();
  }

  void _setupAnimations() {
    _progressController = AnimationController(
      duration: ThemeConstants.durationExtraSlow,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: ThemeConstants.curveSmooth,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _progressController.forward();
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
    _timesSubscription?.cancel();
    _nextPrayerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage != null && _dailyTimes == null) {
      return _buildErrorState();
    }

    if (_dailyTimes == null) {
      return _buildEmptyState();
    }

    final nextPrayer = _nextPrayer ?? _dailyTimes!.nextPrayer;
    if (nextPrayer == null) {
      return _buildEmptyState();
    }

    // استخدام AppCard من النظام الموحد
    return AppCard(
      type: CardType.normal,
      style: CardStyle.gradient,
      primaryColor: context.getPrayerColor(nextPrayer.nameAr),
      gradientColors: [
        context.getPrayerColor(nextPrayer.nameAr),
        context.getPrayerColor(nextPrayer.nameAr).darken(0.2),
      ],
      onTap: _navigateToPrayerTimes,
      child: Column(
        children: [
          _buildMainContent(context, nextPrayer),
          
          ThemeConstants.space3.h,
          
          _buildPrayerTimeline(context),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return AppCard(
      type: CardType.normal,
      style: CardStyle.normal,
      child: AppLoading.page(message: 'جاري تحميل مواقيت الصلاة...'),
    );
  }

  Widget _buildErrorState() {
    return AppCard.info(
      title: _errorMessage ?? 'خطأ في تحميل المواقيت',
      subtitle: 'اضغط للمحاولة مرة أخرى',
      icon: Icons.error_outline,
      iconColor: context.errorColor,
      onTap: _updatePrayerTimes,
    );
  }

  Widget _buildEmptyState() {
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

  Widget _buildMainContent(BuildContext context, PrayerTime nextPrayer) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: const Icon(
            Icons.mosque,
            color: Colors.white,
            size: ThemeConstants.iconMd,
          ),
        ),
        
        ThemeConstants.space3.w,
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مواقيت الصلاة',
                style: context.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.semiBold,
                ),
              ),
              
              Text(
                _location?.displayName ?? 'جاري تحديد الموقع...',
                style: context.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space3,
            vertical: ThemeConstants.space2,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Text(
                nextPrayer.nameAr,
                style: context.titleSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_pulseAnimation.value * 0.02),
                    child: Text(
                      _formatTime(nextPrayer.time),
                      style: context.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.semiBold,
                      ),
                    ),
                  );
                },
              ),
              
              _buildTimeRemaining(context, nextPrayer),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRemaining(BuildContext context, PrayerTime nextPrayer) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final remainingTime = nextPrayer.remainingTimeText;
        
        return Container(
          margin: const EdgeInsets.only(top: ThemeConstants.space1),
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space2,
            vertical: 2,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
          ),
          child: Text(
            remainingTime,
            style: context.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 10,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPrayerTimeline(BuildContext context) {
    if (_dailyTimes == null) return const SizedBox.shrink();
    
    final mainPrayers = _dailyTimes!.prayers.where((prayer) => 
      prayer.type != PrayerType.sunrise
    ).toList();

    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return SizedBox(
          height: 50,
          child: Stack(
            children: [
              Positioned(
                top: 15,
                left: 15,
                right: 15,
                child: Container(
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ),
              
              Positioned(
                top: 15,
                left: 15,
                child: Container(
                  width: _calculateProgressWidth(context, mainPrayers),
                  height: 2,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.3),
                        blurRadius: 2,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: mainPrayers.map((prayer) => 
                  _buildTimelinePoint(context, prayer)
                ).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelinePoint(BuildContext context, PrayerTime prayer) {
    final isActive = prayer.isNext;
    final isPassed = prayer.isPassed;
    
    return Column(
      children: [
        AnimatedContainer(
          duration: ThemeConstants.durationNormal,
          width: isActive ? 20 : 16,
          height: isActive ? 20 : 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPassed || isActive ? Colors.white : Colors.white.withValues(alpha: 0.4),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
              width: 1,
            ),
          ),
          child: Center(
            child: Icon(
              isPassed && !isActive ? Icons.check : context.getPrayerIcon(prayer.nameAr),
              color: isPassed || isActive ? context.getPrayerColor(prayer.nameAr) : Colors.white,
              size: isActive ? 12 : 10,
            ),
          ),
        ),
        
        ThemeConstants.space1.h,
        
        Text(
          prayer.nameAr,
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.7),
            fontWeight: isActive ? ThemeConstants.semiBold : ThemeConstants.regular,
            fontSize: 9,
          ),
        ),
        
        Text(
          _formatTime(prayer.time),
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: isActive ? 0.9 : 0.6),
            fontSize: 8,
          ),
        ),
      ],
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

  double _calculateProgressWidth(BuildContext context, List<PrayerTime> prayers) {
    if (prayers.isEmpty) return 0.0;
    
    final screenWidth = MediaQuery.of(context).size.width - 90;
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
      return screenWidth * _progressAnimation.value;
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
    
    return (screenWidth / (prayers.length - 1)) * progress * _progressAnimation.value;
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