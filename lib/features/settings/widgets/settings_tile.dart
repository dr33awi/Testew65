// lib/features/settings/widgets/settings_tile.dart - محدث بالنظام الموحد الإسلامي

import 'package:flutter/material.dart';

// ✅ استيراد النظام الموحد الإسلامي
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/widgets.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;
  final Color? iconColor;
  final double? iconSize;
  final EdgeInsets? padding;
  final String? badge;
  final BadgeType? badgeType;

  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.iconColor,
    this.iconSize,
    this.padding,
    this.badge,
    this.badgeType,
  });

  // Factory constructors للأنواع الشائعة
  factory SettingsTile.navigation({
    Key? key,
    required String title,
    String? subtitle,
    IconData? icon,
    required VoidCallback onTap,
    Color? iconColor,
    String? badge,
    BadgeType? badgeType,
  }) {
    return SettingsTile(
      key: key,
      title: title,
      subtitle: subtitle,
      icon: icon,
      onTap: onTap,
      iconColor: iconColor,
      badge: badge,
      badgeType: badgeType,
      trailing: const Icon(
        Icons.chevron_right,
        color: AppTheme.textSecondary,
      ),
    );
  }

  factory SettingsTile.toggle({
    Key? key,
    required String title,
    String? subtitle,
    IconData? icon,
    required bool value,
    required ValueChanged<bool>? onChanged, // ✅ إضافة nullable
    Color? iconColor,
    bool enabled = true,
  }) {
    return SettingsTile(
      key: key,
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconColor: iconColor,
      enabled: enabled,
      trailing: Switch(
        value: value,
        onChanged: enabled && onChanged != null ? onChanged : null,
        activeColor: iconColor ?? AppTheme.primary,
      ),
      onTap: enabled && onChanged != null ? () => onChanged(!value) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ إصلاح مشكلة onTap nullable
    return AnimatedPress(
      onTap: (enabled && onTap != null) ? onTap! : () {}, // تقديم دالة فارغة بدلاً من null
      child: Container(
        padding: padding ?? const EdgeInsets.symmetric(
          horizontal: AppTheme.space4,
          vertical: AppTheme.space4,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          color: enabled 
              ? Colors.transparent
              : AppTheme.textSecondary.withValues(alpha: 0.05),
        ),
        child: Row(
          children: [
            // الأيقونة
            if (icon != null) ...[
              _buildIcon(context),
              AppTheme.space4.w,
            ],
            
            // النص الرئيسي
            Expanded(
              child: _buildContent(context),
            ),
            
            // العنصر الجانبي والشارة
            if (badge != null || trailing != null) ...[
              AppTheme.space3.w,
              _buildTrailingSection(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    return Container(
      padding: AppTheme.space2.padding,
      decoration: BoxDecoration(
        color: enabled 
            ? (iconColor ?? AppTheme.primary).withValues(alpha: 0.1)
            : AppTheme.textSecondary.withValues(alpha: 0.05),
        borderRadius: AppTheme.radiusMd.radius,
        border: Border.all(
          color: enabled 
              ? (iconColor ?? AppTheme.primary).withValues(alpha: 0.2)
              : AppTheme.textSecondary.withValues(alpha: 0.5),
        ),
      ),
      child: Icon(
        icon!,
        color: enabled 
            ? iconColor ?? AppTheme.primary
            : AppTheme.textSecondary.withValues(alpha: 0.7),
        size: iconSize ?? AppTheme.iconMd,
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.bodyLarge.copyWith(
            color: enabled 
                ? AppTheme.textPrimary
                : AppTheme.textSecondary.withValues(alpha: 0.7),
            fontWeight: AppTheme.medium,
          ),
        ),
        
        if (subtitle != null) ...[
          AppTheme.space1.h,
          Text(
            subtitle!,
            style: context.bodySmall.copyWith(
              color: enabled 
                  ? AppTheme.textSecondary
                  : AppTheme.textSecondary.withValues(alpha: 0.5),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTrailingSection(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // الشارة
        if (badge != null) ...[
          _buildBadge(context),
          AppTheme.space2.w,
        ],
        
        // العنصر الجانبي
        if (trailing != null) trailing!,
      ],
    );
  }

  Widget _buildBadge(BuildContext context) {
    final badgeColor = _getBadgeColor(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: AppTheme.radiusFull.radius,
        border: Border.all(
          color: badgeColor.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        badge!,
        style: context.bodySmall.copyWith(
          color: badgeColor,
          fontWeight: AppTheme.medium,
        ),
      ),
    );
  }

  Color _getBadgeColor(BuildContext context) {
    Color badgeColor = AppTheme.primary;
    
    switch (badgeType) {
      case BadgeType.error:
        badgeColor = AppTheme.error;
        break;
      case BadgeType.warning:
        badgeColor = AppTheme.warning;
        break;
      case BadgeType.success:
        badgeColor = AppTheme.success;
        break;
      case BadgeType.info:
      default:
        badgeColor = AppTheme.info;
        break;
    }
    
    return badgeColor;
  }
}

enum BadgeType {
  info,
  success,
  warning,
  error,
}

/// زر إجراء للإعدادات
class SettingsActionButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool isDestructive;
  final bool isOutlined;

  const SettingsActionButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
    this.isDestructive = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return AppButton.outline(
        text: text,
        icon: icon,
        onPressed: onPressed,
        borderColor: isDestructive ? AppTheme.error : AppTheme.primary,
      );
    }
    
    return AppButton.primary(
      text: text,
      icon: icon,
      onPressed: onPressed,
    );
  }
}

/// فاصل بصري للإعدادات
class SettingsDivider extends StatelessWidget {
  final String? label;
  final EdgeInsets? padding;

  const SettingsDivider({
    super.key,
    this.label,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.symmetric(
        vertical: AppTheme.space3,
        horizontal: AppTheme.space4,
      ),
      child: Row(
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: context.bodySmall.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: AppTheme.semiBold,
              ),
            ),
            AppTheme.space3.w,
          ],
          
          Expanded(
            child: Container(
              height: 1,
              color: AppTheme.divider,
            ),
          ),
        ],
      ),
    );
  }
}

/// مساحة فارغة للإعدادات
class SettingsSpacing extends StatelessWidget {
  final double? height;

  const SettingsSpacing({super.key, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height ?? AppTheme.space4);
  }
}