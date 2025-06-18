// lib/features/athkar/widgets/athkar_progress_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';

class AthkarProgressBar extends StatefulWidget {
  final int progress;
  final Color color;
  final int completedCount;
  final int totalCount;

  const AthkarProgressBar({
    super.key,
    required this.progress,
    required this.color,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  State<AthkarProgressBar> createState() => _AthkarProgressBarState();
}

class _AthkarProgressBarState extends State<AthkarProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _progressController = AnimationController(
      duration: ThemeConstants.durationExtraSlow,
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress / 100,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: ThemeConstants.curveSmooth,
    ));

    _progressController.forward();
  }

  @override
  void didUpdateWidget(AthkarProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _progressAnimation = Tween<double>(
        begin: oldWidget.progress / 100,
        end: widget.progress / 100,
      ).animate(CurvedAnimation(
        parent: _progressController,
        curve: ThemeConstants.curveSmooth,
      ));
      _progressController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space3, // تقليل المارجن
        vertical: ThemeConstants.space2, // تقليل المارجن
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl), // تقليل الزاوية
        gradient: LinearGradient(
          colors: [
            widget.color.withValues(alpha: 0.05),
            widget.color.withValues(alpha: 0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: context.dividerColor.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
            ),
            child: Padding(
              padding: const EdgeInsets.all(ThemeConstants.space4), // تقليل الpadding
              child: Column(
                children: [
                  // الرأس
                  _buildHeader(context),
                  
                  ThemeConstants.space3.h, // تقليل المسافة
                  
                  // شريط التقدم المحسن
                  _buildProgressBar(context),
                  
                  ThemeConstants.space3.h, // تقليل المسافة
                  
                  // الإحصائيات
                  _buildStatistics(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // أيقونة التقدم الثابتة (مصغرة)
        Container(
          width: 45, // تصغير الحجم
          height: 45,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                widget.color.withValues(alpha: 0.2),
                widget.color.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd), // تقليل الزاوية
            border: Border.all(
              color: widget.color.withValues(alpha: 0.3),
              width: 1.5, // تقليل سماكة الحد
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.1), // تقليل شدة الظل
                blurRadius: 8, // تقليل الضبابية
                offset: const Offset(0, 4), // تقليل الإزاحة
              ),
            ],
          ),
          child: Icon(
            Icons.trending_up_rounded,
            color: widget.color,
            size: ThemeConstants.iconMd, // تصغير الأيقونة
          ),
        ),
        
        ThemeConstants.space3.w, // تقليل المسافة
        
        // معلومات التقدم
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'التقدم الإجمالي',
                style: context.titleMedium?.copyWith( // تصغير الخط
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              ThemeConstants.space1.h,
              Text(
                'استمر في التقدم والأجر',
                style: context.bodySmall?.copyWith( // تصغير الخط
                  color: context.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
        
        // النسبة المئوية (مصغرة)
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            final currentProgress = (_progressAnimation.value * 100).round();
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space3, // تقليل الpadding
                vertical: ThemeConstants.space2,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    widget.color.withValues(alpha: 0.9),
                    widget.color.darken(0.1).withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd), // تقليل الزاوية
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.2), // تقليل شدة الظل
                    blurRadius: 8, // تقليل الضبابية
                    offset: const Offset(0, 4), // تقليل الإزاحة
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '$currentProgress%',
                    style: context.titleMedium?.copyWith( // تصغير الخط
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                    ),
                  ),
                  Text(
                    'مكتمل',
                    style: context.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: ThemeConstants.medium,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    return Column(
      children: [
        // معلومات التقدم
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التقدم الحالي',
              style: context.labelMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
            AnimatedBuilder(
              animation: _progressAnimation,
              builder: (context, child) {
                final currentProgress = (_progressAnimation.value * 100).round();
                return Text(
                  '$currentProgress% مكتمل',
                  style: context.labelMedium?.copyWith(
                    color: widget.color,
                    fontWeight: ThemeConstants.semiBold,
                  ),
                );
              },
            ),
          ],
        ),
        
        ThemeConstants.space2.h, // تقليل المسافة
        
        // شريط التقدم البسيط (مصغر)
        Container(
          height: 12, // تقليل الارتفاع
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusSm), // تقليل الزاوية
            border: Border.all(
              color: context.dividerColor.withValues(alpha: 0.3),
            ),
          ),
          child: Stack(
            children: [
              // الخلفية مع تدرج خفيف
              Container(
                height: 12, // تقليل الارتفاع
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      context.isDarkMode 
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.05),
                      Colors.transparent,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSm), // تقليل الزاوية
                ),
              ),
              
              // شريط التقدم المتحرك
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusSm), // تقليل الزاوية
                    child: LinearProgressIndicator(
                      value: _progressAnimation.value,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(widget.color),
                      minHeight: 12, // تقليل الارتفاع
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.check_circle_rounded,
            label: 'مكتمل',
            value: '${widget.completedCount}',
            color: ThemeConstants.success,
          ),
        ),
        
        ThemeConstants.space3.w,
        
        Expanded(
          child: _StatCard(
            icon: Icons.pending_rounded,
            label: 'متبقي',
            value: '${widget.totalCount - widget.completedCount}',
            color: ThemeConstants.warning,
          ),
        ),
        
        ThemeConstants.space3.w,
        
        Expanded(
          child: _StatCard(
            icon: Icons.list_rounded,
            label: 'الكل',
            value: '${widget.totalCount}',
            color: widget.color,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space3), // تقليل الpadding
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd), // تقليل الزاوية
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 6, // تقليل الضبابية
            offset: const Offset(0, 2), // تقليل الإزاحة
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space1), // تقليل الpadding
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: ThemeConstants.iconSm, // تصغير الأيقونة
            ),
          ),
          
          ThemeConstants.space1.h, // تقليل المسافة
          
          Text(
            value,
            style: context.titleMedium?.copyWith( // تصغير الخط
              color: color,
              fontWeight: ThemeConstants.bold,
            ),
          ),
          
          ThemeConstants.space1.h,
          
          Text(
            label,
            style: context.labelSmall?.copyWith( // تصغير الخط
              color: context.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }
}