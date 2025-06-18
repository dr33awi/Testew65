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
  late AnimationController _backgroundController;
  late AnimationController _qiblaFoundController;
  
  late Animation<double> _pulseAnimation;
  late Animation<double> _backgroundAnimation;
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

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

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

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.linear,
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
    final wasNearQibla = _isNearQibla;
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
    _backgroundController.dispose();
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
            // خلفية متحركة مع تأثيرات بصرية
            _buildAnimatedBackground(size),
            
            // حاوية البوصلة الرئيسية
            _buildCompassContainer(size, context, relativeAngle, angleDifference),
            
            // معلومات الدقة والحالة
            _buildStatusInfo(context, size, angleDifference),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedBackground(double size) {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) {
        return Container(
          width: size,
          height: size,
          child: CustomPaint(
            painter: CompassBackgroundPainter(
              animation: _backgroundAnimation.value,
              accuracy: widget.accuracy,
              isNearQibla: _isNearQibla,
              qiblaFoundAnimation: _qiblaFoundAnimation.value,
              primaryColor: context.primaryColor,
              isDarkMode: context.isDarkMode,
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompassContainer(double size, BuildContext context, double relativeAngle, double angleDifference) {
    return Container(
      width: size * 0.95,
      height: size * 0.95,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            context.cardColor.withValues(alpha: 0.95),
            context.cardColor.withValues(alpha: 0.8),
            context.cardColor.withValues(alpha: 0.6),
          ],
          stops: const [0.3, 0.7, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          ...ThemeConstants.shadowXl,
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
            width: size,
            height: size,
            child: Stack(
              children: [
                // علامات البوصلة
                CustomPaint(
                  size: Size(size, size),
                  painter: EnhancedCompassPainter(
                    accuracy: widget.accuracy,
                    isDarkMode: context.isDarkMode,
                    primaryColor: context.primaryColor,
                    textColor: context.textPrimaryColor,
                    secondaryColor: context.textSecondaryColor,
                  ),
                ),

                // تسميات الاتجاهات
                _buildDirectionLabels(size, context),
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
        final scale = isAccurate ? 1.0 + (_qiblaFoundAnimation.value * 0.2) : 1.0;
        final glowIntensity = isAccurate ? _qiblaFoundAnimation.value : 0.0;

        return Transform.rotate(
          angle: relativeAngle * (math.pi / 180),
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: size * 0.9,
              height: size * 0.9,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // توهج القبلة عند الدقة العالية
                  if (isAccurate)
                    Positioned(
                      top: 0,
                      child: Container(
                        width: 100,
                        height: size * 0.5,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            colors: [
                              ThemeConstants.success.withValues(alpha: glowIntensity * 0.3),
                              ThemeConstants.success.withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // سهم القبلة الرئيسي
                  Positioned(
                    top: 0,
                    child: Container(
                      width: 80,
                      height: size * 0.45,
                      child: CustomPaint(
                        painter: EnhancedQiblaArrowPainter(
                          color: isAccurate ? ThemeConstants.success : context.primaryColor,
                          accuracy: widget.accuracy,
                          glowIntensity: glowIntensity,
                          pulseAnimation: _pulseAnimation.value,
                        ),
                      ),
                    ),
                  ),

                  // تسمية القبلة
                  Positioned(
                    top: size * 0.12,
                    child: AnimatedContainer(
                      duration: ThemeConstants.durationNormal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.space3,
                        vertical: ThemeConstants.space1,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            (isAccurate ? ThemeConstants.success : context.primaryColor).withValues(alpha: 0.9),
                            (isAccurate ? ThemeConstants.success : context.primaryColor).withValues(alpha: 0.7),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                        boxShadow: [
                          BoxShadow(
                            color: (isAccurate ? ThemeConstants.success : context.primaryColor).withValues(alpha: 0.3),
                            blurRadius: isAccurate ? 15 : 8,
                            offset: const Offset(0, 4),
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
                              fontFamily: ThemeConstants.fontFamilyArabic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // مؤشر المسافة الزاوية
                  if (angleDifference < 30)
                    Positioned(
                      top: size * 0.2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ThemeConstants.space2,
                          vertical: ThemeConstants.space1,
                        ),
                        decoration: BoxDecoration(
                          color: context.cardColor.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                          border: Border.all(
                            color: context.primaryColor.withValues(alpha: 0.3),
                          ),
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
      top: size * 0.04,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Container(
            width: 0,
            height: 0,
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 12 + (_pulseAnimation.value * 3),
                  color: Colors.transparent,
                ),
                right: BorderSide(
                  width: 12 + (_pulseAnimation.value * 3),
                  color: Colors.transparent,
                ),
                bottom: BorderSide(
                  width: 25 + (_pulseAnimation.value * 5),
                  color: ThemeConstants.error.withValues(
                    alpha: 0.8 + (_pulseAnimation.value * 0.2),
                  ),
                ),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(top: 30),
              child: Text(
                'الجهاز',
                style: context.labelSmall?.copyWith(
                  color: ThemeConstants.error,
                  fontWeight: ThemeConstants.medium,
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
          width: ThemeConstants.iconLg,
          height: ThemeConstants.iconLg,
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
              width: ThemeConstants.borderMedium,
            ),
            boxShadow: [
              BoxShadow(
                color: centerColor.withValues(alpha: 0.4),
                blurRadius: isAccurate ? 20 : 10,
                offset: const Offset(0, 4),
              ),
              ...ThemeConstants.shadowMd,
            ],
          ),
          child: isAccurate 
              ? Icon(
                  Icons.check,
                  color: Colors.white,
                  size: ThemeConstants.iconSm,
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
              vertical: ThemeConstants.space2,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.cardColor.withValues(alpha: 0.95),
                  context.cardColor.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              border: Border.all(
                color: context.primaryColor.withValues(alpha: 0.2),
              ),
              boxShadow: ThemeConstants.shadowLg,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _pulseAnimation.value * 0.1,
                      child: Icon(
                        Icons.navigation,
                        color: context.primaryColor,
                        size: ThemeConstants.iconMd,
                      ),
                    );
                  },
                ),
                ThemeConstants.space2.w,
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
                      style: context.labelSmall?.copyWith(
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
              ThemeConstants.space2.w,
              if (!widget.isCalibrated)
                _buildCalibrationChip(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAccuracyChip(BuildContext context) {
    final accuracyColor = _getAccuracyColor(widget.accuracy);
    
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space3,
            vertical: ThemeConstants.space1,
          ),
          decoration: BoxDecoration(
            color: accuracyColor.withValues(alpha: 0.1 + (_pulseAnimation.value * 0.1)),
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
              ThemeConstants.space1.w,
              Text(
                _getAccuracyText(widget.accuracy),
                style: context.labelSmall?.copyWith(
                  color: accuracyColor,
                  fontWeight: ThemeConstants.medium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCalibrationChip(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onCalibrate?.call();
      },
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space3,
              vertical: ThemeConstants.space1,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ThemeConstants.warning.withValues(alpha: 0.2 + (_pulseAnimation.value * 0.1)),
                  ThemeConstants.warning.withValues(alpha: 0.1 + (_pulseAnimation.value * 0.05)),
                ],
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
              border: Border.all(
                color: ThemeConstants.warning.withValues(alpha: 0.4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(
                  angle: _pulseAnimation.value * 0.2,
                  child: Icon(
                    Icons.compass_calibration,
                    size: ThemeConstants.iconSm,
                    color: ThemeConstants.warning,
                  ),
                ),
                ThemeConstants.space1.w,
                Text(
                  'معايرة',
                  style: context.labelSmall?.copyWith(
                    color: ThemeConstants.warning,
                    fontWeight: ThemeConstants.medium,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDirectionLabels(double size, BuildContext context) {
    final directions = [
      {'text': 'ش', 'angle': 0.0, 'isMain': true, 'color': ThemeConstants.error}, // شمال
      {'text': 'ش ش', 'angle': 22.5, 'isMain': false, 'color': context.textSecondaryColor},
      {'text': 'ش ق', 'angle': 45.0, 'isMain': false, 'color': context.textSecondaryColor},
      {'text': 'ش ق ق', 'angle': 67.5, 'isMain': false, 'color': context.textSecondaryColor},
      {'text': 'ق', 'angle': 90.0, 'isMain': true, 'color': context.textPrimaryColor}, // شرق
      {'text': 'ج ق ق', 'angle': 112.5, 'isMain': false, 'color': context.textSecondaryColor},
      {'text': 'ج ق', 'angle': 135.0, 'isMain': false, 'color': context.textSecondaryColor},
      {'text': 'ج ج ق', 'angle': 157.5, 'isMain': false, 'color': context.textSecondaryColor},
      {'text': 'ج', 'angle': 180.0, 'isMain': true, 'color': context.textPrimaryColor}, // جنوب
      {'text': 'ج ج غ', 'angle': 202.5, 'isMain': false, 'color': context.textSecondaryColor},
      {'text': 'ج غ', 'angle': 225.0, 'isMain': false, 'color': context.textSecondaryColor},
      {'text': 'غ ج ج', 'angle': 247.5, 'isMain': false, 'color': context.textSecondaryColor},
      {'text': 'غ', 'angle': 270.0, 'isMain': true, 'color': context.textPrimaryColor}, // غرب
      {'text': 'غ ش ش', 'angle': 292.5, 'isMain': false, 'color': context.textSecondaryColor},
      {'text': 'ش غ', 'angle': 315.0, 'isMain': false, 'color': context.textSecondaryColor},
      {'text': 'ش ش غ', 'angle': 337.5, 'isMain': false, 'color': context.textSecondaryColor},
    ];

    return Stack(
      children: directions.map((direction) {
        final angle = direction['angle'] as double;
        final isMain = direction['isMain'] as bool;
        final text = direction['text'] as String;
        final color = direction['color'] as Color;

        final radians = (angle - 90) * (math.pi / 180);
        final radius = size * 0.38;
        final x = radius * math.cos(radians);
        final y = radius * math.sin(radians);

        return Transform.translate(
          offset: Offset(x, y),
          child: Container(
            width: isMain ? 35 : 30,
            height: isMain ? 35 : 30,
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
                      width: 1,
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: color.withValues(alpha: isMain ? 1.0 : 0.7),
                  fontSize: isMain ? ThemeConstants.textSizeSm : ThemeConstants.textSizeXs,
                  fontWeight: isMain ? ThemeConstants.bold : ThemeConstants.regular,
                  fontFamily: ThemeConstants.fontFamilyArabic,
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

/// رسام خلفية البوصلة المحسن
class CompassBackgroundPainter extends CustomPainter {
  final double animation;
  final double accuracy;
  final bool isNearQibla;
  final double qiblaFoundAnimation;
  final Color primaryColor;
  final bool isDarkMode;

  CompassBackgroundPainter({
    required this.animation,
    required this.accuracy,
    required this.isNearQibla,
    required this.qiblaFoundAnimation,
    required this.primaryColor,
    required this.isDarkMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // رسم موجات الدقة
    _drawAccuracyWaves(canvas, center, radius);

    // رسم دوائر النجاح عند العثور على القبلة
    if (isNearQibla) {
      _drawSuccessRings(canvas, center, radius);
    }

    // رسم النجوم الإسلامية المتحركة
    _drawIslamicStars(canvas, size);

    // رسم خطوط الطاقة المغناطيسية
    _drawMagneticField(canvas, center, radius);
  }

  void _drawAccuracyWaves(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final waveColor = Color.lerp(
      ThemeConstants.error,
      primaryColor,
      accuracy,
    )!;

    for (int i = 0; i < 4; i++) {
      final waveRadius = radius * 0.3 + (i * 30) + (animation * 20);
      final alpha = (1 - (i * 0.2)) * (0.4 - animation * 0.2) * accuracy;
      
      paint.color = waveColor.withValues(alpha: alpha.clamp(0.0, 1.0));
      canvas.drawCircle(center, waveRadius, paint);
    }
  }

  void _drawSuccessRings(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (int i = 0; i < 3; i++) {
      final ringRadius = radius * 0.4 + (i * 40) + (qiblaFoundAnimation * 30);
      final alpha = (1 - qiblaFoundAnimation) * (1 - i * 0.3);
      
      paint.color = ThemeConstants.success.withValues(alpha: alpha.clamp(0.0, 1.0));
      canvas.drawCircle(center, ringRadius, paint);
    }
  }

  void _drawIslamicStars(Canvas canvas, Size size) {
    final starPositions = [
      Offset(size.width * 0.15, size.height * 0.2),
      Offset(size.width * 0.85, size.height * 0.3),
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.8, size.height * 0.75),
    ];

    final paint = Paint()
      ..color = primaryColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (int i = 0; i < starPositions.length; i++) {
      final offset = math.sin(animation * 2 * math.pi + i * math.pi / 2) * 8;
      final rotation = animation * math.pi / 4;
      
      canvas.save();
      canvas.translate(starPositions[i].dx + offset, starPositions[i].dy + offset);
      canvas.rotate(rotation);
      
      _drawEightPointStar(canvas, Offset.zero, 12, paint);
      canvas.restore();
    }
  }

  void _drawMagneticField(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final fieldColor = isDarkMode 
        ? primaryColor.withValues(alpha: 0.15)
        : primaryColor.withValues(alpha: 0.1);

    // خطوط المجال المغناطيسي المنحنية
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4) + (animation * math.pi / 8);
      final startRadius = radius * 0.2;
      final endRadius = radius * 0.9;
      
      final path = Path();
      
      for (double r = startRadius; r <= endRadius; r += 5) {
        final adjustedAngle = angle + math.sin(r / 20 + animation * 2 * math.pi) * 0.2;
        final x = center.dx + r * math.cos(adjustedAngle);
        final y = center.dy + r * math.sin(adjustedAngle);
        
        if (r == startRadius) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      
      paint.color = fieldColor.withValues(alpha: fieldColor.alpha * (1 - i * 0.1));
      canvas.drawPath(path, paint);
    }
  }

  void _drawEightPointStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const int points = 8;
    final double angle = 2 * math.pi / points;

    for (int i = 0; i < points; i++) {
      final outerAngle = i * angle - math.pi / 2;
      final innerAngle = (i + 0.5) * angle - math.pi / 2;

      final outerX = center.dx + radius * math.cos(outerAngle);
      final outerY = center.dy + radius * math.sin(outerAngle);

      final innerX = center.dx + (radius * 0.5) * math.cos(innerAngle);
      final innerY = center.dy + (radius * 0.5) * math.sin(innerAngle);

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
  bool shouldRepaint(covariant CompassBackgroundPainter oldDelegate) {
    return oldDelegate.animation != animation ||
           oldDelegate.accuracy != accuracy ||
           oldDelegate.isNearQibla != isNearQibla ||
           oldDelegate.qiblaFoundAnimation != qiblaFoundAnimation;
  }
}

/// رسام البوصلة المحسن
class EnhancedCompassPainter extends CustomPainter {
  final double accuracy;
  final bool isDarkMode;
  final Color primaryColor;
  final Color textColor;
  final Color secondaryColor;

  EnhancedCompassPainter({
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

    // رسم الأرقام
    _drawNumbers(canvas, center, radius);
  }

  void _drawMainCircles(Canvas canvas, Offset center, double radius) {
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // الدائرة الخارجية
    circlePaint.color = primaryColor.withValues(alpha: 0.3);
    canvas.drawCircle(center, radius - 2, circlePaint);

    // الدائرة الداخلية
    circlePaint
      ..color = primaryColor.withValues(alpha: 0.2)
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius * 0.85, circlePaint);

    // دائرة المنتصف
    circlePaint
      ..color = secondaryColor.withValues(alpha: 0.1)
      ..strokeWidth = 1;
    canvas.drawCircle(center, radius * 0.7, circlePaint);
  }

  void _drawDegreeMarks(Canvas canvas, Offset center, double radius) {
    for (int i = 0; i < 360; i += 1) {
      final angle = i * (math.pi / 180);
      final isMainDirection = i % 90 == 0;
      final isMediumDirection = i % 45 == 0;
      final isMinorDirection = i % 15 == 0;
      final is5DegMark = i % 5 == 0;

      Paint linePaint;
      double lineLength;
      double lineWidth;

      if (isMainDirection) {
        lineLength = 35;
        lineWidth = 3;
        linePaint = Paint()
          ..color = i == 0 ? ThemeConstants.error : primaryColor
          ..strokeWidth = lineWidth;
      } else if (isMediumDirection) {
        lineLength = 25;
        lineWidth = 2;
        linePaint = Paint()
          ..color = primaryColor.withValues(alpha: 0.8)
          ..strokeWidth = lineWidth;
      } else if (isMinorDirection) {
        lineLength = 18;
        lineWidth = 1.5;
        linePaint = Paint()
          ..color = secondaryColor.withValues(alpha: 0.7)
          ..strokeWidth = lineWidth;
      } else if (is5DegMark) {
        lineLength = 12;
        lineWidth = 1;
        linePaint = Paint()
          ..color = secondaryColor.withValues(alpha: 0.5)
          ..strokeWidth = lineWidth;
      } else {
        lineLength = 8;
        lineWidth = 0.5;
        linePaint = Paint()
          ..color = secondaryColor.withValues(alpha: 0.3)
          ..strokeWidth = lineWidth;
      }

      final startRadius = radius - lineLength;
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

  void _drawNumbers(Canvas canvas, Offset center, double radius) {
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );

    for (int i = 0; i < 360; i += 30) {
      final angle = i * (math.pi / 180);
      final numberRadius = radius - 50;

      final x = center.dx + numberRadius * math.cos(angle - math.pi / 2);
      final y = center.dy + numberRadius * math.sin(angle - math.pi / 2);

      textPainter.text = TextSpan(
        text: i.toString(),
        style: TextStyle(
          color: i == 0 ? ThemeConstants.error : textColor,
          fontSize: i % 90 == 0 ? 16 : 12,
          fontWeight: i % 90 == 0 ? FontWeight.bold : FontWeight.normal,
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant EnhancedCompassPainter oldDelegate) {
    return oldDelegate.accuracy != accuracy || 
           oldDelegate.isDarkMode != isDarkMode ||
           oldDelegate.primaryColor != primaryColor;
  }
}

/// رسام سهم القبلة المحسن
class EnhancedQiblaArrowPainter extends CustomPainter {
  final Color color;
  final double accuracy;
  final double glowIntensity;
  final double pulseAnimation;

  EnhancedQiblaArrowPainter({
    required this.color,
    required this.accuracy,
    required this.glowIntensity,
    required this.pulseAnimation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // رسم الظل مع التوهج
    _drawShadowAndGlow(canvas, size);

    // رسم السهم الرئيسي
    _drawMainArrow(canvas, size);

    // رسم التفاصيل الزخرفية
    _drawDecorations(canvas, size);

    // رسم التدرج العلوي
    _drawGlossEffect(canvas, size);
  }

  void _drawShadowAndGlow(Canvas canvas, Size size) {
    final path = _createArrowPath(size);

    // الظل
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.save();
    canvas.translate(2, 4);
    canvas.drawPath(path, shadowPaint);
    canvas.restore();

    // التوهج عند الدقة العالية
    if (glowIntensity > 0) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: glowIntensity * 0.6)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8 + (pulseAnimation * 4));

      canvas.drawPath(path, glowPaint);
    }
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
          color.darken(0.4),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, mainPaint);

    // الحدود
    final borderPaint = Paint()
      ..color = color.darken(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, borderPaint);
  }

  void _drawDecorations(Canvas canvas, Size size) {
    final decorPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // خطوط زخرفية على السهم
    final centerX = size.width / 2;
    final decorationLines = [
      [Offset(centerX - 8, size.height * 0.6), Offset(centerX + 8, size.height * 0.6)],
      [Offset(centerX - 6, size.height * 0.7), Offset(centerX + 6, size.height * 0.7)],
    ];

    for (final line in decorationLines) {
      canvas.drawLine(line[0], line[1], decorPaint);
    }

    // نقطة مضيئة في الأعلى
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(centerX, size.height * 0.15),
      3,
      dotPaint,
    );
  }

  void _drawGlossEffect(Canvas canvas, Size size) {
    final glossPath = Path();
    glossPath.moveTo(size.width * 0.4, size.height * 0.1);
    glossPath.quadraticBezierTo(
      size.width / 2, size.height * 0.05,
      size.width * 0.6, size.height * 0.1,
    );
    glossPath.quadraticBezierTo(
      size.width * 0.55, size.height * 0.4,
      size.width * 0.45, size.height * 0.4,
    );
    glossPath.close();

    final glossPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.4),
          Colors.white.withValues(alpha: 0.1),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height * 0.4));

    canvas.drawPath(glossPath, glossPaint);
  }

  Path _createArrowPath(Size size) {
    final path = Path();
    final centerX = size.width / 2;

    // شكل السهم المحسن
    path.moveTo(centerX, 0); // رأس السهم
    path.lineTo(size.width * 0.75, size.height * 0.35); // الجناح الأيمن
    path.lineTo(size.width * 0.65, size.height * 0.35); // دخول داخلي أيمن
    path.lineTo(size.width * 0.65, size.height * 0.85); // جانب أيمن طويل
    path.lineTo(size.width * 0.35, size.height * 0.85); // جانب أيسر طويل
    path.lineTo(size.width * 0.35, size.height * 0.35); // دخول داخلي أيسر
    path.lineTo(size.width * 0.25, size.height * 0.35); // الجناح الأيسر
    path.close();

    return path;
  }

  @override
  bool shouldRepaint(covariant EnhancedQiblaArrowPainter oldDelegate) {
    return oldDelegate.color != color ||
           oldDelegate.accuracy != accuracy ||
           oldDelegate.glowIntensity != glowIntensity ||
           oldDelegate.pulseAnimation != pulseAnimation;
  }
}