// lib/features/prayer_times/screens/prayer_settings_screen.dart

import 'package:athkar_app/features/prayer_times/utils/prayer_extensions.dart';
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

class _PrayerSettingsScreenState extends State<PrayerSettingsScreen> with SingleTickerProviderStateMixin {
  late final LoggerService _logger;
  late final PrayerTimesService _prayerService;
  
  // إعدادات الحساب
  late PrayerCalculationSettings _calculationSettings;
  
  // حالة التحميل
  bool _isLoading = true;
  bool _isSaving = false;
  bool _hasChanges = false;
  
  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    _setupAnimations();
    _loadSettings();
  }

  void _initializeServices() {
    _logger = getIt<LoggerService>();
    _prayerService = getIt<PrayerTimesService>();
  }
  
  void _setupAnimations() {
    _animationController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: ThemeConstants.curveSmooth,
    );
    
    _animationController.forward();
  }

  void _loadSettings() {
    setState(() {
      _calculationSettings = _prayerService.calculationSettings;
      _isLoading = false;
    });
  }

  void _markAsChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
      // تشغيل اهتزاز خفيف عند التغيير
      HapticFeedback.lightImpact();
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    
    try {
      // حفظ إعدادات الحساب
      await _prayerService.updateCalculationSettings(_calculationSettings);
      
      _logger.logEvent('prayer_settings_updated', parameters: {
        'calculation_method': _calculationSettings.method.toString(),
        'asr_juristic': _calculationSettings.asrJuristic.toString(),
        'has_manual_adjustments': _calculationSettings.hasManualAdjustments,
      });
      
      if (!mounted) return;
      
      // تشغيل اهتزاز عند النجاح
      HapticFeedback.mediumImpact();
      
      // عرض رسالة نجاح
      context.showSuccessSnackBar('تم حفظ الإعدادات بنجاح');
      
      setState(() {
        _hasChanges = false;
      });
      
      // العودة للشاشة السابقة بعد تأخير بسيط
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } catch (e) {
      _logger.error(
        message: 'خطأ في حفظ الإعدادات',
        error: e,
      );
      
      if (!mounted) return;
      
      // تشغيل اهتزاز عند الخطأ
      HapticFeedback.heavyImpact();
      
      context.showErrorSnackBar('فشل حفظ الإعدادات');
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
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar(
        title: 'إعدادات مواقيت الصلاة',
        centerTitle: true,
        elevation: 0,
        actions: [
          if (_hasChanges && !_isSaving)
            IconButton(
              icon: const Icon(Icons.save_rounded),
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
    ? Center(child: AppLoading(
        type: LoadingType.circular,
        size: LoadingSize.medium,
        color: ThemeConstants.success,
        message: 'جاري تحميل الإعدادات...',
      ))
    : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // رأس الصفحة
                SliverToBoxAdapter(
                  child: _buildHeaderSection(),
                ),
                
                // إعدادات طريقة الحساب
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildCalculationSection(),
                  ),
                ),
                
                // إعدادات المذهب
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildJuristicSection(),
                  ),
                ),
                
                // تعديلات يدوية
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildManualAdjustmentsSection(),
                  ),
                ),
                
                // زر الحفظ
                SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildSaveButton(),
                  ),
                ),
                
                // مساحة في الأسفل
                const SliverToBoxAdapter(
                  child: SizedBox(height: ThemeConstants.space8),
                ),
              ],
            ),
    );
  }

  // قسم رأس الصفحة
  Widget _buildHeaderSection() {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            ThemeConstants.success.withOpacity(0.8),
            ThemeConstants.success,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        boxShadow: [
          BoxShadow(
            color: ThemeConstants.success.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: const Icon(
                  Icons.mosque_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: ThemeConstants.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إعدادات حساب مواقيت الصلاة',
                      style: context.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.bold,
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.space1),
                    Text(
                      'ضبط طريقة الحساب والتعديلات',
                      style: context.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: ThemeConstants.space4),
          
          // شريط تقدم لإظهار حالة الإعدادات
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'دقة الحساب',
                    style: context.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.medium,
                    ),
                  ),
                  Text(
                    _hasChanges ? 'تم التعديل' : 'مضبوط',
                    style: context.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ThemeConstants.space2),
              ClipRRect(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                child: LinearProgressIndicator(
                  value: _hasChanges ? 0.7 : 1.0,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _hasChanges ? Colors.amber : Colors.white,
                  ),
                  minHeight: 6,
                ),
              ),
            ],
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
      icon: Icons.save_rounded,
      accentColor: ThemeConstants.success,
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
      subtitle: 'اختر طريقة حساب مواقيت الصلاة',
      icon: Icons.calculate_rounded,
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
    
    final methodDescriptions = {
      CalculationMethod.muslimWorldLeague: 'الفجر 18°، العشاء 17°',
      CalculationMethod.egyptian: 'الفجر 19.5°، العشاء 17.5°',
      CalculationMethod.karachi: 'الفجر 18°، العشاء 18°',
      CalculationMethod.ummAlQura: 'الفجر 18.5°، العشاء 90 دقيقة بعد المغرب',
      CalculationMethod.dubai: 'الفجر 18.2°، العشاء 18.2°',
      CalculationMethod.qatar: 'الفجر 18°، العشاء 90 دقيقة بعد المغرب',
      CalculationMethod.kuwait: 'الفجر 18°، العشاء 17.5°',
      CalculationMethod.singapore: 'الفجر 20°، العشاء 18°',
      CalculationMethod.northAmerica: 'الفجر 15°، العشاء 15°',
      CalculationMethod.other: 'زوايا مخصصة',
    };
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _showCalculationMethodDialog();
        },
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'طريقة الحساب',
                          style: context.titleMedium?.semiBold,
                        ),
                        const SizedBox(height: ThemeConstants.space1),
                        Text(
                          methodNames[_calculationSettings.method] ?? '',
                          style: context.bodyLarge?.copyWith(
                            color: ThemeConstants.success,
                            fontWeight: ThemeConstants.medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(ThemeConstants.space2),
                    decoration: BoxDecoration(
                      color: ThemeConstants.success.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: ThemeConstants.success,
                      size: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: ThemeConstants.space3),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space3,
                  vertical: ThemeConstants.space2,
                ),
                decoration: BoxDecoration(
                  color: ThemeConstants.success.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  border: Border.all(
                    color: ThemeConstants.success.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: ThemeConstants.success.withOpacity(0.7),
                      size: 16,
                    ),
                    const SizedBox(width: ThemeConstants.space2),
                    Expanded(
                      child: Text(
                        methodDescriptions[_calculationSettings.method] ?? '',
                        style: context.bodySmall?.copyWith(
                          color: ThemeConstants.success.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
      subtitle: 'اختر المذهب الفقهي لحساب وقت العصر',
      icon: Icons.school_rounded,
      children: [
        _buildJuristicMethodCard(),
      ],
    );
  }

  Widget _buildJuristicMethodCard() {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المذهب المتبع لصلاة العصر',
            style: context.titleMedium?.semiBold,
          ),
          const SizedBox(height: ThemeConstants.space3),
          _buildJuristicOption(
            title: 'مذهب الجمهور',
            subtitle: 'الشافعي، المالكي، الحنبلي',
            description: 'عندما يكون ظل الشيء مثله',
            value: AsrJuristic.standard,
          ),
          const SizedBox(height: ThemeConstants.space3),
          _buildJuristicOption(
            title: 'المذهب الحنفي',
            subtitle: 'أبو حنيفة النعمان',
            description: 'عندما يكون ظل الشيء مثليه',
            value: AsrJuristic.hanafi,
          ),
        ],
      ),
    );
  }

  Widget _buildJuristicOption({
    required String title,
    required String subtitle,
    required String description,
    required AsrJuristic value,
  }) {
    final isSelected = _calculationSettings.asrJuristic == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _calculationSettings = _calculationSettings.copyWith(
            asrJuristic: value,
          );
          _markAsChanged();
        });
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.all(ThemeConstants.space3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          border: Border.all(
            color: isSelected 
                ? ThemeConstants.success 
                : context.dividerColor,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected 
              ? ThemeConstants.success.withOpacity(0.05)
              : context.cardColor,
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? ThemeConstants.success
                      : context.dividerColor,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ThemeConstants.success,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: ThemeConstants.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.titleSmall?.copyWith(
                      fontWeight: ThemeConstants.semiBold,
                      color: isSelected 
                          ? ThemeConstants.success
                          : context.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: ThemeConstants.space1),
                  Text(
                    subtitle,
                    style: context.bodySmall?.copyWith(
                      color: context.textSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: ThemeConstants.space2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ThemeConstants.space2,
                      vertical: ThemeConstants.space1,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? ThemeConstants.success.withOpacity(0.1)
                          : context.dividerColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                    ),
                    child: Text(
                      description,
                      style: context.bodySmall?.copyWith(
                        color: isSelected 
                            ? ThemeConstants.success
                            : context.textSecondaryColor,
                        fontWeight: isSelected
                            ? ThemeConstants.medium
                            : null,
                      ),
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

  Widget _buildManualAdjustmentsSection() {
    return SettingsSection(
      title: 'تعديلات يدوية',
      subtitle: 'تعديل أوقات الصلاة بالدقائق',
      icon: Icons.tune_rounded,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ضبط أوقات الصلاة',
                style: context.titleMedium?.semiBold,
              ),
              const SizedBox(height: ThemeConstants.space2),
              Text(
                'يمكنك تعديل أوقات الصلاة بإضافة أو طرح دقائق من كل وقت',
                style: context.bodyMedium?.copyWith(
                  color: context.textSecondaryColor,
                ),
              ),
              const SizedBox(height: ThemeConstants.space4),
            ],
          ),
        ),
        _buildAdjustmentTile('الفجر', 'fajr'),
        _buildAdjustmentTile('الشروق', 'sunrise'),
        _buildAdjustmentTile('الظهر', 'dhuhr'),
        _buildAdjustmentTile('العصر', 'asr'),
        _buildAdjustmentTile('المغرب', 'maghrib'),
        _buildAdjustmentTile('العشاء', 'isha'),
        const SizedBox(height: ThemeConstants.space2),
      ],
    );
  }

  Widget _buildAdjustmentTile(String name, String key) {
    final adjustment = _calculationSettings.manualAdjustments[key] ?? 0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space2,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: ThemeConstants.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Icon(
              _getPrayerIcon(key),
              color: ThemeConstants.success,
              size: 20,
            ),
          ),
          const SizedBox(width: ThemeConstants.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.titleSmall?.semiBold,
                ),
                if (adjustment != 0)
                  Text(
                    adjustment > 0 ? 'تقديم $adjustment دقيقة' : 'تأخير ${-adjustment} دقيقة',
                    style: context.bodySmall?.copyWith(
                      color: adjustment > 0
                          ? ThemeConstants.success
                          : ThemeConstants.warning,
                    ),
                  ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAdjustmentButton(
                icon: Icons.remove_circle_outline,
                onPressed: () {
                  _updateAdjustment(key, adjustment - 1);
                },
                color: adjustment <= -30 
                    ? context.dividerColor 
                    : ThemeConstants.error.withOpacity(0.7),
                isDisabled: adjustment <= -30,
              ),
              Container(
                width: 50,
                alignment: Alignment.center,
                child: Text(
                  adjustment > 0 ? '+$adjustment' : adjustment.toString(),
                  style: context.titleMedium?.copyWith(
                    fontWeight: ThemeConstants.semiBold,
                    color: adjustment != 0 
                        ? (adjustment > 0 ? ThemeConstants.success : ThemeConstants.error)
                        : context.textPrimaryColor,
                  ),
                ),
              ),
              _buildAdjustmentButton(
                icon: Icons.add_circle_outline,
                onPressed: () {
                  _updateAdjustment(key, adjustment + 1);
                },
                color: adjustment >= 30 
                    ? context.dividerColor 
                    : ThemeConstants.success,
                isDisabled: adjustment >= 30,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    bool isDisabled = false,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
      child: InkWell(
        onTap: isDisabled ? null : onPressed,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        child: Padding(
          padding: const EdgeInsets.all(ThemeConstants.space1),
          child: Icon(
            icon,
            color: isDisabled ? context.dividerColor : color,
            size: 26,
          ),
        ),
      ),
    );
  }

  IconData _getPrayerIcon(String prayerKey) {
    switch (prayerKey) {
      case 'fajr':
        return Icons.dark_mode;
      case 'sunrise':
        return Icons.wb_sunny_outlined;
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
    if (value < -30 || value > 30) return; // حد أقصى 30 دقيقة
    
    setState(() {
      final adjustments = Map<String, int>.from(
        _calculationSettings.manualAdjustments,
      );
      
      if (value == 0) {
        adjustments.remove(key); // إزالة القيمة إذا كانت 0
      } else {
        adjustments[key] = value;
      }
      
      _calculationSettings = _calculationSettings.copyWith(
        manualAdjustments: adjustments,
      );
      _markAsChanged();
    });
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: AnimatedContainer(
        duration: ThemeConstants.durationFast,
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          gradient: LinearGradient(
            colors: _hasChanges
                ? [ThemeConstants.success, ThemeConstants.success.darken(0.1)]
                : [Colors.grey.shade400, Colors.grey.shade500],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: _hasChanges
              ? [
                  BoxShadow(
                    color: ThemeConstants.success.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _isSaving || !_hasChanges ? null : _saveSettings,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            child: Center(
              child: _isSaving
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.save_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: ThemeConstants.space2),
                        Text(
                          'حفظ الإعدادات',
                          style: context.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: ThemeConstants.bold,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// قسم في شاشة الإعدادات
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
          padding: const EdgeInsets.fromLTRB(
            ThemeConstants.space4,
            ThemeConstants.space4,
            ThemeConstants.space4,
            ThemeConstants.space2,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space2),
                decoration: BoxDecoration(
                  color: ThemeConstants.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: ThemeConstants.success,
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
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            side: BorderSide(
              color: context.dividerColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          color: context.cardColor,
          child: Column(children: children),
        ),
      ],
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
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ThemeConstants.success.withOpacity(0.9),
                  ThemeConstants.success,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  ),
                  child: const Icon(
                    Icons.calculate_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: ThemeConstants.space3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اختر طريقة الحساب',
                        style: context.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: ThemeConstants.bold,
                        ),
                      ),
                      Text(
                        'اختر الطريقة المناسبة لمنطقتك',
                        style: context.bodySmall?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // القائمة
          Flexible(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: methods.length,
              itemBuilder: (context, index) {
                final method = methods[index];
                final isSelected = method.$1 == currentMethod;
                
                return Material(
                  color: isSelected 
                      ? ThemeConstants.success.withOpacity(0.1)
                      : Colors.transparent,
                  child: InkWell(
                    onTap: () => onMethodSelected(method.$1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.space4,
                        vertical: ThemeConstants.space3,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? ThemeConstants.success
                                    : context.dividerColor,
                                width: 2,
                              ),
                              color: isSelected
                                  ? ThemeConstants.success.withOpacity(0.1)
                                  : Colors.transparent,
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ThemeConstants.success,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: ThemeConstants.space3),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  method.$2,
                                  style: context.titleSmall?.copyWith(
                                    fontWeight: isSelected 
                                        ? ThemeConstants.semiBold
                                        : ThemeConstants.medium,
                                    color: isSelected
                                        ? ThemeConstants.success
                                        : context.textPrimaryColor,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  method.$3,
                                  style: context.bodySmall?.copyWith(
                                    color: isSelected
                                        ? ThemeConstants.success.withOpacity(0.8)
                                        : context.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: ThemeConstants.success,
                              size: 18,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Footer
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space3),
            decoration: BoxDecoration(
              color: context.cardColor,
              border: Border(
                top: BorderSide(
                  color: context.dividerColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(
                      color: ThemeConstants.success,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}