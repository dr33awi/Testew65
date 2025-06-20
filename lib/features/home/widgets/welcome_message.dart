// lib/features/home/widgets/welcome_message.dart
import 'package:flutter/material.dart';
import '../../../app/themes/index.dart';

/// رسالة الترحيب الديناميكية في الصفحة الرئيسية
class WelcomeMessage extends StatefulWidget {
  /// اسم المستخدم (اختياري)
  final String? userName;
  
  /// عرض مبسط بدون تفاصيل إضافية
  final bool isCompact;
  
  /// إمكانية النقر على الرسالة
  final VoidCallback? onTap;

  const WelcomeMessage({
    super.key,
    this.userName,
    this.isCompact = false,
    this.onTap,
  });

  @override
  State<WelcomeMessage> createState() => _WelcomeMessageState();
}

class _WelcomeMessageState extends State<WelcomeMessage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: ThemeConstants.durationSlow,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.elasticOut),
    ));
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
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
              child: widget.isCompact ? _buildCompactMessage() : _buildFullMessage(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactMessage() {
    return IslamicCard(
      onTap: widget.onTap,
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      child: Row(
        children: [
          // أيقونة الوقت
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spaceSm),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
            ),
            child: Icon(
              _getCurrentTimeIcon(),
              color: context.primaryColor,
              size: ThemeConstants.iconMd,
            ),
          ),
          
          Spaces.mediumH,
          
          // رسالة الترحيب
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreetingMessage(),
                  style: context.titleStyle.copyWith(
                    fontWeight: ThemeConstants.fontSemiBold,
                  ),
                ),
                if (widget.userName != null) ...[
                  Spaces.xs,
                  Text(
                    widget.userName!,
                    style: context.bodyStyle.copyWith(
                      color: context.primaryColor,
                      fontWeight: ThemeConstants.fontMedium,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // أيقونة السهم إذا كانت قابلة للنقر
          if (widget.onTap != null)
            Icon(
              Icons.arrow_forward_ios,
              size: ThemeConstants.iconSm,
              color: context.secondaryTextColor,
            ),
        ],
      ),
    );
  }

  Widget _buildFullMessage() {
    return IslamicCard.gradient(
      gradient: _getCurrentGradient(),
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الرأس مع الوقت والتاريخ
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spaceMd),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                ),
                child: Icon(
                  _getCurrentTimeIcon(),
                  color: Colors.white,
                  size: ThemeConstants.iconLg,
                ),
              ),
              
              Spaces.mediumH,
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getCurrentTime(),
                      style: AppTypography.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: ThemeConstants.fontMedium,
                      ),
                    ),
                    Spaces.xs,
                    Text(
                      _getCurrentDate(),
                      style: AppTypography.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          Spaces.large,
          
          // رسالة الترحيب الرئيسية
          Text(
            _getGreetingMessage(),
            style: AppTypography.heading.copyWith(
              color: Colors.white,
              fontSize: widget.userName != null 
                  ? ThemeConstants.fontSize3xl 
                  : ThemeConstants.fontSize4xl,
            ),
          ),
          
          if (widget.userName != null) ...[
            Spaces.small,
            Text(
              widget.userName!,
              style: AppTypography.title.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                fontWeight: ThemeConstants.fontBold,
              ),
            ),
          ],
          
          Spaces.medium,
          
          // رسالة إلهامية
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spaceMd),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Colors.white.withValues(alpha: 0.8),
                  size: ThemeConstants.iconSm,
                ),
                Spaces.smallH,
                Expanded(
                  child: Text(
                    _getInspirationalMessage(),
                    style: AppTypography.body.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  IconData _getCurrentTimeIcon() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 12) {
      return Icons.wb_sunny; // صباح
    } else if (hour >= 12 && hour < 17) {
      return Icons.wb_cloudy; // ظهيرة
    } else if (hour >= 17 && hour < 20) {
      return Icons.brightness_3; // مساء
    } else {
      return Icons.nights_stay; // ليل
    }
  }

  LinearGradient _getCurrentGradient() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 12) {
      // تدرج الصباح - أصفر برتقالي
      return const LinearGradient(
        colors: [Color(0xFFFFB74D), Color(0xFFFF8A65)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour >= 12 && hour < 17) {
      // تدرج الظهيرة - أزرق سماوي
      return const LinearGradient(
        colors: [Color(0xFF42A5F5), Color(0xFF64B5F6)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else if (hour >= 17 && hour < 20) {
      // تدرج المساء - برتقالي وردي
      return const LinearGradient(
        colors: [Color(0xFFFF7043), Color(0xFFE57373)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    } else {
      // تدرج الليل - بنفسجي أزرق
      return const LinearGradient(
        colors: [Color(0xFF5C6BC0), Color(0xFF7986CB)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
  }

  String _getGreetingMessage() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 12) {
      return 'صباح الخير';
    } else if (hour >= 12 && hour < 17) {
      return 'أهلاً وسهلاً';
    } else if (hour >= 17 && hour < 20) {
      return 'مساء الخير';
    } else {
      return 'مساء الخير';
    }
  }

  String _getInspirationalMessage() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 12) {
      return 'ابدأ يومك بذكر الله والأذكار المباركة';
    } else if (hour >= 12 && hour < 17) {
      return 'استمر في ذكر الله واجعله نوراً في قلبك';
    } else if (hour >= 17 && hour < 20) {
      return 'اختتم يومك بالاستغفار والحمد لله';
    } else {
      return 'اقرأ أذكار النوم واستعد لليوم التالي';
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'مساءً' : 'صباحاً';
    
    return '$hour:$minute $period';
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    
    const arabicMonths = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    const arabicWeekdays = [
      'الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 
      'الجمعة', 'السبت', 'الأحد'
    ];
    
    final weekday = arabicWeekdays[now.weekday - 1];
    final day = now.day;
    final month = arabicMonths[now.month - 1];
    final year = now.year;
    
    return '$weekday، $day $month $year';
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}