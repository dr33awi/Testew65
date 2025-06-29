// lib/features/settings/widgets/settings_section.dart - محدث بالنظام الموحد الإسلامي

import 'package:flutter/material.dart';

// ✅ استيراد النظام الموحد الإسلامي
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets/widgets.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final List<Widget> children;
  final EdgeInsets? padding;
  final bool showHeader;
  final Color? headerColor;

  const SettingsSection({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.children,
    this.padding,
    this.showHeader = true,
    this.headerColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppTheme.space4,
        vertical: AppTheme.space3,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.radiusXl),
        color: AppTheme.card,
        boxShadow: AppTheme.shadowSm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showHeader) _buildHeader(context),
          
          Container(
            padding: padding ?? AppTheme.space4.padding,
            child: Column(
              children: _buildChildren(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppTheme.space4.padding,
      decoration: BoxDecoration(
        color: headerColor ?? AppTheme.primary.withValues(alpha: 0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusXl),
          topRight: Radius.circular(AppTheme.radiusXl),
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: AppTheme.space2.padding,
              decoration: BoxDecoration(
                color: (headerColor ?? AppTheme.primary).withValues(alpha: 0.2),
                borderRadius: AppTheme.radiusMd.radius,
              ),
              child: Icon(
                icon!,
                color: headerColor ?? AppTheme.primary,
                size: AppTheme.iconSm,
              ),
            ),
            
            AppTheme.space3.w,
          ],
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.titleMedium.copyWith(
                    fontWeight: AppTheme.bold,
                    color: headerColor ?? AppTheme.primary,
                  ),
                ),
                
                if (subtitle != null) ...[
                  AppTheme.space1.h,
                  Text(
                    subtitle!,
                    style: context.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildChildren() {
    final List<Widget> widgets = [];
    
    for (int i = 0; i < children.length; i++) {
      widgets.add(children[i]);
      
      // إضافة فاصل بين العناصر
      if (i < children.length - 1) {
        widgets.add(
          Divider(
            height: AppTheme.space4,
            indent: AppTheme.space6,
            endIndent: AppTheme.space6,
            color: AppTheme.divider.withValues(alpha: 0.3),
          ),
        );
      }
    }
    
    return widgets;
  }
}

/// رأس قسم الإعدادات - منفصل
class SettingsSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? color;
  final Widget? trailing;

  const SettingsSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.color,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: AppTheme.space4,
        vertical: AppTheme.space3,
      ),
      padding: AppTheme.space3.padding,
      decoration: BoxDecoration(
        color: (color ?? AppTheme.primary).withValues(alpha: 0.1),
        borderRadius: AppTheme.radiusMd.radius,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: AppTheme.space2.padding,
              decoration: BoxDecoration(
                color: (color ?? AppTheme.primary).withValues(alpha: 0.2),
                borderRadius: AppTheme.radiusMd.radius,
              ),
              child: Icon(
                icon!,
                color: color ?? AppTheme.primary,
                size: AppTheme.iconSm,
              ),
            ),
            
            AppTheme.space2.w,
          ],
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.bodyLarge.copyWith(
                    fontWeight: AppTheme.bold,
                    color: color ?? AppTheme.primary,
                  ),
                ),
                
                if (subtitle != null) ...[
                  AppTheme.space1.h,
                  Text(
                    subtitle!,
                    style: context.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          if (trailing != null) ...[
            AppTheme.space2.w,
            trailing!,
          ],
        ],
      ),
    );
  }
}