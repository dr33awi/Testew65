// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';
import '../widgets/category_grid.dart';
import '../widgets/quick_stats_card.dart';
import '../../prayer_times/widgets/home_prayer_times_card.dart';
import '../widgets/welcome_message.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar - تم تبسيطه
          SliverAppBar(
            floating: true,
            backgroundColor: context.backgroundColor,
            elevation: 0,
            title: Text(
              'تطبيق الأذكار',
              style: context.titleLarge?.semiBold,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => Navigator.pushNamed(context, '/notifications'),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => Navigator.pushNamed(context, '/settings'),
              ),
            ],
          ),
          
          // Welcome Message
          const SliverToBoxAdapter(
            child: WelcomeMessage(),
          ),
          
          // Prayer Times Card
          const SliverToBoxAdapter(
            child: PrayerTimesCard(),
          ),

          SliverToBoxAdapter(
            child: ThemeConstants.space4.h,
          ),
          
          // Quick Stats
          SliverToBoxAdapter(
            child: QuickStatsCard(
              dailyProgress: 75,
              lastReadTime: '٨:٣٠ ص',
              onStatTap: (stat) {
                context.showInfoSnackBar('تم النقر على: $stat');
              },
            ),
          ),
          
          SliverToBoxAdapter(
            child: ThemeConstants.space4.h,
          ),
          
          // Section Title
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space4,
                vertical: ThemeConstants.space2,
              ),
              child: Text(
                'الأقسام الرئيسية',
                style: context.titleLarge?.semiBold,
              ),
            ),
          ),
          
          // Category Grid
          const CategoryGrid(),
          
          // Bottom Padding
          SliverToBoxAdapter(
            child: ThemeConstants.space8.h,
          ),
        ],
      ),
    );
  }
}