// lib/features/settings/screens/settings_screen.dart

import 'package:flutter/material.dart';
import 'package:athkar_app/app/themes/index.dart';
import 'package:athkar_app/app/di/service_locator.dart';
import 'package:athkar_app/core/infrastructure/services/storage/storage_service.dart';


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const IslamicAppBar(title: 'الإعدادات'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان الرئيسي
            Text(
              'إعدادات التطبيق',
              style: context.headingStyle,
            ),
            
            Spaces.medium,
            
            // قائمة الإعدادات
            ..._buildSettingsSections(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSettingsSections(BuildContext context) {
    return [
      // المظهر والعرض
      _buildSettingsSection(
        context: context,
        title: 'المظهر والعرض',
        icon: Icons.palette_outlined,
        items: [
          _SettingsItem(
            title: 'السمة',
            subtitle: 'فاتح، داكن، أو تلقائي',
            icon: Icons.brightness_6_outlined,
            onTap: () => _navigateToThemeSettings(context),
            trailing: _getThemeModeText(),
          ),
          _SettingsItem(
            title: 'حجم الخط',
            subtitle: 'تكبير أو تصغير النصوص',
            icon: Icons.format_size_outlined,
            onTap: () => _navigateToDisplaySettings(context),
          ),
          _SettingsItem(
            title: 'اللغة',
            subtitle: 'العربية أو الإنجليزية',
            icon: Icons.language_outlined,
            onTap: () => _navigateToLanguageSettings(context),
            trailing: 'العربية',
          ),
        ],
      ),
      
      Spaces.large,
      
      // الإشعارات والتنبيهات
      _buildSettingsSection(
        context: context,
        title: 'الإشعارات والتنبيهات',
        icon: Icons.notifications_outlined,
        items: [
          _SettingsItem(
            title: 'إشعارات الصلاة',
            subtitle: 'تذكيرات أوقات الصلوات',
            icon: Icons.mosque_outlined,
            onTap: () => _navigateToNotificationSettings(context, 'prayer'),
          ),
          _SettingsItem(
            title: 'إشعارات الأذكار',
            subtitle: 'تذكيرات الأذكار اليومية',
            icon: Icons.menu_book_outlined,
            onTap: () => _navigateToNotificationSettings(context, 'athkar'),
          ),
          _SettingsItem(
            title: 'الإعدادات العامة',
            subtitle: 'إدارة جميع الإشعارات',
            icon: Icons.tune_outlined,
            onTap: () => _navigateToGeneralNotifications(context),
          ),
        ],
      ),
      
      Spaces.large,
      
      // الأذونات والصلاحيات
      _buildSettingsSection(
        context: context,
        title: 'الأذونات والصلاحيات',
        icon: Icons.security_outlined,
        items: [
          _SettingsItem(
            title: 'أذونات التطبيق',
            subtitle: 'إدارة أذونات الموقع والإشعارات',
            icon: Icons.admin_panel_settings_outlined,
            onTap: () => _navigateToPermissionsSettings(context),
          ),
          _SettingsItem(
            title: 'الخصوصية',
            subtitle: 'إعدادات الخصوصية والأمان',
            icon: Icons.privacy_tip_outlined,
            onTap: () => _navigateToPrivacySettings(context),
          ),
        ],
      ),
      
      Spaces.large,
      
      // التخزين والبيانات
      _buildSettingsSection(
        context: context,
        title: 'التخزين والبيانات',
        icon: Icons.storage_outlined,
        items: [
          _SettingsItem(
            title: 'إدارة البيانات',
            subtitle: 'النسخ الاحتياطي والاستعادة',
            icon: Icons.backup_outlined,
            onTap: () => _navigateToDataSettings(context),
          ),
          _SettingsItem(
            title: 'مسح البيانات',
            subtitle: 'إعادة تعيين إعدادات التطبيق',
            icon: Icons.delete_outline,
            onTap: () => _showClearDataDialog(context),
            isDestructive: true,
          ),
        ],
      ),
      
      Spaces.large,
      
      // الدعم والمعلومات
      _buildSettingsSection(
        context: context,
        title: 'الدعم والمعلومات',
        icon: Icons.help_outline,
        items: [
          _SettingsItem(
            title: 'حول التطبيق',
            subtitle: 'معلومات عن التطبيق والإصدار',
            icon: Icons.info_outline,
            onTap: () => _navigateToAboutSettings(context),
          ),
          _SettingsItem(
            title: 'مركز المساعدة',
            subtitle: 'الأسئلة الشائعة والدعم',
            icon: Icons.help_center_outlined,
            onTap: () => _navigateToHelpSettings(context),
          ),
          _SettingsItem(
            title: 'تقييم التطبيق',
            subtitle: 'شاركنا رأيك في التطبيق',
            icon: Icons.star_outline,
            onTap: () => _rateApp(context),
          ),
          _SettingsItem(
            title: 'مشاركة التطبيق',
            subtitle: 'أخبر الآخرين عن التطبيق',
            icon: Icons.share_outlined,
            onTap: () => _shareApp(context),
          ),
        ],
      ),
      
      Spaces.extraLarge,
      
      // معلومات الإصدار
      Center(
        child: Column(
          children: [
            Text(
              'تطبيق الأذكار',
              style: context.captionStyle.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
            Spaces.xs,
            Text(
              'الإصدار 1.0.0',
              style: context.captionStyle.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
      
      Spaces.large,
    ];
  }

  Widget _buildSettingsSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<_SettingsItem> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // عنوان القسم
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.smallPadding),
          child: Row(
            children: [
              Icon(
                icon,
                size: ThemeConstants.iconSm,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                title,
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                  fontWeight: ThemeConstants.fontSemiBold,
                ),
              ),
            ],
          ),
        ),
        
        Spaces.small,
        
        // العناصر
        IslamicCard.simple(
          color: context.cardColor,
          padding: EdgeInsets.zero,
          child: Column(
            children: items
                .map((item) => _buildSettingsItem(context, item))
                .expand((widget) => [widget, const SizedBox(height: 1)])
                .take(items.length * 2 - 1)
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(BuildContext context, _SettingsItem item) {
    return ListTile(
      leading: Icon(
        item.icon,
        color: item.isDestructive ? context.errorColor : context.secondaryTextColor,
      ),
      title: Text(
        item.title,
        style: context.bodyStyle.copyWith(
          color: item.isDestructive ? context.errorColor : null,
          fontWeight: ThemeConstants.fontMedium,
        ),
      ),
      subtitle: item.subtitle != null
          ? Text(
              item.subtitle!,
              style: context.captionStyle,
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.trailing != null) ...[
            Text(
              item.trailing!,
              style: context.captionStyle.copyWith(
                color: context.primaryColor,
                fontWeight: ThemeConstants.fontMedium,
              ),
            ),
            Spaces.smallH,
          ],
          Icon(
            Icons.arrow_forward_ios,
            size: ThemeConstants.iconXs,
            color: context.secondaryTextColor,
          ),
        ],
      ),
      onTap: item.onTap,
    );
  }

  // Navigation Methods
  void _navigateToThemeSettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings/theme');
  }

  void _navigateToDisplaySettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings/display');
  }

  void _navigateToLanguageSettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings/language');
  }

  void _navigateToNotificationSettings(BuildContext context, String type) {
    Navigator.pushNamed(context, '/settings/notifications/$type');
  }

  void _navigateToGeneralNotifications(BuildContext context) {
    Navigator.pushNamed(context, '/settings/notifications');
  }

  void _navigateToPermissionsSettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings/permissions');
  }

  void _navigateToPrivacySettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings/privacy');
  }

  void _navigateToDataSettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings/data');
  }

  void _navigateToAboutSettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings/about');
  }

  void _navigateToHelpSettings(BuildContext context) {
    Navigator.pushNamed(context, '/settings/help');
  }

  // Helper Methods
  String _getThemeModeText() {
    switch (AppTheme.themeModeNotifier.value) {
      case ThemeMode.light:
        return 'فاتح';
      case ThemeMode.dark:
        return 'داكن';
      case ThemeMode.system:
        return 'تلقائي';
    }
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح البيانات'),
        content: const Text(
          'هل أنت متأكد من رغبتك في مسح جميع بيانات التطبيق؟\n'
          'هذا الإجراء لا يمكن التراجع عنه.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _clearAppData(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.errorColor,
            ),
            child: const Text('مسح'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAppData(BuildContext context) async {
    try {
      final storage = getIt<StorageService>();
      await storage.clear();
      
      if (context.mounted) {
        context.showSuccessMessage('تم مسح البيانات بنجاح');
      }
    } catch (e) {
      if (context.mounted) {
        context.showErrorMessage('حدث خطأ أثناء مسح البيانات');
      }
    }
  }

  void _rateApp(BuildContext context) {
    context.showInfoMessage('سيتم فتح متجر التطبيقات');
  }

  void _shareApp(BuildContext context) {
    context.showInfoMessage('سيتم مشاركة رابط التطبيق');
  }
}

// Data class for settings items
class _SettingsItem {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final String? trailing;
  final bool isDestructive;

  const _SettingsItem({
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
    this.trailing,
    this.isDestructive = false,
  });
}