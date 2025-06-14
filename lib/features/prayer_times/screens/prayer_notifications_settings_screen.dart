// lib/features/prayer_times/screens/prayer_notifications_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
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
      
      context.showSuccessSnackBar('تم حفظ إعدادات الإشعارات بنجاح');
      setState(() {
        _hasChanges = false;
      });
    } catch (e) {
      _logger.error(
        message: 'خطأ في حفظ إعدادات الإشعارات',
        error: e,
      );
      
      if (!mounted) return;
      
      context.showErrorSnackBar('فشل حفظ إعدادات الإشعارات');
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
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        elevation: 0,
        title: Text(
          'إعدادات إشعارات الصلوات',
          style: context.titleLarge?.semiBold,
        ),
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
          ? Center(child: AppLoading.circular())
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
          child: SizedBox(height: ThemeConstants.space8 * 2),
        ),
      ],
    );
  }

  Widget _buildMainSettingsSection() {
    return Container(
      margin: ThemeConstants.space4.all,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        color: context.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: ThemeConstants.opacity5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Padding(
            padding: ThemeConstants.space4.all,
            child: Row(
              children: [
                Container(
                  padding: ThemeConstants.space2.all,
                  decoration: BoxDecoration(
                    color: ThemeConstants.success.withValues(alpha: ThemeConstants.opacity10),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  ),
                  child: Icon(
                    Icons.notifications_active,
                    color: ThemeConstants.success,
                    size: ThemeConstants.iconMd,
                  ),
                ),
                ThemeConstants.space3.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إعدادات الإشعارات العامة',
                        style: context.titleMedium?.semiBold,
                      ),
                      Text(
                        'تفعيل أو تعطيل الإشعارات لجميع الصلوات',
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(),
          
          // تفعيل/تعطيل الإشعارات
          SwitchListTile(
            title: const Text('تفعيل الإشعارات'),
            subtitle: const Text('تلقي تنبيهات أوقات الصلاة'),
            value: _notificationSettings.enabled,
            onChanged: (value) {
              setState(() {
                _notificationSettings = _notificationSettings.copyWith(
                  enabled: value,
                );
                _markAsChanged();
              });
            },
            activeColor: ThemeConstants.success,
          ),
          
          // الاهتزاز
          SwitchListTile(
            title: const Text('الاهتزاز'),
            subtitle: const Text('اهتزاز الجهاز عند التنبيه'),
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
            activeColor: ThemeConstants.success,
          ),
          
          // تشغيل الأذان
          SwitchListTile(
            title: const Text('تشغيل الأذان'),
            subtitle: const Text('تشغيل صوت الأذان عند حلول وقت الصلاة'),
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
            activeColor: ThemeConstants.success,
          ),
          
          // اختيار نوع صوت الأذان
          if (_notificationSettings.enabled && _notificationSettings.playAdhan)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ThemeConstants.space4,
                vertical: ThemeConstants.space2,
              ),
              child: Row(
                children: [
                  const Text('صوت الأذان:'),
                  ThemeConstants.space3.w,
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _notificationSettings.adhanSound,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: ThemeConstants.space3,
                          vertical: ThemeConstants.space2,
                        ),
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
          
          ThemeConstants.space2.h,
        ],
      ),
    );
  }

  Widget _buildPrayerNotificationsSection() {
    final prayers = [
      (PrayerType.fajr, 'الفجر', ThemeConstants.getPrayerIcon('fajr')),
      (PrayerType.dhuhr, 'الظهر', ThemeConstants.getPrayerIcon('dhuhr')),
      (PrayerType.asr, 'العصر', ThemeConstants.getPrayerIcon('asr')),
      (PrayerType.maghrib, 'المغرب', ThemeConstants.getPrayerIcon('maghrib')),
      (PrayerType.isha, 'العشاء', ThemeConstants.getPrayerIcon('isha')),
    ];
    
    return Container(
      margin: ThemeConstants.space4.all,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        color: context.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: ThemeConstants.opacity5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Padding(
            padding: ThemeConstants.space4.all,
            child: Row(
              children: [
                Container(
                  padding: ThemeConstants.space2.all,
                  decoration: BoxDecoration(
                    color: ThemeConstants.success.withValues(alpha: ThemeConstants.opacity10),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  ),
                  child: Icon(
                    ThemeConstants.iconPrayer,
                    color: ThemeConstants.success,
                    size: ThemeConstants.iconMd,
                  ),
                ),
                ThemeConstants.space3.w,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إعدادات إشعارات الصلوات',
                        style: context.titleMedium?.semiBold,
                      ),
                      Text(
                        'تخصيص الإشعارات لكل صلاة على حدة',
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
        width: ThemeConstants.iconXl,
        height: ThemeConstants.iconXl,
        decoration: BoxDecoration(
          color: ThemeConstants.success.withValues(alpha: ThemeConstants.opacity10),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        child: Icon(
          icon,
          color: ThemeConstants.success,
          size: ThemeConstants.iconMd,
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
        activeColor: ThemeConstants.success,
      ),
      children: [
        if (isEnabled && _notificationSettings.enabled)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ThemeConstants.space4,
              vertical: ThemeConstants.space2,
            ),
            child: Row(
              children: [
                const Text('التنبيه قبل'),
                ThemeConstants.space3.w,
                SizedBox(
                  width: 80,
                  child: DropdownButtonFormField<int>(
                    value: minutesBefore,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ThemeConstants.space3,
                        vertical: ThemeConstants.space2,
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
                ThemeConstants.space2.w,
                const Text('دقيقة'),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAdvancedSettingsSection() {
    return Container(
      margin: ThemeConstants.space4.all,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        color: context.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: ThemeConstants.opacity5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
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
              padding: ThemeConstants.space2.all,
              decoration: BoxDecoration(
                color: ThemeConstants.success.withValues(alpha: ThemeConstants.opacity10),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
              child: Icon(
                ThemeConstants.iconSettings,
                color: ThemeConstants.success,
                size: ThemeConstants.iconMd,
              ),
            ),
            title: Text(
              'إعدادات متقدمة',
              style: context.titleMedium?.semiBold,
            ),
            subtitle: Text(
              'إعدادات إضافية للإشعارات',
              style: context.bodySmall?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
            children: [
              const Divider(),
              
              // تنبيه لصلاة الجماعة
              SwitchListTile(
                title: const Text('تنبيه لصلاة الجماعة'),
                subtitle: const Text('تذكير إضافي بوقت الإقامة'),
                value: false,
                onChanged: _notificationSettings.enabled ? (_) {
                  context.showInfoSnackBar('هذه الميزة قيد التطوير');
                } : null,
                activeColor: ThemeConstants.success,
              ),
              
              // تنبيه للصلوات الفائتة
              SwitchListTile(
                title: const Text('تنبيه للصلوات الفائتة'),
                subtitle: const Text('تذكير بالصلوات التي لم تتم في وقتها'),
                value: false,
                onChanged: _notificationSettings.enabled ? (_) {
                  context.showInfoSnackBar('هذه الميزة قيد التطوير');
                } : null,
                activeColor: ThemeConstants.success,
              ),
              
              // عدم إزعاج أثناء النوم
              SwitchListTile(
                title: const Text('عدم إزعاج أثناء النوم'),
                subtitle: const Text('كتم صوت الإشعارات أثناء ساعات النوم'),
                value: false,
                onChanged: _notificationSettings.enabled ? (_) {
                  context.showInfoSnackBar('هذه الميزة قيد التطوير');
                } : null,
                activeColor: ThemeConstants.success,
              ),
              
              ThemeConstants.space2.h,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: ThemeConstants.space4.all,
      child: SizedBox(
        width: double.infinity,
        height: ThemeConstants.buttonHeight,
        child: ElevatedButton(
          onPressed: _isSaving || !_hasChanges ? null : _saveSettings,
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeConstants.success,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            elevation: ThemeConstants.elevation2,
          ),
          child: _isSaving
              ? SizedBox(
                  width: ThemeConstants.iconMd,
                  height: ThemeConstants.iconMd,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save, size: ThemeConstants.iconMd),
                    ThemeConstants.space2.w,
                    Text(
                      'حفظ الإعدادات',
                      style: TextStyle(
                        fontSize: ThemeConstants.textSizeLg,
                        fontWeight: ThemeConstants.bold,
                      ),
                    ),
                  ],
                ),
        ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeConstants.success,
            ),
            child: const Text('حفظ وخروج'),
          ),
        ],
      ),
    );
  }
}