// lib/features/prayer_times/widgets/home_prayer_times_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';
import '../models/prayer_time_model.dart';
import '../services/prayer_times_service.dart';
import '../utils/prayer_extensions.dart';
import '../../../app/di/service_locator.dart';

class PrayerTimesCard extends StatefulWidget {
  const PrayerTimesCard({super.key});

  @override
  State<PrayerTimesCard> createState() => _PrayerTimesCardState();
}

class _PrayerTimesCardState extends State<PrayerTimesCard>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  late PrayerTimesService _prayerTimesService;
  DailyPrayerTimes? _dailyTimes;
  PrayerTime? _nextPrayer;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _prayerTimesService = getService<PrayerTimesService>();
    _setupAnimations();
    _initializePrayerTimes();
  }

  void _setupAnimations() {
    // تحسين: تقليل سرعة الحركة
    _pulseController = AnimationController(
      duration: const Duration(seconds: 3), // زيادة المدة
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _initializePrayerTimes() async {
    try {
      // محاولة الحصول على المواقيت المحفوظة أولاً
      final cachedTimes = await _prayerTimesService.getCachedPrayerTimes(DateTime.now());
      
      if (cachedTimes != null) {
        setState(() {
          _dailyTimes = cachedTimes.updatePrayerStates();
          _nextPrayer = _dailyTimes?.nextPrayer;
          _isLoading = false;
        });
      }
      
      // تحديث المواقيت
      await _prayerTimesService.updatePrayerTimes();
      
      // الاستماع للتحديثات
      _prayerTimesService.prayerTimesStream.listen((times) {
        if (mounted) {
          setState(() {
            _dailyTimes = times;
            _nextPrayer = times.nextPrayer;
            _isLoading = false;
            _errorMessage = null;
          });
        }
      });
      
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'خطأ في تحميل مواقيت الصلاة';
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // في حالة التحميل
    if (_isLoading) {
      return _buildLoadingCard(context);
    }
    
    // في حالة الخطأ
    if (_errorMessage != null) {
      return _buildErrorCard(context);
    }
    
    // في حالة عدم وجود بيانات
    if (_dailyTimes == null) {
      return _buildNoDataCard(context);
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: _getPrayerGradient(_nextPrayer?.nameAr ?? 'الفجر'),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _navigateToPrayerTimes,
            borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            child: Container(
              padding: const EdgeInsets.all(ThemeConstants.space4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              ),
              child: Column(
                children: [
                  // رأس البطاقة المدمج
                  _buildCompactHeader(context),
                  
                  ThemeConstants.space4.h,
                  
                  // نقاط الصلوات المبسطة
                  _buildSimplePrayerPoints(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactHeader(BuildContext context) {
    final location = _prayerTimesService.currentLocation;
    
    return Row(
      children: [
        // أيقونة المسجد
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space3),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: const Icon(
            Icons.mosque,
            color: Colors.white,
            size: ThemeConstants.iconLg,
          ),
        ),
        
        ThemeConstants.space4.w,
        
        // المعلومات المدمجة
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'الصلاة القادمة: ',
                    style: context.labelMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    _nextPrayer?.nameAr ?? 'غير محدد',
                    style: context.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                    ),
                  ),
                ],
              ),
              ThemeConstants.space1.h,
              // الوقت والوقت المتبقي
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ThemeConstants.space2,
                      vertical: ThemeConstants.space1,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                    ),
                    child: Text(
                      _nextPrayer?.formattedTime ?? '--:--',
                      style: context.titleSmall?.copyWith(
                        color: _getPrayerColor(_nextPrayer?.nameAr ?? 'الفجر'),
                        fontWeight: ThemeConstants.bold,
                      ),
                    ),
                  ),
                  ThemeConstants.space2.w,
                  Icon(
                    Icons.schedule_rounded,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: ThemeConstants.iconXs,
                  ),
                  ThemeConstants.space1.w,
                  Expanded(
                    child: Text(
                      _nextPrayer?.formattedRemainingTime ?? 'غير محدد',
                      style: context.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // زر التفاصيل
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space2),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
          ),
          child: const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
            size: ThemeConstants.iconSm,
          ),
        ),
      ],
    );
  }

  Widget _buildSimplePrayerPoints(BuildContext context) {
    final prayers = _dailyTimes?.prayers ?? [];
    
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: prayers.map((prayer) => 
          _buildSimpleTimePoint(context, prayer)
        ).toList(),
      ),
    );
  }

  Widget _buildSimpleTimePoint(BuildContext context, PrayerTime prayer) {
    final isActive = prayer.isNext;
    final isPassed = prayer.isPassed;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // تحسين: الأيقونة مع تأثير محدود للصلاة القادمة
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Container(
              width: isActive ? 32 : 28,
              height: isActive ? 32 : 28,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPassed || isActive ? Colors.white : Colors.white.withValues(alpha: 0.4),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.6),
                  width: 1,
                ),
                boxShadow: isActive ? [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.3 + (_pulseAnimation.value * 0.2)), // تقليل التأثير
                    blurRadius: 4 + (_pulseAnimation.value * 6), // تقليل التأثير
                    spreadRadius: 1 + (_pulseAnimation.value * 1), // تقليل التأثير
                  ),
                ] : null,
              ),
              child: Center(
                child: Transform.scale(
                  scale: isActive ? 1.0 + (_pulseAnimation.value * 0.1) : 1.0, // تقليل التحجيم
                  child: Icon(
                    prayer.icon,
                    color: isPassed || isActive ? prayer.color : Colors.white,
                    size: isActive ? 16 : 14,
                  ),
                ),
              ),
            );
          },
        ),
        
        ThemeConstants.space2.h,
        
        // اسم الصلاة
        Text(
          prayer.nameAr,
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.7),
            fontWeight: isActive ? ThemeConstants.semiBold : ThemeConstants.regular,
            fontSize: 11,
          ),
        ),
        
        // الوقت
        Text(
          prayer.formattedTime,
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: isActive ? 0.9 : 0.6),
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CircularProgressIndicator(
            color: context.primaryColor,
            strokeWidth: 2,
          ),
          ThemeConstants.space3.h,
          Text(
            'جاري تحميل مواقيت الصلاة...',
            style: context.labelMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.error_outline,
            color: context.errorColor,
            size: ThemeConstants.iconLg,
          ),
          ThemeConstants.space2.h,
          Text(
            _errorMessage ?? 'حدث خطأ',
            style: context.labelMedium?.copyWith(
              color: context.errorColor,
            ),
            textAlign: TextAlign.center,
          ),
          ThemeConstants.space2.h,
          ElevatedButton(
            onPressed: _initializePrayerTimes,
            child: Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        border: Border.all(
          color: context.dividerColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.location_off,
            color: context.textSecondaryColor,
            size: ThemeConstants.iconLg,
          ),
          ThemeConstants.space2.h,
          Text(
            'لا توجد بيانات مواقيت الصلاة',
            style: context.labelMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
          ThemeConstants.space2.h,
          ElevatedButton(
            onPressed: _initializePrayerTimes,
            child: Text('تحديث'),
          ),
        ],
      ),
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
}

/// نموذج بيانات وقت الصلاة (مهجور - للتوافق مع القديم)
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