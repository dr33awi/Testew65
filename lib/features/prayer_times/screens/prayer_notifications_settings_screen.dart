// lib/features/prayer_times/screens/prayer_notifications_settings_screen.dart - مُصحح

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
    if (!mounted) return; // ✅ فحص mounted أولاً
    
    setState(() => _isSaving = true);
    
    try {
      await _prayerService.updateNotificationSettings(_notificationSettings);
      
      _logger.logEvent('prayer_notification_settings_updated', parameters: {
        'enabled': _notificationSettings.enabled,
        'enabled_prayers_count': _notificationSettings.enabledPrayers.values.where((v) => v).length,
      });
      
      if (!mounted) return; // ✅ فحص mounted قبل استخدام context
      
      // ✅ استخدام النظام الموحد للإشعارات
      context.showSuccessSnackBar('تم حفظ إعدادات الإشعارات بنجاح');
      
      setState(() {
        _hasChanges = false;
      });
    } catch (e) {
      _logger.error(
        message: 'خطأ في حفظ إعدادات الإشعارات',
        error: e,
      );
      
      if (!mounted) return; // ✅ فحص mounted قبل استخدام context
      
      context.showErrorSnackBar('فشل حفظ إعدادات الإشعارات');
    } finally {
      if (mounted) { // ✅ فحص mounted قبل setState
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      // ✅ استخدام CustomAppBar الموحد
      appBar: CustomAppBar.simple(
        title: 'إعدادات إشعارات الصلوات',
        onBack: () => _handleBackPress(),
        actions: [
          if (_hasChanges && !_isSaving)
            AppBarAction(
              icon: AppIconsSystem.save,
              onPressed: () => _saveSettings(), // ✅ wrapper function
              tooltip: 'حفظ التغييرات',
              color: context.primaryColor,
            ),
        ],
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
        SliverToBoxAdapter(
          child: ThemeConstants.space8.h,
        ),
      ],
    );
  }

  Widget _buildMainSettingsSection() {
    // ✅ استخدام AppCard الموحد
    return AppCard.custom(
      margin: ThemeConstants.space4.all,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          _buildSectionHeader(
            'إعدادات الإشعارات العامة',
            'تفعيل أو تعطيل الإشعارات لجميع الصلوات',
            AppIconsSystem.notifications,
          ),
          
          const Divider(),
          
          // تفعيل/تعطيل الإشعارات
          SwitchListTile(
            title: Text(
              'تفعيل الإشعارات',
              style: AppTextStyles.label1.copyWith(
                color: context.textPrimaryColor,
              ),
            ),
            subtitle: Text(
              'تلقي تنبيهات أوقات الصلاة',
              style: AppTextStyles.body2.copyWith(
                color: context.textSecondaryColor,
              ),
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
            activeThumbColor: context.primaryColor,
          ),
          
          // الاهتزاز
          SwitchListTile(
            title: Text(
              'الاهتزاز',
              style: AppTextStyles.label1.copyWith(
                color: context.textPrimaryColor,
              ),
            ),
            subtitle: Text(
              'اهتزاز الجهاز عند التنبيه',
              style: AppTextStyles.body2.copyWith(
                color: context.textSecondaryColor,
              ),
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
            activeThumbColor: context.primaryColor,
          ),
          
          ThemeConstants.space2.h,
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Padding(
      padding: ThemeConstants.space4.all,
      child: Row(
        children: [
          // ✅ استخدام AppContainerBuilder الموحد
          AppContainerBuilder.basic(
            child: Icon(
              icon,
              color: context.primaryColor,
              size: ThemeConstants.iconMd,
            ),
            backgroundColor: context.primaryColor.withOpacitySafe(0.1),
            borderRadius: ThemeConstants.radiusMd,
            padding: ThemeConstants.space2.all,
          ),
          ThemeConstants.space3.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.h5.copyWith(
                    color: context.textPrimaryColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.body2.copyWith(
                    color: context.textSecondaryColor,
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
    const prayers = [
      (PrayerType.fajr, 'الفجر', Icons.dark_mode),
      (PrayerType.dhuhr, 'الظهر', Icons.light_mode),
      (PrayerType.asr, 'العصر', Icons.wb_cloudy),
      (PrayerType.maghrib, 'المغرب', Icons.wb_twilight),
      (PrayerType.isha, 'العشاء', Icons.bedtime),
    ];
    
    // ✅ استخدام AppCard الموحد
    return AppCard.custom(
      margin: ThemeConstants.space4.all,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          _buildSectionHeader(
            'إعدادات إشعارات الصلوات',
            'تخصيص الإشعارات لكل صلاة على حدة',
            AppIconsSystem.prayer,
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
      leading: AppContainerBuilder.basic(
        child: Icon(
          icon,
          color: context.primaryColor,
          size: ThemeConstants.iconMd,
        ),
        backgroundColor: context.primaryColor.withOpacitySafe(0.1),
        borderRadius: ThemeConstants.radiusMd,
        padding: const EdgeInsets.all(8),
      ),
      title: Text(
        name,
        style: AppTextStyles.label1.copyWith(
          color: context.textPrimaryColor,
        ),
      ),
      subtitle: Text(
        isEnabled && _notificationSettings.enabled
            ? 'تنبيه قبل $minutesBefore دقيقة'
            : 'التنبيه معطل',
        style: AppTextStyles.body2.copyWith(
          color: context.textSecondaryColor,
        ),
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
        activeThumbColor: context.primaryColor,
      ),
      children: [
        if (isEnabled && _notificationSettings.enabled)
          _buildMinutesSelector(type, minutesBefore),
      ],
    );
  }

  Widget _buildMinutesSelector(PrayerType type, int minutesBefore) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space2,
      ),
      child: Row(
        children: [
          Text(
            'التنبيه قبل',
            style: AppTextStyles.body2.copyWith(
              color: context.textPrimaryColor,
            ),
          ),
          
          ThemeConstants.space3.w,
          
          SizedBox(
            width: 80,
            child: DropdownButtonFormField<int>(
              value: minutesBefore,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space3,
                  vertical: ThemeConstants.space2,
                ),
                border: OutlineInputBorder(
                  borderRadius: ThemeConstants.radiusMd.circular,
                ),
              ),
              items: [0, 5, 10, 15, 20, 25, 30, 45, 60]
                  .map((minutes) => DropdownMenuItem(
                        value: minutes,
                        child: Text(
                          '$minutes',
                          style: AppTextStyles.body2.copyWith(
                            color: context.textPrimaryColor,
                          ),
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
          
          ThemeConstants.space2.w,
          
          Text(
            'دقيقة',
            style: AppTextStyles.body2.copyWith(
              color: context.textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: ThemeConstants.space4.all,
      child: AppButton.primary(
        text: 'حفظ الإعدادات',
        onPressed: _isSaving || !_hasChanges ? null : () => _saveSettings(), // ✅ wrapper function
        isLoading: _isSaving,
        isFullWidth: true,
        icon: AppIconsSystem.save,
        backgroundColor: context.primaryColor,
      ),
    );
  }

  void _handleBackPress() {
    if (_hasChanges) {
      _showUnsavedChangesDialog();
    } else {
      Navigator.pop(context);
    }
  }

  void _showUnsavedChangesDialog() {
    AppInfoDialog.showConfirmation(
      context: context,
      title: 'تغييرات غير محفوظة',
      content: 'لديك تغييرات لم يتم حفظها. هل تريد حفظ التغييرات قبل المغادرة؟',
      confirmText: 'حفظ وخروج',
      cancelText: 'تجاهل التغييرات',
    ).then((result) async {
      if (!mounted) return; // ✅ فحص mounted
      
      if (result == true) {
        await _saveSettings();
        if (mounted) Navigator.pop(context); // ✅ فحص mounted مرة أخرى
      } else {
        Navigator.pop(context);
      }
    });
  }
}