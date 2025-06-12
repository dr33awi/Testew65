// lib/features/qibla/widgets/qibla_compass.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';

class QiblaCompass extends StatefulWidget {
  final double qiblaDirection;
  final double currentDirection;
  final double accuracy;
  final bool isCalibrated;
  final VoidCallback? onCalibrate;

  const QiblaCompass({
    super.key,
    required this.qiblaDirection,
    required this.currentDirection,
    this.accuracy = 1.0,
    this.isCalibrated = true,
    this.onCalibrate,
  });

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  double _previousDirection = 0;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _previousDirection = widget.currentDirection;
  }

  @override
  void didUpdateWidget(QiblaCompass oldWidget) {
    super.didUpdateWidget(oldWidget);

    // تحديث سلس للاتجاه
    if ((widget.currentDirection - _previousDirection).abs() > 1) {
      _previousDirection = widget.currentDirection;
      _rotationController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // حساب زاوية القبلة النسبية
    final relativeAngle = (widget.qiblaDirection - widget.currentDirection + 360) % 360;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight) * 0.9;

        return Stack(
          alignment: Alignment.center,
          children: [
            // مؤشر الدقة
            if (widget.accuracy < 0.8)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: size * (1 + _pulseAnimation.value * 0.1),
                    height: size * (1 + _pulseAnimation.value * 0.1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.3 - _pulseAnimation.value * 0.3),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),

            // خلفية البوصلة
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    context.cardColor,
                    context.cardColor.withValues(alpha: 0.95),
                    context.cardColor.withValues(alpha: 0.9),
                  ],
                  stops: const [0.5, 0.8, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                  BoxShadow(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    blurRadius: 30,
                    spreadRadius: -5,
                  ),
                ],
              ),
            ),

            // البوصلة المتحركة
            AnimatedBuilder(
              animation: _rotationController,
              builder: (context, child) {
                final smoothDirection = _lerp(
                  _previousDirection,
                  widget.currentDirection,
                  _rotationController.value,
                );

                return Transform.rotate(
                  angle: -smoothDirection * (math.pi / 180),
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: Stack(
                      children: [
                        // خطوط البوصلة
                        CustomPaint(
                          size: Size(size, size),
                          painter: EnhancedCompassPainter(
                            accuracy: widget.accuracy,
                          ),
                        ),

                        // تسميات الاتجاهات
                        _buildDirectionLabels(size, context),
                      ],
                    ),
                  ),
                );
              },
            ),

            // مؤشر القبلة
            Transform.rotate(
              angle: relativeAngle * (math.pi / 180),
              child: SizedBox(
                width: size * 0.85,
                height: size * 0.85,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // سهم القبلة
                    Positioned(
                      top: 0,
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 300),
                        tween: Tween(begin: 0, end: 1),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: 0.9 + value * 0.1,
                            child: SizedBox(
                              width: 60,
                              height: 100,
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  // سهم القبلة
                                  CustomPaint(
                                    size: const Size(60, 60),
                                    painter: QiblaArrowPainter(
                                      color: context.primaryColor,
                                    ),
                                  ),
                                  // نص "قبلة"
                                  Positioned(
                                    top: 20,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: context.primaryColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Text(
                                        'قبلة',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // مركز البوصلة
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: context.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: context.primaryColor.withValues(alpha: 0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),

            // مؤشر اتجاه الجهاز
            Positioned(
              top: (constraints.maxHeight - size) / 2 - 10,
              child: Container(
                width: 0,
                height: 0,
                decoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 10, color: Colors.transparent),
                    right: BorderSide(width: 10, color: Colors.transparent),
                    bottom: BorderSide(width: 20, color: Colors.red),
                  ),
                ),
              ),
            ),

            // معلومات الزاوية والدقة
            Positioned(
              bottom: (constraints.maxHeight - size) / 2 + 20,
              child: Column(
                children: [
                  // زاوية القبلة
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: context.cardColor.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: context.primaryColor.withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.navigation,
                          size: 20,
                          color: context.primaryColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${relativeAngle.toStringAsFixed(1)}°',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // مؤشر الدقة
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getAccuracyColor(widget.accuracy).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getAccuracyColor(widget.accuracy).withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getAccuracyIcon(widget.accuracy),
                          size: 14,
                          color: _getAccuracyColor(widget.accuracy),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _getAccuracyText(widget.accuracy),
                          style: TextStyle(
                            fontSize: 12,
                            color: _getAccuracyColor(widget.accuracy),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // زر المعايرة
            if (!widget.isCalibrated && widget.onCalibrate != null)
              Positioned(
                top: 20,
                right: 20,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onCalibrate?.call();
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.orange.withValues(alpha: 0.5),
                        ),
                      ),
                      child: const Icon(
                        Icons.compass_calibration,
                        size: 20,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildDirectionLabels(double size, BuildContext context) {
    return Center(
      child: Stack(
        children: [
          _buildDirectionLabel('N', Alignment.topCenter, context, size, true),
          _buildDirectionLabel('E', Alignment.centerRight, context, size, true),
          _buildDirectionLabel('S', Alignment.bottomCenter, context, size, true),
          _buildDirectionLabel('W', Alignment.centerLeft, context, size, true),

          _buildDirectionLabel('NE', const Alignment(0.7, -0.7), context, size, false),
          _buildDirectionLabel('SE', const Alignment(0.7, 0.7), context, size, false),
          _buildDirectionLabel('SW', const Alignment(-0.7, 0.7), context, size, false),
          _buildDirectionLabel('NW', const Alignment(-0.7, -0.7), context, size, false),
        ],
      ),
    );
  }

  Widget _buildDirectionLabel(
    String text,
    Alignment alignment,
    BuildContext context,
    double size,
    bool isMainDirection,
  ) {
    return Align(
      alignment: alignment,
      child: Padding(
        padding: EdgeInsets.all(size * 0.08),
        child: Container(
          width: isMainDirection ? 30 : 25,
          height: isMainDirection ? 30 : 25,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: text == 'N'
                ? Colors.red.withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: text == 'N'
                    ? Colors.red
                    : isMainDirection
                        ? context.textSecondaryColor
                        : context.textSecondaryColor.withValues(alpha: 0.6),
                fontSize: isMainDirection ? 16 : 12,
                fontWeight: isMainDirection ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) return Colors.green;
    if (accuracy >= 0.5) return Colors.orange;
    return Colors.red;
  }

  IconData _getAccuracyIcon(double accuracy) {
    if (accuracy >= 0.8) return Icons.gps_fixed;
    if (accuracy >= 0.5) return Icons.gps_not_fixed;
    return Icons.gps_off;
  }

  String _getAccuracyText(double accuracy) {
    if (accuracy >= 0.8) return 'دقة عالية';
    if (accuracy >= 0.5) return 'دقة متوسطة';
    return 'دقة منخفضة';
  }

  double _lerp(double a, double b, double t) {
    // تعامل خاص مع الانتقال عبر 0/360
    double diff = b - a;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return (a + diff * t + 360) % 360;
  }
}

// رسام البوصلة المحسن
class EnhancedCompassPainter extends CustomPainter {
  final double accuracy;

  EnhancedCompassPainter({this.accuracy = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // تعديل الألوان بناءً على الدقة
    final primaryColor = Color.lerp(
      Colors.red.withValues(alpha: 0.3),
      Colors.grey.shade800,
      accuracy,
    )!;

    final secondaryColor = Color.lerp(
      Colors.red.withValues(alpha: 0.2),
      Colors.grey.shade400,
      accuracy,
    )!;

    // رسم الدوائر
    final circlePaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius - 2, circlePaint);

    // دائرة داخلية
    canvas.drawCircle(
      center,
      radius * 0.85,
      Paint()
        ..color = secondaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    // رسم خطوط الاتجاهات
    for (int i = 0; i < 360; i += 5) {
      final angle = i * (math.pi / 180);
      final isMainDirection = i % 90 == 0;
      final isMediumDirection = i % 45 == 0;
      final isMinorDirection = i % 15 == 0;

      Paint linePaint;
      double lineLength;

      if (isMainDirection) {
        lineLength = 25;
        linePaint = Paint()
          ..color = primaryColor
          ..strokeWidth = 2.5;
      } else if (isMediumDirection) {
        lineLength = 18;
        linePaint = Paint()
          ..color = primaryColor.withValues(alpha: 0.8)
          ..strokeWidth = 1.5;
      } else if (isMinorDirection) {
        lineLength = 12;
        linePaint = Paint()
          ..color = secondaryColor
          ..strokeWidth = 1;
      } else {
        lineLength = 8;
        linePaint = Paint()
          ..color = secondaryColor.withValues(alpha: 0.5)
          ..strokeWidth = 0.5;
      }

      final startRadius = radius - lineLength;
      final endRadius = radius - 2;

      final startPoint = Offset(
        center.dx + startRadius * math.cos(angle - math.pi / 2),
        center.dy + startRadius * math.sin(angle - math.pi / 2),
      );

      final endPoint = Offset(
        center.dx + endRadius * math.cos(angle - math.pi / 2),
        center.dy + endRadius * math.sin(angle - math.pi / 2),
      );

      canvas.drawLine(startPoint, endPoint, linePaint);
    }

    // رسم دائرة مركزية إضافية
    canvas.drawCircle(
      center,
      radius * 0.05,
      Paint()
        ..color = primaryColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(EnhancedCompassPainter oldDelegate) {
    return oldDelegate.accuracy != accuracy;
  }
}

// رسام سهم القبلة
class QiblaArrowPainter extends CustomPainter {
  final Color color;

  QiblaArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final path = Path();

    // رسم السهم
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width * 0.7, size.height * 0.4);
    path.lineTo(size.width * 0.6, size.height * 0.4);
    path.lineTo(size.width * 0.6, size.height * 0.8);
    path.lineTo(size.width * 0.4, size.height * 0.8);
    path.lineTo(size.width * 0.4, size.height * 0.4);
    path.lineTo(size.width * 0.3, size.height * 0.4);
    path.close();

    // رسم الظل
    canvas.save();
    canvas.translate(0, 2);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // رسم السهم
    canvas.drawPath(path, paint);

    // إضافة تأثير لامع
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.3),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.4));

    canvas.drawPath(path, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}