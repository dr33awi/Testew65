// lib/features/prayer_times/screens/prayer_notifications_settings_screen.dart - الإصلاح النهائي

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
    setState(() => _isSaving = true);
    
    try {
      await _prayerService.updateNotificationSettings(_notificationSettings);
      
      _logger.logEvent('prayer_notification_settings_updated', parameters: {
        'enabled': _notificationSettings.enabled,
        'enabled_prayers_count': _notificationSettings.enabledPrayers.values.where((v) => v).length,
      });
      
      if (!mounted) return;
      
      AppSnackBar.showSuccess(
        context: context,
        message: 'تم حفظ إعدادات الإشعارات بنجاح',
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
      
      AppSnackBar.showError(
        context: context,
        message: 'فشل حفظ إعدادات الإشعارات',
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
      backgroundColor: AppColorSystem.getBackground(context),
      appBar: CustomAppBar.simple(
        title: 'إعدادات إشعارات الصلوات',
        onBack: () {
          if (_hasChanges) {
            _showUnsavedChangesDialog();
          } else {
            Navigator.pop(context);
          }
        },
        actions: [
          if (_hasChanges && !_isSaving)
            AppBarAction(
              icon: AppIconsSystem.save,
              onPressed: _saveSettings,
              tooltip: 'حفظ التغييرات',
              color: AppColorSystem.primary,
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
        const SliverToBoxAdapter(
          child: SizedBox(height: ThemeConstants.space8),
        ),
      ],
    );
  }

  Widget _buildMainSettingsSection() {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        color: AppColorSystem.getCard(context),
        boxShadow: AppShadowSystem.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
                  decoration: BoxDecoration(
                    color: AppColorSystem.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  ),
                  child: Icon(
                    AppIconsSystem.notifications,
                    color: AppColorSystem.primary,
                    size: ThemeConstants.iconMd,
                  ),
                ),
                const SizedBox(width: ThemeConstants.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إعدادات الإشعارات العامة',
                        style: AppTextStyles.h5.copyWith(
                          color: AppColorSystem.getTextPrimary(context),
                        ),
                      ),
                      Text(
                        'تفعيل أو تعطيل الإشعارات لجميع الصلوات',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColorSystem.getTextSecondary(context),
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
            title: Text(
              'تفعيل الإشعارات',
              style: AppTextStyles.label1.copyWith(
                color: AppColorSystem.getTextPrimary(context),
              ),
            ),
            subtitle: Text(
              'تلقي تنبيهات أوقات الصلاة',
              style: AppTextStyles.body2.copyWith(
                color: AppColorSystem.getTextSecondary(context),
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
            activeThumbColor: AppColorSystem.primary,
          ),
          
          // الاهتزاز
          SwitchListTile(
            title: Text(
              'الاهتزاز',
              style: AppTextStyles.label1.copyWith(
                color: AppColorSystem.getTextPrimary(context),
              ),
            ),
            subtitle: Text(
              'اهتزاز الجهاز عند التنبيه',
              style: AppTextStyles.body2.copyWith(
                color: AppColorSystem.getTextSecondary(context),
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
            activeThumbColor: AppColorSystem.primary,
          ),
          
          const SizedBox(height: ThemeConstants.space2),
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
    
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        color: AppColorSystem.getCard(context),
        boxShadow: AppShadowSystem.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
                  decoration: BoxDecoration(
                    color: AppColorSystem.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  ),
                  child: Icon(
                    AppIconsSystem.prayer,
                    color: AppColorSystem.primary,
                    size: ThemeConstants.iconMd,
                  ),
                ),
                const SizedBox(width: ThemeConstants.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إعدادات إشعارات الصلوات',
                        style: AppTextStyles.h5.copyWith(
                          color: AppColorSystem.getTextPrimary(context),
                        ),
                      ),
                      Text(
                        'تخصيص الإشعارات لكل صلاة على حدة',
                        style: AppTextStyles.body2.copyWith(
                          color: AppColorSystem.getTextSecondary(context),
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
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColorSystem.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        child: Icon(
          icon,
          color: AppColorSystem.primary,
          size: ThemeConstants.iconMd,
        ),
      ),
      title: Text(
        name,
        style: AppTextStyles.label1.copyWith(
          color: AppColorSystem.getTextPrimary(context),
        ),
      ),
      subtitle: Text(
        isEnabled && _notificationSettings.enabled
            ? 'تنبيه قبل $minutesBefore دقيقة'
            : 'التنبيه معطل',
        style: AppTextStyles.body2.copyWith(
          color: AppColorSystem.getTextSecondary(context),
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
        activeThumbColor: AppColorSystem.primary,
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
              color: AppColorSystem.getTextPrimary(context),
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space3),
          
          SizedBox(
            width: 80,
            child: DropdownButtonFormField<int>(
              value: minutesBefore,
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space3,
                  vertical: ThemeConstants.space2,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(ThemeConstants.radiusMd)),
                ),
              ),
              items: [0, 5, 10, 15, 20, 25, 30, 45, 60]
                  .map((minutes) => DropdownMenuItem(
                        value: minutes,
                        child: Text(
                          '$minutes',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColorSystem.getTextPrimary(context),
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
          
          const SizedBox(width: ThemeConstants.space2),
          
          Text(
            'دقيقة',
            style: AppTextStyles.body2.copyWith(
              color: AppColorSystem.getTextPrimary(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: AppButton.primary(
        text: 'حفظ الإعدادات',
        onPressed: _isSaving || !_hasChanges ? null : _saveSettings,
        isLoading: _isSaving,
        isFullWidth: true,
        icon: AppIconsSystem.save,
        backgroundColor: AppColorSystem.primary,
      ),
    );
  }

  void _showUnsavedChangesDialog() {
    AppInfoDialog.showConfirmation(
      context: context,
      title: 'تغييرات غير محفوظة',
      content: 'لديك تغييرات لم يتم حفظها. هل تريد حفظ التغييرات قبل المغادرة؟',
      confirmText: 'حفظ وخروج',
      cancelText: 'تجاهل التغييرات',
    ).then((result) async {
      if (result == true) {
        await _saveSettings();
        if (mounted) Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    });
  }
}