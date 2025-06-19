// lib/app/themes/widgets/core/app_loading.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../theme_constants.dart';
import '../../core/theme_extensions.dart';

/// أنواع مؤشرات التحميل الموحدة
enum LoadingType {
  circular,
  linear,
  dots,
  pulse,
  prayer,
  islamic,
}

/// أحجام مؤشرات التحميل
enum LoadingSize {
  small,
  medium,
  large,
}

/// مؤشر تحميل موحد ومحسن
class AppLoading extends StatelessWidget {
  final LoadingType type;
  final LoadingSize size;
  final String? message;
  final String? title;
  final Color? color;
  final double? value;
  final bool showBackground;
  final bool enableBlur;
  final double? strokeWidth;
  final Widget? icon;

  const AppLoading({
    super.key,
    this.type = LoadingType.circular,
    this.size = LoadingSize.medium,
    this.message,
    this.title,
    this.color,
    this.value,
    this.showBackground = false,
    this.enableBlur = false,
    this.strokeWidth,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.primaryColor;
    
    Widget loadingWidget = _buildLoadingIndicator(context, effectiveColor);
    
    // إضافة النص إذا وُجد
    if (message != null || title != null) {
      loadingWidget = _buildWithText(context, loadingWidget, effectiveColor);
    }

    // إضافة الخلفية إذا طُلبت
    if (showBackground) {
      loadingWidget = _buildWithBackground(context, loadingWidget, effectiveColor);
    }

    return Center(child: loadingWidget);
  }

  Widget _buildLoadingIndicator(BuildContext context, Color effectiveColor) {
    switch (type) {
      case LoadingType.circular:
        return _buildCircular(effectiveColor);
      case LoadingType.linear:
        return _buildLinear(effectiveColor);
      case LoadingType.dots:
        return DotsLoadingIndicator(
          color: effectiveColor,
          size: size,
        );
      case LoadingType.pulse:
        return PulseLoadingIndicator(
          color: effectiveColor,
          size: _getSize(),
        );
      case LoadingType.prayer:
        return PrayerLoadingIndicator(
          color: effectiveColor,
          size: _getSize(),
        );
      case LoadingType.islamic:
        return IslamicLoadingIndicator(
          color: effectiveColor,
          size: _getSize(),
        );
    }
  }

  Widget _buildCircular(Color color) {
    final size = _getSize();
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: value,
        strokeWidth: strokeWidth ?? _getStrokeWidth(),
        valueColor: AlwaysStoppedAnimation<Color>(color),
        backgroundColor: color.withValues(alpha: 0.2),
      ),
    );
  }

  Widget _buildLinear(Color color) {
    return SizedBox(
      width: _getLinearWidth(),
      child: LinearProgressIndicator(
        value: value,
        minHeight: _getLinearHeight(),
        valueColor: AlwaysStoppedAnimation<Color>(color),
        backgroundColor: color.withValues(alpha: 0.2),
      ),
    );
  }

  Widget _buildWithText(BuildContext context, Widget loadingWidget, Color effectiveColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space3),
            decoration: BoxDecoration(
              color: effectiveColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: icon!,
          ),
          ThemeConstants.space4.h,
        ],
        
        loadingWidget,
        
        ThemeConstants.space4.h,
        
        if (title != null)
          Text(
            title!,
            style: context.titleMedium?.copyWith(
              color: showBackground ? effectiveColor : context.textPrimaryColor,
              fontWeight: ThemeConstants.semiBold,
            ),
            textAlign: TextAlign.center,
          ),
        
        if (message != null) ...[
          if (title != null) ThemeConstants.space2.h,
          Text(
            message!,
            style: context.bodyMedium?.copyWith(
              color: showBackground 
                  ? effectiveColor.withValues(alpha: 0.8)
                  : context.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildWithBackground(BuildContext context, Widget child, Color effectiveColor) {
    Widget container = Container(
      padding: const EdgeInsets.all(ThemeConstants.space6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            effectiveColor.withValues(alpha: 0.9),
            effectiveColor.darken(0.1).withValues(alpha: 0.9),
          ],
        ),
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: effectiveColor.withValues(alpha: 0.3),
            blurRadius: 25,
            offset: const Offset(0, 15),
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );

    if (enableBlur) {
      container = ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: container,
        ),
      );
    }

    return container;
  }

  double _getSize() {
    switch (size) {
      case LoadingSize.small:
        return 24;
      case LoadingSize.medium:
        return 36;
      case LoadingSize.large:
        return 48;
    }
  }

  double _getStrokeWidth() {
    switch (size) {
      case LoadingSize.small:
        return 2;
      case LoadingSize.medium:
        return 3;
      case LoadingSize.large:
        return 4;
    }
  }

  double _getLinearWidth() {
    switch (size) {
      case LoadingSize.small:
        return 100;
      case LoadingSize.medium:
        return 150;
      case LoadingSize.large:
        return 200;
    }
  }

  double _getLinearHeight() {
    switch (size) {
      case LoadingSize.small:
        return 2;
      case LoadingSize.medium:
        return 4;
      case LoadingSize.large:
        return 6;
    }
  }

  // Factory constructors محسنة
  factory AppLoading.circular({
    LoadingSize size = LoadingSize.medium,
    Color? color,
    double? value,
    String? message,
  }) {
    return AppLoading(
      type: LoadingType.circular,
      size: size,
      color: color,
      value: value,
      message: message,
    );
  }

  factory AppLoading.linear({
    LoadingSize size = LoadingSize.medium,
    Color? color,
    double? value,
    String? message,
  }) {
    return AppLoading(
      type: LoadingType.linear,
      size: size,
      color: color,
      value: value,
      message: message,
    );
  }

  factory AppLoading.page({
    String? title,
    String? message,
    LoadingType type = LoadingType.prayer,
    Color? color,
    Widget? icon,
  }) {
    return AppLoading(
      type: type,
      size: LoadingSize.large,
      title: title,
      message: message,
      color: color,
      icon: icon,
      showBackground: true,
      enableBlur: true,
    );
  }

  factory AppLoading.prayer({
    String? message,
    Color? color,
  }) {
    return AppLoading(
      type: LoadingType.prayer,
      size: LoadingSize.large,
      message: message ?? 'جاري تحميل مواقيت الصلاة...',
      color: color,
      showBackground: true,
      enableBlur: true,
    );
  }

  factory AppLoading.islamic({
    String? message,
    Color? color,
  }) {
    return AppLoading(
      type: LoadingType.islamic,
      size: LoadingSize.large,
      message: message,
      color: color,
      showBackground: true,
      enableBlur: true,
    );
  }

  factory AppLoading.simple({
    LoadingSize size = LoadingSize.medium,
    Color? color,
  }) {
    return AppLoading(
      type: LoadingType.circular,
      size: size,
      color: color,
    );
  }
}

