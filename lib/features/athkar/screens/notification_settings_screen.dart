// lib/features/athkar/screens/notification_settings_screen.dart - موحد مع النظام
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
      print('🔍 بدء تحميل البيانات...');
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
      
      print('✅ تحقق من الإذن...');
      _hasPermission = await _permissionService.checkNotificationPermission();
      print('📱 حالة الإذن: $_hasPermission');
      
      print('📚 تحميل الفئات...');
      final allCategories = await _service.loadCategories();
      print('📚 تم تحميل ${allCategories.length} فئة');
      
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
      
      if (mounted) { // ✅ تحقق من أن Widget ما زال mounted
        setState(() {
          _categories = allCategories;
          _isLoading = false;
        });
        print('✅ تم تحميل البيانات بنجاح');
      }
      
    } catch (e, stackTrace) {
      print('❌ خطأ في تحميل البيانات: $e');
      print('📍 Stack trace: $stackTrace');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'فشل في تحميل البيانات. يرجى المحاولة مرة أخرى.';
        });
      }
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
        AppSnackBar.showSuccess(
          context: context,
          message: 'تم تفعيل الإشعارات بنجاح',
        );
      }
    } catch (e) {
      _logger.error(message: 'فشل طلب إذن الإشعارات - $e');
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
    HapticFeedback.lightImpact();
    setState(() => _enabled[categoryId] = value);
    await _saveChanges();
    
    final category = _categories?.firstWhere((c) => c.id == categoryId);
    if (category != null) {
      AppSnackBar.show(
        context: context,
        message: value 
            ? 'تم تفعيل تذكير ${category.title}'
            : 'تم إيقاف تذكير ${category.title}',
        icon: value ? Icons.notifications_active : Icons.notifications_off,
        backgroundColor: value ? context.successColor : context.textSecondaryColor,
      );
    }
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
      HapticFeedback.mediumImpact();
      await _updateTime(categoryId, selectedTime);
      if (!(_enabled[categoryId] ?? false)) {
        await _toggleCategory(categoryId, true);
      }
      
      AppSnackBar.showSuccess(
        context: context,
        message: 'تم تحديث الوقت إلى ${selectedTime.format(context)}',
      );
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
      accentColor: context.successColor,
    );
    
    if (shouldEnable == true) {
      setState(() {
        for (final category in _categories ?? <AthkarCategory>[]) {
          _enabled[category.id] = true;
        }
      });
      await _saveChanges();
      
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
      accentColor: ThemeConstants.warning,
    );
    
    if (shouldDisable == true) {
      setState(() {
        for (final category in _categories ?? <AthkarCategory>[]) {
          _enabled[category.id] = false;
        }
      });
      await _saveChanges();
      
      AppSnackBar.showWarning(
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
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // بطاقة حالة الإشعارات باستخدام النظام الموحد
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(ThemeConstants.space4),
              child: _buildPermissionCard(),
            ),
          ),
          
          if (_hasPermission && categories.isNotEmpty) ...[
            // إحصائيات سريعة
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
                child: _buildQuickStats(categories),
              ),
            ),
            
            const SliverToBoxAdapter(
              child: SizedBox(height: ThemeConstants.space6),
            ),
            
            // عنوان القائمة
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'جميع فئات الأذكار (${categories.length})',
                      style: context.titleMedium?.copyWith(
                        fontWeight: ThemeConstants.bold,
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.space1),
                    Text(
                      'اضغط على الفئة لتغيير الوقت، واستخدم المفتاح للتفعيل/الإيقاف',
                      style: context.bodySmall?.copyWith(
                        color: context.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SliverToBoxAdapter(
              child: SizedBox(height: ThemeConstants.space4),
            ),
            
            // قائمة الفئات
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = categories[index];
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index < categories.length - 1 
                            ? ThemeConstants.space3 
                            : ThemeConstants.space8,
                      ),
                      child: _buildCategoryCard(category),
                    );
                  },
                  childCount: categories.length,
                ),
              ),
            ),
          ] else if (_hasPermission && categories.isEmpty)
            SliverFillRemaining(
              child: AppEmptyState.noData(
                message: 'لم يتم العثور على أي فئات للأذكار',
              ),
            )
          else
            SliverFillRemaining(
              child: Padding(
                padding: const EdgeInsets.all(ThemeConstants.space4),
                child: _buildPermissionWarning(),
              ),
            ),
        ],
      ),
    );
  }

  /// ✅ بطاقة حالة الإشعارات باستخدام النظام الموحد
  Widget _buildPermissionCard() {
    if (_hasPermission) {
      return AppCard.glassWelcome(
        title: 'الإشعارات مفعلة ✅',
        subtitle: 'يمكنك الآن تخصيص تذكيرات الأذكار',
        primaryColor: context.successColor,
        onTap: () {
          // يمكن إضافة إجراء اختياري
        },
      );
    }
    
    return AppCard.glassWelcome(
      title: 'تفعيل الإشعارات 🔔',
      subtitle: 'اضغط هنا لتفعيل تذكيرات الأذكار',
      primaryColor: context.warningColor,
      onTap: _requestPermission,
    );
  }

  /// ✅ تحذير الإشعارات باستخدام النظام الموحد
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

  /// ✅ إحصائيات سريعة بتصميم بسيط - مُصححة
  Widget _buildQuickStats(List<AthkarCategory> categories) {
    final enabledCount = _enabled.values.where((e) => e).length;
    final disabledCount = categories.length - enabledCount;
    
    return Row(
      children: [
        Expanded(
          child: _buildSimpleStatCard(
            title: 'مفعلة',
            value: '$enabledCount',
            icon: Icons.notifications_active,
            color: context.successColor,
          ),
        ),
        const SizedBox(width: ThemeConstants.space3),
        Expanded(
          child: _buildSimpleStatCard(
            title: 'معطلة',
            value: '$disabledCount',
            icon: Icons.notifications_off,
            color: context.textSecondaryColor,
          ),
        ),
        const SizedBox(width: ThemeConstants.space3),
        Expanded(
          child: _buildSimpleStatCard(
            title: 'الكل',
            value: '${categories.length}',
            icon: Icons.format_list_numbered,
            color: context.primaryColor,
          ),
        ),
      ],
    );
  }

  /// ✅ بطاقة إحصائية بسيطة بدون مشاكل layout
  Widget _buildSimpleStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.darken(0.2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.space3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: context.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: ThemeConstants.bold,
                shadows: const [
                  Shadow(
                    color: Colors.black26,
                    offset: Offset(0, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: context.bodySmall?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: ThemeConstants.medium,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ بطاقة الفئة باستخدام النظام الموحد مع ألوان الفئات
  Widget _buildCategoryCard(AthkarCategory category) {
    final isEnabled = _enabled[category.id] ?? false;
    final currentTime = _customTimes[category.id] ?? 
        CategoryHelper.getDefaultReminderTime(category.id);
    final originalTime = _originalTimes[category.id];
    final hasCustomTime = originalTime != null && currentTime != originalTime;
    
    // ✅ استخدام نفس نظام الألوان من الشاشات الأخرى
    final categoryColor = CategoryHelper.getCategoryColor(context, category.id);
    final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
    final categoryDescription = CategoryHelper.getCategoryDescription(category.id);

    return AppCard(
      type: CardType.normal,
      style: CardStyle.gradient, // ✅ نفس النمط المستخدم في athkar_details
      primaryColor: isEnabled ? categoryColor : context.textSecondaryColor,
      gradientColors: isEnabled ? [
        categoryColor,                    // ✅ نفس التدرج
        categoryColor.darken(0.2),
      ] : [
        context.textSecondaryColor.withValues(alpha: 0.3),
        context.textSecondaryColor.withValues(alpha: 0.5),
      ],
      onTap: isEnabled ? () => _selectTime(category.id, currentTime) : null,
      margin: EdgeInsets.zero,
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Row(
        children: [
          // ✅ أيقونة دائرية موحدة
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
              size: 24,
            ),
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
                      Shadow(
                        color: Colors.black26, 
                        offset: Offset(0, 1), 
                        blurRadius: 2,
                      ),
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8, 
                      vertical: 2,
                    ),
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
                            fontWeight: hasCustomTime 
                                ? ThemeConstants.bold 
                                : ThemeConstants.regular,
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
            activeTrackColor: Colors.white.withOpacitySafe(0.3),
            inactiveThumbColor: context.textSecondaryColor,
            inactiveTrackColor: context.dividerColor,
          ),
        ],
      ),
    );
  }
}