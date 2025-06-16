// lib/features/settings/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final StorageService _storage;
  
  bool _isDarkMode = false;
  String _selectedLanguage = 'ar';
  
  @override
  void initState() {
    super.initState();
    _storage = getIt<StorageService>();
    _loadSettings();
  }
  
  void _loadSettings() {
    setState(() {
      _isDarkMode = _storage.getBool('theme_mode') ?? false;
      _selectedLanguage = _storage.getString('app_language') ?? 'ar';
    });
  }
  
  Future<void> _toggleTheme(bool value) async {
    setState(() => _isDarkMode = value);
    await _storage.setBool('theme_mode', value);
    // TODO: تطبيق تغيير الثيم على التطبيق
  }
  
  Future<void> _changeLanguage(String? value) async {
    if (value == null) return;
    setState(() => _selectedLanguage = value);
    await _storage.setString('app_language', value);
    // TODO: تطبيق تغيير اللغة على التطبيق
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar.simple(
        title: 'الإعدادات',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // إعدادات الإشعارات
            _SettingsSection(
              title: 'الإشعارات',
              children: [
                _SettingsTile(
                  icon: Icons.notifications_outlined,
                  title: 'إشعارات الصلاة',
                  subtitle: 'تخصيص تنبيهات أوقات الصلاة',
                  onTap: () => Navigator.pushNamed(
                    context, 
                    AppRouter.prayerNotificationsSettings,
                  ),
                ),
                _SettingsTile(
                  icon: Icons.menu_book_outlined,
                  title: 'إشعارات الأذكار',
                  subtitle: 'تخصيص تذكيرات الأذكار اليومية',
                  onTap: () => Navigator.pushNamed(
                    context, 
                    AppRouter.athkarNotificationsSettings,
                  ),
                ),
              ],
            ),
            
            // إعدادات المظهر
            _SettingsSection(
              title: 'المظهر',
              children: [
                _SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'الوضع الليلي',
                  subtitle: 'تفعيل الثيم الداكن',
                  trailing: Switch(
                    value: _isDarkMode,
                    onChanged: _toggleTheme,
                    activeColor: context.primaryColor,
                  ),
                ),
                _SettingsTile(
                  icon: Icons.language_outlined,
                  title: 'اللغة',
                  subtitle: 'اختر لغة التطبيق',
                  trailing: DropdownButton<String>(
                    value: _selectedLanguage,
                    onChanged: _changeLanguage,
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(
                        value: 'ar',
                        child: Text('العربية'),
                      ),
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // إعدادات عامة
            _SettingsSection(
              title: 'عام',
              children: [
                _SettingsTile(
                  icon: Icons.location_on_outlined,
                  title: 'الموقع',
                  subtitle: 'تحديد موقعك لحساب أوقات الصلاة',
                  onTap: () {
                    // TODO: فتح إعدادات الموقع
                    context.showInfoSnackBar('قريباً');
                  },
                ),
                _SettingsTile(
                  icon: Icons.battery_saver_outlined,
                  title: 'إعدادات البطارية',
                  subtitle: 'إدارة استهلاك البطارية',
                  onTap: () {
                    // TODO: فتح إعدادات البطارية
                    context.showInfoSnackBar('قريباً');
                  },
                ),
              ],
            ),
            
            // حول التطبيق
            _SettingsSection(
              title: 'حول',
              children: [
                _SettingsTile(
                  icon: Icons.share_outlined,
                  title: 'مشاركة التطبيق',
                  subtitle: 'شارك التطبيق مع الأصدقاء',
                  onTap: () {
                    // TODO: مشاركة التطبيق
                    context.showInfoSnackBar('قريباً');
                  },
                ),
                _SettingsTile(
                  icon: Icons.star_outline,
                  title: 'تقييم التطبيق',
                  subtitle: 'قيم التطبيق على المتجر',
                  onTap: () {
                    // TODO: فتح صفحة التقييم
                    context.showInfoSnackBar('قريباً');
                  },
                ),
                _SettingsTile(
                  icon: Icons.info_outline,
                  title: 'عن التطبيق',
                  subtitle: 'معلومات حول التطبيق',
                  onTap: () {
                    _showAboutDialog();
                  },
                ),
              ],
            ),
            
            // مساحة إضافية
            ThemeConstants.space8.h,
          ],
        ),
      ),
    );
  }
  
  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        ),
        title: Row(
          children: [
            Icon(
              Icons.auto_awesome,
              color: context.primaryColor,
            ),
            ThemeConstants.space2.w,
            const Text('تطبيق الأذكار'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'الإصدار 1.0.0',
              style: context.bodyLarge,
            ),
            ThemeConstants.space2.h,
            Text(
              'تطبيق شامل للمسلم يحتوي على الأذكار اليومية ومواقيت الصلاة واتجاه القبلة وأكثر.',
              style: context.bodyMedium,
            ),
            ThemeConstants.space3.h,
            Text(
              '© 2024 جميع الحقوق محفوظة',
              style: context.labelSmall?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}

// قسم في الإعدادات
class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            ThemeConstants.space4,
            ThemeConstants.space4,
            ThemeConstants.space4,
            ThemeConstants.space2,
          ),
          child: Text(
            title,
            style: context.labelLarge?.copyWith(
              color: context.primaryColor,
              fontWeight: ThemeConstants.semiBold,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            boxShadow: ThemeConstants.shadowSm,
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

// عنصر في الإعدادات
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          child: Row(
            children: [
              // الأيقونة
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: context.primaryColor,
                  size: ThemeConstants.iconMd,
                ),
              ),
              
              ThemeConstants.space3.w,
              
              // المحتوى
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: context.titleMedium,
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
              
              // الزائدة
              if (trailing != null)
                trailing!
              else if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: ThemeConstants.iconSm,
                  color: context.textSecondaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}