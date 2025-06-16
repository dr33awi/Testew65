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
  
  // تغيير من late إلى nullable وتهيئة لاحقاً
  Future<List<AthkarCategory>>? _futureCategories;
  
  final Map<String, bool> _enabled = {};
  final Map<String, TimeOfDay> _customTimes = {};
  bool _saving = false;
  bool _hasPermission = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _permissionService = getIt<PermissionService>();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      
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
      
      // انتظار التحميل
      await _futureCategories;
      
    } catch (e) {
      debugPrint('خطأ في تحميل البيانات: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
    if (_saving || _futureCategories == null) return;
    
    setState(() => _saving = true);
    
    try {
      // حفظ الفئات المفعلة
      final enabledIds = _enabled.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();
      await _service.setEnabledReminderCategories(enabledIds);
      
      // جدولة الإشعارات
      try {
        final notificationManager = NotificationManager.instance;
        await notificationManager.cancelAllAthkarNotifications();
        
        // جدولة إشعارات للفئات المفعلة
        final categories = await _futureCategories!;
        for (final category in categories) {
          if (_enabled[category.id] ?? false) {
            final time = _customTimes[category.id] ?? category.notifyTime;
            if (time != null) {
              await notificationManager.scheduleAthkarReminder(
                categoryId: category.id,
                categoryName: category.title,
                time: time,
              );
            }
          }
        }
        
        if (mounted) {
          context.showSuccessSnackBar('تم حفظ الإعدادات بنجاح');
        }
      } catch (e) {
        debugPrint('خطأ في جدولة الإشعارات: $e');
        if (mounted) {
          context.showErrorSnackBar('تم حفظ الإعدادات لكن قد تكون هناك مشكلة في الإشعارات');
        }
      }
    } catch (e) {
      debugPrint('خطأ في حفظ الإعدادات: $e');
      if (mounted) {
        context.showErrorSnackBar('حدث خطأ في حفظ الإعدادات');
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar.simple(
        title: 'إشعارات الأذكار',
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: AppLoading.page(
                message: 'جاري تحميل الإعدادات...',
              ),
            )
          : _futureCategories == null
              ? Center(
                  child: AppEmptyState.error(
                    message: 'فشل في تحميل البيانات',
                    onRetry: _loadData,
                  ),
                )
              : FutureBuilder<List<AthkarCategory>>(
                  future: _futureCategories,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: AppLoading.page(
                          message: 'جاري تحميل الإعدادات...',
                        ),
                      );
                    }

                    if (snapshot.hasError) {
                      return AppEmptyState.error(
                        message: 'حدث خطأ في تحميل البيانات',
                        onRetry: _loadData,
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
                          // حالة الإذن
                          _buildPermissionSection(),
                          
                          const SizedBox(height: ThemeConstants.space6),
                          
                          // قائمة الفئات
                          if (_hasPermission) ...[
                            Text(
                              'الفئات المتاحة',
                              style: context.titleMedium?.copyWith(
                                fontWeight: ThemeConstants.bold,
                                color: context.textPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: ThemeConstants.space4),
                            ...categories.map((category) => 
                              _buildCategoryTile(category)
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildPermissionSection() {
    return AppCard(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _hasPermission ? Icons.notifications_active : Icons.notifications_off,
                color: _hasPermission ? ThemeConstants.success : ThemeConstants.warning,
                size: 24,
              ),
              const SizedBox(width: ThemeConstants.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _hasPermission ? 'الإشعارات مفعلة' : 'الإشعارات معطلة',
                      style: context.titleSmall?.copyWith(
                        fontWeight: ThemeConstants.semiBold,
                        color: _hasPermission ? ThemeConstants.success : ThemeConstants.warning,
                      ),
                    ),
                    Text(
                      _hasPermission 
                          ? 'يمكنك تلقي تذكيرات الأذكار'
                          : 'قم بتفعيل الإشعارات لتلقي التذكيرات',
                      style: context.bodySmall?.copyWith(
                        color: context.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!_hasPermission) ...[
            const SizedBox(height: ThemeConstants.space3),
            SizedBox(
              width: double.infinity,
              child: AppButton.primary(
                text: 'تفعيل الإشعارات',
                onPressed: _requestPermission,
                icon: Icons.notifications,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCategoryTile(AthkarCategory category) {
    final isEnabled = _enabled[category.id] ?? false;
    final currentTime = _customTimes[category.id] ?? category.notifyTime!;

    return Padding(
      padding: const EdgeInsets.only(bottom: ThemeConstants.space3),
      child: AppCard(
        padding: const EdgeInsets.all(ThemeConstants.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: context.titleSmall?.copyWith(
                          fontWeight: ThemeConstants.semiBold,
                        ),
                      ),
                      if (category.description?.isNotEmpty == true)
                        Text(
                          category.description!,
                          style: context.bodySmall?.copyWith(
                            color: context.textSecondaryColor,
                          ),
                        ),
                    ],
                  ),
                ),
                Switch(
                  value: isEnabled,
                  onChanged: _hasPermission 
                      ? (value) => _toggleCategory(category.id, value)
                      : null,
                  activeColor: ThemeConstants.primary,
                ),
              ],
            ),
            if (isEnabled) ...[
              const SizedBox(height: ThemeConstants.space3),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: context.textSecondaryColor,
                  ),
                  const SizedBox(width: ThemeConstants.space2),
                  Text(
                    'وقت التذكير: ${currentTime.format(context)}',
                    style: context.bodySmall?.copyWith(
                      color: context.textSecondaryColor,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => _selectTime(category.id, currentTime),
                    child: const Text('تغيير'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(String categoryId, TimeOfDay currentTime) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: context.surfaceColor,
              hourMinuteTextColor: context.textPrimaryColor,
              dialHandColor: ThemeConstants.primary,
              dialBackgroundColor: context.cardColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      await _updateTime(categoryId, selectedTime);
    }
  }
}