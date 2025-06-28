// lib/features/prayer_times/screens/prayer_settings_screen.dart - مُحدث بالنظام الموحد

import 'package:athkar_app/features/settings/widgets/settings_section.dart';
import 'package:athkar_app/features/settings/widgets/settings_tile.dart';
import 'package:flutter/material.dart';

// ✅ استيراد النظام الموحد
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
      
      context.showSuccessSnackBar('تم حفظ الإعدادات بنجاح');
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
      
      context.showErrorSnackBar('فشل حفظ الإعدادات');
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
        actions: [
          if (_hasChanges && !_isSaving)
            AppBarAction(
              icon: Icons.save,
              onPressed: _saveSettings,
              tooltip: 'حفظ التغييرات',
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
                ThemeConstants.space8.sliverBox,
              ],
            ),
    );
  }

  Widget _buildCalculationSection() {
    return SettingsSection(
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
    
    return SettingsTile(
      icon: Icons.calculate,
      title: 'طريقة الحساب',
      subtitle: methodNames[_calculationSettings.method] ?? '',
      trailing: Icon(
        Icons.chevron_right,
        color: context.textSecondaryColor,
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
      icon: Icons.school,
      children: [
        SettingsTile(
          icon: Icons.radio_button_checked,
          title: 'الجمهور',
          subtitle: 'الشافعي، المالكي، الحنبلي',
          trailing: Radio<AsrJuristic>(
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
            activeColor: context.primaryColor,
          ),
          onTap: () {
            setState(() {
              _calculationSettings = _calculationSettings.copyWith(
                asrJuristic: AsrJuristic.standard,
              );
              _markAsChanged();
            });
          },
        ),
        SettingsTile(
          icon: Icons.radio_button_unchecked,
          title: 'الحنفي',
          subtitle: 'المذهب الحنفي',
          trailing: Radio<AsrJuristic>(
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
            activeColor: context.primaryColor,
          ),
          onTap: () {
            setState(() {
              _calculationSettings = _calculationSettings.copyWith(
                asrJuristic: AsrJuristic.hanafi,
              );
              _markAsChanged();
            });
          },
        ),
      ],
    );
  }

  Widget _buildManualAdjustmentsSection() {
    return SettingsSection(
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
    
    return SettingsTile(
      icon: context.getPrayerIcon(key),
      title: name,
      subtitle: adjustment != 0 ? 'تعديل: ${adjustment > 0 ? '+' : ''}$adjustment دقيقة' : 'بدون تعديل',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton.text(
            text: '',
            icon: Icons.remove_circle_outline,
            onPressed: () => _updateAdjustment(key, adjustment - 1),
            textColor: context.primaryColor,
          ),
          Container(
            width: 50,
            child: Text(
              adjustment > 0 ? '+$adjustment' : adjustment.toString(),
              textAlign: TextAlign.center,
              style: context.titleMedium?.copyWith(
                fontWeight: ThemeConstants.semiBold,
                color: adjustment == 0 
                    ? context.textSecondaryColor 
                    : context.primaryColor,
              ),
            ),
          ),
          AppButton.text(
            text: '',
            icon: Icons.add_circle_outline,
            onPressed: () => _updateAdjustment(key, adjustment + 1),
            textColor: context.primaryColor,
          ),
        ],
      ),
      onTap: () => _showAdjustmentDialog(name, key, adjustment),
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

  void _showAdjustmentDialog(String prayerName, String key, int currentValue) {
    int newValue = currentValue;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('تعديل وقت $prayerName'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'تعديل الوقت بالدقائق',
                style: context.bodyMedium?.copyWith(
                  color: context.textSecondaryColor,
                ),
              ),
              ThemeConstants.space4.h,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppButton.outline(
                    text: '',
                    icon: Icons.remove,
                    onPressed: () {
                      setState(() {
                        newValue = (newValue - 1).clamp(-30, 30);
                      });
                    },
                  ),
                  ThemeConstants.space4.w,
                  Container(
                    width: 80,
                    child: Text(
                      newValue > 0 ? '+$newValue' : newValue.toString(),
                      textAlign: TextAlign.center,
                      style: context.headlineSmall?.copyWith(
                        fontWeight: ThemeConstants.bold,
                        color: context.primaryColor,
                      ),
                    ),
                  ),
                  ThemeConstants.space4.w,
                  AppButton.outline(
                    text: '',
                    icon: Icons.add,
                    onPressed: () {
                      setState(() {
                        newValue = (newValue + 1).clamp(-30, 30);
                      });
                    },
                  ),
                ],
              ),
              ThemeConstants.space3.h,
              Text(
                'النطاق: -30 إلى +30 دقيقة',
                style: context.bodySmall?.copyWith(
                  color: context.textSecondaryColor,
                ),
              ),
            ],
          ),
          actions: [
            AppButton.outline(
              text: 'إلغاء',
              onPressed: () => Navigator.pop(context),
            ),
            AppButton.primary(
              text: 'حفظ',
              onPressed: () {
                _updateAdjustment(key, newValue);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: ThemeConstants.space4.padding,
      child: AppButton.primary(
        text: 'حفظ الإعدادات',
        onPressed: _isSaving || !_hasChanges ? null : _saveSettings,
        isLoading: _isSaving,
        isFullWidth: true,
        icon: Icons.save,
      ),
    );
  }
}

/// مربع حوار اختيار طريقة الحساب
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
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
      child: Container(
        constraints: BoxConstraints(maxHeight: context.screenHeight * 0.8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // العنوان
            Container(
              padding: ThemeConstants.space4.padding,
              decoration: BoxDecoration(
                gradient: context.primaryGradient,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(ThemeConstants.radiusXl),
                  topRight: Radius.circular(ThemeConstants.radiusXl),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calculate,
                    color: Colors.white,
                    size: ThemeConstants.iconLg,
                  ),
                  ThemeConstants.space3.w,
                  Expanded(
                    child: Text(
                      'اختر طريقة الحساب',
                      style: context.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // القائمة
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  children: methods.map((method) {
                    final isSelected = method.$1 == currentMethod;
                    return Container(
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? context.primaryColor.withValues(alpha: 0.1)
                            : null,
                        border: Border(
                          bottom: BorderSide(
                            color: context.dividerColor,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: RadioListTile<CalculationMethod>(
                        title: Text(
                          method.$2,
                          style: context.titleSmall?.copyWith(
                            fontWeight: isSelected 
                                ? ThemeConstants.semiBold 
                                : ThemeConstants.medium,
                          ),
                        ),
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
                            onMethodSelected(value);
                          }
                        },
                        activeColor: context.primaryColor,
                        contentPadding: ThemeConstants.space4.paddingH,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            // أزرار التحكم
            Padding(
              padding: ThemeConstants.space4.padding,
              child: Row(
                children: [
                  Expanded(
                    child: AppButton.outline(
                      text: 'إلغاء',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}