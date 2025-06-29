// lib/features/prayer_times/screens/prayer_notifications_settings_screen.dart (محدث بالنظام الموحد)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/widgets.dart';
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
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ إعدادات الإشعارات بنجاح'),
          backgroundColor: AppTheme.success,
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
        const SnackBar(
          content: Text('فشل حفظ إعدادات الإشعارات'),
          backgroundColor: AppTheme.error,
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
              icon: const Icon(Icons.save, color: AppTheme.primary),
              onPressed: _saveSettings,
              tooltip: 'حفظ التغييرات',
            ),
        ],
        leading: BackButton(
          onPressed: () {
            if (_hasChanges) {
              _showUnsavedChangesDialog();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: _isLoading
          ? AppLoading.page(message: 'جاري تحميل الإعدادات...')
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    return CustomScrollView(
      slivers: [
        // القسم الرئيسي للإعدادات
        SliverToBoxAdapter(
          child: _buildMainSettingsSection(),
        ),
        
        // قسم الإشعارات لكل صلاة
        SliverToBoxAdapter(
          child: _buildPrayerNotificationsSection(),
        ),
        
        // زر الحفظ
        SliverToBoxAdapter(
          child: _buildSaveButton(),
        ),
        
        // مساحة في الأسفل
        SliverToBoxAdapter(child: AppTheme.space8.h),
      ],
    );
  }

  Widget _buildMainSettingsSection() {
    return AppCard(
      title: 'إعدادات الإشعارات العامة',
      subtitle: 'تفعيل أو تعطيل الإشعارات لجميع الصلوات',
      icon: Icons.notifications_active,
      child: Column(
        children: [
          // تفعيل/تعطيل الإشعارات
          SwitchListTile(
            title: const Text(
              'تفعيل الإشعارات',
              style: AppTheme.bodyLarge,
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
            activeColor: AppTheme.primary,
          ),
          
          // الاهتزاز
          SwitchListTile(
            title: const Text('الاهتزاز', style: AppTheme.bodyLarge),
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
            activeColor: AppTheme.primary,
          ),
          
          // تشغيل الأذان
          SwitchListTile(
            title: const Text('تشغيل الأذان', style: AppTheme.bodyLarge),
            subtitle: Text(
              'تشغيل صوت الأذان عند التنبيه',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
            ),
            value: _notificationSettings.playAdhan,
            onChanged: _notificationSettings.enabled
                ? (value) {
                    setState(() {
                      _notificationSettings = _notificationSettings.copyWith(
                        playAdhan: value,
                      );
                      _markAsChanged();
                    });
                  }
                : null,
            activeColor: AppTheme.primary,
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
        children: prayers.map((prayer) => _buildPrayerNotificationTile(
          prayer.$1,
          prayer.$2,
          prayer.$3,
        )).toList(),
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
    final prayerColor = AppTheme.getPrayerColor(name);
    
    return ExpansionTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: prayerColor.withValues(alpha: 0.1),
          borderRadius: AppTheme.radiusMd.radius,
        ),
        child: Icon(
          icon,
          color: prayerColor,
          size: AppTheme.iconMd,
        ),
      ),
      title: Text(name, style: AppTheme.bodyLarge),
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
        activeColor: prayerColor,
      ),
      children: [
        if (isEnabled && _notificationSettings.enabled)
          _buildMinutesSelector(type, minutesBefore),
      ],
    );
  }

  Widget _buildMinutesSelector(PrayerType type, int minutesBefore) {
    return Padding(
      padding: AppTheme.space4.paddingH,
      child: Row(
        children: [
          const Text('التنبيه قبل', style: AppTheme.bodyMedium),
          AppTheme.space3.w,
          Container(
            width: 80,
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.border),
              borderRadius: AppTheme.radiusMd.radius,
            ),
            child: DropdownButtonFormField<int>(
              value: minutesBefore,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: AppTheme.space3,
                  vertical: AppTheme.space2,
                ),
                border: InputBorder.none,
              ),
              dropdownColor: AppTheme.surface,
              items: [0, 5, 10, 15, 20, 25, 30, 45, 60]
                  .map((minutes) => DropdownMenuItem(
                        value: minutes,
                        child: Text(
                          '$minutes',
                          style: AppTheme.bodyMedium,
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
            ),
          ),
          AppTheme.space2.w,
          const Text('دقيقة', style: AppTheme.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: AppTheme.space4.padding,
      child: AppButton.primary(
        text: 'حفظ الإعدادات',
        icon: Icons.save,
        isLoading: _isSaving,
        isFullWidth: true,
        onPressed: _isSaving || !_hasChanges ? null : _saveSettings,
      ),
    );
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text(
          'تغييرات غير محفوظة',
          style: AppTheme.titleLarge,
        ),
        content: const Text(
          'لديك تغييرات لم يتم حفظها. هل تريد حفظ التغييرات قبل المغادرة؟',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          AppButton.text(
            text: 'تجاهل التغييرات',
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
          AppButton.primary(
            text: 'حفظ وخروج',
            onPressed: () {
              Navigator.pop(context);
              _saveSettings().then((_) {
                if (mounted) Navigator.pop(context);
              });
            },
          ),
        ],
      ),
    );
  }
}