// lib/features/settings/widgets/settings_section.dart
import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';

/// قسم في شاشة الإعدادات
class SettingsSection extends StatelessWidget {
  final String title;
  final IconData? icon;
  final List<Widget> children;
  final EdgeInsetsGeometry? margin;

  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
    this.icon,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          Padding(
            padding: const EdgeInsets.only(
              left: ThemeConstants.space2,
              right: ThemeConstants.space2,
              bottom: ThemeConstants.space2,
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: ThemeConstants.iconSm,
                    color: context.primaryColor,
                  ),
                  ThemeConstants.space2.w,
                ],
                Text(
                  title,
                  style: context.labelLarge?.copyWith(
                    color: context.primaryColor,
                    fontWeight: ThemeConstants.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // محتوى القسم
          Container(
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                for (int i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i < children.length - 1)
                    Divider(
                      height: 1,
                      indent: ThemeConstants.space6,
                      endIndent: ThemeConstants.space6,
                      color: context.dividerColor.withValues(alpha: 0.5),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}