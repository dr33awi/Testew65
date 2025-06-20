// lib/features/athkar/widgets/athkar_stats_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

// ✅ استيرادات النظام الموحد الموجود فقط
import '../../../app/themes/index.dart';

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
      margin: EdgeInsets.all(context.mediumPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
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
            color: ThemeConstants.primary.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 1,
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
      padding: EdgeInsets.all(context.mediumPadding),
      child: Column(
        children: [
          // الرأس
          _buildHeader(context),
          
          Spaces.medium,
          
          // الإحصائيات
          _buildStatistics(context),
          
          if (widget.onViewDetails != null) ...[
            Spaces.medium,
            
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
        // الأيقونة الثابتة
        Container(
          width: 50,
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
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Icon(
            Icons.insights_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        
        Spaces.medium,
        
        // العنوان والوصف
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إحصائياتك اليوم',
                style: context.titleStyle.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
              
              Spaces.small,
              
              Text(
                _getMotivationalMessage(),
                style: context.bodyStyle.copyWith(
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
      padding: EdgeInsets.all(context.mediumPadding),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
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
            height: 40,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          
          // سلسلة الأيام
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
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onViewDetails!();
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: context.mediumPadding,
            horizontal: context.mediumPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.analytics_outlined,
                size: ThemeConstants.iconSm,
                color: ThemeConstants.primary,
              ),
              SizedBox(width: context.smallPadding),
              Text(
                'عرض التفاصيل',
                style: context.titleStyle.copyWith(
                  color: ThemeConstants.primary,
                  fontWeight: ThemeConstants.fontSemiBold,
                ),
              ),
              SizedBox(width: context.smallPadding),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: ThemeConstants.iconXs,
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
        // الأيقونة
        Stack(
          alignment: Alignment.center,
          children: [
            // توهج بسيط للخطوط المتتالية
            if (showGlow)
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
              ),
            
            // الأيقونة
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: hasStreak ? ThemeConstants.iconMd : ThemeConstants.iconSm,
              ),
            ),
            
            // شريط التقدم الدائري
            if (showProgress)
              SizedBox(
                width: 35,
                height: 35,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 2,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
          ],
        ),
        
        Spaces.small,
        
        // القيمة
        Text(
          value,
          style: context.titleStyle.copyWith(
            color: color,
            fontWeight: ThemeConstants.fontBold,
            fontSize: hasStreak ? 20 : 18,
          ),
        ),
        
        Spaces.xs,
        
        // التسمية
        Text(
          label,
          style: context.captionStyle.copyWith(
            color: color.withValues(alpha: 0.9),
            fontWeight: ThemeConstants.fontMedium,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}