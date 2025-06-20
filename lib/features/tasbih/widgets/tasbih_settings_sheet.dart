// lib/features/tasbih/widgets/tasbih_settings_sheet.dart

import 'package:flutter/material.dart';
import '../../../app/themes/index.dart';
import '../services/tasbih_service.dart';

class TasbihSettingsSheet extends StatefulWidget {
  final TasbihService service;

  const TasbihSettingsSheet({
    super.key,
    required this.service,
  });

  @override
  State<TasbihSettingsSheet> createState() => _TasbihSettingsSheetState();
}

class _TasbihSettingsSheetState extends State<TasbihSettingsSheet> {
  late TextEditingController _goalController;
  late int _dailyGoal;
  late bool _enableNotifications;
  late bool _enableVibration;
  late bool _enableSound;

  @override
  void initState() {
    super.initState();
    _dailyGoal = widget.service.dailyGoal;
    _enableNotifications = widget.service.enableNotifications;
    _enableVibration = widget.service.enableVibration;
    _enableSound = widget.service.enableSound;
    
    _goalController = TextEditingController(text: _dailyGoal.toString());
  }

  @override
  void dispose() {
    _goalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // المقبض
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: context.borderColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // العنوان
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.mediumPadding),
            child: Row(
              children: [
                Icon(
                  Icons.settings,
                  color: context.primaryColor,
                ),
                Spaces.smallH,
                Text(
                  'إعدادات المسبحة',
                  style: context.titleStyle.copyWith(
                    color: context.primaryColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          // المحتوى
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.mediumPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // الهدف اليومي
                  _buildDailyGoalSection(),
                  
                  Spaces.large,
                  
                  // إعدادات التفاعل
                  _buildInteractionSettings(),
                  
                  Spaces.large,
                  
                  // أزرار الإجراءات
                  _buildActionButtons(),
                  
                  // مساحة إضافية للشاشات الصغيرة
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyGoalSection() {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.flag,
                color: context.primaryColor,
                size: 20,
              ),
              Spaces.smallH,
              Text(
                'الهدف اليومي',
                style: context.titleStyle.copyWith(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          Row(
            children: [
              Expanded(
                child: IslamicInput(
                  controller: _goalController,
                  label: 'عدد التسبيحات',
                  hint: 'أدخل الهدف اليومي',
                  keyboardType: TextInputType.number,
                  prefixIcon: Icons.track_changes,
                  onChanged: (value) {
                    final goal = int.tryParse(value);
                    if (goal != null && goal > 0 && goal <= 10000) {
                      setState(() {
                        _dailyGoal = goal;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          // الخيارات السريعة
          Wrap(
            spacing: 8,
            children: [33, 100, 300, 500, 1000].map((goal) {
              final isSelected = _dailyGoal == goal;
              
              return FilterChip(
                label: Text(goal.toString()),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    _dailyGoal = goal;
                    _goalController.text = goal.toString();
                  });
                },
                selectedColor: context.primaryColor.withValues(alpha: 0.2),
                checkmarkColor: context.primaryColor,
              );
            }).toList(),
          ),
          
          Spaces.small,
          
          Text(
            'الهدف الحالي: ${widget.service.dailyCount} من $_dailyGoal',
            style: context.captionStyle.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionSettings() {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.touch_app,
                color: context.infoColor,
                size: 20,
              ),
              Spaces.smallH,
              Text(
                'إعدادات التفاعل',
                style: context.titleStyle.copyWith(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          // الإشعارات
          IslamicSwitch(
            title: 'تفعيل الإشعارات',
            subtitle: 'إشعارات لتذكيرك بالتسبيح',
            value: _enableNotifications,
            onChanged: (value) {
              setState(() {
                _enableNotifications = value;
              });
            },
          ),
          
          // الاهتزاز
          IslamicSwitch(
            title: 'تفعيل الاهتزاز',
            subtitle: 'اهتزاز خفيف عند العد',
            value: _enableVibration,
            onChanged: (value) {
              setState(() {
                _enableVibration = value;
              });
            },
          ),
          
          // الصوت
          IslamicSwitch(
            title: 'تفعيل الصوت',
            subtitle: 'صوت عند العد (غير مُوصى به)',
            value: _enableSound,
            onChanged: (value) {
              setState(() {
                _enableSound = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // حفظ الإعدادات
        SizedBox(
          width: double.infinity,
          child: IslamicButton.primary(
            text: 'حفظ الإعدادات',
            icon: Icons.save,
            onPressed: _saveSettings,
          ),
        ),
        
        Spaces.medium,
        
        // إعدادات الخطر
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.errorColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.errorColor.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning,
                    color: context.errorColor,
                    size: 20,
                  ),
                  Spaces.smallH,
                  Text(
                    'منطقة الخطر',
                    style: context.bodyStyle.copyWith(
                      color: context.errorColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              
              Spaces.medium,
              
              Text(
                'هذه الإجراءات ستحذف البيانات نهائياً',
                style: context.captionStyle.copyWith(
                  color: context.errorColor,
                ),
              ),
              
              Spaces.medium,
              
              Row(
                children: [
                  Expanded(
                    child: IslamicButton.outlined(
                      text: 'إعادة تعيين اليوم',
                      onPressed: _resetDaily,
                    ),
                  ),
                  Spaces.mediumH,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _resetAll,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.errorColor,
                      ),
                      child: const Text(
                        'حذف الكل',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _saveSettings() async {
    try {
      await Future.wait([
        widget.service.setDailyGoal(_dailyGoal),
        widget.service.setNotificationsEnabled(_enableNotifications),
        widget.service.setVibrationEnabled(_enableVibration),
        widget.service.setSoundEnabled(_enableSound),
      ]);
      
      if (context.mounted) {
        Navigator.pop(context);
        context.showSuccessMessage('تم حفظ الإعدادات بنجاح');
      }
    } catch (e) {
      if (context.mounted) {
        context.showErrorMessage('حدث خطأ أثناء حفظ الإعدادات');
      }
    }
  }

  void _resetDaily() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'إعادة تعيين العداد اليومي',
          style: context.titleStyle,
        ),
        content: Text(
          'هل تريد إعادة تعيين العداد اليومي؟',
          style: context.bodyStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              await widget.service.resetDaily();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                context.showSuccessMessage('تم إعادة تعيين العداد اليومي');
              }
            },
            child: const Text('إعادة تعيين'),
          ),
        ],
      ),
    );
  }

  void _resetAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'حذف جميع البيانات',
          style: context.titleStyle.copyWith(
            color: context.errorColor,
          ),
        ),
        content: Text(
          'هذا الإجراء سيمحو جميع البيانات والإحصائيات نهائياً. هل أنت متأكد؟',
          style: context.bodyStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              await widget.service.resetAll();
              if (context.mounted) {
                Navigator.pop(context);
                Navigator.pop(context);
                context.showWarningMessage('تم حذف جميع البيانات');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.errorColor,
            ),
            child: const Text(
              'حذف الكل',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}