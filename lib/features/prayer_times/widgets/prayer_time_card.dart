// lib/features/prayer_times/widgets/prayer_time_card.dart (محدث بالنظام الموحد)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../models/prayer_time_model.dart';

/// بطاقة وقت الصلاة المحسنة باستخدام النظام الموحد
class PrayerTimeCard extends StatefulWidget {
  final PrayerTime prayer;
  final Function(bool) onNotificationToggle;
  final bool forceColored;

  const PrayerTimeCard({
    super.key,
    required this.prayer,
    required this.onNotificationToggle,
    this.forceColored = false,
  });

  @override
  State<PrayerTimeCard> createState() => _PrayerTimeCardState();
}

class _PrayerTimeCardState extends State<PrayerTimeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: ThemeConstants.curveSmooth,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isNext = widget.prayer.isNext;
    final isPassed = widget.prayer.isPassed;
    final useGradient = widget.forceColored || isNext;
    
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: _buildCard(context, useGradient, isPassed),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, bool useGradient, bool isPassed) {
    // استخدام AppCard من النظام الموحد
    return AppCard(
      type: CardType.normal,
      style: useGradient ? CardStyle.gradient : CardStyle.normal,
      primaryColor: useGradient 
          ? context.getPrayerColor(widget.prayer.type.name)
          : context.cardColor,
      gradientColors: useGradient ? [
        context.getPrayerColor(widget.prayer.type.name),
        context.getPrayerColor(widget.prayer.type.name).darken(0.2),
      ] : null,
      onTap: _handleCardTap,
      margin: const EdgeInsets.only(bottom: ThemeConstants.space3),
      child: _buildCardContent(context, useGradient, isPassed),
    );
  }

  Widget _buildCardContent(BuildContext context, bool useGradient, bool isPassed) {
    return Row(
      children: [
        _buildEnhancedStatusIcon(context, useGradient, isPassed),
        
        ThemeConstants.space4.w,
        
        Expanded(
          child: _buildPrayerInfo(context, useGradient, isPassed),
        ),
        
        ThemeConstants.space4.w,
        
        _buildEnhancedTimeSection(context, useGradient),
      ],
    );
  }

  Widget _buildEnhancedStatusIcon(
    BuildContext context, 
    bool useGradient, 
    bool isPassed
  ) {
    final iconData = _getStatusIcon(isPassed);
    final iconColor = _getIconColor(context, useGradient, isPassed);
    
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: useGradient 
            ? Colors.white.withValues(alpha: 0.25)
            : iconColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        border: Border.all(
          color: useGradient 
              ? Colors.white.withValues(alpha: 0.4)
              : iconColor.withValues(alpha: 0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: useGradient ? 0.3 : 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Icon(
          iconData,
          color: iconColor,
          size: ThemeConstants.iconLg,
        ),
      ),
    );
  }

  IconData _getStatusIcon(bool isPassed) {
    if (widget.prayer.isNext) {
      return Icons.schedule_rounded;
    } else if (isPassed) {
      return Icons.check_circle_rounded;
    } else {
      return context.getPrayerIcon(widget.prayer.nameAr);
    }
  }

  Color _getIconColor(BuildContext context, bool useGradient, bool isPassed) {
    if (useGradient) {
      return Colors.white;
    }
    
    if (widget.prayer.isNext) {
      return context.getPrayerColor(widget.prayer.type.name);
    } else if (isPassed) {
      return context.successColor;
    } else {
      return context.getPrayerColor(widget.prayer.type.name);
    }
  }

  Widget _buildPrayerInfo(BuildContext context, bool useGradient, bool isPassed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.prayer.nameAr,
          style: context.headlineSmall?.copyWith(
            color: _getTextColor(context, useGradient, isPassed),
            fontWeight: widget.prayer.isNext 
                ? ThemeConstants.bold 
                : ThemeConstants.semiBold,
            shadows: useGradient ? [
              Shadow(
                color: Colors.black.withValues(alpha: 0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ] : null,
          ),
        ),
        
        ThemeConstants.space2.h,
        
        Text(
          widget.prayer.nameEn,
          style: context.bodySmall?.copyWith(
            color: _getTextColor(context, useGradient, isPassed).withValues(alpha: 0.8),
            fontWeight: ThemeConstants.medium,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedTimeSection(BuildContext context, bool useGradient) {
    final baseColor = context.getPrayerColor(widget.prayer.type.name);
    
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: useGradient 
              ? [
                  Colors.white.withValues(alpha: 0.25),
                  Colors.white.withValues(alpha: 0.15),
                ]
              : [
                  baseColor.withValues(alpha: 0.15),
                  baseColor.withValues(alpha: 0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        border: Border.all(
          color: useGradient 
              ? Colors.white.withValues(alpha: 0.3)
              : baseColor.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (useGradient ? Colors.white : baseColor).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _formatTime(widget.prayer.time),
            style: context.headlineMedium?.copyWith(
              color: useGradient ? Colors.white : baseColor,
              fontWeight: ThemeConstants.bold,
              shadows: useGradient ? [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ] : null,
            ),
          ),
          
          if (widget.prayer.iqamaTime != null) ...[
            ThemeConstants.space1.h,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space2,
                vertical: ThemeConstants.space1,
              ),
              decoration: BoxDecoration(
                color: useGradient 
                    ? Colors.black.withValues(alpha: 0.2)
                    : context.surfaceColor,
                borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
              ),
              child: Text(
                'الإقامة ${_formatTime(widget.prayer.iqamaTime!)}',
                style: context.labelSmall?.copyWith(
                  color: useGradient 
                      ? Colors.white.withValues(alpha: 0.9)
                      : context.textSecondaryColor,
                  fontWeight: ThemeConstants.medium,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _handleCardTap() {
    HapticFeedback.lightImpact();
    // يمكن إضافة وظائف إضافية هنا مثل إظهار تفاصيل الصلاة
  }

  Color _getTextColor(BuildContext context, bool useGradient, bool isPassed) {
    if (useGradient) return Colors.white;
    if (isPassed) return context.textSecondaryColor;
    return context.textPrimaryColor;
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }
}