// lib/features/qibla/widgets/qibla_compass.dart - محدث للنظام الموحد
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart'; // ✅ النظام الموحد

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
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late Animation<double> _rotationAnimation;
  
  double _previousDirection = 0;
  bool _hasVibratedForQibla = false;

  @override
  void initState() {
    super.initState();
    _setupAnimation();
    _previousDirection = widget.currentDirection;
  }

  void _setupAnimation() {
    _rotationController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: ThemeConstants.curveSmooth,
    ));
  }

  @override
  void didUpdateWidget(QiblaCompass oldWidget) {
    super.didUpdateWidget(oldWidget);

    // تحديث الدوران بسلاسة
    if ((widget.currentDirection - _previousDirection).abs() > 1) {
      _previousDirection = oldWidget.currentDirection;
      _rotationController.forward(from: 0);
    }

    // اهتزاز عند العثور على القبلة
    final angleDifference = _getAngleDifference();
    if (angleDifference < 10 && !_hasVibratedForQibla) {
      HapticFeedback.lightImpact();
      _hasVibratedForQibla = true;
    } else if (angleDifference >= 10) {
      _hasVibratedForQibla = false;
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  double _getAngleDifference() {
    final relativeAngle = (widget.qiblaDirection - widget.currentDirection + 360) % 360;
    return (relativeAngle > 180 ? 360 - relativeAngle : relativeAngle).abs();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);
        
        return Stack(
          alignment: Alignment.center,
          children: [
            // حاوية البوصلة
            _buildCompassContainer(size, context),
            
            // معلومات الحالة
            _buildStatusInfo(context, size),
          ],
        );
      },
    );
  }

  Widget _buildCompassContainer(double size, BuildContext context) {
    return Container(
      width: size * 0.9,
      height: size * 0.9,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppColorSystem.getCard(context),
            AppColorSystem.getCard(context).withValues(alpha: 0.98),
            AppColorSystem.getCard(context).withValues(alpha: 0.95),
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
        // ✅ استخدام AppShadowSystem
        boxShadow: [
          ...AppShadowSystem.colored(
            color: AppColorSystem.getCategoryColor('qibla'),
            intensity: ShadowIntensity.medium,
            opacity: 0.15,
          ),
          ...AppShadowSystem.medium,
        ],
        border: Border.all(
          color: AppColorSystem.getCategoryColor('qibla').withValues(alpha: 0.1),
          width: 2,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // البوصلة الدوارة
          _buildRotatingCompass(size, context),
          
          // مؤشر القبلة
          _buildQiblaIndicator(size, context),
          
          // النقطة المركزية
          _buildCenterDot(context),
        ],
      ),
    );
  }

  Widget _buildRotatingCompass(double size, BuildContext context) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        final smoothDirection = _lerp(
          _previousDirection,
          widget.currentDirection,
          _rotationAnimation.value,
        );

        return Transform.rotate(
          angle: -smoothDirection * (math.pi / 180),
          child: SizedBox(
            width: size * 0.8,
            height: size * 0.8,
            child: CustomPaint(
              painter: CompassPainter(
                primaryColor: AppColorSystem.getCategoryColor('qibla'),
                textColor: AppColorSystem.getTextPrimary(context),
                secondaryColor: AppColorSystem.getTextSecondary(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQiblaIndicator(double size, BuildContext context) {
    final relativeAngle = (widget.qiblaDirection - widget.currentDirection + 360) % 360;
    final angleDifference = _getAngleDifference();
    final isAccurate = angleDifference < 5;

    return Transform.rotate(
      angle: relativeAngle * (math.pi / 180),
      child: Container(
        width: size * 0.75,
        height: size * 0.75,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // سهم القبلة المحسن
            Container(
              width: 50,
              height: size * 0.3,
              child: CustomPaint(
                painter: EnhancedQiblaArrowPainter(
                  color: isAccurate ? AppColorSystem.success : AppColorSystem.getCategoryColor('qibla'),
                  isAccurate: isAccurate,
                ),
              ),
            ),

            // تسمية القبلة مبسطة
            Positioned(
              top: size * 0.06,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: (isAccurate ? AppColorSystem.success : AppColorSystem.getCategoryColor('qibla'))
                      .withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(20),
                  // ✅ استخدام AppShadowSystem
                  boxShadow: AppShadowSystem.colored(
                    color: isAccurate ? AppColorSystem.success : AppColorSystem.getCategoryColor('qibla'),
                    intensity: ShadowIntensity.light,
                    opacity: 0.3,
                  ),
                ),
                child: Text(
                  'القبلة',
                  style: AppTextStyles.label2.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            // زاوية الانحراف محسنة
            if (angleDifference < 30)
              Positioned(
                top: size * 0.14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColorSystem.getCard(context).withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (isAccurate ? AppColorSystem.success : AppColorSystem.getCategoryColor('qibla'))
                          .withValues(alpha: 0.4),
                      width: 1.5,
                    ),
                    boxShadow: AppShadowSystem.light,
                  ),
                  child: Text(
                    '${angleDifference.toStringAsFixed(1)}°',
                    style: AppTextStyles.label2.copyWith(
                      color: isAccurate ? AppColorSystem.success : AppColorSystem.getCategoryColor('qibla'),
                      fontWeight: ThemeConstants.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterDot(BuildContext context) {
    final angleDifference = _getAngleDifference();
    final isAccurate = angleDifference < 5;

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [
            isAccurate ? AppColorSystem.success : AppColorSystem.getCategoryColor('qibla'),
            (isAccurate ? AppColorSystem.success : AppColorSystem.getCategoryColor('qibla')).darken(0.2),
          ],
        ),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 4,
        ),
        boxShadow: [
          ...AppShadowSystem.colored(
            color: isAccurate ? AppColorSystem.success : AppColorSystem.getCategoryColor('qibla'),
            intensity: isAccurate ? ShadowIntensity.strong : ShadowIntensity.medium,
            opacity: 0.4,
          ),
          ...AppShadowSystem.light,
        ],
      ),
      child: isAccurate
          ? Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 16,
            )
          : Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
            ),
    );
  }

  Widget _buildStatusInfo(BuildContext context, double size) {
    return Positioned(
      bottom: 0,
      child: Column(
        children: [
          // معلومات الاتجاه
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space3,
              vertical: ThemeConstants.space2,
            ),
            decoration: BoxDecoration(
              color: AppColorSystem.getCard(context).withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              border: Border.all(color: AppColorSystem.getCategoryColor('qibla').withValues(alpha: 0.2)),
              boxShadow: AppShadowSystem.light,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  AppIconsSystem.qibla,
                  color: AppColorSystem.getCategoryColor('qibla'),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.currentDirection.toStringAsFixed(1)}°',
                  style: AppTextStyles.label1.copyWith(
                    fontWeight: ThemeConstants.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  _getCompassDirection(widget.currentDirection),
                  style: AppTextStyles.label2.copyWith(
                    color: AppColorSystem.getTextSecondary(context),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // مؤشرات الحالة
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatusChip(
                context,
                _getAccuracyIcon(widget.accuracy),
                _getAccuracyText(widget.accuracy),
                _getAccuracyColor(widget.accuracy),
              ),
              if (!widget.isCalibrated) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: widget.onCalibrate,
                  child: _buildStatusChip(
                    context,
                    Icons.compass_calibration,
                    'معايرة',
                    AppColorSystem.warning,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: ThemeConstants.semiBold,
            ),
          ),
        ],
      ),
    );
  }

  // دوال مساعدة
  Color _getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) return AppColorSystem.success;
    if (accuracy >= 0.5) return AppColorSystem.warning;
    return AppColorSystem.error;
  }

  IconData _getAccuracyIcon(double accuracy) {
    if (accuracy >= 0.8) return Icons.gps_fixed;
    if (accuracy >= 0.5) return Icons.gps_not_fixed;
    return Icons.gps_off;
  }

  String _getAccuracyText(double accuracy) {
    if (accuracy >= 0.8) return 'عالية';
    if (accuracy >= 0.5) return 'متوسطة';
    return 'منخفضة';
  }

  String _getCompassDirection(double direction) {
    if (direction >= 337.5 || direction < 22.5) return 'ش';
    if (direction >= 22.5 && direction < 67.5) return 'ش ق';
    if (direction >= 67.5 && direction < 112.5) return 'ق';
    if (direction >= 112.5 && direction < 157.5) return 'ج ق';
    if (direction >= 157.5 && direction < 202.5) return 'ج';
    if (direction >= 202.5 && direction < 247.5) return 'ج غ';
    if (direction >= 247.5 && direction < 292.5) return 'غ';
    return 'ش غ';
  }

  double _lerp(double a, double b, double t) {
    double diff = b - a;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return (a + diff * t + 360) % 360;
  }
}

// رسام البوصلة المحسن
class CompassPainter extends CustomPainter {
  final Color primaryColor;
  final Color textColor;
  final Color secondaryColor;

  CompassPainter({
    required this.primaryColor,
    required this.textColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // رسم الدوائر الداخلية
    _drawInnerCircles(canvas, center, radius);

    // رسم علامات الدرجات المحسنة
    _drawEnhancedDegreeMarks(canvas, center, radius);

    // رسم تسميات الاتجاهات
    _drawDirectionLabels(canvas, center, radius);
  }

  void _drawInnerCircles(Canvas canvas, Offset center, double radius) {
    // الدائرة الخارجية الرئيسية
    final outerCirclePaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    canvas.drawCircle(center, radius - 3, outerCirclePaint);

    // دائرة داخلية للتفاصيل
    final innerCirclePaint = Paint()
      ..color = secondaryColor.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    canvas.drawCircle(center, radius * 0.75, innerCirclePaint);

    // دائرة مركزية صغيرة
    final centerCirclePaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    
    canvas.drawCircle(center, radius * 0.15, centerCirclePaint);
  }

  void _drawEnhancedDegreeMarks(Canvas canvas, Offset center, double radius) {
    for (int i = 0; i < 360; i += 5) {
      final angle = i * (math.pi / 180);
      final isMainDirection = i % 90 == 0;
      final isMediumDirection = i % 30 == 0;
      final isMinorDirection = i % 15 == 0;

      double lineLength;
      Paint linePaint;

      if (isMainDirection) {
        lineLength = 25;
        linePaint = Paint()
          ..color = i == 0 ? AppColorSystem.error : primaryColor
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round;
      } else if (isMediumDirection) {
        lineLength = 18;
        linePaint = Paint()
          ..color = primaryColor.withValues(alpha: 0.7)
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.round;
      } else if (isMinorDirection) {
        lineLength = 12;
        linePaint = Paint()
          ..color = primaryColor.withValues(alpha: 0.5)
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round;
      } else {
        lineLength = 8;
        linePaint = Paint()
          ..color = secondaryColor.withValues(alpha: 0.4)
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.round;
      }

      final startRadius = radius - lineLength - 5;
      final endRadius = radius - 5;

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

  void _drawDirectionLabels(Canvas canvas, Offset center, double radius) {
    final directions = [
      {'text': 'ش', 'angle': 0.0, 'color': AppColorSystem.error, 'isMain': true},
      {'text': 'ق', 'angle': 90.0, 'color': primaryColor, 'isMain': true},
      {'text': 'ج', 'angle': 180.0, 'color': primaryColor, 'isMain': true},
      {'text': 'غ', 'angle': 270.0, 'color': primaryColor, 'isMain': true},
    ];

    for (final direction in directions) {
      final angle = ((direction['angle'] as double) - 90) * (math.pi / 180);
      final textRadius = radius * 0.65;
      final x = center.dx + textRadius * math.cos(angle);
      final y = center.dy + textRadius * math.sin(angle);

      // خلفية دائرية للنص
      final bgPaint = Paint()
        ..color = (direction['color'] as Color).withValues(alpha: 0.1);
      
      canvas.drawCircle(Offset(x, y), 18, bgPaint);

      // حد دائري
      final borderPaint = Paint()
        ..color = (direction['color'] as Color).withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      
      canvas.drawCircle(Offset(x, y), 18, borderPaint);

      // النص
      final textStyle = TextStyle(
        color: direction['color'] as Color,
        fontSize: 18,
        fontWeight: ThemeConstants.bold, // ✅ استخدام النظام الموحد
      );

      final textPainter = TextPainter(
        text: TextSpan(text: direction['text'] as String, style: textStyle),
        textDirection: TextDirection.rtl,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CompassPainter oldDelegate) =>
      oldDelegate.primaryColor != primaryColor;
}

// رسام سهم القبلة المحسن
class EnhancedQiblaArrowPainter extends CustomPainter {
  final Color color;
  final bool isAccurate;

  EnhancedQiblaArrowPainter({
    required this.color,
    required this.isAccurate,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final centerX = size.width / 2;

    // شكل السهم المحسن - أكثر أناقة
    path.moveTo(centerX, 0); // رأس السهم
    path.lineTo(size.width * 0.75, size.height * 0.25); // الجناح الأيمن الخارجي
    path.lineTo(size.width * 0.62, size.height * 0.25); // الجناح الأيمن الداخلي
    path.lineTo(size.width * 0.58, size.height * 0.75); // الجانب الأيمن
    path.lineTo(size.width * 0.52, size.height * 0.9); // النهاية اليمنى
    path.lineTo(size.width * 0.48, size.height * 0.9); // النهاية اليسرى
    path.lineTo(size.width * 0.42, size.height * 0.75); // الجانب الأيسر
    path.lineTo(size.width * 0.38, size.height * 0.25); // الجناح الأيسر الداخلي
    path.lineTo(size.width * 0.25, size.height * 0.25); // الجناح الأيسر الخارجي
    path.close();

    // تدرج لوني للسهم
    final mainPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color,
          color.lighten(0.1), // ✅ استخدام extension من النظام الموحد
          color.darken(0.1),
          color.darken(0.2),
        ],
        stops: const [0.0, 0.3, 0.7, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(path, mainPaint);

    // توهج للسهم عند الدقة العالية
    if (isAccurate) {
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawPath(path, glowPaint);
    }

    // حدود السهم
    final borderPaint = Paint()
      ..color = color.darken(0.3) // ✅ استخدام extension من النظام الموحد
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, borderPaint);

    // خط مضيء في المنتصف
    final centerLinePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(centerX, size.height * 0.15),
      Offset(centerX, size.height * 0.8),
      centerLinePaint,
    );

    // نقطة مضيئة في الأعلى
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.9);

    canvas.drawCircle(
      Offset(centerX, size.height * 0.12),
      3,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant EnhancedQiblaArrowPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.isAccurate != isAccurate;
}