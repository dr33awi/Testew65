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
  bool _hasVibratedForQibla = false;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: ThemeConstants.durationSlow,
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: ThemeConstants.curveDefault,
    ));

    _previousDirection = widget.currentDirection;
  }

  @override
  void didUpdateWidget(QiblaCompass oldWidget) {
    super.didUpdateWidget(oldWidget);

    if ((widget.currentDirection - _previousDirection).abs() > 1) {
      _previousDirection = oldWidget.currentDirection;
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
    final relativeAngle = (widget.qiblaDirection - widget.currentDirection + 360) % 360;

    // Haptic Feedback Logic
    final angleDifference = (relativeAngle > 180 ? 360 - relativeAngle : relativeAngle).abs();
    if (angleDifference < 5 && !_hasVibratedForQibla) {
      HapticFeedback.lightImpact();
      _hasVibratedForQibla = true;
    } else if (angleDifference >= 5 && _hasVibratedForQibla) {
      _hasVibratedForQibla = false;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);

        return Stack(
          alignment: Alignment.center,
          children: [
            // Accuracy Indicator Pulse
            if (widget.accuracy < 0.8)
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Container(
                    width: size * (1.0 - (0.2 * (1 - widget.accuracy)) + _pulseAnimation.value * 0.05),
                    height: size * (1.0 - (0.2 * (1 - widget.accuracy)) + _pulseAnimation.value * 0.05),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ThemeConstants.warning.withValues(
                          alpha: ThemeConstants.opacity30 - _pulseAnimation.value * ThemeConstants.opacity20
                        ),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),

            // Compass Background
            Container(
              width: size * 0.9,
              height: size * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    context.cardColor,
                    context.cardColor.darken(0.05),
                    context.cardColor.darken(0.1),
                  ],
                  stops: const [0.5, 0.8, 1.0],
                ),
                boxShadow: ThemeConstants.shadowLg,
              ),
            ),

            // Rotatable Compass Dial
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
                        // Compass markings
                        CustomPaint(
                          size: Size(size, size),
                          painter: EnhancedCompassPainter(
                            accuracy: widget.accuracy,
                            isDarkMode: context.isDarkMode,
                          ),
                        ),

                        // Direction labels
                        _buildDirectionLabels(size, context),
                      ],
                    ),
                  ),
                );
              },
            ),

            // Qibla Indicator Arrow
            Transform.rotate(
              angle: relativeAngle * (math.pi / 180),
              child: SizedBox(
                width: size * 0.8,
                height: size * 0.8,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    // Qibla Arrow
                    Positioned(
                      top: 0,
                      child: TweenAnimationBuilder<double>(
                        duration: ThemeConstants.durationFast,
                        tween: Tween(begin: 0.9, end: 1.0),
                        curve: ThemeConstants.curveSmooth,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            alignment: Alignment.topCenter,
                            child: SizedBox(
                              width: 60,
                              height: size * 0.4,
                              child: CustomPaint(
                                painter: QiblaArrowPainter(
                                  color: context.primaryColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // "Qibla" text label
                    Positioned(
                      top: size * 0.1,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ThemeConstants.space3,
                          vertical: ThemeConstants.space1,
                        ),
                        decoration: BoxDecoration(
                          color: context.primaryColor,
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                        ),
                        child: Text(
                          'قبلة',
                          style: context.bodySmall?.copyWith(
                            color: context.primaryColor.contrastingTextColor,
                            fontWeight: ThemeConstants.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Center Dot
            Container(
              width: ThemeConstants.iconMd,
              height: ThemeConstants.iconMd,
              decoration: BoxDecoration(
                color: context.primaryColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: context.cardColor,
                  width: ThemeConstants.borderMedium,
                ),
                boxShadow: ThemeConstants.shadowMd,
              ),
            ),

            // Device Orientation Indicator
            Positioned(
              top: (constraints.maxHeight - size) / 2 + size * 0.05,
              child: Container(
                width: 0,
                height: 0,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 10, color: Colors.transparent),
                    right: BorderSide(width: 10, color: Colors.transparent),
                    bottom: BorderSide(width: 20, color: ThemeConstants.error),
                  ),
                ),
              ),
            ),

            // Current Angle and Accuracy Info
            Positioned(
              bottom: (constraints.maxHeight - size) / 2 + ThemeConstants.space4,
              child: Column(
                children: [
                  // Current Angle Display
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ThemeConstants.space4,
                      vertical: ThemeConstants.space2,
                    ),
                    decoration: BoxDecoration(
                      color: context.cardColor.withValues(alpha: ThemeConstants.opacity90),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                      border: Border.all(
                        color: context.primaryColor.withValues(alpha: ThemeConstants.opacity30),
                      ),
                      boxShadow: ThemeConstants.shadowSm,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.screen_rotation_alt,
                          size: ThemeConstants.iconMd,
                          color: context.primaryColor,
                        ),
                        ThemeConstants.space2.w,
                        Text(
                          '${widget.currentDirection.toStringAsFixed(1)}°',
                          style: context.titleLarge?.copyWith(
                            fontWeight: ThemeConstants.bold,
                            color: context.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  ThemeConstants.space2.h,

                  // Accuracy Indicator
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ThemeConstants.space3,
                      vertical: ThemeConstants.space1,
                    ),
                    decoration: BoxDecoration(
                      color: _getAccuracyColor(widget.accuracy).withValues(alpha: ThemeConstants.opacity20),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      border: Border.all(
                        color: _getAccuracyColor(widget.accuracy).withValues(alpha: ThemeConstants.opacity50),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getAccuracyIcon(widget.accuracy),
                          size: ThemeConstants.iconSm,
                          color: _getAccuracyColor(widget.accuracy),
                        ),
                        ThemeConstants.space1.w,
                        Text(
                          _getAccuracyText(widget.accuracy),
                          style: context.bodySmall?.copyWith(
                            color: _getAccuracyColor(widget.accuracy),
                            fontWeight: ThemeConstants.medium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
          // Main directions (N, E, S, W)
          _buildDirectionLabel('N', Alignment.topCenter, context, size, true),
          _buildDirectionLabel('E', Alignment.centerRight, context, size, true),
          _buildDirectionLabel('S', Alignment.bottomCenter, context, size, true),
          _buildDirectionLabel('W', Alignment.centerLeft, context, size, true),

          // Secondary directions (NE, SE, SW, NW)
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
                ? ThemeConstants.error.withValues(alpha: ThemeConstants.opacity10)
                : Colors.transparent,
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: text == 'N'
                    ? ThemeConstants.error
                    : isMainDirection
                        ? context.textSecondaryColor
                        : context.textSecondaryColor.withValues(alpha: ThemeConstants.opacity70),
                fontSize: isMainDirection ? ThemeConstants.textSizeMd : ThemeConstants.textSizeSm,
                fontWeight: isMainDirection ? ThemeConstants.bold : ThemeConstants.regular,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) return ThemeConstants.success;
    if (accuracy >= 0.5) return ThemeConstants.warning;
    return ThemeConstants.error;
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
    double diff = b - a;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return (a + diff * t + 360) % 360;
  }
}

// Custom Painter for the Compass Dial
class EnhancedCompassPainter extends CustomPainter {
  final double accuracy;
  final bool isDarkMode;

  EnhancedCompassPainter({this.accuracy = 1.0, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Adjust colors based on accuracy and theme
    final primaryLineColor = Color.lerp(
      ThemeConstants.error.withValues(alpha: ThemeConstants.opacity50),
      isDarkMode ? ThemeConstants.darkDivider : ThemeConstants.lightDivider,
      accuracy,
    )!;

    final secondaryLineColor = Color.lerp(
      ThemeConstants.error.withValues(alpha: ThemeConstants.opacity30),
      isDarkMode 
          ? ThemeConstants.darkTextSecondary.withValues(alpha: ThemeConstants.opacity30)
          : ThemeConstants.lightTextSecondary.withValues(alpha: ThemeConstants.opacity30),
      accuracy,
    )!;

    // Draw main circles
    final circlePaint = Paint()
      ..color = primaryLineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius - 2, circlePaint);
    canvas.drawCircle(center, radius * 0.85, circlePaint..strokeWidth = 1);

    // Draw markings (lines for degrees)
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
          ..color = primaryLineColor
          ..strokeWidth = 2.5;
      } else if (isMediumDirection) {
        lineLength = 18;
        linePaint = Paint()
          ..color = primaryLineColor.withValues(alpha: ThemeConstants.opacity70)
          ..strokeWidth = 1.5;
      } else if (isMinorDirection) {
        lineLength = 12;
        linePaint = Paint()
          ..color = secondaryLineColor
          ..strokeWidth = 1;
      } else {
        lineLength = 8;
        linePaint = Paint()
          ..color = secondaryLineColor.withValues(alpha: ThemeConstants.opacity50)
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
  }

  @override
  bool shouldRepaint(covariant EnhancedCompassPainter oldDelegate) {
    return oldDelegate.accuracy != accuracy || oldDelegate.isDarkMode != isDarkMode;
  }
}

// Custom Painter for the Qibla Arrow
class QiblaArrowPainter extends CustomPainter {
  final Color color;

  QiblaArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Simple shadow effect
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: ThemeConstants.opacity20)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final path = Path();

    // Draw the main arrow shape
    path.moveTo(size.width / 2, 0);
    path.lineTo(size.width * 0.7, size.height * 0.4);
    path.lineTo(size.width * 0.6, size.height * 0.4);
    path.lineTo(size.width * 0.6, size.height * 0.8);
    path.lineTo(size.width * 0.4, size.height * 0.8);
    path.lineTo(size.width * 0.4, size.height * 0.4);
    path.lineTo(size.width * 0.3, size.height * 0.4);
    path.close();

    // Apply shadow
    canvas.save();
    canvas.translate(0, 2);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // Draw the arrow
    canvas.drawPath(path, paint);

    // Add a subtle gradient for a glossy effect
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: ThemeConstants.opacity30),
          Colors.white.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.4));

    canvas.drawPath(path, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}