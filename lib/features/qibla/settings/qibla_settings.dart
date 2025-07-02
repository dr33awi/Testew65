// lib/features/qibla/settings/qibla_settings.dart - إعدادات محسنة بالنظام الموحد
import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';

/// إعدادات القبلة باستخدام النظام الموحد
class QiblaSettings {
  QiblaSettings._();

  // ✅ استخدام ThemeConstants للمفاتيح
  static const String _precisionModeKey = 'qibla_precision_mode';
  static const String _autoUpdateKey = 'qibla_auto_update';
  static const String _vibrateOnTargetKey = 'qibla_vibrate';
  static const String _soundEffectsKey = 'qibla_sound_effects';
  static const String _compassThemeKey = 'qibla_compass_theme';
  static const String _updateIntervalKey = 'qibla_update_interval';
  static const String _accuracyThresholdKey = 'qibla_accuracy_threshold';

  static StorageService get _storage => getIt<StorageService>();

  // ===== الإعدادات الأساسية =====

  /// وضع الدقة العالية (يستهلك بطارية أكثر)
  static bool get precisionMode => 
    _storage.getBool(_precisionModeKey) ?? false;
    
  static Future<void> setPrecisionMode(bool value) async {
    await _storage.setBool(_precisionModeKey, value);
  }

  /// التحديث التلقائي للموقع
  static bool get autoUpdate => 
    _storage.getBool(_autoUpdateKey) ?? true;
    
  static Future<void> setAutoUpdate(bool value) async {
    await _storage.setBool(_autoUpdateKey, value);
  }

  /// الاهتزاز عند العثور على القبلة
  static bool get vibrateOnTarget => 
    _storage.getBool(_vibrateOnTargetKey) ?? true;
    
  static Future<void> setVibrateOnTarget(bool value) async {
    await _storage.setBool(_vibrateOnTargetKey, value);
  }

  /// تأثيرات صوتية
  static bool get soundEffects => 
    _storage.getBool(_soundEffectsKey) ?? false;
    
  static Future<void> setSoundEffects(bool value) async {
    await _storage.setBool(_soundEffectsKey, value);
  }

  /// ثيم البوصلة
  static QiblaCompassTheme get compassTheme {
    final themeIndex = _storage.getInt(_compassThemeKey) ?? 0;
    return QiblaCompassTheme.values[themeIndex.clamp(0, QiblaCompassTheme.values.length - 1)];
  }
    
  static Future<void> setCompassTheme(QiblaCompassTheme theme) async {
    await _storage.setInt(_compassThemeKey, theme.index);
  }

  /// فترة التحديث (بالثواني)
  static int get updateInterval => 
    _storage.getInt(_updateIntervalKey) ?? 5;
    
  static Future<void> setUpdateInterval(int seconds) async {
    await _storage.setInt(_updateIntervalKey, seconds.clamp(1, 60));
  }

  /// عتبة الدقة المطلوبة
  static double get accuracyThreshold => 
    _storage.getDouble(_accuracyThresholdKey) ?? 0.7;
    
  static Future<void> setAccuracyThreshold(double threshold) async {
    await _storage.setDouble(_accuracyThresholdKey, threshold.clamp(0.1, 1.0));
  }

  // ===== دوال مساعدة =====

  /// الحصول على لون البوصلة حسب الثيم
  static Color getCompassColor() {
    switch (compassTheme) {
      case QiblaCompassTheme.classic:
        return AppColorSystem.getCategoryColor('qibla');
      case QiblaCompassTheme.modern:
        return AppColorSystem.primary;
      case QiblaCompassTheme.elegant:
        return AppColorSystem.tertiary;
      case QiblaCompassTheme.vibrant:
        return AppColorSystem.accent;
    }
  }

  /// الحصول على Duration للتحديث
  static Duration get updateDuration => Duration(seconds: updateInterval);

  /// إعادة تعيين جميع الإعدادات
  static Future<void> resetToDefaults() async {
    await _storage.remove(_precisionModeKey);
    await _storage.remove(_autoUpdateKey);
    await _storage.remove(_vibrateOnTargetKey);
    await _storage.remove(_soundEffectsKey);
    await _storage.remove(_compassThemeKey);
    await _storage.remove(_updateIntervalKey);
    await _storage.remove(_accuracyThresholdKey);
  }

  /// الحصول على ملخص الإعدادات
  static Map<String, dynamic> getSettingsSummary() {
    return {
      'precisionMode': precisionMode,
      'autoUpdate': autoUpdate,
      'vibrateOnTarget': vibrateOnTarget,
      'soundEffects': soundEffects,
      'compassTheme': compassTheme.name,
      'updateInterval': updateInterval,
      'accuracyThreshold': accuracyThreshold,
    };
  }
}

/// ثيمات البوصلة المختلفة
enum QiblaCompassTheme {
  classic,   // كلاسيكي - ألوان تقليدية
  modern,    // عصري - ألوان حديثة  
  elegant,   // أنيق - ألوان هادئة
  vibrant,   // نابض - ألوان زاهية
}

