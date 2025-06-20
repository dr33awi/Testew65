// lib/features/settings/screens/notifications_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:athkar_app/app/themes/index.dart';
import 'package:athkar_app/core/infrastructure/services/notifications/notification_manager.dart';
import 'package:athkar_app/core/infrastructure/services/notifications/models/notification_models.dart';

class NotificationsSettingsScreen extends StatefulWidget {
  const NotificationsSettingsScreen({super.key});

  @override
  State<NotificationsSettingsScreen> createState() => _NotificationsSettingsScreenState();
}

class _NotificationsSettingsScreenState extends State<NotificationsSettingsScreen> {
  NotificationSettings? _currentSettings;
  bool _isLoading = true;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await NotificationManager.instance.getSettings();
      final permission = await NotificationManager.instance.hasPermission();
      
      setState(() {
        _currentSettings = settings;
        _hasPermission = permission;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        context.showErrorMessage('حدث خطأ في تحميل الإعدادات');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        appBar: IslamicAppBar(title: 'إعدادات الإشعارات'),
        body: Center(child: IslamicLoading(message: 'جاري التحميل...')),
      );
    }

    if (_currentSettings == null) {
      return Scaffold(
        appBar: const IslamicAppBar(title: 'إعدادات الإشعارات'),
        body: Center(
          child: EmptyState(
            icon: Icons.error_outline,
            title: 'خطأ في التحميل',
            subtitle: 'لم نتمكن من تحميل إعدادات الإشعارات',
            action: IslamicButton.primary(
              text: 'إعادة المحاولة',
              onPressed: _loadSettings,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: const IslamicAppBar(title: 'إعدادات الإشعارات'),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // حالة الأذونات
            if (!_hasPermission) _buildPermissionWarning(context),
            
            // الإعدادات العامة
            _buildGeneralSettings(context),
            
            Spaces.large,
            
            // إعدادات أوقات الهدوء
            _buildQuietTimeSettings(context),
            
            Spaces.large,
            
            // إعدادات البطارية
            _buildBatterySettings(context),
            
            Spaces.large,
            
            // إعدادات متقدمة
            _buildAdvancedSettings(context),
            
            Spaces.large,
            
            // أزرار الإجراءات
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionWarning(BuildContext context) {
    return Column(
      children: [
        IslamicCard(
          color: context.warningColor.withValues(alpha: 0.1),
          border: Border.all(color: context.warningColor.withValues(alpha: 0.3)),
          child: Row(
            children: [
              Icon(
                Icons.warning_outlined,
                color: context.warningColor,
              ),
              Spaces.mediumH,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إذن الإشعارات مطلوب',
                      style: context.bodyStyle.copyWith(
                        fontWeight: ThemeConstants.fontSemiBold,
                        color: context.warningColor,
                      ),
                    ),
                    Spaces.xs,
                    Text(
                      'يحتاج التطبيق إذن الإشعارات لإرسال التذكيرات',
                      style: context.captionStyle,
                    ),
                  ],
                ),
              ),
              Spaces.smallH,
              IslamicButton.small(
                text: 'السماح',
                onPressed: _requestPermission,
              ),
            ],
          ),
        ),
        Spaces.large,
      ],
    );
  }

  Widget _buildGeneralSettings(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.notifications_outlined,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'الإعدادات العامة',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          // تفعيل/تعطيل الإشعارات
          IslamicSwitch(
            value: _currentSettings!.enabled,
            title: 'تفعيل الإشعارات',
            subtitle: 'تشغيل أو إيقاف جميع الإشعارات',
            onChanged: _hasPermission ? _toggleNotifications : null,
          ),
          
          if (_currentSettings!.enabled) ...[
            const Divider(),
            
            // الاهتزاز
            IslamicSwitch(
              value: _currentSettings!.vibrationEnabled,
              title: 'الاهتزاز',
              subtitle: 'اهتزاز الجهاز مع الإشعارات',
              onChanged: _toggleVibration,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuietTimeSettings(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bedtime_outlined,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'وقت الهدوء',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          Text(
            'تعيين فترة زمنية لإيقاف الإشعارات (مثل وقت النوم)',
            style: context.captionStyle,
          ),
          
          Spaces.medium,
          
          Row(
            children: [
              Expanded(
                child: _buildTimeSelector(
                  context: context,
                  label: 'بداية الهدوء',
                  time: _currentSettings!.quietTimeStart,
                  onTimeSelected: _setQuietTimeStart,
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: _buildTimeSelector(
                  context: context,
                  label: 'نهاية الهدوء',
                  time: _currentSettings!.quietTimeEnd,
                  onTimeSelected: _setQuietTimeEnd,
                ),
              ),
            ],
          ),
          
          if (_currentSettings!.quietTimeStart != null && 
              _currentSettings!.quietTimeEnd != null) ...[
            Spaces.small,
            Container(
              padding: EdgeInsets.all(context.smallPadding),
              decoration: BoxDecoration(
                color: context.infoColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(context.smallRadius),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: ThemeConstants.iconSm,
                    color: context.infoColor,
                  ),
                  Spaces.smallH,
                  Expanded(
                    child: Text(
                      'سيتم إيقاف الإشعارات من ${_formatTime(_currentSettings!.quietTimeStart!)} '
                      'إلى ${_formatTime(_currentSettings!.quietTimeEnd!)}',
                      style: context.captionStyle.copyWith(
                        color: context.infoColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBatterySettings(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.battery_saver_outlined,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'إعدادات البطارية',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          Text(
            'تحسين استهلاك البطارية من خلال تقليل الإشعارات عند انخفاض مستوى البطارية',
            style: context.captionStyle,
          ),
          
          Spaces.medium,
          
          Row(
            children: [
              Expanded(
                child: Text(
                  'الحد الأدنى لمستوى البطارية',
                  style: context.bodyStyle,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: context.smallPadding,
                  vertical: context.smallPadding / 2,
                ),
                decoration: BoxDecoration(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(context.smallRadius),
                ),
                child: Text(
                  '${_currentSettings!.minBatteryLevel ?? 15}%',
                  style: context.bodyStyle.copyWith(
                    color: context.primaryColor,
                    fontWeight: ThemeConstants.fontSemiBold,
                  ),
                ),
              ),
            ],
          ),
          
          Spaces.small,
          
          Slider(
            value: (_currentSettings!.minBatteryLevel ?? 15).toDouble(),
            min: 0,
            max: 50,
            divisions: 10,
            label: '${_currentSettings!.minBatteryLevel ?? 15}%',
            onChanged: _setBatteryLevel,
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings(BuildContext context) {
    return IslamicCard.simple(
      color: context.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tune_outlined,
                color: context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'إعدادات متقدمة',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.category_outlined,
              color: context.secondaryTextColor,
            ),
            title: const Text('إشعارات الصلاة'),
            subtitle: const Text('إعدادات خاصة بتذكيرات الصلوات'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _navigateToPrayerNotifications(context),
          ),
          
          const Divider(),
          
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.menu_book_outlined,
              color: context.secondaryTextColor,
            ),
            title: const Text('إشعارات الأذكار'),
            subtitle: const Text('إعدادات خاصة بتذكيرات الأذكار'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _navigateToAthkarNotifications(context),
          ),
          
          const Divider(),
          
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.history_outlined,
              color: context.secondaryTextColor,
            ),
            title: const Text('سجل الإشعارات'),
            subtitle: const Text('عرض الإشعارات المرسلة مؤخراً'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _navigateToNotificationHistory(context),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: IslamicButton.primary(
            text: 'حفظ الإعدادات',
            icon: Icons.save_outlined,
            onPressed: _saveSettings,
          ),
        ),
        
        Spaces.medium,
        
        SizedBox(
          width: double.infinity,
          child: IslamicButton.outlined(
            text: 'اختبار الإشعار',
            icon: Icons.notification_add_outlined,
            onPressed: _testNotification,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelector({
    required BuildContext context,
    required String label,
    required TimeOfDay? time,
    required Function(TimeOfDay) onTimeSelected,
  }) {
    return GestureDetector(
      onTap: () => _selectTime(context, time, onTimeSelected),
      child: Container(
        padding: EdgeInsets.all(context.mediumPadding),
        decoration: BoxDecoration(
          color: context.backgroundColor,
          borderRadius: BorderRadius.circular(context.smallRadius),
          border: Border.all(color: context.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: context.captionStyle,
            ),
            Spaces.xs,
            Text(
              time != null ? _formatTime(time) : 'غير محدد',
              style: context.bodyStyle.copyWith(
                fontWeight: ThemeConstants.fontSemiBold,
                color: time != null ? null : context.secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Methods
  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Action Methods
  Future<void> _requestPermission() async {
    try {
      final granted = await NotificationManager.instance.requestPermission();
      if (mounted) {
        setState(() {
          _hasPermission = granted;
        });
        
        if (granted) {
          context.showSuccessMessage('تم منح إذن الإشعارات');
        } else {
          context.showErrorMessage('لم يتم منح إذن الإشعارات');
        }
      }
    } catch (e) {
      if (mounted) {
        context.showErrorMessage('حدث خطأ أثناء طلب الإذن');
      }
    }
  }

  void _toggleNotifications(bool value) async {
    try {
      await NotificationManager.instance.setEnabled(value);
      if (mounted) {
        setState(() {
          _currentSettings = _currentSettings!.copyWith(enabled: value);
        });
        
        context.showSuccessMessage(
          value ? 'تم تفعيل الإشعارات' : 'تم إيقاف الإشعارات'
        );
      }
    } catch (e) {
      if (mounted) {
        context.showErrorMessage('حدث خطأ أثناء تحديث الإعدادات');
      }
    }
  }

  void _toggleVibration(bool value) {
    setState(() {
      _currentSettings = _currentSettings!.copyWith(vibrationEnabled: value);
    });
  }

  Future<void> _selectTime(
    BuildContext context,
    TimeOfDay? currentTime,
    Function(TimeOfDay) onSelected,
  ) async {
    final time = await showTimePicker(
      context: context,
      initialTime: currentTime ?? TimeOfDay.now(),
    );
    
    if (time != null) {
      onSelected(time);
    }
  }

  void _setQuietTimeStart(TimeOfDay time) {
    setState(() {
      _currentSettings = _currentSettings!.copyWith(quietTimeStart: time);
    });
  }

  void _setQuietTimeEnd(TimeOfDay time) {
    setState(() {
      _currentSettings = _currentSettings!.copyWith(quietTimeEnd: time);
    });
  }

  void _setBatteryLevel(double value) {
    setState(() {
      _currentSettings = _currentSettings!.copyWith(
        minBatteryLevel: value.round(),
      );
    });
  }

  Future<void> _saveSettings() async {
    try {
      await NotificationManager.instance.updateSettings(_currentSettings!);
      if (mounted) {
        context.showSuccessMessage('تم حفظ إعدادات الإشعارات');
      }
    } catch (e) {
      if (mounted) {
        context.showErrorMessage('حدث خطأ أثناء حفظ الإعدادات');
      }
    }
  }

  Future<void> _testNotification() async {
    try {
      await NotificationManager.instance.showInstantNotification(
        title: 'اختبار الإشعار',
        body: 'هذا إشعار تجريبي للتأكد من عمل النظام',
      );
      
      if (mounted) {
        context.showSuccessMessage('تم إرسال إشعار تجريبي');
      }
    } catch (e) {
      if (mounted) {
        context.showErrorMessage('حدث خطأ أثناء إرسال الإشعار التجريبي');
      }
    }
  }

  // Navigation Methods
  void _navigateToPrayerNotifications(BuildContext context) {
    Navigator.pushNamed(context, '/settings/notifications/prayer');
  }

  void _navigateToAthkarNotifications(BuildContext context) {
    Navigator.pushNamed(context, '/settings/notifications/athkar');
  }

  void _navigateToNotificationHistory(BuildContext context) {
    Navigator.pushNamed(context, '/settings/notifications/history');
  }
}