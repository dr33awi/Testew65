// lib/features/home/screens/home_screen.dart - محسن للأداء

import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';
import '../widgets/category_grid.dart';
import 'package:athkar_app/features/home/widgets/daily_quotes_card.dart';
import 'package:athkar_app/features/home/widgets/welcome_message.dart';
import 'package:athkar_app/features/prayer_times/widgets/home_prayer_times_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  
  // إزالة تتبع التمرير المكلف
  bool _showFloatingButton = false;

  @override
  void initState() {
    super.initState();
    _setupScrollController();
  }

  void _setupScrollController() {
    _scrollController = ScrollController()
      ..addListener(() {
        // تحسين: فقط لإظهار/إخفاء الزر العائم
        final shouldShow = _scrollController.offset > 200;
        if (shouldShow != _showFloatingButton) {
          setState(() {
            _showFloatingButton = shouldShow;
          });
        }
      });
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
      body: Stack(
        children: [
          // خلفية ثابتة مبسطة
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: context.isDarkMode
                    ? [
                        ThemeConstants.darkBackground,
                        ThemeConstants.darkSurface.withValues(alpha: 0.8),
                        ThemeConstants.darkBackground,
                      ]
                    : [
                        ThemeConstants.lightBackground,
                        ThemeConstants.primarySoft.withValues(alpha: 0.1),
                        ThemeConstants.lightBackground,
                      ],
                stops: const [0.0, 0.3, 1.0],
              ),
            ),
          ),
          
          // المحتوى الرئيسي
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // شريط تطبيق مبسط
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          context.primaryColor.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: context.backgroundColor.withValues(alpha: 0.8),
                        border: Border(
                          bottom: BorderSide(
                            color: context.dividerColor.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                title: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: ThemeConstants.primaryGradient,
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      ),
                      child: const Icon(
                        Icons.mosque,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    ThemeConstants.space3.w,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'تطبيق الأذكار',
                            style: context.titleLarge?.copyWith(
                              fontWeight: ThemeConstants.bold,
                              color: context.textPrimaryColor,
                            ),
                          ),
                          Text(
                            'السلام عليكم',
                            style: context.labelMedium?.copyWith(
                              color: context.textSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(left: ThemeConstants.space2),
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(context, '/notifications'),
                        child: Container(
                          padding: const EdgeInsets.all(ThemeConstants.space2),
                          decoration: BoxDecoration(
                            color: context.cardColor.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: context.textPrimaryColor,
                            size: ThemeConstants.iconMd,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: ThemeConstants.space2),
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(context, '/settings'),
                        child: Container(
                          padding: const EdgeInsets.all(ThemeConstants.space2),
                          decoration: BoxDecoration(
                            color: context.cardColor.withValues(alpha: 0.8),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.settings_outlined,
                            color: context.textPrimaryColor,
                            size: ThemeConstants.iconMd,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ThemeConstants.space2.w,
                ],
              ),
              
              // المحتوى الرئيسي
              SliverPadding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.space4,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // رسالة الترحيب
                    const WelcomeMessage(),
                    
                    ThemeConstants.space4.h,
                    
                    // بطاقة مواقيت الصلاة
                    const PrayerTimesCard(),
                    
                    ThemeConstants.space4.h,
                    
                    // بطاقة الاقتباسات
                    const DailyQuotesCard(),
                    
                    ThemeConstants.space6.h,
                    
                    // عنوان الأقسام
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.space4,
                        vertical: ThemeConstants.space3,
                      ),
                      decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                        border: Border.all(
                          color: context.dividerColor.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 4,
                            height: 32,
                            decoration: BoxDecoration(
                              gradient: ThemeConstants.primaryGradient,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          ThemeConstants.space3.w,
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: context.primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                            ),
                            child: Icon(
                              Icons.apps_rounded,
                              color: context.primaryColor,
                              size: 20,
                            ),
                          ),
                          ThemeConstants.space3.w,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الأقسام الرئيسية',
                                  style: context.titleMedium?.copyWith(
                                    fontWeight: ThemeConstants.bold,
                                    color: context.textPrimaryColor,
                                  ),
                                ),
                                Text(
                                  'اختر القسم المناسب لك',
                                  style: context.labelSmall?.copyWith(
                                    color: context.textSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
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
          ),
          
          // زر العائم للعودة للأعلى
          if (_showFloatingButton)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                backgroundColor: context.primaryColor,
                child: const Icon(
                  Icons.keyboard_arrow_up,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}