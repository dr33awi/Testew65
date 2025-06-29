// lib/app/themes/widgets/specialized/settings_cards.dart
// كروت الإعدادات والتفضيلات - مفصولة ومتخصصة
// ✅ استيراد النظام الموحد الإسلامي - الوحيد المسموح
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ==================== كروت الإعدادات المتخصصة ====================

/// بطاقة إعداد مع مفتاح تشغيل
class SettingToggleCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? color;
  final bool isEnabled;

  const SettingToggleCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.value,
    this.onChanged,
    this.color,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final settingColor = color ?? AppTheme.primary;
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.space4,
        vertical: AppTheme.space2,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusMd.radius,
        child: InkWell(
          onTap: isEnabled && onChanged != null 
              ? () => onChanged!(!value) 
              : null,
          borderRadius: AppTheme.radiusMd.radius,
          child: Container(
            padding: AppTheme.space4.padding,
            decoration: BoxDecoration(
              color: value 
                  ? settingColor.withValues(alpha: 0.1)
                  : AppTheme.card,
              borderRadius: AppTheme.radiusMd.radius,
              border: Border.all(
                color: value 
                    ? settingColor.withValues(alpha: 0.3)
                    : AppTheme.divider.withValues(alpha: 0.3),
                width: value ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // الأيقونة
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: value 
                        ? settingColor
                        : settingColor.withValues(alpha: 0.1),
                    borderRadius: AppTheme.radiusMd.radius,
                  ),
                  child: Icon(
                    icon,
                    color: value 
                        ? Colors.white
                        : settingColor,
                    size: AppTheme.iconMd,
                  ),
                ),
                
                AppTheme.space3.w,
                
                // النص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: AppTheme.medium,
                          color: value ? settingColor : null,
                        ),
                      ),
                      if (subtitle != null) ...[
                        AppTheme.space1.h,
                        Text(
                          subtitle!,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // المفتاح
                Switch(
                  value: value,
                  onChanged: isEnabled ? onChanged : null,
                  activeColor: settingColor,
                  inactiveThumbColor: AppTheme.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// بطاقة إعداد للانتقال
class SettingNavigationCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? color;
  final Widget? trailing;
  final bool showBadge;
  final String? badgeText;

  const SettingNavigationCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
    this.color,
    this.trailing,
    this.showBadge = false,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final settingColor = color ?? AppTheme.primary;
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.space4,
        vertical: AppTheme.space2,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusMd.radius,
        child: InkWell(
          onTap: () {
            if (onTap != null) {
              HapticFeedback.lightImpact();
              onTap!();
            }
          },
          borderRadius: AppTheme.radiusMd.radius,
          child: Container(
            padding: AppTheme.space4.padding,
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: AppTheme.radiusMd.radius,
              border: Border.all(
                color: AppTheme.divider.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // الأيقونة
                Stack(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: settingColor.withValues(alpha: 0.1),
                        borderRadius: AppTheme.radiusMd.radius,
                      ),
                      child: Icon(
                        icon,
                        color: settingColor,
                        size: AppTheme.iconMd,
                      ),
                    ),
                    
                    // شارة التنبيه
                    if (showBadge)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.error,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            badgeText ?? '',
                            style: AppTheme.caption.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: AppTheme.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                
                AppTheme.space3.w,
                
                // النص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: AppTheme.medium,
                        ),
                      ),
                      if (subtitle != null) ...[
                        AppTheme.space1.h,
                        Text(
                          subtitle!,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // العنصر الجانبي
                if (trailing != null) ...[
                  AppTheme.space2.w,
                  trailing!,
                ] else ...[
                  AppTheme.space2.w,
                  const Icon(
                    Icons.chevron_right,
                    color: AppTheme.textTertiary,
                    size: AppTheme.iconMd,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// بطاقة إعداد مع قائمة اختيار
class SettingSelectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final String currentValue;
  final List<SettingOption> options;
  final ValueChanged<String>? onChanged;
  final Color? color;

  const SettingSelectionCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.currentValue,
    required this.options,
    this.onChanged,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final settingColor = color ?? AppTheme.primary;
    final currentOption = options.firstWhere(
      (option) => option.value == currentValue,
      orElse: () => options.first,
    );
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.space4,
        vertical: AppTheme.space2,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusMd.radius,
        child: InkWell(
          onTap: () => _showSelectionDialog(context, settingColor),
          borderRadius: AppTheme.radiusMd.radius,
          child: Container(
            padding: AppTheme.space4.padding,
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: AppTheme.radiusMd.radius,
              border: Border.all(
                color: AppTheme.divider.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // الأيقونة
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: settingColor.withValues(alpha: 0.1),
                    borderRadius: AppTheme.radiusMd.radius,
                  ),
                  child: Icon(
                    icon,
                    color: settingColor,
                    size: AppTheme.iconMd,
                  ),
                ),
                
                AppTheme.space3.w,
                
                // النص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: AppTheme.medium,
                        ),
                      ),
                      if (subtitle != null) ...[
                        AppTheme.space1.h,
                        Text(
                          subtitle!,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // القيمة الحالية
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.space3,
                    vertical: AppTheme.space1,
                  ),
                  decoration: BoxDecoration(
                    color: settingColor.withValues(alpha: 0.1),
                    borderRadius: AppTheme.radiusFull.radius,
                  ),
                  child: Text(
                    currentOption.label,
                    style: AppTheme.bodySmall.copyWith(
                      color: settingColor,
                      fontWeight: AppTheme.medium,
                    ),
                  ),
                ),
                
                AppTheme.space2.w,
                
                Icon(
                  Icons.expand_more,
                  color: AppTheme.textTertiary,
                  size: AppTheme.iconSm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSelectionDialog(BuildContext context, Color color) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) => 
            ListTile(
              leading: Icon(
                option.icon ?? Icons.check_circle_outline,
                color: option.value == currentValue ? color : AppTheme.textTertiary,
              ),
              title: Text(option.label),
              subtitle: option.description != null ? Text(option.description!) : null,
              selected: option.value == currentValue,
              selectedTileColor: color.withValues(alpha: 0.1),
              onTap: () {
                Navigator.pop(context);
                if (onChanged != null) {
                  onChanged!(option.value);
                }
              },
            ),
          ).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }
}

/// بطاقة إعداد مع شريط تمرير
class SettingSliderCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double>? onChanged;
  final Color? color;
  final String Function(double)? valueFormatter;

  const SettingSliderCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    this.onChanged,
    this.color,
    this.valueFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final settingColor = color ?? AppTheme.primary;
    
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.space4,
        vertical: AppTheme.space2,
      ),
      child: Container(
        padding: AppTheme.space4.padding,
        decoration: BoxDecoration(
          color: AppTheme.card,
          borderRadius: AppTheme.radiusMd.radius,
          border: Border.all(
            color: AppTheme.divider.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            // العنوان والأيقونة
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: settingColor.withValues(alpha: 0.1),
                    borderRadius: AppTheme.radiusMd.radius,
                  ),
                  child: Icon(
                    icon,
                    color: settingColor,
                    size: AppTheme.iconMd,
                  ),
                ),
                
                AppTheme.space3.w,
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: AppTheme.medium,
                        ),
                      ),
                      if (subtitle != null) ...[
                        AppTheme.space1.h,
                        Text(
                          subtitle!,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // القيمة الحالية
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.space3,
                    vertical: AppTheme.space1,
                  ),
                  decoration: BoxDecoration(
                    color: settingColor.withValues(alpha: 0.1),
                    borderRadius: AppTheme.radiusFull.radius,
                  ),
                  child: Text(
                    valueFormatter?.call(value) ?? value.toStringAsFixed(1),
                    style: AppTheme.bodySmall.copyWith(
                      color: settingColor,
                      fontWeight: AppTheme.bold,
                      fontFamily: AppTheme.numbersFont,
                    ),
                  ),
                ),
              ],
            ),
            
            AppTheme.space3.h,
            
            // شريط التمرير
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: settingColor,
                inactiveTrackColor: settingColor.withValues(alpha: 0.2),
                thumbColor: settingColor,
                overlayColor: settingColor.withValues(alpha: 0.2),
                valueIndicatorColor: settingColor,
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                divisions: divisions,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// بطاقة معلومات التطبيق
class AppInfoCard extends StatelessWidget {
  final String appName;
  final String version;
  final String? buildNumber;
  final IconData? icon;
  final VoidCallback? onTap;

