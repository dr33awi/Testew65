// lib/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';
import '../widgets/category_grid.dart';
import 'package:athkar_app/features/daily_quote/widgets/daily_quotes_card.dart';
import 'package:athkar_app/features/home/widgets/welcome_message.dart';
import 'package:athkar_app/features/prayer_times/widgets/home_prayer_times_card.dart' hide DailyQuotesCard;

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
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space4,
          ),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: ThemeConstants.space4),
              
              // رسالة الترحيب
              const WelcomeMessage(),
              
              const SizedBox(height: ThemeConstants.space4),
              
              // بطاقة مواقيت الصلاة
              const PrayerTimesCard(),
              
              const SizedBox(height: ThemeConstants.space4),
              
              // بطاقة الاقتباسات
              const DailyQuotesCard(),
              
              const SizedBox(height: ThemeConstants.space6),
              
              // عنوان الأقسام
              _buildSectionHeader(),
              
              const SizedBox(height: ThemeConstants.space4),
            ]),
          ),
        ),
        
        // شبكة الفئات
        const CategoryGrid(),
        
        // مساحة في الأسفل
        const SliverToBoxAdapter(
          child: SizedBox(height: ThemeConstants.space12),
        ),
      ],
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.primaryColor.withValues(alpha: 0.1),
            context.primaryColor.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: context.primaryColor.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.space4),
        child: Row(
          children: [
            // المؤشر الجانبي
            Container(
              width: 4,
              height: 32,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    context.primaryColor,
                    context.primaryColor.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(width: ThemeConstants.space4),
            
            // الأيقونة
            Container(
              padding: const EdgeInsets.all(ThemeConstants.space2),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                border: Border.all(
                  color: context.primaryColor.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.apps_rounded,
                color: context.primaryColor,
                size: ThemeConstants.iconMd,
              ),
            ),
            
            const SizedBox(width: ThemeConstants.space3),
            
            // النص
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الأقسام الرئيسية',
                    style: context.titleLarge?.copyWith(
                      fontWeight: ThemeConstants.bold,
                      color: context.textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: ThemeConstants.space1),
                  Text(
                    'اختر القسم المناسب لك',
                    style: context.labelMedium?.copyWith(
                      color: context.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            
            // أيقونة إضافية
            Container(
              padding: const EdgeInsets.all(ThemeConstants.space2),
              decoration: BoxDecoration(
                color: context.primaryColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: context.primaryColor.withValues(alpha: 0.6),
                size: ThemeConstants.iconSm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}