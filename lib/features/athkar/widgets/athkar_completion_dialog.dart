// lib/features/athkar/widgets/athkar_completion_dialog.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';

class AthkarCompletionDialog extends StatefulWidget {
  final String categoryName;
  final VoidCallback? onShare;
  final VoidCallback? onReset;

  const AthkarCompletionDialog({
    super.key,
    required this.categoryName,
    this.onShare,
    this.onReset,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String categoryName,
    VoidCallback? onShare,
    VoidCallback? onReset,
  }) async {
    HapticFeedback.mediumImpact();
    
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AthkarCompletionDialog(
        categoryName: categoryName,
        onShare: onShare,
        onReset: onReset,
      ),
    );
  }

  @override
  State<AthkarCompletionDialog> createState() => _AthkarCompletionDialogState();
}

class _AthkarCompletionDialogState extends State<AthkarCompletionDialog>
    with TickerProviderStateMixin {
  late final AnimationController _mainController;
  late final AnimationController _confettiController;
  late final AnimationController _pulseController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startAnimations();
  }

  void _setupAnimations() {
    _mainController = AnimationController(
      vsync: this,
      duration: ThemeConstants.durationSlow,
    );
    
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: const Interval(0.0, 0.6),
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _startAnimations() async {
    _mainController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _confettiController.repeat();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _confettiController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _mainController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
                  gradient: LinearGradient(
                    colors: [
                      ThemeConstants.success.withValues(alpha: 0.95),
                      ThemeConstants.success.darken(0.1).withValues(alpha: 0.95),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Stack(
                      children: [
                        // Confetti في الخلفية
                        _buildConfettiBackground(),
                        
                        // المحتوى الرئيسي
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(ThemeConstants.radius3xl),
                          ),
                          child: _buildContent(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildConfettiBackground() {
    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _confettiController,
        builder: (context, child) {
          return CustomPaint(
            painter: ConfettiPainter(_confettiController.value),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // الأيقونة المتحركة
          _buildSuccessIcon(),
          
          ThemeConstants.space4.h,
          
          // العنوان والرسالة
          _buildTitleSection(context),
          
          ThemeConstants.space4.h,
          
          // معلومات الإنجاز
          _buildAchievementInfo(context),
          
          ThemeConstants.space4.h,
          
          // آية قرآنية
          _buildQuranVerse(context),
          
          ThemeConstants.space6.h,
          
          // الأزرار
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // دوائر متحركة في الخلفية
                ...List.generate(3, (index) {
                  return AnimatedBuilder(
                    animation: _confettiController,
                    builder: (context, child) {
                      final offset = _confettiController.value * 2 * math.pi + index;
                      return Transform.scale(
                        scale: 1.0 + (math.sin(offset) * 0.1),
                        child: Container(
                          width: 100 - (index * 20),
                          height: 100 - (index * 20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2 - (index * 0.05)),
                              width: 1,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
                
                // الأيقونة الرئيسية
                const Icon(
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 60,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleSection(BuildContext context) {
    return AnimationConfiguration.synchronized(
      duration: ThemeConstants.durationNormal,
      child: SlideAnimation(
        verticalOffset: 30,
        child: FadeInAnimation(
          child: Column(
            children: [
              Text(
                'بارك الله فيك! 🎉',
                style: context.headlineLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              ThemeConstants.space2.h,
              
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'أكملت ${widget.categoryName}',
                      style: context.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.semiBold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    ThemeConstants.space1.h,
                    Text(
                      'جعله الله في ميزان حسناتك',
                      style: context.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementInfo(BuildContext context) {
    return AnimationConfiguration.synchronized(
      duration: ThemeConstants.durationNormal,
      child: SlideAnimation(
        verticalOffset: 30,
        delay: const Duration(milliseconds: 200),
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('✓', 'مكتمل', 'بالكامل'),
                _buildStatItem('🤲', 'ثواب', 'عظيم'),
                _buildStatItem('⭐', 'إنجاز', 'رائع'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String icon, String title, String subtitle) {
    return Column(
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 24),
        ),
        ThemeConstants.space1.h,
        Text(
          title,
          style: context.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: ThemeConstants.semiBold,
          ),
        ),
        Text(
          subtitle,
          style: context.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildQuranVerse(BuildContext context) {
    return AnimationConfiguration.synchronized(
      duration: ThemeConstants.durationNormal,
      child: SlideAnimation(
        verticalOffset: 30,
        delay: const Duration(milliseconds: 400),
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                Text(
                  '﴿ وَاذْكُر رَّبَّكَ كَثِيرًا وَسَبِّحْ بِالْعَشِيِّ وَالْإِبْكَارِ ﴾',
                  style: context.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontFamily: ThemeConstants.fontFamilyArabic,
                    height: 2.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                ThemeConstants.space2.h,
                Text(
                  'سورة آل عمران - آية 41',
                  style: context.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // زر المشاركة
        if (widget.onShare != null)
          AnimationConfiguration.synchronized(
            duration: ThemeConstants.durationNormal,
            child: SlideAnimation(
              horizontalOffset: 50,
              delay: const Duration(milliseconds: 600),
              child: FadeInAnimation(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context, false);
                      widget.onShare?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: ThemeConstants.success,
                      padding: const EdgeInsets.symmetric(vertical: ThemeConstants.space4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                      ),
                      elevation: 8,
                    ),
                    icon: const Icon(Icons.share_rounded),
                    label: Text(
                      'مشاركة الإنجاز 📱',
                      style: context.titleMedium?.copyWith(
                        fontWeight: ThemeConstants.semiBold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        
        if (widget.onShare != null) ThemeConstants.space3.h,
        
        // الأزرار الثانوية
        AnimationConfiguration.synchronized(
          duration: ThemeConstants.durationNormal,
          child: SlideAnimation(
            horizontalOffset: -50,
            delay: const Duration(milliseconds: 800),
            child: FadeInAnimation(
              child: Row(
                children: [
                  // زر الإغلاق
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                        padding: const EdgeInsets.symmetric(vertical: ThemeConstants.space3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                        ),
                      ),
                      child: const Text('إغلاق'),
                    ),
                  ),
                  
                  if (widget.onReset != null) ...[
                    ThemeConstants.space3.w,
                    
                    // زر البدء من جديد
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context, true);
                          widget.onReset?.call();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white.withValues(alpha: 0.5)),
                          padding: const EdgeInsets.symmetric(vertical: ThemeConstants.space3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                          ),
                        ),
                        icon: const Icon(Icons.refresh_rounded, size: 18),
                        label: const Text('البدء مجدداً'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// رسام الconfetti المحسن
class ConfettiPainter extends CustomPainter {
  final double animationValue;

  ConfettiPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // ألوان مختلفة للconfetti
    final colors = [
      Colors.white.withValues(alpha: 0.9),
      Colors.yellow.withValues(alpha: 0.8),
      Colors.orange.withValues(alpha: 0.8),
      Colors.pink.withValues(alpha: 0.8),
      Colors.lightBlue.withValues(alpha: 0.8),
    ];
    
    // رسم جزيئات متحركة متطورة
    for (int i = 0; i < 25; i++) {
      final progress = (animationValue + i * 0.08) % 1.0;
      final lateralMovement = math.sin(animationValue * 4 + i) * 30;
      
      final x = (size.width * 0.1) + (i % 5) * (size.width * 0.2) + lateralMovement;
      final y = -20 + progress * (size.height + 40);
      final colorIndex = i % colors.length;
      
      paint.color = colors[colorIndex];
      
      // أشكال مختلفة ومتنوعة
      if (i % 4 == 0) {
        // دوائر
        canvas.drawCircle(Offset(x, y), 4, paint);
      } else if (i % 4 == 1) {
        // مربعات مدورة
        final rect = RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset(x, y), width: 8, height: 8),
          const Radius.circular(2),
        );
        canvas.drawRRect(rect, paint);
      } else if (i % 4 == 2) {
        // نجوم
        _drawStar(canvas, Offset(x, y), 5, paint);
      } else {
        // قلوب صغيرة
        _drawHeart(canvas, Offset(x, y), 4, paint);
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const points = 5;
    const angle = 3.14159 * 2 / points;
    
    for (int i = 0; i < points; i++) {
      final outerAngle = i * angle - 3.14159 / 2;
      final innerAngle = outerAngle + angle / 2;
      
      final outerX = center.dx + radius * math.cos(outerAngle);
      final outerY = center.dy + radius * math.sin(outerAngle);
      
      final innerX = center.dx + radius * 0.5 * math.cos(innerAngle);
      final innerY = center.dy + radius * 0.5 * math.sin(innerAngle);
      
      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    
    path.moveTo(center.dx, center.dy + size);
    
    path.cubicTo(
      center.dx - size, center.dy,
      center.dx - size, center.dy - size / 2,
      center.dx, center.dy - size / 2,
    );
    
    path.cubicTo(
      center.dx + size, center.dy - size / 2,
      center.dx + size, center.dy,
      center.dx, center.dy + size,
    );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}