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
    // التحقق من الإذن
    _hasPermission = await _permissionService.checkNotificationPermission();
    
    // تهيئة الفئات
    _futureCategories = _service.loadCategories().then((cats) {
      final enabledIds = _service.getEnabledReminderCategories();
      for (final c in cats) {
        _enabled[c.id] = enabledIds.contains(c.id);
        if (c.notifyTime != null) {
          _customTimes[c.id] = c.notifyTime!;
        }
      }
      return cats.where((c) => c.notifyTime != null).toList();
    });
  }

  Future<void> _requestPermission() async {
    final granted = await _permissionService.requestNotificationPermission();
    setState(() => _hasPermission = granted);
    if (granted) {
      context.showSuccessSnackBar('تم منح إذن الإشعارات');
    }
  }

  Future<void> _toggleCategory(String categoryId, bool value) async {
    setState(() {
      _enabled[categoryId] = value;
    });
    await _saveChanges();
  }

  Future<void> _updateTime(String categoryId, TimeOfDay time) async {
    setState(() {
      _customTimes[categoryId] = time;
    });
    await _saveChanges();
  }

  Future<void> _saveChanges() async {
    if (_saving) return;
    
    setState(() => _saving = true);
    
    try {
      // حفظ الفئات المفعلة
      final enabledIds = _enabled.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();
      await _service.setEnabledReminderCategories(enabledIds);
      
      // جدولة الإشعارات
      final notificationManager = getIt<NotificationManager>();
      await notificationManager.cancelAllNotifications();
      
      // جدولة إشعارات للفئات المفعلة
      final categories = await _futureCategories;
      for (final category in categories) {
        if (_enabled[category.id] ?? false) {
          final time = _customTimes[category.id] ?? category.notifyTime;
          if (time != null) {
            await notificationManager.scheduleAthkarReminder(
              categoryId: category.id,
              title: category.title,
              body: 'حان وقت ${category.title}',
              time: time,
            );
          }
        }
      }
    } catch (e) {
      context.showErrorSnackBar('حدث خطأ في حفظ الإعدادات');
    } finally {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar.simple(
        title: 'إشعارات الأذكار',
      ),
      body: FutureBuilder<List<AthkarCategory>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: AppLoading.page(
                message: 'جاري تحميل الإعدادات...',
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return AppEmptyState.noData(
              message: 'لا توجد فئات متاحة للتنبيهات',
            );
          }

          final categories = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // بطاقة تنبيه الإذن
                if (!_hasPermission)
                  AppNoticeCard(
                    type: NoticeType.warning,
                    title: 'إذن الإشعارات مطلوب',
                    message: 'يجب السماح بالإشعارات لتلقي تنبيهات الأذكار',
                    margin: const EdgeInsets.only(bottom: ThemeConstants.space4),
                    action: AppButton.primary(
                      text: 'السماح بالإشعارات',
                      onPressed: _requestPermission,
                      size: ButtonSize.small,
                      icon: Icons.notifications,
                    ),
                  ),

                // العنوان
                Text(
                  'اختر الأذكار التي تريد التذكير بها',
                  style: context.titleMedium,
                ),
                
                ThemeConstants.space2.h,
                
                Text(
                  'سيتم تذكيرك بهذه الأذكار في الأوقات المحددة يومياً',
                  style: context.bodyMedium?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),

                ThemeConstants.space4.h,

                // قائمة الفئات
                ...categories.map((category) => _buildCategoryCard(category)),
                
                // مساحة إضافية
                ThemeConstants.space8.h,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(AthkarCategory category) {
    final isEnabled = _enabled[category.id] ?? false;
    final time = _customTimes[category.id] ?? category.notifyTime;

    return AppCard(
      margin: const EdgeInsets.only(bottom: ThemeConstants.space3),
      child: Column(
        children: [
          // رأس البطاقة
          Row(
            children: [
              // الأيقونة
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  Icons.notifications_active,
                  color: category.color,
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
                      category.title,
                      style: context.titleMedium,
                    ),
                    if (category.description != null) ...[
                      ThemeConstants.space1.h,
                      Text(
                        category.description!,
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              
              // المفتاح
              Switch(
                value: isEnabled,
                onChanged: _hasPermission ? (value) => _toggleCategory(category.id, value) : null,
                activeColor: context.primaryColor,
              ),
            ],
          ),
          
          // إعدادات الوقت
          if (isEnabled && time != null) ...[
            ThemeConstants.space3.h,
            
            const Divider(),
            
            ThemeConstants.space3.h,
            
            InkWell(
              onTap: () async {
                final newTime = await showTimePicker(
                  context: context,
                  initialTime: time,
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        timePickerTheme: TimePickerThemeData(
                          backgroundColor: context.cardColor,
                          hourMinuteShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                          ),
                          dayPeriodShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                
                if (newTime != null && newTime != time) {
                  HapticFeedback.lightImpact();
                  await _updateTime(category.id, newTime);
                }
              },
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space3,
                  vertical: ThemeConstants.space2,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: ThemeConstants.iconSm,
                      color: context.textSecondaryColor,
                    ),
                    ThemeConstants.space2.w,
                    Text(
                      'وقت التذكير',
                      style: context.bodyMedium,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.space3,
                        vertical: ThemeConstants.space1,
                      ),
                      decoration: BoxDecoration(
                        color: context.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                      ),
                      child: Text(
                        time.format(context),
                        style: context.labelMedium?.copyWith(
                          color: context.primaryColor,
                          fontWeight: ThemeConstants.semiBold,
                        ),
                      ),
                    ),
                    ThemeConstants.space1.w,
                    Icon(
                      Icons.arrow_forward_ios,
                      size: ThemeConstants.iconXs,
                      color: context.textSecondaryColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}