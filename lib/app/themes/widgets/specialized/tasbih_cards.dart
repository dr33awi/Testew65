// lib/app/themes/widgets/specialized/tasbih_cards.dart
// كروت المسبحة والعداد - مفصولة ومتخصصة
// ✅ استيراد النظام الموحد الإسلامي - الوحيد المسموح
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

// ==================== كروت المسبحة المتخصصة ====================

/// بطاقة المسبحة الرئيسية التفاعلية
class TasbihCard extends StatefulWidget {
  final String dhikrText;
  final int currentCount;
  final int targetCount;
  final Color primaryColor;
  final VoidCallback onIncrement;
  final VoidCallback? onReset;
  final VoidCallback? onComplete;
  final List<TasbihAction>? actions;
  final bool useHapticFeedback;
  final bool useAnimation;
  final bool showProgress;
  final bool isCompleted;

  const TasbihCard({
    super.key,
    required this.dhikrText,
    required this.currentCount,
    required this.targetCount,
    required this.primaryColor,
    required this.onIncrement,
    this.onReset,
    this.onComplete,
    this.actions,
    this.useHapticFeedback = true,
    this.useAnimation = true,
    this.showProgress = true,
    this.isCompleted = false,
  });

  @override
  State<TasbihCard> createState() => _TasbihCardState();
}

class _TasbihCardState extends State<TasbihCard> with TickerProviderStateMixin {
  late AnimationController _incrementController;
  late AnimationController _pulseController;
  late AnimationController _completionController;
  
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _completionAnimation;

