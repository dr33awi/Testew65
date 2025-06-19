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
  final VoidCallback? onReread;
  final VoidCallback? onClose;

  const AthkarCompletionDialog({
    super.key,
    required this.categoryName,
    this.onShare,
    this.onReread,
    this.onClose,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String categoryName,
    VoidCallback? onShare,
    VoidCallback? onReread,
    VoidCallback? onClose,
  }) async {
    HapticFeedback.mediumImpact();
    
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AthkarCompletionDialog(
        categoryName: categoryName,
        onShare: onShare,
        onReread: onReread,
        onClose: onClose,
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
                constraints: const BoxConstraints(maxWidth: 350, maxHeight: 500),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
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
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
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
                            borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
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
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // الأيقونة المبسطة
          _buildSuccessIcon(),
          
          ThemeConstants.space3.h,
          
          // العنوان والرسالة
          _buildTitleSection(context),
          
          ThemeConstants.space3.h,
          
          // آية قرآنية
          _buildQuranVerse(context),
          
          ThemeConstants.space3.h,
          
          // الأزرار
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.3),
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
      child: const Icon(
        Icons.check_circle_rounded,
        color: Colors.white,
        size: 40,
      ),
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
                'بارك الله فيك 🎉',
                style: context.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              ThemeConstants.space2.h,
              
              Text(
                'أكملت ${widget.categoryName}\nجعله الله في ميزان حسناتك',
                style: context.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.semiBold,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuranVerse(BuildContext context) {
    return AnimationConfiguration.synchronized(
      duration: ThemeConstants.durationNormal,
      child: SlideAnimation(
        verticalOffset: 30,
        delay: const Duration(milliseconds: 400),
        child: FadeInAnimation(
          child: Column(
            children: [
              Text(
                '﴿ وَاذْكُر رَّبَّكَ كَثِيرًا وَسَبِّحْ بِالْعَشِيِّ وَالْإِبْكَارِ ﴾',
                style: context.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontFamily: ThemeConstants.fontFamilyArabic,
                  height: 1.8,
                ),
                textAlign: TextAlign.center,
              ),
              ThemeConstants.space1.h,
              Text(
                'سورة آل عمران - آية 41',
                style: context.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // الصف الأول: زر إعادة القراءة
        if (widget.onReread != null) ...[
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context, true);
                    widget.onReread?.call();
                  },
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: ThemeConstants.space3,
                      horizontal: ThemeConstants.space4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          color: ThemeConstants.success,
                          size: 24,
                        ),
                        ThemeConstants.space2.w,
                        Text(
                          'إعادة القراءة',
                          style: context.titleMedium?.copyWith(
                            color: ThemeConstants.success,
                            fontWeight: ThemeConstants.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          ThemeConstants.space3.h,
        ],
        
        // الصف الثاني: أزرار الإغلاق والمشاركة
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // زر المشاركة (إذا كان متاحاً)
            if (widget.onShare != null) ...[
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                    widget.onShare?.call();
                  },
                  icon: const Icon(
                    Icons.share_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  tooltip: 'مشاركة الإنجاز',
                ),
              ),
              
              ThemeConstants.space4.w,
            ],
            
            // زر الإغلاق والعودة لفئات الأذكار
            SizedBox(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context, false);
                      widget.onClose?.call();
                    },
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: ThemeConstants.space3,
                        horizontal: ThemeConstants.space4,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.home_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                          ThemeConstants.space2.w,
                          Text(
                            'العودة للأذكار',
                            style: context.titleSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: ThemeConstants.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
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