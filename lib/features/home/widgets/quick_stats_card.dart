// lib/features/home/widgets/quick_stats_section.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';

class QuickStatsSection extends StatefulWidget {
  const QuickStatsSection({super.key});

  @override
  State<QuickStatsSection> createState() => _QuickStatsSectionState();
}

class _QuickStatsSectionState extends State<QuickStatsSection>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late List<AnimationController> _cardControllers;
  
  // بيانات وهمية - يجب استبدالها ببيانات حقيقية
  final int dailyProgress = 75;
  final int todayAthkar = 12;
  final int weekStreak = 7;
  final int totalCount = 234;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _progressController = AnimationController(
      duration: ThemeConstants.durationExtraSlow,
      vsync: this,
    );

    _cardControllers = List.generate(4, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 800 + (index * 200)),
        vsync: this,
      );
    });

    // بدء الحركات بتأخير متدرج
    for (int i = 0; i < _cardControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) {
          _cardControllers[i].forward();
        }
      });
    }

    _progressController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _progressController.dispose();
    for (final controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم
          _buildSectionTitle(context),
          
          ThemeConstants.space4.h,
          
          // الإحصائيات
          SizedBox(
            height: 180,
            child: Row(
              children: [
                // بطاقة التقدم اليومي الرئيسية
                Expanded(
                  flex: 2,
                  child: _buildMainProgressCard(context),
                ),
                
                ThemeConstants.space3.w,
                
                // البطاقات الصغيرة
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildSmallStatCard(
                          context: context,
                          title: 'أذكار اليوم',
                          value: todayAthkar.toString(),
                          icon: Icons.auto_awesome,
                          gradient: [ThemeConstants.accent, ThemeConstants.accentLight],
                          index: 1,
                        ),
                      ),
                      
                      ThemeConstants.space3.h,
                      
                      Expanded(
                        child: _buildSmallStatCard(
                          context: context,
                          title: 'أيام متتالية',
                          value: weekStreak.toString(),
                          icon: Icons.local_fire_department,
                          gradient: [ThemeConstants.tertiary, ThemeConstants.tertiaryLight],
                          index: 2,
                          showStreak: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          ThemeConstants.space3.h,
          
          // بطاقة الإجمالي
          _buildTotalCard(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(ThemeConstants.space2),
          decoration: BoxDecoration(
            color: context.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: Icon(
            Icons.trending_up_rounded,
            color: context.primaryColor,
            size: ThemeConstants.iconMd,
          ),
        ),
        
        ThemeConstants.space3.w,
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'إحصائياتك اليوم',
                style: context.titleLarge?.copyWith(
                  fontWeight: ThemeConstants.bold,
                ),
              ),
              Text(
                'تتبع تقدمك الروحي',
                style: context.labelMedium?.copyWith(
                  color: context.textSecondaryColor,
                ),
              ),
            ],
          ),
        ),
        
        AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1.0 + (_pulseController.value * 0.1),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space3,
                  vertical: ThemeConstants.space1,
                ),
                decoration: BoxDecoration(
                  gradient: ThemeConstants.primaryGradient,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                ),
                child: Text(
                  'مستمر',
                  style: context.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.semiBold,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMainProgressCard(BuildContext context) {
    return AnimatedBuilder(
      animation: _cardControllers[0],
      builder: (context, child) {
        return Transform.scale(
          scale: _cardControllers[0].value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.primaryColor.withValues(alpha: 0.9),
                  context.primaryColor.darken(0.1).withValues(alpha: 0.9),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: context.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      // التنقل لصفحة الإحصائيات التفصيلية
                    },
                    borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                    child: Stack(
                      children: [
                        // خلفية زخرفية
                        _buildCardBackground(),
                        
                        // المحتوى
                        Padding(
                          padding: const EdgeInsets.all(ThemeConstants.space4),
                          child: _buildMainCardContent(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCardBackground() {
    return Positioned.fill(
      child: Stack(
        children: [
          // دوائر زخرفية
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          
          // خطوط زخرفية
          CustomPaint(
            painter: DecorationPainter(),
            size: Size.infinite,
          ),
        ],
      ),
    );
  }

  Widget _buildMainCardContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // مؤشر التقدم الدائري
        AnimatedBuilder(
          animation: _progressController,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // الدائرة الخارجية
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircularProgressIndicator(
                    value: (dailyProgress / 100) * _progressController.value,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                
                // النص في المنتصف
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(dailyProgress * _progressController.value).round()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '%',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
        
        ThemeConstants.space4.h,
        
        // النص التوضيحي
        Text(
          'إنجاز اليوم',
          style: context.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: ThemeConstants.bold,
          ),
        ),
        
        ThemeConstants.space1.h,
        
        Text(
          'أكمل اليوم بقوة! 💪',
          style: context.labelMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradient,
    required int index,
    bool showStreak = false,
  }) {
    return AnimatedBuilder(
      animation: _cardControllers[index],
      builder: (context, child) {
        return Transform.scale(
          scale: _cardControllers[index].value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient.map((c) => c.withValues(alpha: 0.9)).toList(),
              ),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                },
                borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                child: Stack(
                  children: [
                    // تأثير الشرر للخطوط المتتالية
                    if (showStreak)
                      Positioned(
                        top: -10,
                        right: -10,
                        child: AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _pulseController.value * 2 * math.pi,
                              child: Icon(
                                Icons.auto_awesome,
                                size: 30,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                            );
                          },
                        ),
                      ),
                    
                    // المحتوى
                    Padding(
                      padding: const EdgeInsets.all(ThemeConstants.space3),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // الأيقونة
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          
                          ThemeConstants.space2.h,
                          
                          // القيمة
                          Text(
                            value,
                            style: context.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: ThemeConstants.bold,
                            ),
                          ),
                          
                          // العنوان
                          Text(
                            title,
                            style: context.labelMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTotalCard(BuildContext context) {
    return AnimatedBuilder(
      animation: _cardControllers[3],
      builder: (context, child) {
        return Transform.scale(
          scale: _cardControllers[3].value,
          child: Container(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              border: Border.all(
                color: context.dividerColor.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.primaryColor.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // أيقونة الإجمالي
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space3),
                  decoration: BoxDecoration(
                    gradient: ThemeConstants.primaryGradient,
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  ),
                  child: const Icon(
                    Icons.emoji_events,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                
                ThemeConstants.space4.w,
                
                // المعلومات
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'إجمالي الأذكار',
                        style: context.titleMedium?.copyWith(
                          fontWeight: ThemeConstants.semiBold,
                        ),
                      ),
                      Text(
                        'مجموع ما قرأته حتى الآن',
                        style: context.labelMedium?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // العدد
                Column(
                  children: [
                    Text(
                      totalCount.toString(),
                      style: context.headlineMedium?.copyWith(
                        color: context.primaryColor,
                        fontWeight: ThemeConstants.bold,
                      ),
                    ),
                    Text(
                      'ذكر',
                      style: context.labelSmall?.copyWith(
                        color: context.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// رسام الزخارف للبطاقات
class DecorationPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // رسم خطوط منحنية زخرفية
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.6,
      size.width * 0.8, size.height * 0.8,
    );
    
    canvas.drawPath(path, paint);
    
    // رسم نقاط زخرفية
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(
          size.width * (0.1 + i * 0.2),
          size.height * 0.9,
        ),
        2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}