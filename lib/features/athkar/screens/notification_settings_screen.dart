// lib/features/athkar/screens/notification_settings_screen.dart
import 'package:flutter/material.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/themes/index.dart';
import '../../../core/infrastructure/services/notifications/notification_manager.dart';
import '../../../core/infrastructure/services/notifications/models/notification_models.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';

/// شاشة إعدادات تذكيرات الأذكار
class AthkarNotificationSettingsScreen extends StatefulWidget {
  const AthkarNotificationSettingsScreen({super.key});

  @override
  State<AthkarNotificationSettingsScreen> createState() => _AthkarNotificationSettingsScreenState();
}

class _AthkarNotificationSettingsScreenState extends State<AthkarNotificationSettingsScreen>
    with TickerProviderStateMixin {
  late final AthkarService _athkarService;
  late final PermissionService _permissionService;
  late AnimationController _animationController;

  List<AthkarCategory> _categories = [];
  NotificationSettings _notificationSettings = const NotificationSettings();
  Map<String, bool> _categorySettings = {};
  bool _isLoading = true;
  bool _hasPermission = false;
  String? _error;

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

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // تحميل الأذونات
      _hasPermission = await _permissionService.checkNotificationPermission();

      // تحميل الإعدادات
      _notificationSettings = await NotificationManager.instance.getSettings();

      // تحميل الفئات
      _categories = await _athkarService.loadCategories();

      // تحميل إعدادات الفئات
      final enabledIds = _athkarService.getEnabledReminderCategories();
      _categorySettings = {
        for (final category in _categories)
          category.id: enabledIds.contains(category.id)
      };

      setState(() {
        _isLoading = false;
      });

      _animationController.forward();
    } catch (e) {
      setState(() {
        _error = 'حدث خطأ في تحميل الإعدادات';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return IslamicAppBar(
      title: 'إعدادات التذكيرات',
      actions: [
        if (!_isLoading && _hasPermission) ...[
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveSettings,
            tooltip: 'حفظ الإعدادات',
          ),
        ],
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const IslamicLoading(
        message: 'جاري تحميل الإعدادات...',
      );
    }

    if (_error != null) {
      return EmptyState(
        icon: Icons.error_outline,
        title: 'حدث خطأ',
        subtitle: _error,
        action: IslamicButton.primary(
          text: 'إعادة المحاولة',
          icon: Icons.refresh,
          onPressed: _loadData,
        ),
      );
    }

    return FadeTransition(
      opacity: _animationController,
      child: ListView(
        padding: const EdgeInsets.all(ThemeConstants.spaceMd),
        children: [
          if (!_hasPermission) ...[
            _buildPermissionSection(),
            Spaces.large,
          ],
          _buildGeneralSettings(),
          Spaces.large,
          if (_hasPermission) ...[
            _buildQuietTimeSettings(),
            Spaces.large,
            _buildBatterySettings(),
            Spaces.large,
            _buildCategoriesSettings(),
          ],
        ],
      ),
    );
  }

  Widget _buildPermissionSection() {
    return IslamicCard.elevated(
      color: ThemeConstants.warning.withValues(alpha: 0.1),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spaceSm),
                decoration: BoxDecoration(
                  color: ThemeConstants.warning.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                ),
                child: const Icon(
                  Icons.notifications_off,
                  color: ThemeConstants.warning,
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إذن الإشعارات مطلوب',
                      style: context.titleStyle.copyWith(
                        color: ThemeConstants.warning,
                        fontWeight: ThemeConstants.fontBold,
                      ),
                    ),
                    Spaces.xs,
                    Text(
                      'يجب السماح للتطبيق بإرسال الإشعارات لتفعيل التذكيرات',
                      style: context.bodyStyle.copyWith(
                        color: ThemeConstants.warning.darken(0.3),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Spaces.medium,
          SizedBox(
            width: double.infinity,
            child: IslamicButton.primary(
              text: 'طلب الإذن',
              icon: Icons.notifications_active,
              onPressed: _requestPermission,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.settings),
              Spaces.mediumH,
              Text(
                'الإعدادات العامة',
                style: context.titleStyle.copyWith(
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
            ],
          ),
          Spaces.medium,
          IslamicSwitch(
            title: 'تفعيل التذكيرات',
            subtitle: 'السماح بإرسال تذكيرات الأذكار',
            value: _notificationSettings.enabled,
            onChanged: _hasPermission ? (value) {
              setState(() {
                _notificationSettings = _notificationSettings.copyWith(enabled: value);
              });
            } : null,
          ),
          if (_hasPermission) ...[
            const Divider(),
            IslamicSwitch(
              title: 'الاهتزاز',
              subtitle: 'تفعيل الاهتزاز مع الإشعارات',
              value: _notificationSettings.vibrationEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationSettings = _notificationSettings.copyWith(vibrationEnabled: value);
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuietTimeSettings() {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.bedtime),
              Spaces.mediumH,
              Text(
                'وقت الهدوء',
                style: context.titleStyle.copyWith(
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
            ],
          ),
          Spaces.small,
          Text(
            'تعطيل الإشعارات خلال فترة محددة',
            style: context.captionStyle,
          ),
          Spaces.medium,
          Row(
            children: [
              Expanded(
                child: _buildTimeSelector(
                  label: 'من الساعة',
                  time: _notificationSettings.quietTimeStart,
                  onChanged: (time) {
                    setState(() {
                      _notificationSettings = _notificationSettings.copyWith(quietTimeStart: time);
                    });
                  },
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: _buildTimeSelector(
                  label: 'إلى الساعة',
                  time: _notificationSettings.quietTimeEnd,
                  onChanged: (time) {
                    setState(() {
                      _notificationSettings = _notificationSettings.copyWith(quietTimeEnd: time);
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector({
    required String label,
    required TimeOfDay? time,
    required ValueChanged<TimeOfDay?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.captionStyle.copyWith(
            fontWeight: ThemeConstants.fontMedium,
          ),
        ),
        Spaces.small,
        InkWell(
          onTap: () => _selectTime(time, onChanged),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(ThemeConstants.spaceMd),
            decoration: BoxDecoration(
              border: Border.all(color: context.borderColor),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time != null 
                      ? '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}'
                      : 'اختر الوقت',
                  style: context.bodyStyle,
                ),
                const Icon(Icons.access_time),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBatterySettings() {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.battery_alert),
              Spaces.mediumH,
              Text(
                'إعدادات البطارية',
                style: context.titleStyle.copyWith(
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
            ],
          ),
          Spaces.small,
          Text(
            'تعطيل الإشعارات عند انخفاض البطارية',
            style: context.captionStyle,
          ),
          Spaces.medium,
          Row(
            children: [
              Expanded(
                child: Text(
                  'الحد الأدنى للبطارية: ${_notificationSettings.minBatteryLevel ?? 15}%',
                  style: context.bodyStyle,
                ),
              ),
              Spaces.mediumH,
              SizedBox(
                width: 100,
                child: Slider(
                  value: (_notificationSettings.minBatteryLevel ?? 15).toDouble(),
                  min: 0,
                  max: 50,
                  divisions: 10,
                  onChanged: (value) {
                    setState(() {
                      _notificationSettings = _notificationSettings.copyWith(
                        minBatteryLevel: value.round(),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSettings() {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.category),
              Spaces.mediumH,
              Text(
                'فئات الأذكار',
                style: context.titleStyle.copyWith(
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
            ],
          ),
          Spaces.small,
          Text(
            'اختر الفئات التي تريد تلقي تذكيرات لها',
            style: context.captionStyle,
          ),
          Spaces.medium,
          ...List.generate(_categories.length, (index) {
            final category = _categories[index];
            final isEnabled = _categorySettings[category.id] ?? false;
            
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final delay = index * 0.1;
                final animationValue = Curves.easeOutQuart.transform(
                  (_animationController.value - delay).clamp(0.0, 1.0),
                );
                
                return Transform.translate(
                  offset: Offset(30 * (1 - animationValue), 0),
                  child: Opacity(
                    opacity: animationValue,
                    child: _buildCategoryItem(category, isEnabled),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(AthkarCategory category, bool isEnabled) {
    return Container(
      margin: const EdgeInsets.only(bottom: ThemeConstants.spaceSm),
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        color: isEnabled 
            ? category.color.withValues(alpha: 0.1)
            : context.cardColor,
        border: Border.all(
          color: isEnabled 
              ? category.color.withValues(alpha: 0.3)
              : context.borderColor,
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: category.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
            ),
            child: Icon(
              category.icon,
              color: category.color,
              size: ThemeConstants.iconMd,
            ),
          ),
          Spaces.mediumH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.title,
                  style: context.bodyStyle.copyWith(
                    fontWeight: ThemeConstants.fontMedium,
                  ),
                ),
                if (category.notifyTime != null) ...[
                  Spaces.xs,
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        size: ThemeConstants.iconSm,
                        color: context.secondaryTextColor,
                      ),
                      Spaces.smallH,
                      Text(
                        '${category.notifyTime!.hour.toString().padLeft(2, '0')}:'
                        '${category.notifyTime!.minute.toString().padLeft(2, '0')}',
                        style: context.captionStyle,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: isEnabled,
            onChanged: (value) {
              setState(() {
                _categorySettings[category.id] = value;
              });
            },
            activeColor: category.color,
          ),
        ],
      ),
    );
  }

  // Actions
  Future<void> _requestPermission() async {
    final granted = await _permissionService.requestNotificationPermission();
    
    if (granted) {
      setState(() {
        _hasPermission = true;
      });
      context.showSuccessMessage('تم منح إذن الإشعارات');
      await _loadData();
    } else {
      context.showErrorMessage('لم يتم منح إذن الإشعارات');
    }
  }

  Future<void> _selectTime(TimeOfDay? currentTime, ValueChanged<TimeOfDay?> onChanged) async {
    final time = await showTimePicker(
      context: context,
      initialTime: currentTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
    
    if (time != null) {
      onChanged(time);
    }
  }

  Future<void> _saveSettings() async {
    try {
      // حفظ الإعدادات العامة
      await NotificationManager.instance.updateSettings(_notificationSettings);

      // حفظ إعدادات الفئات
      await _athkarService.updateReminderSettings(_categorySettings);

      context.showSuccessMessage('تم حفظ الإعدادات بنجاح');
    } catch (e) {
      context.showErrorMessage('فشل في حفظ الإعدادات');
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}