/// Extension لثيمات البوصلة
extension QiblaCompassThemeExtension on QiblaCompassTheme {
  String get name {
    switch (this) {
      case QiblaCompassTheme.classic:
        return 'كلاسيكي';
      case QiblaCompassTheme.modern:
        return 'عصري';
      case QiblaCompassTheme.elegant:
        return 'أنيق';
      case QiblaCompassTheme.vibrant:
        return 'نابض';
    }
  }

  String get description {
    switch (this) {
      case QiblaCompassTheme.classic:
        return 'ألوان تقليدية مريحة للعين';
      case QiblaCompassTheme.modern:
        return 'تصميم عصري بألوان متوازنة';
      case QiblaCompassTheme.elegant:
        return 'ألوان هادئة وأنيقة';
      case QiblaCompassTheme.vibrant:
        return 'ألوان زاهية ومشرقة';
    }
  }

  Color get primaryColor {
    switch (this) {
      case QiblaCompassTheme.classic:
        return AppColorSystem.getCategoryColor('qibla');
      case QiblaCompassTheme.modern:
        return AppColorSystem.primary;
      case QiblaCompassTheme.elegant:
        return AppColorSystem.tertiary;
      case QiblaCompassTheme.vibrant:
        return AppColorSystem.accent;
    }
  }

  IconData get icon {
    switch (this) {
      case QiblaCompassTheme.classic:
        return Icons.grain;
      case QiblaCompassTheme.modern:
        return Icons.auto_awesome;
      case QiblaCompassTheme.elegant:
        return Icons.stars;
      case QiblaCompassTheme.vibrant:
        return Icons.colorize;
    }
  }
}

/// شاشة إعدادات القبلة
class QiblaSettingsScreen extends StatefulWidget {
  const QiblaSettingsScreen({super.key});

  @override
  State<QiblaSettingsScreen> createState() => _QiblaSettingsScreenState();
}

