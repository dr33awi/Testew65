// lib/features/athkar/screens/notification_settings_screen.dart - مُحدث بالـ widgets الموحدة
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/themes/app_theme.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';
import '../../../core/infrastructure/services/notifications/notification_manager.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';

class AthkarNotificationSettingsScreen extends StatefulWidget {
  const AthkarNotificationSettingsScreen({super.key});

  @override
  State<AthkarNotificationSettingsScreen> createState() => _AthkarNotificationSettingsScreenState();
}

class _AthkarNotificationSettingsScreenState extends State<AthkarNotificationSettingsScreen> {
  late final AthkarService _service;
  late final PermissionService _permissionService;
  late final LoggerService _logger;
  
  List<AthkarCategory>? _categories;
  
  final Map<String, bool> _enabled = {};
  final Map<String, TimeOfDay> _customTimes = {};
  final Map<String, TimeOfDay> _originalTimes = {};
  bool _saving = false;
  bool _hasPermission = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _permissionService = getIt<PermissionService>();
    _logger = getIt<LoggerService>();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      _logger.info(message: '[NotificationSettings] بدء تحميل البيانات');
      
      _hasPermission = await _permissionService.checkNotificationPermission();
      _logger.debug(message: '[NotificationSettings] حالة الإذن: $_hasPermission');
      
      final allCategories = await _service.loadCategories();
      _logger.info(message: '[NotificationSettings] تم تحميل ${allCategories.length} فئة');
      
      final enabledIds = _service.getEnabledReminderCategories();
      final savedCustomTimes = _loadSavedCustomTimes();
      
      final isFirstLaunch = enabledIds.isEmpty && savedCustomTimes.isEmpty;
      _logger.debug(message: '[NotificationSettings] أول تشغيل: $isFirstLaunch');
      
      _enabled.clear();
      _customTimes.clear();
      _originalTimes.clear();
      
      final autoEnabledIds = <String>[];
      
      for (final category in allCategories) {
        _originalTimes[category.id] = category.notifyTime ?? 
            CategoryHelper.getDefaultReminderTime(category.id);
        
        bool shouldEnable = enabledIds.contains(category.id);
        
        if (isFirstLaunch && CategoryHelper.shouldAutoEnable(category.id)) {
          shouldEnable = true;
          autoEnabledIds.add(category.id);
        }
        
        _enabled[category.id] = shouldEnable;
        _customTimes[category.id] = savedCustomTimes[category.id] ?? 
            _originalTimes[category.id]!;
      }
      
      if (isFirstLaunch && autoEnabledIds.isNotEmpty) {
        await _saveInitialSettings(autoEnabledIds);
      }
      
      setState(() {
        _categories = allCategories;
        _isLoading = false;
      });
      
