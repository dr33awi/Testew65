// lib/features/home/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد الكامل
import '../../../app/themes/index.dart';
import '../../../app/di/service_locator.dart';

// استيراد الويدجتات المخصصة
import '../widgets/category_grid.dart';
import 'package:athkar_app/features/daily_quote/widgets/daily_quotes_card.dart';
import 'package:athkar_app/features/home/widgets/welcome_message.dart';
import 'package:athkar_app/features/prayer_times/widgets/home_prayer_times_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> 
    with TickerProviderStateMixin {
  
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late AnimationController _backgroundController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeControllers() {
    _scrollController = ScrollController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
  }

  void _initializeAnimations() {
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
    ));

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_backgroundController);
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: _buildMainContent(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppAppBar(
      title: 'تطبيق الأذكار',
      backgroundColor: context.backgroundColor.withValues(alpha: 0.95),
      actions: [
        AppIconButton(
          icon: Icons.search_rounded,
          onPressed: () => _handleSearch(context),
          tooltip: 'البحث',
        ),
        AppIconButton(
          icon: Icons.notifications_outlined,
          onPressed: () => _handleNotifications(context),
          tooltip: 'الإشعارات',
        ),
        AppIconButton(
          icon: Icons.settings_outlined,
          onPressed: () => _handleSettings(context),
          tooltip: 'الإعدادات',
        ),
      ],
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundAnimation,
      builder: (context, child) => Container(
        decoration: BoxDecoration(
          gradient: _getTimeBasedGradient(),
        ),
        child: _buildScrollableContent(context),
      ),
    );
  }

  Widget _buildScrollableContent(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // مساحة للـ AppBar
        const SliverToBoxAdapter(
          child: SizedBox(height: kToolbarHeight + 20),
        ),
        
        // المحتوى الرئيسي
        SliverPadding(
          padding: AppSpacing.screenPadding,
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              // رسالة الترحيب مع الأنيميشن
              _buildAnimatedWelcome(),
              
              AppSpacing.verticalLarge,
              
              // بطاقة مواقيت الصلاة
              _buildAnimatedPrayerCard(),
              
              AppSpacing.verticalLarge,
              
              // بطاقة الاقتباسات
              _buildAnimatedQuoteCard(),
              
              AppSpacing.verticalExtraLarge,
              
              // عنوان الأقسام
              _buildAnimatedSectionHeader(),
              
              AppSpacing.verticalLarge,
            ]),
          ),
        ),
        
        // شبكة الفئات
        _buildAnimatedCategoryGrid(),
        
        // إحصائيات سريعة
        _buildQuickStats(),
        
        // مساحة في الأسفل
        SliverToBoxAdapter(
          child: AppSpacing.verticalHuge,
        ),
      ],
    );
  }

  Widget _buildAnimatedWelcome() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _slideAnimation.value),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: const WelcomeMessage(),
        ),
      ),
    );
  }

  Widget _buildAnimatedPrayerCard() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _slideAnimation.value * 0.8),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.1, 0.7, curve: Curves.easeOut),
          ),
          child: const PrayerTimesCard(),
        ),
      ),
    );
  }

  Widget _buildAnimatedQuoteCard() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _slideAnimation.value * 0.6),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
          ),
          child: const DailyQuotesCard(),
        ),
      ),
    );
  }

  Widget _buildAnimatedSectionHeader() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _slideAnimation.value * 0.4),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.3, 0.9, curve: Curves.easeOut),
          ),
          child: _buildSectionHeader(),
        ),
      ),
    );
  }

  Widget _buildSectionHeader() {
    return AppCard.gradient(
      gradient: LinearGradient(
        colors: [
          context.primary.withValues(alpha: 0.1),
          context.secondary.withValues(alpha: 0.1),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: AppRow(
        children: [
          // المؤشر الجانبي مع الأنيميشن
          AnimatedBuilder(
            animation: _backgroundAnimation,
            builder: (context, child) => Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    context.primary,
                    context.secondary,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  transform: GradientRotation(_backgroundAnimation.value * 2 * 3.14159),
                ),
                borderRadius: BorderRadius.circular(2),
                boxShadow: [
                  BoxShadow(
                    color: context.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),
          
          AppSpacing.horizontalMedium,
          
          // الأيقونة مع تأثيرات
          Container(
            padding: AppSpacing.paddingMedium,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.primary.withValues(alpha: 0.2),
                  context.secondary.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(context.radius),
              border: Border.all(
                color: context.primary.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: AnimatedBuilder(
              animation: _backgroundAnimation,
              builder: (context, child) => Transform.rotate(
                angle: _backgroundAnimation.value * 0.1,
                child: Icon(
                  Icons.apps_rounded,
                  color: context.primary,
                  size: 28,
                ),
              ),
            ),
          ),
          
          AppSpacing.horizontalMedium,
          
          // النصوص
          Expanded(
            child: AppColumn.small(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title(
                  text: 'الأقسام الرئيسية',
                  color: context.text,
                ),
                AppText.caption(
                  text: 'اختر القسم المناسب لك',
                  color: context.secondaryText,
                ),
              ],
            ),
          ),
          
          // زر "عرض الكل"
          AppButton.outlined(
            text: 'عرض الكل',
            onPressed: () => _handleViewAll(context),
            size: AppButtonSize.small,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCategoryGrid() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, _slideAnimation.value * 0.2),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
          ),
          child: const CategoryGrid(),
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    return SliverPadding(
      padding: AppSpacing.screenPaddingHorizontal,
      sliver: SliverToBoxAdapter(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _slideAnimation.value * 0.1),
            child: FadeTransition(
              opacity: CurvedAnimation(
                parent: _animationController,
                curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
              ),
              child: _buildStatsRow(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return AppCard.simple(
      child: AppRow(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            icon: Icons.auto_awesome,
            label: 'أذكار اليوم',
            value: '12',
            color: AppColors.success,
          ),
          _buildStatItem(
            icon: Icons.menu_book,
            label: 'الآيات',
            value: '5',
            color: AppColors.primary,
          ),
          _buildStatItem(
            icon: Icons.favorite,
            label: 'الأدعية',
            value: '8',
            color: AppColors.warning,
          ),
          _buildStatItem(
            icon: Icons.trending_up,
            label: 'التقدم',
            value: '85%',
            color: AppColors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return AppColumn.small(
      children: [
        Container(
          padding: AppSpacing.paddingSmall,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        AppText.caption(
          text: value,
          color: context.text,
        ),
        AppText.caption(
          text: label,
          color: context.secondaryText,
        ),
      ],
    );
  }

  LinearGradient _getTimeBasedGradient() {
    final hour = DateTime.now().hour;
    
    if (hour < 6) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.darkBackground.withValues(alpha: 0.8),
          AppColors.darkSurface.withValues(alpha: 0.6),
        ],
      );
    } else if (hour < 18) {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.lightBackground.withValues(alpha: 0.9),
          AppColors.lightSurface.withValues(alpha: 0.7),
        ],
      );
    } else {
      return LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primaryDark.withValues(alpha: 0.3),
          AppColors.lightBackground.withValues(alpha: 0.8),
        ],
      );
    }
  }

  // ==================== معالجات الأحداث ====================
  
  void _handleSearch(BuildContext context) {
    HapticFeedback.lightImpact();
    context.showInfo('البحث قريباً');
  }

  void _handleNotifications(BuildContext context) {
    HapticFeedback.lightImpact();
    context.showInfo('الإشعارات قريباً');
  }

  void _handleSettings(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(context, '/settings');
  }

  void _handleViewAll(BuildContext context) {
    HapticFeedback.lightImpact();
    context.showInfo('عرض جميع الأقسام قريباً');
  }
}