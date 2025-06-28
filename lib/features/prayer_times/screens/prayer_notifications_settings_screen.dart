// lib/features/prayer_times/screens/prayer_notifications_settings_screen.dart - مُحدث بالنظام الموحد

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:athkar_app/app/themes/widgets/widgets.dart';

import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../services/prayer_times_service.dart';
import '../models/prayer_time_model.dart';

class PrayerNotificationsSettingsScreen extends StatefulWidget {
  const PrayerNotificationsSettingsScreen({super.key});

  @override
  State<PrayerNotificationsSettingsScreen> createState() => _PrayerNotificationsSettingsScreenState();
}

class _PrayerNotificationsSettingsScreenState extends State<PrayerNotificationsSettingsScreen> {
  late final LoggerService _logger;
  late final PrayerTimesService _prayerService;
  
  late PrayerNotificationSettings _notificationSettings;
  
  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadSettings();
  }

  void _initializeServices() {
    _logger = getIt<LoggerService>();
    _prayerService = getIt<PrayerTimesService>();
  }

  void _loadSettings() {
    setState(() {
      _notificationSettings = _prayerService.notificationSettings;
      _isLoading = false;
    });
  }

  void _markAsChanged() {
    setState(() {
      _hasChanges = true;
    });
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    
    try {
      await _prayerService.updateNotificationSettings(_notificationSettings);
      
      _logger.logEvent('prayer_notification_settings_updated', parameters: {
        'enabled': _notificationSettings.enabled,
        'enabled_prayers_count': _notificationSettings.enabledPrayers.values.where((v) => v).length,
      });
      
      if (!mounted) return;
      
      // استخدام النظام الموحد للإشعارات
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم حفظ إعدادات الإشعارات بنجاح'),
          backgroundColor: AppTheme.primary,
        ),
      );
      
      setState(() {
        _hasChanges = false;
      });
    } catch (e) {
      _logger.error(
        message: 'خطأ في حفظ إعدادات الإشعارات',
        error: e,
      );
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('فشل حفظ إعدادات الإشعارات'),
          backgroundColor: AppTheme.accent,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: SimpleAppBar(
        title: 'إعدادات إشعارات الصلوات',
        actions: [
          if (_hasChanges && !_isSaving)
            IconButton(
              icon: Icon(Icons.save, color: AppTheme.textSecondary),
              onPressed: _saveSettings,
              tooltip: 'حفظ التغييرات',
            ),
        ],
      ),
      body: _isLoading
          ? AppLoading.page(message: 'جاري تحميل الإعدادات...')
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: AppTheme.space4.padding,
      child: Column(
        children: [
          _buildMainSettingsSection(),
          
          AppTheme.space4.h,
          
          _buildPrayerNotificationsSection(),
          
          AppTheme.space6.h,
          
          _buildSaveButton(),
          
          AppTheme.space8.h,
        ],
      ),
    );
  }

  Widget _buildMainSettingsSection() {
    return AppCard(
      title: 'إعدادات الإشعارات العامة',
      subtitle: 'تفعيل أو تعطيل الإشعارات لجميع الصلوات',
      icon: Icons.notifications_active,
      child: Column(
        children: [
          AppTheme.space4.h,
          
          // تفعيل/تعطيل الإشعارات
          SwitchListTile(
            title: Text(
              'تفعيل الإشعارات',
              style: AppTheme.bodyMedium,
            ),
            subtitle: Text(
              'تلقي تنبيهات أوقات الصلاة',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
            ),
            value: _notificationSettings.enabled,
            onChanged: (value) {
              setState(() {
                _notificationSettings = _notificationSettings.copyWith(
                  enabled: value,
                );
                _markAsChanged();
              });
            },
            activeTrackColor: AppTheme.primary,
            activeThumbColor: Colors.white,
            contentPadding: EdgeInsets.zero,
          ),
          
          // الاهتزاز
          SwitchListTile(
            title: Text(
              'الاهتزاز',
              style: AppTheme.bodyMedium,
            ),
            subtitle: Text(
              'اهتزاز الجهاز عند التنبيه',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
            ),
            value: _notificationSettings.vibrate,
            onChanged: _notificationSettings.enabled
                ? (value) {
                    setState(() {
                      _notificationSettings = _notificationSettings.copyWith(
                        vibrate: value,
                      );
                      _markAsChanged();
                    });
                  }
                : null,
            activeTrackColor: AppTheme.primary,
            activeThumbColor: Colors.white,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerNotificationsSection() {
    const prayers = [
      (PrayerType.fajr, 'الفجر', Icons.dark_mode),
      (PrayerType.dhuhr, 'الظهر', Icons.light_mode),
      (PrayerType.asr, 'العصر', Icons.wb_cloudy),
      (PrayerType.maghrib, 'المغرب', Icons.wb_twilight),
      (PrayerType.isha, 'العشاء', Icons.bedtime),
    ];
    
    return AppCard(
      title: 'إعدادات إشعارات الصلوات',
      subtitle: 'تخصيص الإشعارات لكل صلاة على حدة',
      icon: Icons.mosque,
      child: Column(
        children: [
          AppTheme.space4.h,
          
          ...prayers.map((prayer) => _buildPrayerNotificationTile(
            prayer.$1,
            prayer.$2,
            prayer.$3,
          )),
        ],
      ),
    );
  }

  Widget _buildPrayerNotificationTile(
    PrayerType type,
    String name,
    IconData icon,
  ) {
    final isEnabled = _notificationSettings.enabledPrayers[type] ?? false;
    final minutesBefore = _notificationSettings.minutesBefore[type] ?? 0;
    
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.space2),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: AppTheme.radiusMd.radius,
        border: Border.all(
          color: isEnabled && _notificationSettings.enabled 
              ? AppTheme.primary.withOpacity(0.3)
              : AppTheme.textSecondary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            borderRadius: AppTheme.radiusMd.radius,
          ),
          child: Icon(
            icon,
            color: AppTheme.primary,
            size: 20,
          ),
        ),
        title: Text(
          name,
          style: AppTheme.bodyMedium,
        ),
        subtitle: Text(
          isEnabled && _notificationSettings.enabled
              ? 'تنبيه قبل $minutesBefore دقيقة'
              : 'التنبيه معطل',
          style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
        ),
        trailing: Switch(
          value: isEnabled,
          onChanged: _notificationSettings.enabled
              ? (value) {
                  HapticFeedback.lightImpact();
                  setState(() {
                    final updatedPrayers = Map<PrayerType, bool>.from(
                      _notificationSettings.enabledPrayers,
                    );
                    updatedPrayers[type] = value;
                    
                    _notificationSettings = _notificationSettings.copyWith(
                      enabledPrayers: updatedPrayers,
                    );
                    _markAsChanged();
                  });
                }
              : null,
          activeColor: AppTheme.primary,
        ),
        children: [
          if (isEnabled && _notificationSettings.enabled)
            _buildMinutesSelector(type, minutesBefore),
        ],
        tilePadding: AppTheme.space3.padding,
        childrenPadding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildMinutesSelector(PrayerType type, int minutesBefore) {
    return Container(
      padding: AppTheme.space3.padding,
      decoration: BoxDecoration(
        color: AppTheme.card,
        border: Border(
          top: BorderSide(
            color: AppTheme.textSecondary.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'التنبيه قبل',
            style: AppTheme.bodySmall,
          ),
          
          AppTheme.space3.w,
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: AppTheme.space2),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: AppTheme.radiusSm.radius,
              border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3)),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: minutesBefore,
                items: [0, 5, 10, 15, 20, 25, 30, 45, 60]
                    .map((minutes) => DropdownMenuItem(
                          value: minutes,
                          child: Text(
                            '$minutes',
                            style: AppTheme.bodySmall,
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    HapticFeedback.selectionClick();
                    setState(() {
                      final updatedMinutes = Map<PrayerType, int>.from(
                        _notificationSettings.minutesBefore,
                      );
                      updatedMinutes[type] = value;
                      
                      _notificationSettings = _notificationSettings.copyWith(
                        minutesBefore: updatedMinutes,
                      );
                      _markAsChanged();
                    });
                  }
                },
                style: AppTheme.bodyMedium,
                dropdownColor: AppTheme.surface,
              ),
            ),
          ),
          
          AppTheme.space2.w,
          
          Text(
            'دقيقة',
            style: AppTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return AppButton.primary(
      text: 'حفظ الإعدادات',
      icon: Icons.save,
      onPressed: _isSaving || !_hasChanges ? null : _saveSettings,
      isLoading: _isSaving,
      isFullWidth: true,
    );
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.card,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusLg.radius,
        ),
        title: Text(
          'تغييرات غير محفوظة',
          style: AppTheme.titleLarge,
        ),
        content: Text(
          'لديك تغييرات لم يتم حفظها. هل تريد حفظ التغييرات قبل المغادرة؟',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          AppButton.outline(
            text: 'تجاهل التغييرات',
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          
          AppTheme.space2.w,
          
          AppButton.primary(
            text: 'حفظ وخروج',
            onPressed: () {
              Navigator.pop(context);
              _saveSettings().then((_) {
                Navigator.pop(context);
              });
            },
          ),
        ],
      ),
    );
  }
}