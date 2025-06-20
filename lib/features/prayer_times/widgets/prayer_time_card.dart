// lib/features/prayer_times/widgets/prayer_time_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/index.dart';
import '../models/prayer_time_model.dart';

/// بطاقة وقت الصلاة المحسنة مع الثيم الموحد
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
    final prayerColor = ThemeConstants.getPrayerColor(widget.prayer.nameAr);
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
              boxShadow: useGradient 
                  ? [
                      BoxShadow(
                        color: prayerColor.withAlpha(77),
                        blurRadius: 25,
                        offset: const Offset(0, 12),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: prayerColor.withAlpha(26),
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                        spreadRadius: 5,
                      ),
                    ]
                  : ThemeConstants.shadowMd,
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
                      // الخلفية
                      _buildCardBackground(useGradient, prayerColor, isPassed),
                      
                      // المحتوى الرئيسي
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: useGradient 
                                ? Colors.white.withAlpha(51)
                                : context.borderColor,
                            width: useGradient ? 1.5 : 1,
                          ),
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                        ),
                        child: _buildCardContent(context, useGradient, prayerColor, isPassed),
                      ),
                      
                      // تأثير الضوء
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
                                  Colors.white.withAlpha(51),
                                  Colors.white.withAlpha(13),
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

  Widget _buildCardBackground(bool useGradient, Color prayerColor, bool isPassed) {
    if (useGradient) {
      return Container(
        decoration: BoxDecoration(
          gradient: ThemeConstants.getPrayerGradient(widget.prayer.nameAr),
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
          color: context.cardColor,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        ),
      );
    }
  }

  Widget _buildCardContent(
    BuildContext context, 
    bool useGradient, 
    Color prayerColor, 
    bool isPassed
  ) {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.spaceLg),
      child: Column(
        children: [
          // الصف العلوي
          Row(
            children: [
              // أيقونة الحالة
              _buildStatusIcon(context, useGradient, prayerColor, isPassed),
              
              const HSpace(ThemeConstants.spaceMd),
              
              // معلومات الصلاة
              Expanded(
                child: _buildPrayerInfo(context, useGradient, isPassed),
              ),
              
              const HSpace(ThemeConstants.spaceMd),
              
              // الوقت
              _buildTimeSection(context, useGradient, prayerColor),
            ],
          ),
          
          const VSpace(ThemeConstants.spaceMd),
          
          // الصف السفلي
          _buildBottomRow(context, useGradient, prayerColor),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(
    BuildContext context, 
    bool useGradient, 
    Color prayerColor, 
    bool isPassed
  ) {
    IconData icon;
    Color iconColor;
    Color backgroundColor;
    
    if (widget.prayer.isNext) {
      icon = Icons.schedule_rounded;
      iconColor = useGradient ? Colors.white : prayerColor;
      backgroundColor = useGradient 
          ? Colors.white.withAlpha(64)
          : prayerColor.withAlpha(38);
    } else if (isPassed) {
      icon = Icons.check_circle_rounded;
      iconColor = useGradient ? Colors.white : ThemeConstants.success;
      backgroundColor = useGradient 
          ? Colors.white.withAlpha(64)
          : ThemeConstants.success.withAlpha(38);
    } else {
      icon = ThemeConstants.getPrayerIcon(widget.prayer.nameAr);
      iconColor = useGradient ? Colors.white : prayerColor;
      backgroundColor = useGradient 
          ? Colors.white.withAlpha(64)
          : prayerColor.withAlpha(38);
    }
    
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(
          color: iconColor.withAlpha(102),
          width: 2,
        ),
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: ThemeConstants.iconMd,
      ),
    );
  }

  Widget _buildPrayerInfo(BuildContext context, bool useGradient, bool isPassed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.prayer.nameAr,
          style: context.titleStyle.copyWith(
            color: useGradient 
                ? Colors.white 
                : isPassed 
                    ? context.secondaryTextColor 
                    : context.textColor,
            fontWeight: widget.prayer.isNext 
                ? ThemeConstants.fontBold 
                : ThemeConstants.fontSemiBold,
          ),
        ),
        const VSpace(ThemeConstants.spaceSm),
        Text(
          widget.prayer.nameEn,
          style: context.captionStyle.copyWith(
            color: useGradient 
                ? Colors.white.withAlpha(204)
                : context.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection(BuildContext context, bool useGradient, Color prayerColor) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        color: useGradient 
            ? Colors.white.withAlpha(64)
            : prayerColor.withAlpha(38),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        border: Border.all(
          color: useGradient 
              ? Colors.white.withAlpha(77)
              : prayerColor.withAlpha(51),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _formatTime(widget.prayer.time),
            style: context.titleStyle.copyWith(
              color: useGradient ? Colors.white : prayerColor,
              fontWeight: ThemeConstants.fontBold,
            ),
          ),
          if (widget.prayer.iqamaTime != null) ...[
            const VSpace(ThemeConstants.spaceXs),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.spaceSm,
                vertical: ThemeConstants.spaceXs,
              ),
              decoration: BoxDecoration(
                color: useGradient 
                    ? Colors.black.withAlpha(51)
                    : context.surfaceColor,
                borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
              ),
              child: Text(
                'الإقامة ${_formatTime(widget.prayer.iqamaTime!)}',
                style: context.captionStyle.copyWith(
                  color: useGradient 
                      ? Colors.white.withAlpha(229)
                      : context.secondaryTextColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomRow(BuildContext context, bool useGradient, Color prayerColor) {
    return IslamicCard(
      color: useGradient 
          ? Colors.white.withAlpha(38)
          : context.surfaceColor.withAlpha(128),
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      child: Row(
        children: [
          Expanded(
            child: _buildStatusInfo(context, useGradient),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionButton(
                context: context,
                icon: Icons.notifications_outlined,
                onTap: () => widget.onNotificationToggle(true),
                useGradient: useGradient,
                tooltip: 'تبديل التنبيه',
              ),
              const HSpace(ThemeConstants.spaceSm),
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
                color: useGradient 
                    ? Colors.white.withAlpha(204) 
                    : context.primaryColor,
              ),
              const HSpace(ThemeConstants.spaceSm),
              Text(
                'متبقي ${widget.prayer.remainingTimeText}',
                style: context.captionStyle.copyWith(
                  color: useGradient 
                      ? Colors.white.withAlpha(229) 
                      : context.textColor,
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
            color: useGradient 
                ? Colors.white.withAlpha(204) 
                : ThemeConstants.success,
          ),
          const HSpace(ThemeConstants.spaceSm),
          Text(
            'انتهت',
            style: context.captionStyle.copyWith(
              color: useGradient 
                  ? Colors.white.withAlpha(229) 
                  : context.secondaryTextColor,
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
            color: useGradient 
                ? Colors.white.withAlpha(204) 
                : context.secondaryTextColor,
          ),
          const HSpace(ThemeConstants.spaceSm),
          Text(
            'قادمة',
            style: context.captionStyle.copyWith(
              color: useGradient 
                  ? Colors.white.withAlpha(229) 
                  : context.secondaryTextColor,
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
            ? Colors.white.withAlpha(51)
            : context.primaryColor.withAlpha(26),
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

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }

  void _showPrayerDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPrayerDetailsSheet(context),
    );
  }

  void _showPrayerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildPrayerOptionsSheet(context),
    );
  }

  Widget _buildPrayerDetailsSheet(BuildContext context) {
    return IslamicCard(
      color: context.cardColor,
      margin: const EdgeInsets.all(ThemeConstants.spaceMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                ThemeConstants.getPrayerIcon(widget.prayer.nameAr),
                color: ThemeConstants.getPrayerColor(widget.prayer.nameAr),
                size: ThemeConstants.iconMd,
              ),
              const HSpace(ThemeConstants.spaceMd),
              Text(
                'صلاة ${widget.prayer.nameAr}',
                style: context.titleStyle.copyWith(
                  fontWeight: ThemeConstants.fontBold,
                ),
              ),
            ],
          ),
          
          const VSpace(ThemeConstants.spaceLg),
          
          _buildDetailRow(context, 'الوقت', _formatTime(widget.prayer.time)),
          if (widget.prayer.iqamaTime != null)
            _buildDetailRow(context, 'الإقامة', _formatTime(widget.prayer.iqamaTime!)),
          
          const VSpace(ThemeConstants.spaceLg),
          
          IslamicButton.outlined(
            text: 'إغلاق',
            onPressed: () => Navigator.pop(context),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerOptionsSheet(BuildContext context) {
    return IslamicCard(
      color: context.cardColor,
      margin: const EdgeInsets.all(ThemeConstants.spaceMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'خيارات الصلاة',
            style: context.titleStyle.copyWith(
              fontWeight: ThemeConstants.fontBold,
            ),
          ),
          
          const VSpace(ThemeConstants.spaceLg),
          
          ListTile(
            leading: Icon(
              Icons.notifications,
              color: context.primaryColor,
            ),
            title: const Text('تبديل التنبيه'),
            onTap: () {
              Navigator.pop(context);
              widget.onNotificationToggle(true);
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
          
          const VSpace(ThemeConstants.spaceMd),
          
          IslamicButton.outlined(
            text: 'إلغاء',
            onPressed: () => Navigator.pop(context),
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
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
}