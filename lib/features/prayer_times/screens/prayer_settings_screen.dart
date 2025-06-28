// lib/features/prayer_times/screens/prayer_settings_screen.dart - مُحدث بالنظام الموحد

import 'package:flutter/material.dart';

// ✅ استيراد النظام الموحد
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:athkar_app/app/themes/widgets/widgets.dart';

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
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('تم حفظ الإعدادات بنجاح'),
          backgroundColor: AppTheme.primary,
        ),
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
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('فشل حفظ الإعدادات'),
          backgroundColor: AppTheme.accent,
        ),
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
      backgroundColor: AppTheme.background,
      appBar: SimpleAppBar(
        title: 'إعدادات مواقيت الصلاة',
        actions: [
          if (_hasChanges && !_isSaving)
            IconButton(
              icon: Icon(Icons.save, color: AppTheme.textSecondary),
              onPressed: _saveSettings,
              tooltip: 'حفظ التغييرات',
            ),
        ],
      ),
      body: _isLoading
          ? AppLoading.page(message: 'جاري تحميل الإعدادات...')
          : SingleChildScrollView(
              padding: AppTheme.space4.padding,
              child: Column(
                children: [
                  // إعدادات طريقة الحساب
                  _buildCalculationSection(),
                  
                  AppTheme.space4.h,
                  
                  // إعدادات المذهب
                  _buildJuristicSection(),
                  
                  AppTheme.space4.h,
                  
                  // تعديلات يدوية
                  _buildManualAdjustmentsSection(),
                  
                  AppTheme.space6.h,
                  
                  // زر الحفظ
                  _buildSaveButton(),
                  
                  AppTheme.space8.h,
                ],
              ),
            ),
    );
  }

  Widget _buildCalculationSection() {
    return AppCard(
      title: 'طريقة الحساب',
      subtitle: 'اختر طريقة حساب مواقيت الصلاة',
      icon: Icons.calculate,
      child: Column(
        children: [
          AppTheme.space4.h,
          _buildCalculationMethodTile(),
        ],
      ),
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
      leading: Container(
        padding: AppTheme.space2.padding,
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.1),
          borderRadius: AppTheme.radiusMd.radius,
        ),
        child: Icon(
          Icons.calculate,
          color: AppTheme.primary,
          size: 20,
        ),
      ),
      title: Text(
        'طريقة الحساب',
        style: AppTheme.bodyMedium,
      ),
      subtitle: Text(
        methodNames[_calculationSettings.method] ?? '',
        style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: AppTheme.textSecondary,
      ),
      onTap: _showCalculationMethodDialog,
      contentPadding: EdgeInsets.zero,
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
    return AppCard(
      title: 'المذهب الفقهي',
      subtitle: 'اختر المذهب الفقهي لحساب وقت العصر',
      icon: Icons.school,
      child: Column(
        children: [
          AppTheme.space4.h,
          
          RadioListTile<AsrJuristic>(
            title: Text(
              'الجمهور',
              style: AppTheme.bodyMedium,
            ),
            subtitle: Text(
              'الشافعي، المالكي، الحنبلي',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
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
            activeColor: AppTheme.primary,
            contentPadding: EdgeInsets.zero,
          ),
          
          RadioListTile<AsrJuristic>(
            title: Text(
              'الحنفي',
              style: AppTheme.bodyMedium,
            ),
            subtitle: Text(
              'المذهب الحنفي',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
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
            activeColor: AppTheme.primary,
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildManualAdjustmentsSection() {
    return AppCard(
      title: 'تعديلات يدوية',
      subtitle: 'تعديل أوقات الصلاة بالدقائق (-30 إلى +30)',
      icon: Icons.tune,
      child: Column(
        children: [
          AppTheme.space4.h,
          
          _buildAdjustmentTile('الفجر', 'fajr'),
          _buildAdjustmentTile('الشروق', 'sunrise'),
          _buildAdjustmentTile('الظهر', 'dhuhr'),
          _buildAdjustmentTile('العصر', 'asr'),
          _buildAdjustmentTile('المغرب', 'maghrib'),
          _buildAdjustmentTile('العشاء', 'isha'),
        ],
      ),
    );
  }

  Widget _buildAdjustmentTile(String name, String key) {
    final adjustment = _calculationSettings.manualAdjustments[key] ?? 0;
    
    return Container(
      margin: EdgeInsets.only(bottom: AppTheme.space2),
      padding: AppTheme.space3.padding,
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: AppTheme.radiusMd.radius,
        border: Border.all(
          color: AppTheme.textSecondary.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: AppTheme.space2.padding,
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: AppTheme.radiusSm.radius,
            ),
            child: Icon(
              _getPrayerIcon(key),
              color: AppTheme.primary,
              size: 20,
            ),
          ),
          
          AppTheme.space3.w,
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTheme.bodyMedium,
                ),
                Text(
                  adjustment != 0 
                      ? 'تعديل: ${adjustment > 0 ? '+' : ''}$adjustment دقيقة' 
                      : 'بدون تعديل',
                  style: AppTheme.bodySmall.copyWith(
                    color: adjustment == 0 
                        ? AppTheme.textSecondary 
                        : AppTheme.primary,
                  ),
                ),
              ],
            ),
          ),
          
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () => _updateAdjustment(key, adjustment - 1),
                iconSize: 20,
                color: AppTheme.primary,
              ),
              Container(
                width: 50,
                child: Text(
                  adjustment > 0 ? '+$adjustment' : adjustment.toString(),
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: adjustment == 0 
                        ? AppTheme.textSecondary 
                        : AppTheme.primary,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => _updateAdjustment(key, adjustment + 1),
                iconSize: 20,
                color: AppTheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getPrayerIcon(String prayerKey) {
    switch (prayerKey) {
      case 'fajr':
        return Icons.dark_mode;
      case 'sunrise':
        return Icons.wb_sunny;
      case 'dhuhr':
        return Icons.light_mode;
      case 'asr':
        return Icons.wb_cloudy;
      case 'maghrib':
        return Icons.wb_twilight;
      case 'isha':
        return Icons.bedtime;
      default:
        return Icons.access_time;
    }
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
    return AppButton.primary(
      text: 'حفظ الإعدادات',
      icon: Icons.save,
      onPressed: _isSaving || !_hasChanges ? null : _saveSettings,
      isLoading: _isSaving,
      isFullWidth: true,
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
      backgroundColor: AppTheme.card,
      shape: RoundedRectangleBorder(
        borderRadius: AppTheme.radiusXl.radius,
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // العنوان
            Container(
              padding: AppTheme.space4.padding,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppTheme.radiusXl),
                  topRight: Radius.circular(AppTheme.radiusXl),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calculate,
                    color: Colors.white,
                    size: 24,
                  ),
                  AppTheme.space3.w,
                  Expanded(
                    child: Text(
                      'اختر طريقة الحساب',
                      style: AppTheme.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
                            ? AppTheme.primary.withValues(alpha: 0.1)
                            : null,
                        border: Border(
                          bottom: BorderSide(
                            color: AppTheme.textSecondary.withValues(alpha: 0.1),
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: RadioListTile<CalculationMethod>(
                        title: Text(
                          method.$2,
                          style: AppTheme.bodyMedium.copyWith(
                            fontWeight: isSelected 
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        subtitle: Text(
                          method.$3,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        value: method.$1,
                        groupValue: currentMethod,
                        onChanged: (value) {
                          if (value != null) {
                            onMethodSelected(value);
                          }
                        },
                        activeColor: AppTheme.primary,
                        contentPadding: AppTheme.space3.paddingH,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            
            // زر الإلغاء
            Padding(
              padding: AppTheme.space4.padding,
              child: AppButton.outline(
                text: 'إلغاء',
                onPressed: () => Navigator.pop(context),
                isFullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}