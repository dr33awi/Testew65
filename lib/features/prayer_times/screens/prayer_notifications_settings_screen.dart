// lib/features/prayer_times/screens/prayer_notifications_settings_screen.dart - محدث بالنظام الموحد الإسلامي الكامل

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد الإسلامي - محدث
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/widgets.dart';
import '../../../app/themes/widgets/extended_cards.dart';
import '../../../app/themes/utils/prayer_utils.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../services/prayer_times_service.dart';
import '../models/prayer_time_model.dart';

class PrayerNotificationsSettingsScreen extends StatefulWidget {
  const PrayerNotificationsSettingsScreen({super.key});

  @override
  State<PrayerNotificationsSettingsScreen> createState() => _PrayerNotificationsSettingsScreenState();
}

class _PrayerNotificationsSettingsScreenState extends State<PrayerNotificationsSettingsScreen>
    with TickerProviderStateMixin {
  late final LoggerService _logger;
  late final PrayerTimesService _prayerService;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  late PrayerNotificationSettings _notificationSettings;
  
  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeServices();
    _loadSettings();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: AppTheme.durationNormal,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    
    _animationController.forward();
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
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _isLoading
            ? AppLoading.page(message: 'جاري تحميل الإعدادات...')
            : _buildContent(),
      ),
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
    return SettingsGroupCard(
      title: 'إعدادات الإشعارات العامة',
      icon: Icons.notifications_active,
      children: [
        // تفعيل الإشعارات
        AppCard(
          child: SwitchListTile(
            title: Text(
              'تفعيل الإشعارات',
              style: context.bodyLarge,
            ),
            subtitle: Text(
              'تلقي تنبيهات أوقات الصلاة',
              style: context.bodySmall.copyWith(color: AppTheme.textSecondary),
            ),
            value: _notificationSettings.enabled,
            onChanged: (bool value) {
              setState(() {
                _notificationSettings = _notificationSettings.copyWith(
                  enabled: value,
                );
                _markAsChanged();
              });
            },
            activeColor: AppTheme.primary,
            secondary: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: AppTheme.radiusMd.radius,
              ),
              child: const Icon(
                Icons.notifications,
                color: AppTheme.primary,
                size: AppTheme.iconMd,
              ),
            ),
          ),
        ),
        
        // الاهتزاز
        AppCard(
          child: SwitchListTile(
            title: Text(
              'الاهتزاز',
              style: context.bodyLarge,
            ),
            subtitle: Text(
              'اهتزاز الجهاز عند التنبيه',
              style: context.bodySmall.copyWith(color: AppTheme.textSecondary),
            ),
            value: _notificationSettings.vibrate,
            onChanged: _notificationSettings.enabled
                ? (bool value) {
                    setState(() {
                      _notificationSettings = _notificationSettings.copyWith(
                        vibrate: value,
                      );
                      _markAsChanged();
                    });
                  }
                : null,
            activeColor: AppTheme.secondary,
            secondary: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.secondary.withValues(alpha: 0.1),
                borderRadius: AppTheme.radiusMd.radius,
              ),
              child: const Icon(
                Icons.vibration,
                color: AppTheme.secondary,
                size: AppTheme.iconMd,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerNotificationsSection() {
    const prayers = [
      (PrayerType.fajr, 'الفجر'),
      (PrayerType.dhuhr, 'الظهر'),
      (PrayerType.asr, 'العصر'),
      (PrayerType.maghrib, 'المغرب'),
      (PrayerType.isha, 'العشاء'),
    ];
    
    return SettingsGroupCard(
      title: 'إعدادات إشعارات الصلوات',
      icon: Icons.mosque,
      children: prayers.map((prayer) => _buildPrayerNotificationCard(
        prayer.$1,
        prayer.$2,
      )).toList(),
    );
  }

  Widget _buildPrayerNotificationCard(PrayerType type, String name) {
    final isEnabled = _notificationSettings.enabledPrayers[type] ?? false;
    final minutesBefore = _notificationSettings.minutesBefore[type] ?? 0;
    final prayerColor = context.getPrayerColor(name);
    
    return AppCard(
      color: prayerColor.withValues(alpha: 0.1),
      child: Column(
        children: [
          // رأس الصلاة مع التبديل
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: prayerColor.withValues(alpha: 0.2),
                  borderRadius: AppTheme.radiusMd.radius,
                ),
                child: Icon(
                  CardHelper.getPrayerIcon(name),
                  color: prayerColor,
                  size: AppTheme.iconMd,
                ),
              ),
              
              AppTheme.space3.w,
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: context.bodyLarge.copyWith(
                        fontWeight: AppTheme.semiBold,
                      ),
                    ),
                    Text(
                      isEnabled && _notificationSettings.enabled
                          ? 'تنبيه قبل $minutesBefore دقيقة'
                          : 'التنبيه معطل',
                      style: context.bodySmall.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              
              Switch(
                value: isEnabled,
                onChanged: _notificationSettings.enabled
                    ? (bool value) {
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
            ],
          ),
          
          // إعدادات الدقائق
          if (isEnabled && _notificationSettings.enabled) ...[
            AppTheme.space3.h,
            const Divider(color: AppTheme.divider),
            AppTheme.space3.h,
            _buildMinutesSelector(type, minutesBefore, prayerColor),
          ],
        ],
      ),
    );
  }

  Widget _buildMinutesSelector(PrayerType type, int minutesBefore, Color prayerColor) {
    return Row(
      children: [
        Icon(
          Icons.schedule,
          color: prayerColor,
          size: AppTheme.iconSm,
        ),
        
        AppTheme.space2.w,
        
        const Text('التنبيه قبل', style: AppTheme.bodyMedium),
        
        AppTheme.space3.w,
        
        // قائمة الدقائق
        Expanded(
          child: Wrap(
            spacing: AppTheme.space2,
            children: [0, 5, 10, 15, 20, 25, 30, 45, 60].map((minutes) {
              final isSelected = minutesBefore == minutes;
              
              return AnimatedPress(
                onTap: () => _updateMinutesBefore(type, minutes),
                child: Container(
                  padding: AppTheme.space2.paddingH.add(AppTheme.space1.paddingV),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? prayerColor 
                        : AppTheme.surface,
                    borderRadius: AppTheme.radiusFull.radius,
                    border: Border.all(
                      color: isSelected 
                          ? prayerColor 
                          : AppTheme.border,
                    ),
                  ),
                  child: Text(
                    '$minutes د',
                    style: context.bodySmall.copyWith(
                      color: isSelected 
                          ? Colors.white 
                          : AppTheme.textPrimary,
                      fontWeight: isSelected 
                          ? AppTheme.semiBold 
                          : AppTheme.medium,
                      fontFamily: AppTheme.numbersFont,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _updateMinutesBefore(PrayerType type, int minutes) {
    HapticFeedback.selectionClick();
    setState(() {
      final updatedMinutes = Map<PrayerType, int>.from(
        _notificationSettings.minutesBefore,
      );
      updatedMinutes[type] = minutes;
      
      _notificationSettings = _notificationSettings.copyWith(
        minutesBefore: updatedMinutes,
      );
      _markAsChanged();
    });
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
        title: Text(
          'تغييرات غير محفوظة',
          style: context.titleLarge,
        ),
        content: Text(
          'لديك تغييرات لم يتم حفظها. هل تريد حفظ التغييرات قبل المغادرة؟',
          style: context.bodyMedium,
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