// lib/features/home/screens/home_screen.dart - حل بسيط وفعال
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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late List<Animation<double>> _itemAnimations;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // إنشاء animations متتالية للعناصر
    _itemAnimations = List.generate(4, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _fadeController,
        curve: Interval(
          index * 0.15,
          0.6 + (index * 0.1),
          curve: Curves.easeOutCubic,
        ),
      ));
    });

    // بدء الانيميشن
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: context.primaryColor,
        backgroundColor: context.cardColor,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.space4,
            vertical: ThemeConstants.space2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // رسالة الترحيب
              AnimatedBuilder(
                animation: _itemAnimations[0],
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _itemAnimations[0],
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _itemAnimations[0].value)),
                      child: const WelcomeMessage(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: ThemeConstants.space4),
              
              // مواقيت الصلاة
              AnimatedBuilder(
                animation: _itemAnimations[1],
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _itemAnimations[1],
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _itemAnimations[1].value)),
                      child: const PrayerTimesCard(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: ThemeConstants.space4),
              
              // الاقتباسات اليومية
              AnimatedBuilder(
                animation: _itemAnimations[2],
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _itemAnimations[2],
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _itemAnimations[2].value)),
                      child: const DailyQuotesCard(),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: ThemeConstants.space6),
              
              // عنوان الميزات
              AnimatedBuilder(
                animation: _itemAnimations[3],
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _itemAnimations[3],
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _itemAnimations[3].value)),
                      child: _buildSectionHeader(context),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: ThemeConstants.space4),
              
              // شبكة الفئات
              AnimatedBuilder(
                animation: _itemAnimations[3],
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _itemAnimations[3],
                    child: Transform.translate(
                      offset: Offset(0, 30 * (1 - _itemAnimations[3].value)),
                      child: const SimpleCategoryGrid(),
                    ),
                  );
                },
              ),
              
              // مساحة إضافية للأسفل
              const SizedBox(height: ThemeConstants.space8),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: context.isDarkMode 
            ? Brightness.light 
            : Brightness.dark,
      ),
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: ThemeConstants.space4),
          decoration: BoxDecoration(
            color: context.cardColor.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: context.dividerColor.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: context.primaryColor.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.settings_rounded,
              color: context.primaryColor,
              size: ThemeConstants.iconMd,
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.pushNamed(context, '/settings').catchError((error) {
                context.showInfoSnackBar('هذه الميزة قيد التطوير');
                return null;
              });
            },
            tooltip: 'الإعدادات',
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space4,
        vertical: ThemeConstants.space3,
      ),
      decoration: BoxDecoration(
        color: context.cardColor.withValues(alpha: 0.6),
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
          // أيقونة جانبية
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: context.primaryGradient,
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
              Icons.apps_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space3),
          
          // النص
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الميزات الرئيسية',
                  style: context.titleLarge?.copyWith(
                    fontWeight: ThemeConstants.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'اختر الميزة التي تريد استخدامها',
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // زر عرض الكل
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: ThemeConstants.space3,
              vertical: ThemeConstants.space1,
            ),
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
              border: Border.all(
                color: context.primaryColor.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'عرض الكل',
                  style: context.labelMedium?.copyWith(
                    color: context.primaryColor,
                    fontWeight: ThemeConstants.semiBold,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: context.primaryColor,
                  size: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    HapticFeedback.lightImpact();
    
    // محاكاة تحديث البيانات
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (mounted) {
      context.showSuccessSnackBar('تم تحديث البيانات بنجاح');
    }
  }
}