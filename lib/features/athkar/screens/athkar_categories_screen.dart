// lib/features/athkar/screens/athkar_categories_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// ✅ استيرادات النظام الموحد الموجود فقط
import '../../../app/themes/index.dart';

import '../../../app/di/service_locator.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';
import '../widgets/athkar_category_card.dart';
import 'notification_settings_screen.dart';

class AthkarCategoriesScreen extends StatefulWidget {
  const AthkarCategoriesScreen({super.key});

  @override
  State<AthkarCategoriesScreen> createState() => _AthkarCategoriesScreenState();
}

class _AthkarCategoriesScreenState extends State<AthkarCategoriesScreen>
    with SingleTickerProviderStateMixin {
  late final AthkarService _service;
  late final PermissionService _permissionService;
  late final StorageService _storage;
  late final AnimationController _animationController;
  
  late Future<List<AthkarCategory>> _futureCategories;
  final Map<String, int> _progress = {};

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _storage = getIt<StorageService>();
    _permissionService = getIt<PermissionService>();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProgress();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _initialize() async {
    _futureCategories = _service.loadCategories();
    _loadProgress();
    _animationController.forward();
  }

  Future<void> _loadProgress() async {
    try {
      final categories = await _futureCategories;
      final progressMap = <String, int>{};
      
      for (final category in categories) {
        int totalCompleted = 0;
        int totalRequired = 0;
        
        final key = 'athkar_progress_${category.id}';
        final savedData = _storage.getMap(key);
        final savedProgress = savedData?.map((k, v) => MapEntry(int.parse(k), v as int)) ?? <int, int>{};
        
        for (final item in category.athkar) {
          final currentCount = savedProgress[item.id] ?? 0;
          totalCompleted += currentCount.clamp(0, item.count);
          totalRequired += item.count;
        }
        
        final percentage = totalRequired > 0 ? ((totalCompleted / totalRequired) * 100).round() : 0;
        progressMap[category.id] = percentage;
      }
      
      if (mounted) {
        setState(() {
          _progress.clear();
          _progress.addAll(progressMap);
        });
      }
    } catch (e) {
      debugPrint('Error loading progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // شريط التنقل العلوي
            _buildAppBar(context),
            
            // المحتوى
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await _loadProgress();
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // رسالة الترحيب
                    SliverToBoxAdapter(
                      child: _buildWelcomeCard(context),
                    ),
                    
                    const SliverToBoxAdapter(child: Spaces.large),
                    
                    // قائمة الفئات
                    FutureBuilder<List<AthkarCategory>>(
                      future: _futureCategories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SliverFillRemaining(
                            child: IslamicLoading(
                              message: 'جاري تحميل الأذكار...',
                              color: context.primaryColor,
                            ),
                          );
                        }
                        
                        if (snapshot.hasError) {
                          return SliverFillRemaining(
                            child: _buildErrorState(),
                          );
                        }
                        
                        final categories = snapshot.data ?? [];
                        
                        if (categories.isEmpty) {
                          return SliverFillRemaining(
                            child: _buildEmptyState(),
                          );
                        }
                        
                        return SliverPadding(
                          padding: EdgeInsets.all(context.mediumPadding),
                          sliver: AnimationLimiter(
                            child: SliverGrid(
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16,
                                childAspectRatio: 0.8,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final category = categories[index];
                                  final progress = _progress[category.id] ?? 0;
                                  
                                  return AnimationConfiguration.staggeredGrid(
                                    position: index,
                                    duration: const Duration(milliseconds: 300),
                                    columnCount: 2,
                                    child: ScaleAnimation(
                                      child: FadeInAnimation(
                                        child: AthkarCategoryCard(
                                          category: category,
                                          progress: progress,
                                          onTap: () => _openCategoryDetails(category),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                childCount: categories.length,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SliverToBoxAdapter(child: Spaces.extraLarge),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return IslamicCard.simple(
      padding: EdgeInsets.all(context.mediumPadding),
      child: Row(
        children: [
          // أيقونة التطبيق
          Container(
            padding: EdgeInsets.all(context.smallPadding),
            decoration: BoxDecoration(
              gradient: ThemeConstants.primaryGradient,
              borderRadius: BorderRadius.circular(context.mediumRadius),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
          ),
          
          SizedBox(width: context.mediumPadding),
          
          // العنوان
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('أذكار المسلم', style: context.titleStyle),
                Text(
                  'احرص على الذكر في كل وقت',
                  style: context.captionStyle,
                ),
              ],
            ),
          ),
          
          // الإجراءات
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // زر المفضلة
              IslamicCard.simple(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.favorites);
                  },
                  icon: Icon(
                    Icons.favorite_outline,
                    color: context.secondaryTextColor,
                  ),
                  tooltip: 'المفضلة',
                ),
              ),
              
              SizedBox(width: context.smallPadding),
              
              // زر إعدادات الإشعارات
              IslamicCard.simple(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AthkarNotificationSettingsScreen(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: context.secondaryTextColor,
                  ),
                  tooltip: 'إعدادات الإشعارات',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(context.mediumPadding),
      padding: EdgeInsets.all(context.mediumPadding),
      decoration: BoxDecoration(
        gradient: ThemeConstants.primaryGradient,
        borderRadius: BorderRadius.circular(context.largeRadius),
        boxShadow: ThemeConstants.shadowMd,
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 40,
            ),
          ),
          
          SizedBox(width: context.mediumPadding),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IslamicText.dua(
                  text: 'اختر فئة الأذكار',
                  color: Colors.white,
                  fontSize: 24,
                ),
                
                SizedBox(height: context.smallPadding),
                
                IslamicText.quran(
                  text: 'وَاذْكُر رَّبَّكَ كَثِيرًا وَسَبِّحْ بِالْعَشِيِّ وَالْإِبْكَارِ',
                  color: Colors.white,
                  fontSize: 16,
                ),
                
                SizedBox(height: context.smallPadding),
                
                Text(
                  'اقرأ الأذكار اليومية وحافظ على ذكر الله',
                  style: context.bodyStyle.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: ThemeConstants.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 50,
              color: ThemeConstants.error,
            ),
          ),
          
          const Spaces.large,
          
          Text(
            'حدث خطأ في تحميل البيانات',
            style: context.titleStyle.copyWith(color: ThemeConstants.error),
            textAlign: TextAlign.center,
          ),
          
          const Spaces.large,
          
          IslamicButton.outlined(
            text: 'إعادة المحاولة',
            icon: Icons.refresh,
            onPressed: () {
              setState(() {
                _futureCategories = _service.loadCategories();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: context.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.menu_book_outlined,
              size: 50,
              color: context.primaryColor,
            ),
          ),
          
          const Spaces.large,
          
          Text(
            'لا توجد أذكار متاحة حالياً',
            style: context.titleStyle,
            textAlign: TextAlign.center,
          ),
          
          const Spaces.medium,
          
          Text(
            'سيتم إضافة الأذكار قريباً',
            style: context.captionStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _openCategoryDetails(AthkarCategory category) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(
      context,
      AppRouter.athkarDetails,
      arguments: category.id,
    ).then((_) {
      _loadProgress();
    });
  }
}