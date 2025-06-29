// lib/features/home/screens/home_screen.dart - مع استخدام CustomAppBar الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../widgets/welcome_message.dart';
import '../widgets/category_grid.dart';
import '../../daily_quote/widgets/daily_quotes_card.dart';
import '../../prayer_times/widgets/home_prayer_times_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: _buildCustomAppBar(context),
      body: RefreshIndicator(
        onRefresh: () => _handleRefresh(context),
        color: context.primaryColor,
        backgroundColor: context.cardColor,
        child: const SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: ThemeConstants.space4,
            vertical: ThemeConstants.space2,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // رسالة الترحيب
              WelcomeMessage(),
              
              SizedBox(height: ThemeConstants.space4),
              
              // مواقيت الصلاة
              PrayerTimesCard(),
              
              SizedBox(height: ThemeConstants.space4),
              
              // الاقتباسات اليومية
              DailyQuotesCard(),
              
              SizedBox(height: ThemeConstants.space6),
              
              // شبكة الفئات مع العنوان المدمج
              SimpleCategoryGrid(),
              
              // مساحة إضافية للأسفل
              SizedBox(height: ThemeConstants.space8),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildCustomAppBar(BuildContext context) {
    return CustomAppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      toolbarHeight: 70,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: context.isDarkMode 
            ? Brightness.light 
            : Brightness.dark,
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              context.primaryColor.withValues(alpha: 0.1),
              context.primaryColor.withValues(alpha: 0.05),
              Colors.transparent,
            ],
          ),
        ),
      ),
      titleWidget: Row(
        children: [
          // أيقونة التطبيق
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.primaryColor,
                  context.primaryColor.darken(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: context.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.mosque_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space3),
          
          // اسم التطبيق والترحيب
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'مُسلم',
                  style: context.headlineSmall?.copyWith(
                    fontWeight: ThemeConstants.bold,
                    color: context.textPrimaryColor,
                    fontSize: 20,
                    height: 1.1,
                  ),
                ),
                Text(
                  'السلام عليكم ورحمة الله',
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondaryColor,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        // أيقونة الإعدادات
        Container(
          margin: const EdgeInsets.only(left: ThemeConstants.space4),
          decoration: BoxDecoration(
            color: context.cardColor.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: context.dividerColor.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: context.primaryColor.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              Icons.settings_outlined,
              color: context.primaryColor,
              size: 22,
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

  Future<void> _handleRefresh(BuildContext context) async {
    HapticFeedback.lightImpact();
    
    // محاكاة تحديث البيانات
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (context.mounted) {
      context.showSuccessSnackBar('تم تحديث البيانات بنجاح');
    }
  }
}