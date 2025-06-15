// lib/features/athkar/screens/notification_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/themes/app_theme.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';
import '../../../core/infrastructure/services/notifications/notification_manager.dart';

class AthkarNotificationSettingsScreen extends StatefulWidget {
  const AthkarNotificationSettingsScreen({super.key});

  @override
  State<AthkarNotificationSettingsScreen> createState() => _AthkarNotificationSettingsScreenState();
}

class _AthkarNotificationSettingsScreenState extends State<AthkarNotificationSettingsScreen> {
  late final AthkarService _service;
  late final PermissionService _permissionService;
  late Future<List<AthkarCategory>> _futureCategories;
  final Map<String, bool> _enabled = {};
  final Map<String, TimeOfDay> _customTimes = {};
  bool _saving = false;
  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _permissionService = getIt<PermissionService>();
    _loadData();
  }

  Future<void> _loadData() async {
    // التحقق من الصلاحيات
    final status = await _permissionService.checkPermissionStatus(
      AppPermissionType.notification,
    );
    _hasPermission = status == AppPermissionStatus.granted;

    // تحميل الفئات
    _futureCategories = _service.loadCategories().then((cats) {
      final enabledIds = _service.getEnabledReminderCategories();
      for (final c in cats) {
        _enabled[c.id] = enabledIds.contains(c.id);
        if (c.notifyTime != null) {
          _customTimes[c.id] = c.notifyTime!;
        }
      }
      return cats;
    });
  }

  Future<void> _requestPermission() async {
    final status = await _permissionService.requestPermission(
      AppPermissionType.notification,
    );
    
    if (status == AppPermissionStatus.granted) {
      setState(() => _hasPermission = true);
      context.showSuccessSnackBar('تم تفعيل الإشعارات بنجاح');
    } else if (status == AppPermissionStatus.permanentlyDenied) {
      final shouldOpenSettings = await AppInfoDialog.showConfirmation(
        context: context,
        title: 'الإشعارات مطلوبة',
        content: 'يرجى تفعيل الإشعارات من إعدادات التطبيق لتلقي تذكيرات الأذكار',
        confirmText: 'فتح الإعدادات',
        cancelText: 'لاحقاً',
        icon: Icons.notifications_off,
      );
      
      if (shouldOpenSettings == true) {
        await _permissionService.openAppSettings();
      }
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await _service.updateReminderSettings(_enabled);
      
      // جدولة التذكيرات للفئات المفعلة
      for (final entry in _enabled.entries) {
        if (entry.value && _customTimes.containsKey(entry.key)) {
          final category = (await _service.loadCategories())
              .firstWhere((c) => c.id == entry.key);
          
          await NotificationManager.instance.scheduleAthkarReminder(
            categoryId: category.id,
            categoryName: category.title,
            time: _customTimes[entry.key]!,
          );
        } else if (!entry.value) {
          await NotificationManager.instance.cancelAthkarReminder(entry.key);
        }
      }
      
      if (mounted) {
        context.showSuccessSnackBar('تم حفظ الإعدادات بنجاح');
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) context.showErrorSnackBar('حدث خطأ في حفظ الإعدادات');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _selectTime(String categoryId) async {
    final initialTime = _customTimes[categoryId] ?? TimeOfDay.now();
    final time = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: context.cardColor,
              hourMinuteTextColor: context.primaryColor,
              dayPeriodTextColor: context.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (time != null) {
      setState(() {
        _customTimes[categoryId] = time;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar.simple(
        title: 'إشعارات الأذكار',
        actions: [
          if (_hasPermission)
            TextButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.primaryColor,
                      ),
                    )
                  : Text(
                      'حفظ',
                      style: TextStyle(
                        color: context.primaryColor,
                        fontWeight: ThemeConstants.semiBold,
                      ),
                    ),
            ),
        ],
      ),
      body: FutureBuilder<List<AthkarCategory>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: AppLoading.circular());
          }
          
          final categories = snapshot.data!;
          
          return Column(
            children: [
              // تنبيه الصلاحيات
              if (!_hasPermission)
                Container(
                  margin: const EdgeInsets.all(ThemeConstants.space4),
                  child: AppNoticeCard(
                    type: NoticeType.warning,
                    title: 'الإشعارات غير مفعلة',
                    message: 'يجب تفعيل الإشعارات لتلقي تذكيرات الأذكار',
                    action: AppButton.primary(
                      text: 'تفعيل الإشعارات',
                      onPressed: _requestPermission,
                      size: ButtonSize.small,
                    ),
                  ),
                ),
              
              // قائمة الفئات
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(ThemeConstants.space4),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => ThemeConstants.space3.h,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final enabled = _enabled[category.id] ?? false;
                    final time = _customTimes[category.id];
                    
                    return _NotificationSettingCard(
                      category: category,
                      enabled: enabled && _hasPermission,
                      time: time,
                      onToggle: _hasPermission
                          ? (value) {
                              HapticFeedback.lightImpact();
                              setState(() => _enabled[category.id] = value);
                            }
                          : null,
                      onTimeSelect: _hasPermission && enabled
                          ? () => _selectTime(category.id)
                          : null,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// بطاقة إعداد التنبيه
class _NotificationSettingCard extends StatelessWidget {
  final AthkarCategory category;
  final bool enabled;
  final TimeOfDay? time;
  final ValueChanged<bool>? onToggle;
  final VoidCallback? onTimeSelect;

  const _NotificationSettingCard({
    required this.category,
    required this.enabled,
    this.time,
    this.onToggle,
    this.onTimeSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: enabled
              ? context.primaryColor.withValues(alpha: 0.3)
              : context.dividerColor,
        ),
        boxShadow: enabled ? ThemeConstants.shadowSm : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.space4),
        child: Row(
          children: [
            // الأيقونة
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: enabled
                    ? context.primaryColor.withValues(alpha: 0.1)
                    : context.surfaceColor,
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
              child: Icon(
                category.icon,
                color: enabled ? context.primaryColor : context.textSecondaryColor,
              ),
            ),
            
            ThemeConstants.space3.w,
            
            // المحتوى
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: context.titleMedium?.copyWith(
                      fontWeight: ThemeConstants.semiBold,
                    ),
                  ),
                  if (time != null) ...[
                    ThemeConstants.space1.h,
                    InkWell(
                      onTap: onTimeSelect,
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: ThemeConstants.space1,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: ThemeConstants.iconXs,
                              color: enabled
                                  ? context.primaryColor
                                  : context.textSecondaryColor,
                            ),
                            ThemeConstants.space1.w,
                            Text(
                              time!.format(context),
                              style: context.bodyMedium?.copyWith(
                                color: enabled
                                    ? context.primaryColor
                                    : context.textSecondaryColor,
                                fontWeight: ThemeConstants.medium,
                              ),
                            ),
                            if (onTimeSelect != null) ...[
                              ThemeConstants.space1.w,
                              Icon(
                                Icons.edit,
                                size: ThemeConstants.iconXs,
                                color: context.primaryColor,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ] else
                    Text(
                      'لا يوجد وقت محدد',
                      style: context.bodySmall?.copyWith(
                        color: context.textSecondaryColor,
                      ),
                    ),
                ],
              ),
            ),
            
            // المفتاح
            Switch(
              value: enabled,
              onChanged: onToggle,
              activeColor: context.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}