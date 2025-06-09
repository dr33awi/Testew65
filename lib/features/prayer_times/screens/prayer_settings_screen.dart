// lib/features/prayer_times/screens/prayer_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../services/prayer_times_service.dart';
import '../models/prayer_time_model.dart';

class PrayerSettingsScreen extends StatefulWidget {
  const PrayerSettingsScreen({super.key});

  @override
  State<PrayerSettingsScreen> createState() => _PrayerSettingsScreenState();
}

class _PrayerSettingsScreenState extends State<PrayerSettingsScreen> {
  late final LoggerService _logger;
  late final PrayerTimesService _prayerService;
  
  // إعدادات الحساب
  late PrayerCalculationSettings _calculationSettings;
  
  // إعدادات التنبيهات
  late PrayerNotificationSettings _notificationSettings;
  
  // حالة التحميل
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _loadSettings();
  }

  void _initializeServices() {
    _logger = getIt<LoggerService>();
    _prayerService = PrayerTimesService(
      logger: _logger,
      storage: getIt(),
      permissionService: getIt(),
    );
  }

  void _loadSettings() {
    setState(() {
      _calculationSettings = _prayerService.calculationSettings;
      _notificationSettings = _prayerService.notificationSettings;
      _isLoading = false;
    });
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    
    try {
      // حفظ إعدادات الحساب
      await _prayerService.updateCalculationSettings(_calculationSettings);
      
      // حفظ إعدادات التنبيهات
      await _prayerService.updateNotificationSettings(_notificationSettings);
      
      _logger.logEvent('prayer_settings_updated', parameters: {
        'calculation_method': _calculationSettings.method.toString(),
        'notifications_enabled': _notificationSettings.enabled,
      });
      
      if (mounted) {
        context.showSuccessSnackBar('تم حفظ الإعدادات بنجاح');
        Navigator.pop(context);
      }
    } catch (e) {
      _logger.error(
        message: 'خطأ في حفظ الإعدادات',
        error: e,
      );
      
      if (mounted) {
        context.showErrorSnackBar('فشل حفظ الإعدادات');
      }
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
      appBar: CustomAppBar.simple(
        title: 'إعدادات مواقيت الصلاة',
      ),
      body: _isLoading
          ? Center(child: AppLoading.circular())
          : CustomScrollView(
              slivers: [
                // إعدادات طريقة الحساب
                SliverToBoxAdapter(
                  child: _buildCalculationSection(),
                ),
                
                // إعدادات المذهب
                SliverToBoxAdapter(
                  child: _buildJuristicSection(),
                ),
                
                // إعدادات التنبيهات
                SliverToBoxAdapter(
                  child: _buildNotificationSection(),
                ),
                
                // تعديلات يدوية
                SliverToBoxAdapter(
                  child: _buildManualAdjustmentsSection(),
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
            ),
    );
  }

  Widget _buildCalculationSection() {
    return _SettingsSection(
      title: 'طريقة الحساب',
      icon: Icons.calculate,
      children: [
        _buildCalculationMethodTile(),
      ],
    );
  }

  Widget _buildCalculationMethodTile() {
    final methodNames = {
      CalculationMethod.muslimWorldLeague: 'رابطة العالم الإسلامي',
      CalculationMethod.egyptian: 'الهيئة المصرية العامة للمساحة',
      CalculationMethod.karachi: 'جامعة العلوم الإسلامية، كراتشي',
      CalculationMethod.ummAlQura: 'أم القرى',
      CalculationMethod.dubai: 'دبي',
      CalculationMethod.qatar: 'قطر',
      CalculationMethod.kuwait: 'الكويت',
      CalculationMethod.singapore: 'سنغافورة',
      CalculationMethod.northAmerica: 'الجمعية الإسلامية لأمريكا الشمالية',
      CalculationMethod.other: 'أخرى',
    };
    
    return ListTile(
      title: const Text('طريقة الحساب'),
      subtitle: Text(methodNames[_calculationSettings.method] ?? ''),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        _showCalculationMethodDialog();
      },
    );
  }

  void _showCalculationMethodDialog() {
    showDialog(
      context: context,
      builder: (context) => _CalculationMethodDialog(
        currentMethod: _calculationSettings.method,
        onMethodSelected: (method) {
          setState(() {
            _calculationSettings = _calculationSettings.copyWith(
              method: method,
            );
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildJuristicSection() {
    return _SettingsSection(
      title: 'المذهب الفقهي',
      icon: Icons.school,
      children: [
        RadioListTile<AsrJuristic>(
          title: const Text('الجمهور'),
          subtitle: const Text('الشافعي، المالكي، الحنبلي'),
          value: AsrJuristic.standard,
          groupValue: _calculationSettings.asrJuristic,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _calculationSettings = _calculationSettings.copyWith(
                  asrJuristic: value,
                );
              });
            }
          },
        ),
        RadioListTile<AsrJuristic>(
          title: const Text('الحنفي'),
          subtitle: const Text('المذهب الحنفي'),
          value: AsrJuristic.hanafi,
          groupValue: _calculationSettings.asrJuristic,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _calculationSettings = _calculationSettings.copyWith(
                  asrJuristic: value,
                );
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildNotificationSection() {
    return _SettingsSection(
      title: 'التنبيهات',
      icon: Icons.notifications,
      children: [
        SwitchListTile(
          title: const Text('تفعيل التنبيهات'),
          subtitle: const Text('تلقي تنبيهات لأوقات الصلاة'),
          value: _notificationSettings.enabled,
          onChanged: (value) {
            setState(() {
              _notificationSettings = _notificationSettings.copyWith(
                enabled: value,
              );
            });
          },
        ),
        
        if (_notificationSettings.enabled) ...[
          const Divider(),
          
          // تنبيهات كل صلاة
          _buildPrayerNotificationTile(
            'الفجر',
            PrayerType.fajr,
          ),
          _buildPrayerNotificationTile(
            'الظهر',
            PrayerType.dhuhr,
          ),
          _buildPrayerNotificationTile(
            'العصر',
            PrayerType.asr,
          ),
          _buildPrayerNotificationTile(
            'المغرب',
            PrayerType.maghrib,
          ),
          _buildPrayerNotificationTile(
            'العشاء',
            PrayerType.isha,
          ),
          
          const Divider(),
          
          SwitchListTile(
            title: const Text('الاهتزاز'),
            subtitle: const Text('اهتزاز الجهاز عند التنبيه'),
            value: _notificationSettings.vibrate,
            onChanged: (value) {
              setState(() {
                _notificationSettings = _notificationSettings.copyWith(
                  vibrate: value,
                );
              });
            },
          ),
        ],
      ],
    );
  }

  Widget _buildPrayerNotificationTile(String name, PrayerType type) {
    final isEnabled = _notificationSettings.enabledPrayers[type] ?? false;
    final minutesBefore = _notificationSettings.minutesBefore[type] ?? 0;
    
    return ExpansionTile(
      title: Text(name),
      subtitle: Text(
        isEnabled
            ? 'تنبيه قبل $minutesBefore دقيقة'
            : 'التنبيه مُعطّل',
      ),
      leading: Switch(
        value: isEnabled,
        onChanged: (value) {
          setState(() {
            final updatedPrayers = Map<PrayerType, bool>.from(
              _notificationSettings.enabledPrayers,
            );
            updatedPrayers[type] = value;
            
            _notificationSettings = _notificationSettings.copyWith(
              enabledPrayers: updatedPrayers,
            );
          });
        },
      ),
      children: [
        if (isEnabled)
          Padding(
            padding: const EdgeInsets.symmetric(
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
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ThemeConstants.space2,
                        vertical: ThemeConstants.space1,
                      ),
                    ),
                    items: [0, 5, 10, 15, 20, 25, 30]
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

  Widget _buildManualAdjustmentsSection() {
    return _SettingsSection(
      title: 'تعديلات يدوية',
      icon: Icons.tune,
      subtitle: 'تعديل أوقات الصلاة بالدقائق',
      children: [
        _buildAdjustmentTile('الفجر', 'fajr'),
        _buildAdjustmentTile('الشروق', 'sunrise'),
        _buildAdjustmentTile('الظهر', 'dhuhr'),
        _buildAdjustmentTile('العصر', 'asr'),
        _buildAdjustmentTile('المغرب', 'maghrib'),
        _buildAdjustmentTile('العشاء', 'isha'),
      ],
    );
  }

  Widget _buildAdjustmentTile(String name, String key) {
    final adjustment = _calculationSettings.manualAdjustments[key] ?? 0;
    
    return ListTile(
      title: Text(name),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: () {
              _updateAdjustment(key, adjustment - 1);
            },
          ),
          SizedBox(
            width: 50,
            child: Text(
              adjustment > 0 ? '+$adjustment' : adjustment.toString(),
              textAlign: TextAlign.center,
              style: context.titleMedium?.semiBold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              _updateAdjustment(key, adjustment + 1);
            },
          ),
        ],
      ),
    );
  }

  void _updateAdjustment(String key, int value) {
    setState(() {
      final adjustments = Map<String, int>.from(
        _calculationSettings.manualAdjustments,
      );
      adjustments[key] = value.clamp(-30, 30);
      
      _calculationSettings = _calculationSettings.copyWith(
        manualAdjustments: adjustments,
      );
    });
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: AppButton.primary(
        text: 'حفظ الإعدادات',
        onPressed: _isSaving ? null : _saveSettings,
        isLoading: _isSaving,
        isFullWidth: true,
        icon: Icons.save,
      ),
    );
  }
}

// ===== Helper Widgets =====

class _SettingsSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space2),
                decoration: BoxDecoration(
                  color: context.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: context.primaryColor,
                  size: ThemeConstants.iconMd,
                ),
              ),
              ThemeConstants.space3.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.titleMedium?.semiBold,
                    ),
                    if (subtitle != null) ...[
                      ThemeConstants.space1.h,
                      Text(
                        subtitle!,
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        
        Card(
          margin: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space4,
            vertical: ThemeConstants.space2,
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _CalculationMethodDialog extends StatelessWidget {
  final CalculationMethod currentMethod;
  final Function(CalculationMethod) onMethodSelected;

  const _CalculationMethodDialog({
    required this.currentMethod,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    final methods = [
      (CalculationMethod.muslimWorldLeague, 'رابطة العالم الإسلامي', 'الفجر 18°، العشاء 17°'),
      (CalculationMethod.egyptian, 'الهيئة المصرية العامة للمساحة', 'الفجر 19.5°، العشاء 17.5°'),
      (CalculationMethod.karachi, 'جامعة العلوم الإسلامية، كراتشي', 'الفجر 18°، العشاء 18°'),
      (CalculationMethod.ummAlQura, 'أم القرى', 'الفجر 18.5°، العشاء 90 دقيقة بعد المغرب'),
      (CalculationMethod.dubai, 'دبي', 'الفجر 18.2°، العشاء 18.2°'),
      (CalculationMethod.qatar, 'قطر', 'الفجر 18°، العشاء 90 دقيقة بعد المغرب'),
      (CalculationMethod.kuwait, 'الكويت', 'الفجر 18°، العشاء 17.5°'),
      (CalculationMethod.singapore, 'سنغافورة', 'الفجر 20°، العشاء 18°'),
      (CalculationMethod.northAmerica, 'الجمعية الإسلامية لأمريكا الشمالية', 'الفجر 15°، العشاء 15°'),
    ];
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: Text(
              'اختر طريقة الحساب',
              style: context.titleLarge?.semiBold,
            ),
          ),
          
          const Divider(),
          
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: methods.map((method) {
                  return RadioListTile<CalculationMethod>(
                    title: Text(method.$2),
                    subtitle: Text(
                      method.$3,
                      style: context.bodySmall?.copyWith(
                        color: context.textSecondaryColor,
                      ),
                    ),
                    value: method.$1,
                    groupValue: currentMethod,
                    onChanged: (value) {
                      if (value != null) {
                        HapticFeedback.lightImpact();
                        onMethodSelected(value);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          
          const Divider(),
          
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.space3),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
          ),
        ],
      ),
    );
  }
}