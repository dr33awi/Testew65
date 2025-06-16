// lib/features/settings/widgets/settings_tile.dart
import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';

/// عنصر في قسم الإعدادات
class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final bool enabled;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? context.primaryColor;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space4,
            vertical: ThemeConstants.space4,
          ),
          child: Row(
            children: [
              // الأيقونة
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: enabled 
                      ? effectiveIconColor.withValues(alpha: 0.1)
                      : context.textSecondaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: enabled 
                      ? effectiveIconColor
                      : context.textSecondaryColor.withValues(alpha: 0.5),
                  size: ThemeConstants.iconMd,
                ),
              ),
              
              ThemeConstants.space4.w,
              
              // المحتوى
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.titleMedium?.copyWith(
                        color: enabled 
                            ? context.textPrimaryColor
                            : context.textSecondaryColor.withValues(alpha: 0.7),
                        fontWeight: ThemeConstants.medium,
                      ),
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
                      ),
                    ],
                  ],
                ),
              ),
              
              ThemeConstants.space3.w,
              
              // العنصر الإضافي
              if (trailing != null)
                trailing!
              else if (onTap != null && enabled)
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: ThemeConstants.iconSm,
                  color: context.textSecondaryColor.withValues(alpha: 0.6),
                ),
            ],
          ),
        ),
      ),
    );
  }
}