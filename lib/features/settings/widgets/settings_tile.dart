// lib/features/settings/widgets/settings_tile.dart - مُحدث بالنظام الموحد

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد
import '../../../app/themes/app_theme.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Color? iconColor;
  final Color? backgroundColor;
  final bool enabled;
  final bool showRipple;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final bool showDivider;
  final Widget? badge;
  final double? iconSize;
  final CrossAxisAlignment crossAxisAlignment;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.iconColor,
    this.backgroundColor,
    this.enabled = true,
    this.showRipple = true,
    this.padding,
    this.borderRadius,
    this.showDivider = false,
    this.badge,
    this.iconSize,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  void _handleTap() {
    if (!enabled || onTap == null) return;
    HapticFeedback.mediumImpact();
    onTap!();
  }

  void _handleLongPress() {
    if (!enabled || onLongPress == null) return;
    HapticFeedback.heavyImpact();
    onLongPress!();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? context.primaryColor;
    final effectiveBackgroundColor = backgroundColor ?? Colors.transparent;
    final effectivePadding = padding ?? EdgeInsets.symmetric(
      horizontal: ThemeConstants.space4,
      vertical: ThemeConstants.space4,
    );
    final effectiveBorderRadius = borderRadius ?? 
        BorderRadius.circular(ThemeConstants.radiusXl);

    return Container(
      decoration: BoxDecoration(
        color: effectiveBackgroundColor,
        borderRadius: effectiveBorderRadius,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleTap,
          onLongPress: _handleLongPress,
          borderRadius: effectiveBorderRadius,
          splashColor: showRipple 
              ? effectiveIconColor.withValues(alpha: 0.1)
              : Colors.transparent,
          highlightColor: showRipple
              ? effectiveIconColor.withValues(alpha: 0.05)
              : Colors.transparent,
          child: Opacity(
            opacity: enabled ? 1.0 : 0.6,
            child: Padding(
              padding: effectivePadding,
              child: Row(
                crossAxisAlignment: crossAxisAlignment,
                children: [
                  _buildIcon(context, effectiveIconColor),
                  ThemeConstants.space4.w,
                  Expanded(child: _buildContent(context)),
                  if (trailing != null) ...[
                    ThemeConstants.space3.w,
                    _buildTrailing(context),
                  ] else if (onTap != null && enabled) ...[
                    ThemeConstants.space3.w,
                    _buildDefaultTrailing(context),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(BuildContext context, Color iconColor) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: iconSize != null ? iconSize! + 16 : 48,
          height: iconSize != null ? iconSize! + 16 : 48,
          decoration: BoxDecoration(
            color: enabled 
                ? iconColor.withValues(alpha: 0.1)
                : context.textSecondaryColor.withValues(alpha: 0.05),
            borderRadius: ThemeConstants.radiusMd.radius,
          ),
          child: Icon(
            icon,
            color: enabled 
                ? iconColor
                : context.textSecondaryColor.withValues(alpha: 0.5),
            size: iconSize ?? ThemeConstants.iconMd,
          ),
        ),
        
        if (badge != null)
          Positioned(
            top: 0,
            right: 0,
            child: badge!,
          ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: context.titleMedium?.copyWith(
            color: enabled 
                ? context.textPrimaryColor
                : context.textSecondaryColor.withValues(alpha: 0.7),
            fontWeight: ThemeConstants.medium,
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        if (subtitle != null) ...[
          ThemeConstants.space1.h,
          Text(
            subtitle!,
            style: context.bodySmall?.copyWith(
              color: enabled 
                  ? context.textSecondaryColor
                  : context.textSecondaryColor.withValues(alpha: 0.5),
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildTrailing(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: trailing!,
    );
  }

  Widget _buildDefaultTrailing(BuildContext context) {
    return Icon(
      Icons.arrow_forward_ios_rounded,
      size: ThemeConstants.iconSm,
      color: context.textSecondaryColor.withValues(
        alpha: enabled ? 0.6 : 0.3,
      ),
    );
  }
}

/// Badge للإشعارات أو التنبيهات
class SettingsBadge extends StatelessWidget {
  final String? text;
  final Color? color;
  final bool isNew;
  final bool isWarning;
  final bool isError;
  final double? size;

  const SettingsBadge({
    super.key,
    this.text,
    this.color,
    this.isNew = false,
    this.isWarning = false,
    this.isError = false,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    if (color != null) {
      badgeColor = color!;
    } else if (isError) {
      badgeColor = context.errorColor;
    } else if (isWarning) {
      badgeColor = context.warningColor;
    } else if (isNew) {
      badgeColor = context.successColor;
    } else {
      badgeColor = context.primaryColor;
    }

    final effectiveSize = size ?? 16.0;

    return Container(
      constraints: BoxConstraints(
        minWidth: effectiveSize,
        minHeight: effectiveSize,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: text != null ? 6 : 0,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(effectiveSize / 2),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: text != null
          ? Text(
              text!,
              style: TextStyle(
                color: Colors.white,
                fontSize: effectiveSize * 0.6,
                fontWeight: FontWeight.bold,
                height: 1,
              ),
              textAlign: TextAlign.center,
            )
          : null,
    );
  }

  factory SettingsBadge.isNew([String? text]) => SettingsBadge(
        text: text ?? 'جديد',
        isNew: true,
      );

  factory SettingsBadge.warning([String? text]) => SettingsBadge(
        text: text ?? '!',
        isWarning: true,
      );

  factory SettingsBadge.error([String? text]) => SettingsBadge(
        text: text ?? '!',
        isError: true,
      );

  factory SettingsBadge.count(int count, {Color? color}) => SettingsBadge(
        text: count > 99 ? '99+' : count.toString(),
        color: color,
      );

  factory SettingsBadge.dot({Color? color}) => SettingsBadge(
        color: color,
        size: 8,
      );
}

/// Switch مخصص للإعدادات
class SettingsSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final bool enabled;

  const SettingsSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Switch.adaptive(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: activeColor ?? context.primaryColor,
      inactiveThumbColor: inactiveColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

/// قائمة منسدلة للإعدادات
class SettingsDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final bool enabled;

  const SettingsDropdown({
    super.key,
    required this.value,
    required this.items,
    this.onChanged,
    this.hint,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      hint: hint != null ? Text(hint!) : null,
      underline: const SizedBox(),
      isDense: true,
      icon: Icon(
        Icons.arrow_drop_down,
        color: context.textSecondaryColor,
      ),
    );
  }
}

/// زر إجراء في الإعدادات
class SettingsActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final bool outlined;
  final bool enabled;

  const SettingsActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.color,
    this.outlined = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.primaryColor;

    if (outlined) {
      return AppButton.outline(
        text: text,
        onPressed: enabled ? onPressed : null,
        icon: icon,
        borderColor: effectiveColor,
      );
    }

    return AppButton.primary(
      text: text,
      onPressed: enabled ? onPressed : null,
      icon: icon,
      backgroundColor: effectiveColor,
    );
  }
}