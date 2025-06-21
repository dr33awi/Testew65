// lib/features/home/widgets/home_prayer_times_card.dart
import 'package:flutter/material.dart';
import '../../../app/themes/index.dart';
import '../../../app/routes/app_router.dart';

/// بطاقة أوقات الصلاة في الصفحة الرئيسية
class HomePrayerTimesCard extends StatefulWidget {
  /// اسم الصلاة القادمة
  final String? nextPrayerName;
  
  /// وقت الصلاة القادمة
  final String? nextPrayerTime;
  
  /// الوقت المتبقي للصلاة القادمة
  final Duration? timeUntilNextPrayer;
  
  /// callback عند النقر على "عرض الكل"
  final VoidCallback? onViewAllTap;
  
  /// callback عند النقر على "تفعيل الموقع"
  final VoidCallback? onLocationTap;

  const HomePrayerTimesCard({
    super.key,
    this.nextPrayerName,
    this.nextPrayerTime,
    this.timeUntilNextPrayer,
    this.onViewAllTap,
    this.onLocationTap,
  });

  @override
  State<HomePrayerTimesCard> createState() => _HomePrayerTimesCardState();
}

class _HomePrayerTimesCardState extends State<HomePrayerTimesCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.1, 0.8, curve: Curves.easeOutCubic),
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: _buildCard(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard() {
    return IslamicCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Spaces.medium,
          _hasPrayerData() ? _buildPrayerInfo() : _buildLocationPrompt(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(ThemeConstants.spaceSm),
          decoration: BoxDecoration(
            color: ThemeConstants.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
          ),
          child: const Icon(
            Icons.mosque,
            color: ThemeConstants.primary,
          ),
        ),
        Spaces.mediumH,
        Expanded(
          child: Text(
            'أوقات الصلاة',
            style: context.titleStyle.copyWith(
              fontWeight: ThemeConstants.fontBold,
            ),
          ),
        ),
        TextButton(
          onPressed: widget.onViewAllTap ?? _defaultViewAllAction,
          child: const Text('عرض الكل'),
        ),
      ],
    );
  }

  Widget _buildPrayerInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        gradient: ThemeConstants.primaryGradient,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      child: Column(
        children: [
          Text(
            'الصلاة القادمة',
            style: AppTypography.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          Spaces.small,
          Text(
            widget.nextPrayerName!,
            style: AppTypography.title.copyWith(
              color: Colors.white,
              fontWeight: ThemeConstants.fontBold,
            ),
          ),
          Spaces.xs,
          Text(
            widget.nextPrayerTime!,
            style: AppTypography.subtitle.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          if (widget.timeUntilNextPrayer != null) ...[
            Spaces.small,
            _buildTimeRemaining(),
          ],
        ],
      ),
    );
  }

  Widget _buildTimeRemaining() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spaceMd,
        vertical: ThemeConstants.spaceSm,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.schedule,
            color: Colors.white,
            size: ThemeConstants.iconSm,
          ),
          Spaces.smallH,
          Text(
            _formatDuration(widget.timeUntilNextPrayer!),
            style: AppTypography.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: ThemeConstants.fontMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPrompt() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ThemeConstants.spaceLg),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spaceMd),
            decoration: BoxDecoration(
              color: context.secondaryTextColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
            ),
            child: Icon(
              Icons.location_off,
              size: ThemeConstants.iconLg,
              color: context.secondaryTextColor,
            ),
          ),
          Spaces.medium,
          Text(
            'يرجى تفعيل الموقع لعرض أوقات الصلاة',
            style: context.bodyStyle.copyWith(
              fontWeight: ThemeConstants.fontMedium,
            ),
            textAlign: TextAlign.center,
          ),
          Spaces.small,
          Text(
            'سيتم عرض أوقات الصلاة بناءً على موقعك الحالي',
            style: context.captionStyle,
            textAlign: TextAlign.center,
          ),
          Spaces.large,
          IslamicButton.primary(
            text: 'تفعيل الموقع',
            icon: Icons.location_on,
            onPressed: widget.onLocationTap ?? _defaultLocationAction,
          ),
        ],
      ),
    );
  }

  // Helper methods
  bool _hasPrayerData() {
    return widget.nextPrayerName != null && 
           widget.nextPrayerTime != null;
  }

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      return '$hours ساعة و $minutes دقيقة';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} دقيقة';
    } else {
      return 'أقل من دقيقة';
    }
  }

  void _defaultViewAllAction() {
    AppRouter.push(AppRouter.prayerTimes);
  }

  void _defaultLocationAction() {
    AppRouter.push(AppRouter.prayerSettings);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}