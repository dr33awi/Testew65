// lib/features/athkar/screens/athkar_categories_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:ui';

// ✅ استيرادات النظام الموحد الجديد
import '../../../app/themes/app_theme.dart';
import '../../../app/themes/widgets.dart';
import '../../../app/themes/colors.dart';
import '../../../app/themes/index.dart';

import '../../../app/di/service_locator.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../../../core/infrastructure/services/notifications/notification_manager.dart';
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
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _storage = getIt<StorageService>();
    _permissionService = getIt<PermissionService>();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // ثابت بدلاً من ThemeConstants
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
    _checkNotificationPermission();
    _loadProgress();
    _animationController.forward();
  }

  Future<void> _checkNotificationPermission() async {
    final status = await _permissionService.checkPermissionStatus(
      AppPermissionType.notification,
    );
    if (mounted) {
      setState(() {
        _notificationsEnabled = status == AppPermissionStatus.granted;
      });
    }
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
        child: AppColumn(
          children: [
            // شريط التنقل العلوي - استخدام النظام الموحد
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
                    
                    Spaces.large.sliverBox, // ✅ استخدام النظام الموحد
                    
                    // قائمة الفئات
                    FutureBuilder<List<AthkarCategory>>(
                      future: _futureCategories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SliverFillRemaining(
                            child: AppLoadingWidget( // ✅ النظام الموحد
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
                          padding: context.screenPadding, // ✅ النظام الموحد
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
                    
                    Spaces.extraLarge.sliverBox, // ✅ النظام الموحد
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
    return AppCard.simple( // ✅ استخدام النظام الموحد
      padding: context.mediumPadding,
      child: AppRow( // ✅ استخدام النظام الموحد
        children: [
          // أيقونة التطبيق
          Container(
            padding: context.smallPadding,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient, // ✅ النظام الموحد
              borderRadius: BorderRadius.circular(context.borderRadius),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
          ),
          
          // العنوان
          Expanded(
            child: AppColumn.small( // ✅ النظام الموحد
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.title('أذكار المسلم'), // ✅ النظام الموحد
                AppText.caption('احرص على الذكر في كل وقت'), // ✅ النظام الموحد
              ],
            ),
          ),
          
          // الإجراءات
          AppRow.small( // ✅ النظام الموحد
            children: [
              // زر المفضلة
              AppCard.simple(
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
              
              // زر إعدادات الإشعارات
              AppCard.simple(
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
    return AppCard.athkar( // ✅ استخدام النظام الموحد للأذكار
      child: AppRow( // ✅ النظام الموحد
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
          
          Expanded(
            child: AppColumn.small( // ✅ النظام الموحد
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IslamicText.dua( // ✅ النظام الموحد للنصوص الإسلامية
                  text: 'اختر فئة الأذكار',
                  color: Colors.white,
                  fontSize: 24,
                ),
                
                IslamicText.quran( // ✅ النظام الموحد
                  text: 'وَاذْكُر رَّبَّكَ كَثِيرًا وَسَبِّحْ بِالْعَشِيِّ وَالْإِبْكَارِ',
                  color: Colors.white,
                  fontSize: 16,
                ),
                
                AppText.body( // ✅ النظام الموحد
                  'اقرأ الأذكار اليومية وحافظ على ذكر الله',
                  color: Colors.white.withValues(alpha: 0.8),
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
      child: AppColumn( // ✅ النظام الموحد
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 50,
              color: AppColors.error,
            ),
          ),
          
          AppText.title( // ✅ النظام الموحد
            'حدث خطأ في تحميل البيانات',
            color: AppColors.error,
            textAlign: TextAlign.center,
          ),
          
          IslamicButton.outlined( // ✅ النظام الموحد
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
      child: AppColumn( // ✅ النظام الموحد
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
          
          AppText.title( // ✅ النظام الموحد
            'لا توجد أذكار متاحة حالياً',
            textAlign: TextAlign.center,
          ),
          
          AppText.body( // ✅ النظام الموحد
            'سيتم إضافة الأذكار قريباً',
            color: context.secondaryTextColor,
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

// ✅ إضافة Extension للSliverBox
extension SliverBoxExtension on Widget {
  Widget get sliverBox => SliverToBoxAdapter(child: this);
}