// lib/features/prayer_times/widgets/prayer_time_card.dart - النسخة الموحدة

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
              child: _buildCard(context, useGradient, isPassed),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, bool useGradient, bool isPassed) {
    if (useGradient) {
      // ✅ استخدام AppCard مع تدرج موحد
      return AppCard.custom(
        style: CardStyle.glassmorphism,
        gradientColors: [
          widget.prayer.type.name.themeColor,
          widget.prayer.type.name.themeColor.darken(0.2),
        ],
        onTap: _handleCardTap,
        child: _buildCardContent(context, useGradient, isPassed),
      );
    } else {
      // ✅ استخدام AppCard عادي
      return AppCard.simple(
        title: widget.prayer.nameAr,
        subtitle: widget.prayer.nameEn,
        icon: widget.prayer.type.name.themePrayerIcon,
        onTap: _handleCardTap,
        primaryColor: widget.prayer.type.name.themeColor,
      ).cardContainer(
        margin: EdgeInsets.zero,
        withGlass: false,
      );
    }
  }

  Widget _buildCardContent(BuildContext context, bool useGradient, bool isPassed) {
    return Row(
      children: [
        _buildStatusIcon(context, useGradient, isPassed),
        ThemeConstants.space4.w,
        Expanded(
          child: _buildPrayerInfo(context, useGradient, isPassed),
        ),
        ThemeConstants.space4.w,
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
    
    // ✅ استخدام النظام الموحد للحاويات
    return AppContainerBuilder.glass(
      child: Icon(
        iconData,
        color: iconColor,
        size: ThemeConstants.iconLg,
      ),
      borderRadius: ThemeConstants.radiusXl,
      backgroundColor: useGradient 
          ? Colors.white.withOpacitySafe(0.25)
          : iconColor.withOpacitySafe(0.15),
      padding: EdgeInsets.zero,
    ).shadow(
      color: iconColor,
      intensity: ShadowIntensity.medium,
    );
  }

  IconData _getStatusIcon(bool isPassed) {
    if (widget.prayer.isNext) {
      return AppIconsSystem.schedule;
    } else if (isPassed) {
      return AppIconsSystem.success;
    } else {
      return widget.prayer.nameAr.themePrayerIcon;
    }
  }

  Color _getIconColor(BuildContext context, bool useGradient, bool isPassed) {
    if (useGradient) {
      return Colors.white;
    }
    
    if (widget.prayer.isNext) {
      return widget.prayer.type.name.themeColor;
    } else if (isPassed) {
      return 'success'.themeColor;
    } else {
      return widget.prayer.type.name.themeColor;
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
        
        ThemeConstants.space2.h,
        
        Text(
          widget.prayer.nameEn,
          style: AppTextStyles.body2.copyWith(
            color: _getTextColor(context, useGradient, isPassed).withOpacitySafe(0.8),
            fontWeight: ThemeConstants.medium,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection(BuildContext context, bool useGradient) {
    final baseColor = widget.prayer.type.name.themeColor;
    
    // ✅ استخدام AppContainerBuilder للحاوية الموحدة
    return AppContainerBuilder.gradient(
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
          
          // ✅ معلومات الإقامة
          if (widget.prayer.iqamaTime != null) ...[
            ThemeConstants.space1.h,
            AppNoticeCard.info(
              title: 'الإقامة ${_formatTime(widget.prayer.iqamaTime!)}',
            ).padded(EdgeInsets.zero),
          ],
        ],
      ),
      gradientColors: useGradient 
          ? [
              Colors.white.withOpacitySafe(0.25),
              Colors.white.withOpacitySafe(0.15),
            ]
          : [
              baseColor.withOpacitySafe(0.15),
              baseColor.withOpacitySafe(0.1),
            ],
      borderRadius: ThemeConstants.radiusXl,
      padding: ThemeConstants.space4.all,
    ).shadow(
      color: useGradient ? Colors.white : baseColor,
      intensity: ShadowIntensity.light,
    );
  }

  void _handleCardTap() {
    HapticFeedback.lightImpact();
    
    // ✅ استخدام النظام الموحد للحوارات
    AppInfoDialog.show(
      context: context,
      title: 'صلاة ${widget.prayer.nameAr}',
      content: 'الوقت: ${_formatTime(widget.prayer.time)}\n'
               'الحالة: ${widget.prayer.isNext ? "القادمة" : widget.prayer.isPassed ? "انتهت" : "لم تحن بعد"}',
      icon: widget.prayer.nameAr.themePrayerIcon,
      accentColor: widget.prayer.type.name.themeColor,
      actions: [
        DialogAction(
          label: 'تفعيل التنبيه',
          onPressed: () {
            Navigator.pop(context);
            widget.onNotificationToggle(true);
          },
          isPrimary: true,
        ),
      ],
    );
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