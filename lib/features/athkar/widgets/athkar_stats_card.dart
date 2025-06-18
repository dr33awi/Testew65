// lib/features/athkar/widgets/athkar_stats_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';

class AthkarStatsCard extends StatefulWidget {
  final int totalCategories;
  final int completedToday;
  final int streak;
  final VoidCallback? onViewDetails;

  const AthkarStatsCard({
    super.key,
    required this.totalCategories,
    required this.completedToday,
    required this.streak,
    this.onViewDetails,
  });

  @override
  State<AthkarStatsCard> createState() => _AthkarStatsCardState();
}

class _AthkarStatsCardState extends State<AthkarStatsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.space3), // تقليل المارجن
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl), // تقليل الزاوية
        gradient: LinearGradient(
          colors: [
            ThemeConstants.primary.withValues(alpha: 0.9),
            ThemeConstants.primary.darken(0.1).withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeConstants.primary.withValues(alpha: 0.2), // تقليل الظل
            blurRadius: 15, // تقليل الضبابية
            offset: const Offset(0, 8), // تقليل الإزاحة
            spreadRadius: 1, // تقليل الانتشار
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
            ),
            child: _buildContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4), // تقليل الpadding
      child: Column(
        children: [
          // الرأس
          _buildHeader(context),
          
          ThemeConstants.space3.h, // تقليل المسافة
          
          // الإحصائيات
          _buildStatistics(context),
          
          if (widget.onViewDetails != null) ...[
            ThemeConstants.space3.h, // تقليل المسافة
            
            // زر عرض التفاصيل
            _buildDetailsButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // الأيقونة الثابتة (مصغرة)
        Container(
          width: 50, // تصغير الحجم
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.2),
                blurRadius: 10, // تقليل الضبابية
                spreadRadius: 1, // تقليل الانتشار
              ),
            ],
          ),
          child: const Icon(
            Icons.insights_rounded,
            color: Colors.white,
            size: 24, // تصغير الأيقونة
          ),
        ),
        
        ThemeConstants.space3.w, // تقليل المسافة
        
        // العنوان والوصف
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إحصائياتك اليوم',
                style: context.titleLarge?.copyWith( // تصغير الخط
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              
              ThemeConstants.space1.h,
              
              Text(
                _getMotivationalMessage(),
                style: context.bodyMedium?.copyWith( // تصغير الخط
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space3), // تقليل الpadding
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg), // تقليل الزاوية
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // الأذكار المكتملة
          Expanded(
            child: _StatItem(
              icon: Icons.check_circle_rounded,
              value: '${widget.completedToday}/${widget.totalCategories}',
              label: 'أكملت اليوم',
              color: Colors.white,
              showProgress: true,
              progress: widget.totalCategories > 0 
                  ? widget.completedToday / widget.totalCategories 
                  : 0.0,
            ),
          ),
          
          // الفاصل
          Container(
            width: 1,
            height: 40, // تقليل الارتفاع
            color: Colors.white.withValues(alpha: 0.3),
          ),
          
          // سلسلة الأيام (بدون أنيميشن)
          Expanded(
            child: _StatItem(
              icon: Icons.local_fire_department_rounded,
              value: '${widget.streak}',
              label: widget.streak == 1 ? 'يوم متتالي' : 'أيام متتالية',
              color: Colors.white,
              hasStreak: widget.streak > 0,
              showGlow: widget.streak > 0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: AnimatedPress(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onViewDetails!();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: ThemeConstants.space3, // تقليل الpadding
            horizontal: ThemeConstants.space4,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg), // تقليل الزاوية
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10, // تقليل الضبابية
                offset: const Offset(0, 4), // تقليل الإزاحة
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.analytics_outlined,
                size: ThemeConstants.iconSm, // تصغير الأيقونة
                color: ThemeConstants.primary,
              ),
              ThemeConstants.space2.w,
              Text(
                'عرض التفاصيل',
                style: context.titleSmall?.copyWith( // تصغير الخط
                  color: ThemeConstants.primary,
                  fontWeight: ThemeConstants.semiBold,
                ),
              ),
              ThemeConstants.space2.w,
              // أيقونة السهم الثابتة
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: ThemeConstants.iconXs, // تصغير الأيقونة
                color: ThemeConstants.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getMotivationalMessage() {
    final completionPercentage = widget.totalCategories > 0 
        ? (widget.completedToday / widget.totalCategories) * 100 
        : 0;
    
    if (completionPercentage == 100) {
      return 'ما شاء الله! أكملت جميع الأذكار اليوم 🎉';
    } else if (completionPercentage >= 75) {
      return 'أحسنت! تقدم ممتاز، أكمل البقية 💪';
    } else if (completionPercentage >= 50) {
      return 'بداية موفقة! استمر في هذا التقدم الرائع 📈';
    } else if (completionPercentage > 0) {
      return 'بداية طيبة، لا تتوقف واستمر في الذكر 🌟';
    } else {
      return 'ابدأ يومك بالأذكار واجعله مباركاً ✨';
    }
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool hasStreak;
  final bool showProgress;
  final double progress;
  final bool showGlow;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.hasStreak = false,
    this.showProgress = false,
    this.progress = 0.0,
    this.showGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // الأيقونة (بدون تأثيرات)
        Stack(
          alignment: Alignment.center,
          children: [
            // توهج بسيط للخطوط المتتالية
            if (showGlow)
              Container(
                width: 35, // تصغير الحجم
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.3),
                      blurRadius: 15, // تقليل الضبابية
                      spreadRadius: 3, // تقليل الانتشار
                    ),
                  ],
                ),
              ),
            
            // الأيقونة
            Container(
              width: 32, // تصغير الحجم
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: hasStreak ? ThemeConstants.iconMd : ThemeConstants.iconSm, // تصغير الأيقونة
              ),
            ),
            
            // شريط التقدم الدائري
            if (showProgress)
              SizedBox(
                width: 35, // تصغير الحجم
                height: 35,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 2, // تقليل السماكة
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
          ],
        ),
        
        ThemeConstants.space2.h, // تقليل المسافة
        
        // القيمة
        Text(
          value,
          style: context.titleLarge?.copyWith( // تصغير الخط
            color: color,
            fontWeight: ThemeConstants.bold,
            fontSize: hasStreak ? 20 : 18, // تصغير الحجم
          ),
        ),
        
        ThemeConstants.space1.h,
        
        // التسمية
        Text(
          label,
          style: context.labelSmall?.copyWith( // تصغير الخط
            color: color.withValues(alpha: 0.9),
            fontWeight: ThemeConstants.medium,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}