// lib/features/prayer_times/screens/prayer_times_screen.dart

import 'package:flutter/material.dart';
import '../../../app/themes/index.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/routes/app_router.dart';
import '../models/prayer_time_model.dart';
import '../services/prayer_times_service.dart';
import '../widgets/prayer_card.dart' as prayer_widgets;
import '../widgets/location_card.dart' as location_widgets;

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  late final PrayerTimesService _prayerService;
  bool _isLoading = true;
  bool _isLocationLoading = false;
  String? _error;
  DailyPrayerTimes? _currentTimes;

  @override
  void initState() {
    super.initState();
    _prayerService = getService<PrayerTimesService>();
    _initializePrayerTimes();
    _listenToPrayerTimes();
  }

  /// تهيئة مواقيت الصلاة
  Future<void> _initializePrayerTimes() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // تحديث المواقيت
      await _prayerService.updatePrayerTimes();
      
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  /// الاستماع لتحديثات مواقيت الصلاة
  void _listenToPrayerTimes() {
    _prayerService.prayerTimesStream.listen(
      (times) {
        if (mounted) {
          setState(() {
            _currentTimes = times;
            _error = null;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() {
            _error = error.toString();
          });
        }
      },
    );
  }

  /// تحديث الموقع
  Future<void> _updateLocation() async {
    setState(() {
      _isLocationLoading = true;
    });

    try {
      await _prayerService.getCurrentLocation();
      await _prayerService.updatePrayerTimes();
      
      if (mounted) {
        context.showSuccessMessage('تم تحديث الموقع بنجاح');
      }
    } catch (e) {
      if (mounted) {
        context.showErrorMessage('فشل تحديث الموقع: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLocationLoading = false;
        });
      }
    }
  }

  /// فتح الإعدادات
  void _openSettings() {
    AppRouter.push(AppRouter.prayerSettings);
  }

  /// فتح إعدادات التنبيهات
  void _openNotificationSettings() {
    AppRouter.push(AppRouter.prayerNotificationsSettings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(
        title: 'مواقيت الصلاة',
        actions: [
          IconButton(
            onPressed: _openNotificationSettings,
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'إعدادات التنبيهات',
          ),
          IconButton(
            onPressed: _openSettings,
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'إعدادات الحساب',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _initializePrayerTimes,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: IslamicLoading(
          message: 'جارٍ تحميل مواقيت الصلاة...',
        ),
      );
    }

    if (_error != null) {
      return _buildErrorState();
    }

    if (_currentTimes == null) {
      return _buildEmptyState();
    }

    return _buildPrayerTimesContent();
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.largePadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: context.errorColor,
            ),
            
            Spaces.large,
            
            Text(
              'خطأ في تحميل المواقيت',
              style: context.titleStyle,
              textAlign: TextAlign.center,
            ),
            
            Spaces.medium,
            
            Text(
              _error ?? 'حدث خطأ غير متوقع',
              style: context.bodyStyle.copyWith(
                color: context.secondaryTextColor,
              ),
              textAlign: TextAlign.center,
            ),
            
            Spaces.extraLarge,
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IslamicButton.outlined(
                  text: 'تحديث الموقع',
                  icon: Icons.location_on,
                  onPressed: _updateLocation,
                ).flex(1),
                
                Spaces.mediumH,
                
                IslamicButton.primary(
                  text: 'إعادة المحاولة',
                  icon: Icons.refresh,
                  onPressed: _initializePrayerTimes,
                ).flex(1),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return EmptyState(
      icon: Icons.mosque,
      title: 'لا توجد مواقيت محفوظة',
      subtitle: 'يرجى تحديد موقعك أولاً لحساب مواقيت الصلاة',
      action: IslamicButton.primary(
        text: 'تحديد الموقع',
        icon: Icons.location_on,
        onPressed: _updateLocation,
        isLoading: _isLocationLoading,
      ),
    );
  }

  Widget _buildPrayerTimesContent() {
    final prayers = _currentTimes!.prayers
        .where((p) => p.type != PrayerType.sunrise)
        .toList();

    return ListView(
      padding: EdgeInsets.all(context.mediumPadding),
      children: [
        // معلومات الموقع - إصلاح: استخدام الاستيراد المحدد
        location_widgets.LocationCard(
          location: _currentTimes!.location,
          onUpdateLocation: _updateLocation,
          isLoading: _isLocationLoading,
        ),
        
        Spaces.large,
        
        // الصلاة التالية - إصلاح: استخدام الاستيراد المحدد
        if (_currentTimes!.nextPrayer != null)
          prayer_widgets.NextPrayerCard(
            prayer: _currentTimes!.nextPrayer!,
          ),
        
        Spaces.large,
        
        // عنوان مواقيت اليوم
        Row(
          children: [
            Icon(
              Icons.today,
              color: context.primaryColor,
            ),
            Spaces.smallH,
            Text(
              'مواقيت اليوم',
              style: context.titleStyle,
            ),
            const Spacer(),
            Text(
              _formatDate(_currentTimes!.date),
              style: context.captionStyle,
            ),
          ],
        ),
        
        Spaces.medium,
        
        // قائمة الصلوات
        ...prayers.map((prayer) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: prayer_widgets.PrayerCard(prayer: prayer),
          );
        }),
        
        Spaces.large,
        
        // معلومات إضافية
        _buildAdditionalInfo(),
        
        // مساحة إضافية للتمرير
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildAdditionalInfo() {
    final sunrise = _currentTimes!.prayers
        .where((p) => p.type == PrayerType.sunrise)
        .firstOrNull;

    return IslamicCard(
      padding: EdgeInsets.all(context.mediumPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.wb_sunny,
                color: Colors.orange,
                size: 20,
              ),
              Spaces.smallH,
              Text(
                'معلومات إضافية',
                style: context.subtitleStyle.semiBold,
              ),
            ],
          ),
          
          Spaces.medium,
          
          if (sunrise != null) ...[
            _buildInfoRow(
              'وقت الشروق',
              _formatTime(sunrise.time),
              Icons.wb_sunny,
              Colors.orange,
            ),
            
            // إصلاح: إضافة const
            const Divider(height: 24),
          ],
          
          _buildInfoRow(
            'طريقة الحساب',
            _getCalculationMethodName(_currentTimes!.settings.method),
            Icons.calculate,
            context.primaryColor,
          ),
          
          if (_currentTimes!.settings.asrJuristic == AsrJuristic.hanafi) ...[
            // إصلاح: إضافة const
            const Divider(height: 24),
            _buildInfoRow(
              'المذهب',
              'الحنفي',
              Icons.school,
              context.secondaryColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        Spaces.mediumH,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: context.captionStyle,
              ),
              Text(
                value,
                style: context.bodyStyle.medium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }

  String _formatDate(DateTime date) {
    const months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    const weekdays = [
      'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'
    ];
    
    final weekday = weekdays[date.weekday - 1];
    final day = date.day;
    final month = months[date.month - 1];
    final year = date.year;
    
    return '$weekday، $day $month $year';
  }

  String _getCalculationMethodName(CalculationMethod method) {
    switch (method) {
      case CalculationMethod.muslimWorldLeague:
        return 'رابطة العالم الإسلامي';
      case CalculationMethod.egyptian:
        return 'الهيئة المصرية العامة للمساحة';
      case CalculationMethod.karachi:
        return 'جامعة العلوم الإسلامية، كراتشي';
      case CalculationMethod.ummAlQura:
        return 'أم القرى';
      case CalculationMethod.dubai:
        return 'دبي';
      case CalculationMethod.qatar:
        return 'قطر';
      case CalculationMethod.kuwait:
        return 'الكويت';
      case CalculationMethod.singapore:
        return 'سنغافورة';
      case CalculationMethod.northAmerica:
        return 'الجمعية الإسلامية لأمريكا الشمالية';
      case CalculationMethod.other:
        return 'مخصص';
    }
  }
}