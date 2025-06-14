// lib/features/home/widgets/quick_stats_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../../app/themes/app_theme.dart';

class QuickStatsCard extends StatefulWidget {
  final int dailyProgress;
  final String? lastReadTime;
  final Function(String) onStatTap;

  const QuickStatsCard({
    super.key,
    required this.dailyProgress,
    required this.lastReadTime,
    required this.onStatTap,
  });

  @override
  State<QuickStatsCard> createState() => _QuickStatsCardState();
}

class _QuickStatsCardState extends State<QuickStatsCard> with TickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;



  @override
  void initState() {
    super.initState();
    
    // Progress animation
    _progressController = AnimationController(
      duration: ThemeConstants.durationSlow,
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.dailyProgress / 100,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOutBack,
    ));
    
    // Start animations
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: ThemeConstants.space4.horizontal,
      height: 160,
      child: Row(
        children: [
          // Daily progress - Modern circular design
          Expanded(
            flex: 2,
            child: _buildCircularProgressCard(context),
          ),
          
          ThemeConstants.space3.w,
          
          // Stats column
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Favorites
                Expanded(
                  child: _buildModernStatItem(
                    context: context,
                    icon: ThemeConstants.iconFavorite,
                    label: 'المفضلة',
                    gradient: [
                      ThemeConstants.error,
                      ThemeConstants.error.darken(0.2),
                    ],
                    onTap: () => widget.onStatTap('favorites'),
                  ),
                ),
                
                ThemeConstants.space3.h,
                
                // Streak with animation
                Expanded(
                  child: _buildModernStatItem(
                    context: context,
                    icon: Icons.local_fire_department,
                    label: 'أيام متتالية',
                    gradient: [ThemeConstants.warning, ThemeConstants.warning.darken(0.2)],
                    onTap: () => widget.onStatTap('achievements'),
                    isStreak: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularProgressCard(BuildContext context) {
    final gradient = [context.primaryColor, context.primaryColor.darken(0.2)];
    
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onStatTap('daily_progress');
        },
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withValues(alpha: ThemeConstants.opacity30),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // إضافة نمط ديناميكي في الخلفية
              Positioned(
                right: -30,
                top: -30,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: ThemeConstants.opacity5),
                  ),
                ),
              ),
              
              // Content
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Circular progress with modern design
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Background circle
                      Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: ThemeConstants.opacity30),
                            width: ThemeConstants.borderMedium,
                          ),
                        ),
                      ),
                      
                      // Animated progress
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return SizedBox(
                            width: 75,
                            height: 75,
                            child: CircularProgressIndicator(
                              value: _progressAnimation.value,
                              strokeWidth: 6,
                              backgroundColor: Colors.transparent,
                              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          );
                        },
                      ),
                      
                      // Percentage text
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: ThemeConstants.space1.bottom,
                            child: Text(
                              '%',
                              style: context.titleMedium?.copyWith(
                                color: Colors.white,
                                fontSize: ThemeConstants.textSizeXl,
                                fontWeight: ThemeConstants.semiBold,
                              ),
                            ),
                          ),
                          Text(
                            '${widget.dailyProgress}',
                            style: context.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: ThemeConstants.bold,
                              fontSize: ThemeConstants.textSize3xl + 8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  ThemeConstants.space3.h,
                  
                  Text(
                    'إنجاز اليوم',
                    style: context.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                      fontSize: ThemeConstants.textSizeLg,
                    ),
                  ),
                  
                  Text(
                    'استمر في التقدم',
                    style: context.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: ThemeConstants.opacity90),
                      fontSize: ThemeConstants.textSizeSm + 1,
                      fontWeight: ThemeConstants.medium,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernStatItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required List<Color> gradient,
    required VoidCallback onTap,
    bool isStreak = false,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withValues(alpha: ThemeConstants.opacity30),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // إضافة نمط ديناميكي في الخلفية
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: ThemeConstants.opacity5),
                  ),
                ),
              ),
              
              // المحتوى
              Container(
                padding: ThemeConstants.space3.all,
                child: Row(
                  children: [
                    // Icon with modern container
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: ThemeConstants.opacity30),
                          width: ThemeConstants.borderMedium,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            icon,
                            color: Colors.white,
                            size: ThemeConstants.iconMd,
                          ),
                          if (isStreak)
                            Positioned(
                              right: 0,
                              top: 0,
                              child: Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: Colors.yellowAccent,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.yellowAccent.withValues(alpha: ThemeConstants.opacity50),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    
                    ThemeConstants.space3.w,
                    
                    // Text content
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: context.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: ThemeConstants.bold,
                            ),
                          ),
                          
                          ThemeConstants.space2.h,
                          
                          // Progress bar with shimmer effect
                          Stack(
                            children: [
                              Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                                  borderRadius: BorderRadius.circular(ThemeConstants.radiusXs),
                                ),
                              ),
                              Container(
                                height: 4,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(ThemeConstants.radiusXs),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withValues(alpha: ThemeConstants.opacity50),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}