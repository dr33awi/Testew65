// lib/features/athkar/screens/notification_settings_screen.dart
import 'package:flutter/material.dart';
import 'package:athkar_app/app/di/service_locator.dart';
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:athkar_app/core/infrastructure/services/permissions/permission_service.dart';
import 'package:athkar_app/core/infrastructure/services/notifications/notification_manager.dart';
import '../models/athkar_model.dart';
import '../services/athkar_service.dart';

/// شاشة إعدادات تذكيرات الأذكار
class AthkarNotificationSettingsScreen extends StatefulWidget {
  const AthkarNotificationSettingsScreen({super.key});

  @override
  State<AthkarNotificationSettingsScreen> createState() => _AthkarNotificationSettingsScreenState();
}

class _AthkarNotificationSettingsScreenState extends State<AthkarNotificationSettingsScreen>
    with SingleTickerProviderStateMixin {
  late final AthkarService _athkarService;
  late final PermissionService _permissionService;
  late final AnimationController _animationController;
  
  List<AthkarCategory> _categories = [];
  Map<String, bool> _enabledMap = {};
  Map<String, TimeOfDay> _customTimes = {};
  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;
  bool _hasNotificationPermission = false;

  @override
  void initState() {
    super.initState();
    _athkarService = getService<AthkarService>();
    _permissionService = getService<PermissionService>();
    _animationController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // فحص إذن الإشعارات
      _hasNotificationPermission = await _permissionService.checkNotificationPermission();

      // تحميل الفئات
      final categories = await _athkarService.loadCategories();
      
      // تحميل الإعدادات الحالية
      final enabledIds = _athkarService.getEnabledReminderCategories();
      final customTimes = _athkarService.getCustomTimes();
      
      // إنشاء خريطة التفعيل
      final enabledMap = <String, bool>{};
      for (final category in categories) {
        enabledMap[category.id] = enabledIds.contains(category.id);
      }

      if (mounted) {
        setState(() {
          _categories = categories;
          _enabledMap = enabledMap;
          _customTimes = customTimes;
          _isLoading = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveSettings() async {
    if (_isSaving) return;
    
    try {
      setState(() {
        _isSaving = true;
      });

      // حفظ الأوقات المخصصة
      await _athkarService.setCustomTimes(_customTimes);
      
      // تحديث إعدادات التذكيرات مع إعادة الجدولة
      await _athkarService.updateReminderSettings(_enabledMap);

      context.showSuccessSnackBar('تم حفظ الإعدادات بنجاح');
    } catch (e) {
      context.showErrorSnackBar('خطأ في حفظ الإعدادات');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _requestNotificationPermission() async {
    try {
      final granted = await _permissionService.requestNotificationPermission();
      
      if (mounted) {
        setState(() {
          _hasNotificationPermission = granted;
        });
        
        if (granted) {
          context.showSuccessSnackBar('تم منح إذن الإشعارات');
        } else {
          context.showErrorSnackBar('تم رفض إذن الإشعارات');
        }
      }
    } catch (e) {
      context.showErrorSnackBar('خطأ في طلب الإذن');
    }
  }

  Future<void> _selectTimeForCategory(AthkarCategory category) async {
    final currentTime = _customTimes[category.id] ?? category.notifyTime ?? TimeOfDay.now();
    
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
      helpText: 'اختر وقت التذكير لـ ${category.title}',
      cancelText: 'إلغاء',
      confirmText: 'تأكيد',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: context.cardColor,
              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              ),
              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedTime != null) {
      setState(() {
        _customTimes[category.id] = selectedTime;
      });
    }
  }

  void _resetToDefaultTime(AthkarCategory category) {
    setState(() {
      _customTimes.remove(category.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.simple(
        title: 'إعدادات تذكيرات الأذكار',
        actions: [
          if (_isSaving)
            Padding(
              padding: const EdgeInsets.all(ThemeConstants.space4),
              child: AppLoading.inline(),
            )
          else
            AppBarAction(
              icon: Icons.save,
              onPressed: _saveSettings,
              tooltip: 'حفظ',
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: AppLoading.page(
          message: 'جاري تحميل الإعدادات...',
        ),
      );
    }

    if (_error != null) {
      return AppEmptyState.error(
        message: _error,
        onRetry: _loadData,
      );
    }

    return SingleChildScrollView(
      padding: context.appResponsivePadding,
      child: Column(
        children: [
          // بطاقة إذن الإشعارات
          _buildPermissionCard(),
          
          const SizedBox(height: ThemeConstants.space4),
          
          // بطاقة الإعدادات العامة
          _buildGeneralSettingsCard(),
          
          const SizedBox(height: ThemeConstants.space4),
          
          // قائمة فئات الأذكار
          _buildCategoriesList(),
          
          // مساحة إضافية في الأسفل
          const SizedBox(height: ThemeConstants.space8),
        ],
      ),
    );
  }

  Widget _buildPermissionCard() {
    return AppCard.info(
      title: 'إذن الإشعارات',
      subtitle: _hasNotificationPermission 
          ? 'تم منح الإذن - ستصلك التذكيرات'
          : 'مطلوب إذن الإشعارات لتفعيل التذكيرات',
      icon: _hasNotificationPermission ? Icons.notifications_active : Icons.notifications_off,
      iconColor: _hasNotificationPermission ? AppColorSystem.success : AppColorSystem.warning,
      trailing: _hasNotificationPermission 
          ? Icon(Icons.check_circle, color: AppColorSystem.success)
          : AppButton.primary(
              text: 'طلب الإذن',
              onPressed: _requestNotificationPermission,
              size: ButtonSize.medium,
            ),
    );
  }

  Widget _buildGeneralSettingsCard() {
    final enabledCount = _enabledMap.values.where((enabled) => enabled).length;
    
    return AppContainerBuilder.card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.settings,
                color: context.primaryColor,
                size: ThemeConstants.iconMd,
              ),
              const SizedBox(width: ThemeConstants.space3),
              Expanded(
                child: Text(
                  'الإعدادات العامة',
                  style: AppTextStyles.h5.copyWith(
                    fontWeight: ThemeConstants.semiBold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: ThemeConstants.space4),
          
          // إحصائيات سريعة
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space3),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.category,
                    label: 'الفئات',
                    value: '${_categories.length}',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: context.dividerColor,
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.notifications,
                    label: 'المفعلة',
                    value: '$enabledCount',
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: context.dividerColor,
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.schedule,
                    label: 'مخصصة',
                    value: '${_customTimes.length}',
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space4),
          
          // أزرار الإجراءات السريعة
          Row(
            children: [
              Expanded(
                child: AppButton.outline(
                  text: 'تفعيل الكل',
                  onPressed: _enableAll,
                  icon: Icons.select_all,
                ),
              ),
              const SizedBox(width: ThemeConstants.space3),
              Expanded(
                child: AppButton.outline(
                  text: 'إلغاء الكل',
                  onPressed: _disableAll,
                  icon: Icons.clear_all,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: context.primaryColor,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.h5.copyWith(
            fontWeight: ThemeConstants.bold,
            color: context.primaryColor,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: context.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'فئات الأذكار',
          style: AppTextStyles.h5.copyWith(
            fontWeight: ThemeConstants.semiBold,
          ),
        ),
        
        const SizedBox(height: ThemeConstants.space3),
        
        AnimationLimiter(
          child: Column(
            children: List.generate(
              _categories.length,
              (index) {
                final category = _categories[index];
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: ThemeConstants.durationNormal,
                  child: SlideAnimation(
                    verticalOffset: 30.0,
                    child: FadeInAnimation(
                      child: _buildCategoryCard(category),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryCard(AthkarCategory category) {
    final isEnabled = _enabledMap[category.id] ?? false;
    final hasCustomTime = _customTimes.containsKey(category.id);
    final effectiveTime = _customTimes[category.id] ?? category.notifyTime;
    
    return Container(
      margin: const EdgeInsets.only(bottom: ThemeConstants.space3),
      child: AppContainerBuilder.card(
        child: Column(
          children: [
            // الرأس الرئيسي
            Row(
              children: [
                // أيقونة الفئة
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: category.color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                  ),
                  child: Icon(
                    category.icon,
                    color: category.color,
                    size: 24,
                  ),
                ),
                
                const SizedBox(width: ThemeConstants.space3),
                
                // معلومات الفئة
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.title,
                        style: AppTextStyles.h5.copyWith(
                          fontWeight: ThemeConstants.semiBold,
                        ),
                      ),
                      if (category.description != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          category.description!,
                          style: AppTextStyles.caption.copyWith(
                            color: context.textSecondaryColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                
                // مفتاح التفعيل
                Switch.adaptive(
                  value: isEnabled,
                  onChanged: _hasNotificationPermission 
                      ? (value) {
                          setState(() {
                            _enabledMap[category.id] = value;
                          });
                        }
                      : null,
                  activeColor: category.color,
                ),
              ],
            ),
            
            // إعدادات الوقت (إذا كانت مفعلة)
            if (isEnabled) ...[
              const SizedBox(height: ThemeConstants.space3),
              Divider(color: context.dividerColor),
              const SizedBox(height: ThemeConstants.space3),
              
              _buildTimeSettings(category, effectiveTime, hasCustomTime),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSettings(AthkarCategory category, TimeOfDay? effectiveTime, bool hasCustomTime) {
    return Row(
      children: [
        Icon(
          Icons.schedule,
          color: context.textSecondaryColor,
          size: 20,
        ),
        const SizedBox(width: ThemeConstants.space2),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'وقت التذكير',
                style: AppTextStyles.label2.copyWith(
                  fontWeight: ThemeConstants.medium,
                ),
              ),
              if (effectiveTime != null) ...[
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      '${effectiveTime.hour.toString().padLeft(2, '0')}:${effectiveTime.minute.toString().padLeft(2, '0')}',
                      style: AppTextStyles.body2.copyWith(
                        color: context.primaryColor,
                        fontWeight: ThemeConstants.semiBold,
                      ),
                    ),
                    if (hasCustomTime) ...[
                      const SizedBox(width: ThemeConstants.space1),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColorSystem.info.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'مخصص',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColorSystem.info,
                            fontWeight: ThemeConstants.medium,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ] else ...[
                Text(
                  'لم يتم تحديد وقت',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColorSystem.warning,
                  ),
                ),
              ],
            ],
          ),
        ),
        
        // أزرار التحكم
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _selectTimeForCategory(category),
              icon: Icon(
                hasCustomTime ? Icons.edit : Icons.add_alarm,
                size: 20,
              ),
              tooltip: hasCustomTime ? 'تعديل الوقت' : 'تحديد وقت مخصص',
            ),
            if (hasCustomTime)
              IconButton(
                onPressed: () => _resetToDefaultTime(category),
                icon: const Icon(
                  Icons.restore,
                  size: 20,
                ),
                tooltip: 'العودة للوقت الافتراضي',
              ),
          ],
        ),
      ],
    );
  }

  // دوال مساعدة
  void _enableAll() {
    setState(() {
      for (final category in _categories) {
        _enabledMap[category.id] = true;
      }
    });
  }

  void _disableAll() {
    setState(() {
      for (final category in _categories) {
        _enabledMap[category.id] = false;
      }
    });
  }
}