/// مؤشر تحميل بنقاط متحركة محسن
class DotsLoadingIndicator extends StatefulWidget {
  final Color color;
  final LoadingSize size;

  const DotsLoadingIndicator({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<DotsLoadingIndicator> createState() => _DotsLoadingIndicatorState();
}

class _DotsLoadingIndicatorState extends State<DotsLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: ThemeConstants.durationExtraSlow,
      vsync: this,
    )..repeat();

    _animations = List.generate(3, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            0.6 + index * 0.2,
            curve: ThemeConstants.curveSmooth,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotSize = widget.size == LoadingSize.small ? 8.0
        : widget.size == LoadingSize.medium ? 10.0
        : 12.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: widget.color.withValues(
                  alpha: 0.3 + _animations[index].value * 0.7
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.color.withValues(alpha: _animations[index].value * 0.5),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}

/// مؤشر تحميل بنبضات محسن
class PulseLoadingIndicator extends StatefulWidget {
  final Color color;
  final double size;

  const PulseLoadingIndicator({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<PulseLoadingIndicator> createState() => _PulseLoadingIndicatorState();
}

class _PulseLoadingIndicatorState extends State<PulseLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: ThemeConstants.curveSmooth),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: _opacityAnimation.value),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.color.withValues(alpha: _opacityAnimation.value * 0.5),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// مؤشر تحميل خاص بالصلاة
class PrayerLoadingIndicator extends StatefulWidget {
  final Color color;
  final double size;

  const PrayerLoadingIndicator({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<PrayerLoadingIndicator> createState() => _PrayerLoadingIndicatorState();
}

class _PrayerLoadingIndicatorState extends State<PrayerLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotationController);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // الدائرة الخارجية المتحركة
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.color.withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: CustomPaint(
                    painter: _PrayerCirclePainter(
                      color: widget.color,
                      progress: _rotationController.value,
                    ),
                  ),
                ),
              );
            },
          ),
          
          // أيقونة المسجد في المنتصف
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: widget.size * 0.5,
                  height: widget.size * 0.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.color.withValues(alpha: 0.1),
                    border: Border.all(
                      color: widget.color.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.mosque,
                    color: widget.color,
                    size: widget.size * 0.25,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// مؤشر تحميل إسلامي بزخارف
class IslamicLoadingIndicator extends StatefulWidget {
  final Color color;
  final double size;

  const IslamicLoadingIndicator({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<IslamicLoadingIndicator> createState() => _IslamicLoadingIndicatorState();
}

class _IslamicLoadingIndicatorState extends State<IslamicLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _IslamicPatternPainter(
              color: widget.color,
              animation: _animation.value,
            ),
          );
        },
      ),
    );
  }
}

