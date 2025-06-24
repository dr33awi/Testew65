// lib/features/athkar/screens/notification_settings_screen.dart (مُصلح نهائياً)
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
  final Map<String, TimeOfDay> _originalTimes = {}; // للتتبع الأوقات الأصلية
  bool _saving = false;
  bool _hasPermission = false;
  bool _isLoading = true;
  String? _errorMessage;

  // أوقات افتراضية محدثة وموحدة
  static const Map<String, TimeOfDay> _defaultTimes = {
    'morning': TimeOfDay(hour: 6, minute: 0),      // أذكار الصباح
    'الصباح': TimeOfDay(hour: 6, minute: 0),
    'أذكار الصباح': TimeOfDay(hour: 6, minute: 0),
    
    'evening': TimeOfDay(hour: 18, minute: 0),     // أذكار المساء  
    'المساء': TimeOfDay(hour: 18, minute: 0),
    'أذكار المساء': TimeOfDay(hour: 18, minute: 0),
    
    'sleep': TimeOfDay(hour: 22, minute: 0),       // أذكار النوم
    'النوم': TimeOfDay(hour: 22, minute: 0), 
    'أذكار النوم': TimeOfDay(hour: 22, minute: 0),
    
    'wakeup': TimeOfDay(hour: 5, minute: 30),      // أذكار الاستيقاظ
    'الاستيقاظ': TimeOfDay(hour: 5, minute: 30),
    
    'prayer': TimeOfDay(hour: 12, minute: 0),      // أذكار الصلاة
    'الصلاة': TimeOfDay(hour: 12, minute: 0),
    'بعد الصلاة': TimeOfDay(hour: 12, minute: 0),
    'أذكار بعد الصلاة': TimeOfDay(hour: 12, minute: 0),
    
    'eating': TimeOfDay(hour: 19, minute: 0),      // أذكار الطعام
    'الطعام': TimeOfDay(hour: 19, minute: 0),
    
    'travel': TimeOfDay(hour: 8, minute: 0),       // أذكار السفر
    'السفر': TimeOfDay(hour: 8, minute: 0),
    'أذكار السفر': TimeOfDay(hour: 8, minute: 0),
    
    'general': TimeOfDay(hour: 14, minute: 0),     // أذكار عامة
    'عامة': TimeOfDay(hour: 14, minute: 0),
    'أذكار عامة': TimeOfDay(hour: 14, minute: 0),
  };

  // الفئات التي يجب تفعيلها تلقائياً
  static const Set<String> _autoEnabledCategories = {
    'morning', 'الصباح', 'أذكار الصباح',
    'evening', 'المساء', 'أذكار المساء',
    'sleep', 'النوم', 'أذكار النوم',
  };

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _permissionService = getIt<PermissionService>();
    _logger = getIt<LoggerService>();
    _loadData();
  }

  /// الحصول على الوقت الافتراضي للفئة مع تطابق أفضل
  TimeOfDay _getDefaultTimeForCategory(String categoryId) {
    // البحث عن تطابق مباشر أولاً
    if (_defaultTimes.containsKey(categoryId)) {
      return _defaultTimes[categoryId]!;
    }
    
    // البحث عن تطابق جزئي
    final normalizedId = categoryId.toLowerCase().trim();
    for (final entry in _defaultTimes.entries) {
      if (normalizedId.contains(entry.key.toLowerCase()) || 
          entry.key.toLowerCase().contains(normalizedId)) {
        return entry.value;
      }
    }
    
    // وقت افتراضي عام
    return const TimeOfDay(hour: 9, minute: 0);
  }

  /// التحقق من أن الفئة يجب تفعيلها تلقائياً
  bool _shouldAutoEnable(String categoryId) {
    final normalizedId = categoryId.toLowerCase().trim();
    return _autoEnabledCategories.any((category) => 
        normalizedId.contains(category.toLowerCase()) || 
        category.toLowerCase().contains(normalizedId));
  }

  /// الحصول على NotificationManager مع التحقق من التهيئة
  Future<NotificationManager?> _getNotificationManager() async {
    try {
      return NotificationManager.instance;
    } catch (e) {
      _logger.error(message: '[NotificationSettings] NotificationManager غير مهيأ - $e');
      return null;
    }
  }

  /// تحميل البيانات مع معالجة محسنة للأخطاء
  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      _logger.info(message: '[NotificationSettings] بدء تحميل البيانات');
      
      // التحقق من إذن الإشعارات
      _hasPermission = await _permissionService.checkNotificationPermission();
      _logger.debug(message: '[NotificationSettings] حالة الإذن: $_hasPermission');
      
      // تحميل جميع الفئات
      final allCategories = await _service.loadCategories();
      _logger.info(message: '[NotificationSettings] تم تحميل ${allCategories.length} فئة');
      
      // تحميل الإعدادات المحفوظة
      final enabledIds = _service.getEnabledReminderCategories();
      final savedCustomTimes = _loadSavedCustomTimes();
      
      // التحقق من أول تشغيل
      final isFirstLaunch = enabledIds.isEmpty && savedCustomTimes.isEmpty;
      _logger.debug(message: '[NotificationSettings] أول تشغيل: $isFirstLaunch');
      
      // تهيئة البيانات
      _enabled.clear();
      _customTimes.clear();
      _originalTimes.clear();
      
      final autoEnabledIds = <String>[];
      
      for (final category in allCategories) {
        // حفظ الوقت الأصلي
        _originalTimes[category.id] = category.notifyTime ?? 
            _getDefaultTimeForCategory(category.id);
        
        // تحديد حالة التفعيل
        bool shouldEnable = enabledIds.contains(category.id);
        
        if (isFirstLaunch && _shouldAutoEnable(category.id)) {
          shouldEnable = true;
          autoEnabledIds.add(category.id);
        }
        
        _enabled[category.id] = shouldEnable;
        
        // تحديد الوقت (مخصص أو افتراضي)
        _customTimes[category.id] = savedCustomTimes[category.id] ?? 
            _originalTimes[category.id]!;
      }
      
      // في أول تشغيل، حفظ الإعدادات الافتراضية
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

  /// حفظ الإعدادات الأولية
  Future<void> _saveInitialSettings(List<String> autoEnabledIds) async {
    try {
      _logger.info(message: '[NotificationSettings] حفظ الإعدادات الأولية');
      
      // حفظ الفئات المفعلة
      await _service.setEnabledReminderCategories(autoEnabledIds);
      
      // حفظ الأوقات المخصصة  
      await _saveCustomTimes();
      
      // جدولة الإشعارات إذا كانت الأذونات متاحة
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

  /// تحميل الأوقات المخصصة المحفوظة
  Map<String, TimeOfDay> _loadSavedCustomTimes() {
    try {
      final savedTimes = _service.getCustomTimes();
      return savedTimes;
    } catch (e) {
      _logger.warning(message: '[NotificationSettings] فشل تحميل الأوقات المخصصة - $e');
      return {};
    }
  }

  /// حفظ الأوقات المخصصة
  Future<void> _saveCustomTimes() async {
    try {
      await _service.setCustomTimes(_customTimes);
      _logger.debug(message: '[NotificationSettings] تم حفظ الأوقات المخصصة');
    } catch (e) {
      _logger.error(message: '[NotificationSettings] فشل حفظ الأوقات المخصصة - $e');
    }
  }

  /// طلب إذن الإشعارات
  Future<void> _requestPermission() async {
    try {
      _logger.info(message: '[NotificationSettings] طلب إذن الإشعارات');
      
      final granted = await _permissionService.requestNotificationPermission();
      setState(() => _hasPermission = granted);
      
      _logger.info(message: '[NotificationSettings] نتيجة طلب الإذن: $granted');
      
      // إذا تم منح الإذن، جدولة الإشعارات المفعلة
      if (granted) {
        await _scheduleEnabledNotifications();
      }
      
    } catch (e) {
      _logger.error(message: '[NotificationSettings] فشل طلب إذن الإشعارات - $e');
    }
  }

  /// جدولة الإشعارات المفعلة
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

  /// تفعيل/إلغاء فئة
  Future<void> _toggleCategory(String categoryId, bool value) async {
    setState(() {
      _enabled[categoryId] = value;
    });
    
    _logger.debug(message: '[NotificationSettings] تغيير حالة الفئة $categoryId إلى $value');
    
    await _saveChanges();
  }

  /// تحديث وقت الفئة
  Future<void> _updateTime(String categoryId, TimeOfDay time) async {
    setState(() {
      _customTimes[categoryId] = time;
    });
    
    _logger.debug(message: '[NotificationSettings] تحديث وقت الفئة $categoryId إلى ${time.hour}:${time.minute}');
    
    await _saveChanges();
  }

  /// حفظ التغييرات مع جدولة الإشعارات
  Future<void> _saveChanges() async {
    if (_saving) return;
    
    setState(() => _saving = true);
    
    try {
      _logger.info(message: '[NotificationSettings] بدء حفظ التغييرات');
      
      // 1. حفظ الفئات المفعلة
      final enabledIds = _enabled.entries
          .where((e) => e.value)
          .map((e) => e.key)
          .toList();
      
      await _service.setEnabledReminderCategories(enabledIds);
      
      // 2. حفظ الأوقات المخصصة
      await _saveCustomTimes();
      
      // 3. إدارة الإشعارات
      if (_hasPermission) {
        final notificationManager = await _getNotificationManager();
        if (notificationManager != null) {
          // إلغاء جميع الإشعارات السابقة
          await notificationManager.cancelAllAthkarReminders();
          
          // جدولة إشعارات جديدة للفئات المفعلة
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

  /// اختيار وقت جديد للفئة
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
      
      // تفعيل الفئة تلقائياً عند تغيير الوقت
      if (!(_enabled[categoryId] ?? false)) {
        await _toggleCategory(categoryId, true);
      }
    }
  }

  /// تفعيل جميع التذكيرات
  Future<void> _enableAllReminders() async {
    HapticFeedback.mediumImpact();
    
    final shouldEnable = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تفعيل جميع التذكيرات'),
        content: const Text('هل تريد تفعيل تذكيرات جميع فئات الأذكار بالأوقات الحالية؟'),
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

  /// إيقاف جميع التذكيرات
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
      appBar: AppBar(
        title: const Text('إشعارات الأذكار'),
        centerTitle: true,
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
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: context.errorColor,
            ),
            const SizedBox(height: 16),
            Text(
              'خطأ في التحميل',
              style: context.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: context.bodyMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('المحاولة مرة أخرى'),
            ),
          ],
        ),
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
            // حالة الإذن
            _buildPermissionSection(),
            
            const SizedBox(height: 24),
            
            // قائمة الفئات
            if (_hasPermission) ...[
              if (categories.isEmpty)
                _buildNoCategoriesMessage()
              else ...[
                // إحصائيات سريعة
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

  Widget _buildPermissionSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.dividerColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _hasPermission ? Icons.notifications_active : Icons.notifications_off,
                color: _hasPermission ? Colors.green : Colors.orange,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _hasPermission ? 'الإشعارات مفعلة' : 'الإشعارات معطلة',
                      style: context.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: _hasPermission ? Colors.green : Colors.orange,
                      ),
                    ),
                    Text(
                      _hasPermission 
                          ? 'يمكنك الآن تخصيص تذكيرات الأذكار'
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
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _requestPermission,
                icon: const Icon(Icons.notifications),
                label: const Text('تفعيل الإشعارات'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickStats(List<AthkarCategory> categories) {
    final enabledCount = _enabled.values.where((e) => e).length;
    final disabledCount = categories.length - enabledCount;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.dividerColor),
      ),
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.notifications_active,
              count: enabledCount,
              label: 'مفعلة',
              color: Colors.green,
            ),
          ),
          
          Container(
            width: 1,
            height: 40,
            color: context.dividerColor,
          ),
          
          Expanded(
            child: _StatItem(
              icon: Icons.notifications_off,
              count: disabledCount,
              label: 'معطلة',
              color: context.textSecondaryColor,
            ),
          ),
          
          Container(
            width: 1,
            height: 40,
            color: context.dividerColor,
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

  Widget _buildNoCategoriesMessage() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 48,
            color: context.textSecondaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Text(
            'لا توجد فئات أذكار',
            style: context.titleMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'لم يتم العثور على أي فئات للأذكار',
            style: context.bodyMedium?.copyWith(
              color: context.textSecondaryColor.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionRequiredMessage() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 48,
            color: Colors.orange,
          ),
          const SizedBox(height: 12),
          Text(
            'الإشعارات مطلوبة',
            style: context.titleMedium?.copyWith(
              color: Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'يجب تفعيل الإشعارات أولاً لتتمكن من إعداد تذكيرات الأذكار لجميع الفئات',
            style: context.bodyMedium?.copyWith(
              color: context.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _requestPermission,
            icon: const Icon(Icons.notifications_active),
            label: const Text('تفعيل الإشعارات الآن'),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTile(AthkarCategory category) {
    final isEnabled = _enabled[category.id] ?? false;
    final currentTime = _customTimes[category.id] ?? 
        _getDefaultTimeForCategory(category.id);
    final originalTime = _originalTimes[category.id];
    final hasCustomTime = originalTime != null && currentTime != originalTime;
    final isAutoEnabled = _shouldAutoEnable(category.id);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.dividerColor),
        ),
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
                    color: category.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 20,
                  ),
                ),
                
                const SizedBox(width: 12),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              category.title,
                              style: context.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (isAutoEnabled)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'أساسي',
                                style: context.labelSmall?.copyWith(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          else if (hasCustomTime)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'مخصص',
                                style: context.labelSmall?.copyWith(
                                  color: Colors.blue,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (category.description?.isNotEmpty == true)
                        Text(
                          category.description!,
                          style: context.bodySmall?.copyWith(
                            color: context.textSecondaryColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      
                      // عدد الأذكار
                      Row(
                        children: [
                          Text(
                            '${category.athkar.length} ذكر',
                            style: context.labelSmall?.copyWith(
                              color: context.textSecondaryColor.withOpacity(0.7),
                            ),
                          ),
                          if (isAutoEnabled) ...[
                            Text(
                              ' • ',
                              style: context.labelSmall?.copyWith(
                                color: context.textSecondaryColor.withOpacity(0.7),
                              ),
                            ),
                            Text(
                              'مفعل تلقائياً',
                              style: context.labelSmall?.copyWith(
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
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
                  activeColor: isAutoEnabled ? Colors.green : context.primaryColor,
                ),
              ],
            ),
            
            if (isEnabled) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isAutoEnabled ? Colors.green : context.primaryColor)
                      .withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: (isAutoEnabled ? Colors.green : context.primaryColor)
                        .withOpacity(0.2),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: isAutoEnabled ? Colors.green : context.primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'وقت التذكير: ${currentTime.format(context)}',
                            style: context.bodyMedium?.copyWith(
                              color: isAutoEnabled ? Colors.green : context.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (hasCustomTime)
                            Text(
                              'تم تخصيص الوقت',
                              style: context.labelSmall?.copyWith(
                                color: (isAutoEnabled ? Colors.green : context.primaryColor)
                                    .withOpacity(0.7),
                              ),
                            )
                          else if (originalTime == null)
                            Text(
                              'وقت افتراضي - يمكنك تغييره',
                              style: context.labelSmall?.copyWith(
                                color: (isAutoEnabled ? Colors.green : context.primaryColor)
                                    .withOpacity(0.7),
                              ),
                            ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectTime(category.id, currentTime),
                      style: TextButton.styleFrom(
                        minimumSize: const Size(0, 32),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                      child: const Text('تغيير'),
                    ),
                  ],
                ),
              ),
            ] else if (originalTime == null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    size: 12,
                    color: context.textSecondaryColor.withOpacity(0.7),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'الوقت الافتراضي: ${currentTime.format(context)}',
                    style: context.labelSmall?.copyWith(
                      color: context.textSecondaryColor.withOpacity(0.7),
                    ),
                  ),
                  if (isAutoEnabled) ...[
                    Text(
                      ' (أساسي)',
                      style: context.labelSmall?.copyWith(
                        color: Colors.green.withOpacity(0.7),
                        fontWeight: FontWeight.w500,
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
          size: 16,
        ),
        const SizedBox(height: 4),
        Text(
          '$count',
          style: context.titleMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: context.labelSmall?.copyWith(
            color: context.textSecondaryColor,
          ),
        ),
      ],
    );
  }
}