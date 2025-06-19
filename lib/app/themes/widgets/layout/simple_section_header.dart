// lib/app/themes/widgets/layout/simple_section_header.dart
import 'package:flutter/material.dart';
import '../../theme_constants.dart';
import '../../core/theme_extensions.dart';

/// A reusable section header used across the app.
class SimpleSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTapRefresh;
  final bool showRefresh;

  const SimpleSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTapRefresh,
    this.showRefresh = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      child: Row(
        children: [
          // side indicator
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              gradient: ThemeConstants.primaryGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ThemeConstants.space4.w,
          // icon
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space2),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Icon(icon, color: context.primaryColor, size: ThemeConstants.iconMd),
          ),
          ThemeConstants.space3.w,
          // texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.titleLarge?.copyWith(
                    fontWeight: ThemeConstants.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: context.labelMedium?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          if (showRefresh && onTapRefresh != null)
            IconButton(
              onPressed: onTapRefresh,
              icon: Icon(Icons.refresh, color: context.textSecondaryColor),
              tooltip: 'تحديث',
            ),
        ],
      ),
    );
  }
}
