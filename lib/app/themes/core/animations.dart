// lib/app/themes/core/animations.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// نظام الحركات والتأثيرات البصرية الموحد للتطبيق الإسلامي
/// يوفر تأثيرات حركية متسقة وسلسة مع طابع إسلامي أنيق
class AppAnimations {
  AppAnimations._();

  // ==================== المدد الزمنية ====================
  
  /// مدد زمنية معيارية للحركات
  static const Duration ultraFast = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration extraSlow = Duration(milliseconds: 800);
  static const Duration ultraSlow = Duration(milliseconds: 1200);

  // ==================== المنحنيات ====================
  
  /// منحنيات مخصصة للتطبيق الإسلامي
  static const Curve smooth = Curves.easeInOutCubic;
  static const Curve gentle = Curves.easeInOut;
  static const Curve spring = Curves.elasticOut;
  static const Curve bounce = Curves.bounceOut;
  static const Curve quick = Curves.easeOutQuart;
  static const Curve entrance = Curves.easeOutBack;
  static const Curve exit = Curves.easeInBack;

  /// منحنى مخصص للطابع الإسلامي (ناعم ومريح)
  static const Curve islamic = Cubic(0.25, 0.46, 0.45, 0.94);

  // ==================== تأثيرات الانتقال ====================
  
  /// انتقال تدريجي للصفحات
  static PageRouteBuilder<T> slideTransition<T>({
    required Widget page,
    SlideDirection direction = SlideDirection.right,
    Duration duration = normal,
    Curve curve = smooth,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetAnimation = Tween<Offset>(
          begin: _getSlideOffset(direction),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: curve));

        final exitAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: _getSlideOffset(_getOppositeDirection(direction)),
        ).animate(CurvedAnimation(parent: secondaryAnimation, curve: curve));

