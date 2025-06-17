// lib/features/prayer_times/widgets/home_prayer_times_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../models/prayer_time_model.dart';

class PrayerTimesCard extends StatefulWidget {
  final DailyPrayerTimes? dailyPrayerTimes;
  final VoidCallback? onTap;

  const PrayerTimesCard({
    super.key,
    this.dailyPrayerTimes,
    this.onTap,
  });

  @override
  State<PrayerTimesCard> createState() => _PrayerTimesCardState();
}

class _PrayerTimesCardState extends State<PrayerTimesCard>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
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

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
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

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dailyPrayerTimes == null) {
      return _buildLoadingCard(context);
    }

    final dailyTimes = widget.dailyPrayerTimes!;
    final nextPrayer = dailyTimes.nextPrayer;
    final mainPrayers = _getMainPrayers(dailyTimes.prayers);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: _getPrayerGradient(nextPrayer?.type ?? PrayerType.fajr),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                widget.onTap?.call();
              },
              borderRadius: BorderRadius.circular(24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    // رأس البطاقة
                    _buildHeader(context, dailyTimes),
                    
                    const SizedBox(height: 12),
                    
                    // الصلاة القادمة
                    if (nextPrayer != null)
                      _buildNextPrayerSection(context, nextPrayer),
                    
                    const SizedBox(height: 16),
                    
                    // خط زمني للصلوات
                    _buildPrayerTimeline(context, mainPrayers, nextPrayer),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 12),
            Text(
              'جاري تحميل مواقيت الصلاة...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, DailyPrayerTimes dailyTimes) {
    return Row(
      children: [
        // أيقونة المسجد
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.mosque,
            color: Colors.white,
            size: 32,
          ),
        ),
        
        const SizedBox(width: 16),
        
        // المعلومات
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مواقيت الصلاة',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${dailyTimes.location.cityName ?? 'الموقع الحالي'}, ${dailyTimes.location.countryName ?? ''}',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // عنوان الصلاة القادمة
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.schedule_rounded,
                color: Colors.white.withOpacity(0.8),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'الصلاة القادمة',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // اسم الصلاة والوقت
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nextPrayer.nameAr,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _getNextPrayerMessage(nextPrayer.type),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
              
              // الوقت مع تأثير النبض
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + (_pulseAnimation.value * 0.05),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _formatTime(nextPrayer.time),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: _getPrayerColor(nextPrayer.type),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // الوقت المتبقي
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
            horizontal: 12,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_outlined,
                color: Colors.white.withOpacity(0.8),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                remainingTime,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrayerTimeline(BuildContext context, List<PrayerTime> prayers, PrayerTime? nextPrayer) {
    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        return Column(
          children: [
            // عنوان التايم لاين
            Row(
              children: [
                Icon(
                  Icons.timeline_rounded,
                  color: Colors.white.withOpacity(0.8),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'جدول اليوم',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // التايم لاين
            SizedBox(
              height: 70,
              child: Stack(
                children: [
                  // الخط الأساسي
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
                  
                  // خط التقدم
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Container(
                      width: _calculateProgressWidth(context, prayers),
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
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
                    children: prayers.map((prayer) => 
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
        // النقطة
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
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
              isPassed && !isActive ? Icons.check : _getPrayerIcon(prayer.type),
              color: isPassed || isActive ? _getPrayerColor(prayer.type) : Colors.white,
              size: isActive ? 18 : 16,
            ),
          ),
        ),
        
        const SizedBox(height: 4),
        
        // اسم الصلاة
        Text(
          prayer.nameAr,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.white.withOpacity(isActive ? 1.0 : 0.7),
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            fontSize: 11,
          ),
        ),
        
        // الوقت
        Text(
          _formatTime(prayer.time),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.white.withOpacity(isActive ? 0.9 : 0.6),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  // دوال مساعدة
  List<PrayerTime> _getMainPrayers(List<PrayerTime> allPrayers) {
    return allPrayers.where((prayer) => 
      prayer.type == PrayerType.fajr ||
      prayer.type == PrayerType.dhuhr ||
      prayer.type == PrayerType.asr ||
      prayer.type == PrayerType.maghrib ||
      prayer.type == PrayerType.isha
    ).toList();
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$hour12:$minute $period';
  }

  LinearGradient _getPrayerGradient(PrayerType prayerType) {
    switch (prayerType) {
      case PrayerType.fajr:
        return const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case PrayerType.dhuhr:
        return const LinearGradient(
          colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case PrayerType.asr:
        return const LinearGradient(
          colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case PrayerType.maghrib:
        return const LinearGradient(
          colors: [Color(0xFFfa709a), Color(0xFFfee140)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case PrayerType.isha:
        return const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  Color _getPrayerColor(PrayerType prayerType) {
    switch (prayerType) {
      case PrayerType.fajr:
        return const Color(0xFF667eea);
      case PrayerType.dhuhr:
        return const Color(0xFFf5576c);
      case PrayerType.asr:
        return const Color(0xFF4facfe);
      case PrayerType.maghrib:
        return const Color(0xFFfa709a);
      case PrayerType.isha:
        return const Color(0xFF667eea);
      default:
        return const Color(0xFF667eea);
    }
  }

  IconData _getPrayerIcon(PrayerType prayerType) {
    switch (prayerType) {
      case PrayerType.fajr:
        return Icons.wb_twilight;
      case PrayerType.sunrise:
        return Icons.wb_sunny;
      case PrayerType.dhuhr:
        return Icons.wb_sunny_outlined;
      case PrayerType.asr:
        return Icons.wb_cloudy;
      case PrayerType.maghrib:
        return Icons.wb_twilight;
      case PrayerType.isha:
        return Icons.nights_stay;
      default:
        return Icons.schedule;
    }
  }

  String _getNextPrayerMessage(PrayerType prayerType) {
    switch (prayerType) {
      case PrayerType.fajr:
        return 'صلاة الفجر مباركة';
      case PrayerType.dhuhr:
        return 'وقت صلاة الظهر';
      case PrayerType.asr:
        return 'لا تفوت صلاة العصر';
      case PrayerType.maghrib:
        return 'حان وقت المغرب';
      case PrayerType.isha:
        return 'صلاة العشاء قد حانت';
      default:
        return 'استعد للصلاة';
    }
  }

  double _calculateProgressWidth(BuildContext context, List<PrayerTime> prayers) {
    if (prayers.isEmpty) return 0;
    
    final screenWidth = MediaQuery.of(context).size.width - 120;
    
    // العثور على الصلاة الحالية
    int currentPrayerIndex = 0;
    for (int i = 0; i < prayers.length; i++) {
      if (prayers[i].isPassed) {
        currentPrayerIndex = i;
      }
    }
    
    if (currentPrayerIndex == prayers.length - 1) {
      return screenWidth * _progressAnimation.value;
    }
    
    // حساب التقدم
    final progress = currentPrayerIndex / (prayers.length - 1);
    return screenWidth * progress * _progressAnimation.value;
  }
}