  const AppInfoCard({
    super.key,
    required this.appName,
    required this.version,
    this.buildNumber,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.space4,
        vertical: AppTheme.space2,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusMd.radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppTheme.radiusMd.radius,
          child: Container(
            padding: AppTheme.space4.padding,
            decoration: BoxDecoration(
              gradient: AppTheme.oliveGoldGradient,
              borderRadius: AppTheme.radiusMd.radius,
              boxShadow: AppTheme.shadowMd,
            ),
            child: Row(
              children: [
                // الأيقونة
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: AppTheme.radiusMd.radius,
                  ),
                  child: Icon(
                    icon ?? Icons.apps,
                    color: Colors.white,
                    size: AppTheme.iconLg,
                  ),
                ),
                
                AppTheme.space3.w,
                
                // معلومات التطبيق
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appName,
                        style: AppTheme.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: AppTheme.bold,
                        ),
                      ),
                      AppTheme.space1.h,
                      Text(
                        'الإصدار $version',
                        style: AppTheme.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontFamily: AppTheme.numbersFont,
                        ),
                      ),
                      if (buildNumber != null) ...[
                        Text(
                          'البناء $buildNumber',
                          style: AppTheme.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontFamily: AppTheme.numbersFont,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // سهم الانتقال
                if (onTap != null)
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: AppTheme.iconMd,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// بطاقة إعدادات خطيرة
class DangerSettingCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final bool requireConfirmation;
  final String? confirmationMessage;

  const DangerSettingCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
    this.requireConfirmation = true,
    this.confirmationMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.space4,
        vertical: AppTheme.space2,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusMd.radius,
        child: InkWell(
          onTap: () => _handleTap(context),
          borderRadius: AppTheme.radiusMd.radius,
          child: Container(
            padding: AppTheme.space4.padding,
            decoration: BoxDecoration(
              color: AppTheme.error.withValues(alpha: 0.1),
              borderRadius: AppTheme.radiusMd.radius,
              border: Border.all(
                color: AppTheme.error.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // الأيقونة
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.error.withValues(alpha: 0.2),
                    borderRadius: AppTheme.radiusMd.radius,
                  ),
                  child: Icon(
                    icon,
                    color: AppTheme.error,
                    size: AppTheme.iconMd,
                  ),
                ),
                
                AppTheme.space3.w,
                
                // النص
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: AppTheme.medium,
                          color: AppTheme.error,
                        ),
                      ),
                      if (subtitle != null) ...[
                        AppTheme.space1.h,
                        Text(
                          subtitle!,
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // أيقونة التحذير
                Icon(
                  Icons.warning,
                  color: AppTheme.error,
                  size: AppTheme.iconSm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    if (onTap == null) return;
    
    if (requireConfirmation) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Row(
            children: [
              Icon(
                Icons.warning,
                color: AppTheme.error,
              ),
              AppTheme.space2.w,
              const Text('تأكيد العملية'),
            ],
          ),
          content: Text(
            confirmationMessage ?? 'هل أنت متأكد من تنفيذ هذا الإجراء؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onTap!();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.error,
              ),
              child: const Text('تأكيد'),
            ),
          ],
        ),
      );
    } else {
      onTap!();
    }
  }
}