      _logger.info(message: '[NotificationSettings] تم تحميل البيانات بنجاح');
      
    } catch (e) {
      _logger.error(message: '[NotificationSettings] فشل تحميل البيانات - $e');
      
      setState(() {
        _isLoading = false;
        _errorMessage = 'فشل في تحميل البيانات. يرجى المحاولة مرة أخرى.';
      });
    }
  }

  Future<NotificationManager?> _getNotificationManager() async {
    try {
      return NotificationManager.instance;
    } catch (e) {
      _logger.error(message: '[NotificationSettings] NotificationManager غير مهيأ - $e');
      return null;
    }
  }

  Future<void> _saveInitialSettings(List<String> autoEnabledIds) async {
    try {
      _logger.info(message: '[NotificationSettings] حفظ الإعدادات الأولية');
      
      await _service.setEnabledReminderCategories(autoEnabledIds);
      await _saveCustomTimes();
      
      if (_hasPermission) {
        final notificationManager = await _getNotificationManager();
        if (notificationManager != null) {
          for (final categoryId in autoEnabledIds) {
            final category = _categories?.firstWhere((c) => c.id == categoryId);
            if (category != null) {
              final time = _customTimes[categoryId];
              if (time != null) {
                await notificationManager.scheduleAthkarReminder(
                  categoryId: categoryId,
                  categoryName: category.title,
                  time: time,
                );
              }
            }
          }
        }
      }
      
      _logger.info(message: '[NotificationSettings] تم حفظ الإعدادات الأولية بنجاح');
    } catch (e) {
      _logger.error(message: '[NotificationSettings] فشل حفظ الإعدادات الأولية - $e');
    }
  }

  Map<String, TimeOfDay> _loadSavedCustomTimes() {
    try {
      final savedTimes = _service.getCustomTimes();
      return savedTimes;
    } catch (e) {
      _logger.warning(message: '[NotificationSettings] فشل تحميل الأوقات المخصصة - $e');
      return {};
    }
  }

  Future<void> _saveCustomTimes() async {
    try {
      await _service.setCustomTimes(_customTimes);
      _logger.debug(message: '[NotificationSettings] تم حفظ الأوقات المخصصة');
    } catch (e) {
      _logger.error(message: '[NotificationSettings] فشل حفظ الأوقات المخصصة - $e');
    }
  }

  Future<void> _requestPermission() async {
    try {
      _logger.info(message: '[NotificationSettings] طلب إذن الإشعارات');
      
      final granted = await _permissionService.requestNotificationPermission();
      setState(() => _hasPermission = granted);
      
      _logger.info(message: '[NotificationSettings] نتيجة طلب الإذن: $granted');
      
      if (granted) {
        await _scheduleEnabledNotifications();
      }
      
    } catch (e) {
      _logger.error(message: '[NotificationSettings] فشل طلب إذن الإشعارات - $e');
    }
  }

  Future<void> _scheduleEnabledNotifications() async {
    try {
      final notificationManager = await _getNotificationManager();
      if (notificationManager == null) return;
      
      final categories = _categories ?? [];
      
      for (final category in categories) {
        if (_enabled[category.id] ?? false) {
          final time = _customTimes[category.id];
          if (time != null) {
            await notificationManager.scheduleAthkarReminder(
              categoryId: category.id,
              categoryName: category.title,
              time: time,
            );
          }
        }
      }
      
      _logger.info(message: '[NotificationSettings] تم جدولة الإشعارات المفعلة');
    } catch (e) {
      _logger.error(message: '[NotificationSettings] فشل جدولة الإشعارات - $e');
    }
  }

  Future<void> _toggleCategory(String categoryId, bool value) async {
    setState(() {
      _enabled[categoryId] = value;
    });
    
    _logger.debug(message: '[NotificationSettings] تغيير حالة الفئة $categoryId إلى $value');
    
    await _saveChanges();
  }

  Future<void> _updateTime(String categoryId, TimeOfDay time) async {
    setState(() {
      _customTimes[categoryId] = time;
    });
    
    _logger.debug(message: '[NotificationSettings] تحديث وقت الفئة $categoryId إلى ${time.hour}:${time.minute}');
    
    await _saveChanges();
  }

  Future<void> _saveChanges() async {
    if (_saving) return;
    
    setState(() => _saving = true);
    
    try {
      _logger.info(message: '[NotificationSettings] بدء حفظ التغييرات');
      
      final enabledIds = _enabled.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();
      
      await _service.setEnabledReminderCategories(enabledIds);
      await _saveCustomTimes();
      
      if (_hasPermission) {
        final notificationManager = await _getNotificationManager();
        if (notificationManager != null) {
          await notificationManager.cancelAllAthkarReminders();
          
          final categories = _categories ?? [];
          for (final category in categories) {
            if (_enabled[category.id] ?? false) {
              final time = _customTimes[category.id];
              if (time != null) {
                await notificationManager.scheduleAthkarReminder(
                  categoryId: category.id,
                  categoryName: category.title,
                  time: time,
                );
              }
            }
          }
        }
      }
      
      _logger.info(message: '[NotificationSettings] تم حفظ التغييرات بنجاح - ${enabledIds.length} فئة مفعلة');
      
    } catch (e) {
      _logger.error(message: '[NotificationSettings] فشل حفظ التغييرات - $e');
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _selectTime(String categoryId, TimeOfDay currentTime) async {
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
      helpText: 'اختر وقت التذكير',
      cancelText: 'إلغاء',
      confirmText: 'تأكيد',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: context.surfaceColor,
              hourMinuteTextColor: context.textPrimaryColor,
              dialHandColor: context.primaryColor,
              dialBackgroundColor: context.cardColor,
              helpTextStyle: context.titleMedium?.copyWith(
                color: context.textPrimaryColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      await _updateTime(categoryId, selectedTime);
      
      if (!(_enabled[categoryId] ?? false)) {
        await _toggleCategory(categoryId, true);
      }
    }
  }

  Future<void> _enableAllReminders() async {
    HapticFeedback.mediumImpact();
    
    final shouldEnable = await AppInfoDialog.showConfirmation(
      context: context,
      title: 'تفعيل جميع التذكيرات',
      content: 'هل تريد تفعيل تذكيرات جميع فئات الأذكار بالأوقات الحالية؟',
      confirmText: 'تفعيل الكل',
      cancelText: 'إلغاء',
    );
    
    if (shouldEnable == true) {
      setState(() {
        for (final category in _categories ?? <AthkarCategory>[]) {
          _enabled[category.id] = true;
        }
      });
      await _saveChanges();
    }
  }

  Future<void> _disableAllReminders() async {
    HapticFeedback.mediumImpact();
    
    final shouldDisable = await AppInfoDialog.showConfirmation(
      context: context,
      title: 'إيقاف جميع التذكيرات',
      content: 'هل تريد إيقاف جميع تذكيرات الأذكار؟',
      confirmText: 'إيقاف الكل',
      cancelText: 'إلغاء',
    );
    
    if (shouldDisable == true) {
      setState(() {
        for (final category in _categories ?? <AthkarCategory>[]) {
          _enabled[category.id] = false;
        }
      });
      await _saveChanges();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      // ✅ استخدام CustomAppBar الموحد
      appBar: CustomAppBar.simple(
        title: 'إشعارات الأذكار',
        actions: [
          if (_hasPermission && (_categories?.isNotEmpty ?? false))
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                switch (value) {
                  case 'enable_all':
                    _enableAllReminders();
                    break;
                  case 'disable_all':
                    _disableAllReminders();
                    break;
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'enable_all',
                  child: Row(
                    children: [
                      Icon(Icons.notifications_active),
                      SizedBox(width: 8),
                      Text('تفعيل الكل'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'disable_all',
                  child: Row(
                    children: [
                      Icon(Icons.notifications_off),
                      SizedBox(width: 8),
                      Text('إيقاف الكل'),
                    ],
                  ),
                ),
              ],
            ),
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return AppLoading.page(
        message: 'جاري تحميل الإعدادات...',
      );
    }

    if (_errorMessage != null) {
      return AppEmptyState.error(
        message: _errorMessage!,
        onRetry: _loadData,
      );
    }

    final categories = _categories ?? [];

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ استخدام AppNoticeCard للإشعارات
            _buildPermissionNotice(),
            
            const SizedBox(height: 24),
            
            if (_hasPermission) ...[
              if (categories.isEmpty)
                AppEmptyState.noData(
                  message: 'لم يتم العثور على أي فئات للأذكار',
                )
              else ...[
                _buildQuickStats(categories),
                
                const SizedBox(height: 16),
                
                Text(
                  'جميع فئات الأذكار (${categories.length})',
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 8),
                
                Text(
                  'يمكنك تفعيل التذكيرات لأي فئة وتخصيص أوقاتها',
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
                
                const SizedBox(height: 16),
                
                ...categories.map((category) => 
                  _buildCategoryCard(category)
                ),
              ],
            ] else
              AppNoticeCard.warning(
                title: 'الإشعارات مطلوبة',
                message: 'يجب تفعيل الإشعارات أولاً لتتمكن من إعداد تذكيرات الأذكار لجميع الفئات',
                action: AppButton.primary(
                  text: 'تفعيل الإشعارات الآن',
                  onPressed: _requestPermission,
                  icon: Icons.notifications_active,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionNotice() {
    if (_hasPermission) {
      return AppNoticeCard.success(
        title: 'الإشعارات مفعلة',
        message: 'يمكنك الآن تخصيص تذكيرات الأذكار',
      );
    } else {
      return AppNoticeCard.warning(
        title: 'الإشعارات معطلة',
        message: 'قم بتفعيل الإشعارات لتلقي التذكيرات',
        action: AppButton.primary(
          text: 'تفعيل الإشعارات',
          onPressed: _requestPermission,
          icon: Icons.notifications,
        ),
      );
    }
  }

  Widget _buildQuickStats(List<AthkarCategory> categories) {
    final enabledCount = _enabled.values.where((e) => e).length;
    final disabledCount = categories.length - enabledCount;
    
    // ✅ استخدام AppCard للإحصائيات
    return Row(
      children: [
        Expanded(
          child: AppCard.stat(
            title: 'مفعلة',
            value: '$enabledCount',
            icon: Icons.notifications_active,
            color: Colors.green,
          ),
        ),
        
        ThemeConstants.space3.w,
        
        Expanded(
          child: AppCard.stat(
            title: 'معطلة',
            value: '$disabledCount',
            icon: Icons.notifications_off,
            color: context.textSecondaryColor,
          ),
        ),
        
        ThemeConstants.space3.w,
        
        Expanded(
          child: AppCard.stat(
            title: 'الكل',
            value: '${categories.length}',
            icon: Icons.format_list_numbered,
            color: context.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(AthkarCategory category) {
    final isEnabled = _enabled[category.id] ?? false;
    final currentTime = _customTimes[category.id] ?? 
        CategoryHelper.getDefaultReminderTime(category.id);
    final originalTime = _originalTimes[category.id];
    final hasCustomTime = originalTime != null && currentTime != originalTime;
    
    final isAutoEnabled = CategoryHelper.shouldAutoEnable(category.id);
    final categoryColor = CategoryHelper.getCategoryColor(context, category.id);
    final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
    final categoryDescription = CategoryHelper.getCategoryDescription(category.id);

    // ✅ استخدام AppCard للفئات
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          // البطاقة الرئيسية
          AppCard.info(
            title: category.title,
            subtitle: categoryDescription,
            icon: categoryIcon,
            iconColor: categoryColor,
            trailing: Switch(
              value: isEnabled,
              onChanged: _hasPermission 
                  ? (value) => _toggleCategory(category.id, value)
                  : null,
              activeColor: isAutoEnabled ? Colors.green : context.primaryColor,
            ),
            onTap: isEnabled ? () => _selectTime(category.id, currentTime) : null,
          ),
          
          // معلومات الوقت إذا كانت الفئة مفعلة
          if (isEnabled) ...[
            ThemeConstants.space3.h,
            AppNoticeCard.info(
              title: 'وقت التذكير: ${currentTime.format(context)}',
              message: hasCustomTime 
                  ? 'تم تخصيص الوقت'
                  : 'وقت افتراضي - يمكنك تغييره',
              action: AppButton.text(
                text: 'تغيير الوقت',
                onPressed: () => _selectTime(category.id, currentTime),
              ),
              margin: EdgeInsets.zero,
            ),
          ],
        ],
      ),
    );
  }
}