// lib/features/prayer_times/widgets/prayer_time_card.dart - مُصحح نهائياً
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../models/prayer_time_model.dart';

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
            child: Container(
              margin: const EdgeInsets.only(bottom: ThemeConstants.space3),
              child: useGradient 
                  ? AppContainerBuilder.gradient(
                      colors: [
                        AppColorSystem.getPrayerColor(widget.prayer.type.name),
                        AppColorSystem.getPrayerColor(widget.prayer.type.name).darken(0.2),
                      ],
                      child: GestureDetector(
                        onTap: _handleCardTap,
                        child: _buildCardContent(context, useGradient, isPassed),
                      ),
                    )
                  : AppContainerBuilder.basic(
                      backgroundColor: AppColorSystem.getCard(context),
                      shadows: AppShadowSystem.card,
                      child: GestureDetector(
                        onTap: _handleCardTap,
                        child: _buildCardContent(context, useGradient, isPassed),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, bool useGradient, bool isPassed) {
    return Row(
      children: [
        _buildStatusIcon(context, useGradient, isPassed),
        const SizedBox(width: ThemeConstants.space4),
        Expanded(
          child: _buildPrayerInfo(context, useGradient, isPassed),
        ),
        const SizedBox(width: ThemeConstants.space4),
        _buildTimeSection(context, useGradient),
      ],
    );
  }

  Widget _buildStatusIcon(
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
        boxShadow: AppShadowSystem.colored(
          color: iconColor,
          opacity: useGradient ? 0.3 : 0.15,
        ),
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
      return AppIconsSystem.schedule;
    } else if (isPassed) {
      return AppIconsSystem.success;
    } else {
      return AppIconsSystem.getPrayerIcon(widget.prayer.nameAr);
    }
  }

  Color _getIconColor(BuildContext context, bool useGradient, bool isPassed) {
    if (useGradient) {
      return Colors.white;
    }
    
    if (widget.prayer.isNext) {
      return AppColorSystem.getPrayerColor(widget.prayer.type.name);
    } else if (isPassed) {
      return AppColorSystem.success;
    } else {
      return AppColorSystem.getPrayerColor(widget.prayer.type.name);
    }
  }

  Widget _buildPrayerInfo(BuildContext context, bool useGradient, bool isPassed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.prayer.nameAr,
          style: AppTextStyles.h4.copyWith(
            color: _getTextColor(context, useGradient, isPassed),
            fontWeight: widget.prayer.isNext 
                ? ThemeConstants.bold 
                : ThemeConstants.semiBold,
            shadows: useGradient ? AppShadowSystem.textShadow() : null,
          ),
        ),
        
        const SizedBox(height: ThemeConstants.space2),
        
        Text(
          widget.prayer.nameEn,
          style: AppTextStyles.body2.copyWith(
            color: _getTextColor(context, useGradient, isPassed).withValues(alpha: 0.8),
            fontWeight: ThemeConstants.medium,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection(BuildContext context, bool useGradient) {
    final baseColor = AppColorSystem.getPrayerColor(widget.prayer.type.name);
    
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
        boxShadow: AppShadowSystem.colored(
          color: useGradient ? Colors.white : baseColor,
          opacity: 0.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _formatTime(widget.prayer.time),
            style: AppTextStyles.h3.copyWith(
              color: useGradient ? Colors.white : baseColor,
              fontWeight: ThemeConstants.bold,
              shadows: useGradient ? AppShadowSystem.textShadow() : null,
            ),
          ),
          
          if (widget.prayer.iqamaTime != null) ...[
            const SizedBox(height: ThemeConstants.space1),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space2,
                vertical: ThemeConstants.space1,
              ),
              decoration: BoxDecoration(
                color: useGradient 
                    ? Colors.black.withValues(alpha: 0.2)
                    : AppColorSystem.getSurface(context),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
              ),
              child: Text(
                'الإقامة ${_formatTime(widget.prayer.iqamaTime!)}',
                style: AppTextStyles.caption.copyWith(
                  color: useGradient 
                      ? Colors.white.withValues(alpha: 0.9)
                      : AppColorSystem.getTextSecondary(context),
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
    // يمكن إضافة وظائف إضافية هنا
  }

  Color _getTextColor(BuildContext context, bool useGradient, bool isPassed) {
    if (useGradient) return Colors.white;
    if (isPassed) return AppColorSystem.getTextSecondary(context);
    return AppColorSystem.getTextPrimary(context);
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }
}