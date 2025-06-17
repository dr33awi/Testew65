// lib/features/prayer_times/widgets/home_prayer_times_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';

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

  // بيانات وهمية - يجب استبدالها ببيانات حقيقية من الخدمة
  final List<PrayerTimeData> prayerTimes = [
    PrayerTimeData(name: 'الفجر', time: '05:30', isPassed: true, isNext: false),
    PrayerTimeData(name: 'الشروق', time: '07:00', isPassed: true, isNext: false),
    PrayerTimeData(name: 'الظهر', time: '12:15', isPassed: true, isNext: false),
    PrayerTimeData(name: 'العصر', time: '15:45', isPassed: false, isNext: true),
    PrayerTimeData(name: 'المغرب', time: '18:20', isPassed: false, isNext: false),
    PrayerTimeData(name: 'العشاء', time: '19:50', isPassed: false, isNext: false),
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
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

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nextPrayer = prayerTimes.firstWhere(
      (prayer) => prayer.isNext,
      orElse: () => prayerTimes.first,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: _getPrayerGradient(nextPrayer.name),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _navigateToPrayerTimes,
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              child: Container(
                padding: const EdgeInsets.all(ThemeConstants.space5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                ),
                child: Column(
                  children: [
                    // رأس البطاقة
                    _buildHeader(context, nextPrayer),
                    
                    ThemeConstants.space3.h,
                    
                    // الصلاة القادمة
                    _buildNextPrayerSection(context, nextPrayer),
                    
                    ThemeConstants.space4.h,
                    
                    // خط زمني للصلوات
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

  Widget _buildHeader(BuildContext context, PrayerTimeData nextPrayer) {
    return Row(
      children: [
        // أيقونة المسجد
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space3),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: Icon(
            Icons.mosque,
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
                'مواقيت الصلاة',
                style: context.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              Text(
                'الرياض، المملكة العربية السعودية',
                style: context.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNextPrayerSection(BuildContext context, PrayerTimeData nextPrayer) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space3),
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
          // عنوان الصلاة القادمة
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.schedule_rounded,
                color: Colors.white.withValues(alpha: 0.8),
                size: ThemeConstants.iconSm,
              ),
              ThemeConstants.space2.w,
              Text(
                'الصلاة القادمة',
                style: context.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          
          ThemeConstants.space2.h,
          
          // اسم الصلاة والوقت
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nextPrayer.name,
                    style: context.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                    ),
                  ),
                  Text(
                    _getNextPrayerMessage(nextPrayer.name),
                    style: context.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
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
                        horizontal: ThemeConstants.space3,
                        vertical: ThemeConstants.space1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                      ),
                      child: Text(
                        nextPrayer.time,
                        style: context.titleMedium?.copyWith(
                          color: _getPrayerColor(nextPrayer.name),
                          fontWeight: ThemeConstants.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          
          ThemeConstants.space2.h,
          
          // الوقت المتبقي
          _buildTimeRemaining(context),
        ],
      ),
    );
  }

  Widget _buildTimeRemaining(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        // حساب الوقت المتبقي (مثال)
        const remainingTime = '2 ساعة و 15 دقيقة';
        
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space3,
            vertical: ThemeConstants.space1,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_outlined,
                color: Colors.white.withValues(alpha: 0.8),
                size: ThemeConstants.iconSm,
              ),
              ThemeConstants.space1.w,
              Text(
                'بعد $remainingTime',
                style: context.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: ThemeConstants.medium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPrayerTimeline(BuildContext context) {
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
                  color: Colors.white.withValues(alpha: 0.8),
                  size: ThemeConstants.iconSm,
                ),
                ThemeConstants.space2.w,
                Text(
                  'جدول اليوم',
                  style: context.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
            
            ThemeConstants.space3.h,
            
            // التايم لاين
            SizedBox(
              height: 70,
              child: Stack(
                children: [
                  // الخط الأساسي خلف الأيقونات (غير مكتمل)
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                  
                  // خط التقدم التدريجي
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Container(
                      width: _calculateProgressWidth(context),
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(1),
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
                  
                  // نقاط الصلوات فوق الخط
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: prayerTimes.map((prayer) => 
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

  Widget _buildTimelinePoint(BuildContext context, PrayerTimeData prayer) {
    final isActive = prayer.isNext;
    final isPassed = prayer.isPassed;
    
    return Column(
      children: [
        // النقطة (الأيقونة)
        AnimatedContainer(
          duration: ThemeConstants.durationNormal,
          width: isActive ? 32 : 28,
          height: isActive ? 32 : 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isPassed || isActive ? Colors.white : Colors.white.withValues(alpha: 0.4),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              isPassed && !isActive ? Icons.check : _getPrayerIcon(prayer.name),
              color: isPassed || isActive ? _getPrayerColor(prayer.name) : Colors.white,
              size: isActive ? 18 : 16,
            ),
          ),
        ),
        
        ThemeConstants.space1.h,
        
        // اسم الصلاة
        Text(
          prayer.name,
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.7),
            fontWeight: isActive ? ThemeConstants.semiBold : ThemeConstants.regular,
            fontSize: 11,
          ),
        ),
        
        // الوقت
        Text(
          prayer.time,
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: isActive ? 0.9 : 0.6),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  void _navigateToPrayerTimes() {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/prayer-times').catchError((error) {
      if (context.mounted) {
        context.showInfoSnackBar('هذه الميزة قيد التطوير');
      }
      return null;
    });
  }

  // دوال مساعدة
  LinearGradient _getPrayerGradient(String prayerName) {
    return ThemeConstants.prayerGradient(prayerName);
  }

  Color _getPrayerColor(String prayerName) {
    return ThemeConstants.getPrayerColor(prayerName);
  }

  IconData _getPrayerIcon(String prayerName) {
    return ThemeConstants.getPrayerIcon(prayerName);
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

  double _getDayProgress() {
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    return currentMinutes / 1440; // 1440 دقيقة في اليوم
  }

  double _calculateProgressWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width - 120; // عرض الشاشة مطروحاً منه الهوامش
    final totalPrayers = prayerTimes.length;
    final sectionWidth = screenWidth / (totalPrayers - 1); // عرض كل قسم بين الصلوات
    
    // حساب موقع كل صلاة بالدقائق (تقريبي)
    final prayerTimes24h = [
      5 * 60 + 30,  // الفجر 05:30
      7 * 60 + 0,   // الشروق 07:00
      12 * 60 + 15, // الظهر 12:15
      15 * 60 + 45, // العصر 15:45
      18 * 60 + 20, // المغرب 18:20
      19 * 60 + 50, // العشاء 19:50
    ];
    
    final now = DateTime.now();
    final currentMinutes = now.hour * 60 + now.minute;
    
    // العثور على الصلاة الحالية
    int currentPrayerIndex = 0;
    for (int i = 0; i < prayerTimes24h.length; i++) {
      if (currentMinutes >= prayerTimes24h[i]) {
        currentPrayerIndex = i;
      } else {
        break;
      }
    }
    
    // إذا كان الوقت بعد العشاء، فالخط يصل للنهاية
    if (currentMinutes >= prayerTimes24h.last) {
      return screenWidth * _progressAnimation.value;
    }
    
    // إذا كان الوقت قبل الفجر، فلا يوجد خط
    if (currentMinutes < prayerTimes24h[0]) {
      return 0;
    }
    
    // حساب التقدم داخل القسم الحالي
    double progress;
    if (currentPrayerIndex == prayerTimes24h.length - 1) {
      // إذا كنا في آخر صلاة
      progress = currentPrayerIndex.toDouble();
    } else {
      final nextPrayerTime = prayerTimes24h[currentPrayerIndex + 1];
      final currentPrayerTime = prayerTimes24h[currentPrayerIndex];
      final sectionProgress = (currentMinutes - currentPrayerTime) / (nextPrayerTime - currentPrayerTime);
      progress = currentPrayerIndex + sectionProgress.clamp(0.0, 1.0);
    }
    
    return (screenWidth / (totalPrayers - 1)) * progress * _progressAnimation.value;
  }
}

/// نموذج بيانات وقت الصلاة
class PrayerTimeData {
  final String name;
  final String time;
  final bool isPassed;
  final bool isNext;

  const PrayerTimeData({
    required this.name,
    required this.time,
    required this.isPassed,
    required this.isNext,
  });
}