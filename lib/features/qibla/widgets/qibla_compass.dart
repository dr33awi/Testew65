// lib/features/qibla/widgets/qibla_compass.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';

class QiblaCompass extends StatefulWidget {
  final double qiblaDirection; // اتجاه القبلة (درجات من الشمال الحقيقي)
  final double currentDirection; // الاتجاه الحالي للجهاز (درجات من الشمال المغناطيسي)
  final double accuracy; // دقة البوصلة (0.0 - 1.0)
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
  late AnimationController _qiblaFoundController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _qiblaFoundAnimation;

  double _previousDirection = 0;
  bool _hasVibratedForQibla = false;
  bool _isNearQibla = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _previousDirection = widget.currentDirection;
  }

  void _setupAnimations() {
    _rotationController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _qiblaFoundController = AnimationController(
      duration: ThemeConstants.durationSlow,
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _qiblaFoundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _qiblaFoundController,
      curve: ThemeConstants.curveSmooth,
    ));
  }

  @override
  void didUpdateWidget(QiblaCompass oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Smoothly animate rotation to new direction
    if ((widget.currentDirection - _previousDirection).abs() > 1) {
      _previousDirection = oldWidget.currentDirection;
      _rotationController.forward(from: 0);
    }

    // Check if near Qibla and handle animations
    final relativeAngle = (widget.qiblaDirection - widget.currentDirection + 360) % 360;
    final angleDifference = (relativeAngle > 180 ? 360 - relativeAngle : relativeAngle).abs();
    _isNearQibla = angleDifference < 10;

    // Haptic feedback when finding Qibla
    if (_isNearQibla && !_hasVibratedForQibla) {
      HapticFeedback.lightImpact();
      _qiblaFoundController.forward();
      _hasVibratedForQibla = true;
    } else if (!_isNearQibla && _hasVibratedForQibla) {
      _hasVibratedForQibla = false;
      _qiblaFoundController.reverse();
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _qiblaFoundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final relativeAngle = (widget.qiblaDirection - widget.currentDirection + 360) % 360;
    final angleDifference = (relativeAngle > 180 ? 360 - relativeAngle : relativeAngle).abs();

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);

        return Stack(
          alignment: Alignment.center,
          children: [
            // خلفية بسيطة بدون حركة
            _buildStaticBackground(size, context),
            
            // حاوية البوصلة الرئيسية
            _buildCompassContainer(size, context, relativeAngle, angleDifference),
            
            // معلومات الدقة والحالة
            _buildStatusInfo(context, size, angleDifference),
          ],
        );
      },
    );
  }

  Widget _buildStaticBackground(double size, BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            context.primaryColor.withValues(alpha: 0.05),
            context.primaryColor.withValues(alpha: 0.02),
            Colors.transparent,
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
      ),
      child: CustomPaint(
        painter: SimpleBackgroundPainter(
          accuracy: widget.accuracy,
          isNearQibla: _isNearQibla,
          primaryColor: context.primaryColor,
        ),
      ),
    );
  }

  Widget _buildCompassContainer(double size, BuildContext context, double relativeAngle, double angleDifference) {
    return Container(
      width: size * 0.9,
      height: size * 0.9,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            context.cardColor,
            context.cardColor.withValues(alpha: 0.95),
            context.cardColor.withValues(alpha: 0.8),
          ],
          stops: const [0.0, 0.8, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: context.primaryColor.withValues(alpha: 0.2),
                width: 2,
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // البوصلة الدوارة
                _buildRotatingCompass(size, context),
                
                // مؤشر القبلة
                _buildQiblaIndicator(size, context, relativeAngle, angleDifference),
                
                // مؤشر اتجاه الجهاز
                _buildDeviceIndicator(size, context),
                
                // النقطة المركزية
                _buildCenterDot(context, angleDifference),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRotatingCompass(double size, BuildContext context) {
    return AnimatedBuilder(
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
            width: size * 0.85,
            height: size * 0.85,
            child: Stack(
              children: [
                // علامات البوصلة
                CustomPaint(
                  size: Size(size * 0.85, size * 0.85),
                  painter: CleanCompassPainter(
                    accuracy: widget.accuracy,
                    isDarkMode: context.isDarkMode,
                    primaryColor: context.primaryColor,
                    textColor: context.textPrimaryColor,
                    secondaryColor: context.textSecondaryColor,
                  ),
                ),

                // تسميات الاتجاهات
                _buildDirectionLabels(size * 0.85, context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQiblaIndicator(double size, BuildContext context, double relativeAngle, double angleDifference) {
    return AnimatedBuilder(
      animation: Listenable.merge([_qiblaFoundAnimation, _pulseAnimation]),
      builder: (context, child) {
        final isAccurate = angleDifference < 5;
        final scale = isAccurate ? 1.0 + (_qiblaFoundAnimation.value * 0.1) : 1.0;

        return Transform.rotate(
          angle: relativeAngle * (math.pi / 180),
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: size * 0.8,
              height: size * 0.8,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // سهم القبلة الرئيسي
                  Positioned(
                    top: 0,
                    child: Container(
                      width: 60,
                      height: size * 0.35,
                      child: CustomPaint(
                        painter: CleanQiblaArrowPainter(
                          color: isAccurate ? ThemeConstants.success : context.primaryColor,
                          isAccurate: isAccurate,
                          glowIntensity: isAccurate ? _qiblaFoundAnimation.value : 0.0,
                        ),
                      ),
                    ),
                  ),

                  // تسمية القبلة
                  Positioned(
                    top: size * 0.08,
                    child: AnimatedContainer(
                      duration: ThemeConstants.durationNormal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.space3,
                        vertical: ThemeConstants.space1,
                      ),
                      decoration: BoxDecoration(
                        color: (isAccurate ? ThemeConstants.success : context.primaryColor).withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                        boxShadow: [
                          BoxShadow(
                            color: (isAccurate ? ThemeConstants.success : context.primaryColor).withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.mosque,
                            color: Colors.white,
                            size: ThemeConstants.iconSm,
                          ),
                          ThemeConstants.space1.w,
                          Text(
                            'القبلة',
                            style: context.labelMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: ThemeConstants.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // مؤشر المسافة الزاوية
                  if (angleDifference < 30)
                    Positioned(
                      top: size * 0.15,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ThemeConstants.space2,
                          vertical: ThemeConstants.space1,
                        ),
                        decoration: BoxDecoration(
                          color: context.cardColor.withValues(alpha: 0.95),
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                          border: Border.all(
                            color: (isAccurate ? ThemeConstants.success : context.primaryColor).withValues(alpha: 0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          '${angleDifference.toStringAsFixed(1)}°',
                          style: context.labelSmall?.copyWith(
                            color: isAccurate ? ThemeConstants.success : context.primaryColor,
                            fontWeight: ThemeConstants.semiBold,
                          ),
                        ),
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

  Widget _buildDeviceIndicator(double size, BuildContext context) {
    return Positioned(
      top: size * 0.02,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 10,
                  color: Colors.transparent,
                ),
                right: BorderSide(
                  width: 10,
                  color: Colors.transparent,
                ),
                bottom: BorderSide(
                  width: 20,
                  color: ThemeConstants.error.withValues(alpha: 0.8),
                ),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 25),
              child: Text(
                'الجهاز',
                style: context.labelSmall?.copyWith(
                  color: ThemeConstants.error,
                  fontWeight: ThemeConstants.semiBold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCenterDot(BuildContext context, double angleDifference) {
    return AnimatedBuilder(
      animation: _qiblaFoundAnimation,
      builder: (context, child) {
        final isAccurate = angleDifference < 5;
        final centerColor = isAccurate 
            ? Color.lerp(context.primaryColor, ThemeConstants.success, _qiblaFoundAnimation.value)!
            : context.primaryColor;

        return Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                centerColor,
                centerColor.darken(0.2),
              ],
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: context.cardColor,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: centerColor.withValues(alpha: 0.4),
                blurRadius: isAccurate ? 15 : 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: isAccurate 
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 14,
                )
              : null,
        );
      },
    );
  }

  Widget _buildStatusInfo(BuildContext context, double size, double angleDifference) {
    return Positioned(
      bottom: 0,
      child: Column(
        children: [
          // معلومات الاتجاه الحالي
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space4,
              vertical: ThemeConstants.space3,
            ),
            decoration: BoxDecoration(
              color: context.cardColor.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              border: Border.all(
                color: context.primaryColor.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.navigation,
                  color: context.primaryColor,
                  size: ThemeConstants.iconMd,
                ),
                ThemeConstants.space3.w,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.currentDirection.toStringAsFixed(1)}°',
                      style: context.titleMedium?.copyWith(
                        fontWeight: ThemeConstants.bold,
                        color: context.textPrimaryColor,
                      ),
                    ),
                    Text(
                      _getCompassDirection(widget.currentDirection),
                      style: context.labelMedium?.copyWith(
                        color: context.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          ThemeConstants.space3.h,

          // مؤشر الدقة
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildAccuracyChip(context),
              if (!widget.isCalibrated) ...[
                ThemeConstants.space2.w,
                _buildCalibrationChip(context),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyChip(BuildContext context) {
    final accuracyColor = _getAccuracyColor(widget.accuracy);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space3,
        vertical: ThemeConstants.space2,
      ),
      decoration: BoxDecoration(
        color: accuracyColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
        border: Border.all(
          color: accuracyColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getAccuracyIcon(widget.accuracy),
            size: ThemeConstants.iconSm,
            color: accuracyColor,
          ),
          ThemeConstants.space2.w,
          Text(
            _getAccuracyText(widget.accuracy),
            style: context.labelMedium?.copyWith(
              color: accuracyColor,
              fontWeight: ThemeConstants.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalibrationChip(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onCalibrate?.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space3,
          vertical: ThemeConstants.space2,
        ),
        decoration: BoxDecoration(
          color: ThemeConstants.warning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
          border: Border.all(
            color: ThemeConstants.warning.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.compass_calibration,
              size: ThemeConstants.iconSm,
              color: ThemeConstants.warning,
            ),
            ThemeConstants.space2.w,
            Text(
              'معايرة',
              style: context.labelMedium?.copyWith(
                color: ThemeConstants.warning,
                fontWeight: ThemeConstants.semiBold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionLabels(double size, BuildContext context) {
    final directions = [
      {'text': 'ش', 'angle': 0.0, 'isMain': true, 'color': ThemeConstants.error}, // شمال
      {'text': 'ق', 'angle': 90.0, 'isMain': true, 'color': context.textPrimaryColor}, // شرق
      {'text': 'ج', 'angle': 180.0, 'isMain': true, 'color': context.textPrimaryColor}, // جنوب
      {'text': 'غ', 'angle': 270.0, 'isMain': true, 'color': context.textPrimaryColor}, // غرب
      {'text': 'ش ق', 'angle': 45.0, 'isMain': false, 'color': context.textSecondaryColor},
      {'text': 'ج ق', 'angle': 135.0, 'isMain': false, 'color': context.textSecondaryColor},
      {'text': 'ج غ', 'angle': 225.0, 'isMain': false, 'color': context.textSecondaryColor},
      {'text': 'ش غ', 'angle': 315.0, 'isMain': false, 'color': context.textSecondaryColor},
    ];

    return Stack(
      children: directions.map((direction) {
        final angle = direction['angle'] as double;
        final isMain = direction['isMain'] as bool;
        final text = direction['text'] as String;
        final color = direction['color'] as Color;

        final radians = (angle - 90) * (math.pi / 180);
        final radius = size * 0.35;
        final x = radius * math.cos(radians);
        final y = radius * math.sin(radians);

        return Transform.translate(
          offset: Offset(x, y),
          child: Container(
            width: isMain ? 40 : 35,
            height: isMain ? 40 : 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: angle == 0 
                  ? ThemeConstants.error.withValues(alpha: 0.1)
                  : isMain 
                      ? context.primaryColor.withValues(alpha: 0.1)
                      : Colors.transparent,
              border: angle == 0 || isMain 
                  ? Border.all(
                      color: color.withValues(alpha: 0.3),
                      width: 1.5,
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: color.withValues(alpha: isMain ? 1.0 : 0.8),
                  fontSize: isMain ? 16 : 14,
                  fontWeight: isMain ? FontWeight.bold : FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // دوال مساعدة
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

  String _getCompassDirection(double direction) {
    if (direction >= 337.5 || direction < 22.5) return 'شمال';
    if (direction >= 22.5 && direction < 67.5) return 'شمال شرق';
    if (direction >= 67.5 && direction < 112.5) return 'شرق';
    if (direction >= 112.5 && direction < 157.5) return 'جنوب شرق';
    if (direction >= 157.5 && direction < 202.5) return 'جنوب';
    if (direction >= 202.5 && direction < 247.5) return 'جنوب غرب';
    if (direction >= 247.5 && direction < 292.5) return 'غرب';
    return 'شمال غرب';
  }

  double _lerp(double a, double b, double t) {
    double diff = b - a;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return (a + diff * t + 360) % 360;
  }
}

/// رسام خلفية بسيط بدون حركة
class SimpleBackgroundPainter extends CustomPainter {
  final double accuracy;
  final bool isNearQibla;
  final Color primaryColor;

  SimpleBackgroundPainter({
    required this.accuracy,
    required this.isNearQibla,
    required this.primaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // رسم دوائر ثابتة للدقة
    _drawAccuracyRings(canvas, center, radius);

    // رسم دائرة النجاح عند العثور على القبلة
    if (isNearQibla) {
      _drawSuccessRing(canvas, center, radius);
    }
  }

  void _drawAccuracyRings(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final accuracyColor = Color.lerp(
      Colors.red,
      primaryColor,
      accuracy,
    )!;

    // رسم 3 دوائر ثابتة
    for (int i = 0; i < 3; i++) {
      final ringRadius = radius * (0.3 + i * 0.15);
      final alpha = (1 - i * 0.3) * 0.2 * accuracy;
      
      paint.color = accuracyColor.withValues(alpha: alpha.clamp(0.0, 1.0));
      canvas.drawCircle(center, ringRadius, paint);
    }
  }

  void _drawSuccessRing(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = ThemeConstants.success.withValues(alpha: 0.3);

    canvas.drawCircle(center, radius * 0.4, paint);
  }

  @override
  bool shouldRepaint(covariant SimpleBackgroundPainter oldDelegate) {
    return oldDelegate.accuracy != accuracy || 
           oldDelegate.isNearQibla != isNearQibla;
  }
}

/// رسام البوصلة المبسط
class CleanCompassPainter extends CustomPainter {
  final double accuracy;
  final bool isDarkMode;
  final Color primaryColor;
  final Color textColor;
  final Color secondaryColor;

  CleanCompassPainter({
    required this.accuracy,
    required this.isDarkMode,
    required this.primaryColor,
    required this.textColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // رسم الدوائر الرئيسية
    _drawMainCircles(canvas, center, radius);

    // رسم علامات الدرجات
    _drawDegreeMarks(canvas, center, radius);
  }

  void _drawMainCircles(Canvas canvas, Offset center, double radius) {
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke;

    // الدائرة الخارجية
    circlePaint
      ..color = primaryColor.withValues(alpha: 0.2)
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius - 2, circlePaint);

    // الدائرة الداخلية
    circlePaint
      ..color = secondaryColor.withValues(alpha: 0.1)
      ..strokeWidth = 0.5;
    canvas.drawCircle(center, radius * 0.7, circlePaint);
  }

  void _drawDegreeMarks(Canvas canvas, Offset center, double radius) {
    for (int i = 0; i < 360; i += 5) {
      final angle = i * (math.pi / 180);
      final isMainDirection = i % 90 == 0;
      final isMediumDirection = i % 30 == 0;

      Paint linePaint;
      double lineLength;

      if (isMainDirection) {
        lineLength = 25;
        linePaint = Paint()
          ..color = i == 0 ? ThemeConstants.error : primaryColor
          ..strokeWidth = 2;
      } else if (isMediumDirection) {
        lineLength = 15;
        linePaint = Paint()
          ..color = primaryColor.withValues(alpha: 0.6)
          ..strokeWidth = 1;
      } else {
        lineLength = 8;
        linePaint = Paint()
          ..color = secondaryColor.withValues(alpha: 0.4)
          ..strokeWidth = 0.5;
      }

      final startRadius = radius - lineLength - 3;
      final endRadius = radius - 3;

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
  bool shouldRepaint(covariant CleanCompassPainter oldDelegate) {
    return oldDelegate.accuracy != accuracy || 
           oldDelegate.isDarkMode != isDarkMode ||
           oldDelegate.primaryColor != primaryColor;
  }
}

/// رسام سهم القبلة المبسط
class CleanQiblaArrowPainter extends CustomPainter {
  final Color color;
  final bool isAccurate;
  final double glowIntensity;

  CleanQiblaArrowPainter({
    required this.color,
    required this.isAccurate,
    required this.glowIntensity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // رسم التوهج عند الدقة العالية
    if (isAccurate && glowIntensity > 0) {
      _drawGlow(canvas, size);
    }

    // رسم السهم الرئيسي
    _drawMainArrow(canvas, size);
  }

  void _drawGlow(Canvas canvas, Size size) {
    final path = _createArrowPath(size);
    final glowPaint = Paint()
      ..color = color.withValues(alpha: glowIntensity * 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawPath(path, glowPaint);
  }

  void _drawMainArrow(Canvas canvas, Size size) {
    final path = _createArrowPath(size);

    // الخلفية الرئيسية
    final mainPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color,
          color.darken(0.2),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, mainPaint);

    // الحدود
    final borderPaint = Paint()
      ..color = color.darken(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawPath(path, borderPaint);

    // نقطة مضيئة في الأعلى
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9);

    canvas.drawCircle(
      Offset(size.width / 2, size.height * 0.15),
      2,
      dotPaint,
    );
  }

  Path _createArrowPath(Size size) {
    final path = Path();
    final centerX = size.width / 2;

    // شكل السهم
    path.moveTo(centerX, 0); // رأس السهم
    path.lineTo(size.width * 0.7, size.height * 0.3); // الجناح الأيمن
    path.lineTo(size.width * 0.6, size.height * 0.3); // دخول داخلي أيمن
    path.lineTo(size.width * 0.6, size.height * 0.8); // جانب أيمن طويل
    path.lineTo(size.width * 0.4, size.height * 0.8); // جانب أيسر طويل
    path.lineTo(size.width * 0.4, size.height * 0.3); // دخول داخلي أيسر
    path.lineTo(size.width * 0.3, size.height * 0.3); // الجناح الأيسر
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant CleanQiblaArrowPainter oldDelegate) {
    return oldDelegate.color != color ||
           oldDelegate.isAccurate != isAccurate ||
           oldDelegate.glowIntensity != glowIntensity;
  }
}