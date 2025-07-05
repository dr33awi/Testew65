// lib/features/tasbih/widgets/tasbih_counter_ring.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

/// ويدجت الحلقة الدائرية لعرض التقدم
class TasbihCounterRing extends StatefulWidget {
  final double progress;
  final List<Color> gradient;
  final double strokeWidth;

  const TasbihCounterRing({
    super.key,
    required this.progress,
    required this.gradient,
    this.strokeWidth = 8.0,
  });

  @override
  State<TasbihCounterRing> createState() => _TasbihCounterRingState();
}

class _TasbihCounterRingState extends State<TasbihCounterRing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    
    _controller.forward();
  }

  @override
  void didUpdateWidget(TasbihCounterRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _CounterRingPainter(
            progress: _animation.value,
            gradient: widget.gradient,
            strokeWidth: widget.strokeWidth,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _CounterRingPainter extends CustomPainter {
  final double progress;
  final List<Color> gradient;
  final double strokeWidth;

  _CounterRingPainter({
    required this.progress,
    required this.gradient,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // رسم الحلقة الخلفية
    final backgroundPaint = Paint()
      ..color = gradient[0].withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // رسم حلقة التقدم
    if (progress > 0) {
      final progressPaint = Paint()
        ..shader = LinearGradient(
          colors: gradient,
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      const startAngle = -math.pi / 2; // البداية من الأعلى
      final sweepAngle = 2 * math.pi * progress;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        progressPaint,
      );

      // رسم نقطة في نهاية الخط
      if (progress < 1.0) {
        final endAngle = startAngle + sweepAngle;
        final endX = center.dx + radius * math.cos(endAngle);
        final endY = center.dy + radius * math.sin(endAngle);
        
        final dotPaint = Paint()
          ..color = gradient.last
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(
          Offset(endX, endY),
          strokeWidth / 2 + 2,
          dotPaint,
        );
        
        // هالة حول النقطة
        final haloPaint = Paint()
          ..color = gradient.last.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill;
        
        canvas.drawCircle(
          Offset(endX, endY),
          strokeWidth / 2 + 6,
          haloPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _CounterRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
           oldDelegate.gradient != gradient ||
           oldDelegate.strokeWidth != strokeWidth;
  }
}