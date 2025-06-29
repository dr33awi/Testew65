// lib/app/themes/widgets/background_effects.dart - خلفيات وتأثيرات بصرية متقدمة
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:athkar_app/app/themes/app_theme.dart';

/// نظام الخلفيات والتأثيرات البصرية المتقدمة
class BackgroundEffects {
  BackgroundEffects._();

  /// خلفية متدرجة مع تأثيرات متحركة
  static Widget animatedGradientBackground({
    List<Color>? colors,
    Duration duration = const Duration(seconds: 8),
    Widget? child,
  }) {
    return _AnimatedGradientBackground(
      colors: colors ?? [
        AppTheme.background,
        AppTheme.surface,
        AppTheme.primaryDark.withValues(alpha: 0.1),
        AppTheme.secondaryDark.withValues(alpha: 0.1),
      ],
      duration: duration,
      child: child,
    );
  }

  /// تأثير الجسيمات العائمة
  static Widget floatingParticles({
    int particleCount = 50,
    List<Color>? colors,
    double minSize = 2.0,
    double maxSize = 8.0,
    Widget? child,
  }) {
    return _FloatingParticles(
      particleCount: particleCount,
      colors: colors ?? [
        AppTheme.primary.withValues(alpha: 0.3),
        AppTheme.secondary.withValues(alpha: 0.2),
        AppTheme.tertiary.withValues(alpha: 0.1),
      ],
      minSize: minSize,
      maxSize: maxSize,
      child: child,
    );
  }

  /// تأثير الموجات المتحركة
  static Widget wavesEffect({
    Color? waveColor,
    double amplitude = 20.0,
    double frequency = 0.02,
    Duration duration = const Duration(seconds: 6),
    Widget? child,
  }) {
    return _WavesEffect(
      waveColor: waveColor ?? AppTheme.primary.withValues(alpha: 0.1),
      amplitude: amplitude,
      frequency: frequency,
      duration: duration,
      child: child,
    );
  }

  /// خلفية إسلامية بأنماط هندسية
  static Widget islamicPatterns({
    Color? patternColor,
    double opacity = 0.05,
    double scale = 1.0,
    Widget? child,
  }) {
    return _IslamicPatterns(
      patternColor: patternColor ?? AppTheme.primary,
      opacity: opacity,
      scale: scale,
      child: child,
    );
  }

  /// تأثير Aurora (الشفق القطبي)
  static Widget auroraEffect({
    List<Color>? colors,
    Duration duration = const Duration(seconds: 12),
    Widget? child,
  }) {
    return _AuroraEffect(
      colors: colors ?? [
        AppTheme.primary.withValues(alpha: 0.2),
        AppTheme.secondary.withValues(alpha: 0.15),
        AppTheme.tertiary.withValues(alpha: 0.1),
      ],
      duration: duration,
      child: child,
    );
  }

  /// خلفية ليلية مع نجوم متلألئة
  static Widget starryNight({
    int starCount = 100,
    Widget? child,
  }) {
    return _StarryNight(
      starCount: starCount,
      child: child,
    );
  }
}

// ========== الخلفية المتدرجة المتحركة ==========

class _AnimatedGradientBackground extends StatefulWidget {
  final List<Color> colors;
  final Duration duration;
  final Widget? child;

  const _AnimatedGradientBackground({
    required this.colors,
    required this.duration,
    this.child,
  });

