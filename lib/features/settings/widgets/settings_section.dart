// lib/features/settings/widgets/settings_section.dart (مُنظف)

import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';

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
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: elevation ?? 12,
            offset: const Offset(0, 4),
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? context.cardColor,
            gradient: gradient,
            borderRadius: effectiveBorderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showHeader) _buildHeader(context),
              _buildContent(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final effectiveTitleColor = titleColor ?? context.primaryColor;
    final effectiveIconColor = iconColor ?? context.primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onHeaderTap,
        borderRadius: BorderRadius.only(
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
                ThemeConstants.space3.w,
              ],
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.titleMedium?.copyWith(
                        color: effectiveTitleColor,
                        fontWeight: ThemeConstants.bold,
                        height: 1.2,
                      ),
                    ),
                    if (subtitle != null) ...[
                      ThemeConstants.space1.h,
                      Text(
                        subtitle!,
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              if (headerTrailing != null) ...[
                ThemeConstants.space3.w,
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
            color: context.dividerColor.withValues(alpha: 0.3),
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
                    color: context.dividerColor.withValues(alpha: 0.3),
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

/// ويدجت لعنوان القسم فقط
class SettingsSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? titleColor;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const SettingsSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.titleColor,
    this.iconColor,
    this.trailing,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTitleColor = titleColor ?? context.primaryColor;
    final effectiveIconColor = iconColor ?? context.primaryColor;
    final effectivePadding = padding ?? const EdgeInsets.symmetric(
      horizontal: ThemeConstants.space4,
      vertical: ThemeConstants.space3,
    );

    return Padding(
      padding: effectivePadding,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(ThemeConstants.space2),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: ThemeConstants.iconSm,
                  color: effectiveIconColor,
                ),
                ThemeConstants.space2.w,
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.labelLarge?.copyWith(
                        color: effectiveTitleColor,
                        fontWeight: ThemeConstants.bold,
                      ),
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
              if (trailing != null) ...[
                ThemeConstants.space2.w,
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}