// ==================== مكونات مساعدة للإعدادات ====================

/// خيار الإعداد
class SettingOption {
  final String value;
  final String label;
  final String? description;
  final IconData? icon;

  const SettingOption({
    required this.value,
    required this.label,
    this.description,
    this.icon,
  });
}

/// مجموعة الإعدادات
class SettingGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final String? description;

  const SettingGroup({
    super.key,
    required this.title,
    required this.children,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان المجموعة
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space4,
            vertical: AppTheme.space2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.titleMedium.copyWith(
                  fontWeight: AppTheme.bold,
                  color: AppTheme.primary,
                ),
              ),
              if (description != null) ...[
                AppTheme.space1.h,
                Text(
                  description!,
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // عناصر المجموعة
        ...children,
        
        AppTheme.space4.h,
      ],
    );
  }
}

/// فاصل الإعدادات
class SettingDivider extends StatelessWidget {
  final String? label;

  const SettingDivider({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.space4,
        vertical: AppTheme.space3,
      ),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: AppTheme.divider,
              thickness: 1,
            ),
          ),
          if (label != null) ...[
            AppTheme.space3.w,
            Text(
              label!,
              style: AppTheme.caption.copyWith(
                color: AppTheme.textTertiary,
                fontWeight: AppTheme.medium,
              ),
            ),
            AppTheme.space3.w,
            Expanded(
              child: Divider(
                color: AppTheme.divider,
                thickness: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== Factory Methods للإعدادات ====================

/// مصنع بطاقات الإعدادات
class SettingCards {
  SettingCards._();

  /// إعداد مع مفتاح تشغيل
  static Widget toggle({
    required String title,
    String? subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool>? onChanged,
    Color? color,
    bool isEnabled = true,
  }) {
    return SettingToggleCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      value: value,
      onChanged: onChanged,
      color: color,
      isEnabled: isEnabled,
    );
  }

  /// إعداد للانتقال
  static Widget navigation({
    required String title,
    String? subtitle,
    required IconData icon,
    VoidCallback? onTap,
    Color? color,
    Widget? trailing,
    bool showBadge = false,
    String? badgeText,
  }) {
    return SettingNavigationCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      color: color,
      trailing: trailing,
      showBadge: showBadge,
      badgeText: badgeText,
    );
  }

  /// إعداد مع قائمة اختيار
  static Widget selection({
    required String title,
    String? subtitle,
    required IconData icon,
    required String currentValue,
    required List<SettingOption> options,
    ValueChanged<String>? onChanged,
    Color? color,
  }) {
    return SettingSelectionCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      currentValue: currentValue,
      options: options,
      onChanged: onChanged,
      color: color,
    );
  }

  /// إعداد مع شريط تمرير
  static Widget slider({
    required String title,
    String? subtitle,
    required IconData icon,
    required double value,
    required double min,
    required double max,
    int? divisions,
    ValueChanged<double>? onChanged,
    Color? color,
    String Function(double)? valueFormatter,
  }) {
    return SettingSliderCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      value: value,
      min: min,
      max: max,
      divisions: divisions,
      onChanged: onChanged,
      color: color,
      valueFormatter: valueFormatter,
    );
  }

  /// معلومات التطبيق
  static Widget appInfo({
    required String appName,
    required String version,
    String? buildNumber,
    IconData? icon,
    VoidCallback? onTap,
  }) {
    return AppInfoCard(
      appName: appName,
      version: version,
      buildNumber: buildNumber,
      icon: icon,
      onTap: onTap,
    );
  }

  /// إعداد خطير
  static Widget danger({
    required String title,
    String? subtitle,
    required IconData icon,
    VoidCallback? onTap,
    bool requireConfirmation = true,
    String? confirmationMessage,
  }) {
    return DangerSettingCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      requireConfirmation: requireConfirmation,
      confirmationMessage: confirmationMessage,
    );
  }

  /// مجموعة إعدادات
  static Widget group({
    required String title,
    required List<Widget> children,
    String? description,
  }) {
    return SettingGroup(
      title: title,
      children: children,
      description: description,
    );
  }

  /// فاصل
  static Widget divider({String? label}) {
    return SettingDivider(label: label);
  }

  /// الخيارات الشائعة للإعدادات
  static List<SettingOption> getFontSizeOptions() {
    return const [
      SettingOption(value: 'small', label: 'صغير', description: 'خط صغير سهل القراءة'),
      SettingOption(value: 'medium', label: 'متوسط', description: 'الحجم الافتراضي'),
      SettingOption(value: 'large', label: 'كبير', description: 'خط كبير واضح'),
      SettingOption(value: 'xlarge', label: 'كبير جداً', description: 'للقراءة المريحة'),
    ];
  }

  static List<SettingOption> getLanguageOptions() {
    return const [
      SettingOption(value: 'ar', label: 'العربية', icon: Icons.language),
      SettingOption(value: 'en', label: 'English', icon: Icons.language),
    ];
  }

  static List<SettingOption> getThemeOptions() {
    return const [
      SettingOption(value: 'system', label: 'تلقائي', description: 'حسب إعدادات النظام'),
      SettingOption(value: 'light', label: 'فاتح', description: 'الثيم الفاتح'),
      SettingOption(value: 'dark', label: 'داكن', description: 'الثيم الداكن'),
    ];
  }

  static List<SettingOption> getNotificationTimeOptions() {
    return const [
      SettingOption(value: '5', label: '5 دقائق'),
      SettingOption(value: '10', label: '10 دقائق'),
      SettingOption(value: '15', label: '15 دقيقة'),
      SettingOption(value: '30', label: '30 دقيقة'),
      SettingOption(value: '60', label: 'ساعة'),
    ];
  }
}

