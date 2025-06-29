// lib/features/athkar/screens/notification_settings_screen.dart - محسن ومُطبق النظام الموحد
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
      
      _hasPermission = await _permissionService.checkNotificationPermission();
      final allCategories = await _service.loadCategories();
      final enabledIds = _service.getEnabledReminderCategories();
      final savedCustomTimes = _loadSavedCustomTimes();
      
      final isFirstLaunch = enabledIds.isEmpty && savedCustomTimes.isEmpty;
      final autoEnabledIds = <String>[];
      
      _enabled.clear();
      _customTimes.clear();
      _originalTimes.clear();
      
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
      
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'فشل في تحميل البيانات. يرجى المحاولة مرة أخرى.';
      });
    }
  }

  Map<String, TimeOfDay> _loadSavedCustomTimes() {
    try {
      return _service.getCustomTimes();
    } catch (e) {
      return {};
    }
  }

  Future<void> _saveInitialSettings(List<String> autoEnabledIds) async {
    try {
      await _service.setEnabledReminderCategories(autoEnabledIds);
      await _saveCustomTimes();
      if (_hasPermission) {
        await _scheduleEnabledNotifications();
      }
    } catch (e) {
      _logger.error(message: 'فشل حفظ الإعدادات الأولية - $e');
    }
  }

  Future<void> _saveCustomTimes() async {
    try {
      await _service.setCustomTimes(_customTimes);
    } catch (e) {
      _logger.error(message: 'فشل حفظ الأوقات المخصصة - $e');
    }
  }

  Future<void> _requestPermission() async {
    try {
      final granted = await _permissionService.requestNotificationPermission();
      setState(() => _hasPermission = granted);
      if (granted) {
        await _scheduleEnabledNotifications();
        // ✅ استخدام النظام الموحد للـ SnackBar
        AppSnackBar.showSuccess(
          context: context,
          message: 'تم تفعيل الإشعارات بنجاح',
        );
      }
    } catch (e) {
      _logger.error(message: 'فشل طلب إذن الإشعارات - $e');
      // ✅ استخدام النظام الموحد للأخطاء
      AppSnackBar.showError(
        context: context,
        message: 'فشل في تفعيل الإشعارات',
      );
    }
  }

  Future<void> _scheduleEnabledNotifications() async {
    try {
      final notificationManager = NotificationManager.instance;
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
    } catch (e) {
      _logger.error(message: 'فشل جدولة الإشعارات - $e');
    }
  }

  Future<void> _toggleCategory(String categoryId, bool value) async {
    setState(() => _enabled[categoryId] = value);
    await _saveChanges();
  }

  Future<void> _updateTime(String categoryId, TimeOfDay time) async {
    setState(() => _customTimes[categoryId] = time);
    await _saveChanges();
  }

  Future<void> _saveChanges() async {
    if (_saving) return;
    
    setState(() => _saving = true);
    
    try {
      final enabledIds = _enabled.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();
      
      await _service.setEnabledReminderCategories(enabledIds);
      await _saveCustomTimes();
      
      if (_hasPermission) {
        final notificationManager = NotificationManager.instance;
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
    } catch (e) {
      _logger.error(message: 'فشل حفظ التغييرات - $e');
      // ✅ استخدام النظام الموحد للأخطاء
      AppSnackBar.showError(
        context: context,
        message: 'فشل في حفظ التغييرات',
      );
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
      // ✅ استخدام النظام الموحد
      AppSnackBar.showSuccess(
        context: context,
        message: 'تم تفعيل جميع التذكيرات',
      );
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
      // ✅ استخدام النظام الموحد
      AppSnackBar.showSuccess(
        context: context,
        message: 'تم إيقاف جميع التذكيرات',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
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
      return AppLoading.page(message: 'جاري تحميل الإعدادات...');
    }

    if (_errorMessage != null) {
      return AppEmptyState.error(message: _errorMessage!, onRetry: _loadData);
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
            _buildPermissionNotice(),
            const SizedBox(height: 24),
            
            if (_hasPermission) ...[
              if (categories.isEmpty)
                AppEmptyState.noData(message: 'لم يتم العثور على أي فئات للأذكار')
              else ...[
                _buildQuickStats(categories),
                const SizedBox(height: 16),
                
                Text(
                  'جميع فئات الأذكار (${categories.length})',
                  style: context.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                
                Text(
                  'يمكنك تفعيل التذكيرات لأي فئة وتخصيص أوقاتها',
                  style: context.bodySmall?.copyWith(color: context.textSecondaryColor),
                ),
                const SizedBox(height: 16),
                
                ...categories.map((category) => _buildCategoryCard(category)),
              ],
            ] else
              _buildPermissionWarning(),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionNotice() {
    return AppCard(
      type: CardType.normal,
      style: CardStyle.gradient,
      primaryColor: _hasPermission ? ThemeConstants.success : ThemeConstants.warning,
      icon: _hasPermission ? Icons.notifications_active : Icons.notifications_off,
      title: _hasPermission ? 'الإشعارات مفعلة' : 'الإشعارات معطلة',
      content: _hasPermission 
          ? 'يمكنك الآن تخصيص تذكيرات الأذكار'
          : 'قم بتفعيل الإشعارات لتلقي التذكيرات',
      actions: !_hasPermission ? [
        CardAction(
          icon: Icons.notifications,
          label: 'تفعيل الإشعارات',
          onPressed: _requestPermission,
          isPrimary: true,
        ),
      ] : null,
    );
  }

  Widget _buildPermissionWarning() {
    return AppNoticeCard.warning(
      title: 'الإشعارات مطلوبة',
      message: 'يجب تفعيل الإشعارات أولاً لتتمكن من إعداد تذكيرات الأذكار لجميع الفئات',
      action: AppButton.primary(
        text: 'تفعيل الإشعارات الآن',
        onPressed: _requestPermission,
        icon: Icons.notifications_active,
      ),
    );
  }

  Widget _buildQuickStats(List<AthkarCategory> categories) {
    final enabledCount = _enabled.values.where((e) => e).length;
    final disabledCount = categories.length - enabledCount;
    
    return Row(
      children: [
        Expanded(
          child: AppCard.stat(
            title: 'مفعلة',
            value: '$enabledCount',
            icon: Icons.notifications_active,
            color: ThemeConstants.success,
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
    
    final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
    final categoryDescription = CategoryHelper.getCategoryDescription(category.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AppCard(
        type: CardType.normal,
        style: CardStyle.gradient,
        primaryColor: ThemeConstants.success,
        onTap: isEnabled ? () => _selectTime(category.id, currentTime) : null,
        margin: EdgeInsets.zero,
        borderRadius: ThemeConstants.radiusXl,
        child: Padding(
          padding: const EdgeInsets.all(ThemeConstants.space4),
          child: Row(
            children: [
              // أيقونة دائرية
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.25),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: Icon(categoryIcon, color: Colors.white, size: 24),
              ),
              
              const SizedBox(width: ThemeConstants.space3),
              
              // النص والمعلومات
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: context.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.bold,
                        shadows: const [
                          Shadow(color: Colors.black26, offset: Offset(0, 1), blurRadius: 2),
                        ],
                      ),
                    ),
                    if (categoryDescription.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        categoryDescription,
                        style: context.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (isEnabled) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 12,
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              currentTime.format(context),
                              style: context.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: hasCustomTime ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              // مفتاح التشغيل
              Switch(
                value: isEnabled,
                onChanged: _hasPermission ? (value) => _toggleCategory(category.id, value) : null,
                activeColor: Colors.white,
                activeTrackColor: Colors.white.withValues(alpha: 0.3),
                inactiveThumbColor: context.textSecondaryColor,
                inactiveTrackColor: context.dividerColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}