        return SlideTransition(
          position: offsetAnimation,
          child: SlideTransition(
            position: exitAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// انتقال بتلاشي
  static PageRouteBuilder<T> fadeTransition<T>({
    required Widget page,
    Duration duration = normal,
    Curve curve = gentle,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: curve),
          child: child,
        );
      },
    );
  }

  /// انتقال بتكبير (مناسب للنوافذ الإسلامية)
  static PageRouteBuilder<T> scaleTransition<T>({
    required Widget page,
    Duration duration = normal,
    Curve curve = entrance,
    Alignment alignment = Alignment.center,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: curve),
          alignment: alignment,
          child: child,
        );
      },
    );
  }

  /// انتقال دوراني لطيف (للقبلة والتسبيح)
  static PageRouteBuilder<T> rotationTransition<T>({
    required Widget page,
    Duration duration = slow,
    Curve curve = islamic,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return RotationTransition(
          turns: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: curve),
          ),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  // ==================== تأثيرات الـ Widgets ====================
  
  /// تأثير الضغط المتحرك
  static Widget pressEffect({
    required Widget child,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    double scaleFactor = 0.95,
    Duration duration = fast,
    bool hapticFeedback = true,
  }) {
    return _AnimatedPress(
      onTap: onTap,
      onLongPress: onLongPress,
      scaleFactor: scaleFactor,
      duration: duration,
      hapticFeedback: hapticFeedback,
      child: child,
    );
  }

  /// تأثير الظهور التدريجي
  static Widget fadeIn({
    required Widget child,
    Duration duration = normal,
    Curve curve = gentle,
    Duration delay = Duration.zero,
  }) {
    return _FadeInAnimation(
      duration: duration,
      curve: curve,
      delay: delay,
      child: child,
    );
  }

  /// تأثير الانزلاق للداخل
  static Widget slideIn({
    required Widget child,
    SlideDirection direction = SlideDirection.bottom,
    Duration duration = normal,
    Curve curve = entrance,
    Duration delay = Duration.zero,
  }) {
    return _SlideInAnimation(
      direction: direction,
      duration: duration,
      curve: curve,
      delay: delay,
      child: child,
    );
  }

  /// تأثير التكبير التدريجي
  static Widget scaleIn({
    required Widget child,
    Duration duration = normal,
    Curve curve = spring,
    Duration delay = Duration.zero,
    double initialScale = 0.0,
  }) {
    return _ScaleInAnimation(
      duration: duration,
      curve: curve,
      delay: delay,
      initialScale: initialScale,
      child: child,
    );
  }

  /// تأثير الاهتزاز اللطيف
  static Widget shake({
    required Widget child,
    Duration duration = fast,
    double intensity = 5.0,
  }) {
    return _ShakeAnimation(
      duration: duration,
      intensity: intensity,
      child: child,
    );
  }

  /// تأثير النبض (للتنبيهات المهمة)
  static Widget pulse({
    required Widget child,
    Duration duration = slow,
    double minScale = 0.95,
    double maxScale = 1.05,
    bool repeat = true,
  }) {
    return _PulseAnimation(
      duration: duration,
      minScale: minScale,
      maxScale: maxScale,
      repeat: repeat,
      child: child,
    );
  }

  /// تأثير الوميض (للإشعارات)
  static Widget blink({
    required Widget child,
    Duration duration = normal,
    bool repeat = true,
    int repeatCount = 3,
  }) {
    return _BlinkAnimation(
      duration: duration,
      repeat: repeat,
      repeatCount: repeatCount,
      child: child,
    );
  }

  // ==================== تأثيرات خاصة بالتطبيق الإسلامي ====================
  
  /// تأثير ظهور الآيات (من اليمين مع تلاشي)
  static Widget verseReveal({
    required Widget child,
    Duration duration = slow,
    Duration delay = Duration.zero,
  }) {
    return _VerseRevealAnimation(
      duration: duration,
      delay: delay,
      child: child,
    );
  }

  /// تأثير عد التسبيح (تكبير مع نبض)
  static Widget tasbihCount({
    required Widget child,
    Duration duration = fast,
    VoidCallback? onComplete,
  }) {
    return _TasbihCountAnimation(
      duration: duration,
      onComplete: onComplete,
      child: child,
    );
  }

  /// تأثير دوران القبلة
  static Widget qiblaRotation({
    required Widget child,
    double angle = 0.0,
    Duration duration = normal,
  }) {
    return _QiblaRotationAnimation(
      angle: angle,
      duration: duration,
      child: child,
    );
  }

  /// تأثير موجة الصلاة (انتشار دائري)
  static Widget prayerWave({
    required Widget child,
    Duration duration = extraSlow,
    Color color = Colors.blue,
  }) {
    return _PrayerWaveAnimation(
      duration: duration,
      color: color,
      child: child,
    );
  }

  // ==================== تأثيرات القوائم ====================
  
  /// تأثير ظهور عناصر القائمة تدريجياً
  static Widget staggeredList({
    required List<Widget> children,
    Duration itemDelay = const Duration(milliseconds: 100),
    Duration itemDuration = normal,
    SlideDirection direction = SlideDirection.bottom,
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        
        return slideIn(
          direction: direction,
          duration: itemDuration,
          delay: Duration(milliseconds: itemDelay.inMilliseconds * index),
          child: child,
        );
      }).toList(),
    );
  }

  // ==================== المساعدات الداخلية ====================
  
  static Offset _getSlideOffset(SlideDirection direction) {
    return switch (direction) {
      SlideDirection.left => const Offset(-1.0, 0.0),
      SlideDirection.right => const Offset(1.0, 0.0),
      SlideDirection.top => const Offset(0.0, -1.0),
      SlideDirection.bottom => const Offset(0.0, 1.0),
    };
  }

  static SlideDirection _getOppositeDirection(SlideDirection direction) {
    return switch (direction) {
      SlideDirection.left => SlideDirection.right,
      SlideDirection.right => SlideDirection.left,
      SlideDirection.top => SlideDirection.bottom,
      SlideDirection.bottom => SlideDirection.top,
    };
  }
}

/// اتجاهات الانزلاق
enum SlideDirection { left, right, top, bottom }

// ==================== الـ Widgets المتحركة ====================

/// ويدجت الضغط المتحرك
class _AnimatedPress extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double scaleFactor;
  final Duration duration;
  final bool hapticFeedback;

  const _AnimatedPress({
    required this.child,
    this.onTap,
    this.onLongPress,
    required this.scaleFactor,
    required this.duration,
    required this.hapticFeedback,
  });

  @override
  State<_AnimatedPress> createState() => _AnimatedPressState();
}

class _AnimatedPressState extends State<_AnimatedPress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.scaleFactor,
    ).animate(CurvedAnimation(parent: _controller, curve: AppAnimations.gentle));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
    if (widget.hapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// ويدجت التلاشي التدريجي
class _FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Duration delay;

  const _FadeInAnimation({
    required this.child,
    required this.duration,
    required this.curve,
    required this.delay,
  });

  @override
  State<_FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<_FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

/// ويدجت الانزلاق التدريجي
class _SlideInAnimation extends StatefulWidget {
  final Widget child;
  final SlideDirection direction;
  final Duration duration;
  final Curve curve;
  final Duration delay;

  const _SlideInAnimation({
    required this.child,
    required this.direction,
    required this.duration,
    required this.curve,
    required this.delay,
  });

  @override
  State<_SlideInAnimation> createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<_SlideInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    
    _slideAnimation = Tween<Offset>(
      begin: AppAnimations._getSlideOffset(widget.direction),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: widget.curve);

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}

/// ويدجت التكبير التدريجي
class _ScaleInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Duration delay;
  final double initialScale;

  const _ScaleInAnimation({
    required this.child,
    required this.duration,
    required this.curve,
    required this.delay,
    required this.initialScale,
  });

  @override
  State<_ScaleInAnimation> createState() => _ScaleInAnimationState();
}

