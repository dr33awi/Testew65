// lib/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';
import '../widgets/category_grid.dart';
import 'package:athkar_app/features/daily_quote/widgets/daily_quotes_card.dart';
import 'package:athkar_app/features/home/widgets/welcome_message.dart';
import 'package:athkar_app/features/prayer_times/widgets/home_prayer_times_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar(
        title: 'تطبيق الأذكار',
        actions: [
          AppBarAction(
            icon: Icons.settings_outlined,
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'الإعدادات',
          ),
        ],
      ),
      body: _buildMainContent(context),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // المحتوى الرئيسي
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space4,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              ThemeConstants.space4.h,
              
              // رسالة الترحيب
              const WelcomeMessage(),
              
              ThemeConstants.space4.h,
              
              // بطاقة مواقيت الصلاة
              const PrayerTimesCard(),
              
              ThemeConstants.space4.h,
              
              // بطاقة الاقتباسات
              const DailyQuotesCard(),
              
              ThemeConstants.space6.h,
              
              // عنوان الأقسام الموحد
              _buildUnifiedSectionHeader(context),
              
              ThemeConstants.space4.h,
            ]),
          ),
        ),
        
        // شبكة الفئات
        const CategoryGrid(),
        
        // مساحة في الأسفل
        SliverToBoxAdapter(
          child: ThemeConstants.space12.h,
        ),
      ],
    );
  }

  Widget _buildUnifiedSectionHeader(BuildContext context) {
    return AppCard.info(
      title: 'الأقسام الرئيسية',
      subtitle: 'اختر القسم المناسب لك',
      icon: Icons.apps_rounded,
      iconColor: context.primaryColor,
    );
  }
}