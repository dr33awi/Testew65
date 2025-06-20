// lib/features/prayer_times/widgets/prayer_time_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/index.dart';
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
            margin: const EdgeInsets.only(bottom: ThemeConstants.spaceMd),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              boxShadow: [
                BoxShadow(
                  color: useGradient 
                      ? gradient[0].withAlpha(0.3)
                      : Colors.black.withAlpha(0.08),
                  blurRadius: useGradient ? 25 : 15,
                  offset: Offset(0, useGradient ? 12 : 8),
                  spreadRadius: useGradient ? 2 : 0,
                ),
                if (useGradient) ...[
                  BoxShadow(
                    color: gradient[0].withAlpha(0.1),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                    spreadRadius: 5,
                  ),
                ],
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showPrayerDetails(context),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                  child: Stack(
                    children: [
                      // الخلفية المتدرجة أو العادية
                      _buildCardBackground(useGradient, gradient, isPassed),
                      
                      // المحتوى الرئيسي
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: useGradient 
                                ? Colors.white.withAlpha(0.2)
                                : context.borderColor.withAlpha(0.1),
                            width: useGradient ? 1.5 : 1,
                          ),
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
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
                                  Colors.white.withAlpha(0.2),
                                  Colors.white.withAlpha(0.05),
                                  Colors.transparent,
                                ],
                              ),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(ThemeConstants.radiusXl),
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
              gradient[0].withAlpha(0.95),
              gradient[1].withAlpha(0.9),
            ],
          ),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
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
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
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
      padding: const EdgeInsets.all(ThemeConstants.spaceLg),
      child: Column(
        children: [
          // الصف العلوي - الأيقونة والمعلومات والوقت
          Row(
            children: [
              // أيقونة الحالة المحسنة
              _buildEnhancedStatusIcon(context, useGradient, gradient, isPassed),
              
              Spaces.mediumH,
              
              // معلومات الصلاة
              Expanded(
                child: _buildPrayerInfo(context, useGradient, isPassed),
              ),
              
              Spaces.mediumH,
              
              // الوقت المحسن
              _buildEnhancedTimeSection(context, useGradient, gradient),
            ],
          ),
          
          Spaces.medium,
          
          // الصف السفلي - الحالة والإجراءات
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
      backgroundColor = Colors.white.withAlpha(0.25);
      borderColor = Colors.white.withAlpha(0.4);
    } else if (isPassed) {
      icon = Icons.check_circle_rounded;
      iconColor = useGradient ? Colors.white : ThemeConstants.success;
      backgroundColor = useGradient 
          ? Colors.white.withAlpha(0.25)
          : ThemeConstants.success.withAlpha(0.15);
      borderColor = useGradient 
          ? Colors.white.withAlpha(0.4)
          : ThemeConstants.success.withAlpha(0.3);
    } else {
      icon = _getPrayerIcon(widget.prayer.type);
      iconColor = useGradient ? Colors.white : gradient[0];
      backgroundColor = useGradient 
          ? Colors.white.withAlpha(0.25)
          : gradient[0].withAlpha(0.15);
      borderColor = useGradient 
          ? Colors.white.withAlpha(0.4)
          : gradient[0].withAlpha(0.3);
    }
    
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withAlpha(useGradient ? 0.3 : 0.15),
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
          size: ThemeConstants.iconMd,
        ),
      ),
    );
  }

  Widget _buildPrayerInfo(BuildContext context, bool useGradient, bool isPassed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // اسم الصلاة
        Text(
          widget.prayer.nameAr,
          style: context.titleStyle.copyWith(
            color: _getTextColor(context, useGradient, isPassed),
            fontWeight: widget.prayer.isNext 
                ? ThemeConstants.fontBold 
                : ThemeConstants.fontSemiBold,
            shadows: useGradient ? [
              Shadow(
                color: Colors.black.withAlpha(0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ] : null,
          ),
        ),
        
        Spaces.small,
        
        // الاسم بالإنجليزية
        Text(
          widget.prayer.nameEn,
          style: context.captionStyle.copyWith(
            color: _getTextColor(context, useGradient, isPassed).withAlpha(0.8),
            fontWeight: ThemeConstants.fontMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedTimeSection(BuildContext context, bool useGradient, List<Color> gradient) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: useGradient 
              ? [
                  Colors.white.withAlpha(0.25),
                  Colors.white.withAlpha(0.15),
                ]
              : [
                  gradient[0].withAlpha(0.15),
                  gradient[0].withAlpha(0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(
          color: useGradient 
              ? Colors.white.withAlpha(0.3)
              : gradient[0].withAlpha(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: (useGradient ? Colors.white : gradient[0]).withAlpha(0.2),
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
            style: context.titleStyle.copyWith(
              color: useGradient ? Colors.white : gradient[0],
              fontWeight: ThemeConstants.fontBold,
              shadows: useGradient ? [
                Shadow(
                  color: Colors.black.withAlpha(0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ] : null,
            ),
          ),
          
          // وقت الإقامة (إذا توفر)
          if (widget.prayer.iqamaTime != null) ...[
            Spaces.xs,
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.spaceSm,
                vertical: ThemeConstants.spaceXs,
              ),
              decoration: BoxDecoration(
                color: useGradient 
                    ? Colors.black.withAlpha(0.2)
                    : context.surfaceColor,
                borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
              ),
              child: Text(
                'الإقامة ${_formatTime(widget.prayer.iqamaTime!)}',
                style: context.captionStyle.copyWith(
                  color: useGradient 
                      ? Colors.white.withAlpha(0.9)
                      : context.secondaryTextColor,
                  fontWeight: ThemeConstants.fontMedium,
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
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        color: useGradient 
            ? Colors.white.withAlpha(0.1)
            : context.surfaceColor.withAlpha(0.5),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(
          color: useGradient 
              ? Colors.white.withAlpha(0.2)
              : context.borderColor.withAlpha(0.2),
        ),
      ),
      child: Row(
        children: [
          // معلومات الحالة
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
                onTap: () => widget.onNotificationToggle(!widget.prayer.isNotificationEnabled),
                useGradient: useGradient,
                tooltip: 'تبديل التنبيه',
              ),
              Spaces.smallH,
              _buildActionButton(
                context: context,
                icon: Icons.more_vert,
                onTap: () => _showPrayerOptions(context),
                useGradient: useGradient,
                tooltip: 'خيارات',
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
              Icon(
                Icons.schedule,
                size: ThemeConstants.iconSm,
                color: useGradient ? Colors.white.withAlpha(0.8) : context.primaryColor,
              ),
              Spaces.smallH,
              Text(
                'متبقي ${widget.prayer.remainingTimeText}',
                style: context.captionStyle.copyWith(
                  color: useGradient ? Colors.white.withAlpha(0.9) : context.textColor,
                  fontWeight: ThemeConstants.fontMedium,
                ),
              ),
            ],
          );
        },
      );
    } else if (widget.prayer.isPassed) {
      return Row(
        children: [
          Icon(
            Icons.check_circle,
            size: ThemeConstants.iconSm,
            color: useGradient ? Colors.white.withAlpha(0.8) : ThemeConstants.success,
          ),
          Spaces.smallH,
          Text(
            'انتهت',
            style: context.captionStyle.copyWith(
              color: useGradient ? Colors.white.withAlpha(0.9) : context.secondaryTextColor,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Icon(
            Icons.access_time,
            size: ThemeConstants.iconSm,
            color: useGradient ? Colors.white.withAlpha(0.8) : context.secondaryTextColor,
          ),
          Spaces.smallH,
          Text(
            'قادمة',
            style: context.captionStyle.copyWith(
              color: useGradient ? Colors.white.withAlpha(0.9) : context.secondaryTextColor,
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
            ? Colors.white.withAlpha(0.2)
            : context.primaryColor.withAlpha(0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: ThemeConstants.iconSm,
          color: useGradient ? Colors.white : context.primaryColor,
        ),
        onPressed: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        tooltip: tooltip,
        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      ),
    );
  }

  Color _getTextColor(BuildContext context, bool useGradient, bool isPassed) {
    if (useGradient) return Colors.white;
    if (isPassed) return context.secondaryTextColor;
    return context.textColor;
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
    // عرض تفاصيل الصلاة
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPrayerDetailsSheet(context),
    );
  }

  void _showPrayerOptions(BuildContext context) {
    // عرض خيارات الصلاة
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPrayerOptionsSheet(context),
    );
  }

  Widget _buildPrayerDetailsSheet(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // عنوان الصلاة
            Row(
              children: [
                Icon(
                  _getPrayerIcon(widget.prayer.type),
                  color: _getPrayerTypeColor(widget.prayer.type),
                  size: ThemeConstants.iconMd,
                ),
                Spaces.mediumH,
                Text(
                  'صلاة ${widget.prayer.nameAr}',
                  style: context.titleStyle.copyWith(
                    fontWeight: ThemeConstants.fontBold,
                  ),
                ),
              ],
            ),
            
            Spaces.large,
            
            // معلومات الوقت
            _buildDetailRow('الوقت', _formatTime(widget.prayer.time)),
            if (widget.prayer.iqamaTime != null)
              _buildDetailRow('الإقامة', _formatTime(widget.prayer.iqamaTime!)),
            
            Spaces.large,
            
            // إغلاق
            IslamicButton.outlined(
              text: 'إغلاق',
              onPressed: () => Navigator.pop(context),
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerOptionsSheet(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.spaceLg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'خيارات الصلاة',
              style: context.titleStyle.copyWith(
                fontWeight: ThemeConstants.fontBold,
              ),
            ),
            
            Spaces.large,
            
            // خيارات
            ListTile(
              leading: Icon(
                Icons.notifications,
                color: context.primaryColor,
              ),
              title: const Text('تبديل التنبيه'),
              onTap: () {
                Navigator.pop(context);
                widget.onNotificationToggle(!widget.prayer.isNotificationEnabled);
              },
            ),
            
            ListTile(
              leading: Icon(
                Icons.info,
                color: context.primaryColor,
              ),
              title: const Text('تفاصيل الصلاة'),
              onTap: () {
                Navigator.pop(context);
                _showPrayerDetails(context);
              },
            ),
            
            Spaces.medium,
            
            IslamicButton.outlined(
              text: 'إلغاء',
              onPressed: () => Navigator.pop(context),
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: ThemeConstants.spaceSm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.bodyStyle.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
          Text(
            value,
            style: context.bodyStyle.copyWith(
              fontWeight: ThemeConstants.fontSemiBold,
            ),
          ),
        ],
      ),
    );
  }