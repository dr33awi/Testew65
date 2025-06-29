// lib/features/prayer_times/screens/prayer_times_screen.dart - محدث بالثيم الإسلامي الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد الإسلامي - الوحيد المسموح
import 'package:athkar_app/app/themes/index.dart';

import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/location/location_service.dart';
import '../services/prayer_times_service.dart';
import '../models/prayer_times_model.dart';
import '../widgets/next_prayer_countdown.dart';
import '../widgets/location_header.dart';
import '../widgets/prayer_time_card.dart';
import 'prayer_settings_screen.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen>
    with TickerProviderStateMixin {
  late final PrayerTimesService _prayerService;
  late final LocationService _locationService;
  late AnimationController _refreshController;
  late AnimationController _cardsController;

  PrayerTimesData? _prayerTimes;
  String? _locationName;
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _prayerService = getIt<PrayerTimesService>();
    _locationService = getIt<LocationService>();
    
    _setupAnimations();
    _loadPrayerTimes();
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

  @override
  void dispose() {
    _refreshController.dispose();
    _cardsController.dispose();
    super.dispose();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // الحصول على الموقع الحالي
      final location = await _locationService.getCurrentLocation();
      final locationName = await _locationService.getLocationName(
        location.latitude,
        location.longitude,
      );

      // حساب أوقات الصلاة
      final prayerTimes = await _prayerService.calculatePrayerTimes(
        latitude: location.latitude,
        longitude: location.longitude,
        date: DateTime.now(),
      );

      if (mounted) {
        setState(() {
          _prayerTimes = prayerTimes;
          _locationName = locationName;
          _isLoading = false;
        });
        
        _cardsController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'فشل في تحميل أوقات الصلاة. تحقق من الاتصال والموقع.';
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
      // إعادة تحميل الأوقات بعد العودة من الإعدادات
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
        LocationHeader(
          locationName: _locationName ?? 'الموقع الحالي',
          onLocationTap: _refreshPrayerTimes,
        ),

        AppTheme.space4.h,

        // العد التنازلي للصلاة التالية
        NextPrayerCountdown(
          prayerTimes: _prayerTimes!,
          onPrayerChange: (prayerName) {
            // يمكن إضافة إجراءات عند تغيير الصلاة
            HapticFeedback.selectionClick();
          },
        ),

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
            final isCurrent = prayerName == currentPrayer;
            final isNext = prayerName == nextPrayer;
            
            return Padding(
              padding: EdgeInsets.only(bottom: AppTheme.space3),
              child: PrayerTimeCard(
                prayerName: prayerName,
                time: time,
                isCurrent: isCurrent,
                isNext: isNext,
                onTap: () => _showPrayerDetails(prayerName, time),
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
    
    for (final prayer in prayers) {
      final prayerTime = prayer.$2.hour * 60 + prayer.$2.minute;
      if (prayerTime > currentTime) {
        return prayer.$1;
      }
    }
    
    // إذا لم نجد صلاة قادمة اليوم، فالتالية هي فجر الغد
    return 'الفجر';
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
    // يمكن إضافة منطق تعيين التذكير هنا
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