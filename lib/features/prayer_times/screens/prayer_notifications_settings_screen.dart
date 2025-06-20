// lib/features/prayer_times/screens/prayer_notifications_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/index.dart';
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
  bool _showAdvancedSettings = false;

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
      
      context.showSuccessMessage('تم حفظ إعدادات الإشعارات بنجاح');
      setState(() {
        _hasChanges = false;
      });
    } catch (e) {
      _logger.error(
        message: 'خطأ في حفظ إعدادات الإشعارات',
        error: e,
      );
      
      if (!mounted) return;
      
      context.showErrorMessage('فشل حفظ إعدادات الإشعارات');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: IslamicAppBar(
        title: 'إعدادات إشعارات الصلوات',
        actions: [
          if (_hasChanges && !_isSaving)
            IconButton(
              icon: const Icon(Icons.save),
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
          ? Center(child: IslamicLoading(message: 'جاري التحميل...'))
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
        
        // قسم الإعدادات المتقدمة
        SliverToBoxAdapter(
          child: _buildAdvancedSettingsSection(),
        ),
        
        // زر الحفظ
        SliverToBoxAdapter(
          child: _buildSaveButton(),
        ),
        
        // مساحة في الأسفل
        SliverToBoxAdapter(
          child: Spaces.extraLarge,
        ),
      ],
    );
  }

  Widget _buildMainSettingsSection() {
    return IslamicCard.simple(
      margin: const EdgeInsets.all(ThemeConstants.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spaceMd),
                decoration: BoxDecoration(
                  color: ThemeConstants.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  Icons.notifications_active,
                  color: ThemeConstants.primary,
                  size: ThemeConstants.iconMd,
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إعدادات الإشعارات العامة',
                      style: context.titleStyle.copyWith(
                        fontWeight: ThemeConstants.fontSemiBold,
                      ),
                    ),
                    Text(
                      'تفعيل أو تعطيل الإشعارات لجميع الصلوات',
                      style: context.captionStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          Spaces.large,
          
          // تفعيل/تعطيل الإشعارات
          IslamicSwitch(
            title: 'تفعيل الإشعارات',
            subtitle: 'تلقي تنبيهات أوقات الصلاة',
            value: _notificationSettings.enabled,
            onChanged: (value) {
              setState(() {
                _notificationSettings = _notificationSettings.copyWith(
                  enabled: value,
                );
                _markAsChanged();
              });
            },
            activeColor: ThemeConstants.primary,
          ),
          
          // الاهتزاز
          IslamicSwitch(
            title: 'الاهتزاز',
            subtitle: 'اهتزاز الجهاز عند التنبيه',
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
            activeColor: ThemeConstants.primary,
          ),
          
          // تشغيل الأذان
          IslamicSwitch(
            title: 'تشغيل الأذان',
            subtitle: 'تشغيل صوت الأذان عند حلول وقت الصلاة',
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
            activeColor: ThemeConstants.primary,
          ),
          
          // اختيار نوع صوت الأذان (يظهر فقط عند تفعيل الأذان)
          if (_notificationSettings.enabled && _notificationSettings.playAdhan)
            Padding(
              padding: const EdgeInsets.only(top: ThemeConstants.spaceMd),
              child: Row(
                children: [
                  const Text('صوت الأذان:'),
                  Spaces.mediumH,
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _notificationSettings.adhanSound,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'default',
                          child: Text('الأذان الافتراضي'),
                        ),
                        DropdownMenuItem(
                          value: 'makkah',
                          child: Text('أذان الحرم المكي'),
                        ),
                        DropdownMenuItem(
                          value: 'madinah',
                          child: Text('أذان المسجد النبوي'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _notificationSettings = _notificationSettings.copyWith(
                              adhanSound: value,
                            );
                            _markAsChanged();
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPrayerNotificationsSection() {
    final prayers = [
      (PrayerType.fajr, 'الفجر', Icons.dark_mode),
      (PrayerType.dhuhr, 'الظهر', Icons.light_mode),
      (PrayerType.asr, 'العصر', Icons.wb_cloudy),
      (PrayerType.maghrib, 'المغرب', Icons.wb_twilight),
      (PrayerType.isha, 'العشاء', Icons.bedtime),
    ];
    
    return IslamicCard.simple(
      margin: const EdgeInsets.all(ThemeConstants.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spaceMd),
                decoration: BoxDecoration(
                  color: ThemeConstants.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  Icons.mosque,
                  color: ThemeConstants.primary,
                  size: ThemeConstants.iconMd,
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إعدادات إشعارات الصلوات',
                      style: context.titleStyle.copyWith(
                        fontWeight: ThemeConstants.fontSemiBold,
                      ),
                    ),
                    Text(
                      'تخصيص الإشعارات لكل صلاة على حدة',
                      style: context.captionStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const Divider(),
          
          // قائمة الصلوات
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
    
    return ExpansionTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: ThemeConstants.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        child: Icon(
          icon,
          color: ThemeConstants.primary,
          size: 20,
        ),
      ),
      title: Text(name),
      subtitle: Text(
        isEnabled && _notificationSettings.enabled
            ? 'تنبيه قبل $minutesBefore دقيقة'
            : 'التنبيه معطل',
      ),
      trailing: Switch(
        value: isEnabled,
        onChanged: _notificationSettings.enabled
            ? (value) {
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
        activeColor: ThemeConstants.primary,
      ),
      children: [
        if (isEnabled && _notificationSettings.enabled)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.spaceLg,
              vertical: ThemeConstants.spaceMd,
            ),
            child: Row(
              children: [
                const Text('التنبيه قبل'),
                Spaces.mediumH,
                SizedBox(
                  width: 80,
                  child: DropdownButtonFormField<int>(
                    value: minutesBefore,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    items: [0, 5, 10, 15, 20, 25, 30, 45, 60]
                        .map((minutes) => DropdownMenuItem(
                              value: minutes,
                              child: Text('$minutes'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
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
                Spaces.small,
                const Text('دقيقة'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAdvancedSettingsSection() {
    return IslamicCard.simple(
      margin: const EdgeInsets.all(ThemeConstants.spaceLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          ExpansionTile(
            onExpansionChanged: (expanded) {
              setState(() {
                _showAdvancedSettings = expanded;
              });
            },
            leading: Container(
              padding: const EdgeInsets.all(ThemeConstants.spaceMd),
              decoration: BoxDecoration(
                color: ThemeConstants.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
              child: Icon(
                Icons.settings,
                color: ThemeConstants.primary,
                size: ThemeConstants.iconMd,
              ),
            ),
            title: Text(
              'إعدادات متقدمة',
              style: context.titleStyle.copyWith(
                fontWeight: ThemeConstants.fontSemiBold,
              ),
            ),
            subtitle: Text(
              'إعدادات إضافية للإشعارات',
              style: context.captionStyle,
            ),
            children: [
              const Divider(),
              
              // تنبيه لصلاة الجماعة
              IslamicSwitch(
                title: 'تنبيه لصلاة الجماعة',
                subtitle: 'تذكير إضافي بوقت الإقامة',
                value: false, // يمكن إضافة هذه الميزة لاحقًا
                onChanged: _notificationSettings.enabled ? (_) {
                  context.showInfoMessage('هذه الميزة قيد التطوير');
                } : null,
                activeColor: ThemeConstants.primary,
              ),
              
              // تنبيه للصلوات الفائتة
              IslamicSwitch(
                title: 'تنبيه للصلوات الفائتة',
                subtitle: 'تذكير بالصلوات التي لم تتم في وقتها',
                value: false, // يمكن إضافة هذه الميزة لاحقًا
                onChanged: _notificationSettings.enabled ? (_) {
                  context.showInfoMessage('هذه الميزة قيد التطوير');
                } : null,
                activeColor: ThemeConstants.primary,
              ),
              
              // عدم إزعاج أثناء النوم
              IslamicSwitch(
                title: 'عدم إزعاج أثناء النوم',
                subtitle: 'كتم صوت الإشعارات أثناء ساعات النوم',
                value: false, // يمكن إضافة هذه الميزة لاحقًا
                onChanged: _notificationSettings.enabled ? (_) {
                  context.showInfoMessage('هذه الميزة قيد التطوير');
                } : null,
                activeColor: ThemeConstants.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.spaceLg),
      child: IslamicButton.primary(
        text: 'حفظ الإعدادات',
        onPressed: _isSaving || !_hasChanges ? null : _saveSettings,
        isLoading: _isSaving,
        width: double.infinity,
        icon: Icons.save,
      ),
    );
  }

  void _showUnsavedChangesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تغييرات غير محفوظة'),
        content: const Text('لديك تغييرات لم يتم حفظها. هل تريد حفظ التغييرات قبل المغادرة؟'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('تجاهل التغييرات'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _saveSettings().then((_) {
                Navigator.pop(context);
              });
            },
            child: const Text('حفظ وخروج'),
          ),
        ],
      ),
    );
  }
}