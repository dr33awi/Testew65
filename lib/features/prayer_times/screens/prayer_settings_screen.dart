// lib/features/prayer_times/screens/prayer_settings_screen.dart (محدث بالنظام الموحد)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/widgets.dart';
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
          backgroundColor: AppTheme.success,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: SimpleAppBar(
        title: 'إعدادات مواقيت الصلاة',
        actions: [
          if (_hasChanges && !_isSaving)
            IconButton(
              icon: Icon(Icons.save, color: AppTheme.primary),
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
                SliverToBoxAdapter(child: AppTheme.space8.h),
              ],
            ),
    );
  }

  Widget _buildCalculationSection() {
    return AppCard(
      title: 'طريقة الحساب',
      subtitle: 'اختر الطريقة المناسبة لحساب مواقيت الصلاة',
      icon: Icons.calculate,
      child: Column(
        children: [
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
    
    return AnimatedPress(
      onTap: _showCalculationMethodDialog,
      child: ListTile(
        title: Text(
          'طريقة الحساب',
          style: AppTheme.bodyLarge,
        ),
        subtitle: Text(
          methodNames[_calculationSettings.method] ?? '',
          style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: AppTheme.primary,
        ),
      ),
    );
  }

  void _showCalculationMethodDialog() {
    HapticFeedback.lightImpact();
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
      subtitle: 'اختر المذهب المناسب لحساب صلاة العصر',
      icon: Icons.school,
      child: Column(
        children: [
          RadioListTile<AsrJuristic>(
            title: Text('الجمهور', style: AppTheme.bodyLarge),
            subtitle: Text(
              'الشافعي، المالكي، الحنبلي',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
            ),
            value: AsrJuristic.standard,
            groupValue: _calculationSettings.asrJuristic,
            onChanged: (value) {
              if (value != null) {
                HapticFeedback.selectionClick();
                setState(() {
                  _calculationSettings = _calculationSettings.copyWith(
                    asrJuristic: value,
                  );
                  _markAsChanged();
                });
              }
            },
            activeColor: AppTheme.primary,
          ),
          
          RadioListTile<AsrJuristic>(
            title: Text('الحنفي', style: AppTheme.bodyLarge),
            subtitle: Text(
              'المذهب الحنفي',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
            ),
            value: AsrJuristic.hanafi,
            groupValue: _calculationSettings.asrJuristic,
            onChanged: (value) {
              if (value != null) {
                HapticFeedback.selectionClick();
                setState(() {
                  _calculationSettings = _calculationSettings.copyWith(
                    asrJuristic: value,
                  );
                  _markAsChanged();
                });
              }
            },
            activeColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildManualAdjustmentsSection() {
    return AppCard(
      title: 'تعديلات يدوية',
      subtitle: 'تعديل أوقات الصلاة بالدقائق حسب الحاجة',
      icon: Icons.tune,
      child: Column(
        children: [
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
    final prayerColor = AppTheme.getPrayerColor(name);
    
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppTheme.space1),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: prayerColor.withValues(alpha: 0.1),
              borderRadius: AppTheme.radiusMd.radius,
            ),
            child: Icon(
              AppTheme.getCategoryColor(name) as IconData? ?? Icons.mosque,
              color: prayerColor,
              size: AppTheme.iconSm,
            ),
          ),
          
          AppTheme.space3.w,
          
          Expanded(
            child: Text(name, style: AppTheme.bodyLarge),
          ),
          
          // أزرار التحكم
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedPress(
                onTap: () => _updateAdjustment(key, adjustment - 1),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: AppTheme.radiusMd.radius,
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Icon(
                    Icons.remove,
                    color: prayerColor,
                    size: AppTheme.iconSm,
                  ),
                ),
              ),
              
              Container(
                width: 60,
                margin: EdgeInsets.symmetric(horizontal: AppTheme.space2),
                child: Text(
                  adjustment > 0 ? '+$adjustment' : adjustment.toString(),
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: AppTheme.semiBold,
                    color: adjustment == 0 ? AppTheme.textSecondary : prayerColor,
                  ),
                ),
              ),
              
              AnimatedPress(
                onTap: () => _updateAdjustment(key, adjustment + 1),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.surface,
                    borderRadius: AppTheme.radiusMd.radius,
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Icon(
                    Icons.add,
                    color: prayerColor,
                    size: AppTheme.iconSm,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateAdjustment(String key, int value) {
    HapticFeedback.lightImpact();
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
      padding: AppTheme.space4.padding,
      child: AppButton.primary(
        text: 'حفظ الإعدادات',
        icon: Icons.save,
        onPressed: _isSaving || !_hasChanges ? null : _saveSettings,
        isLoading: _isSaving,
        isFullWidth: true,
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
              _saveSettings();
            },
          ),
        ],
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
      backgroundColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppTheme.radiusLg.radius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // العنوان
          Padding(
            padding: AppTheme.space4.padding,
            child: Row(
              children: [
                Container(
                  padding: AppTheme.space2.padding,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: AppTheme.radiusMd.radius,
                  ),
                  child: Icon(
                    Icons.calculate,
                    color: AppTheme.primary,
                    size: AppTheme.iconMd,
                  ),
                ),
                
                AppTheme.space3.w,
                
                Text(
                  'اختر طريقة الحساب',
                  style: AppTheme.titleLarge.copyWith(
                    fontWeight: AppTheme.semiBold,
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(color: AppTheme.divider),
          
          // قائمة الطرق
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: methods.map((method) {
                  return AnimatedPress(
                    onTap: () => onMethodSelected(method.$1),
                    child: RadioListTile<CalculationMethod>(
                      title: Text(
                        method.$2,
                        style: AppTheme.bodyLarge,
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
                          HapticFeedback.selectionClick();
                          onMethodSelected(value);
                        }
                      },
                      activeColor: AppTheme.primary,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          const Divider(color: AppTheme.divider),
          
          // زر الإلغاء
          Padding(
            padding: AppTheme.space3.padding,
            child: AppButton.text(
              text: 'إلغاء',
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}