  @override
  State<_AnimatedGradientBackground> createState() => _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState extends State<_AnimatedGradientBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
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
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.lerp(
                Alignment.topLeft,
                Alignment.bottomRight,
                _animation.value,
              )!,
              radius: 1.5 + (_animation.value * 0.5),
              colors: widget.colors,
              stops: [
                0.0,
                0.3 + (_animation.value * 0.2),
                0.7 + (_animation.value * 0.15),
                1.0,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

// ========== الجسيمات العائمة ==========

class _FloatingParticles extends StatefulWidget {
  final int particleCount;
  final List<Color> colors;
  final double minSize;
  final double maxSize;
  final Widget? child;

  const _FloatingParticles({
    required this.particleCount,
    required this.colors,
    required this.minSize,
    required this.maxSize,
    this.child,
  });

  @override
  State<_FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<_FloatingParticles>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Particle> _particles;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _initializeParticles();
    _controller.repeat();
  }

  void _initializeParticles() {
    final random = math.Random();
    _particles = List.generate(widget.particleCount, (index) {
      return Particle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: widget.minSize + (random.nextDouble() * (widget.maxSize - widget.minSize)),
        color: widget.colors[random.nextInt(widget.colors.length)],
        speed: 0.1 + (random.nextDouble() * 0.3),
        direction: random.nextDouble() * 2 * math.pi,
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
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlesPainter(
                  particles: _particles,
                  animationValue: _controller.value,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Particle {
  double x;
  double y;
  final double size;
  final Color color;
  final double speed;
  final double direction;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speed,
    required this.direction,
  });
}

class ParticlesPainter extends CustomPainter {
  final List<Particle> particles;
  final double animationValue;

  ParticlesPainter({
    required this.particles,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      // تحديث موقع الجسيم
      particle.x += math.cos(particle.direction) * particle.speed * 0.01;
      particle.y += math.sin(particle.direction) * particle.speed * 0.01;

      // إعادة تعيين الموقع إذا خرج من الحدود
      if (particle.x > 1.1) particle.x = -0.1;
      if (particle.x < -0.1) particle.x = 1.1;
      if (particle.y > 1.1) particle.y = -0.1;
      if (particle.y < -0.1) particle.y = 1.1;

      // رسم الجسيم
      final paint = Paint()
        ..color = particle.color.withValues(
          alpha: particle.color.alpha * (0.3 + 0.7 * math.sin(animationValue * 2 * math.pi)),
        )
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(
          particle.x * size.width,
          particle.y * size.height,
        ),
        particle.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ========== تأثير الموجات ==========

class _WavesEffect extends StatefulWidget {
  final Color waveColor;
  final double amplitude;
  final double frequency;
  final Duration duration;
  final Widget? child;

  const _WavesEffect({
    required this.waveColor,
    required this.amplitude,
    required this.frequency,
    required this.duration,
    this.child,
  });

  @override
  State<_WavesEffect> createState() => _WavesEffectState();
}

class _WavesEffectState extends State<_WavesEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(_controller);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return CustomPaint(
                painter: WavesPainter(
                  waveColor: widget.waveColor,
                  amplitude: widget.amplitude,
                  frequency: widget.frequency,
                  phase: _animation.value,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class WavesPainter extends CustomPainter {
  final Color waveColor;
  final double amplitude;
  final double frequency;
  final double phase;

  WavesPainter({
    required this.waveColor,
    required this.amplitude,
    required this.frequency,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    
    // رسم عدة موجات بمراحل مختلفة
    for (int wave = 0; wave < 3; wave++) {
      path.reset();
      final wavePhase = phase + (wave * math.pi / 3);
      
      for (double x = 0; x <= size.width; x += 2) {
        final y = size.height * 0.5 + 
            amplitude * math.sin((x * frequency) + wavePhase) +
            (amplitude * 0.5) * math.sin((x * frequency * 2) + wavePhase);
        
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      
      paint.color = waveColor.withValues(alpha: waveColor.alpha * (0.3 + wave * 0.2));
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ========== الأنماط الإسلامية ==========

class _IslamicPatterns extends StatelessWidget {
  final Color patternColor;
  final double opacity;
  final double scale;
  final Widget? child;

  const _IslamicPatterns({
    required this.patternColor,
    required this.opacity,
    required this.scale,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: IslamicPatternsPainter(
              patternColor: patternColor.withValues(alpha: opacity),
              scale: scale,
            ),
          ),
        ),
        if (child != null) child!,
      ],
    );
  }
}

class IslamicPatternsPainter extends CustomPainter {
  final Color patternColor;
  final double scale;

  IslamicPatternsPainter({
    required this.patternColor,
    required this.scale,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = patternColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final patternSize = 100.0 * scale;
    
    // رسم شبكة من الأنماط الإسلامية
    for (double x = 0; x < size.width + patternSize; x += patternSize) {
      for (double y = 0; y < size.height + patternSize; y += patternSize) {
        _drawIslamicStar(canvas, Offset(x, y), patternSize / 2, paint);
      }
    }
  }

  void _drawIslamicStar(Canvas canvas, Offset center, double radius, Paint paint) {
    const int points = 8;
    final path = Path();
    
    for (int i = 0; i < points; i++) {
      final angle = (i * 2 * math.pi) / points;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.close();
    canvas.drawPath(path, paint);
    
    // رسم دائرة في المنتصف
    canvas.drawCircle(center, radius * 0.3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ========== تأثير Aurora ==========

class _AuroraEffect extends StatefulWidget {
  final List<Color> colors;
  final Duration duration;
  final Widget? child;

  const _AuroraEffect({
    required this.colors,
    required this.duration,
    this.child,
  });

  @override
  State<_AuroraEffect> createState() => _AuroraEffectState();
}

class _AuroraEffectState extends State<_AuroraEffect>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _controllers = List.generate(3, (index) {
      final controller = AnimationController(
        duration: Duration(milliseconds: widget.duration.inMilliseconds + (index * 2000)),
        vsync: this,
      );
      controller.repeat(reverse: true);
      return controller;
    });
    
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) widget.child!,
        ...List.generate(3, (index) {
          return Positioned.fill(
            child: AnimatedBuilder(
              animation: _controllers[index],
              builder: (context, child) {
                return CustomPaint(
                  painter: AuroraPainter(
                    colors: widget.colors,
                    animationValue: _controllers[index].value,
                    layer: index,
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}

class AuroraPainter extends CustomPainter {
  final List<Color> colors;
  final double animationValue;
  final int layer;

  AuroraPainter({
    required this.colors,
    required this.animationValue,
    required this.layer,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..blendMode = BlendMode.screen;

    final path = Path();
    final waveHeight = size.height * 0.3;
    final waveOffset = layer * size.height * 0.1;
    
    path.moveTo(0, size.height);
    
    for (double x = 0; x <= size.width; x += 5) {
      final y = size.height - waveHeight - waveOffset +
          (waveHeight * 0.5) * math.sin((x / size.width * 4 * math.pi) + (animationValue * 2 * math.pi)) +
          (waveHeight * 0.3) * math.cos((x / size.width * 6 * math.pi) + (animationValue * 3 * math.pi));
      
      path.lineTo(x, y);
    }
    
    path.lineTo(size.width, size.height);
    path.close();
    
    paint.shader = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        colors[layer % colors.length].withValues(alpha: 0.3 * animationValue),
        colors[layer % colors.length].withValues(alpha: 0.1 * animationValue),
        Colors.transparent,
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ========== الليلة النجمية ==========

class _StarryNight extends StatefulWidget {
  final int starCount;
  final Widget? child;

  const _StarryNight({
    required this.starCount,
    this.child,
  });

  @override
  State<_StarryNight> createState() => _StarryNightState();
}

class _StarryNightState extends State<_StarryNight>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Star> _stars;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _initializeStars();
    _controller.repeat();
  }

  void _initializeStars() {
    final random = math.Random();
    _stars = List.generate(widget.starCount, (index) {
      return Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 1.0 + (random.nextDouble() * 3.0),
        twinkleSpeed: 0.5 + (random.nextDouble() * 1.5),
        brightness: 0.3 + (random.nextDouble() * 0.7),
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
    return Stack(
      children: [
        // خلفية متدرجة ليلية
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.topCenter,
              radius: 2.0,
              colors: [
                Color(0xFF0F172A),
                Color(0xFF020617),
                Color(0xFF000000),
              ],
            ),
          ),
        ),
        if (widget.child != null) widget.child!,
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: StarsPainter(
                  stars: _stars,
                  animationValue: _controller.value,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class Star {
  final double x;
  final double y;
  final double size;
  final double twinkleSpeed;
  final double brightness;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.twinkleSpeed,
    required this.brightness,
  });
}

class StarsPainter extends CustomPainter {
  final List<Star> stars;
  final double animationValue;

  StarsPainter({
    required this.stars,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final star in stars) {
      final twinkle = (math.sin(animationValue * 2 * math.pi * star.twinkleSpeed) + 1) / 2;
      final alpha = star.brightness * twinkle;
      
      final paint = Paint()
        ..color = Colors.white.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      final center = Offset(
        star.x * size.width,
        star.y * size.height,
      );

      // رسم النجمة
      if (star.size > 2.5) {
        _drawStar(canvas, center, star.size, paint);
      } else {
        canvas.drawCircle(center, star.size, paint);
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    const int points = 5;
    final outerRadius = size;
    final innerRadius = size * 0.4;
    
    for (int i = 0; i < points * 2; i++) {
      final angle = (i * math.pi) / points - math.pi / 2;
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// ========== عنصر خلفية شامل ==========

/// عنصر خلفية شامل يجمع جميع التأثيرات
class EnhancedBackground extends StatelessWidget {
  final Widget child;
  final bool enableGradient;
  final bool enableParticles;
  final bool enableWaves;
  final bool enablePatterns;
  final bool enableAurora;
  final bool enableStars;
  final double effectsIntensity;

  const EnhancedBackground({
    super.key,
    required this.child,
    this.enableGradient = true,
    this.enableParticles = false,
    this.enableWaves = false,
    this.enablePatterns = true,
    this.enableAurora = false,
    this.enableStars = false,
    this.effectsIntensity = 1.0,
  });

  /// خلفية للصفحة الرئيسية
  factory EnhancedBackground.home({
    required Widget child,
  }) {
    return EnhancedBackground(
      enableGradient: true,
      enableParticles: true,
      enablePatterns: true,
      effectsIntensity: 0.7,
      child: child,
    );
  }

  /// خلفية للأذكار
  factory EnhancedBackground.athkar({
    required Widget child,
  }) {
    return EnhancedBackground(
      enableGradient: true,
      enableWaves: true,
      enablePatterns: true,
      effectsIntensity: 0.5,
      child: child,
    );
  }

  /// خلفية ليلية
  factory EnhancedBackground.night({
    required Widget child,
  }) {
    return EnhancedBackground(
      enableStars: true,
      enableAurora: true,
      effectsIntensity: 0.8,
      child: child,
    );
  }

  /// خلفية للقبلة
  factory EnhancedBackground.qibla({
    required Widget child,
  }) {
    return EnhancedBackground(
      enableGradient: true,
      enableParticles: true,
      effectsIntensity: 0.6,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget background = Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.backgroundGradient,
      ),
    );

    if (enableStars) {
      background = BackgroundEffects.starryNight(
        starCount: (100 * effectsIntensity).round(),
        child: background,
      );
    }

    if (enableGradient && !enableStars) {
      background = BackgroundEffects.animatedGradientBackground(
        duration: Duration(seconds: (8 / effectsIntensity).round()),
        child: background,
      );
    }

    if (enableAurora) {
      background = BackgroundEffects.auroraEffect(
        duration: Duration(seconds: (12 / effectsIntensity).round()),
        child: background,
      );
    }

    if (enableWaves) {
      background = BackgroundEffects.wavesEffect(
        amplitude: 20.0 * effectsIntensity,
        duration: Duration(seconds: (6 / effectsIntensity).round()),
        child: background,
      );
    }

    if (enablePatterns) {
      background = BackgroundEffects.islamicPatterns(
        opacity: 0.05 * effectsIntensity,
        scale: effectsIntensity,
        child: background,
      );
    }

    if (enableParticles) {
      background = BackgroundEffects.floatingParticles(
        particleCount: (50 * effectsIntensity).round(),
        child: background,
      );
    }

    return Stack(
      children: [
        background,
        child,
      ],
    );
  }
}