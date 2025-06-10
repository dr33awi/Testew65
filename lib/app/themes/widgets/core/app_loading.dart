// lib/app/themes/widgets/core/app_loading.dart
import 'package:flutter/material.dart';
import '../../theme_constants.dart';
import '../../text_styles.dart';

/// أنواع مؤشرات التحميل
enum LoadingType {
  circular,
  linear,
  dots,
  fade,
  pulse,
}

/// أحجام مؤشرات التحميل
enum LoadingSize {
  small,
  medium,
  large,
}

/// مؤشر تحميل موحد
class AppLoading extends StatelessWidget {
  final LoadingType type;
  final LoadingSize size;
  final String? message;
  final Color? color;
  final double? value;
  final bool showBackground;
  final double? strokeWidth;

  const AppLoading({
    super.key,
    this.type = LoadingType.circular,
    this.size = LoadingSize.medium,
    this.message,
    this.color,
    this.value,
    this.showBackground = false,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.primaryColor;
    
    Widget loadingIndicator;
    
    switch (type) {
      case LoadingType.circular:
        loadingIndicator = _buildCircular(effectiveColor);
        break;
      case LoadingType.linear:
        loadingIndicator = _buildLinear(effectiveColor);
        break;
      case LoadingType.dots:
        loadingIndicator = _buildDots(effectiveColor);
        break;
      case LoadingType.fade:
        loadingIndicator = _buildFade(effectiveColor);
        break;
      case LoadingType.pulse:
        loadingIndicator = _buildPulse(effectiveColor);
        break;
    }

    // إضافة الرسالة إذا وجدت
    if (message != null) {
      loadingIndicator = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loadingIndicator,
          const SizedBox(height: ThemeConstants.space4),
          Text(
            message!,
            style: AppTextStyles.body2.copyWith(
              color: showBackground 
                  ? effectiveColor 
                  : theme.textTheme.bodyMedium?.color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    // إضافة خلفية إذا طُلبت
    if (showBackground) {
      return Container(
        padding: const EdgeInsets.all(ThemeConstants.space6),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
          boxShadow: ThemeConstants.shadowLg,
        ),
        child: loadingIndicator,
      );
    }

    return Center(child: loadingIndicator);
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
      ),
    );
  }

  Widget _buildDots(Color color) {
    return DotsLoadingIndicator(
      color: color,
      size: size,
    );
  }

  Widget _buildFade(Color color) {
    return FadeLoadingIndicator(
      color: color,
      size: _getSize(),
    );
  }

  Widget _buildPulse(Color color) {
    return PulseLoadingIndicator(
      color: color,
      size: _getSize(),
    );
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

  // Factory constructors
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
  }) {
    return AppLoading(
      type: LoadingType.linear,
      size: size,
      color: color,
      value: value,
    );
  }

  factory AppLoading.page({
    String? message,
    LoadingType type = LoadingType.circular,
  }) {
    return AppLoading(
      type: type,
      size: LoadingSize.large,
      message: message,
      showBackground: true,
    );
  }
}

/// مؤشر تحميل بنقاط متحركة
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
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat();

    _animations = List.generate(3, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2,
            0.6 + index * 0.2,
            curve: Curves.easeInOut,
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
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: widget.color.withValues(
                  alpha: 0.3 + _animations[index].value * 0.7
                ),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}

/// مؤشر تحميل بتلاشي
class FadeLoadingIndicator extends StatefulWidget {
  final Color color;
  final double size;

  const FadeLoadingIndicator({
    super.key,
    required this.color,
    required this.size,
  });

  @override
  State<FadeLoadingIndicator> createState() => _FadeLoadingIndicatorState();
}

class _FadeLoadingIndicatorState extends State<FadeLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
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
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: _animation.value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

/// مؤشر تحميل بنبضات
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

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
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
            ),
          ),
        );
      },
    );
  }
}