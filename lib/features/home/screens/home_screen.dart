// lib/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';
import '../widgets/category_grid.dart';
import 'package:athkar_app/features/home/widgets/daily_quotes_card.dart';
import 'package:athkar_app/features/home/widgets/quick_stats_card.dart';
import 'package:athkar_app/features/home/widgets/welcome_message.dart';
import 'package:athkar_app/features/home/widgets/floating_action_menu.dart';
import 'package:athkar_app/features/prayer_times/widgets/home_prayer_times_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> 
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  double _scrollOffset = 0.0;
  bool _showFloatingMenu = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _setupScrollController();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: ThemeConstants.durationSlow,
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: ThemeConstants.curveSmooth,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: ThemeConstants.curveSmooth,
    ));

    _fadeController.forward();
    _slideController.forward();
  }

  void _setupScrollController() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          _scrollOffset = _scrollController.offset;
          _showFloatingMenu = _scrollOffset > 200;
        });
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Stack(
        children: [
          // خلفية متدرجة متطورة
          _buildEnhancedBackground(context),
          
          // المحتوى الرئيسي
          _buildMainContent(context),
          
          // قائمة الإجراءات العائمة
          FloatingActionMenu(
            visible: _showFloatingMenu,
            onScrollToTop: _scrollToTop,
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedBackground(BuildContext context) {
    return Container(
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
          // نمط هندسي خفيف
          Positioned.fill(
            child: CustomPaint(
              painter: GeometricPatternPainter(
                color: context.primaryColor.withValues(alpha: 0.05),
                isDark: context.isDarkMode,
              ),
            ),
          ),
          
          // تأثير الضوء العلوي
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
  }

  Widget _buildMainContent(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // شريط التطبيق المطور
            _buildEnhancedAppBar(context),
            
            // المحتوى الرئيسي
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space4,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // رسالة الترحيب المطورة
                  const AnimationConfiguration.staggeredList(
                    position: 0,
                    duration: ThemeConstants.durationSlow,
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: WelcomeMessage(),
                      ),
                    ),
                  ),
                  
                  ThemeConstants.space4.h,
                  
                  // إحصائيات سريعة
                  const AnimationConfiguration.staggeredList(
                    position: 1,
                    duration: ThemeConstants.durationSlow,
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: QuickStatsSection(),
                      ),
                    ),
                  ),
                  
                  ThemeConstants.space4.h,
                  
                  // بطاقة مواقيت الصلاة المطورة
                  const AnimationConfiguration.staggeredList(
                    position: 2,
                    duration: ThemeConstants.durationSlow,
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: PrayerTimesCard(),
                      ),
                    ),
                  ),
                  
                  ThemeConstants.space4.h,
                  
                  // بطاقة الاقتباسات المطورة
                  const AnimationConfiguration.staggeredList(
                    position: 3,
                    duration: ThemeConstants.durationSlow,
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: DailyQuotesCard(),
                      ),
                    ),
                  ),
                  
                  ThemeConstants.space6.h,
                  
                  // عنوان الأقسام
                  _buildSectionHeader(context),
                  
                  ThemeConstants.space4.h,
                ]),
              ),
            ),
            
            // شبكة الفئات المطورة
            const AnimationLimiter(
              child: CategoryGrid(),
            ),
            
            // مساحة في الأسفل
            SliverToBoxAdapter(
              child: ThemeConstants.space12.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedAppBar(BuildContext context) {
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
          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
        // زر الإشعارات
        _buildAppBarAction(
          icon: Icons.notifications_outlined,
          onPressed: () => Navigator.pushNamed(context, '/notifications'),
          badge: '3',
          tooltip: 'الإشعارات',
        ),
        
        // زر الإعدادات
        _buildAppBarAction(
          icon: Icons.settings_outlined,
          onPressed: () => Navigator.pushNamed(context, '/settings'),
          tooltip: 'الإعدادات',
        ),
        
        ThemeConstants.space2.w,
      ],
    );
  }

  Widget _buildAppBarAction({
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
                  boxShadow: [
                    BoxShadow(
                      color: context.primaryColor.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
                  boxShadow: [
                    BoxShadow(
                      color: ThemeConstants.accent.withValues(alpha: 0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
    return AnimationConfiguration.staggeredList(
      position: 4,
      duration: ThemeConstants.durationSlow,
      child: SlideAnimation(
        verticalOffset: 30.0,
        child: FadeInAnimation(
          child: Container(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
              border: Border.all(
                color: context.dividerColor.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: context.primaryColor.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
                
                ThemeConstants.space4.w,
                
                // الأيقونة
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  ),
                  child: Icon(
                    Icons.apps_rounded,
                    color: context.primaryColor,
                    size: ThemeConstants.iconMd,
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
                        style: context.titleLarge?.copyWith(
                          fontWeight: ThemeConstants.bold,
                          color: context.textPrimaryColor,
                        ),
                      ),
                      Text(
                        'اختر القسم المناسب لك',
                        style: context.labelMedium?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // زر المزيد
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.space2),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: ThemeConstants.iconSm,
                    color: context.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: ThemeConstants.durationSlow,
      curve: ThemeConstants.curveSmooth,
    );
  }
}

/// رسام النمط الهندسي للخلفية
class GeometricPatternPainter extends CustomPainter {
  final Color color;
  final bool isDark;

  GeometricPatternPainter({
    required this.color,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    const double spacing = 60.0;
    
    // رسم شبكة من الأشكال الهندسية
    for (double x = 0; x < size.width + spacing; x += spacing) {
      for (double y = 0; y < size.height + spacing; y += spacing) {
        // رسم دائرة صغيرة
        canvas.drawCircle(
          Offset(x, y),
          2,
          paint,
        );
        
        // رسم خطوط متقاطعة
        if (x + spacing < size.width) {
          canvas.drawLine(
            Offset(x + 10, y),
            Offset(x + spacing - 10, y),
            paint,
          );
        }
        
        if (y + spacing < size.height) {
          canvas.drawLine(
            Offset(x, y + 10),
            Offset(x, y + spacing - 10),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}