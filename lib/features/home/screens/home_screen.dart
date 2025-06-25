// lib/features/home/screens/home_screen.dart - محسن ومرتب
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
      appBar: CustomAppBar(
        actions: [
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
        isTransparent: true,
        automaticallyImplyLeading: false,
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // الترحيب
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              ThemeConstants.space4,
              ThemeConstants.space2,
              ThemeConstants.space4,
              ThemeConstants.space3,
            ),
            sliver: const SliverToBoxAdapter(
              child: WelcomeMessage(),
            ),
          ),
          
          // مواقيت الصلاة
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space4,
              vertical: ThemeConstants.space2,
            ),
            sliver: const SliverToBoxAdapter(
              child: PrayerTimesCard(),
            ),
          ),
          
          // الاقتباسات اليومية
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space4,
              vertical: ThemeConstants.space2,
            ),
            sliver: const SliverToBoxAdapter(
              child: DailyQuotesCard(),
            ),
          ),
          
          // عنوان الميزات
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              ThemeConstants.space4,
              ThemeConstants.space5,
              ThemeConstants.space4,
              ThemeConstants.space3,
            ),
            sliver: SliverToBoxAdapter(
              child: _buildSectionTitle(context, 'الميزات الرئيسية'),
            ),
          ),
          
          // شبكة الفئات
          const CategoryGrid(),
          
          // مساحة إضافية
          const SliverToBoxAdapter(
            child: SizedBox(height: ThemeConstants.space6),
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
          height: 20,
          decoration: BoxDecoration(
            color: context.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        
        const SizedBox(width: ThemeConstants.space2),
        
        Text(
          title,
          style: context.titleLarge?.copyWith(
            fontWeight: ThemeConstants.bold,
            color: context.textPrimaryColor,
          ),
        ),
        
        const Spacer(),
        
        AppButton.text(
          text: 'عرض الكل',
          onPressed: () {},
          color: context.primaryColor,
        ),
      ],
    );
  }
}