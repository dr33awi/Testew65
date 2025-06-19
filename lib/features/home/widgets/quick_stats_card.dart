// lib/features/home/widgets/quick_stats_section.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';
import 'color_helper.dart';

class QuickStatsSection extends StatefulWidget {
  const QuickStatsSection({super.key});

  @override
  State<QuickStatsSection> createState() => _QuickStatsSectionState();
}

class _QuickStatsSectionState extends State<QuickStatsSection>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
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
    _progressController = AnimationController(
      duration: ThemeConstants.durationExtraSlow,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

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
    _progressController.dispose();
    _pulseController.dispose();
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
          // عنوان القسم الموحد
          _buildUnifiedSectionTitle(context),
          
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
                          gradient: ColorHelper.getCategoryGradient('athkar').colors,
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
                          gradient: ColorHelper.getProgressGradient(1.0).colors,
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

  Widget _buildUnifiedSectionTitle(BuildContext context) {
    return AppCard.info(
      title: 'إحصائياتك اليوم',
      subtitle: 'تتبع تقدمك الروحي',
      icon: Icons.trending_up_rounded,
      iconColor: context.primaryColor,
      trailing: AnimatedBuilder(
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
    );
  }

  Widget _buildMainProgressCard(BuildContext context) {
    return AnimatedBuilder(
      animation: _cardControllers[0],
      builder: (context, child) {
        return Transform.scale(
          scale: _cardControllers[0].value,
          child: AppCard(
            type: CardType.completion,
            style: CardStyle.gradient,
            gradientColors: ColorHelper.getProgressGradient(dailyProgress / 100).colors,
            showShadow: true,
            enableBlur: true,
            onTap: () {
              HapticFeedback.lightImpact();
              // التنقل لصفحة الإحصائيات التفصيلية
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // مؤشر التقدم الدائري
                AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
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
                
                Text(
                  'إنجاز اليوم',
                  style: context.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                  ).withShadow(),
                ),
                
                ThemeConstants.space1.h,
                
                Text(
                  'أكمل اليوم بقوة! 💪',
                  style: context.labelMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
          child: AppCard(
            type: CardType.stat,
            style: CardStyle.gradient,
            title: title,
            value: value,
            icon: icon,
            gradientColors: gradient,
            showShadow: true,
            onTap: () {
              HapticFeedback.lightImpact();
            },
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
                      
                      Text(
                        value,
                        style: context.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: ThemeConstants.bold,
                        ).withShadow(),
                      ),
                      
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
          child: AppCard.info(
            title: 'إجمالي الأذكار',
            subtitle: 'مجموع ما قرأته حتى الآن',
            icon: Icons.emoji_events,
            iconColor: context.primaryColor,
            onTap: () {
              HapticFeedback.lightImpact();
            },
            trailing: Column(
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
          ),
        );
      },
    );
  }
}