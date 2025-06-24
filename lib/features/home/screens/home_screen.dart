
// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';
import '../widgets/welcome_message.dart';
import '../widgets/category_grid.dart';
import '../../daily_quote/widgets/daily_quotes_card.dart';
import '../../prayer_times/widgets/home_prayer_times_card.dart';
import '../../athkar/widgets/athkar_stats_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ استخدام context بدلاً من ThemeConstants مباشر
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // AppBar مخصص
          _buildCustomAppBar(context),
          
          // المحتوى الرئيسي
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ThemeConstants.space3.h,
                
                // رسالة الترحيب ✅ محدثة
                const WelcomeMessage(),
                
                ThemeConstants.space5.h,
                
                // بطاقة مواقيت الصلاة
                const PrayerTimesCard(),
                
                ThemeConstants.space5.h,
                
                // بطاقة الاقتباسات اليومية
                const DailyQuotesCard(),
                
                ThemeConstants.space5.h,
                
                // إحصائيات الأذكار
                const AthkarStatsCard(
                  totalCategories: 6,
                  completedToday: 3,
                  streak: 5,
                ),
                
                ThemeConstants.space6.h,
                
                // عنوان الفئات
                _buildSectionTitle(context, 'الميزات الرئيسية'),
                
                ThemeConstants.space4.h,
              ]),
            ),
          ),
          
          // شبكة الفئات ✅ محدثة
          const CategoryGrid(),
          
          // مساحة إضافية في الأسفل
          SliverToBoxAdapter(
            child: ThemeConstants.space8.h,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 80,
      floating: true,
      pinned: false,
      // ✅ استخدام context بدلاً من التعريفات المحلية
      backgroundColor: context.backgroundColor,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          // ✅ استخدام gradient من context
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context.backgroundColor,
                context.backgroundColor.withValues(alpha: 0.95),
                Colors.transparent,
              ],
              stops: const [0.0, 0.7, 1.0],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space4,
                vertical: ThemeConstants.space2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // العنوان
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'أذكاري',
                        style: context.headlineSmall?.copyWith(
                          // ✅ استخدام context بدلاً من ThemeConstants
                          color: context.textPrimaryColor,
                          fontWeight: ThemeConstants.bold,
                        ),
                      ),
                      Text(
                        'تطبيقك للأذكار والدعاء',
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  
                  // أيقونة الإعدادات
                  Container(
                    decoration: BoxDecoration(
                      // ✅ استخدام context
                      color: context.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/settings').catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('هذه الميزة قيد التطوير'),
                              // ✅ استخدام context
                              backgroundColor: ThemeConstants.info,
                            ),
                          );
                          return null;
                        });
                      },
                      icon: Icon(
                        Icons.settings_rounded,
                        color: context.primaryColor,
                        size: ThemeConstants.iconMd,
                      ),
                      tooltip: 'الإعدادات',
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

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            // ✅ استخدام context بدلاً من ThemeConstants مباشر
            color: context.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        
        ThemeConstants.space3.w,
        
        Text(
          title,
          style: context.titleLarge?.copyWith(
            fontWeight: ThemeConstants.bold,
            // ✅ استخدام context
            color: context.textPrimaryColor,
          ),
        ),
        
        const Spacer(),
        
        TextButton(
          onPressed: () {
            // يمكن إضافة وظيفة "عرض الكل"
          },
          child: Text(
            'عرض الكل',
            style: context.labelLarge?.copyWith(
              color: context.primaryColor,
              fontWeight: ThemeConstants.semiBold,
            ),
          ),
        ),
      ],
    );
  }
}