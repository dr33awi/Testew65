// lib/features/prayer_times/widgets/home_prayer_times_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:async';
import '../../../app/themes/index.dart';
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
              _errorMessage = null;
            });
          }
        },
        onError: (error) {
          if (mounted) {
            setState(() {
              _errorMessage = 'فشل في تحميل مواقيت الصلاة';
              _isLoading = false;
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
      
      if (_prayerService.currentLocation == null) {
        await _prayerService.getCurrentLocation();
      }
      await _prayerService.updatePrayerTimes();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'فشل في تحميل مواقيت الصلاة';
          _isLoading = false;
        });
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

    return IslamicCard.gradient(
      gradient: ThemeConstants.getPrayerGradient(nextPrayer.nameAr),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _navigateToPrayerTimes,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              child: Container(
                padding: const EdgeInsets.all(ThemeConstants.spaceLg),
                child: Column(
                  children: [
                    _buildHeader(context, nextPrayer),
                    Spaces.medium,
                    _buildNextPrayerSection(context, nextPrayer),
                    Spaces.large,
                    _buildPrayerTimeline(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        color: context.cardColor,
      ),
      child: const Center(
        child: IslamicLoading(message: 'جاري تحميل مواقيت الصلاة...'),
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        color: context.cardColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _loadInitialData,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          child: EmptyState(
            icon: Icons.error_outline,
            title: 'خطأ في تحميل المواقيت',
            subtitle: _errorMessage ?? 'حدث خطأ غير متوقع',
            action: IslamicButton.outlined(
              text: 'اضغط للمحاولة مرة أخرى',
              onPressed: _loadInitialData,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        color: context.cardColor,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _loadInitialData,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
          child: const EmptyState(
            icon: Icons.location_on,
            title: 'لم يتم تحديد الموقع',
            subtitle: 'اضغط لتحديد موقعك وعرض مواقيت الصلاة',
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PrayerTime nextPrayer) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(ThemeConstants.spaceMd),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: Icon(
            Icons.mosque,
            color: Colors.white,
            size: ThemeConstants.iconLg,
          ),
        ),
        Spaces.largeH,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مواقيت الصلاة',
                style: context.titleStyle.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
              Text(
                _location?.displayName ?? 'جاري تحديد الموقع...',
                style: context.captionStyle.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNextPrayerSection(BuildContext context, PrayerTime nextPrayer) {
    return IslamicCard.simple(
      color: Colors.white.withOpacity(0.15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.schedule_rounded,
                color: Colors.white.withOpacity(0.8),
                size: ThemeConstants.iconSm,
              ),
              Spaces.smallH,
              Text(
                'الصلاة القادمة',
                style: context.bodyStyle.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          Spaces.medium,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nextPrayer.nameAr,
                    style: context.titleStyle.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.fontBold,
                    ),
                  ),
                  Text(
                    _getNextPrayerMessage(nextPrayer.nameAr),
                    style: context.captionStyle.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_pulseAnimation.value * 0.05),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.spaceMd,
                        vertical: ThemeConstants.spaceSm,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                      ),
                      child: Text(
                        _formatTime(nextPrayer.time),
                        style: context.titleStyle.copyWith(
                          color: ThemeConstants.getPrayerColor(nextPrayer.nameAr),
                          fontWeight: ThemeConstants.fontBold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Spaces.medium,
          _buildTimeRemaining(context, nextPrayer),
        ],
      ),
    );
  }

  Widget _buildTimeRemaining(BuildContext context, PrayerTime nextPrayer) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        final remainingTime = nextPrayer.remainingTimeText;
        
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spaceMd,
            vertical: ThemeConstants.spaceSm,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_outlined,
                color: Colors.white.withOpacity(0.8),
                size: ThemeConstants.iconSm,
              ),
              Spaces.smallH,
              Text(
                remainingTime,
                style: context.bodyStyle.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: ThemeConstants.fontMedium,
                ),
              ),
            ],
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
        return Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.timeline_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: ThemeConstants.iconSm,
                ),
                Spaces.smallH,
                Text(
                  'جدول اليوم',
                  style: context.bodyStyle.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            Spaces.medium,
            SizedBox(
              height: 70,
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Container(
                      width: _calculateProgressWidth(context, mainPrayers),
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1),
                        boxShadow: ThemeConstants.shadowSm,
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
            ),
          ],
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
          width: isActive ? 32 : 28,
          height: isActive ? 32 : 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPassed || isActive ? Colors.white : Colors.white.withOpacity(0.4),
            border: Border.all(
              color: Colors.white.withOpacity(0.6),
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              isPassed && !isActive ? Icons.check : ThemeConstants.getPrayerIcon(prayer.nameAr),
              color: isPassed || isActive ? ThemeConstants.getPrayerColor(prayer.nameAr) : Colors.white,
              size: isActive ? 18 : 16,
            ),
          ),
        ),
        
        Spaces.xs,
        
        Text(
          prayer.nameAr,
          style: context.captionStyle.copyWith(
            color: Colors.white.withOpacity(isActive ? 1.0 : 0.7),
            fontWeight: isActive ? ThemeConstants.fontSemiBold : ThemeConstants.fontRegular,
            fontSize: 11,
          ),
        ),
        
        Text(
          _formatTime(prayer.time),
          style: context.captionStyle.copyWith(
            color: Colors.white.withOpacity(isActive ? 0.9 : 0.6),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  void _navigateToPrayerTimes() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/prayer-times').catchError((error) {
      if (mounted) {
        context.showInfoMessage('جاري تحميل الشاشة...');
      }
      return null;
    });
  }

  String _getNextPrayerMessage(String prayerName) {
    switch (prayerName) {
      case 'الفجر':
        return 'صلاة الفجر مباركة';
      case 'الظهر':
        return 'وقت صلاة الظهر';
      case 'العصر':
        return 'لا تفوت صلاة العصر';
      case 'المغرب':
        return 'حان وقت المغرب';
      case 'العشاء':
        return 'صلاة العشاء قد حانت';
      default:
        return 'استعد للصلاة';
    }
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
    
    final screenWidth = MediaQuery.of(context).size.width - 120;
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

// Extension للموقع
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