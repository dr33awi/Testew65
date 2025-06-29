// lib/features/prayer_times/screens/prayer_settings_screen.dart - محدث بالثيم الإسلامي الموحد

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد الإسلامي - محدث
import 'package:athkar_app/app/themes/index.dart';

import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';

// نماذج البيانات الأساسية
enum CalculationMethod {
  muslimWorldLeague,
  egyptian,
  karachi,
  ummAlQura,
  dubai,
  qatar,
  kuwait,
  singapore,
  northAmerica,
  other,
}

enum AsrJuristic {
  standard,
  hanafi,
}

class PrayerCalculationSettings {
  final CalculationMethod method;
  final AsrJuristic asrJuristic;
  final Map<String, int> manualAdjustments;

  PrayerCalculationSettings({
    required this.method,
    required this.asrJuristic,
    required this.manualAdjustments,
  });

  PrayerCalculationSettings copyWith({
    CalculationMethod? method,
    AsrJuristic? asrJuristic,
    Map<String, int>? manualAdjustments,
  }) {
    return PrayerCalculationSettings(
      method: method ?? this.method,
      asrJuristic: asrJuristic ?? this.asrJuristic,
      manualAdjustments: manualAdjustments ?? this.manualAdjustments,
    );
  }
}

class PrayerSettingsScreen extends StatefulWidget {
  const PrayerSettingsScreen({super.key});

  @override
  State<PrayerSettingsScreen> createState() => _PrayerSettingsScreenState();
}

