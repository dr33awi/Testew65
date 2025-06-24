// lib/features/home/screens/home_screen.dart - مُحدث بالـ widgets الموحدة
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../widgets/welcome_message.dart';
import '../widgets/category_grid.dart';
import '../../daily_quote/widgets/daily_quotes_card.dart';
import '../../prayer_times/widgets/home_prayer_times_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      // ✅ استخدام CustomAppBar الموحد بدلاً من custom AppBar
      appBar: CustomAppBar(
        title: 'أذكاري',
        titleWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'أذكاري',
              style: context.titleLarge?.copyWith(
                fontWeight: ThemeConstants.bold,
                color: context.textPrimaryColor,
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
        leading: Container(
          padding: const EdgeInsets.all(ThemeConstants.space3),
          decoration: BoxDecoration(
            gradient: context.primaryGradient,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            boxShadow: ThemeConstants.shadowSm,
          ),
          child: const Icon(
            Icons.home_rounded,
            color: Colors.white,
            size: ThemeConstants.iconMd,
          ),
        ),
        actions: [
          AppBarAction(
            icon: Icons.search_rounded,
            onPressed: () {
              HapticFeedback.lightImpact();
              context.showInfoSnackBar('البحث قيد التطوير');
            },
            tooltip: 'البحث',
          ),
          AppBarAction(
            icon: Icons.settings_rounded,
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/settings').catchError((error) {
                context.showInfoSnackBar('هذه الميزة قيد التطوير');
                return null;
              });
            },
            tooltip: 'الإعدادات',
            color: context.primaryColor,
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ThemeConstants.space3.h,
                
                // رسالة الترحيب
                const WelcomeMessage(),
                
                ThemeConstants.space5.h,
                
                // بطاقة مواقيت الصلاة
                const PrayerTimesCard(),
                
                ThemeConstants.space5.h,
                
                // بطاقة الاقتباسات اليومية
                const DailyQuotesCard(),
                
                ThemeConstants.space6.h,
                
                // عنوان الفئات
                _buildSectionTitle(context, 'الميزات الرئيسية'),
                
                ThemeConstants.space4.h,
              ]),
            ),
          ),
          
          // شبكة الفئات
          const CategoryGrid(),
          
          // مساحة إضافية في الأسفل
          SliverToBoxAdapter(
            child: ThemeConstants.space8.h,
          ),
        ],
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
            color: context.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        
        ThemeConstants.space3.w,
        
        Text(
          title,
          style: context.titleLarge?.copyWith(
            fontWeight: ThemeConstants.bold,
            color: context.textPrimaryColor,
          ),
        ),
        
        const Spacer(),
        
        // ✅ استخدام AppButton الموحد
        AppButton.text(
          text: 'عرض الكل',
          onPressed: () {
            // يمكن إضافة وظيفة "عرض الكل"
          },
          color: context.primaryColor,
        ),
      ],
    );
  }
}