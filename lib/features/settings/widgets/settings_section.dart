// lib/features/settings/widgets/settings_section.dart - محدثة للنظام الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart'; // ✅ النظام الموحد

class SettingsSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? titleColor;
  final Color? iconColor;
  final bool showHeader;
  final Widget? headerTrailing;
  final VoidCallback? onHeaderTap;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final bool showDividers;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.icon,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.titleColor,
    this.iconColor,
    this.showHeader = true,
    this.headerTrailing,
    this.onHeaderTap,
    this.elevation,
    this.borderRadius,
    this.gradient,
    this.showDividers = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveMargin = margin ?? const EdgeInsets.symmetric(
      horizontal: ThemeConstants.space4,
      vertical: ThemeConstants.space3,
    );

    final effectiveBorderRadius = borderRadius ?? 
        BorderRadius.circular(ThemeConstants.radiusXl);

    return Container(
      margin: effectiveMargin,
      child: AppCard.custom(
        type: CardType.normal,
        style: gradient != null ? CardStyle.gradient : CardStyle.normal,
        backgroundColor: backgroundColor ?? AppColorSystem.getCard(context),
        borderRadius: ThemeConstants.radiusXl,
        padding: EdgeInsets.zero,
        showShadow: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) _buildHeader(context),
            _buildContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final effectiveTitleColor = titleColor ?? AppColorSystem.primary;
    final effectiveIconColor = iconColor ?? AppColorSystem.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onHeaderTap,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(ThemeConstants.radiusXl),
          topRight: Radius.circular(ThemeConstants.radiusXl),
        ),
        child: Container(
          padding: padding ?? const EdgeInsets.all(ThemeConstants.space4),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
                  decoration: BoxDecoration(
                    color: effectiveIconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  ),
                  child: Icon(
                    icon,
                    size: ThemeConstants.iconSm,
                    color: effectiveIconColor,
                  ),
                ),
                const SizedBox(width: ThemeConstants.space3),
              ],
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.h5.copyWith(
                        color: effectiveTitleColor,
                        fontWeight: ThemeConstants.bold,
                        height: 1.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: ThemeConstants.space1),
                      Text(
                        subtitle!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColorSystem.getTextSecondary(context),
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              if (headerTrailing != null) ...[
                const SizedBox(width: ThemeConstants.space3),
                headerTrailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (children.isEmpty) {
      return const SizedBox();
    }

    return Column(
      children: [
        if (showHeader && showDividers)
          Divider(
            height: 1,
            thickness: 1,
            color: AppColorSystem.getDivider(context).withValues(alpha: 0.3),
            indent: 0,
            endIndent: 0,
          ),
        
        ...List.generate(
          children.length,
          (index) {
            final child = children[index];
            final isLast = index == children.length - 1;
            
            return Column(
              children: [
                child,
                if (!isLast && showDividers)
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: ThemeConstants.space6,
                    endIndent: ThemeConstants.space6,
                    color: AppColorSystem.getDivider(context).withValues(alpha: 0.3),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

/// قسم بسيط بدون تعقيدات
class SimpleSettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final IconData? icon;
  final EdgeInsetsGeometry? margin;

  const SimpleSettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.icon,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: title,
      icon: icon,
      children: children,
      margin: margin,
      showDividers: true,
      elevation: 8,
    );
  }
}

/// قسم مع تدرج لوني
class GradientSettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final IconData? icon;
  final List<Color> gradientColors;
  final EdgeInsetsGeometry? margin;

  const GradientSettingsSection({
    super.key,
    required this.title,
    required this.children,
    required this.gradientColors,
    this.icon,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: title,
      icon: icon,
      children: children,
      margin: margin,
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: gradientColors,
      ),
      titleColor: Colors.white,
      iconColor: Colors.white,
      showDividers: false,
    );
  }
}

/// قسم بدون هيدر
class HeaderlessSettingsSection extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;

  const HeaderlessSettingsSection({
    super.key,
    required this.children,
    this.margin,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: '',
      children: children,
      margin: margin,
      backgroundColor: backgroundColor,
      showHeader: false,
      showDividers: true,
    );
  }
}

// ===== settings_tile.dart - محدث للنظام الموحد =====

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
    final effectiveIconColor = iconColor ?? AppColorSystem.primary;
    final effectiveBackgroundColor = backgroundColor ?? Colors.transparent;
    final effectivePadding = padding ?? const EdgeInsets.symmetric(
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
                  const SizedBox(width: ThemeConstants.space4),
                  Expanded(child: _buildContent(context)),
                  if (trailing != null) ...[
                    const SizedBox(width: ThemeConstants.space3),
                    _buildTrailing(context),
                  ] else if (onTap != null && enabled) ...[
                    const SizedBox(width: ThemeConstants.space3),
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
                : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: Icon(
            icon,
            color: enabled 
                ? iconColor
                : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.5),
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
          style: AppTextStyles.label1.copyWith(
            color: enabled 
                ? AppColorSystem.getTextPrimary(context)
                : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.7),
            fontWeight: ThemeConstants.medium,
            height: 1.2,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        
        if (subtitle != null) ...[
          const SizedBox(height: ThemeConstants.space1),
          Text(
            subtitle!,
            style: AppTextStyles.caption.copyWith(
              color: enabled 
                  ? AppColorSystem.getTextSecondary(context)
                  : AppColorSystem.getTextSecondary(context).withValues(alpha: 0.5),
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
      color: AppColorSystem.getTextSecondary(context).withValues(
        alpha: enabled ? 0.6 : 0.3,
      ),
    );
  }
}

/// Badge للإشعارات أو التنبيهات - محدث للنظام الموحد
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
      badgeColor = AppColorSystem.error;
    } else if (isWarning) {
      badgeColor = AppColorSystem.warning;
    } else if (isNew) {
      badgeColor = AppColorSystem.success;
    } else {
      badgeColor = AppColorSystem.primary;
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
        boxShadow: AppShadowSystem.colored(
          color: badgeColor,
          intensity: ShadowIntensity.light,
          opacity: 0.3,
        ),
      ),
      child: text != null
          ? Text(
              text!,
              style: AppTextStyles.caption.copyWith(
                color: Colors.white,
                fontSize: effectiveSize * 0.6,
                fontWeight: ThemeConstants.bold,
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

/// Switch مخصص للإعدادات - محدث للنظام الموحد
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
      activeColor: activeColor ?? AppColorSystem.primary,
      inactiveThumbColor: inactiveColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

/// قائمة منسدلة للإعدادات - محدثة للنظام الموحد
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
      hint: hint != null ? Text(
        hint!,
        style: AppTextStyles.body2.copyWith(
          color: AppColorSystem.getTextSecondary(context),
        ),
      ) : null,
      underline: const SizedBox(),
      isDense: true,
      icon: Icon(
        Icons.arrow_drop_down,
        color: AppColorSystem.getTextSecondary(context),
      ),
    );
  }
}

/// زر إجراء في الإعدادات - محدث للنظام الموحد
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
    final effectiveColor = color ?? AppColorSystem.primary;

    if (outlined) {
      return AppButton.outline(
        text: text,
        onPressed: enabled ? onPressed : null,
        icon: icon,
        color: effectiveColor,
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