  @override
  void initState() {
    super.initState();
    
    _incrementController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _completionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _incrementController,
      curve: Curves.elasticOut,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _completionAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _completionController,
      curve: Curves.bounceOut,
    ));

    // تشغيل النبضة إذا كان مكتملاً
    if (widget.isCompleted) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TasbihCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // التحقق من الإكمال
    if (widget.isCompleted && !oldWidget.isCompleted) {
      _completionController.forward();
      _pulseController.repeat(reverse: true);
      if (widget.onComplete != null) {
        widget.onComplete!();
      }
    } else if (!widget.isCompleted && oldWidget.isCompleted) {
      _completionController.reset();
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _incrementController.dispose();
    _pulseController.dispose();
    _completionController.dispose();
    super.dispose();
  }

  void _handleIncrement() {
    if (widget.isCompleted) return;
    
    if (widget.useHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    
    if (widget.useAnimation) {
      _incrementController.forward().then((_) {
        _incrementController.reverse();
      });
    }
    
    widget.onIncrement();
  }

  void _handleReset() {
    if (widget.onReset != null) {
      if (widget.useHapticFeedback) {
        HapticFeedback.mediumImpact();
      }
      _completionController.reset();
      _pulseController.stop();
      widget.onReset!();
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = widget.targetCount > 0 
        ? widget.currentCount / widget.targetCount 
        : 0.0;

    return Container(
      margin: AppTheme.space3.padding,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusLg.radius,
        child: Container(
          decoration: _buildCardDecoration(),
          padding: AppTheme.space5.padding,
          child: Column(
            children: [
              _buildHeader(),
              AppTheme.space6.h,
              _buildCounter(),
              AppTheme.space6.h,
              if (widget.showProgress) _buildProgress(progress),
              if (widget.actions != null && widget.actions!.isNotEmpty) ...[
                AppTheme.space4.h,
                _buildActions(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      gradient: widget.isCompleted ? LinearGradient(
        colors: [
          AppTheme.success,
          AppTheme.lighten(AppTheme.success, 0.1),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ) : LinearGradient(
        colors: [
          widget.primaryColor.withValues(alpha: 0.1),
          widget.primaryColor.withValues(alpha: 0.05),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: AppTheme.radiusLg.radius,
      border: Border.all(
        color: widget.isCompleted 
            ? AppTheme.success
            : widget.primaryColor,
        width: 2,
      ),
      boxShadow: AppTheme.shadowMd,
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // النص الديني
        Container(
          width: double.infinity,
          padding: AppTheme.space4.padding,
          decoration: BoxDecoration(
            color: widget.isCompleted 
                ? Colors.white.withValues(alpha: 0.9)
                : AppTheme.card,
            borderRadius: AppTheme.radiusMd.radius,
            border: Border.all(
              color: widget.isCompleted 
                  ? Colors.white
                  : widget.primaryColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            widget.dhikrText,
            style: AppTheme.dhikrStyle.copyWith(
              color: widget.isCompleted 
                  ? AppTheme.success
                  : AppTheme.textReligious,
              fontWeight: AppTheme.semiBold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        
        // مؤشر الإكمال
        if (widget.isCompleted) ...[
          AppTheme.space3.h,
          AnimatedBuilder(
            animation: _completionAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _completionAnimation.value,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.celebration,
                      color: Colors.white,
                      size: AppTheme.iconMd,
                    ),
                    AppTheme.space2.w,
                    Text(
                      'مبارك! تم إكمال التسبيح',
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ],
    );
  }

  Widget _buildCounter() {
    return GestureDetector(
      onTap: _handleIncrement,
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _scaleAnimation,
          _pulseAnimation,
        ]),
        builder: (context, child) {
          return Transform.scale(
            scale: widget.useAnimation 
                ? _scaleAnimation.value * (widget.isCompleted ? _pulseAnimation.value : 1.0)
                : 1.0,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                gradient: widget.isCompleted ? const LinearGradient(
                  colors: [Colors.white, Color(0xFFF0F0F0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ) : LinearGradient(
                  colors: [
                    widget.primaryColor,
                    AppTheme.darken(widget.primaryColor, 0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.isCompleted 
                        ? AppTheme.success.withValues(alpha: 0.3)
                        : widget.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 3,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.isCompleted) ...[
                      Icon(
                        Icons.check,
                        color: AppTheme.success,
                        size: 50,
                      ),
                    ] else ...[
                      Text(
                        '${widget.currentCount}',
                        style: AppTheme.displayLarge.copyWith(
                          color: Colors.white,
                          fontFamily: AppTheme.numbersFont,
                          fontSize: 48,
                          fontWeight: AppTheme.bold,
                        ),
                      ),
                      Text(
                        'من ${widget.targetCount}',
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontFamily: AppTheme.numbersFont,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgress(double progress) {
    return Column(
      children: [
        // شريط التقدم الدائري
        SizedBox(
          width: 100,
          height: 100,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // الخلفية
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.primaryColor.withValues(alpha: 0.1),
                ),
              ),
              
              // التقدم
              CircularProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                strokeWidth: 8,
                backgroundColor: widget.primaryColor.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.isCompleted ? AppTheme.success : widget.primaryColor,
                ),
              ),
              
              // النسبة المئوية
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTheme.titleMedium.copyWith(
                  color: widget.isCompleted ? AppTheme.success : widget.primaryColor,
                  fontWeight: AppTheme.bold,
                  fontFamily: AppTheme.numbersFont,
                ),
              ),
            ],
          ),
        ),
        
        AppTheme.space3.h,
        
        // زر إعادة التعيين
        if (widget.onReset != null && widget.currentCount > 0)
          TextButton.icon(
            onPressed: _handleReset,
            icon: const Icon(Icons.refresh, size: AppTheme.iconSm),
            label: const Text('إعادة تعيين'),
            style: TextButton.styleFrom(
              foregroundColor: widget.isCompleted 
                  ? Colors.white
                  : AppTheme.textTertiary,
            ),
          ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.actions!.map((action) => action).toList(),
    );
  }
}

/// بطاقة مسبحة مبسطة للعرض السريع
class SimpleTasbihCard extends StatelessWidget {
  final String dhikrText;
  final int count;
  final Color color;
  final VoidCallback onTap;
  final bool isActive;

  const SimpleTasbihCard({
    super.key,
    required this.dhikrText,
    required this.count,
    required this.color,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppTheme.space2.padding,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusMd.radius,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: AppTheme.radiusMd.radius,
          child: Container(
            decoration: BoxDecoration(
              color: isActive 
                  ? color.withValues(alpha: 0.2)
                  : color.withValues(alpha: 0.1),
              borderRadius: AppTheme.radiusMd.radius,
              border: Border.all(
                color: isActive ? color : color.withValues(alpha: 0.3),
                width: isActive ? 2 : 1,
              ),
            ),
            padding: AppTheme.space3.padding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // النص
                Text(
                  dhikrText,
                  style: AppTheme.bodyMedium.copyWith(
                    color: isActive ? color : AppTheme.textPrimary,
                    fontWeight: isActive ? AppTheme.semiBold : AppTheme.regular,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                AppTheme.space2.h,
                
                // العداد
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      count.toString(),
                      style: AppTheme.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.bold,
                        fontFamily: AppTheme.numbersFont,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// بطاقة إحصائيات التسبيح
class TasbihStatsCard extends StatelessWidget {
  final Map<String, int> dhikrCounts;
  final int totalCount;
  final int sessionsToday;
  final Duration totalTime;
  final VoidCallback? onViewDetails;

  const TasbihStatsCard({
    super.key,
    required this.dhikrCounts,
    required this.totalCount,
    required this.sessionsToday,
    required this.totalTime,
    this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppTheme.space3.padding,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusLg.radius,
        child: InkWell(
          onTap: onViewDetails,
          borderRadius: AppTheme.radiusLg.radius,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: AppTheme.radiusLg.radius,
              boxShadow: AppTheme.shadowMd,
            ),
            padding: AppTheme.space5.padding,
            child: Column(
              children: [
                // العنوان
                Row(
                  children: [
                    Icon(
                      Icons.fingerprint,
                      color: Colors.white,
                      size: AppTheme.iconMd,
                    ),
                    AppTheme.space2.w,
                    Text(
                      'إحصائيات التسبيح',
                      style: AppTheme.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: AppTheme.semiBold,
                      ),
                    ),
                  ],
                ),
                
                AppTheme.space4.h,
                
                // الإحصائيات الرئيسية
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('اليوم', totalCount.toString()),
                    _buildStatItem('جلسات', sessionsToday.toString()),
                    _buildStatItem('الوقت', AppTheme.formatDuration(totalTime)),
                  ],
                ),
                
                AppTheme.space4.h,
                
                // أفضل الأذكار
                if (dhikrCounts.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: AppTheme.space3.padding,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: AppTheme.radiusMd.radius,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'الأكثر تسبيحاً:',
                          style: AppTheme.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontWeight: AppTheme.medium,
                          ),
                        ),
                        AppTheme.space2.h,
                        ..._getTopDhikr().map((entry) => 
                          Padding(
                            padding: const EdgeInsets.only(bottom: AppTheme.space1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: AppTheme.bodySmall.copyWith(
                                      color: Colors.white,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  entry.value.toString(),
                                  style: AppTheme.bodySmall.copyWith(
                                    color: Colors.white,
                                    fontWeight: AppTheme.bold,
                                    fontFamily: AppTheme.numbersFont,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.headlineMedium.copyWith(
            color: Colors.white,
            fontWeight: AppTheme.bold,
            fontFamily: AppTheme.numbersFont,
          ),
        ),
        AppTheme.space1.h,
        Text(
          label,
          style: AppTheme.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
            fontWeight: AppTheme.medium,
          ),
        ),
      ],
    );
  }

  List<MapEntry<String, int>> _getTopDhikr() {
    final entries = dhikrCounts.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(3).toList();
  }
}

/// بطاقة مجموعة التسبيح
class TasbihGroupCard extends StatelessWidget {
  final String groupName;
  final List<TasbihItem> dhikrList;
  final int currentIndex;
  final Function(int) onDhikrSelect;
  final VoidCallback? onStart;
  final bool isActive;

  const TasbihGroupCard({
    super.key,
    required this.groupName,
    required this.dhikrList,
    required this.currentIndex,
    required this.onDhikrSelect,
    this.onStart,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final completedCount = dhikrList.where((item) => item.isCompleted).length;
    final totalCount = dhikrList.length;
    final progress = totalCount > 0 ? completedCount / totalCount : 0.0;

    return Container(
      margin: AppTheme.space3.padding,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusLg.radius,
        child: InkWell(
          onTap: onStart,
          borderRadius: AppTheme.radiusLg.radius,
          child: Container(
            decoration: BoxDecoration(
              color: isActive 
                  ? AppTheme.primary.withValues(alpha: 0.1)
                  : AppTheme.card,
              borderRadius: AppTheme.radiusLg.radius,
              border: Border.all(
                color: isActive 
                    ? AppTheme.primary
                    : AppTheme.divider.withValues(alpha: 0.3),
                width: isActive ? 2 : 1,
              ),
              boxShadow: AppTheme.shadowSm,
            ),
            padding: AppTheme.space4.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العنوان والتقدم
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            groupName,
                            style: AppTheme.titleMedium.copyWith(
                              fontWeight: AppTheme.semiBold,
                              color: isActive ? AppTheme.primary : null,
                            ),
                          ),
                          AppTheme.space1.h,
                          Text(
                            '$completedCount من $totalCount مكتمل',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // مؤشر دائري للتقدم
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 4,
                            backgroundColor: AppTheme.primary.withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                          ),
                          Text(
                            '${(progress * 100).toInt()}%',
                            style: AppTheme.caption.copyWith(
                              fontWeight: AppTheme.bold,
                              fontFamily: AppTheme.numbersFont,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                AppTheme.space4.h,
                
                // قائمة الأذكار المختصرة
                ...dhikrList.take(3).asMap().entries.map((entry) {
                  final index = entry.key;
                  final dhikr = entry.value;
                  final isCurrent = index == currentIndex;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: AppTheme.space2),
                    child: Material(
                      color: Colors.transparent,
                      borderRadius: AppTheme.radiusSm.radius,
                      child: InkWell(
                        onTap: () => onDhikrSelect(index),
                        borderRadius: AppTheme.radiusSm.radius,
                        child: Container(
                          padding: AppTheme.space2.padding,
                          decoration: BoxDecoration(
                            color: isCurrent 
                                ? AppTheme.primary.withValues(alpha: 0.1)
                                : null,
                            borderRadius: AppTheme.radiusSm.radius,
                            border: isCurrent ? Border.all(
                              color: AppTheme.primary.withValues(alpha: 0.3),
                              width: 1,
                            ) : null,
                          ),
                          child: Row(
                            children: [
                              // مؤشر الحالة
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: dhikr.isCompleted 
                                      ? AppTheme.success 
                                      : isCurrent 
                                          ? AppTheme.primary
                                          : AppTheme.textTertiary.withValues(alpha: 0.3),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: dhikr.isCompleted 
                                      ? const Icon(
                                          Icons.check,
                                          size: 12,
                                          color: Colors.white,
                                        )
                                      : Text(
                                          '${index + 1}',
                                          style: AppTheme.caption.copyWith(
                                            color: Colors.white,
                                            fontWeight: AppTheme.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                ),
                              ),
                              
                              AppTheme.space2.w,
                              
                              // النص
                              Expanded(
                                child: Text(
                                  dhikr.text,
                                  style: AppTheme.bodySmall.copyWith(
                                    color: isCurrent ? AppTheme.primary : null,
                                    fontWeight: isCurrent ? AppTheme.medium : AppTheme.regular,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              
                              // العداد
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: dhikr.isCompleted 
                                      ? AppTheme.success
                                      : AppTheme.textTertiary.withValues(alpha: 0.2),
                                  borderRadius: AppTheme.radiusFull.radius,
                                ),
                                child: Text(
                                  dhikr.isCompleted 
                                      ? '✓'
                                      : '${dhikr.currentCount}/${dhikr.targetCount}',
                                  style: AppTheme.caption.copyWith(
                                    color: dhikr.isCompleted 
                                        ? Colors.white
                                        : AppTheme.textSecondary,
                                    fontWeight: AppTheme.medium,
                                    fontFamily: AppTheme.numbersFont,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                
                // عرض المزيد
                if (dhikrList.length > 3) ...[
                  AppTheme.space2.h,
                  Center(
                    child: Text(
                      'و ${dhikrList.length - 3} أذكار أخرى...',
                      style: AppTheme.caption.copyWith(
                        color: AppTheme.textTertiary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ==================== مكونات مساعدة للمسبحة ====================

/// إجراء في بطاقة المسبحة
class TasbihAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final bool isPrimary;

  const TasbihAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        borderRadius: AppTheme.radiusMd.radius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space3,
            vertical: AppTheme.space2,
          ),
          decoration: isPrimary ? BoxDecoration(
            color: color ?? AppTheme.primary,
            borderRadius: AppTheme.radiusMd.radius,
          ) : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppTheme.iconMd,
                color: isPrimary 
                    ? Colors.white
                    : color ?? AppTheme.textSecondary,
              ),
              if (label.isNotEmpty) ...[
                AppTheme.space1.h,
                Text(
                  label,
                  style: AppTheme.caption.copyWith(
                    color: isPrimary 
                        ? Colors.white
                        : color ?? AppTheme.textSecondary,
                    fontWeight: AppTheme.medium,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// عنصر التسبيح
class TasbihItem {
  final String text;
  final int currentCount;
  final int targetCount;
  final bool isCompleted;
  final Color? color;

  const TasbihItem({
    required this.text,
    required this.currentCount,
    required this.targetCount,
    this.isCompleted = false,
    this.color,
  });

  TasbihItem copyWith({
    String? text,
    int? currentCount,
    int? targetCount,
    bool? isCompleted,
    Color? color,
  }) {
    return TasbihItem(
      text: text ?? this.text,
      currentCount: currentCount ?? this.currentCount,
      targetCount: targetCount ?? this.targetCount,
      isCompleted: isCompleted ?? this.isCompleted,
      color: color ?? this.color,
    );
  }
}

/// عداد مسبحة تفاعلي بسيط
class TasbihCounter extends StatefulWidget {
  final int count;
  final int maxCount;
  final Color color;
  final VoidCallback onIncrement;
  final VoidCallback? onReset;
  final bool useAnimation;

  const TasbihCounter({
    super.key,
    required this.count,
    required this.maxCount,
    required this.color,
    required this.onIncrement,
    this.onReset,
    this.useAnimation = true,
  });

  @override
  State<TasbihCounter> createState() => _TasbihCounterState();
}

class _TasbihCounterState extends State<TasbihCounter> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.9,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.useAnimation) {
      _controller.forward().then((_) {
        _controller.reverse();
      });
    }
    HapticFeedback.lightImpact();
    widget.onIncrement();
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = widget.count >= widget.maxCount;
    
    return Column(
      children: [
        // العداد الرئيسي
        GestureDetector(
          onTap: isCompleted ? null : _handleTap,
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: widget.useAnimation ? _scaleAnimation.value : 1.0,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isCompleted ? AppTheme.success : widget.color,
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.shadowMd,
                  ),
                  child: Center(
                    child: isCompleted 
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 30,
                          )
                        : Text(
                            '${widget.count}',
                            style: AppTheme.headlineMedium.copyWith(
                              color: Colors.white,
                              fontWeight: AppTheme.bold,
                              fontFamily: AppTheme.numbersFont,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),
        ),
        
        AppTheme.space2.h,
        
        // معلومات إضافية
        if (!isCompleted) ...[
          Text(
            'من ${widget.maxCount}',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.textSecondary,
              fontFamily: AppTheme.numbersFont,
            ),
          ),
        ] else ...[
          Text(
            'مكتمل! 🎉',
            style: AppTheme.bodySmall.copyWith(
              color: AppTheme.success,
              fontWeight: AppTheme.bold,
            ),
          ),
        ],
        
        // زر إعادة التعيين
        if (widget.onReset != null && widget.count > 0) ...[
          AppTheme.space2.h,
          TextButton(
            onPressed: widget.onReset,
            child: Text(
              'إعادة',
              style: AppTheme.caption.copyWith(
                color: AppTheme.textTertiary,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ==================== Factory Methods للمسبحة ====================

/// مصنع بطاقات المسبحة
class TasbihCards {
  TasbihCards._();

  /// مسبحة أساسية
  static Widget basic({
    required String dhikrText,
    required int currentCount,
    required int targetCount,
    required Color primaryColor,
    required VoidCallback onIncrement,
    VoidCallback? onReset,
    VoidCallback? onComplete,
    bool useHapticFeedback = true,
  }) {
    return TasbihCard(
      dhikrText: dhikrText,
      currentCount: currentCount,
      targetCount: targetCount,
      primaryColor: primaryColor,
      onIncrement: onIncrement,
      onReset: onReset,
      onComplete: onComplete,
      useHapticFeedback: useHapticFeedback,
      isCompleted: currentCount >= targetCount,
    );
  }

  /// مسبحة متقدمة مع إجراءات
  static Widget advanced({
    required String dhikrText,
    required int currentCount,
    required int targetCount,
    required Color primaryColor,
    required VoidCallback onIncrement,
    VoidCallback? onReset,
    VoidCallback? onComplete,
    List<TasbihAction>? actions,
    bool useAnimation = true,
    bool showProgress = true,
  }) {
    return TasbihCard(
      dhikrText: dhikrText,
      currentCount: currentCount,
      targetCount: targetCount,
      primaryColor: primaryColor,
      onIncrement: onIncrement,
      onReset: onReset,
      onComplete: onComplete,
      actions: actions,
      useAnimation: useAnimation,
      showProgress: showProgress,
      isCompleted: currentCount >= targetCount,
    );
  }

  /// مسبحة مبسطة
  static Widget simple({
    required String dhikrText,
    required int count,
    required Color color,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return SimpleTasbihCard(
      dhikrText: dhikrText,
      count: count,
      color: color,
      onTap: onTap,
      isActive: isActive,
    );
  }

  /// إحصائيات التسبيح
  static Widget stats({
    required Map<String, int> dhikrCounts,
    required int totalCount,
    required int sessionsToday,
    required Duration totalTime,
    VoidCallback? onViewDetails,
  }) {
    return TasbihStatsCard(
      dhikrCounts: dhikrCounts,
      totalCount: totalCount,
      sessionsToday: sessionsToday,
      totalTime: totalTime,
      onViewDetails: onViewDetails,
    );
  }

  /// مجموعة التسبيح
  static Widget group({
    required String groupName,
    required List<TasbihItem> dhikrList,
    required int currentIndex,
    required Function(int) onDhikrSelect,
    VoidCallback? onStart,
    bool isActive = false,
  }) {
    return TasbihGroupCard(
      groupName: groupName,
      dhikrList: dhikrList,
      currentIndex: currentIndex,
      onDhikrSelect: onDhikrSelect,
      onStart: onStart,
      isActive: isActive,
    );
  }

  /// عداد بسيط
  static Widget counter({
    required int count,
    required int maxCount,
    required Color color,
    required VoidCallback onIncrement,
    VoidCallback? onReset,
    bool useAnimation = true,
  }) {
    return TasbihCounter(
      count: count,
      maxCount: maxCount,
      color: color,
      onIncrement: onIncrement,
      onReset: onReset,
      useAnimation: useAnimation,
    );
  }

  /// التسبيحات الشائعة
  static List<TasbihItem> getCommonTasbih() {
    return [
      const TasbihItem(
        text: 'سبحان الله',
        currentCount: 0,
        targetCount: 33,
        color: AppTheme.primary,
      ),
      const TasbihItem(
        text: 'الحمد لله',
        currentCount: 0,
        targetCount: 33,
        color: AppTheme.secondary,
      ),
      const TasbihItem(
        text: 'الله أكبر',
        currentCount: 0,
        targetCount: 34,
        color: AppTheme.tertiary,
      ),
      const TasbihItem(
        text: 'لا إله إلا الله',
        currentCount: 0,
        targetCount: 100,
        color: AppTheme.success,
      ),
      const TasbihItem(
        text: 'استغفر الله',
        currentCount: 0,
        targetCount: 100,
        color: AppTheme.warning,
      ),
      const TasbihItem(
        text: 'سبحان الله وبحمده',
        currentCount: 0,
        targetCount: 100,
        color: AppTheme.info,
      ),
    ];
  }

  /// مجموعات التسبيح المختلفة
  static Map<String, List<TasbihItem>> getTasbihGroups() {
    return {
      'التسبيح العادي': [
        const TasbihItem(text: 'سبحان الله', currentCount: 0, targetCount: 33),
        const TasbihItem(text: 'الحمد لله', currentCount: 0, targetCount: 33),
        const TasbihItem(text: 'الله أكبر', currentCount: 0, targetCount: 34),
      ],
      'الاستغفار': [
        const TasbihItem(text: 'استغفر الله', currentCount: 0, targetCount: 100),
        const TasbihItem(text: 'استغفر الله العظيم', currentCount: 0, targetCount: 70),
        const TasbihItem(text: 'رب اغفر لي', currentCount: 0, targetCount: 50),
      ],
      'الصلاة على النبي': [
        const TasbihItem(text: 'اللهم صل على محمد', currentCount: 0, targetCount: 100),
        const TasbihItem(text: 'صلى الله عليه وسلم', currentCount: 0, targetCount: 50),
      ],
      'أذكار المساء': [
        const TasbihItem(text: 'لا إله إلا الله', currentCount: 0, targetCount: 100),
        const TasbihItem(text: 'سبحان الله وبحمده', currentCount: 0, targetCount: 100),
        const TasbihItem(text: 'سبحان الله العظيم', currentCount: 0, targetCount: 100),
      ],
    };
  }
}

// ==================== Extensions للمسبحة ====================

extension TasbihCardExtensions on BuildContext {
  /// إظهار مسبحة في الشاشة الكاملة
  void showFullScreenTasbih({
    required String dhikrText,
    required int currentCount,
    required int targetCount,
    required Color primaryColor,
    required VoidCallback onIncrement,
    VoidCallback? onComplete,
  }) {
    Navigator.of(this).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: AppTheme.background,
          appBar: AppBar(
            title: const Text('المسبحة'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: TasbihCards.advanced(
              dhikrText: dhikrText,
              currentCount: currentCount,
              targetCount: targetCount,
              primaryColor: primaryColor,
              onIncrement: onIncrement,
              onComplete: onComplete,
              useAnimation: true,
              showProgress: true,
              actions: [
                TasbihAction(
                  icon: Icons.share,
                  label: 'مشاركة',
                  onPressed: () {
                    // منطق المشاركة
                  },
                ),
                TasbihAction(
                  icon: Icons.volume_up,
                  label: 'صوت',
                  onPressed: () {
                    // تشغيل الصوت
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// إظهار اختيار مجموعة التسبيح
  void showTasbihGroupPicker({
    required Function(String, List<TasbihItem>) onGroupSelected,
  }) {
    final groups = TasbihCards.getTasbihGroups();
    
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: AppTheme.space4.padding,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: AppTheme.radiusXl.radius,
        ),
        child: Padding(
          padding: AppTheme.space5.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // مقبض السحب
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: AppTheme.radiusFull.radius,
                ),
              ),
              
              AppTheme.space4.h,
              
              // العنوان
              Text(
                'اختر مجموعة التسبيح',
                style: AppTheme.titleLarge.copyWith(
                  fontWeight: AppTheme.bold,
                ),
              ),
              
              AppTheme.space4.h,
              
              // قائمة المجموعات
              ...groups.entries.map((entry) => 
                Container(
                  margin: const EdgeInsets.only(bottom: AppTheme.space3),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: AppTheme.radiusMd.radius,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        onGroupSelected(entry.key, entry.value);
                      },
                      borderRadius: AppTheme.radiusMd.radius,
                      child: Container(
                        padding: AppTheme.space4.padding,
                        decoration: BoxDecoration(
                          color: AppTheme.card,
                          borderRadius: AppTheme.radiusMd.radius,
                          border: Border.all(
                            color: AppTheme.divider.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.fingerprint,
                              color: AppTheme.primary,
                              size: AppTheme.iconMd,
                            ),
                            AppTheme.space3.w,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.key,
                                    style: AppTheme.titleMedium.copyWith(
                                      fontWeight: AppTheme.semiBold,
                                    ),
                                  ),
                                  AppTheme.space1.h,
                                  Text(
                                    '${entry.value.length} أذكار',
                                    style: AppTheme.bodySmall.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: AppTheme.textTertiary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// إظهار إحصائيات التسبيح
  void showTasbihStats({
    required Map<String, int> dhikrCounts,
    required int totalCount,
    required int sessionsToday,
    required Duration totalTime,
  }) {
    showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.analytics,
              color: AppTheme.primary,
            ),
            AppTheme.space2.w,
            const Text('إحصائيات التسبيح'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TasbihCards.stats(
              dhikrCounts: dhikrCounts,
              totalCount: totalCount,
              sessionsToday: sessionsToday,
              totalTime: totalTime,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}

// ==================== مساعدات متقدمة ====================

/// مدير حالة المسبحة
class TasbihStateManager {
  static Map<String, int> _counters = {};
  static Map<String, DateTime> _lastUsed = {};
  
  /// الحصول على العداد
  static int getCount(String dhikrId) {
    return _counters[dhikrId] ?? 0;
  }
  
  /// زيادة العداد
  static void increment(String dhikrId) {
    _counters[dhikrId] = (_counters[dhikrId] ?? 0) + 1;
    _lastUsed[dhikrId] = DateTime.now();
  }
  
  /// إعادة تعيين العداد
  static void reset(String dhikrId) {
    _counters[dhikrId] = 0;
    _lastUsed.remove(dhikrId);
  }
  
  /// إعادة تعيين جميع العدادات
  static void resetAll() {
    _counters.clear();
    _lastUsed.clear();
  }
  
  /// الحصول على الأذكار الأكثر استخداماً
  static List<MapEntry<String, int>> getMostUsed({int limit = 5}) {
    final entries = _counters.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(limit).toList();
  }
  
  /// الحصول على إجمالي التسبيحات اليوم
  static int getTodayTotal() {
    final today = DateTime.now();
    return _lastUsed.entries
        .where((entry) => 
            entry.value.day == today.day && 
            entry.value.month == today.month && 
            entry.value.year == today.year)
        .map((entry) => _counters[entry.key] ?? 0)
        .fold(0, (sum, count) => sum + count);
  }
}

/// مولد ألوان المسبحة
class TasbihColorGenerator {
  static final List<Color> _colors = [
    AppTheme.primary,
    AppTheme.secondary,
    AppTheme.tertiary,
    AppTheme.success,
    AppTheme.warning,
    AppTheme.info,
    AppTheme.error,
  ];
  
  /// الحصول على لون للذكر بناءً على النص
  static Color getColorForDhikr(String dhikrText) {
    final hash = dhikrText.hashCode;
    return _colors[hash.abs() % _colors.length];
  }
  
  /// الحصول على تدرج للذكر
  static LinearGradient getGradientForDhikr(String dhikrText) {
    final color = getColorForDhikr(dhikrText);
    return LinearGradient(
      colors: [color, AppTheme.darken(color, 0.2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

/// صوتيات المسبحة
class TasbihAudio {
  /// تشغيل صوت النقر
  static void playClickSound() {
    // يمكن تنفيذ تشغيل الصوت هنا
    HapticFeedback.lightImpact();
  }
  
  /// تشغيل صوت الإكمال
  static void playCompletionSound() {
    // يمكن تنفيذ تشغيل صوت الإكمال هنا
    HapticFeedback.heavyImpact();
  }
  
  /// تشغيل تلاوة الذكر
  static void playDhikrRecitation(String dhikrText) {
    // يمكن تنفيذ تشغيل التلاوة هنا
  }
}