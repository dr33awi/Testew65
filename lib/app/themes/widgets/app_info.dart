// lib/app/themes/widgets/app_info.dart - معلومات التطبيق الموحدة
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:athkar_app/app/themes/widgets/widgets.dart';
import 'package:flutter/material.dart';

/// نظام معلومات التطبيق الموحد
class AppInfo extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? customIcon;
  final String? version;
  final String? description;
  final List<AppInfoItem>? items;
  final List<Widget>? actions;
  final VoidCallback? onTap;

  const AppInfo({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.customIcon,
    this.version,
    this.description,
    this.items,
    this.actions,
    this.onTap,
  });

  // ========== Factory Constructors ==========

  /// معلومات التطبيق الأساسية
  factory AppInfo.app({
    Key? key,
    required String appName,
    required String version,
    String? description,
    List<AppInfoItem>? features,
    IconData? icon,
  }) {
    return AppInfo(
      key: key,
      title: appName,
      subtitle: 'الإصدار $version',
      icon: icon ?? Icons.apps,
      version: version,
      description: description,
      items: features,
    );
  }

  /// معلومات المطور
  factory AppInfo.developer({
    Key? key,
    required String name,
    String? email,
    String? website,
    VoidCallback? onContact,
  }) {
    return AppInfo(
      key: key,
      title: name,
      subtitle: 'المطور',
      icon: Icons.person,
      items: [
        if (email != null) AppInfoItem(label: 'البريد الإلكتروني', value: email),
        if (website != null) AppInfoItem(label: 'الموقع الإلكتروني', value: website),
      ],
      onTap: onContact,
    );
  }

  /// معلومات الإحصائيات
  factory AppInfo.stats({
    Key? key,
    required String title,
    required Map<String, dynamic> statistics,
    IconData? icon,
  }) {
    return AppInfo(
      key: key,
      title: title,
      subtitle: 'الإحصائيات',
      icon: icon ?? Icons.analytics,
      items: statistics.entries.map((entry) => 
        AppInfoItem(
          label: entry.key,
          value: entry.value.toString(),
        ),
      ).toList(),
    );
  }

  /// معلومات الحالة
  factory AppInfo.status({
    Key? key,
    required String title,
    required String status,
    required Color statusColor,
    String? description,
    DateTime? lastUpdate,
  }) {
    return AppInfo(
      key: key,
      title: title,
      subtitle: status,
      icon: Icons.info,
      description: description,
      items: lastUpdate != null ? [
        AppInfoItem(
          label: 'آخر تحديث',
          value: AppTheme.formatPrayerTime(lastUpdate),
        ),
      ] : null,
    );
  }

  /// معلومات الميزات
  factory AppInfo.features({
    Key? key,
    required String title,
    required List<String> features,
    IconData? icon,
  }) {
    return AppInfo(
      key: key,
      title: title,
      subtitle: '${features.length} ميزة',
      icon: icon ?? Icons.star,
      items: features.map((feature) => 
        AppInfoItem(
          label: feature,
          value: '',
          icon: Icons.check_circle,
        ),
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان والأيقونة
          Row(
            children: [
              if (customIcon != null)
                customIcon!
              else if (icon != null) ...[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withValues(alpha: 0.1),
                    borderRadius: AppTheme.radiusMd.radius,
                  ),
                  child: Icon(
                    icon!,
                    color: AppTheme.primary,
                    size: AppTheme.iconMd,
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
                      style: AppTheme.titleLarge.copyWith(
                        fontWeight: AppTheme.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      AppTheme.space1.h,
                      Text(
                        subtitle!,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              if (version != null) ...[
                AppTheme.space2.w,
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.space2,
                    vertical: AppTheme.space1,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.info.withValues(alpha: 0.1),
                    borderRadius: AppTheme.radiusFull.radius,
                  ),
                  child: Text(
                    'v$version',
                    style: AppTheme.caption.copyWith(
                      color: AppTheme.info,
                      fontWeight: AppTheme.medium,
                    ),
                  ),
                ),
              ],
            ],
          ),
          
          // الوصف
          if (description != null) ...[
            AppTheme.space3.h,
            Text(
              description!,
              style: AppTheme.bodyMedium.copyWith(
                height: 1.6,
              ),
            ),
          ],
          
          // العناصر
          if (items != null && items!.isNotEmpty) ...[
            AppTheme.space4.h,
            ...items!.map((item) => _buildInfoItem(item)),
          ],
          
          // الإجراءات
          if (actions != null && actions!.isNotEmpty) ...[
            AppTheme.space4.h,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: actions!.map((action) =>
                Padding(
                  padding: const EdgeInsets.only(left: AppTheme.space2),
                  child: action,
                ),
              ).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(AppInfoItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.space2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.icon != null) ...[
            Icon(
              item.icon!,
              size: AppTheme.iconSm,
              color: item.iconColor ?? AppTheme.primary,
            ),
            AppTheme.space2.w,
          ],
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: AppTheme.medium,
                  ),
                ),
                if (item.value.isNotEmpty) ...[
                  AppTheme.space1.h,
                  Text(
                    item.value,
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          if (item.trailing != null) ...[
            AppTheme.space2.w,
            item.trailing!,
          ],
        ],
      ),
    );
  }
}

/// عنصر معلومات
class AppInfoItem {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const AppInfoItem({
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.trailing,
    this.onTap,
  });
}

/// قائمة معلومات موحدة
class AppInfoList extends StatelessWidget {
  final List<AppInfo> items;
  final String? title;
  final EdgeInsets? padding;

  const AppInfoList({
    super.key,
    required this.items,
    this.title,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: padding ?? AppTheme.space4.paddingH,
            child: Text(
              title!,
              style: AppTheme.headlineMedium.copyWith(
                fontWeight: AppTheme.bold,
              ),
            ),
          ),
          AppTheme.space4.h,
        ],
        
        ...items.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.space3),
          child: item,
        )),
      ],
    );
  }
}

/// بطاقة إحصائية سريعة
class QuickStatsInfo extends StatelessWidget {
  final Map<String, dynamic> stats;
  final String? title;
  final IconData? icon;
  final Color? color;

  const QuickStatsInfo({
    super.key,
    required this.stats,
    this.title,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      useGradient: true,
      color: color ?? AppTheme.info,
      child: Column(
        children: [
          if (title != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon!,
                    color: Colors.white,
                    size: AppTheme.iconMd,
                  ),
                  AppTheme.space2.w,
                ],
                Text(
                  title!,
                  style: AppTheme.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.semiBold,
                  ),
                ),
              ],
            ),
            AppTheme.space4.h,
          ],
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: stats.entries.map((entry) => 
              _buildStatItem(entry.key, entry.value.toString()),
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.bold,
            fontFamily: AppTheme.numbersFont,
          ),
        ),
        AppTheme.space1.h,
        Text(
          label,
          style: AppTheme.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: AppTheme.medium,
          ),
        ),
      ],
    );
  }
}