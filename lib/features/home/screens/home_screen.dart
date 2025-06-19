// lib/features/home/screens/home_screen.dart

import 'package:flutter/material.dart';

// ✅ استيرادات النظام الموحد الجديد
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets.dart';
import '../../../app/themes/colors.dart';
import '../../../app/themes/components/index.dart';

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
      appBar: IslamicAppBar( // ✅ النظام الموحد
        title: 'تطبيق الأذكار',
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
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
          padding: context.screenPadding, // ✅ النظام الموحد
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Spaces.large, // ✅ النظام الموحد
              
              // رسالة الترحيب البسيطة
              const WelcomeMessage(),
              
              Spaces.large,
              
              // بطاقة مواقيت الصلاة
              const PrayerTimesCard(),
              
              Spaces.large,
              
              // بطاقة الاقتباسات البسيطة
              const DailyQuotesCard(),
              
              Spaces.extraLarge,
              
              // عنوان الأقسام البسيط
              _buildSimpleSectionHeader(context),
              
              Spaces.large,
            ]),
          ),
        ),
        
        // شبكة الفئات البسيطة
        const CategoryGrid(),
        
        // مساحة في الأسفل
        SliverToBoxAdapter(
          child: Spaces.extraLarge,
        ),
      ],
    );
  }

  Widget _buildSimpleSectionHeader(BuildContext context) {
    return AppCard.simple( // ✅ النظام الموحد
      child: AppRow( // ✅ النظام الموحد
        children: [
          // المؤشر الجانبي
          Container(
            width: 4,
            height: 32,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient, // ✅ النظام الموحد
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // الأيقونة
          Container(
            padding: context.smallPadding, // ✅ النظام الموحد
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(context.borderRadius),
            ),
            child: Icon(
              Icons.apps_rounded,
              color: context.primaryColor,
              size: 24,
            ),
          ),
          
          // النص
          Expanded(
            child: AppColumn.small( // ✅ النظام الموحد
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title( // ✅ النظام الموحد
                  'الأقسام الرئيسية',
                ),
                AppText.caption( // ✅ النظام الموحد
                  'اختر القسم المناسب لك',
                  color: context.secondaryTextColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Extension مساعد للبناء
extension HomeScreenExtensions on BuildContext {
  // مساعدات سريعة للألوان
  Color get primaryColor => colorScheme.primary;
  Color get backgroundColor => scaffoldBackgroundColor;
  Color get textColor => textTheme.bodyLarge?.color ?? Colors.black;
  Color get secondaryTextColor => textTheme.bodySmall?.color ?? Colors.grey;
  
  // مساعدات سريعة للمساحات
  EdgeInsets get screenPadding => const EdgeInsets.all(16);
  double get borderRadius => 12.0;
  
  // مساعدات سريعة للنصوص
  TextStyle? get titleStyle => textTheme.titleLarge;
  TextStyle? get bodyStyle => textTheme.bodyMedium;
  TextStyle? get captionStyle => textTheme.bodySmall;
}