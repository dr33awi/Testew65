// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';
import '../widgets/category_grid.dart';
import '../widgets/quick_stats_card.dart';
import '../../prayer_times/widgets/home_prayer_times_card.dart';
import '../widgets/welcome_message.dart';
import '../widgets/daily_quotes_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Stack(
        children: [
          // خلفية متدرجة أنيقة
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.primaryColor.withValues(alpha: ThemeConstants.opacity10),
                    context.primaryColor.withValues(alpha: ThemeConstants.opacity5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // نمط زخرفي في الخلفية
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    context.primaryColor.withValues(alpha: ThemeConstants.opacity5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          // المحتوى الرئيسي
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // App Bar المتطور
              SliverAppBar(
                expandedHeight: 140,
                floating: true,
                snap: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          context.backgroundColor,
                          context.backgroundColor.withValues(alpha: ThemeConstants.opacity90),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                // Logo أنيق
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: ThemeConstants.primaryGradient,
                                    ),
                                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                                    boxShadow: [
                                      BoxShadow(
                                        color: context.primaryColor.withValues(alpha: ThemeConstants.opacity30),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.mosque,
                                    color: Colors.white,
                                    size: ThemeConstants.iconLg,
                                  ),
                                ),
                                
                                ThemeConstants.space3.w,
                                
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'تطبيق الأذكار',
                                        style: context.headlineSmall?.copyWith(
                                          fontWeight: ThemeConstants.bold,
                                          color: context.primaryColor,
                                        ),
                                      ),
                                      Text(
                                        'رفيقك في العبادة',
                                        style: context.bodySmall?.copyWith(
                                          color: context.textSecondaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                
                                // الأزرار الجانبية
                                Container(
                                  padding: const EdgeInsets.all(ThemeConstants.space2),
                                  decoration: BoxDecoration(
                                    color: context.surfaceVariant,
                                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.notifications_outlined),
                                        onPressed: () => Navigator.pushNamed(context, '/notifications'),
                                        color: context.textSecondaryColor,
                                      ),
                                      Container(
                                        width: 1,
                                        height: 24,
                                        color: context.dividerColor,
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.settings_outlined),
                                        onPressed: () => Navigator.pushNamed(context, '/settings'),
                                        color: context.textSecondaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            ThemeConstants.space4.h,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              
              // رسالة الترحيب المتطورة
              const SliverToBoxAdapter(
                child: WelcomeMessage(),
              ),
              
              // بطاقة مواقيت الصلاة الأنيقة
              const SliverToBoxAdapter(
                child: PrayerTimesCard(),
              ),

              // بطاقة الاقتباسات اليومية
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: ThemeConstants.space4),
                  child: const DailyQuotesCard(),
                ),
              ),
              
              // مساحة
              SliverToBoxAdapter(
                child: ThemeConstants.space4.h,
              ),
              
              // الإحصائيات السريعة
              SliverToBoxAdapter(
                child: QuickStatsCard(
                  dailyProgress: 75,
                  lastReadTime: '٨:٣٠ ص',
                  onStatTap: (stat) {
                    context.showInfoSnackBar('تم النقر على: $stat');
                  },
                ),
              ),
              
              // مساحة
              SliverToBoxAdapter(
                child: ThemeConstants.space6.h,
              ),
              
              // عنوان الأقسام مع خط زخرفي
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: ThemeConstants.primaryGradient,
                          ),
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
              
              SliverToBoxAdapter(
                child: ThemeConstants.space4.h,
              ),
              
              // شبكة الفئات المتطورة
              const CategoryGrid(),
              
              // مساحة نهائية
              SliverToBoxAdapter(
                child: ThemeConstants.space10.h,
              ),
            ],
          ),
        ],
      ),
      
      // شريط التنقل السفلي الأنيق (اختياري)
      extendBody: true,
    );
  }
}