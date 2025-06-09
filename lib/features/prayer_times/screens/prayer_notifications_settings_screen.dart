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
        const SliverToBoxAdapter(
          child: SizedBox(height: 80),
        ),
      ],
    );
  }

  Widget _buildMainSettingsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.notifications_active,
                    color: context.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
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
            activeColor: context.primaryColor,
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
            activeColor: context.primaryColor,
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
            activeColor: context.primaryColor,
          ),
          
          // اختيار نوع صوت الأذان (يظهر فقط عند تفعيل الأذان)
          if (_notificationSettings.enabled && _notificationSettings.playAdhan)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text('صوت الأذان:'),
                  const SizedBox(width: 12),
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
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.play_circle_outline),
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      context.showInfoSnackBar('تشغيل صوت الأذان للاختبار');
                      // هنا يمكن إضافة كود تشغيل صوت الأذان للاختبار
                    },
                    tooltip: 'اختبار الصوت',
                  ),
                ],
              ),
            ),
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildPrayerNotificationsSection() {
    final prayers = [
      (PrayerType.fajr, 'الفجر', Icons.dark_mode, _getPrayerColor(PrayerType.fajr)),
      (PrayerType.dhuhr, 'الظهر', Icons.light_mode, _getPrayerColor(PrayerType.dhuhr)),
      (PrayerType.asr, 'العصر', Icons.wb_cloudy, _getPrayerColor(PrayerType.asr)),
      (PrayerType.maghrib, 'المغرب', Icons.wb_twilight, _getPrayerColor(PrayerType.maghrib)),
      (PrayerType.isha, 'العشاء', Icons.bedtime, _getPrayerColor(PrayerType.isha)),
    ];
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.mosque,
                    color: context.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
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
            prayer.$4,
          )),
        ],
      ),
    );
  }

  Widget _buildPrayerNotificationTile(
    PrayerType type,
    String name,
    IconData icon,
    Color color,
  ) {
    final isEnabled = _notificationSettings.enabledPrayers[type] ?? false;
    final minutesBefore = _notificationSettings.minutesBefore[type] ?? 0;
    
    return ExpansionTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: color,
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
        activeColor: color,
      ),
      children: [
        if (isEnabled && _notificationSettings.enabled)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [
                const Text('التنبيه قبل'),
                const SizedBox(width: 12),
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
                const SizedBox(width: 8),
                const Text('دقيقة'),
                
                const Spacer(),
                
                // زر اختبار الإشعار
                TextButton.icon(
                  icon: const Icon(Icons.notifications_active, size: 16),
                  label: const Text('اختبار'),
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    context.showInfoSnackBar('تم إرسال إشعار تجريبي لصلاة $name');
                    // هنا يمكن إضافة كود لإرسال إشعار تجريبي
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: color,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAdvancedSettingsSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.settings,
                color: context.primaryColor,
                size: 24,
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
                value: false, // يمكن إضافة هذه الميزة لاحقًا
                onChanged: _notificationSettings.enabled ? (_) {
                  context.showInfoSnackBar('هذه الميزة قيد التطوير');
                } : null,
                activeColor: context.primaryColor,
              ),
              
              // تنبيه للصلوات الفائتة
              SwitchListTile(
                title: const Text('تنبيه للصلوات الفائتة'),
                subtitle: const Text('تذكير بالصلوات التي لم تتم في وقتها'),
                value: false, // يمكن إضافة هذه الميزة لاحقًا
                onChanged: _notificationSettings.enabled ? (_) {
                  context.showInfoSnackBar('هذه الميزة قيد التطوير');
                } : null,
                activeColor: context.primaryColor,
              ),
              
              // عدم إزعاج أثناء النوم
              SwitchListTile(
                title: const Text('عدم إزعاج أثناء النوم'),
                subtitle: const Text('كتم صوت الإشعارات أثناء ساعات النوم'),
                value: false, // يمكن إضافة هذه الميزة لاحقًا
                onChanged: _notificationSettings.enabled ? (_) {
                  context.showInfoSnackBar('هذه الميزة قيد التطوير');
                } : null,
                activeColor: context.primaryColor,
              ),
              
              const SizedBox(height: 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _isSaving || !_hasChanges ? null : _saveSettings,
          style: ElevatedButton.styleFrom(
            backgroundColor: context.primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
          child: _isSaving
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'حفظ الإعدادات',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
            child: const Text('حفظ وخروج'),
          ),
        ],
      ),
    );
  }

  Color _getPrayerColor(PrayerType type) {
    switch (type) {
      case PrayerType.fajr:
        return const Color(0xFF1A237E); // Deep blue
      case PrayerType.sunrise:
        return const Color(0xFFFFB300); // Amber
      case PrayerType.dhuhr:
        return const Color(0xFFFF6F00); // Orange
      case PrayerType.asr:
        return const Color(0xFF00897B); // Teal
      case PrayerType.maghrib:
        return const Color(0xFFE65100); // Deep orange
      case PrayerType.isha:
        return const Color(0xFF4A148C); // Purple
      default:
        return const Color(0xFF607D8B); // Blue grey
    }
  }
}