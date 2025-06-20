// lib/features/qibla/widgets/qibla_compass.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/index.dart';

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
    required this.accuracy,
    required this.isCalibrated,
    this.onCalibrate,
  });

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _accuracyController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _accuracyAnimation;
  
  double _lastDirection = 0;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _accuracyController = AnimationController(
      duration: ThemeConstants.durationSlow,
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _accuracyAnimation = Tween<double>(
      begin: 0,
      end: widget.accuracy,
    ).animate(CurvedAnimation(
      parent: _accuracyController,
      curve: Curves.easeOutCubic,
    ));
    
    _lastDirection = widget.currentDirection;
    _accuracyController.forward();
  }

  @override
  void didUpdateWidget(QiblaCompass oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (oldWidget.currentDirection != widget.currentDirection) {
      _lastDirection = oldWidget.currentDirection;
      _rotationController.forward(from: 0);
    }
    
    if (oldWidget.accuracy != widget.accuracy) {
      _accuracyAnimation = Tween<double>(
        begin: oldWidget.accuracy,
        end: widget.accuracy,
      ).animate(CurvedAnimation(
        parent: _accuracyController,
        curve: Curves.easeOutCubic,
      ));
      _accuracyController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    _accuracyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        boxShadow: ThemeConstants.shadowMd,
      ),
      child: Column(
        children: [
          // مؤشر الدقة
          _buildAccuracyIndicator(context),
          
          Spaces.medium,
          
          // البوصلة الرئيسية
          Expanded(
            child: _buildCompass(context),
          ),
          
          Spaces.medium,
          
          // معلومات الاتجاه
          _buildDirectionInfo(context),
        ],
      ),
    );
  }

  Widget _buildAccuracyIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spaceSm),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _getAccuracyColor().withValues(alpha: 0.1),
            _getAccuracyColor().withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      child: Row(
        children: [
          // أيقونة الدقة
          AnimatedBuilder(
            animation: _accuracyAnimation,
            builder: (context, child) {
              return Container(
                padding: const EdgeInsets.all(ThemeConstants.spaceSm),
                decoration: BoxDecoration(
                  color: _getAccuracyColor().withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getAccuracyIcon(),
                  color: _getAccuracyColor(),
                  size: ThemeConstants.iconMd,
                ),
              );
            },
          ),
          
          Spaces.mediumH,
          
          // معلومات الدقة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'دقة البوصلة',
                  style: context.bodyStyle.copyWith(
                    fontWeight: ThemeConstants.fontSemiBold,
                  ),
                ),
                Spaces.small,
                AnimatedBuilder(
                  animation: _accuracyAnimation,
                  builder: (context, child) {
                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: context.borderColor,
                              borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: (_accuracyAnimation.value / 100).clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _getAccuracyColor(),
                                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Spaces.smallH,
                        Text(
                          '${_accuracyAnimation.value.toStringAsFixed(0)}%',
                          style: context.captionStyle.copyWith(
                            color: _getAccuracyColor(),
                            fontWeight: ThemeConstants.fontSemiBold,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          
          // زر المعايرة
          if (!widget.isCalibrated && widget.onCalibrate != null)
            IslamicButton.small(
              text: 'معايرة',
              onPressed: () {
                HapticFeedback.lightImpact();
                widget.onCalibrate?.call();
              },
              icon: Icons.compass_calibration,
              color: ThemeConstants.warning,
              isOutlined: true,
            ),
        ],
      ),
    );
  }

  Widget _buildCompass(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 280,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // خلفية البوصلة
            _buildCompassBackground(context),
            
            // إبرة البوصلة
            _buildCompassNeedle(context),
            
            // مؤشر القبلة
            _buildQiblaIndicator(context),
            
            // العلامات الاتجاهية
            _buildDirectionMarkers(context),
            
            // نقطة المركز
            _buildCenterPoint(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCompassBackground(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        final currentRotation = Tween<double>(
          begin: _lastDirection,
          end: widget.currentDirection,
        ).animate(CurvedAnimation(
          parent: _rotationController,
          curve: Curves.easeOutCubic,
        )).value;
        
        return Transform.rotate(
          angle: (currentRotation * math.pi / 180) * -1,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  context.cardColor,
                  context.backgroundColor.withValues(alpha: 0.8),
                ],
                stops: const [0.7, 1.0],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: context.borderColor,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.primaryColor.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: CustomPaint(
              painter: CompassBackgroundPainter(
                primaryColor: context.primaryColor,
                secondaryColor: context.secondaryTextColor,
                backgroundColor: context.cardColor,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompassNeedle(BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        final currentRotation = Tween<double>(
          begin: _lastDirection,
          end: widget.currentDirection,
        ).animate(CurvedAnimation(
          parent: _rotationController,
          curve: Curves.easeOutCubic,
        )).value;
        
        return Transform.rotate(
          angle: (currentRotation * math.pi / 180) * -1,
          child: CustomPaint(
            size: const Size(280, 280),
            painter: CompassNeedlePainter(
              needleColor: context.primaryColor,
              shadowColor: Colors.black.withValues(alpha: 0.3),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQiblaIndicator(BuildContext context) {
    final qiblaAngle = (widget.qiblaDirection - widget.currentDirection) * math.pi / 180;
    
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: qiblaAngle,
          child: Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(top: 30),
              child: Column(
                children: [
                  // أيقونة الكعبة
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          ThemeConstants.secondary,
                          ThemeConstants.secondary.lighten(0.2),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: ThemeConstants.secondary.withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.mosque,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  
                  Spaces.small,
                  
                  // نص القبلة
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ThemeConstants.spaceSm,
                      vertical: ThemeConstants.spaceXs,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeConstants.secondary,
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                    ),
                    child: Text(
                      'القبلة',
                      style: context.captionStyle.copyWith(
                        color: Colors.white,
                        fontWeight: ThemeConstants.fontBold,
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

  Widget _buildDirectionMarkers(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: CustomPaint(
        painter: DirectionMarkersPainter(
          textColor: context.textColor,
          markerColor: context.secondaryTextColor,
          currentDirection: widget.currentDirection,
        ),
      ),
    );
  }

  Widget _buildCenterPoint(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primaryColor,
            context.primaryColor.darken(0.2),
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionInfo(BuildContext context) {
    final angleDifference = _getAngleDifference();
    final isAligned = angleDifference.abs() < 5;
    
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      decoration: BoxDecoration(
        color: isAligned 
            ? ThemeConstants.success.withValues(alpha: 0.1)
            : context.cardColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      child: Column(
        children: [
          // حالة الاتجاه
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isAligned ? Icons.check_circle : Icons.navigation,
                color: isAligned ? ThemeConstants.success : context.primaryColor,
                size: ThemeConstants.iconLg,
              ),
              Spaces.mediumH,
              Text(
                isAligned ? 'متوجه للقبلة ✓' : 'حرك الجهاز للاتجاه الصحيح',
                style: context.titleStyle.copyWith(
                  color: isAligned ? ThemeConstants.success : context.textColor,
                  fontWeight: ThemeConstants.fontSemiBold,
                ),
              ),
            ],
          ),
          
          Spaces.medium,
          
          // معلومات الزوايا
          Row(
            children: [
              Expanded(
                child: _buildAngleInfo(
                  context,
                  'الاتجاه الحالي',
                  '${widget.currentDirection.toStringAsFixed(1)}°',
                  Icons.my_location,
                ),
              ),
              
              Container(
                width: 1,
                height: 40,
                color: context.borderColor,
                margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spaceSm),
              ),
              
              Expanded(
                child: _buildAngleInfo(
                  context,
                  'اتجاه القبلة',
                  '${widget.qiblaDirection.toStringAsFixed(1)}°',
                  Icons.mosque,
                ),
              ),
              
              Container(
                width: 1,
                height: 40,
                color: context.borderColor,
                margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.spaceSm),
              ),
              
              Expanded(
                child: _buildAngleInfo(
                  context,
                  'الفرق',
                  '${angleDifference.abs().toStringAsFixed(1)}°',
                  Icons.compare_arrows,
                  valueColor: isAligned ? ThemeConstants.success : ThemeConstants.warning,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAngleInfo(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? valueColor,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: ThemeConstants.iconMd,
          color: context.secondaryTextColor,
        ),
        Spaces.small,
        Text(
          label,
          style: context.captionStyle,
          textAlign: TextAlign.center,
        ),
        Text(
          value,
          style: context.bodyStyle.copyWith(
            fontWeight: ThemeConstants.fontBold,
            color: valueColor ?? context.primaryColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // دوال مساعدة
  Color _getAccuracyColor() {
    if (widget.accuracy >= 70) return ThemeConstants.success;
    if (widget.accuracy >= 40) return ThemeConstants.warning;
    return ThemeConstants.error;
  }

  IconData _getAccuracyIcon() {
    if (widget.accuracy >= 70) return Icons.gps_fixed;
    if (widget.accuracy >= 40) return Icons.gps_not_fixed;
    return Icons.gps_off;
  }

  double _getAngleDifference() {
    double diff = widget.qiblaDirection - widget.currentDirection;
    while (diff > 180) {
      diff -= 360;
    }
    while (diff < -180) {
      diff += 360;
    }
    return diff;
  }
}

// رسام خلفية البوصلة
class CompassBackgroundPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;

  CompassBackgroundPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // رسم الدوائر المتحدة المركز
    for (int i = 1; i <= 3; i++) {
      final paint = Paint()
        ..color = secondaryColor.withValues(alpha: 0.1 * i)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawCircle(center, radius * 0.3 * i, paint);
    }

    // رسم الخطوط الاتجاهية الرئيسية
    final linePaint = Paint()
      ..color = secondaryColor.withValues(alpha: 0.3)
      ..strokeWidth = 2;

    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final start = Offset(
        center.dx + (radius * 0.7) * math.cos(angle),
        center.dy + (radius * 0.7) * math.sin(angle),
      );
      final end = Offset(
        center.dx + (radius * 0.9) * math.cos(angle),
        center.dy + (radius * 0.9) * math.sin(angle),
      );
      canvas.drawLine(start, end, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// رسام إبرة البوصلة
class CompassNeedlePainter extends CustomPainter {
  final Color needleColor;
  final Color shadowColor;

  CompassNeedlePainter({
    required this.needleColor,
    required this.shadowColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // رسم ظل الإبرة
    final shadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.fill;

    final shadowPath = Path();
    shadowPath.moveTo(center.dx + 2, center.dy - radius * 0.6 + 2);
    shadowPath.lineTo(center.dx + 8 + 2, center.dy + 2);
    shadowPath.lineTo(center.dx + 2, center.dy + radius * 0.3 + 2);
    shadowPath.lineTo(center.dx - 8 + 2, center.dy + 2);
    shadowPath.close();

    canvas.drawPath(shadowPath, shadowPaint);

    // رسم الإبرة الرئيسية
    final needlePaint = Paint()
      ..color = needleColor
      ..style = PaintingStyle.fill;

    final needlePath = Path();
    needlePath.moveTo(center.dx, center.dy - radius * 0.6);
    needlePath.lineTo(center.dx + 8, center.dy);
    needlePath.lineTo(center.dx, center.dy + radius * 0.3);
    needlePath.lineTo(center.dx - 8, center.dy);
    needlePath.close();

    canvas.drawPath(needlePath, needlePaint);

    // رسم الجزء الأبيض للإبرة (الجزء الجنوبي)
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final whitePath = Path();
    whitePath.moveTo(center.dx, center.dy);
    whitePath.lineTo(center.dx + 6, center.dy);
    whitePath.lineTo(center.dx, center.dy + radius * 0.3);
    whitePath.lineTo(center.dx - 6, center.dy);
    whitePath.close();

    canvas.drawPath(whitePath, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// رسام علامات الاتجاه
class DirectionMarkersPainter extends CustomPainter {
  final Color textColor;
  final Color markerColor;
  final double currentDirection;

  DirectionMarkersPainter({
    required this.textColor,
    required this.markerColor,
    required this.currentDirection,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final directions = ['ش', 'ق', 'ج', 'غ'];
    final angles = [0, 90, 180, 270];

    for (int i = 0; i < directions.length; i++) {
      final angle = (angles[i] - currentDirection) * math.pi / 180;
      final x = center.dx + (radius * 0.85) * math.cos(angle - math.pi / 2);
      final y = center.dy + (radius * 0.85) * math.sin(angle - math.pi / 2);

      final textPainter = TextPainter(
        text: TextSpan(
          text: directions[i],
          style: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        textDirection: TextDirection.rtl,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x - textPainter.width / 2,
          y - textPainter.height / 2,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}