// lib/features/tasbih/screens/tasbih_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/index.dart';
import '../../../app/di/service_locator.dart';
import '../services/tasbih_service.dart';
import '../widgets/tasbih_counter_widget.dart';
import '../widgets/tasbih_stats_card.dart';
import '../widgets/tasbih_settings_sheet.dart';
import '../widgets/tasbih_types_sheet.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with TickerProviderStateMixin {
  late final TasbihService _tasbihService;
  late AnimationController _counterController;
  late AnimationController _rippleController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;
  
  @override
  void initState() {
    super.initState();
    _tasbihService = getService<TasbihService>();
    
    // إعداد الحركات
    _counterController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _counterController,
      curve: Curves.elasticOut,
    ));
    
    _rippleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rippleController,
      curve: Curves.easeOut,
    ));
    
    // الاستماع لتغييرات الخدمة
    _tasbihService.addListener(_onTasbihServiceUpdate);
  }

  @override
  void dispose() {
    _tasbihService.removeListener(_onTasbihServiceUpdate);
    _counterController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _onTasbihServiceUpdate() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onCounterTap() async {
    // تأثيرات بصرية
    _counterController.forward().then((_) {
      _counterController.reverse();
    });
    _rippleController.forward().then((_) {
      _rippleController.reset();
    });
    
    // اهتزاز خفيف إذا كان مفعلاً
    if (_tasbihService.enableVibration) {
      HapticFeedback.lightImpact();
    }
    
    // زيادة العداد
    await _tasbihService.increment();
  }

  void _showTasbihTypes() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TasbihTypesSheet(
        currentType: _tasbihService.selectedTasbihType,
        onTypeSelected: (type) async {
          await _tasbihService.setSelectedTasbihType(type);
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TasbihSettingsSheet(
        service: _tasbihService,
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'إعادة تعيين العداد',
          style: context.titleStyle,
        ),
        content: Text(
          'هل تريد إعادة تعيين العداد الحالي؟',
          style: context.bodyStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: context.bodyStyle.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _tasbihService.reset();
              if (context.mounted) {
                Navigator.pop(context);
                context.showSuccessMessage('تم إعادة تعيين العداد');
              }
            },
            child: const Text('إعادة تعيين'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: IslamicAppBar(
        title: 'المسبحة الرقمية',
        actions: [
          IconButton(
            onPressed: _showTasbihTypes,
            icon: const Icon(Icons.format_quote),
            tooltip: 'أنواع التسبيح',
          ),
          IconButton(
            onPressed: _showSettings,
            icon: const Icon(Icons.settings),
            tooltip: 'الإعدادات',
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'reset':
                  _showResetDialog();
                  break;
                case 'reset_daily':
                  _showResetDailyDialog();
                  break;
                case 'reset_all':
                  _showResetAllDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'reset',
                child: Row(
                  children: [
                    Icon(Icons.refresh),
                    Spaces.smallH,
                    Text('إعادة تعيين الجلسة'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'reset_daily',
                child: Row(
                  children: [
                    Icon(Icons.today),
                    Spaces.smallH,
                    Text('إعادة تعيين اليوم'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'reset_all',
                child: Row(
                  children: [
                    Icon(Icons.delete_forever, color: context.errorColor),
                    Spaces.smallH,
                    Text(
                      'إعادة تعيين الكل',
                      style: TextStyle(color: context.errorColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(context.mediumPadding),
        child: Column(
          children: [
            // نوع التسبيح المختار
            _buildSelectedTasbihCard(),
            
            Spaces.large,
            
            // العداد الرئيسي
            TasbihCounterWidget(
              count: _tasbihService.count,
              setProgress: _tasbihService.setProgress,
              completedSets: _tasbihService.completedSets,
              remainingInSet: _tasbihService.remainingInSet,
              scaleAnimation: _scaleAnimation,
              rippleAnimation: _rippleAnimation,
              onTap: _onCounterTap,
            ),
            
            Spaces.large,
            
            // الإحصائيات اليومية
            TasbihStatsCard(
              dailyCount: _tasbihService.dailyCount,
              totalCount: _tasbihService.totalCount,
              dailyGoal: _tasbihService.dailyGoal,
              dailyGoalProgress: _tasbihService.dailyGoalProgress,
              isDailyGoalAchieved: _tasbihService.isDailyGoalAchieved,
              currentStreak: _tasbihService.getCurrentStreak(),
              longestStreak: _tasbihService.getLongestStreak(),
            ),
            
            Spaces.large,
            
            // الإحصائيات الأسبوعية
            _buildWeeklyStats(),
            
            // مساحة إضافية
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedTasbihCard() {
    return IslamicCard(
      gradient: LinearGradient(
        colors: [
          context.primaryColor.withValues(alpha: 0.1),
          context.primaryColor.withValues(alpha: 0.05),
        ],
      ),
      child: InkWell(
        onTap: _showTasbihTypes,
        borderRadius: BorderRadius.circular(context.largeRadius),
        child: Padding(
          padding: EdgeInsets.all(context.mediumPadding),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.primaryColor,
                      context.primaryColor.darken(0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.format_quote,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              
              Spaces.mediumH,
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'التسبيح المختار',
                      style: context.captionStyle.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                    Spaces.xs,
                    IslamicText.tasbih(
                      text: _tasbihService.selectedTasbihType,
                      textAlign: TextAlign.start,
                      fontSize: 18,
                    ),
                  ],
                ),
              ),
              
              Icon(
                Icons.keyboard_arrow_down,
                color: context.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyStats() {
    final weeklyStats = _tasbihService.getWeeklyStatistics();
    final maxCount = weeklyStats.values.isNotEmpty 
        ? weeklyStats.values.reduce((a, b) => a > b ? a : b)
        : 1;
    
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bar_chart,
                color: context.infoColor,
                size: 20,
              ),
              Spaces.smallH,
              Text(
                'إحصائيات الأسبوع',
                style: context.titleStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                'المتوسط: ${_tasbihService.getDailyAverage().toStringAsFixed(0)}',
                style: context.captionStyle.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          // الرسم البياني البسيط
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: weeklyStats.entries.map((entry) {
                final progress = maxCount > 0 ? entry.value / maxCount : 0.0;
                final dayName = _getDayName(entry.key);
                final isToday = _isToday(entry.key);
                
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // القيمة
                        Text(
                          entry.value.toString(),
                          style: context.captionStyle.copyWith(
                            fontSize: 10,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            color: isToday ? context.primaryColor : context.secondaryTextColor,
                          ),
                        ),
                        Spaces.xs,
                        
                        // الشريط
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          height: 60 * progress,
                          decoration: BoxDecoration(
                            gradient: isToday 
                                ? LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      context.primaryColor,
                                      context.primaryColor.lighten(0.2),
                                    ],
                                  )
                                : LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      context.borderColor.withValues(alpha: 0.5),
                                      context.borderColor.withValues(alpha: 0.3),
                                    ],
                                  ),
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                        ),
                        
                        Spaces.xs,
                        
                        // اسم اليوم
                        Text(
                          dayName,
                          style: context.captionStyle.copyWith(
                            fontSize: 10,
                            fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                            color: isToday ? context.primaryColor : context.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDailyDialog() {
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
            child: Text(
              'إلغاء',
              style: context.bodyStyle.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _tasbihService.resetDaily();
              if (context.mounted) {
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

  void _showResetAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'إعادة تعيين جميع البيانات',
          style: context.titleStyle.copyWith(
            color: context.errorColor,
          ),
        ),
        content: Text(
          'هذا الإجراء سيمحو جميع البيانات والإحصائيات. هل أنت متأكد؟',
          style: context.bodyStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: context.bodyStyle.copyWith(
                color: context.secondaryTextColor,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _tasbihService.resetAll();
              if (context.mounted) {
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

  String _getDayName(String dateKey) {
    final date = DateTime.parse(dateKey);
    final dayNames = ['الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت'];
    return dayNames[date.weekday % 7];
  }

  bool _isToday(String dateKey) {
    final date = DateTime.parse(dateKey);
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }
}