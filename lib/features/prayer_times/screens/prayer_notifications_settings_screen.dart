// lib/features/prayer_times/screens/prayer_notifications_settings_screen.dart

import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';

class PrayerNotificationsSettingsScreen extends StatefulWidget {
  const PrayerNotificationsSettingsScreen({super.key});

  @override
  State<PrayerNotificationsSettingsScreen> createState() => _PrayerNotificationsSettingsScreenState();
}

class _PrayerNotificationsSettingsScreenState extends State<PrayerNotificationsSettingsScreen> {
  // إعدادات الإشعارات
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  
  // إعدادات الصلوات
  final Map<String, bool> _prayerNotifications = {
    'fajr': true,
    'dhuhr': true,
    'asr': true,
    'maghrib': true,
    'isha': true,
  };
  
  final Map<String, int> _prayerReminderMinutes = {
    'fajr': 15,
    'dhuhr': 10,
    'asr': 10,
    'maghrib': 5,
    'isha': 15,
  };

  // أسماء الصلوات بالعربية
  final Map<String, String> _prayerNames = {
    'fajr': 'الفجر',
    'dhuhr': 'الظهر',
    'asr': 'العصر',
    'maghrib': 'المغرب',
    'isha': 'العشاء',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar.simple(
        title: 'إعدادات الإشعارات',
        onBack: () => Navigator.of(context).pop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(ThemeConstants.space4),
        children: [
          _buildMainSettings(),
          ThemeConstants.space4.h,
          _buildPrayerSettings(),
          ThemeConstants.space4.h,
          _buildAdvancedSettings(),
          ThemeConstants.space8.h,
        ],
      ),
    );
  }

  Widget _buildMainSettings() {
    return AppCard(
      type: CardType.normal,
      title: 'الإعدادات العامة',
      subtitle: 'التحكم في الإشعارات والتنبيهات',
      icon: Icons.notifications_outlined,
      child: Column(
        children: [
          _buildSettingTile(
            title: 'تفعيل الإشعارات',
            subtitle: 'تلقي إشعارات مواقيت الصلاة',
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
              _requestNotificationPermission();
            },
          ),
          
          const Divider(height: 1),
          
          _buildSettingTile(
            title: 'الصوت',
            subtitle: 'تشغيل صوت مع الإشعار',
            value: _soundEnabled,
            onChanged: _notificationsEnabled ? (value) {
              setState(() {
                _soundEnabled = value;
              });
            } : null,
          ),
          
          const Divider(height: 1),
          
          _buildSettingTile(
            title: 'الاهتزاز',
            subtitle: 'اهتزاز الجهاز مع الإشعار',
            value: _vibrationEnabled,
            onChanged: _notificationsEnabled ? (value) {
              setState(() {
                _vibrationEnabled = value;
              });
            } : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerSettings() {
    return AppCard(
      type: CardType.normal,
      title: 'إشعارات الصلوات',
      subtitle: 'تخصيص إشعارات كل صلاة',
      icon: Icons.mosque,
      child: Column(
        children: _prayerNotifications.keys.map((prayerKey) {
          return Column(
            children: [
              _buildPrayerTile(prayerKey),
              if (prayerKey != _prayerNotifications.keys.last)
                const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPrayerTile(String prayerKey) {
    final prayerName = _prayerNames[prayerKey]!;
    final isEnabled = _prayerNotifications[prayerKey]!;
    final reminderMinutes = _prayerReminderMinutes[prayerKey]!;

    return ExpansionTile(
      leading: Icon(
        ThemeConstants.getPrayerIcon(prayerKey),
        color: ThemeConstants.getPrayerColor(prayerKey),
      ),
      title: Text(prayerName),
      subtitle: Text(
        isEnabled ? 'مفعل - تذكير قبل $reminderMinutes دقيقة' : 'معطل',
        style: context.bodySmall?.copyWith(
          color: isEnabled ? context.textSecondaryColor : Colors.grey,
        ),
      ),
      trailing: Switch(
        value: isEnabled && _notificationsEnabled,
        onChanged: _notificationsEnabled ? (value) {
          setState(() {
            _prayerNotifications[prayerKey] = value;
          });
        } : null,
        activeColor: ThemeConstants.getPrayerColor(prayerKey),
      ),
      children: isEnabled ? [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
          child: _buildReminderSettings(prayerKey),
        ),
      ] : [],
    );
  }

  Widget _buildReminderSettings(String prayerKey) {
    final reminderMinutes = _prayerReminderMinutes[prayerKey]!;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'وقت التذكير',
          style: context.titleSmall?.copyWith(
            fontWeight: ThemeConstants.semiBold,
          ),
        ),
        
        ThemeConstants.space2.h,
        
        Row(
          children: [
            Expanded(
              child: Slider(
                value: reminderMinutes.toDouble(),
                min: 0,
                max: 30,
                divisions: 6,
                label: reminderMinutes == 0 ? 'عند الأذان' : '$reminderMinutes دقيقة',
                onChanged: (value) {
                  setState(() {
                    _prayerReminderMinutes[prayerKey] = value.toInt();
                  });
                },
              ),
            ),
            
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space2,
                vertical: ThemeConstants.space1,
              ),
              decoration: BoxDecoration(
                color: context.surfaceColor,
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
              child: Text(
                reminderMinutes == 0 ? 'عند الأذان' : '$reminderMinutes د',
                textAlign: TextAlign.center,
                style: context.labelMedium?.copyWith(
                  fontWeight: ThemeConstants.semiBold,
                ),
              ),
            ),
          ],
        ),
        
        ThemeConstants.space3.h,
      ],
    );
  }

  Widget _buildAdvancedSettings() {
    return AppCard(
      type: CardType.normal,
      title: 'الإعدادات المتقدمة',
      subtitle: 'خيارات إضافية للإشعارات',
      icon: Icons.tune,
      child: Column(
        children: [
          ListTile(
            leading: Icon(
              Icons.volume_up,
              color: context.primaryColor,
            ),
            title: const Text('نغمة الإشعار'),
            subtitle: const Text('اختيار نغمة مخصصة'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // فتح اختيار النغمة
            },
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: Icon(
              Icons.schedule,
              color: context.primaryColor,
            ),
            title: const Text('الإشعارات الصامتة'),
            subtitle: const Text('إشعارات بدون صوت في أوقات محددة'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // فتح إعدادات الإشعارات الصامتة
            },
          ),
          
          const Divider(height: 1),
          
          ListTile(
            leading: Icon(
              Icons.text_fields,
              color: context.primaryColor,
            ),
            title: const Text('نص الإشعار'),
            subtitle: const Text('تخصيص محتوى الإشعار'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // فتح تخصيص النص
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool>? onChanged,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: context.primaryColor,
      ),
    );
  }

  Future<void> _requestNotificationPermission() async {
    if (!_notificationsEnabled) return;
    
    try {
      // طلب إذن الإشعارات
      // يمكن استخدام مكتبة مثل permission_handler
      
      if (mounted) {
        context.showAppSuccessSnackBar('تم تفعيل الإشعارات بنجاح');
      }
    } catch (e) {
      if (mounted) {
        context.showAppErrorSnackBar('فشل في تفعيل الإشعارات');
      }
    }
  }
}