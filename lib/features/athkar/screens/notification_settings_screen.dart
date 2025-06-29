// lib/features/athkar/screens/notification_settings_screen.dart - محدث بالنظام الموحد الإسلامي

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد الإسلامي - إجباري
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:athkar_app/app/themes/widgets/widgets.dart';
import 'package:athkar_app/app/themes/widgets/extended_cards.dart';
import 'package:athkar_app/app/themes/utils/category_utils.dart';

import '../../../app/di/service_locator.dart';
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
            _getDefaultReminderTime(category.id);
        
        bool shouldEnable = enabledIds.contains(category.id);
        
        if (isFirstLaunch && _shouldAutoEnable(category.id)) {
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
        _showSuccessSnackBar('تم تفعيل الإشعارات بنجاح');
      } else {
        _showErrorSnackBar('فشل في تفعيل الإشعارات');
      }
    } catch (e) {
      _logger.error(message: 'فشل طلب إذن الإشعارات - $e');
      _showErrorSnackBar('فشل في طلب إذن الإشعارات');
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
      _showErrorSnackBar('فشل في حفظ التغييرات');
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
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppTheme.primary,
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
    
    final shouldEnable = await _showConfirmationDialog(
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
      _showSuccessSnackBar('تم تفعيل جميع التذكيرات');
    }
  }

  Future<void> _disableAllReminders() async {
    HapticFeedback.mediumImpact();
    
    final shouldDisable = await _showConfirmationDialog(
      title: 'إيقاف جميع التذكيرات',
      content: 'هل تريد إيقاف جميع تذكيرات الأذكار؟',
      confirmText: 'إيقاف الكل',
      cancelText: 'إلغاء',
      isDestructive: true,
    );
    
    if (shouldDisable == true) {
      setState(() {
        for (final category in _categories ?? <AthkarCategory>[]) {
          _enabled[category.id] = false;
        }
      });
      await _saveChanges();
      _showSuccessSnackBar('تم إيقاف جميع التذكيرات');
    }
  }

  void _showOptionsMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXl),
        ),
      ),
      builder: (context) => Container(
        padding: AppTheme.space4.padding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            AppTheme.space4.h,
            Text(
              'خيارات التذكيرات',
              style: AppTheme.titleLarge.copyWith(
                fontWeight: AppTheme.bold,
              ),
            ),
            AppTheme.space4.h,
            
            // ✅ استخدام SettingCard للخيارات
            SettingCard.navigation(
              title: 'تفعيل الكل',
              subtitle: 'تفعيل جميع تذكيرات الأذكار',
              icon: Icons.notifications_active,
              color: AppTheme.success,
              onTap: () {
                Navigator.pop(context);
                _enableAllReminders();
              },
            ),
            
            SettingCard.navigation(
              title: 'إيقاف الكل',
              subtitle: 'إيقاف جميع تذكيرات الأذكار',
              icon: Icons.notifications_off,
              color: AppTheme.error,
              onTap: () {
                Navigator.pop(context);
                _disableAllReminders();
              },
            ),
            
            AppTheme.space2.h,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      // ✅ استخدام SimpleAppBar الموحد
      appBar: SimpleAppBar(
        title: 'إعدادات التذكيرات',
        actions: [
          if (_hasPermission && (_categories?.isNotEmpty ?? false))
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: AppTheme.textSecondary,
              ),
              onPressed: _showOptionsMenu,
              tooltip: 'خيارات إضافية',
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
      return AppEmptyState.error(
        message: _errorMessage!,
        onRetry: _loadData,
      );
    }

    final categories = _categories ?? [];

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppTheme.primary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppTheme.space4.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPermissionNotice(),
            AppTheme.space6.h,
            
            if (_hasPermission) ...[
              if (categories.isEmpty)
                AppEmptyState.noData(
                  message: 'لم يتم العثور على أي فئات للأذكار',
                )
              else ...[
                _buildQuickStats(categories),
                AppTheme.space4.h,
                
                Text(
                  'جميع فئات الأذكار (${categories.length})',
                  style: AppTheme.titleMedium.copyWith(
                    fontWeight: AppTheme.bold,
                  ),
                ),
                AppTheme.space2.h,
                
                Text(
                  'يمكنك تفعيل التذكيرات لأي فئة وتخصيص أوقاتها',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                AppTheme.space4.h,
                
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
      useGradient: true,
      color: _hasPermission ? AppTheme.success : AppTheme.warning,
      child: Row(
        children: [
          Container(
            padding: AppTheme.space3.padding,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: AppTheme.radiusMd.radius,
            ),
            child: Icon(
              _hasPermission ? Icons.notifications_active : Icons.notifications_off,
              color: Colors.white,
              size: AppTheme.iconLg,
            ),
          ),
          AppTheme.space3.w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _hasPermission ? 'الإشعارات مفعلة' : 'الإشعارات معطلة',
                  style: AppTheme.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.bold,
                  ),
                ),
                Text(
                  _hasPermission 
                      ? 'يمكنك الآن تخصيص تذكيرات الأذكار'
                      : 'قم بتفعيل الإشعارات لتلقي التذكيرات',
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          if (!_hasPermission) ...[
            AppTheme.space3.w,
            AppButton.outline(
              text: 'تفعيل',
              onPressed: _requestPermission,
              borderColor: Colors.white,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPermissionWarning() {
    return AppCard(
      child: Column(
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: AppTheme.warning,
          ),
          AppTheme.space3.h,
          Text(
            'الإشعارات مطلوبة',
            style: AppTheme.titleLarge.copyWith(
              fontWeight: AppTheme.bold,
              color: AppTheme.warning,
            ),
          ),
          AppTheme.space2.h,
          Text(
            'يجب تفعيل الإشعارات أولاً لتتمكن من إعداد تذكيرات الأذكار لجميع الفئات',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          AppTheme.space5.h,
          AppButton.primary(
            text: 'تفعيل الإشعارات الآن',
            onPressed: _requestPermission,
            icon: Icons.notifications_active,
            isFullWidth: true,
          ),
        ],
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
            color: AppTheme.success,
          ),
        ),
        AppTheme.space3.w,
        Expanded(
          child: AppCard.stat(
            title: 'معطلة',
            value: '$disabledCount',
            icon: Icons.notifications_off,
            color: AppTheme.textSecondary,
          ),
        ),
        AppTheme.space3.w,
        Expanded(
          child: AppCard.stat(
            title: 'الكل',
            value: '${categories.length}',
            icon: Icons.format_list_numbered,
            color: AppTheme.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(AthkarCategory category) {
    final isEnabled = _enabled[category.id] ?? false;
    final currentTime = _customTimes[category.id] ?? 
        _getDefaultReminderTime(category.id);
    final originalTime = _originalTimes[category.id];
    final hasCustomTime = originalTime != null && currentTime != originalTime;
    
    final categoryIcon = CategoryUtils.getCategoryIcon(category.id);
    final categoryDescription = CategoryUtils.getCategoryDescription(category.id);
    final categoryColor = CategoryUtils.getCategoryThemeColor(category.id);

    return Padding(
      padding: EdgeInsets.only(bottom: AppTheme.space3),
      child: AnimatedPress(
        onTap: isEnabled ? () => _selectTime(category.id, currentTime) : () {},
        child: AppCard(
          useGradient: true,
          color: categoryColor,
          margin: EdgeInsets.zero,
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
                child: Icon(
                  categoryIcon,
                  color: Colors.white,
                  size: AppTheme.iconLg,
                ),
              ),
              
              AppTheme.space3.w,
              
              // النص والمعلومات
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: AppTheme.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.bold,
                        shadows: const [
                          Shadow(
                            color: Colors.black26,
                            offset: Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    if (categoryDescription.isNotEmpty) ...[
                      AppTheme.space1.h,
                      Text(
                        categoryDescription,
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (isEnabled) ...[
                      AppTheme.space1.h,
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppTheme.space2,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: AppTheme.radiusMd.radius,
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
                              style: AppTheme.labelMedium.copyWith(
                                color: Colors.white,
                                fontWeight: hasCustomTime 
                                    ? AppTheme.bold 
                                    : AppTheme.regular,
                              ),
                            ),
                            if (hasCustomTime) ...[
                              const SizedBox(width: 4),
                              Icon(
                                Icons.edit,
                                size: 10,
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ],
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
                onChanged: _hasPermission 
                    ? (value) => _toggleCategory(category.id, value) 
                    : null,
                activeColor: Colors.white,
                activeTrackColor: Colors.white.withValues(alpha: 0.3),
                inactiveThumbColor: AppTheme.textSecondary,
                inactiveTrackColor: AppTheme.divider,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ دوال مساعدة محلية
  TimeOfDay _getDefaultReminderTime(String categoryId) {
    switch (categoryId) {
      case 'اوقات_الصلاة':
        return const TimeOfDay(hour: 6, minute: 0); // الفجر
      case 'الاذكار':
        return const TimeOfDay(hour: 7, minute: 0); // الصباح
      case 'القبلة':
        return const TimeOfDay(hour: 12, minute: 0); // الظهر
      case 'التسبيح':
        return const TimeOfDay(hour: 20, minute: 0); // المساء
      case 'القران':
        return const TimeOfDay(hour: 21, minute: 0); // بعد المغرب
      case 'الادعية':
        return const TimeOfDay(hour: 22, minute: 0); // الليل
      case 'المفضلة':
        return const TimeOfDay(hour: 8, minute: 0); // الصباح
      default:
        return const TimeOfDay(hour: 8, minute: 0);
    }
  }

  bool _shouldAutoEnable(String categoryId) {
    switch (categoryId) {
      case 'اوقات_الصلاة':
      case 'الاذكار':
        return true; // الفئات الأساسية تُفعل تلقائياً
      default:
        return false;
    }
  }

  // ✅ دوال الحوارات والرسائل
  Future<bool?> _showConfirmationDialog({
    required String title,
    required String content,
    required String confirmText,
    required String cancelText,
    bool isDestructive = false,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusXl.radius,
        ),
        title: Text(
          title,
          style: AppTheme.titleLarge.copyWith(
            fontWeight: AppTheme.bold,
          ),
        ),
        content: Text(
          content,
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              cancelText,
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          AppButton.primary(
            text: confirmText,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.success,
        duration: AppTheme.durationNormal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusMd.radius,
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
        duration: AppTheme.durationNormal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppTheme.radiusMd.radius,
        ),
      ),
    );
  }
}