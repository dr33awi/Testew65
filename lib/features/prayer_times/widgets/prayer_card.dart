// lib/features/prayer_times/widgets/prayer_card.dart

import 'package:flutter/material.dart';
import '../../../app/themes/index.dart';
import '../models/prayer_time_model.dart';

/// بطاقة عرض وقت الصلاة
class PrayerCard extends StatelessWidget {
  final PrayerTime prayer;
  final VoidCallback? onTap;

  const PrayerCard({
    super.key,
    required this.prayer,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IslamicCard(
      onTap: onTap,
      gradient: prayer.isNext ? ThemeConstants.primaryGradient : null,
      color: prayer.isNext ? null : context.cardColor,
      child: Row(
        children: [
          // أيقونة الصلاة
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getPrayerColor().withValues(alpha: prayer.isNext ? 0.2 : 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getPrayerIcon(),
              color: prayer.isNext ? Colors.white : _getPrayerColor(),
              size: 24,
            ),
          ),
          
          Spaces.mediumH,
          
          // معلومات الصلاة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prayer.nameAr,
                  style: (prayer.isNext ? context.titleStyle.copyWith(color: Colors.white) : context.titleStyle).medium,
                ),
                
                if (prayer.isNext && !prayer.isPassed) ...[
                  Spaces.xs,
                  Text(
                    prayer.remainingTimeText,
                    style: context.captionStyle.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // وقت الصلاة
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatTime(prayer.time),
                style: (prayer.isNext ? context.titleStyle.copyWith(color: Colors.white) : context.titleStyle).bold,
              ),
              
              if (prayer.isPassed) ...[
                Spaces.xs,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: context.successColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'انتهت',
                    style: context.captionStyle.copyWith(
                      color: context.successColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              
              if (prayer.isApproaching && !prayer.isPassed) ...[
                Spaces.xs,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: context.warningColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'قريباً',
                    style: context.captionStyle.copyWith(
                      color: context.warningColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Color _getPrayerColor() {
    return ThemeConstants.getPrayerColor(prayer.nameEn);
  }

  IconData _getPrayerIcon() {
    return ThemeConstants.getPrayerIcon(prayer.nameEn);
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'م' : 'ص';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }
}

// lib/features/prayer_times/widgets/next_prayer_card.dart

/// بطاقة عرض الصلاة التالية مع العد التنازلي
class NextPrayerCard extends StatefulWidget {
  final PrayerTime prayer;

  const NextPrayerCard({
    super.key,
    required this.prayer,
  });

  @override
  State<NextPrayerCard> createState() => _NextPrayerCardState();
}

class _NextPrayerCardState extends State<NextPrayerCard> 
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;
  
  @override
  void initState() {
    super.initState();
    
    // تحكم في نبضة البطاقة
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // تحكم في تأثير الإضاءة
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_pulseAnimation, _shimmerAnimation]),
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: ThemeConstants.getPrayerColor(widget.prayer.nameEn).withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: ThemeConstants.getPrayerColor(widget.prayer.nameEn).withValues(alpha: 0.1),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                  spreadRadius: 4,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // الخلفية المتدرجة
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ThemeConstants.getPrayerColor(widget.prayer.nameEn),
                          ThemeConstants.getPrayerColor(widget.prayer.nameEn).darken(0.2),
                        ],
                      ),
                    ),
                  ),
                  
                  // تأثير الإضاءة المتحركة
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Transform.translate(
                        offset: Offset(_shimmerAnimation.value * 200, 0),
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Colors.white.withValues(alpha: 0.1),
                                Colors.white.withValues(alpha: 0.2),
                                Colors.white.withValues(alpha: 0.1),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  // المحتوى
                  Padding(
                    padding: EdgeInsets.all(context.largePadding),
                    child: Column(
                      children: [
                        // العنوان
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.schedule,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            Spaces.smallH,
                            Text(
                              'الصلاة التالية',
                              style: context.bodyStyle.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                _getRelativeTime(),
                                style: context.captionStyle.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                        Spaces.large,
                        
                        // اسم الصلاة والأيقونة
                        Row(
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                ThemeConstants.getPrayerIcon(widget.prayer.nameEn),
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            Spaces.mediumH,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.prayer.nameAr,
                                    style: context.headingStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    _formatTime(widget.prayer.time),
                                    style: context.titleStyle.copyWith(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        
                        Spaces.large,
                        
                        // العد التنازلي
                        _buildCountdown(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCountdown() {
    final remaining = widget.prayer.remainingTime;
    
    if (remaining.inSeconds <= 0) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 24,
              ),
            ),
            Spaces.mediumH,
            Text(
              'حان الآن وقت الصلاة',
              style: context.titleStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    }
    
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            'الوقت المتبقي',
            style: context.bodyStyle.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
          Spaces.medium,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTimeUnit(hours, 'ساعة'),
              _buildTimeSeparator(),
              _buildTimeUnit(minutes, 'دقيقة'),
              _buildTimeSeparator(),
              _buildTimeUnit(seconds, 'ثانية'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(int value, String label) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              value.toString().padLeft(2, '0'),
              style: context.titleStyle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
        Spaces.small,
        Text(
          label,
          style: context.captionStyle.copyWith(
            color: Colors.white.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSeparator() {
    return Column(
      children: [
        Text(
          ':',
          style: context.titleStyle.copyWith(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        // إصلاح: إضافة const
        const SizedBox(height: 20),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'مساءً' : 'صباحاً';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    
    return '$displayHour:$minute $period';
  }

  String _getRelativeTime() {
    final remaining = widget.prayer.remainingTime;
    
    if (remaining.inSeconds <= 0) {
      return 'الآن';
    } else if (remaining.inMinutes < 60) {
      return 'خلال ${remaining.inMinutes} دقيقة';
    } else if (remaining.inHours < 24) {
      return 'خلال ${remaining.inHours} ساعة';
    } else {
      return 'غداً';
    }
  }
}