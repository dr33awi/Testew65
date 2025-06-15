// lib/features/home/widgets/quick_stats_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';

class QuickStatsCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      child: Column(
        children: [
          // العنوان
          _buildSectionHeader(context),
          
          ThemeConstants.space3.h,
          
          // البطاقات
          SizedBox(
            height: 200,
            child: Row(
              children: [
                // بطاقة التقدم اليومي
                Expanded(
                  flex: 3,
                  child: _buildDailyProgressCard(context),
                ),
                
                ThemeConstants.space3.w,
                
                // بطاقات الإحصائيات
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          context: context,
                          title: 'المفضلة',
                          value: '12',
                          icon: Icons.favorite,
                          gradient: [
                            ThemeConstants.accent,
                            ThemeConstants.accentLight,
                          ],
                          onTap: () => onStatTap('favorites'),
                        ),
                      ),
                      
                      ThemeConstants.space3.h,
                      
                      Expanded(
                        child: _buildStatCard(
                          context: context,
                          title: 'الإنجازات',
                          value: '7',
                          icon: Icons.emoji_events,
                          gradient: [
                            ThemeConstants.tertiary,
                            ThemeConstants.tertiaryLight,
                          ],
                          onTap: () => onStatTap('achievements'),
                          isStreak: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                gradient: ThemeConstants.primaryGradient,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ThemeConstants.space3.w,
            Text(
              'إحصائياتك اليوم',
              style: context.titleLarge?.copyWith(
                fontWeight: ThemeConstants.bold,
              ),
            ),
          ],
        ),
        
        TextButton.icon(
          onPressed: () => onStatTap('all_stats'),
          icon: Icon(
            Icons.bar_chart_rounded,
            size: ThemeConstants.iconSm,
            color: context.primaryColor,
          ),
          label: Text(
            'المزيد',
            style: context.labelMedium?.copyWith(
              color: context.primaryColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyProgressCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                onStatTap('daily_progress');
              },
              borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      context.primaryColor.withOpacity(0.9),
                      context.primaryColor.darken(0.1).withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Stack(
                  children: [
                    // نمط زخرفي
                    Positioned(
                      right: -30,
                      top: -30,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ),
                    
                    // المحتوى
                    Padding(
                      padding: const EdgeInsets.all(ThemeConstants.space4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // مؤشر التقدم الدائري
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '$dailyProgress',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '%',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          ThemeConstants.space3.h,
                          
                          Text(
                            'إنجاز اليوم',
                            style: context.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: ThemeConstants.bold,
                            ),
                          ),
                          
                          if (lastReadTime != null) ...[
                            ThemeConstants.space1.h,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: ThemeConstants.iconXs,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                                ThemeConstants.space1.w,
                                Text(
                                  'آخر قراءة: $lastReadTime',
                                  style: context.labelSmall?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onTap,
    bool isStreak = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        boxShadow: [
          BoxShadow(
            color: gradient[0].withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: Material(
          color: Colors.transparent,
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
                  colors: gradient.map((c) => c.withOpacity(0.9)).toList(),
                ),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              ),
              child: Stack(
                children: [
                  // تأثير النجمة للخطوط المتتالية
                  if (isStreak)
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Icon(
                        Icons.auto_awesome,
                        size: 60,
                        color: Colors.white.withOpacity(0.1),
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
                            color: Colors.white.withOpacity(0.2),
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
                          style: context.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: ThemeConstants.bold,
                          ),
                        ),
                        
                        Text(
                          title,
                          style: context.labelMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}