// ==================== Extensions للإعدادات ====================

extension SettingCardExtensions on BuildContext {
  /// إظهار محرر النص
  void showTextEditor({
    required String title,
    required String initialValue,
    required ValueChanged<String> onSaved,
    String? hint,
    int? maxLines,
  }) {
    final controller = TextEditingController(text: initialValue);
    
    showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
          maxLines: maxLines ?? 1,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onSaved(controller.text);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  /// إظهار محرر الأرقام
  void showNumberEditor({
    required String title,
    required double initialValue,
    required ValueChanged<double> onSaved,
    double? min,
    double? max,
    String? suffix,
  }) {
    final controller = TextEditingController(text: initialValue.toString());
    
    showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            suffix: suffix != null ? Text(suffix) : null,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(controller.text) ?? initialValue;
              final clampedValue = value.clamp(min ?? double.negativeInfinity, max ?? double.infinity);
              Navigator.pop(context);
              onSaved(clampedValue);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  /// إظهار معاينة الثيم
  void showThemePreview({
    required String themeName,
    required Widget preview,
    VoidCallback? onApply,
  }) {
    showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Text('معاينة ثيم $themeName'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: preview,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          if (onApply != null)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                onApply();
              },
              child: const Text('تطبيق'),
            ),
        ],
      ),
    );
  }
}