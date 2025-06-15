// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';
import '../widgets/category_grid.dart';
import '../../prayer_times/widgets/home_prayer_times_card.dart';
import '../widgets/welcome_message.dart';
import '../widgets/daily_quotes_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;
  double _scrollOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
        });
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
          // خلفية بسيطة
          Container(
            decoration: BoxDecoration(
              gradient: context.isDarkMode
                  ? ThemeConstants.darkBackgroundGradient
                  : ThemeConstants.backgroundGradient,
            ),
          ),
          
          // المحتوى الرئيسي
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              // شريط علوي مخصص
              _buildSimpleAppBar(),
              
              // رسالة الترحيب
              const SliverToBoxAdapter(
                child: WelcomeMessage(),
              ),
              
              // بطاقة مواقيت الصلاة
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
              
              // عنوان الأقسام
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    ThemeConstants.space4,
                    ThemeConstants.space6,
                    ThemeConstants.space4,
                    ThemeConstants.space3,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 24,
                        decoration: BoxDecoration(
                          gradient: ThemeConstants.primaryGradient,
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
              
              // شبكة الفئات
              const CategoryGrid(),
              
              // مساحة في الأسفل
              SliverToBoxAdapter(
                child: ThemeConstants.space10.h,
              ),
            ],
          ),
          
          // أزرار جانبية عائمة
          _buildFloatingButtons(),
        ],
      ),
    );
  }

  Widget _buildSimpleAppBar() {
    return SliverAppBar(
      expandedHeight: 80.0,
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
        ),
      ),
      title: Text(
        'تطبيق الأذكار',
        style: context.titleLarge?.copyWith(
          fontWeight: ThemeConstants.bold,
          color: context.textPrimaryColor,
        ),
      ),
      actions: [
        _buildAppBarAction(
          icon: Icons.notifications_outlined,
          onPressed: () => Navigator.pushNamed(context, '/notifications'),
          badge: '3',
        ),
        _buildAppBarAction(
          icon: Icons.settings_outlined,
          onPressed: () => Navigator.pushNamed(context, '/settings'),
        ),
      ],
    );
  }

  Widget _buildAppBarAction({
    required IconData icon,
    required VoidCallback onPressed,
    String? badge,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: ThemeConstants.space2),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Material(
            color: Colors.transparent,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPressed,
              child: Container(
                padding: const EdgeInsets.all(ThemeConstants.space2),
                decoration: BoxDecoration(
                  color: context.cardColor.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
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
                  color: ThemeConstants.accent,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
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

  Widget _buildFloatingButtons() {
    if (_scrollOffset <= 200) return const SizedBox.shrink();
    
    return Positioned(
      left: ThemeConstants.space4,
      bottom: ThemeConstants.space6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFloatingButton(
            icon: Icons.favorite_outline,
            color: ThemeConstants.tertiary,
            onPressed: () => Navigator.pushNamed(context, '/favorites'),
            tooltip: 'المفضلة',
          ),
          ThemeConstants.space3.h,
          _buildFloatingButton(
            icon: Icons.arrow_upward,
            color: context.primaryColor,
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: ThemeConstants.durationSlow,
                curve: ThemeConstants.curveSmooth,
              );
            },
            tooltip: 'الأعلى',
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Material(
      elevation: ThemeConstants.elevation8,
      shape: const CircleBorder(),
      color: color,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Tooltip(
          message: tooltip,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  color.lighten(0.1),
                  color,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: ThemeConstants.iconMd,
            ),
          ),
        ),
      ),
    );
  }
}