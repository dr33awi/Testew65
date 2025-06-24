// lib/features/home/screens/home_screen.dart
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

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // شريط التنقل العلوي بنفس نمط شاشة الأذكار
            _buildAppBar(context),
            
            // المحتوى الرئيسي
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        ThemeConstants.space3.h,
                        
                        // رسالة الترحيب
                        const WelcomeMessage(),
                        
                        ThemeConstants.space5.h,
                        
                        // بطاقة مواقيت الصلاة
                        const PrayerTimesCard(),
                        
                        ThemeConstants.space5.h,
                        
                        // بطاقة الاقتباسات اليومية
                        const DailyQuotesCard(),
                        
                        ThemeConstants.space5.h,
                        
                        
                        ThemeConstants.space6.h,
                        
                        // عنوان الفئات
                        _buildSectionTitle(context, 'الميزات الرئيسية'),
                        
                        ThemeConstants.space4.h,
                      ]),
                    ),
                  ),
                  
                  // شبكة الفئات
                  const CategoryGrid(),
                  
                  // مساحة إضافية في الأسفل
                  SliverToBoxAdapter(
                    child: ThemeConstants.space8.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Row(
        children: [
          // أيقونة التطبيق
          Container(
            padding: const EdgeInsets.all(ThemeConstants.space3),
            decoration: BoxDecoration(
              gradient: context.primaryGradient,
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              boxShadow: ThemeConstants.shadowSm,
            ),
            child: const Icon(
              Icons.home_rounded,
              color: Colors.white,
              size: ThemeConstants.iconMd,
            ),
          ),
          
          const SizedBox(width: ThemeConstants.space3),
          
          // العنوان
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أذكاري',
                  style: context.titleLarge?.copyWith(
                    fontWeight: ThemeConstants.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
                Text(
                  'تطبيقك للأذكار والدعاء',
                  style: context.bodySmall?.copyWith(
                    color: context.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          
          // الإجراءات
          Row(
            children: [
              // زر البحث
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: ThemeConstants.opacity30),
                  ),
                  boxShadow: ThemeConstants.shadowSm,
                ),
                child: IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    // يمكن إضافة وظيفة البحث هنا
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('البحث قيد التطوير'),
                        backgroundColor: ThemeConstants.info,
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.search_rounded,
                    color: context.textSecondaryColor,
                  ),
                  tooltip: 'البحث',
                ),
              ),
              
              const SizedBox(width: ThemeConstants.space2),
              
              // زر الإعدادات
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: ThemeConstants.opacity30),
                  ),
                  boxShadow: ThemeConstants.shadowSm,
                ),
                child: IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pushNamed(context, '/settings').catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('هذه الميزة قيد التطوير'),
                          backgroundColor: ThemeConstants.info,
                        ),
                      );
                      return null;
                    });
                  },
                  icon: Icon(
                    Icons.settings_rounded,
                    color: context.primaryColor,
                  ),
                  tooltip: 'الإعدادات',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: context.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        
        ThemeConstants.space3.w,
        
        Text(
          title,
          style: context.titleLarge?.copyWith(
            fontWeight: ThemeConstants.bold,
            color: context.textPrimaryColor,
          ),
        ),
        
        const Spacer(),
        
        TextButton(
          onPressed: () {
            // يمكن إضافة وظيفة "عرض الكل"
          },
          child: Text(
            'عرض الكل',
            style: context.labelLarge?.copyWith(
              color: context.primaryColor,
              fontWeight: ThemeConstants.semiBold,
            ),
          ),
        ),
      ],
    );
  }
}