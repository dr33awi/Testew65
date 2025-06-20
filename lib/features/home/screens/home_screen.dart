// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';

// ✅ استيراد النظام المبسط الجديد فقط
import '../../../app/themes/index.dart';

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
      appBar: IslamicAppBar(
        title: 'تطبيق الأذكار',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            tooltip: 'الإعدادات',
          ),
        ],
      ),
      body: _buildMainContent(),
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // المحتوى الرئيسي
        SliverPadding(
          padding: context.mediumPadding.paddingAll,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Spaces.large,
              
              // رسالة الترحيب
              const WelcomeMessage(),
              
              Spaces.large,
              
              // بطاقة مواقيت الصلاة
              const PrayerTimesCard(),
              
              Spaces.large,
              
              // بطاقة الاقتباسات
              const DailyQuotesCard(),
              
              Spaces.extraLarge,
              
              // عنوان الأقسام
              _buildSectionHeader(),
              
              Spaces.large,
            ]),
          ),
        ),
        
        // شبكة الفئات
        const CategoryGrid(),
        
        // مساحة في الأسفل
        const SliverToBoxAdapter(
          child: Spaces.extraLarge,
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return IslamicCard.simple(
      child: Row(
        children: [
          // المؤشر الجانبي
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              gradient: ThemeConstants.primaryGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          Spaces.mediumH,
          
          // الأيقونة
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(context.mediumRadius),
            ),
            child: Icon(
              Icons.apps_rounded,
              color: context.primaryColor,
              size: 24,
            ),
          ),
          
          Spaces.mediumH,
          
          // النص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الأقسام الرئيسية',
                  style: context.titleStyle,
                ),
                Spaces.small,
                Text(
                  'اختر القسم المناسب لك',
                  style: context.captionStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}