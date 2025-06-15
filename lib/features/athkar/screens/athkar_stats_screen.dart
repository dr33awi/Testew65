// lib/features/athkar/screens/athkar_stats_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../services/athkar_service.dart';
import '../models/athkar_stats.dart';
import '../models/athkar_model.dart';

class AthkarStatsScreen extends StatefulWidget {
  const AthkarStatsScreen({super.key});

  @override
  State<AthkarStatsScreen> createState() => _AthkarStatsScreenState();
}

class _AthkarStatsScreenState extends State<AthkarStatsScreen>
    with SingleTickerProviderStateMixin {
  late final AthkarService _service;
  late final AnimationController _animationController;
  
  AthkarStats? _stats;
  List<AthkarCategory>? _categories;
  int _streak = 0;
  int _todayCompleted = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _animationController = AnimationController(
      vsync: this,
      duration: ThemeConstants.durationNormal,
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
      final stats = await _service.getStats();
      final categories = await _service.loadCategories();
      final streak = await _service.getStreak();
      final todayCompleted = await _service.getCompletedCategoriesToday();
      
      if (mounted) {
        setState(() {
          _stats = stats;
          _categories = categories;
          _streak = streak;
          _todayCompleted = todayCompleted;
          _loading = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        context.showErrorSnackBar('حدث خطأ في تحميل الإحصائيات');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: CustomAppBar.simple(title: 'الإحصائيات'),
        body: Center(child: AppLoading.circular()),
      );
    }

    if (_stats == null || _categories == null) {
      return Scaffold(
        appBar: CustomAppBar.simple(title: 'الإحصائيات'),
        body: AppEmptyState.error(
          message: 'تعذر تحميل الإحصائيات',
          onRetry: _loadData,
        ),
      );
    }

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar.simple(
        title: 'إحصائيات الأذكار',
        actions: [
          AppBarAction(
            icon: Icons.refresh,
            onPressed: _loadData,
            tooltip: 'تحديث',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: CustomScrollView(
          slivers: [
            // الإحصائيات العامة
            SliverToBoxAdapter(
              child: _buildGeneralStats(),
            ),
            
            // إحصائيات الفئات
            SliverToBoxAdapter(
              child: _buildCategoryStats(),
            ),
            
            // الإحصائيات اليومية
            SliverToBoxAdapter(
              child: _buildDailyStats(),
            ),
            
            // مساحة إضافية
            const SliverPadding(
              padding: EdgeInsets.only(bottom: ThemeConstants.space8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralStats() {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        children: [
          // البطاقة الرئيسية
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _animationController,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.2),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _animationController,
                    curve: ThemeConstants.curveDefault,
                  )),
                  child: _MainStatsCard(
                    totalCompleted: _stats!.totalCompleted,
                    streak: _streak,
                    todayCompleted: _todayCompleted,
                    dailyAverage: _stats!.getDailyAverage(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryStats() {
    final mostUsedId = _stats!.getMostUsedCategory();
    final mostUsedCategory = mostUsedId != null
        ? _categories!.firstWhere((c) => c.id == mostUsedId)
        : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إحصائيات الفئات',
            style: context.titleLarge?.copyWith(
              fontWeight: ThemeConstants.bold,
            ),
          ),
          
          ThemeConstants.space3.h,
          
          if (mostUsedCategory != null)
            _MostUsedCategoryCard(
              category: mostUsedCategory,
              count: _stats!.getCompletedForCategory(mostUsedCategory.id),
            ),
          
          ThemeConstants.space3.h,
          
          // قائمة جميع الفئات
          ..._categories!.map((category) {
            final count = _stats!.getCompletedForCategory(category.id);
            return _CategoryStatItem(
              category: category,
              count: count,
              totalCount: _stats!.totalCompleted,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildDailyStats() {
    // الحصول على آخر 7 أيام
    final last7Days = <String, int>{};
    final today = DateTime.now();
    
    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final dateKey = date.toIso8601String().split('T')[0];
      last7Days[dateKey] = _stats!.getCompletedForDate(date);
    }

    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'النشاط الأسبوعي',
            style: context.titleLarge?.copyWith(
              fontWeight: ThemeConstants.bold,
            ),
          ),
          
          ThemeConstants.space3.h,
          
          _WeeklyActivityChart(dailyData: last7Days),
        ],
      ),
    );
  }
}

// بطاقة الإحصائيات الرئيسية
class _MainStatsCard extends StatelessWidget {
  final int totalCompleted;
  final int streak;
  final int todayCompleted;
  final double dailyAverage;

  const _MainStatsCard({
    required this.totalCompleted,
    required this.streak,
    required this.todayCompleted,
    required this.dailyAverage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space5),
      decoration: BoxDecoration(
        gradient: ThemeConstants.primaryGradient,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // الإجمالي
          Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 48,
          ),
          
          ThemeConstants.space2.h,
          
          Text(
            '$totalCompleted',
            style: context.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
            ),
          ),
          
          Text(
            'إجمالي الأذكار المكتملة',
            style: context.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          
          ThemeConstants.space4.h,
          
          // الإحصائيات الفرعية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SubStatItem(
                icon: Icons.local_fire_department,
                value: '$streak',
                label: 'يوم متتالي',
                color: Colors.orange,
              ),
              
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              
              _SubStatItem(
                icon: Icons.today,
                value: '$todayCompleted',
                label: 'أكملت اليوم',
                color: Colors.green,
              ),
              
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              
              _SubStatItem(
                icon: Icons.trending_up,
                value: dailyAverage.toStringAsFixed(1),
                label: 'المعدل اليومي',
                color: Colors.blue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SubStatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _SubStatItem({
    required this.icon,
    required this.value,
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
          size: ThemeConstants.iconMd,
        ),
        ThemeConstants.space1.h,
        Text(
          value,
          style: context.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: ThemeConstants.bold,
          ),
        ),
        Text(
          label,
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}

// بطاقة أكثر فئة استخداماً
class _MostUsedCategoryCard extends StatelessWidget {
  final AthkarCategory category;
  final int count;

  const _MostUsedCategoryCard({
    required this.category,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: ThemeConstants.accent.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: ThemeConstants.accentLight.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              color: ThemeConstants.accent,
              size: ThemeConstants.iconLg,
            ),
          ),
          
          ThemeConstants.space3.w,
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الأكثر استخداماً',
                  style: context.labelMedium?.copyWith(
                    color: ThemeConstants.accent,
                    fontWeight: ThemeConstants.semiBold,
                  ),
                ),
                Text(
                  category.title,
                  style: context.titleMedium?.copyWith(
                    fontWeight: ThemeConstants.bold,
                  ),
                ),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space3,
              vertical: ThemeConstants.space2,
            ),
            decoration: BoxDecoration(
              color: ThemeConstants.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            ),
            child: Text(
              '$count مرة',
              style: context.labelLarge?.copyWith(
                color: ThemeConstants.accent,
                fontWeight: ThemeConstants.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// عنصر إحصائية الفئة
class _CategoryStatItem extends StatelessWidget {
  final AthkarCategory category;
  final int count;
  final int totalCount;

  const _CategoryStatItem({
    required this.category,
    required this.count,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = totalCount > 0 ? (count / totalCount * 100) : 0.0;
    
    return Container(
      margin: const EdgeInsets.only(bottom: ThemeConstants.space2),
      padding: const EdgeInsets.all(ThemeConstants.space3),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      child: Row(
        children: [
          Icon(
            category.icon,
            color: category.color,
            size: ThemeConstants.iconMd,
          ),
          
          ThemeConstants.space3.w,
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category.title,
                      style: context.bodyLarge?.copyWith(
                        fontWeight: ThemeConstants.semiBold,
                      ),
                    ),
                    Text(
                      '$count مرة',
                      style: context.labelLarge?.copyWith(
                        color: context.primaryColor,
                        fontWeight: ThemeConstants.bold,
                      ),
                    ),
                  ],
                ),
                
                ThemeConstants.space2.h,
                
                // شريط التقدم
                ClipRRect(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: context.dividerColor.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(category.color),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// رسم بياني للنشاط الأسبوعي
class _WeeklyActivityChart extends StatelessWidget {
  final Map<String, int> dailyData;

  const _WeeklyActivityChart({
    required this.dailyData,
  });

  @override
  Widget build(BuildContext context) {
    final maxValue = dailyData.values.isEmpty 
        ? 1 
        : dailyData.values.reduce((a, b) => a > b ? a : b).toDouble();
    
    return Container(
      height: 200,
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      child: Column(
        children: [
          // الرسم البياني
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: dailyData.entries.map((entry) {
                final date = DateTime.parse(entry.key);
                final dayName = _getDayName(date.weekday);
                final value = entry.value;
                final height = maxValue > 0 ? (value / maxValue) : 0.0;
                
                return Expanded(
                  child: _DayBar(
                    day: dayName,
                    value: value,
                    height: height,
                    isToday: _isToday(date),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'الإثنين';
      case 2: return 'الثلاثاء';
      case 3: return 'الأربعاء';
      case 4: return 'الخميس';
      case 5: return 'الجمعة';
      case 6: return 'السبت';
      case 7: return 'الأحد';
      default: return '';
    }
  }
  
  bool _isToday(DateTime date) {
    final today = DateTime.now();
    return date.year == today.year &&
           date.month == today.month &&
           date.day == today.day;
  }
}

class _DayBar extends StatelessWidget {
  final String day;
  final int value;
  final double height;
  final bool isToday;

  const _DayBar({
    required this.day,
    required this.value,
    required this.height,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // القيمة
        if (value > 0)
          Text(
            '$value',
            style: context.labelSmall?.copyWith(
              color: isToday ? context.primaryColor : context.textSecondaryColor,
              fontWeight: isToday ? ThemeConstants.bold : ThemeConstants.medium,
            ),
          ),
        
        ThemeConstants.space1.h,
        
        // العمود
        Expanded(
          child: FractionallySizedBox(
            heightFactor: height,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isToday
                    ? context.primaryColor
                    : context.primaryColor.withValues(alpha: 0.3),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(ThemeConstants.radiusSm),
                ),
              ),
            ),
          ),
        ),
        
        ThemeConstants.space2.h,
        
        // اليوم
        Text(
          day.substring(0, 2), // أول حرفين فقط
          style: context.labelSmall?.copyWith(
            color: isToday ? context.primaryColor : context.textSecondaryColor,
            fontWeight: isToday ? ThemeConstants.bold : ThemeConstants.medium,
          ),
        ),
      ],
    );
  }
}