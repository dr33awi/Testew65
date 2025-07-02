// lib/features/prayer_times/screens/prayer_settings_screen.dart - مُصحح

import 'package:flutter/material.dart';
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
  
  // حالة التحميل
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
      _calculationSettings = _prayerService.calculationSettings;
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
      // حفظ إعدادات الحساب
      await _prayerService.updateCalculationSettings(_calculationSettings);
      
      _logger.logEvent('prayer_settings_updated', parameters: {
        'calculation_method': _calculationSettings.method.toString(),
      });
      
      if (!mounted) return;
      
      AppSnackBar.showSuccess(
        context: context, 
        message: 'تم حفظ الإعدادات بنجاح',
      );
      
      setState(() {
        _hasChanges = false;
      });
      
      // العودة للشاشة السابقة
      Navigator.pop(context);
    } catch (e) {
      _logger.error(
        message: 'خطأ في حفظ الإعدادات',
        error: e,
      );
      
      if (!mounted) return;
      
      AppSnackBar.showError(
        context: context,
        message: 'فشل حفظ الإعدادات',
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
        title: 'إعدادات مواقيت الصلاة',
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
                
                // تعديلات يدوية
                SliverToBoxAdapter(
                  child: _buildManualAdjustmentsSection(),
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
    ).then((result) {
      if (result == true) {
        _saveSettings();
      } else {
        Navigator.pop(context);
      }
    });
  }

  Widget _buildCalculationSection() {
    return SettingsSection(
      title: 'طريقة الحساب',
      icon: AppIconsSystem.calculate,
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
      title: Text(
        'طريقة الحساب',
        style: AppTextStyles.label1.copyWith(
          color: AppColorSystem.getTextPrimary(context),
        ),
      ),
      subtitle: Text(
        methodNames[_calculationSettings.method] ?? '',
        style: AppTextStyles.body2.copyWith(
          color: AppColorSystem.getTextSecondary(context),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppColorSystem.getTextSecondary(context),
      ),
      onTap: _showCalculationMethodDialog,
    );
  }

  void _showCalculationMethodDialog() {
    showDialog(
      context: context,
      builder: (context) => CalculationMethodDialog(
        currentMethod: _calculationSettings.method,
        onMethodSelected: (method) {
          setState(() {
            _calculationSettings = _calculationSettings.copyWith(
              method: method,
            );
            _markAsChanged();
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildJuristicSection() {
    return SettingsSection(
      title: 'المذهب الفقهي',
      icon: AppIconsSystem.school,
      children: [
        RadioListTile<AsrJuristic>(
          title: Text(
            'الجمهور',
            style: AppTextStyles.label1.copyWith(
              color: AppColorSystem.getTextPrimary(context),
            ),
          ),
          subtitle: Text(
            'الشافعي، المالكي، الحنبلي',
            style: AppTextStyles.caption.copyWith(
              color: AppColorSystem.getTextSecondary(context),
            ),
          ),
          value: AsrJuristic.standard,
          groupValue: _calculationSettings.asrJuristic,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _calculationSettings = _calculationSettings.copyWith(
                  asrJuristic: value,
                );
                _markAsChanged();
              });
            }
          },
          activeColor: AppColorSystem.primary,
        ),
        RadioListTile<AsrJuristic>(
          title: Text(
            'الحنفي',
            style: AppTextStyles.label1.copyWith(
              color: AppColorSystem.getTextPrimary(context),
            ),
          ),
          subtitle: Text(
            'المذهب الحنفي',
            style: AppTextStyles.caption.copyWith(
              color: AppColorSystem.getTextSecondary(context),
            ),
          ),
          value: AsrJuristic.hanafi,
          groupValue: _calculationSettings.asrJuristic,
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _calculationSettings = _calculationSettings.copyWith(
                  asrJuristic: value,
                );
                _markAsChanged();
              });
            }
          },
          activeColor: AppColorSystem.primary,
        ),
      ],
    );
  }

  Widget _buildManualAdjustmentsSection() {
    return SettingsSection(
      title: 'تعديلات يدوية',
      icon: AppIconsSystem.tune,
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
      title: Text(
        name,
        style: AppTextStyles.label1.copyWith(
          color: AppColorSystem.getTextPrimary(context),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            color: AppColorSystem.primary,
            onPressed: () {
              _updateAdjustment(key, adjustment - 1);
            },
          ),
          SizedBox(
            width: 50,
            child: Text(
              adjustment > 0 ? '+$adjustment' : adjustment.toString(),
              textAlign: TextAlign.center,
              style: AppTextStyles.label1.copyWith(
                color: AppColorSystem.getTextPrimary(context),
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            color: AppColorSystem.primary,
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
      _markAsChanged();
    });
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
}

/// قسم في شاشة الإعدادات - مُصحح
class SettingsSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final List<Widget> children;

  const SettingsSection({
    super.key,
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
                  color: AppColorSystem.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: AppColorSystem.primary,
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
                      style: AppTextStyles.h5.copyWith(
                        color: AppColorSystem.getTextPrimary(context),
                      ),
                    ),
                    if (subtitle != null) ...[
                      ThemeConstants.space1.h,
                      Text(
                        subtitle!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColorSystem.getTextSecondary(context),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space4,
            vertical: ThemeConstants.space2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            color: AppColorSystem.getCard(context),
            boxShadow: AppShadowSystem.card,
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

/// مربع حوار اختيار طريقة الحساب - مُصحح
class CalculationMethodDialog extends StatelessWidget {
  final CalculationMethod currentMethod;
  final Function(CalculationMethod) onMethodSelected;

  const CalculationMethodDialog({
    super.key,
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
      backgroundColor: AppColorSystem.getCard(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: Text(
              'اختر طريقة الحساب',
              style: AppTextStyles.h4.copyWith(
                color: AppColorSystem.getTextPrimary(context),
              ),
            ),
          ),
          
          const Divider(),
          
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: methods.map((method) {
                  return RadioListTile<CalculationMethod>(
                    title: Text(
                      method.$2,
                      style: AppTextStyles.label1.copyWith(
                        color: AppColorSystem.getTextPrimary(context),
                      ),
                    ),
                    subtitle: Text(
                      method.$3,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColorSystem.getTextSecondary(context),
                      ),
                    ),
                    value: method.$1,
                    groupValue: currentMethod,
                    onChanged: (value) {
                      if (value != null) {
                        onMethodSelected(value);
                      }
                    },
                    activeColor: AppColorSystem.primary,
                  );
                }).toList(),
              ),
            ),
          ),
          
          const Divider(),
          
          Padding(
            padding: const EdgeInsets.all(ThemeConstants.space3),
            child: AppButton.text(
              text: 'إلغاء',
              onPressed: () => Navigator.pop(context),
              color: AppColorSystem.primary,
            ),
          ),
        ],
      ),
    );
  }
}