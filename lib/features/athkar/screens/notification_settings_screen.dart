// lib/features/athkar/screens/notification_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيرادات النظام الموحد الموجود فقط
import '../../../app/themes/index.dart';

import '../../../app/di/service_locator.dart';
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
  
  List<AthkarCategory>? _categories;
  
  final Map<String, bool> _enabled = {};
  final Map<String, TimeOfDay> _customTimes = {};
  bool _saving = false;
  bool _hasPermission = false;
  bool _isLoading = true;
  String? _errorMessage;

  // أوقات افتراضية للفئات المختلفة
  static const Map<String, TimeOfDay> _defaultTimes = {
    'morning': TimeOfDay(hour: 6, minute: 0),      // أذكار الصباح
    'evening': TimeOfDay(hour: 18, minute: 0),     // أذكار المساء
    'sleep': TimeOfDay(hour: 22, minute: 0),       // أذكار النوم
    'wakeup': TimeOfDay(hour: 5, minute: 30),      // أذكار الاستيقاظ
    'prayer': TimeOfDay(hour: 12, minute: 0),      // أذكار الصلاة
    'eating': TimeOfDay(hour: 19, minute: 0),      // أذكار الطعام
    'travel': TimeOfDay(hour: 8, minute: 0),       // أذكار السفر
    'general': TimeOfDay(hour: 14, minute: 0),     // أذكار عامة
  };

  // الفئات التي يجب تفعيلها تلقائياً
  static const Set<String> _autoEnabledCategories = {
    'morning',
    'evening', 
    'sleep',
  };

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _permissionService = getIt<PermissionService>();
    _loadData();
  }

  TimeOfDay _getDefaultTimeForCategory(String categoryId) {
    // البحث عن وقت مناسب بناءً على معرف الفئة
    for (final key in _defaultTimes.keys) {
      if (categoryId.toLowerCase().contains(key)) {
        return _defaultTimes[key]!;
      }
    }
    // وقت افتراضي عام
    return const TimeOfDay(hour: 9, minute: 0);
  }

  bool _shouldAutoEnable(String categoryId) {
    // التحقق من أن الفئة يجب تفعيلها تلقائياً
    for (final key in _autoEnabledCategories) {
      if (categoryId.toLowerCase().contains(key)) {
        return true;
      }
    }
    return false;
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      // التحقق من الإذن
      _hasPermission = await _permissionService.checkNotificationPermission();
      
      // تحميل جميع الفئات
      final allCategories = await _service.loadCategories();
      
      final enabledIds = _service.getEnabledReminderCategories();
      
      // التحقق من أول تشغيل (لا توجد إعدادات محفوظة)
      final isFirstLaunch = enabledIds.isEmpty;
      
      // تهيئة البيانات لجميع الفئات
      _enabled.clear();
      _customTimes.clear();
      
      final autoEnabledIds = <String>[];
      
      for (final category in allCategories) {
        // تحديد ما إذا كانت الفئة مفعلة
        bool shouldEnable = enabledIds.contains(category.id);
        
        // في أول تشغيل، تفعيل الفئات الأساسية تلقائياً
        if (isFirstLaunch && _shouldAutoEnable(category.id)) {
          shouldEnable = true;
          autoEnabledIds.add(category.id);
        }
        
        _enabled[category.id] = shouldEnable;
        
        // استخدام الوقت المحدد مسبقاً أو الوقت الافتراضي
        _customTimes[category.id] = category.notifyTime ?? 
            _getDefaultTimeForCategory(category.id);
      }
      
      // في أول تشغيل، حفظ الفئات المفعلة تلقائياً
      if (isFirstLaunch && autoEnabledIds.isNotEmpty) {
        await _service.setEnabledReminderCategories(autoEnabledIds);
        
        // جدولة الإشعارات للفئات المفعلة تلقائياً
        if (_hasPermission) {
          final notificationManager = NotificationManager.instance;
          for (final categoryId in autoEnabledIds) {
            final category = allCategories.firstWhere((c) => c.id == categoryId);
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
      
      setState(() {
        _categories = allCategories;
        _isLoading = false;
      });
      
    } catch (e) {
      debugPrint('خطأ في تحميل البيانات: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'فشل في تحميل البيانات. يرجى المحاولة مرة أخرى.';
      });
    }
  }

  Future<void> _requestPermission() async {
    try {
      final granted = await _permissionService.requestNotificationPermission();
      setState(() => _hasPermission = granted);
    } catch (e) {
      debugPrint('خطأ في طلب الإذن: $e');
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
      if (_hasPermission) {
        final notificationManager = NotificationManager.instance;
        await notificationManager.cancelAllAthkarReminders();
        
        // جدولة إشعارات للفئات المفعلة
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
      debugPrint('خطأ في حفظ الإعدادات: $e');
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
              hourMinuteTextColor: context.textColor,
              dialHandColor: ThemeConstants.primary,
              dialBackgroundColor: context.cardColor,
              helpTextStyle: context.titleStyle.copyWith(
                color: context.textColor,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      await _updateTime(categoryId, selectedTime);
      
      // تفعيل الفئة تلقائياً عند تغيير الوقت
      if (!(_enabled[categoryId] ?? false)) {
        await _toggleCategory(categoryId, true);
      }
    }
  }

  Future<void> _enableAllReminders() async {
    HapticFeedback.mediumImpact();
    
    final shouldEnable = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفعيل جميع التذكيرات'),
        content: const Text('هل تريد تفعيل تذكيرات جميع فئات الأذكار بالأوقات الافتراضية؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('تفعيل الكل'),
          ),
        ],
      ),
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
    
    final shouldDisable = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إيقاف جميع التذكيرات'),
        content: const Text('هل تريد إيقاف جميع تذكيرات الأذكار؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('إيقاف الكل'),
          ),
        ],
      ),
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
      appBar: IslamicAppBar(
        title: 'إشعارات الأذكار',
        actions: [
          if (_hasPermission && (_categories?.isNotEmpty ?? false)) ...[
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
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'enable_all',
                  child: Row(
                    children: [
                      Icon(Icons.notifications_active),
                      SizedBox(width: 8),
                      Text('تفعيل الكل'),
                    ],
                  ),
                ),
                PopupMenuItem(
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
          ],
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
      return Center(
        child: IslamicLoading(
          message: 'جاري تحميل الإعدادات...',
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: EmptyState(
          icon: Icons.error_outline,
          title: _errorMessage!,
          action: IslamicButton.primary(
            text: 'إعادة المحاولة',
            onPressed: _loadData,
          ),
        ),
      );
    }

    final categories = _categories ?? [];

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(context.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // حالة الإذن
            _buildPermissionSection(),
            
            const Spaces.large,
            
            // قائمة الفئات
            if (_hasPermission) ...[
              if (categories.isEmpty)
                _buildNoCategoriesMessage()
              else ...[
                // إحصائيات سريعة
                _buildQuickStats(categories),
                
                const Spaces.medium,
                
                Text(
                  'جميع فئات الأذكار (${categories.length})',
                  style: context.titleStyle,
                ),
                
                const Spaces.small,
                
                Text(
                  'يمكنك تفعيل التذكيرات لأي فئة وتخصيص أوقاتها',
                  style: context.captionStyle,
                ),
                
                const Spaces.medium,
                
                ...categories.map((category) => 
                  _buildCategoryTile(category)
                ),
              ],
            ] else
              _buildPermissionRequiredMessage(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats(List<AthkarCategory> categories) {
    final enabledCount = _enabled.values.where((e) => e).length;
    final disabledCount = categories.length - enabledCount;
    
    return IslamicCard.simple(
      padding: EdgeInsets.all(context.mediumPadding),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.notifications_active,
              count: enabledCount,
              label: 'مفعلة',
              color: ThemeConstants.success,
            ),
          ),
          
          Container(
            width: 1,
            height: 40,
            color: context.borderColor,
          ),
          
          Expanded(
            child: _StatItem(
              icon: Icons.notifications_off,
              count: disabledCount,
              label: 'معطلة',
              color: context.secondaryTextColor,
            ),
          ),
          
          Container(
            width: 1,
            height: 40,
            color: context.borderColor,
          ),
          
          Expanded(
            child: _StatItem(
              icon: Icons.format_list_numbered,
              count: categories.length,
              label: 'الكل',
              color: context.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionSection() {
    return IslamicCard.simple(
      padding: EdgeInsets.all(context.mediumPadding),
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
              SizedBox(width: context.mediumPadding),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _hasPermission ? 'الإشعارات مفعلة' : 'الإشعارات معطلة',
                      style: context.titleStyle.copyWith(
                        color: _hasPermission ? ThemeConstants.success : ThemeConstants.warning,
                      ),
                    ),
                    Text(
                      _hasPermission 
                          ? 'يمكنك الآن تخصيص تذكيرات الأذكار'
                          : 'قم بتفعيل الإشعارات لتلقي التذكيرات',
                      style: context.captionStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!_hasPermission) ...[
            const Spaces.medium,
            SizedBox(
              width: double.infinity,
              child: IslamicButton.primary(
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

  Widget _buildNoCategoriesMessage() {
    return IslamicCard.simple(
      padding: EdgeInsets.all(context.largePadding),
      child: Column(
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 48,
            color: context.secondaryTextColor.withValues(alpha: 0.5),
          ),
          const Spaces.medium,
          Text(
            'لا توجد فئات أذكار',
            style: context.titleStyle.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
          const Spaces.small,
          Text(
            'لم يتم العثور على أي فئات للأذكار',
            style: context.bodyStyle.copyWith(
              color: context.secondaryTextColor.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRequiredMessage() {
    return IslamicCard.simple(
      padding: EdgeInsets.all(context.largePadding),
      child: Column(
        children: [
          const Icon(
            Icons.notifications_off_outlined,
            size: 48,
            color: ThemeConstants.warning,
          ),
          const Spaces.medium,
          Text(
            'الإشعارات مطلوبة',
            style: context.titleStyle.copyWith(
              color: ThemeConstants.warning,
            ),
          ),
          const Spaces.small,
          Text(
            'يجب تفعيل الإشعارات أولاً لتتمكن من إعداد تذكيرات الأذكار لجميع الفئات',
            style: context.bodyStyle.copyWith(
              color: context.secondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const Spaces.medium,
          IslamicButton.primary(
            text: 'تفعيل الإشعارات الآن',
            onPressed: _requestPermission,
            icon: Icons.notifications_active,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(AthkarCategory category) {
    final isEnabled = _enabled[category.id] ?? false;
    final currentTime = _customTimes[category.id] ?? 
        _getDefaultTimeForCategory(category.id);
    final hasOriginalTime = category.notifyTime != null;
    final isAutoEnabled = _shouldAutoEnable(category.id);

    return Padding(
      padding: EdgeInsets.only(bottom: context.mediumPadding),
      child: IslamicCard.simple(
        padding: EdgeInsets.all(context.mediumPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // أيقونة الفئة
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: ThemeConstants.iconMd,
                  ),
                ),
                
                SizedBox(width: context.mediumPadding),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              category.title,
                              style: context.titleStyle,
                            ),
                          ),
                          if (isAutoEnabled)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: ThemeConstants.spaceSm,
                                vertical: ThemeConstants.spaceXs,
                              ),
                              decoration: BoxDecoration(
                                color: ThemeConstants.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  ThemeConstants.radiusSm,
                                ),
                              ),
                              child: Text(
                                'أساسي',
                                style: context.captionStyle.copyWith(
                                  color: ThemeConstants.success,
                                  fontSize: 10,
                                  fontWeight: ThemeConstants.fontBold,
                                ),
                              ),
                            )
                          else if (!hasOriginalTime)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: ThemeConstants.spaceSm,
                                vertical: ThemeConstants.spaceXs,
                              ),
                              decoration: BoxDecoration(
                                color: ThemeConstants.info.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(
                                  ThemeConstants.radiusSm,
                                ),
                              ),
                              child: Text(
                                'مخصص',
                                style: context.captionStyle.copyWith(
                                  color: ThemeConstants.info,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (category.description?.isNotEmpty == true)
                        Text(
                          category.description!,
                          style: context.captionStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      
                      // عدد الأذكار
                      Row(
                        children: [
                          Text(
                            '${category.athkar.length} ذكر',
                            style: context.captionStyle.copyWith(
                              color: context.secondaryTextColor.withValues(alpha: 0.7),
                            ),
                          ),
                          if (isAutoEnabled) ...[
                            Text(
                              ' • ',
                              style: context.captionStyle.copyWith(
                                color: context.secondaryTextColor.withValues(alpha: 0.7),
                              ),
                            ),
                            Text(
                              'مفعل تلقائياً',
                              style: context.captionStyle.copyWith(
                                color: ThemeConstants.success,
                                fontWeight: ThemeConstants.fontMedium,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                
                Switch(
                  value: isEnabled,
                  onChanged: _hasPermission 
                      ? (value) => _toggleCategory(category.id, value)
                      : null,
                  thumbColor: WidgetStateProperty.resolveWith((states) {
                    if (states.contains(WidgetState.selected)) {
                      return isAutoEnabled ? ThemeConstants.success : ThemeConstants.primary;
                    }
                    return null;
                  }),
                ),
              ],
            ),
            
            if (isEnabled) ...[
              const Spaces.medium,
              Container(
                padding: EdgeInsets.all(context.mediumPadding),
                decoration: BoxDecoration(
                  color: (isAutoEnabled ? ThemeConstants.success : ThemeConstants.primary)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  border: Border.all(
                    color: (isAutoEnabled ? ThemeConstants.success : ThemeConstants.primary)
                        .withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: ThemeConstants.iconSm,
                      color: isAutoEnabled ? ThemeConstants.success : ThemeConstants.primary,
                    ),
                    SizedBox(width: context.smallPadding),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'وقت التذكير: ${currentTime.format(context)}',
                            style: context.bodyStyle.copyWith(
                              color: isAutoEnabled ? ThemeConstants.success : ThemeConstants.primary,
                              fontWeight: ThemeConstants.fontMedium,
                            ),
                          ),
                          if (!hasOriginalTime)
                            Text(
                              isAutoEnabled 
                                  ? 'وقت افتراضي للفئة الأساسية'
                                  : 'وقت افتراضي - يمكنك تغييره',
                              style: context.captionStyle.copyWith(
                                color: (isAutoEnabled ? ThemeConstants.success : ThemeConstants.primary)
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectTime(category.id, currentTime),
                      style: TextButton.styleFrom(
                        minimumSize: const Size(0, 32),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.mediumPadding,
                        ),
                      ),
                      child: const Text('تغيير'),
                    ),
                  ],
                ),
              ),
            ] else if (!hasOriginalTime) ...[
              const Spaces.small,
              Row(
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    size: ThemeConstants.iconXs,
                    color: context.secondaryTextColor.withValues(alpha: 0.7),
                  ),
                  SizedBox(width: context.smallPadding / 2),
                  Text(
                    'الوقت الافتراضي: ${currentTime.format(context)}',
                    style: context.captionStyle.copyWith(
                      color: context.secondaryTextColor.withValues(alpha: 0.7),
                    ),
                  ),
                  if (isAutoEnabled) ...[
                    Text(
                      ' (أساسي)',
                      style: context.captionStyle.copyWith(
                        color: ThemeConstants.success.withValues(alpha: 0.7),
                        fontWeight: ThemeConstants.fontMedium,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final int count;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: ThemeConstants.iconSm,
        ),
        SizedBox(height: context.smallPadding / 2),
        Text(
          '$count',
          style: context.titleStyle.copyWith(
            color: color,
            fontWeight: ThemeConstants.fontBold,
          ),
        ),
        Text(
          label,
          style: context.captionStyle,
        ),
      ],
    );
  }
}