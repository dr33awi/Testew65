// lib/features/home/screens/home_screen.dart

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
  double _scrollOffset = 0.0;
  
  // تحسين: تخزين الخلفية لتجنب إعادة البناء
  Widget? _cachedBackground;
  bool _backgroundBuilt = false;

  @override
  void initState() {
    super.initState();
    _setupScrollController();
  }

  void _setupScrollController() {
    _scrollController = ScrollController()
      ..addListener(() {
        // تحسين: تقليل عدد استدعاءات setState
        final newOffset = _scrollController.offset;
        if ((newOffset - _scrollOffset).abs() > 20) { // زيادة threshold
          setState(() {
            _scrollOffset = newOffset;
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
          // تحسين: استخدام خلفية مُحسنة
          _buildOptimizedBackground(context),
          
          // المحتوى الرئيسي
          _buildMainContent(context),
        ],
      ),
    );
  }

  Widget _buildOptimizedBackground(BuildContext context) {
    // تحسين: بناء الخلفية مرة واحدة فقط
    if (!_backgroundBuilt) {
      _cachedBackground = Container(
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
        child: Stack(
          children: [
            // تحسين: نمط هندسي مبسط
            _buildSimplePattern(context),
            
            // تحسين: تأثير ضوئي ثابت
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
                      context.primaryColor.withValues(alpha: 0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      _backgroundBuilt = true;
    }
    return _cachedBackground!;
  }

  Widget _buildSimplePattern(BuildContext context) {
    // تحسين: نمط مبسط بدلاً من CustomPaint
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/pattern.png'), // إذا توفر
            fit: BoxFit.cover,
            opacity: 0.05,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                context.primaryColor.withValues(alpha: 0.02),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // تحسين: شريط تطبيق مبسط
        _buildOptimizedAppBar(context),
        
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
              _buildSectionHeader(context),
              
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

  Widget _buildOptimizedAppBar(BuildContext context) {
    return SliverAppBar(
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
          // تحسين: إزالة BackdropFilter المكلف
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
          // أيقونة التطبيق
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: ThemeConstants.primaryGradient,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              boxShadow: [
                BoxShadow(
                  color: context.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.mosque,
              color: Colors.white,
              size: 24,
            ),
          ),
          
          ThemeConstants.space3.w,
          
          // النص
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
        // تحسين: أزرار مبسطة
        _buildSimpleAppBarAction(
          icon: Icons.notifications_outlined,
          onPressed: () => Navigator.pushNamed(context, '/notifications'),
          badge: '3',
          tooltip: 'الإشعارات',
        ),
        
        _buildSimpleAppBarAction(
          icon: Icons.settings_outlined,
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          tooltip: 'الإعدادات',
        ),
        
        ThemeConstants.space2.w,
      ],
    );
  }

  Widget _buildSimpleAppBarAction({
    required IconData icon,
    required VoidCallback onPressed,
    String? badge,
    required String tooltip,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: ThemeConstants.space2),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // تحسين: إزالة BackdropFilter
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: Container(
                padding: const EdgeInsets.all(ThemeConstants.space2),
                decoration: BoxDecoration(
                  color: context.cardColor.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: context.textPrimaryColor,
                  size: ThemeConstants.iconMd,
                ),
              ),
            ),
          ),
          
          if (badge != null)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [ThemeConstants.accent, ThemeConstants.accentDark],
                  ),
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 18,
                  minHeight: 18,
                ),
                child: Text(
                  badge,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Container(
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
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
          
          ThemeConstants.space3.w,
          
          // الأيقونة
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
          
          // النص
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
          
          // زر المزيد
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: context.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// تحسين: إزالة GeometricPatternPainter المعقد لتحسين الأداء