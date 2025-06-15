// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';
import '../widgets/category_grid.dart';
import '../widgets/quick_stats_card.dart';
import '../../prayer_times/widgets/home_prayer_times_card.dart';
import '../widgets/welcome_message.dart';
import '../widgets/daily_quotes_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _patternController;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
      });
    
    _patternController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
    
    _fadeController = AnimationController(
      duration: ThemeConstants.durationSlow,
      vsync: this,
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: ThemeConstants.curveSmooth,
    );
    
    _fadeController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _patternController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Stack(
        children: [
          // خلفية متدرجة مع نمط زخرفي
          _buildAnimatedBackground(),
          
          // المحتوى الرئيسي
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // شريط علوي مخصص
              _buildCustomAppBar(),
              
              // رسالة الترحيب
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const WelcomeMessage(),
                ),
              ),
              
              // بطاقة مواقيت الصلاة
              SliverToBoxAdapter(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const PrayerTimesCard(),
                ),
              ),

              // بطاقة الاقتباسات اليومية
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: ThemeConstants.space4),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: const DailyQuotesCard(),
                  ),
                ),
              ),
              
              // الإحصائيات السريعة
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: ThemeConstants.space4),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: QuickStatsCard(
                      dailyProgress: 75,
                      lastReadTime: '٨:٣٠ ص',
                      onStatTap: (stat) {
                        context.showInfoSnackBar('تم النقر على: $stat');
                      },
                    ),
                  ),
                ),
              ),
              
              // عنوان الأقسام
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    ThemeConstants.space4,
                    ThemeConstants.space6,
                    ThemeConstants.space4,
                    ThemeConstants.space3,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: ThemeConstants.primaryGradient,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      ThemeConstants.space3.w,
                      Text(
                        'الأقسام الرئيسية',
                        style: context.headlineSmall?.copyWith(
                          fontWeight: ThemeConstants.bold,
                          color: context.textPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // شبكة الفئات
              const CategoryGrid(),
              
              // مساحة في الأسفل
              SliverToBoxAdapter(
                child: ThemeConstants.space10.h,
              ),
            ],
          ),
          
          // أزرار جانبية عائمة
          _buildFloatingButtons(),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _patternController,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: context.isDarkMode
                ? ThemeConstants.darkBackgroundGradient
                : ThemeConstants.backgroundGradient,
          ),
          child: Stack(
            children: [
              // نمط زخرفي متحرك
              Positioned.fill(
                child: CustomPaint(
                  painter: IslamicPatternPainter(
                    color: context.primaryColor.withOpacity(0.03),
                    animation: _patternController.value,
                  ),
                ),
              ),
              
              // تأثير blur للخلفية
              if (_scrollOffset > 100)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: _scrollOffset / 50,
                      sigmaY: _scrollOffset / 50,
                    ),
                    child: Container(
                      color: context.backgroundColor.withOpacity(0.3),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomAppBar() {
    final expandedHeight = 140.0;
    final collapsedHeight = 80.0;
    final expandRatio = math.max(0, 1 - _scrollOffset / (expandedHeight - collapsedHeight));
    
    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context.primaryColor.withOpacity(0.1 + (0.2 * (1 - expandRatio))),
                Colors.transparent,
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // الشعار
                  AnimatedContainer(
                    duration: ThemeConstants.durationNormal,
                    width: 60.0 + (20.0 * expandRatio),
                    height: 60.0 + (20.0 * expandRatio),
                    decoration: BoxDecoration(
                      gradient: ThemeConstants.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: ThemeConstants.shadowLg,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.mosque,
                        color: Colors.white,
                        size: 30.0 + (10.0 * expandRatio),
                      ),
                    ),
                  ),
                  
                  // اسم التطبيق
                  AnimatedOpacity(
                    duration: ThemeConstants.durationFast,
                    opacity: expandRatio.toDouble(),
                    child: AnimatedContainer(
                      duration: ThemeConstants.durationNormal,
                      height: expandRatio > 0.5 ? 30.0 : 0.0,
                      child: Text(
                        'تطبيق الأذكار',
                        style: context.headlineMedium?.copyWith(
                          fontWeight: ThemeConstants.bold,
                          foreground: Paint()
                            ..shader = ThemeConstants.primaryGradient.createShader(
                              const Rect.fromLTWH(0, 0, 200, 70),
                            ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        _buildAppBarAction(
          icon: Icons.notifications_outlined,
          onPressed: () => Navigator.pushNamed(context, '/notifications'),
          badge: '3',
        ),
        _buildAppBarAction(
          icon: Icons.settings_outlined,
          onPressed: () => Navigator.pushNamed(context, '/settings'),
        ),
      ],
    );
  }

  Widget _buildAppBarAction({
    required IconData icon,
    required VoidCallback onPressed,
    String? badge,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: ThemeConstants.space2),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: Container(
                padding: const EdgeInsets.all(ThemeConstants.space2),
                decoration: BoxDecoration(
                  color: context.cardColor.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: context.textPrimaryColor,
                  size: ThemeConstants.iconMd,
                ),
              ),
            ),
          ),
          if (badge != null)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: ThemeConstants.accent,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFloatingButtons() {
    return Positioned(
      left: ThemeConstants.space4,
      bottom: ThemeConstants.space6,
      child: AnimatedOpacity(
        duration: ThemeConstants.durationNormal,
        opacity: _scrollOffset > 200 ? 1.0 : 0.0,
        child: AnimatedScale(
          duration: ThemeConstants.durationNormal,
          scale: _scrollOffset > 200 ? 1.0 : 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildFloatingButton(
                icon: Icons.favorite_outline,
                color: ThemeConstants.tertiary,
                onPressed: () => Navigator.pushNamed(context, '/favorites'),
                tooltip: 'المفضلة',
              ),
              ThemeConstants.space3.h,
              _buildFloatingButton(
                icon: Icons.assessment_outlined,
                color: ThemeConstants.accent,
                onPressed: () => Navigator.pushNamed(context, '/progress'),
                tooltip: 'التقدم',
              ),
              ThemeConstants.space3.h,
              _buildFloatingButton(
                icon: Icons.arrow_upward,
                color: context.primaryColor,
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: ThemeConstants.durationSlow,
                    curve: ThemeConstants.curveSmooth,
                  );
                },
                tooltip: 'الأعلى',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Material(
      elevation: ThemeConstants.elevation8,
      shape: const CircleBorder(),
      color: color,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Tooltip(
          message: tooltip,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  color.lighten(0.1),
                  color,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: ThemeConstants.iconMd,
            ),
          ),
        ),
      ),
    );
  }
}

// رسام النمط الإسلامي
class IslamicPatternPainter extends CustomPainter {
  final Color color;
  final double animation;

  IslamicPatternPainter({
    required this.color,
    required this.animation,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final double spacing = 80;
    final double rotation = animation * 2 * math.pi;

    // رسم شبكة من النجوم الإسلامية
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        canvas.save();
        canvas.translate(x, y);
        
        // دوران بطيء للنمط
        canvas.rotate(rotation * 0.1);
        
        // رسم نجمة ثمانية مع زخارف
        _drawComplexIslamicPattern(canvas, paint, 30);
        
        canvas.restore();
      }
    }
    
    // إضافة نمط ثانوي
    for (double x = spacing / 2; x < size.width + spacing; x += spacing) {
      for (double y = spacing / 2; y < size.height + spacing; y += spacing) {
        canvas.save();
        canvas.translate(x, y);
        canvas.rotate(-rotation * 0.05);
        
        _drawSecondaryPattern(canvas, paint..color = color.withOpacity(0.5), 20);
        
        canvas.restore();
      }
    }
  }

  void _drawComplexIslamicPattern(Canvas canvas, Paint paint, double radius) {
    // النجمة الثمانية الأساسية
    _drawIslamicStar(canvas, paint, radius, 8);
    
    // دائرة مركزية
    canvas.drawCircle(Offset.zero, radius / 3, paint);
    
    // زخارف إضافية
    for (int i = 0; i < 8; i++) {
      final angle = (i * math.pi / 4);
      final x = radius * 0.7 * math.cos(angle);
      final y = radius * 0.7 * math.sin(angle);
      
      canvas.drawCircle(Offset(x, y), radius / 6, paint);
    }
    
    // خطوط شعاعية
    for (int i = 0; i < 16; i++) {
      final angle = (i * math.pi / 8);
      final start = Offset(
        radius * 0.4 * math.cos(angle),
        radius * 0.4 * math.sin(angle),
      );
      final end = Offset(
        radius * 0.6 * math.cos(angle),
        radius * 0.6 * math.sin(angle),
      );
      
      canvas.drawLine(start, end, paint);
    }
  }

  void _drawSecondaryPattern(Canvas canvas, Paint paint, double radius) {
    // نمط الأرابيسك
    final path = Path();
    
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3);
      final x = radius * math.cos(angle);
      final y = radius * math.sin(angle);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    
    path.close();
    canvas.drawPath(path, paint);
    
    // زخرفة داخلية
    for (int i = 0; i < 6; i++) {
      final angle = (i * math.pi / 3) + (math.pi / 6);
      final innerRadius = radius * 0.5;
      final x = innerRadius * math.cos(angle);
      final y = innerRadius * math.sin(angle);
      
      canvas.drawCircle(Offset(x, y), radius / 8, paint);
    }
  }

  void _drawIslamicStar(Canvas canvas, Paint paint, double radius, int points) {
    final path = Path();
    final angle = (2 * math.pi) / points;
    
    for (int i = 0; i < points; i++) {
      final outerX = radius * math.cos(i * angle - math.pi / 2);
      final outerY = radius * math.sin(i * angle - math.pi / 2);
      
      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      
      // نقطة داخلية
      final innerAngle = (i + 0.5) * angle - math.pi / 2;
      final innerRadius = radius * 0.5;
      final innerX = innerRadius * math.cos(innerAngle);
      final innerY = innerRadius * math.sin(innerAngle);
      
      path.lineTo(innerX, innerY);
    }
    
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant IslamicPatternPainter oldDelegate) {
    return oldDelegate.animation != animation || oldDelegate.color != color;
  }
}