// lib/features/prayer_times/screens/prayer_notifications_settings_screen.dart

import 'package:flutter/material.dart';
import '../../../app/themes/index.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../models/prayer_time_model.dart';
import '../services/prayer_times_service.dart';

class PrayerNotificationsSettingsScreen extends StatefulWidget {
  const PrayerNotificationsSettingsScreen({super.key});

  @override
  State<PrayerNotificationsSettingsScreen> createState() => _PrayerNotificationsSettingsScreenState();
}

class _PrayerNotificationsSettingsScreenState extends State<PrayerNotificationsSettingsScreen> {
  late final PrayerTimesService _prayerService;
  late final PermissionService _permissionService;
  late PrayerNotificationSettings _settings;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasNotificationPermission = false;

  @override
  void initState() {
    super.initState();
    _prayerService = getService<PrayerTimesService>();
    _permissionService = getService<PermissionService>();
    _loadCurrentSettings();
    _checkNotificationPermission();
  }

  Future<void> _loadCurrentSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _settings = _prayerService.notificationSettings;
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // إصلاح: التحقق من mounted قبل استخدام context
      if (mounted) {
        context.showErrorMessage('فشل تحميل الإعدادات');
      }
    }
  }

  Future<void> _checkNotificationPermission() async {
    final hasPermission = await _permissionService.checkNotificationPermission();
    if (mounted) {
      setState(() {
        _hasNotificationPermission = hasPermission;
      });
    }
  }

  Future<void> _requestNotificationPermission() async {
    final granted = await _permissionService.requestNotificationPermission();
    if (mounted) {
      setState(() {
        _hasNotificationPermission = granted;
      });
      
      if (granted) {
        context.showSuccessMessage('تم منح إذن الإشعارات');
      } else {
        context.showErrorMessage('لم يتم منح إذن الإشعارات');
      }
    }
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isSaving = true;
    });

    try {
      await _prayerService.updateNotificationSettings(_settings);
      
      if (mounted) {
        context.showSuccessMessage('تم حفظ الإعدادات بنجاح');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        context.showErrorMessage('فشل حفظ الإعدادات');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(
        title: 'تنبيهات الصلاة',
        actions: [
          if (!_isLoading)
            IconButton(
              onPressed: _isSaving ? null : _saveSettings,
              icon: _isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.primaryColor,
                      ),
                    )
                  : const Icon(Icons.save),
              tooltip: 'حفظ الإعدادات',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: IslamicLoading(message: 'جارٍ تحميل الإعدادات...'))
          : _buildSettingsContent(),
    );
  }

  Widget _buildSettingsContent() {
    return ListView(
      padding: EdgeInsets.all(context.mediumPadding),
      children: [
        // حالة الأذونات
        if (!_hasNotificationPermission)
          _buildPermissionCard(),
        
        if (!_hasNotificationPermission)
          Spaces.large,
        
        // التحكم العام
        _buildGeneralSettingsSection(),
        
        Spaces.large,
        
        // إعدادات كل صلاة
        if (_settings.enabled)
          _buildPrayerSpecificSettings(),
        
        if (_settings.enabled)
          Spaces.large,
        
        // إعدادات الصوت والاهتزاز
        if (_settings.enabled)
          _buildSoundAndVibrationSettings(),
        
        // مساحة إضافية
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildPermissionCard() {
    return IslamicCard(
      color: context.warningColor.withValues(alpha: 0.1),
      border: Border.all(color: context.warningColor.withValues(alpha: 0.3)),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: context.warningColor,
                size: 32,
              ),
              Spaces.mediumH,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'مطلوب إذن الإشعارات',
                      style: context.titleStyle.copyWith(
                        color: context.warningColor,
                      ),
                    ),
                    Spaces.xs,
                    Text(
                      'لتلقي تنبيهات مواقيت الصلاة، يجب منح إذن الإشعارات',
                      style: context.bodyStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          Row(
            children: [
              Expanded(
                child: IslamicButton.primary(
                  text: 'منح الإذن',
                  icon: Icons.notifications_active,
                  onPressed: _requestNotificationPermission,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettingsSection() {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'الإعدادات العامة',
                style: context.titleStyle,
              ),
            ],
          ),
          
          Spaces.medium,
          
          IslamicSwitch(
            title: 'تفعيل تنبيهات الصلاة',
            subtitle: 'تلقي إشعارات لأوقات الصلاة',
            value: _settings.enabled,
            onChanged: _hasNotificationPermission ? (value) {
              setState(() {
                _settings = _settings.copyWith(enabled: value);
              });
            } : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerSpecificSettings() {
    final prayers = [
      {'type': PrayerType.fajr, 'name': 'الفجر', 'icon': Icons.wb_twilight},
      {'type': PrayerType.dhuhr, 'name': 'الظهر', 'icon': Icons.wb_sunny},
      {'type': PrayerType.asr, 'name': 'العصر', 'icon': Icons.wb_cloudy},
      {'type': PrayerType.maghrib, 'name': 'المغرب', 'icon': Icons.brightness_3},
      {'type': PrayerType.isha, 'name': 'العشاء', 'icon': Icons.nights_stay},
    ];

    return Column(
      children: prayers.map((prayer) {
        final prayerType = prayer['type'] as PrayerType;
        final isEnabled = _settings.enabledPrayers[prayerType] ?? false;
        final minutesBefore = _settings.minutesBefore[prayerType] ?? 0;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: IslamicCard(
            child: Column(
              children: [
                // تفعيل/إلغاء الصلاة
                IslamicSwitch(
                  title: prayer['name'] as String,
                  subtitle: isEnabled 
                      ? 'تنبيه قبل ${minutesBefore > 0 ? '$minutesBefore دقيقة و' : ''}عند الوقت'
                      : 'التنبيهات معطلة',
                  value: isEnabled,
                  onChanged: (value) {
                    setState(() {
                      final newEnabledPrayers = Map<PrayerType, bool>.from(_settings.enabledPrayers);
                      newEnabledPrayers[prayerType] = value;
                      _settings = _settings.copyWith(enabledPrayers: newEnabledPrayers);
                    });
                  },
                  showAsListTile: false,
                ),
                
                // إعدادات التوقيت (إذا كانت مفعلة)
                if (isEnabled) ...[
                  const Divider(),
                  
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        Icon(
                          prayer['icon'] as IconData,
                          color: ThemeConstants.getPrayerColor(prayer['name'] as String),
                          size: 20,
                        ),
                        Spaces.smallH,
                        Text(
                          'تنبيه مسبق:',
                          style: context.bodyStyle.medium,
                        ),
                        const Spacer(),
                        
                        // اختيار الدقائق
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: context.borderColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: minutesBefore,
                              items: [0, 5, 10, 15, 20, 30].map((minutes) {
                                return DropdownMenuItem(
                                  value: minutes,
                                  child: Text(
                                    minutes == 0 ? 'بدون تنبيه مسبق' : '$minutes دقيقة',
                                    style: context.bodyStyle,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    final newMinutesBefore = Map<PrayerType, int>.from(_settings.minutesBefore);
                                    newMinutesBefore[prayerType] = value;
                                    _settings = _settings.copyWith(minutesBefore: newMinutesBefore);
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSoundAndVibrationSettings() {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.volume_up,
                color: context.secondaryColor,
              ),
              Spaces.smallH,
              Text(
                'الصوت والاهتزاز',
                style: context.titleStyle,
              ),
            ],
          ),
          
          Spaces.medium,
          
          // تشغيل الأذان (معطل دائماً حسب المتطلبات)
          const IslamicSwitch(
            title: 'تشغيل الأذان',
            subtitle: 'تشغيل صوت الأذان مع التنبيه (معطل حالياً)',
            value: false,
            onChanged: null, // معطل دائماً
          ),
          
          // إصلاح: إضافة const
          const Divider(),
          
          // الاهتزاز
          IslamicSwitch(
            title: 'الاهتزاز',
            subtitle: 'اهتزاز الجهاز مع التنبيه',
            value: _settings.vibrate,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(vibrate: value);
              });
            },
          ),
          
          if (!_settings.vibrate) ...[
            Spaces.small,
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: context.infoColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: context.infoColor,
                    size: 16,
                  ),
                  Spaces.smallH,
                  Expanded(
                    child: Text(
                      'عند إلغاء الاهتزاز، ستظهر التنبيهات صامتة تماماً',
                      style: context.captionStyle.copyWith(
                        color: context.infoColor,
                      ),
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
}