/// رسام دائرة الصلاة
class _PrayerCirclePainter extends CustomPainter {
  final Color color;
  final double progress;

  _PrayerCirclePainter({
    required this.color,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 5;

    // رسم القوس المتحرك
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );

    // رسم نقاط تمثل أوقات الصلاة
    const prayerTimes = [0.0, 0.2, 0.4, 0.6, 0.8];
    for (int i = 0; i < prayerTimes.length; i++) {
      final angle = 2 * math.pi * prayerTimes[i] - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      
      canvas.drawCircle(
        Offset(x, y),
        progress > prayerTimes[i] ? 4 : 2,
        Paint()
          ..color = progress > prayerTimes[i] ? color : color.withValues(alpha: 0.3)
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// رسام النمط الإسلامي
class _IslamicPatternPainter extends CustomPainter {
  final Color color;
  final double animation;

  _IslamicPatternPainter({
    required this.color,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 4;

    // رسم نجمة ثمانية
    _drawEightPointedStar(canvas, center, radius, paint);
    
    // رسم دوائر متداخلة
    for (int i = 1; i <= 3; i++) {
      canvas.drawCircle(
        center,
        radius * i / 3,
        paint..color = color.withValues(alpha: 0.3 + (animation * 0.4)),
      );
    }
  }

  void _drawEightPointedStar(Canvas canvas, Offset center, double radius, Paint paint) {
    final path = Path();
    const int points = 8;
    const double angle = 2 * math.pi / points;
    
    for (int i = 0; i < points; i++) {
      final outerAngle = i * angle - math.pi / 2 + (animation * math.pi / 4);
      final innerAngle = (i + 0.5) * angle - math.pi / 2 + (animation * math.pi / 4);
      
      final outerX = center.dx + radius * math.cos(outerAngle);
      final outerY = center.dy + radius * math.sin(outerAngle);
      
      final innerX = center.dx + (radius * 0.6) * math.cos(innerAngle);
      final innerY = center.dy + (radius * 0.6) * math.sin(innerAngle);
      
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