class _ScaleInAnimationState extends State<_ScaleInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _scaleAnimation = Tween<double>(
      begin: widget.initialScale,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: widget.curve));

    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}

/// ويدجت الاهتزاز
class _ShakeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double intensity;

  const _ShakeAnimation({
    required this.child,
    required this.duration,
    required this.intensity,
  });

  @override
  State<_ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<_ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
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
        final offset = Offset(
          widget.intensity * (0.5 - (_animation.value * 4) % 1).abs() * 
          ((_animation.value * 4).floor() % 2 == 0 ? 1 : -1),
          0,
        );
        return Transform.translate(
          offset: offset,
          child: widget.child,
        );
      },
    );
  }
}

/// ويدجت النبض
class _PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool repeat;

  const _PulseAnimation({
    required this.child,
    required this.duration,
    required this.minScale,
    required this.maxScale,
    required this.repeat,
  });

  @override
  State<_PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(CurvedAnimation(parent: _controller, curve: AppAnimations.gentle));

    if (widget.repeat) {
      _controller.repeat(reverse: true);
    } else {
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
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

/// ويدجت الوميض
class _BlinkAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool repeat;
  final int repeatCount;

  const _BlinkAnimation({
    required this.child,
    required this.duration,
    required this.repeat,
    required this.repeatCount,
  });

  @override
  State<_BlinkAnimation> createState() => _BlinkAnimationState();
}

class _BlinkAnimationState extends State<_BlinkAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);

    if (widget.repeat) {
      _controller.repeat(reverse: true);
    } else {
      _startBlinking();
    }
  }

  void _startBlinking() async {
    for (int i = 0; i < widget.repeatCount; i++) {
      await _controller.forward();
      await _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

// ==================== تأثيرات إسلامية خاصة ====================

/// تأثير ظهور الآيات
class _VerseRevealAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;

  const _VerseRevealAnimation({
    required this.child,
    required this.duration,
    required this.delay,
  });

  @override
  State<_VerseRevealAnimation> createState() => _VerseRevealAnimationState();
}

class _VerseRevealAnimationState extends State<_VerseRevealAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0), // من اليمين
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: AppAnimations.islamic));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: AppAnimations.gentle);

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}

/// تأثير عد التسبيح
class _TasbihCountAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback? onComplete;

  const _TasbihCountAnimation({
    required this.child,
    required this.duration,
    this.onComplete,
  });

  @override
  State<_TasbihCountAnimation> createState() => _TasbihCountAnimationState();
}

class _TasbihCountAnimationState extends State<_TasbihCountAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: AppAnimations.bounce));

    _controller.forward().then((_) {
      _controller.reverse().then((_) {
        widget.onComplete?.call();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}

/// تأثير دوران القبلة
class _QiblaRotationAnimation extends StatefulWidget {
  final Widget child;
  final double angle;
  final Duration duration;

  const _QiblaRotationAnimation({
    required this.child,
    required this.angle,
    required this.duration,
  });

  @override
  State<_QiblaRotationAnimation> createState() => _QiblaRotationAnimationState();
}

class _QiblaRotationAnimationState extends State<_QiblaRotationAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  double _previousAngle = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _updateAnimation();
  }

  void _updateAnimation() {
    _rotationAnimation = Tween<double>(
      begin: _previousAngle,
      end: widget.angle,
    ).animate(CurvedAnimation(parent: _controller, curve: AppAnimations.islamic));
    
    _controller.forward();
  }

  @override
  void didUpdateWidget(_QiblaRotationAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.angle != widget.angle) {
      _previousAngle = _rotationAnimation.value;
      _controller.reset();
      _updateAnimation();
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
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// تأثير موجة الصلاة
class _PrayerWaveAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Color color;

  const _PrayerWaveAnimation({
    required this.child,
    required this.duration,
    required this.color,
  });

  @override
  State<_PrayerWaveAnimation> createState() => _PrayerWaveAnimationState();
}

class _PrayerWaveAnimationState extends State<_PrayerWaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this);
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.repeat();
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
          painter: _WavePainter(
            progress: _animation.value,
            color: widget.color,
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// رسام الموجة
class _WavePainter extends CustomPainter {
  final double progress;
  final Color color;

  _WavePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.3 * (1 - progress))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * progress;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}