class _QiblaSettingsScreenState extends State<QiblaSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorSystem.getBackground(context),
      appBar: CustomAppBar.simple(
        title: 'إعدادات القبلة',
      ),
      body: ListView(
        padding: const EdgeInsets.all(ThemeConstants.space4),
        children: [
          // قسم الدقة والأداء
          _buildSectionHeader('الدقة والأداء'),
          _buildPrecisionModeCard(),
          const SizedBox(height: ThemeConstants.space3),
          _buildAutoUpdateCard(),
          const SizedBox(height: ThemeConstants.space3),
          _buildAccuracyThresholdCard(),
          
          const SizedBox(height: ThemeConstants.space6),
          
          // قسم التفاعل
          _buildSectionHeader('التفاعل والتنبيهات'),
          _buildVibrateCard(),
          const SizedBox(height: ThemeConstants.space3),
          _buildSoundEffectsCard(),
          
          const SizedBox(height: ThemeConstants.space6),
          
          // قسم المظهر
          _buildSectionHeader('المظهر والثيم'),
          _buildCompassThemeCard(),
          
          const SizedBox(height: ThemeConstants.space6),
          
          // قسم متقدم
          _buildSectionHeader('إعدادات متقدمة'),
          _buildUpdateIntervalCard(),
          
          const SizedBox(height: ThemeConstants.space6),
          
          // أزرار الإجراءات
          _buildActionButtons(),
          
          const SizedBox(height: ThemeConstants.space8),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ThemeConstants.space3),
      child: Text(
        title,
        style: AppTextStyles.h5.copyWith(
          color: AppColorSystem.getCategoryColor('qibla'),
          fontWeight: ThemeConstants.bold,
        ),
      ),
    );
  }

  Widget _buildPrecisionModeCard() {
    return AppCard.custom(
      type: CardType.info,
      title: 'وضع الدقة العالية',
      subtitle: 'تحديث مستمر للحصول على أفضل دقة (يستهلك بطارية أكثر)',
      icon: Icons.high_quality,
      primaryColor: QiblaSettings.precisionMode ? AppColorSystem.success : AppColorSystem.info,
      child: Switch.adaptive(
        value: QiblaSettings.precisionMode,
        onChanged: (value) async {
          await QiblaSettings.setPrecisionMode(value);
          setState(() {});
          
          if (mounted) {
            context.showSuccessSnackBar(
              value ? 'تم تفعيل الدقة العالية' : 'تم إيقاف الدقة العالية',
            );
          }
        },
        activeTrackColor: AppColorSystem.success,
      ),
    );
  }

  Widget _buildAutoUpdateCard() {
    return AppCard.custom(
      type: CardType.info,
      title: 'التحديث التلقائي',
      subtitle: 'تحديث اتجاه القبلة تلقائياً عند تغيير الموقع',
      icon: Icons.update,
      primaryColor: QiblaSettings.autoUpdate ? AppColorSystem.success : AppColorSystem.warning,
      child: Switch.adaptive(
        value: QiblaSettings.autoUpdate,
        onChanged: (value) async {
          await QiblaSettings.setAutoUpdate(value);
          setState(() {});
        },
        activeTrackColor: AppColorSystem.success,
      ),
    );
  }

  Widget _buildVibrateCard() {
    return AppCard.custom(
      type: CardType.info,
      title: 'اهتزاز التأكيد',
      subtitle: 'اهتزاز خفيف عند العثور على اتجاه القبلة',
      icon: Icons.vibration,
      primaryColor: QiblaSettings.vibrateOnTarget ? AppColorSystem.success : AppColorSystem.info,
      child: Switch.adaptive(
        value: QiblaSettings.vibrateOnTarget,
        onChanged: (value) async {
          await QiblaSettings.setVibrateOnTarget(value);
          setState(() {});
        },
        activeTrackColor: AppColorSystem.success,
      ),
    );
  }

  Widget _buildSoundEffectsCard() {
    return AppCard.custom(
      type: CardType.info,
      title: 'تأثيرات صوتية',
      subtitle: 'صوت تأكيد عند العثور على القبلة',
      icon: Icons.volume_up,
      primaryColor: QiblaSettings.soundEffects ? AppColorSystem.success : AppColorSystem.info,
      child: Switch.adaptive(
        value: QiblaSettings.soundEffects,
        onChanged: (value) async {
          await QiblaSettings.setSoundEffects(value);
          setState(() {});
        },
        activeTrackColor: AppColorSystem.success,
      ),
    );
  }

  Widget _buildCompassThemeCard() {
    return AppCard.custom(
      type: CardType.info,
      title: 'ثيم البوصلة',
      subtitle: QiblaSettings.compassTheme.description,
      icon: QiblaSettings.compassTheme.icon,
      primaryColor: QiblaSettings.compassTheme.primaryColor,
      child: Column(
        children: QiblaCompassTheme.values.map((theme) {
          return RadioListTile<QiblaCompassTheme>(
            title: Text(theme.name),
            subtitle: Text(theme.description),
            value: theme,
            groupValue: QiblaSettings.compassTheme,
            activeColor: theme.primaryColor,
            onChanged: (value) async {
              if (value != null) {
                await QiblaSettings.setCompassTheme(value);
                setState(() {});
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAccuracyThresholdCard() {
    return AppCard.custom(
      type: CardType.info,
      title: 'عتبة الدقة المطلوبة',
      subtitle: 'الحد الأدنى لدقة البوصلة: ${(QiblaSettings.accuracyThreshold * 100).toInt()}%',
      icon: Icons.tune,
      primaryColor: AppColorSystem.info,
      child: Column(
        children: [
          Slider(
            value: QiblaSettings.accuracyThreshold,
            min: 0.1,
            max: 1.0,
            divisions: 9,
            label: '${(QiblaSettings.accuracyThreshold * 100).toInt()}%',
            activeColor: AppColorSystem.getCategoryColor('qibla'),
            onChanged: (value) async {
              await QiblaSettings.setAccuracyThreshold(value);
              setState(() {});
            },
          ),
          Text(
            'دقة أقل = استجابة أسرع، دقة أعلى = استجابة أكثر ثباتاً',
            style: AppTextStyles.caption.copyWith(
              color: AppColorSystem.getTextSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateIntervalCard() {
    return AppCard.custom(
      type: CardType.info,
      title: 'فترة التحديث',
      subtitle: 'كل ${QiblaSettings.updateInterval} ثانية',
      icon: Icons.timer,
      primaryColor: AppColorSystem.tertiary,
      child: Column(
        children: [
          Slider(
            value: QiblaSettings.updateInterval.toDouble(),
            min: 1,
            max: 60,
            divisions: 59,
            label: '${QiblaSettings.updateInterval}ث',
            activeColor: AppColorSystem.tertiary,
            onChanged: (value) async {
              await QiblaSettings.setUpdateInterval(value.round());
              setState(() {});
            },
          ),
          Text(
            'فترة أقل = تحديث أسرع (يستهلك بطارية أكثر)',
            style: AppTextStyles.caption.copyWith(
              color: AppColorSystem.getTextSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // زر إعادة تعيين
        AppButton.outline(
          text: 'إعادة تعيين الإعدادات',
          onPressed: _resetSettings,
          color: AppColorSystem.warning,
          isFullWidth: true,
        ),
        
        const SizedBox(height: ThemeConstants.space3),
        
        // زر حفظ وإغلاق
        AppButton.primary(
          text: 'حفظ الإعدادات',
          onPressed: () {
            context.showSuccessSnackBar('تم حفظ الإعدادات بنجاح');
            Navigator.of(context).pop();
          },
          isFullWidth: true,
        ),
      ],
    );
  }

  Future<void> _resetSettings() async {
    final confirmed = await AppInfoDialog.showConfirmation(
      context: context,
      title: 'إعادة تعيين الإعدادات',
      content: 'هل أنت متأكد من إعادة تعيين جميع إعدادات القبلة إلى القيم الافتراضية؟',
      confirmText: 'إعادة تعيين',
      isDestructive: true,
    );

    if (confirmed == true) {
      await QiblaSettings.resetToDefaults();
      setState(() {});
      
      if (mounted) {
        context.showSuccessSnackBar('تم إعادة تعيين الإعدادات بنجاح');
      }
    }
  }
}