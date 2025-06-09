// lib/features/home/presentation/widgets/quick_stats_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../../../app/themes/app_theme.dart';

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

  // تحديد اللون حسب وقت اليوم لتناسق أفضل مع الواجهة
  List<Color> _getTimeBasedGradient() {
    final hour = DateTime.now().hour;
    
    if (hour < 5) {
      return [const Color(0xFF1F1C2C), const Color(0xFF4A148C)]; // ليل
    } else if (hour < 8) {
      return [const Color(0xFF1A237E), const Color(0xFF303F9F)]; // فجر
    } else if (hour < 12) {
      return [const Color(0xFFFF9800), const Color(0xFFFF6F00)]; // صباح
    } else if (hour < 15) {
      return [const Color(0xFFFF6F00), const Color(0xFFE65100)]; // ظهر
    } else if (hour < 17) {
      return [const Color(0xFF00897B), const Color(0xFF00695C)]; // عصر
    } else if (hour < 20) {
      return [const Color(0xFFE65100), const Color(0xFFBF360C)]; // مغرب
    } else {
      return [const Color(0xFF4A148C), const Color(0xFF311B92)]; // عشاء/ليل
    }
  }

  @override
  void initState() {
    super.initState();
    
    // Progress animation
    _progressController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
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
                    icon: Icons.favorite,
                    label: 'المفضلة',
                    gradient: [
                      Color(0xFFE91E63),
                      Color(0xFFC2185B),
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
                    gradient: [
                      Color(0xFFFF6F00),
                      Color(0xFFE65100),
                    ],
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
    final isDark = context.isDarkMode;
    final gradient = _getTimeBasedGradient();
    
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onStatTap('daily_progress');
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withOpacity(0.3),
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
                    color: Colors.white.withOpacity(0.05),
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
                          color: Colors.white.withOpacity(0.2),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
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
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '%',
                              style: context.titleMedium?.copyWith(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: ThemeConstants.semiBold,
                              ),
                            ),
                          ),
                          Text(
                            '${widget.dailyProgress}',
                            style: context.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: ThemeConstants.bold,
                              fontSize: 32,
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
                      fontSize: 16,
                    ),
                  ),
                  
                  Text(
                    'استمر في التقدم',
                    style: context.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
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
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: gradient,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: gradient[0].withOpacity(0.3),
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
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              ),
              
              // المحتوى
              Container(
                padding: const EdgeInsets.all(ThemeConstants.space3),
                child: Row(
                  children: [
                    // Icon with modern container
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            icon,
                            color: Colors.white,
                            size: 24,
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
                                      color: Colors.yellowAccent.withOpacity(0.5),
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
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              Container(
                                height: 4,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withOpacity(0.5),
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