class _PrayerSettingsScreenState extends State<PrayerSettingsScreen>
    with TickerProviderStateMixin {
  late final LoggerService _logger;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  // إعدادات الحساب
  late PrayerCalculationSettings _calculationSettings;
  
  // حالة التحميل
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
      _calculationSettings = PrayerCalculationSettings(
        method: CalculationMethod.ummAlQura,
        asrJuristic: AsrJuristic.standard,
        manualAdjustments: {
          'fajr': 0,
          'sunrise': 0,
          'dhuhr': 0,
          'asr': 0,
          'maghrib': 0,
          'isha': 0,
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
      
      _logger.logEvent('prayer_settings_updated', parameters: {
        'calculation_method': _calculationSettings.method.toString(),
        'asr_juristic': _calculationSettings.asrJuristic.toString(),
      });
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم حفظ الإعدادات بنجاح'),
          backgroundColor: AppTheme.success,
        ),
      );
      
      setState(() {
        _hasChanges = false;
      });
      
      Navigator.pop(context);
    } catch (e) {
      _logger.error(
        message: 'خطأ في حفظ الإعدادات',
        error: e,
      );
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل حفظ الإعدادات'),
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
        title: 'إعدادات مواقيت الصلاة',
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
      ),
    );
  }

  Widget _buildCalculationSection() {
    return Padding(
      padding: AppTheme.space4.paddingH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTheme.space4.h,
          
          // عنوان القسم
          Text(
            'طريقة الحساب',
            style: AppTheme.headlineMedium.copyWith(
              fontWeight: AppTheme.bold,
            ),
          ),
          
          AppTheme.space3.h,
          
          // بطاقة طريقة الحساب
          SettingCard(
            title: 'طريقة الحساب',
            subtitle: _getMethodName(_calculationSettings.method),
            icon: Icons.calculate,
            color: AppTheme.primary,
            onTap: _showCalculationMethodDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildJuristicSection() {
    return Padding(
      padding: AppTheme.space4.paddingH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTheme.space6.h,
          
          // عنوان القسم
          Text(
            'المذهب الفقهي',
            style: AppTheme.headlineMedium.copyWith(
              fontWeight: AppTheme.bold,
            ),
          ),
          
          AppTheme.space3.h,
          
          // الجمهور
          AppCard(
            child: Row(
              children: [
                Radio<AsrJuristic>(
                  value: AsrJuristic.standard,
                  groupValue: _calculationSettings.asrJuristic,
                  onChanged: (AsrJuristic? value) {
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
                
                AppTheme.space2.w,
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الجمهور',
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: AppTheme.semiBold,
                        ),
                      ),
                      AppTheme.space1.h,
                      Text(
                        'الشافعي، المالكي، الحنبلي',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          AppTheme.space3.h,
          
          // الحنفي
          AppCard(
            child: Row(
              children: [
                Radio<AsrJuristic>(
                  value: AsrJuristic.hanafi,
                  groupValue: _calculationSettings.asrJuristic,
                  onChanged: (AsrJuristic? value) {
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
                  activeColor: AppTheme.secondary,
                ),
                
                AppTheme.space2.w,
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'الحنفي',
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: AppTheme.semiBold,
                        ),
                      ),
                      AppTheme.space1.h,
                      Text(
                        'المذهب الحنفي',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManualAdjustmentsSection() {
    final prayers = [
      ('الفجر', 'fajr'),
      ('الشروق', 'sunrise'),
      ('الظهر', 'dhuhr'),
      ('العصر', 'asr'),
      ('المغرب', 'maghrib'),
      ('العشاء', 'isha'),
    ];

    return Padding(
      padding: AppTheme.space4.paddingH,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTheme.space6.h,
          
          // عنوان القسم
          Text(
            'تعديلات يدوية (بالدقائق)',
            style: AppTheme.headlineMedium.copyWith(
              fontWeight: AppTheme.bold,
            ),
          ),
          
          AppTheme.space3.h,
          
          ...prayers.map((prayer) => _buildAdjustmentCard(prayer.$1, prayer.$2)),
        ],
      ),
    );
  }

  Widget _buildAdjustmentCard(String name, String key) {
    final adjustment = _calculationSettings.manualAdjustments[key] ?? 0;
    final prayerColor = AppTheme.getPrayerColor(name);
    
    return Padding(
      padding: EdgeInsets.only(bottom: AppTheme.space3),
      child: AppCard(
        child: Row(
          children: [
            // أيقونة الصلاة
            Icon(
              AppTheme.getPrayerIcon(name),
              color: prayerColor,
              size: AppTheme.iconMd,
            ),
            
            AppTheme.space3.w,
            
            // اسم الصلاة
            Expanded(
              child: Text(
                name,
                style: AppTheme.bodyLarge.copyWith(
                  fontWeight: AppTheme.semiBold,
                ),
              ),
            ),
            
            // أزرار التحكم
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // زر النقص
                IconButton(
                  onPressed: () => _updateAdjustment(key, adjustment - 1),
                  icon: Icon(
                    Icons.remove_circle_outline,
                    color: AppTheme.error,
                    size: AppTheme.iconMd,
                  ),
                  tooltip: 'تقليل دقيقة',
                ),
                
                // العدد الحالي
                Container(
                  width: AppTheme.iconXl + AppTheme.space2,
                  child: Text(
                    adjustment > 0 ? '+$adjustment' : adjustment.toString(),
                    textAlign: TextAlign.center,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: AppTheme.semiBold,
                      color: adjustment == 0 ? AppTheme.textSecondary : prayerColor,
                      fontFamily: AppTheme.numbersFont,
                    ),
                  ),
                ),
                
                // زر الزيادة
                IconButton(
                  onPressed: () => _updateAdjustment(key, adjustment + 1),
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: AppTheme.success,
                    size: AppTheme.iconMd,
                  ),
                  tooltip: 'زيادة دقيقة',
                ),
              ],
            ),
          ],
        ),
      ),
    );
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

  String _getMethodName(CalculationMethod method) {
    const methodNames = {
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
    
    return methodNames[method] ?? 'غير محدد';
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
              _saveSettings();
            },
          ),
        ],
      ),
    );
  }
}

/// مربع حوار اختيار طريقة الحساب - محدث بالنظام الموحد
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
          AppCard.basic(
            title: 'اختر طريقة الحساب',
            icon: Icons.calculate,
            color: AppTheme.primary,
          ),
          
          // قائمة الطرق
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                children: methods.map((method) {
                  final isSelected = method.$1 == currentMethod;
                  
                  return AppCard(
                    onTap: () => onMethodSelected(method.$1),
                    color: isSelected 
                        ? AppTheme.primary.withValues(alpha: 0.1)
                        : null,
                    child: Row(
                      children: [
                        Radio<CalculationMethod>(
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
                        
                        AppTheme.space2.w,
                        
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                method.$2,
                                style: AppTheme.bodyLarge.copyWith(
                                  fontWeight: isSelected 
                                      ? AppTheme.semiBold 
                                      : AppTheme.medium,
                                  color: isSelected ? AppTheme.primary : null,
                                ),
                              ),
                              AppTheme.space1.h,
                              Text(
                                method.$3,
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // زر الإلغاء
          Padding(
            padding: AppTheme.space3.padding,
            child: AppButton.outline(
              text: 'إلغاء',
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }
}