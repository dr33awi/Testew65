// lib/features/tasbih/widgets/tasbih_counter_widget.dart

import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../app/themes/index.dart';

class TasbihCounterWidget extends StatelessWidget {
  final int count;
  final double setProgress;
  final int completedSets;
  final int remainingInSet;
  final Animation<double> scaleAnimation;
  final Animation<double> rippleAnimation;
  final VoidCallback onTap;

  const TasbihCounterWidget({
    super.key,
    required this.count,
    required this.setProgress,
    required this.completedSets,
    required this.remainingInSet,
    required this.scaleAnimation,
    required this.rippleAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // تأثير الموجات
          AnimatedBuilder(
            animation: rippleAnimation,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(280, 280),
                painter: RipplePainter(
                  animation: rippleAnimation,
                  color: context.primaryColor,
                ),
              );
            },
          ),
          
          // الحلقة الخارجية للتقدم
          SizedBox(
            width: 260,
            height: 260,
            child: CustomPaint(
              painter: ProgressRingPainter(
                progress: setProgress,
                backgroundColor: context.borderColor.withValues(alpha: 0.2),
                progressColor: context.primaryColor,
                strokeWidth: 8,
              ),
            ),
          ),
          
          // الحلقة الداخلية
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  context.cardColor,
                  context.surfaceColor,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: context.primaryColor.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          
          // العداد الرئيسي
          AnimatedBuilder(
            animation: scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: scaleAnimation.value,
                child: GestureDetector(
                  onTap: onTap,
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          context.primaryColor.lighten(0.1),
                          context.primaryColor,
                          context.primaryColor.darken(0.1),
                        ],
                        stops: const [0.0, 0.7, 1.0],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: context.primaryColor.withValues(alpha: 0.4),
                          blurRadius: 15,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // العدد الرئيسي
                        Text(
                          count.toString(),
                          style: AppTypography.counter.copyWith(
                            color: Colors.white,
                            fontSize: _getCounterFontSize(count),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        
                        // النص التوضيحي
                        if (count > 0) ...[
                          const SizedBox(height: 4),
                          Text(
                            _getCounterLabel(count),
                            style: context.captionStyle.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          
          // معلومات الأطقم
          Positioned(
            bottom: 20,
            child: _buildSetsInfo(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSetsInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.borderColor.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // الأطقم المكتملة
          _buildSetInfo(
            context,
            'أطقم مكتملة',
            completedSets.toString(),
            Icons.check_circle,
            context.successColor,
          ),
          
          if (count > 0) ...[
            Container(
              width: 1,
              height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: context.borderColor.withValues(alpha: 0.3),
            ),
            
            // المتبقي في الطقم
            _buildSetInfo(
              context,
              'متبقي',
              remainingInSet.toString(),
              Icons.radio_button_unchecked,
              context.primaryColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSetInfo(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: color,
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: context.bodyStyle.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        Text(
          label,
          style: context.captionStyle.copyWith(
            fontSize: 10,
            color: context.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  double _getCounterFontSize(int count) {
    if (count < 10) return 48;
    if (count < 100) return 42;
    if (count < 1000) return 36;
    return 30;
  }

  String _getCounterLabel(int count) {
    if (count == 1) return 'تسبيحة';
    if (count < 11) return 'تسبيحات';
    return 'تسبيحة';
  }
}

/// رسام الحلقة المتقدمة
class ProgressRingPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  ProgressRingPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - strokeWidth / 2;

    // رسم الخلفية
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // رسم التقدم
    if (progress > 0) {
      final progressPaint = Paint()
        ..shader = LinearGradient(
          colors: [
            progressColor.lighten(0.2),
            progressColor,
            progressColor.darken(0.1),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final sweepAngle = 2 * math.pi * progress;
      const startAngle = -math.pi / 2; // البداية من الأعلى

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}

/// رسام تأثير الموجات
class RipplePainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;

  RipplePainter({
    required this.animation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (animation.value == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = size.width / 2;

    for (int i = 0; i < 3; i++) {
      final progress = (animation.value + (i * 0.3)) % 1.0;
      final radius = maxRadius * progress;
      final opacity = (1.0 - progress) * 0.3;

      if (opacity > 0) {
        final paint = Paint()
          ..color = color.withValues(alpha: opacity)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

        canvas.drawCircle(center, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}