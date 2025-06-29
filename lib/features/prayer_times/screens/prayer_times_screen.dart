// lib/features/prayer_times/screens/prayer_times_screen.dart - محدث بالثيم الإسلامي الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

// ✅ استيراد النظام الموحد الإسلامي - الوحيد المسموح
import 'package:athkar_app/app/themes/index.dart';

import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import 'prayer_settings_screen.dart';

// نموذج بيانات بسيط لأوقات الصلاة
class PrayerTimesData {
  final DateTime fajr;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final String location;

  PrayerTimesData({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.location,
  });
}

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen>
    with TickerProviderStateMixin {
  late final LoggerService _logger;
  late AnimationController _refreshController;
  late AnimationController _cardsController;
  late Timer _timer;

  PrayerTimesData? _prayerTimes;
  String _locationName = 'الرياض، السعودية';
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _logger = getIt<LoggerService>();
    
    _setupAnimations();
    _loadPrayerTimes();
    _setupTimer();
  }

  void _setupAnimations() {
    _refreshController = AnimationController(
      duration: AppTheme.durationNormal,
      vsync: this,
    );
    
    _cardsController = AnimationController(
      duration: AppTheme.durationSlow,
      vsync: this,
    );
  }

  void _setupTimer() {
    // تحديث كل دقيقة
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      if (mounted) {
        setState(() {}); // إعادة بناء الواجهة لتحديث الأوقات
      }
    });
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _cardsController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // محاكاة تحميل البيانات
      await Future.delayed(const Duration(seconds: 1));

      // أوقات صلاة تجريبية للرياض
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      
      final prayerTimes = PrayerTimesData(
        fajr: today.add(const Duration(hours: 4, minutes: 45)),
        dhuhr: today.add(const Duration(hours: 12, minutes: 15)),
        asr: today.add(const Duration(hours: 15, minutes: 30)),
        maghrib: today.add(const Duration(hours: 18, minutes: 5)),
        isha: today.add(const Duration(hours: 19, minutes: 35)),
        location: _locationName,
      );

      if (mounted) {
        setState(() {
          _prayerTimes = prayerTimes;
          _isLoading = false;
        });
        
        _cardsController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'فشل في تحميل أوقات الصلاة. تحقق من الاتصال.';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshPrayerTimes() async {
    HapticFeedback.lightImpact();
    _refreshController.repeat();
    
    await _loadPrayerTimes();
    
    if (mounted) {
      _refreshController.stop();
      _refreshController.reset();
    }
  }

  void _openSettings() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PrayerSettingsScreen(),
      ),
    ).then((_) {
      _loadPrayerTimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppAppBar.basic(
        title: 'أوقات الصلاة',
        actions: [
          // زر التحديث
          RotationTransition(
            turns: _refreshController,
            child: IconButton(
              icon: const Icon(Icons.refresh),
              color: AppTheme.textSecondary,
              onPressed: _isLoading ? null : _refreshPrayerTimes,
              tooltip: 'تحديث الأوقات',
            ),
          ),
          
          // زر الإعدادات
          IconButton(
            icon: const Icon(Icons.settings),
            color: AppTheme.textSecondary,
            onPressed: _openSettings,
            tooltip: 'إعدادات الصلاة',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return AppLoading.page(message: 'جاري تحميل أوقات الصلاة...');
    }

    if (_errorMessage != null) {
      return AppEmptyState.noData(
        message: _errorMessage!,
        onRetry: _loadPrayerTimes,
      );
    }

    if (_prayerTimes == null) {
      return AppEmptyState.noData(
        message: 'لم يتم العثور على أوقات الصلاة',
        onRetry: _loadPrayerTimes,
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshPrayerTimes,
      color: AppTheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: AnimatedBuilder(
          animation: _cardsController,
          builder: (context, child) {
            return FadeTransition(
              opacity: _cardsController,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _cardsController,
                  curve: Curves.easeOut,
                )),
                child: _buildContent(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        // معلومات الموقع
        _buildLocationHeader(),

        AppTheme.space4.h,

        // العد التنازلي للصلاة التالية
        _buildNextPrayerCountdown(),

        AppTheme.space6.h,

        // قائمة أوقات الصلاة
        _buildPrayerTimesList(),

        AppTheme.space6.h,

        // معلومات إضافية
        _buildAdditionalInfo(),

        AppTheme.space8.h,
      ],
    );
  }

  Widget _buildLocationHeader() {
    return AppCard.basic(
      title: _locationName,
      subtitle: 'اضغط للتحديث أو تغيير الموقع',
      icon: Icons.location_on,
      color: AppTheme.info,
      onTap: _refreshPrayerTimes,
    );
  }

  Widget _buildNextPrayerCountdown() {
    final nextPrayer = _getNextPrayer();
    final nextPrayerTime = _getNextPrayerTime();
    final timeToNext = _getTimeToNextPrayer();
    
    if (nextPrayer == null || nextPrayerTime == null || timeToNext == null) {
      return const SizedBox.shrink();
    }

    final isNegative = timeToNext.isNegative;
    final displayTime = isNegative ? Duration.zero : timeToNext;

    return AppCard(
      useGradient: true,
      color: AppTheme.getPrayerColor(nextPrayer),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                AppTheme.getPrayerIcon(nextPrayer),
                color: Colors.white,
                size: AppTheme.iconLg,
              ),
              AppTheme.space3.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الصلاة القادمة',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    AppTheme.space1.h,
                    Text(
                      nextPrayer,
                      style: AppTheme.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                AppTheme.formatPrayerTime(nextPrayerTime),
                style: AppTheme.headlineMedium.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.bold,
                  fontFamily: AppTheme.numbersFont,
                ),
              ),
            ],
          ),
          
          if (!isNegative) ...[
            AppTheme.space3.h,
            Container(
              padding: AppTheme.space3.padding,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: AppTheme.radiusMd.radius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.schedule,
                    color: Colors.white,
                    size: AppTheme.iconSm,
                  ),
                  AppTheme.space2.w,
                  Text(
                    'بعد ${AppTheme.formatDuration(displayTime)}',
                    style: AppTheme.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: AppTheme.semiBold,
                      fontFamily: AppTheme.numbersFont,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPrayerTimesList() {
    final prayers = PrayerUtils.getMainPrayers();
    final currentPrayer = _getCurrentPrayer();
    final nextPrayer = _getNextPrayer();

    return Padding(
      padding: AppTheme.space4.paddingH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'أوقات الصلوات اليوم',
            style: AppTheme.titleLarge.copyWith(
              fontWeight: AppTheme.bold,
            ),
          ),
          
          AppTheme.space3.h,
          
          ...prayers.map((prayerName) {
            final time = _getPrayerTime(prayerName);
            final prayerTime = _getPrayerDateTime(prayerName);
            final isCurrent = prayerName == currentPrayer;
            final isNext = prayerName == nextPrayer;
            
            return Padding(
              padding: EdgeInsets.only(bottom: AppTheme.space3),
              child: AppCard.prayer(
                prayerName: prayerName,
                time: time,
                isCurrent: isCurrent,
                isNext: isNext,
                onTap: () => _showPrayerDetails(prayerName, time),
                remainingTime: isNext ? _getTimeToNextPrayer() : null,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Padding(
      padding: AppTheme.space4.paddingH,
      child: Column(
        children: [
          // إحصائيات سريعة
          Row(
            children: [
              Expanded(
                child: AppCard.stat(
                  title: 'الفجر',
                  value: _getPrayerTime('الفجر'),
                  icon: AppTheme.getPrayerIcon('الفجر'),
                  color: AppTheme.getPrayerColor('الفجر'),
                ),
              ),
              AppTheme.space3.w,
              Expanded(
                child: AppCard.stat(
                  title: 'المغرب',
                  value: _getPrayerTime('المغرب'),
                  icon: AppTheme.getPrayerIcon('المغرب'),
                  color: AppTheme.getPrayerColor('المغرب'),
                ),
              ),
            ],
          ),

          AppTheme.space4.h,

          // رسالة تذكيرية
          MessageCards.info(
            title: 'تذكير',
            message: 'يتم حساب الأوقات بناءً على موقعك الحالي. تأكد من تفعيل خدمات الموقع للحصول على أوقات دقيقة.',
            isDismissible: true,
          ),
        ],
      ),
    );
  }

  String _getPrayerTime(String prayerName) {
    if (_prayerTimes == null) return '--:--';
    
    switch (prayerName) {
      case 'الفجر':
        return AppTheme.formatPrayerTime(_prayerTimes!.fajr);
      case 'الظهر':
        return AppTheme.formatPrayerTime(_prayerTimes!.dhuhr);
      case 'العصر':
        return AppTheme.formatPrayerTime(_prayerTimes!.asr);
      case 'المغرب':
        return AppTheme.formatPrayerTime(_prayerTimes!.maghrib);
      case 'العشاء':
        return AppTheme.formatPrayerTime(_prayerTimes!.isha);
      default:
        return '--:--';
    }
  }

  DateTime? _getPrayerDateTime(String prayerName) {
    if (_prayerTimes == null) return null;
    
    switch (prayerName) {
      case 'الفجر':
        return _prayerTimes!.fajr;
      case 'الظهر':
        return _prayerTimes!.dhuhr;
      case 'العصر':
        return _prayerTimes!.asr;
      case 'المغرب':
        return _prayerTimes!.maghrib;
      case 'العشاء':
        return _prayerTimes!.isha;
      default:
        return null;
    }
  }

  String? _getCurrentPrayer() {
    if (_prayerTimes == null) return null;
    
    final now = DateTime.now();
    final currentTime = now.hour * 60 + now.minute;
    
    final prayers = [
      ('الفجر', _prayerTimes!.fajr),
      ('الظهر', _prayerTimes!.dhuhr),
      ('العصر', _prayerTimes!.asr),
      ('المغرب', _prayerTimes!.maghrib),
      ('العشاء', _prayerTimes!.isha),
    ];
    
    String? currentPrayer;
    for (int i = 0; i < prayers.length; i++) {
      final prayerTime = prayers[i].$2.hour * 60 + prayers[i].$2.minute;
      
      if (currentTime >= prayerTime) {
        currentPrayer = prayers[i].$1;
      } else {
        break;
      }
    }
    
    return currentPrayer;
  }

  String? _getNextPrayer() {
    if (_prayerTimes == null) return null;
    
    final now = DateTime.now();
    final currentTime = now.hour * 60 + now.minute;
    
    final prayers = [
      ('الفجر', _prayerTimes!.fajr),
      ('الظهر', _prayerTimes!.dhuhr),
      ('العصر', _prayerTimes!.asr),
      ('المغرب', _prayerTimes!.maghrib),
      ('العشاء', _prayerTimes!.isha),
    ];
    
    // البحث عن أول صلاة لم تحن بعد
    for (final prayer in prayers) {
      final prayerTime = prayer.$2.hour * 60 + prayer.$2.minute;
      if (prayerTime > currentTime) {
        return prayer.$1;
      }
    }
    
    // إذا لم نجد صلاة قادمة اليوم، فالتالية هي فجر الغد
    return 'الفجر';
  }

  DateTime? _getNextPrayerTime() {
    final nextPrayer = _getNextPrayer();
    if (nextPrayer == null) return null;
    
    final prayerTime = _getPrayerDateTime(nextPrayer);
    if (prayerTime == null) return null;
    
    final now = DateTime.now();
    
    // إذا كانت الصلاة قد فاتت اليوم، فهي غداً
    if (prayerTime.isBefore(now)) {
      return prayerTime.add(const Duration(days: 1));
    }
    
    return prayerTime;
  }

  Duration? _getTimeToNextPrayer() {
    final nextPrayerTime = _getNextPrayerTime();
    if (nextPrayerTime == null) return null;
    
    final now = DateTime.now();
    return nextPrayerTime.difference(now);
  }

  void _showPrayerDetails(String prayerName, String time) {
    HapticFeedback.lightImpact();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: context.screenHeight * 0.6,
        ),
        child: AppCard(
          useGradient: true,
          color: AppTheme.getPrayerColor(prayerName),
          margin: EdgeInsets.zero,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // مقبض السحب
              Container(
                margin: AppTheme.space3.paddingV,
                width: AppTheme.iconXl + AppTheme.space2,
                height: AppTheme.space1,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.6),
                  borderRadius: AppTheme.radiusXs.radius,
                ),
              ),
              
              Flexible(
                child: Padding(
                  padding: AppTheme.space5.padding,
                  child: Column(
                    children: [
                      // أيقونة وعنوان
                      Icon(
                        AppTheme.getPrayerIcon(prayerName),
                        size: AppTheme.iconXl + AppTheme.space4,
                        color: Colors.white,
                      ),
                      
                      AppTheme.space3.h,
                      
                      Text(
                        'صلاة $prayerName',
                        style: AppTheme.headlineMedium.copyWith(
                          color: Colors.white,
                          fontWeight: AppTheme.bold,
                        ),
                      ),
                      
                      AppTheme.space2.h,
                      
                      Text(
                        time,
                        style: AppTheme.displayMedium.copyWith(
                          color: Colors.white,
                          fontFamily: AppTheme.numbersFont,
                          fontWeight: AppTheme.bold,
                        ),
                      ),
                      
                      AppTheme.space4.h,
                      
                      // معلومات إضافية
                      AppCard(
                        color: Colors.white.withValues(alpha: 0.15),
                        child: Text(
                          _getPrayerDescription(prayerName),
                          style: AppTheme.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.6,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      AppTheme.space5.h,
                      
                      // أزرار العمليات
                      Row(
                        children: [
                          Expanded(
                            child: AppButton.outline(
                              text: 'تذكير',
                              icon: Icons.notifications,
                              onPressed: () {
                                Navigator.pop(context);
                                _setReminderForPrayer(prayerName);
                              },
                              borderColor: Colors.white,
                            ),
                          ),
                          
                          AppTheme.space3.w,
                          
                          Expanded(
                            child: AppButton.primary(
                              text: 'إغلاق',
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getPrayerDescription(String prayerName) {
    switch (prayerName) {
      case 'الفجر':
        return 'صلاة الفجر من أعظم الصلوات، وقت السكينة والهدوء قبل بداية النهار.';
      case 'الظهر':
        return 'صلاة الظهر في وسط النهار، وقت الاستراحة والتواصل مع الله.';
      case 'العصر':
        return 'صلاة العصر، الصلاة الوسطى التي أمرنا الله بالمحافظة عليها.';
      case 'المغرب':
        return 'صلاة المغرب عند غروب الشمس، وقت التأمل وختام النهار.';
      case 'العشاء':
        return 'صلاة العشاء آخر صلوات اليوم، وقت الاستغفار والدعاء.';
      default:
        return 'إحدى الصلوات الخمس المفروضة على كل مسلم.';
    }
  }

  void _setReminderForPrayer(String prayerName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم تفعيل تذكير صلاة $prayerName'),
        backgroundColor: AppTheme.success,
        duration: AppTheme.durationNormal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusMd.radius,
        ),
      ),
    );
  }
}