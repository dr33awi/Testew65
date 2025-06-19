// lib/features/prayer_times/widgets/prayer_time_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';
import '../models/prayer_time_model.dart';

/// بطاقة وقت الصلاة المحسنة
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
    final gradient = _getGradient(widget.prayer.type);
    final useGradient = widget.forceColored || isNext;
    
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.only(bottom: ThemeConstants.space3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              boxShadow: [
                BoxShadow(
                  color: useGradient 
                      ? gradient[0].withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: 0.08),
                  blurRadius: useGradient ? 25 : 15,
                  offset: Offset(0, useGradient ? 12 : 8),
                  spreadRadius: useGradient ? 2 : 0,
                ),
                if (useGradient) ...[
                  BoxShadow(
                    color: gradient[0].withValues(alpha: 0.1),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                    spreadRadius: 5,
                  ),
                ],
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showPrayerDetails(context),
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                  child: Stack(
                    children: [
                      // الخلفية المتدرجة أو العادية
                      _buildCardBackground(useGradient, gradient, isPassed),
                      
                      // المحتوى الرئيسي
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: useGradient 
                                ? Colors.white.withValues(alpha: 0.2)
                                : context.dividerColor.withValues(alpha: 0.1),
                            width: useGradient ? 1.5 : 1,
                          ),
                          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                        ),
                        child: _buildCardContent(context, useGradient, gradient, isPassed),
                      ),
                      
                      // تأثير الضوء في الأعلى
                      if (useGradient)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.white.withValues(alpha: 0.2),
                                  Colors.white.withValues(alpha: 0.05),
                                  Colors.transparent,
                                ],
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(ThemeConstants.radius2xl),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardBackground(bool useGradient, List<Color> gradient, bool isPassed) {
    if (useGradient) {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              gradient[0].withValues(alpha: 0.95),
              gradient[1].withValues(alpha: 0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.cardColor,
              context.cardColor.darken(0.02),
            ],
          ),
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        ),
      );
    }
  }

  Widget _buildCardContent(
    BuildContext context, 
    bool useGradient, 
    List<Color> gradient, 
    bool isPassed
  ) {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space5),
      child: Column(
        children: [
          // الصف العلوي - الأيقونة والمعلومات والوقت
          Row(
            children: [
              // أيقونة الحالة المحسنة
              _buildEnhancedStatusIcon(context, useGradient, gradient, isPassed),
              
              ThemeConstants.space4.w,
              
              // معلومات الصلاة
              Expanded(
                child: _buildPrayerInfo(context, useGradient, isPassed),
              ),
              
              ThemeConstants.space4.w,
              
              // الوقت المحسن
              _buildEnhancedTimeSection(context, useGradient, gradient),
            ],
          ),
          
          ThemeConstants.space4.h,
          
          // الصف السفلي - العداد والإعدادات
          _buildBottomRow(context, useGradient, gradient),
        ],
      ),
    );
  }

  Widget _buildEnhancedStatusIcon(
    BuildContext context, 
    bool useGradient, 
    List<Color> gradient, 
    bool isPassed
  ) {
    IconData icon;
    Color iconColor;
    Color backgroundColor;
    Color borderColor;
    
    if (widget.prayer.isNext) {
      icon = Icons.schedule_rounded;
      iconColor = Colors.white;
      backgroundColor = Colors.white.withValues(alpha: 0.25);
      borderColor = Colors.white.withValues(alpha: 0.4);
    } else if (isPassed) {
      icon = Icons.check_circle_rounded;
      iconColor = useGradient ? Colors.white : ThemeConstants.success;
      backgroundColor = useGradient 
          ? Colors.white.withValues(alpha: 0.25)
          : ThemeConstants.success.withValues(alpha: 0.15);
      borderColor = useGradient 
          ? Colors.white.withValues(alpha: 0.4)
          : ThemeConstants.success.withValues(alpha: 0.3);
    } else {
      icon = _getPrayerIcon(widget.prayer.type);
      iconColor = useGradient ? Colors.white : gradient[0];
      backgroundColor = useGradient 
          ? Colors.white.withValues(alpha: 0.25)
          : gradient[0].withValues(alpha: 0.15);
      borderColor = useGradient 
          ? Colors.white.withValues(alpha: 0.4)
          : gradient[0].withValues(alpha: 0.3);
    }
    
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        border: Border.all(
          color: borderColor,
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
          icon,
          color: iconColor,
          size: ThemeConstants.iconLg,
        ),
      ),
    );
  }

  Widget _buildPrayerInfo(BuildContext context, bool useGradient, bool isPassed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // اسم الصلاة مع تأثير نص
        Row(
          children: [
            Expanded(
              child: Text(
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
            ),
            // شارة الحالة
            if (widget.prayer.isNext)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space2,
                  vertical: ThemeConstants.space1,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  'القادمة',
                  style: context.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
        
        ThemeConstants.space2.h,
        
        // الاسم بالإنجليزية
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

  Widget _buildEnhancedTimeSection(BuildContext context, bool useGradient, List<Color> gradient) {
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
                  gradient[0].withValues(alpha: 0.15),
                  gradient[0].withValues(alpha: 0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        border: Border.all(
          color: useGradient 
              ? Colors.white.withValues(alpha: 0.3)
              : gradient[0].withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (useGradient ? Colors.white : gradient[0]).withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // الوقت الرئيسي
          Text(
            _formatTime(widget.prayer.time),
            style: context.headlineMedium?.copyWith(
              color: useGradient ? Colors.white : gradient[0],
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
          
          // وقت الإقامة (إذا توفر)
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

  Widget _buildBottomRow(BuildContext context, bool useGradient, List<Color> gradient) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space3),
      decoration: BoxDecoration(
        color: useGradient 
            ? Colors.white.withValues(alpha: 0.1)
            : context.surfaceColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        border: Border.all(
          color: useGradient 
              ? Colors.white.withValues(alpha: 0.2)
              : context.dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          // معلومات الحالة أو العد التنازلي
          Expanded(
            child: _buildStatusInfo(context, useGradient),
          ),
          
          // أزرار الإجراءات
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                context: context,
                icon: Icons.notifications_outlined,
                onTap: () {
                  HapticFeedback.lightImpact();
                  widget.onNotificationToggle(true);
                },
                useGradient: useGradient,
                tooltip: 'تنبيه الصلاة',
              ),
              
              ThemeConstants.space2.w,
              
              _buildActionButton(
                context: context,
                icon: Icons.info_outline,
                onTap: () => _showPrayerDetails(context),
                useGradient: useGradient,
                tooltip: 'تفاصيل الصلاة',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusInfo(BuildContext context, bool useGradient) {
    if (widget.prayer.isNext) {
      return StreamBuilder(
        stream: Stream.periodic(const Duration(seconds: 1)),
        builder: (context, snapshot) {
          return Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space1),
                decoration: BoxDecoration(
                  color: useGradient 
                      ? Colors.white.withValues(alpha: 0.2)
                      : ThemeConstants.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.timer_outlined,
                  size: ThemeConstants.iconSm,
                  color: useGradient 
                      ? Colors.white.withValues(alpha: 0.9)
                      : ThemeConstants.primary,
                ),
              ),
              ThemeConstants.space2.w,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الوقت المتبقي',
                      style: context.labelSmall?.copyWith(
                        color: _getTextColor(context, useGradient, false).withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      widget.prayer.remainingTimeText,
                      style: context.labelMedium?.copyWith(
                        color: _getTextColor(context, useGradient, false),
                        fontWeight: ThemeConstants.semiBold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    } else if (widget.prayer.isPassed) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space1),
            decoration: BoxDecoration(
              color: useGradient 
                  ? Colors.white.withValues(alpha: 0.2)
                  : ThemeConstants.success.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              size: ThemeConstants.iconSm,
              color: useGradient 
                  ? Colors.white.withValues(alpha: 0.9)
                  : ThemeConstants.success,
            ),
          ),
          ThemeConstants.space2.w,
          Text(
            'انتهى وقت الصلاة',
            style: context.labelMedium?.copyWith(
              color: _getTextColor(context, useGradient, true),
              fontWeight: ThemeConstants.medium,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space1),
            decoration: BoxDecoration(
              color: useGradient 
                  ? Colors.white.withValues(alpha: 0.2)
                  : _getGradient(widget.prayer.type)[0].withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.schedule_outlined,
              size: ThemeConstants.iconSm,
              color: useGradient 
                  ? Colors.white.withValues(alpha: 0.9)
                  : _getGradient(widget.prayer.type)[0],
            ),
          ),
          ThemeConstants.space2.w,
          Text(
            'صلاة قادمة',
            style: context.labelMedium?.copyWith(
              color: _getTextColor(context, useGradient, false),
              fontWeight: ThemeConstants.medium,
            ),
          ),
        ],
      );
    }
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
    required bool useGradient,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: useGradient 
            ? Colors.white.withValues(alpha: 0.2)
            : context.surfaceColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(
          color: useGradient 
              ? Colors.white.withValues(alpha: 0.3)
              : context.dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          child: Container(
            padding: const EdgeInsets.all(ThemeConstants.space2),
            child: Icon(
              icon,
              size: ThemeConstants.iconMd,
              color: useGradient 
                  ? Colors.white.withValues(alpha: 0.9)
                  : context.textSecondaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Color _getTextColor(BuildContext context, bool useGradient, bool isPassed) {
    if (useGradient) return Colors.white;
    if (isPassed) return context.textSecondaryColor;
    return context.textPrimaryColor;
  }

  List<Color> _getGradient(PrayerType type) {
    final baseColor = _getPrayerTypeColor(type);
    return [baseColor, baseColor.darken(0.2)];
  }
  
  Color _getPrayerTypeColor(PrayerType type) {
    return ThemeConstants.getPrayerColor(type.name);
  }

  IconData _getPrayerIcon(PrayerType type) {
    return ThemeConstants.getPrayerIcon(type.name);
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }

  void _showPrayerDetails(BuildContext context) {
    HapticFeedback.lightImpact();
    
    AppInfoDialog.show(
      context: context,
      title: widget.prayer.nameAr,
      content: 'وقت ${widget.prayer.nameAr}: ${_formatTime(widget.prayer.time)}',
      subtitle: widget.prayer.isPassed 
          ? 'انتهى وقت الصلاة' 
          : widget.prayer.remainingTimeText,
      icon: _getPrayerIcon(widget.prayer.type),
      accentColor: _getGradient(widget.prayer.type)[0],
      actions: [
        DialogAction(
          label: 'إعدادات الصلاة',
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/prayer-settings');
          },
          isPrimary: true,
        ),
      ],
    );
  }
}