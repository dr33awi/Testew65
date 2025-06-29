// lib/features/prayer_times/screens/prayer_notifications_settings_screen.dart - محدث بالثيم الإسلامي الموحد

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد الإسلامي - محدث
import 'package:athkar_app/app/themes/index.dart';

import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';

// نماذج البيانات الأساسية
enum PrayerType {
  fajr,
  dhuhr,
  asr,
  maghrib,
  isha,
}

class PrayerNotificationSettings {
  final bool enabled;
  final bool vibrate;
  final Map<PrayerType, bool> enabledPrayers;
  final Map<PrayerType, int> minutesBefore;

  PrayerNotificationSettings({
    required this.enabled,
    required this.vibrate,
    required this.enabledPrayers,
    required this.minutesBefore,
  });

  PrayerNotificationSettings copyWith({
    bool? enabled,
    bool? vibrate,
    Map<PrayerType, bool>? enabledPrayers,
    Map<PrayerType, int>? minutesBefore,
  }) {
    return PrayerNotificationSettings(
      enabled: enabled ?? this.enabled,
      vibrate: vibrate ?? this.vibrate,
      enabledPrayers: enabledPrayers ?? this.enabledPrayers,
      minutesBefore: minutesBefore ?? this.minutesBefore,
    );
  }
}

class PrayerNotificationsSettingsScreen extends StatefulWidget {
  const PrayerNotificationsSettingsScreen({super.key});

  @override
  State<PrayerNotificationsSettingsScreen> createState() => 
    _PrayerNotificationsSettingsScreenState();
}

class _PrayerNotificationsSettingsScreenState extends State<PrayerNotificationsSettingsScreen>
    with TickerProviderStateMixin {
  late final LoggerService _logger;
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
  }

  void _loadSettings() {
    // تحميل الإعدادات الافتراضية
    setState(() {
      _notificationSettings = PrayerNotificationSettings(
        enabled: true,
        vibrate: true,
        enabledPrayers: {
          PrayerType.fajr: true,
          PrayerType.dhuhr: true,
          PrayerType.asr: true,
          PrayerType.maghrib: true,
          PrayerType.isha: true,
        },
        minutesBefore: {
          PrayerType.fajr: 10,
          PrayerType.dhuhr: 5,
          PrayerType.asr: 5,
          PrayerType.maghrib: 5,
          PrayerType.isha: 10,
        },
      );
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
      // محاكاة حفظ الإعدادات
      await Future.delayed(const Duration(seconds: 1));
      
      _logger.logEvent('prayer_notification_settings_updated', parameters: {
        'enabled': _notificationSettings.enabled,
        'enabled_prayers_count': _notificationSettings.enabledPrayers.values.where((v) => v).length,
        'vibrate': _notificationSettings.vibrate,
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
      appBar: AppAppBar.basic(
        title: 'إعدادات إشعارات الصلوات',
        actions: [
          if (_hasChanges && !_isSaving)
            IconButton(
              icon: const Icon(Icons.save, color: AppTheme.primary),
              onPressed: _saveSettings,
              tooltip: 'حفظ التغييرات',
            ),
        ],
        onBackPressed: () {
          if (_hasChanges) {
            _showUnsavedChangesDialog();
          } else {
            Navigator.pop(context);
          }
        },
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
    return Padding(
      padding: AppTheme.space4.paddingH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTheme.space4.h,
          
          // عنوان القسم
          Text(
            'إعدادات الإشعارات العامة',
            style: AppTheme.headlineMedium.copyWith(
              fontWeight: AppTheme.bold,
            ),
          ),
          
          AppTheme.space3.h,
          
          // تفعيل الإشعارات
          SettingCard.toggle(
            title: 'تفعيل الإشعارات',
            subtitle: 'تلقي تنبيهات أوقات الصلاة',
            icon: Icons.notifications,
            value: _notificationSettings.enabled,
            onChanged: (bool value) {
              setState(() {
                _notificationSettings = _notificationSettings.copyWith(
                  enabled: value,
                );
                _markAsChanged();
              });
            },
            color: AppTheme.primary,
          ),
          
          AppTheme.space3.h,
          
          // الاهتزاز
          SettingCard.toggle(
            title: 'الاهتزاز',
            subtitle: 'اهتزاز الجهاز عند التنبيه',
            icon: Icons.vibration,
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
            color: AppTheme.secondary,
          ),
        ],
      ),
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
    
    return Padding(
      padding: AppTheme.space4.paddingH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTheme.space6.h,
          
          // عنوان القسم
          Text(
            'إعدادات إشعارات الصلوات',
            style: AppTheme.headlineMedium.copyWith(
              fontWeight: AppTheme.bold,
            ),
          ),
          
          AppTheme.space3.h,
          
          ...prayers.map((prayer) => _buildPrayerNotificationCard(
            prayer.$1,
            prayer.$2,
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildPrayerNotificationCard(PrayerType type, String name) {
    final isEnabled = _notificationSettings.enabledPrayers[type] ?? false;
    final minutesBefore = _notificationSettings.minutesBefore[type] ?? 0;
    final prayerColor = AppTheme.getPrayerColor(name);
    
    return Padding(
      padding: EdgeInsets.only(bottom: AppTheme.space3),
      child: AppCard(
        child: Column(
          children: [
            // رأس الصلاة مع التبديل
            Row(
              children: [
                // أيقونة الصلاة
                Icon(
                  AppTheme.getPrayerIcon(name),
                  color: prayerColor,
                  size: AppTheme.iconMd,
                ),
                
                AppTheme.space3.w,
                
                // معلومات الصلاة
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: AppTheme.semiBold,
                        ),
                      ),
                      AppTheme.space1.h,
                      Text(
                        isEnabled && _notificationSettings.enabled
                            ? 'تنبيه قبل $minutesBefore دقيقة'
                            : 'التنبيه معطل',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // مفتاح التشغيل
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
              _buildMinutesSelector(type, minutesBefore, prayerColor),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMinutesSelector(PrayerType type, int minutesBefore, Color prayerColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // فاصل
        Container(
          height: 1,
          color: AppTheme.divider,
          margin: AppTheme.space2.paddingV,
        ),
        
        Row(
          children: [
            Icon(
              Icons.schedule,
              color: prayerColor,
              size: AppTheme.iconSm,
            ),
            
            AppTheme.space2.w,
            
            Text(
              'التنبيه قبل:',
              style: AppTheme.bodyMedium.copyWith(
                fontWeight: AppTheme.medium,
              ),
            ),
          ],
        ),
        
        AppTheme.space3.h,
        
        // قائمة الدقائق
        Wrap(
          spacing: AppTheme.space2,
          runSpacing: AppTheme.space2,
          children: [0, 5, 10, 15, 20, 25, 30, 45, 60].map((minutes) {
            final isSelected = minutesBefore == minutes;
            
            return GestureDetector(
              onTap: () => _updateMinutesBefore(type, minutes),
              child: AnimatedContainer(
                duration: AppTheme.durationFast,
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
                  style: AppTheme.bodySmall.copyWith(
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