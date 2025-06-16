// lib/features/athkar/widgets/athkar_completion_dialog.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _mainController = AnimationController(
      vsync: this,
      duration: ThemeConstants.durationSlow,
    );
    
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
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
    
    _startAnimations();
  }

  void _startAnimations() async {
    _mainController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _confettiController.repeat();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _confettiController.dispose();
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              ),
              elevation: 16,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                  gradient: ThemeConstants.customGradient(
                    colors: [
                      ThemeConstants.success.lighten(0.2),
                      ThemeConstants.success,
                      ThemeConstants.success.darken(0.1),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Confetti في الخلفية
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                        child: AnimatedBuilder(
                          animation: _confettiController,
                          builder: (context, child) {
                            return CustomPaint(
                              painter: _ConfettiPainter(_confettiController.value),
                            );
                          },
                        ),
                      ),
                    ),
                    
                    // المحتوى
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // الرأس
                        Container(
                          padding: const EdgeInsets.all(ThemeConstants.space6),
                          child: Column(
                            children: [
                              // الأيقونة المتحركة
                              _AnimatedSuccessIcon(
                                animation: _mainController,
                              ),
                              
                              ThemeConstants.space4.h,
                              
                              // العنوان
                              AnimationConfiguration.synchronized(
                                duration: ThemeConstants.durationNormal,
                                child: SlideAnimation(
                                  verticalOffset: 20,
                                  curve: Curves.easeOutBack,
                                  child: FadeInAnimation(
                                    child: Text(
                                      'بارك الله فيك! 🎉',
                                      style: context.headlineMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: ThemeConstants.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              
                              ThemeConstants.space2.h,
                              
                              // الرسالة
                              AnimationConfiguration.synchronized(
                                duration: ThemeConstants.durationNormal,
                                child: SlideAnimation(
                                  verticalOffset: 20,
                                  curve: Curves.easeOutBack,
                                  delay: const Duration(milliseconds: 100),
                                  child: FadeInAnimation(
                                    child: Container(
                                      padding: const EdgeInsets.all(ThemeConstants.space3),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
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
                                  ),
                                ),
                              ),
                              
                              ThemeConstants.space2.h,
                              
                              // آية أو حديث
                              AnimationConfiguration.synchronized(
                                duration: ThemeConstants.durationNormal,
                                child: SlideAnimation(
                                  verticalOffset: 20,
                                  curve: Curves.easeOutBack,
                                  delay: const Duration(milliseconds: 200),
                                  child: FadeInAnimation(
                                    child: Container(
                                      padding: const EdgeInsets.all(ThemeConstants.space3),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                                      ),
                                      child: Text(
                                        '\"واذكر ربك كثيراً وسبح بالعشي والإبكار\"',
                                        style: context.bodyMedium?.copyWith(
                                          color: Colors.white.withValues(alpha: 0.8),
                                          fontStyle: FontStyle.italic,
                                          height: 1.6,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        // الإجراءات
                        Container(
                          decoration: BoxDecoration(
                            color: context.cardColor,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(ThemeConstants.radiusXl),
                              bottomRight: Radius.circular(ThemeConstants.radiusXl),
                            ),
                          ),
                          padding: const EdgeInsets.all(ThemeConstants.space4),
                          child: Column(
                            children: [
                              // زر المشاركة
                              if (widget.onShare != null)
                                AnimationConfiguration.synchronized(
                                  duration: ThemeConstants.durationNormal,
                                  child: SlideAnimation(
                                    horizontalOffset: 50,
                                    curve: Curves.easeOutBack,
                                    delay: const Duration(milliseconds: 300),
                                    child: FadeInAnimation(
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: AppButton.custom(
                                          text: 'مشاركة الإنجاز 📱',
                                          icon: Icons.share_rounded,
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                            widget.onShare?.call();
                                          },
                                          backgroundColor: ThemeConstants.success,
                                          textColor: Colors.white,
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
                                  curve: Curves.easeOutBack,
                                  delay: const Duration(milliseconds: 400),
                                  child: FadeInAnimation(
                                    child: Row(
                                      children: [
                                        // زر الإغلاق
                                        Expanded(
                                          child: AppButton.text(
                                            text: 'إغلاق',
                                            onPressed: () => Navigator.pop(context, false),
                                            color: context.textSecondaryColor,
                                          ),
                                        ),
                                        
                                        ThemeConstants.space3.w,
                                        
                                        // زر البدء من جديد
                                        if (widget.onReset != null)
                                          Expanded(
                                            child: AppButton.outline(
                                              text: 'البدء مجدداً',
                                              onPressed: () {
                                                Navigator.pop(context, true);
                                                widget.onReset?.call();
                                              },
                                              icon: Icons.refresh_rounded,
                                              color: ThemeConstants.success,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// أيقونة النجاح المتحركة
class _AnimatedSuccessIcon extends StatelessWidget {
  final Animation<double> animation;

  const _AnimatedSuccessIcon({
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 2,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // الدوائر المتحركة
              _AnimatedCircle(
                animation: animation,
                delay: 0.0,
                size: 100,
                opacity: 0.3,
              ),
              _AnimatedCircle(
                animation: animation,
                delay: 0.2,
                size: 80,
                opacity: 0.4,
              ),
              _AnimatedCircle(
                animation: animation,
                delay: 0.4,
                size: 60,
                opacity: 0.5,
              ),
              
              // الأيقونة
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: animation,
                  curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
                ),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: ThemeConstants.success,
                    size: 36,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// دائرة متحركة
class _AnimatedCircle extends StatelessWidget {
  final Animation<double> animation;
  final double delay;
  final double size;
  final double opacity;

  const _AnimatedCircle({
    required this.animation,
    required this.delay,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        final value = Curves.easeOut.transform(
          ((animation.value - delay) / (1 - delay)).clamp(0.0, 1.0),
        );
        
        return Transform.scale(
          scale: value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: opacity * (1 - value)),
                width: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}

/// رسام الconfetti
class _ConfettiPainter extends CustomPainter {
  final double animationValue;

  _ConfettiPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    // ألوان مختلفة للconfetti
    final colors = [
      Colors.white.withValues(alpha: 0.8),
      Colors.yellow.withValues(alpha: 0.6),
      Colors.orange.withValues(alpha: 0.6),
      Colors.pink.withValues(alpha: 0.6),
    ];
    
    // رسم جزيئات متحركة
    for (int i = 0; i < 20; i++) {
      final progress = (animationValue + i * 0.1) % 1.0;
      final x = (size.width * 0.1) + (i % 4) * (size.width * 0.2) + 
                (progress * 50 - 25);
      final y = progress * size.height;
      final colorIndex = i % colors.length;
      
      paint.color = colors[colorIndex];
      
      // رسم أشكال مختلفة
      if (i % 3 == 0) {
        // دوائر
        canvas.drawCircle(Offset(x, y), 3, paint);
      } else if (i % 3 == 1) {
        // مربعات
        canvas.drawRect(
          Rect.fromCenter(center: Offset(x, y), width: 6, height: 6),
          paint,
        );
      } else {
        // نجوم صغيرة
        _drawStar(canvas, Offset(x, y), 4, paint);
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
      
      final outerX = center.dx + radius * 0.8 * (outerAngle.cos());
      final outerY = center.dy + radius * 0.8 * (outerAngle.sin());
      
      final innerX = center.dx + radius * 0.4 * (innerAngle.cos());
      final innerY = center.dy + radius * 0.4 * (innerAngle.sin());
      
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Extension للحصول على cos و sin
extension DoubleExtension on double {
  double cos() => math.cos(this);
  double sin() => math.sin(this);
}