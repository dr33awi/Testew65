// lib/features/prayer_times/screens/prayer_settings_screen.dart

import 'package:flutter/material.dart';
import '../../../app/themes/index.dart';
import '../../../app/di/service_locator.dart';
import '../models/prayer_time_model.dart';
import '../services/prayer_times_service.dart';

class PrayerSettingsScreen extends StatefulWidget {
  const PrayerSettingsScreen({super.key});

  @override
  State<PrayerSettingsScreen> createState() => _PrayerSettingsScreenState();
}

class _PrayerSettingsScreenState extends State<PrayerSettingsScreen> {
  late final PrayerTimesService _prayerService;
  late PrayerCalculationSettings _settings;
  bool _isLoading = true;
  bool _isSaving = false;

  // Controllers للتعديلات اليدوية
  final Map<String, TextEditingController> _adjustmentControllers = {};

  @override
  void initState() {
    super.initState();
    _prayerService = getService<PrayerTimesService>();
    _loadCurrentSettings();
  }

  @override
  void dispose() {
    for (final controller in _adjustmentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadCurrentSettings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _settings = _prayerService.calculationSettings;
      _initializeControllers();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        context.showErrorMessage('فشل تحميل الإعدادات');
      }
    }
  }

  void _initializeControllers() {
    final prayers = ['fajr', 'dhuhr', 'asr', 'maghrib', 'isha'];
    for (final prayer in prayers) {
      final adjustment = _settings.manualAdjustments[prayer] ?? 0;
      _adjustmentControllers[prayer] = TextEditingController(
        text: adjustment.toString(),
      );
    }
  }

  Future<void> _saveSettings() async {
    setState(() {
      _isSaving = true;
    });

    try {
      // تحديث التعديلات اليدوية
      final adjustments = <String, int>{};
      for (final entry in _adjustmentControllers.entries) {
        final value = int.tryParse(entry.value.text) ?? 0;
        adjustments[entry.key] = value;
      }

      final updatedSettings = _settings.copyWith(
        manualAdjustments: adjustments,
      );

      await _prayerService.updateCalculationSettings(updatedSettings);
      
      if (mounted) {
        context.showSuccessMessage('تم حفظ الإعدادات بنجاح');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        context.showErrorMessage('فشل حفظ الإعدادات');
      }
    } finally {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(
        title: 'إعدادات الحساب',
        actions: [
          if (!_isLoading)
            IconButton(
              onPressed: _isSaving ? null : _saveSettings,
              icon: _isSaving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.primaryColor,
                      ),
                    )
                  : const Icon(Icons.save),
              tooltip: 'حفظ الإعدادات',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: IslamicLoading(message: 'جارٍ تحميل الإعدادات...'))
          : _buildSettingsContent(),
    );
  }

  Widget _buildSettingsContent() {
    return ListView(
      padding: EdgeInsets.all(context.mediumPadding),
      children: [
        // طريقة الحساب
        _buildCalculationMethodSection(),
        
        Spaces.large,
        
        // المذهب الفقهي
        _buildJuristicSection(),
        
        Spaces.large,
        
        // زوايا الحساب (للطريقة المخصصة)
        if (_settings.method == CalculationMethod.other)
          _buildAnglesSection(),
        
        Spaces.large,
        
        // التعديلات اليدوية
        _buildManualAdjustmentsSection(),
        
        Spaces.large,
        
        // إعدادات إضافية
        _buildAdditionalSettings(),
        
        // مساحة إضافية
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildCalculationMethodSection() {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.calculate,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'طريقة الحساب',
                style: context.titleStyle,
              ),
            ],
          ),
          
          Spaces.medium,
          
          Text(
            'اختر طريقة حساب مواقيت الصلاة المناسبة لمنطقتك',
            style: context.bodyStyle.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
          
          Spaces.medium,
          
          ...CalculationMethod.values.map((method) {
            return RadioListTile<CalculationMethod>(
              title: Text(_getMethodName(method)),
              subtitle: Text(_getMethodDescription(method)),
              value: method,
              groupValue: _settings.method,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _settings = _settings.copyWith(method: value);
                  });
                }
              },
              contentPadding: EdgeInsets.zero,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildJuristicSection() {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.school,
                color: context.secondaryColor,
              ),
              Spaces.smallH,
              Text(
                'المذهب الفقهي',
                style: context.titleStyle,
              ),
            ],
          ),
          
          Spaces.medium,
          
          Text(
            'اختر المذهب الفقهي لحساب وقت صلاة العصر',
            style: context.bodyStyle.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
          
          Spaces.medium,
          
          RadioListTile<AsrJuristic>(
            title: const Text('الجمهور (الشافعي، المالكي، الحنبلي)'),
            subtitle: const Text('عندما يصبح ظل الشيء مثله'),
            value: AsrJuristic.standard,
            groupValue: _settings.asrJuristic,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _settings = _settings.copyWith(asrJuristic: value);
                });
              }
            },
            contentPadding: EdgeInsets.zero,
          ),
          
          RadioListTile<AsrJuristic>(
            title: const Text('الحنفي'),
            subtitle: const Text('عندما يصبح ظل الشيء ضعفه'),
            value: AsrJuristic.hanafi,
            groupValue: _settings.asrJuristic,
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _settings = _settings.copyWith(asrJuristic: value);
                });
              }
            },
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildAnglesSection() {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.architecture,
                color: context.infoColor,
              ),
              Spaces.smallH,
              Text(
                'زوايا الحساب المخصصة',
                style: context.titleStyle,
              ),
            ],
          ),
          
          Spaces.medium,
          
          Row(
            children: [
              Expanded(
                child: _buildAngleField(
                  'زاوية الفجر',
                  _settings.fajrAngle,
                  (value) => _settings = _settings.copyWith(fajrAngle: value),
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: _buildAngleField(
                  'زاوية العشاء',
                  _settings.ishaAngle,
                  (value) => _settings = _settings.copyWith(ishaAngle: value),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAngleField(String label, int currentValue, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.bodyStyle.medium,
        ),
        Spaces.small,
        IslamicInput(
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: currentValue.toString()),
          onChanged: (value) {
            final intValue = int.tryParse(value);
            if (intValue != null && intValue >= 10 && intValue <= 25) {
              onChanged(intValue);
            }
          },
          suffixIcon: Icons.straighten,
        ),
      ],
    );
  }

  Widget _buildManualAdjustmentsSection() {
    final prayers = [
      {'key': 'fajr', 'name': 'الفجر'},
      {'key': 'dhuhr', 'name': 'الظهر'},
      {'key': 'asr', 'name': 'العصر'},
      {'key': 'maghrib', 'name': 'المغرب'},
      {'key': 'isha', 'name': 'العشاء'},
    ];

    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tune,
                color: context.warningColor,
              ),
              Spaces.smallH,
              Text(
                'التعديلات اليدوية',
                style: context.titleStyle,
              ),
            ],
          ),
          
          Spaces.medium,
          
          Text(
            'اضبط المواقيت بالدقائق (+ للتأخير، - للتقديم)',
            style: context.bodyStyle.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
          
          Spaces.medium,
          
          ...prayers.map((prayer) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      prayer['name']!,
                      style: context.bodyStyle.medium,
                    ),
                  ),
                  
                  Spaces.mediumH,
                  
                  Expanded(
                    child: IslamicInput(
                      controller: _adjustmentControllers[prayer['key']]!,
                      keyboardType: TextInputType.number,
                      hint: '0',
                      suffixIcon: Icons.access_time,
                    ),
                  ),
                  
                  Spaces.smallH,
                  
                  Text(
                    'دقيقة',
                    style: context.captionStyle,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAdditionalSettings() {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'إعدادات إضافية',
                style: context.titleStyle,
              ),
            ],
          ),
          
          Spaces.medium,
          
          IslamicSwitch(
            title: 'تطبيق التوقيت الصيفي',
            subtitle: 'تعديل تلقائي للتوقيت الصيفي',
            value: _settings.summerTimeAdjustment,
            onChanged: (value) {
              setState(() {
                _settings = _settings.copyWith(summerTimeAdjustment: value);
              });
            },
          ),
        ],
      ),
    );
  }

  String _getMethodName(CalculationMethod method) {
    switch (method) {
      case CalculationMethod.muslimWorldLeague:
        return 'رابطة العالم الإسلامي';
      case CalculationMethod.egyptian:
        return 'الهيئة المصرية العامة للمساحة';
      case CalculationMethod.karachi:
        return 'جامعة العلوم الإسلامية، كراتشي';
      case CalculationMethod.ummAlQura:
        return 'أم القرى';
      case CalculationMethod.dubai:
        return 'دبي';
      case CalculationMethod.qatar:
        return 'قطر';
      case CalculationMethod.kuwait:
        return 'الكويت';
      case CalculationMethod.singapore:
        return 'سنغافورة';
      case CalculationMethod.northAmerica:
        return 'الجمعية الإسلامية لأمريكا الشمالية';
      case CalculationMethod.other:
        return 'مخصص';
    }
  }

  String _getMethodDescription(CalculationMethod method) {
    switch (method) {
      case CalculationMethod.muslimWorldLeague:
        return 'الطريقة الأكثر انتشاراً عالمياً';
      case CalculationMethod.egyptian:
        return 'مناسبة لمصر والدول المجاورة';
      case CalculationMethod.karachi:
        return 'مناسبة لباكستان وجنوب آسيا';
      case CalculationMethod.ummAlQura:
        return 'المعتمدة في السعودية';
      case CalculationMethod.dubai:
        return 'المعتمدة في الإمارات';
      case CalculationMethod.qatar:
        return 'المعتمدة في قطر';
      case CalculationMethod.kuwait:
        return 'المعتمدة في الكويت';
      case CalculationMethod.singapore:
        return 'مناسبة لجنوب شرق آسيا';
      case CalculationMethod.northAmerica:
        return 'مناسبة لأمريكا الشمالية';
      case CalculationMethod.other:
        return 'تخصيص الزوايا يدوياً';
    }
  }
}