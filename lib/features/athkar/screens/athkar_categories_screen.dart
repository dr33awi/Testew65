// lib/features/athkar/screens/athkar_categories_screen.dart (مُصلح)
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart'; // ✅ يحتوي على AppLoading و AppEmptyState
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

class _AthkarCategoriesScreenState extends State<AthkarCategoriesScreen> {
  late final AthkarService _service;
  late final PermissionService _permissionService;
  late final StorageService _storage;
  
  late Future<List<AthkarCategory>> _futureCategories;
  final Map<String, int> _progress = {};
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _storage = getIt<StorageService>();
    _permissionService = getIt<PermissionService>();
    
    _initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProgress();
  }

  Future<void> _initialize() async {
    _futureCategories = _service.loadCategories();
    _checkNotificationPermission();
    _loadProgress();
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
                    
                    const SliverToBoxAdapter(
                      child: SizedBox(height: ThemeConstants.space4),
                    ),
                    
                    // قائمة الفئات
                    FutureBuilder<List<AthkarCategory>>(
                      future: _futureCategories,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return SliverFillRemaining(
                            child: Center(
                              // ✅ استخدام AppLoading من app_theme.dart
                              child: AppLoading.page(
                                message: 'جاري تحميل الأذكار...',
                              ),
                            ),
                          );
                        }
                        
                        if (snapshot.hasError) {
                          return SliverFillRemaining(
                            // ✅ استخدام AppEmptyState من app_theme.dart
                            child: AppEmptyState.error(
                              message: 'حدث خطأ في تحميل البيانات',
                              onRetry: () {
                                setState(() {
                                  _futureCategories = _service.loadCategories();
                                });
                              },
                            ),
                          );
                        }
                        
                        final categories = snapshot.data ?? [];
                        
                        if (categories.isEmpty) {
                          return SliverFillRemaining(
                            // ✅ استخدام AppEmptyState من app_theme.dart
                            child: AppEmptyState.noData(
                              message: 'لا توجد أذكار متاحة حالياً',
                            ),
                          );
                        }
                        
                        return SliverPadding(
                          padding: const EdgeInsets.all(ThemeConstants.space4),
                          sliver: SliverGrid(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: ThemeConstants.space4,
                              crossAxisSpacing: ThemeConstants.space4,
                              childAspectRatio: 0.8,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final category = categories[index];
                                final progress = _progress[category.id] ?? 0;
                                
                                return AthkarCategoryCard(
                                  category: category,
                                  progress: progress,
                                  onTap: () => _openCategoryDetails(category),
                                );
                              },
                              childCount: categories.length,
                            ),
                          ),
                        );
                      },
                    ),
                    
                    const SliverToBoxAdapter(
                      child: SizedBox(height: ThemeConstants.space8),
                    ),
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
              ThemeConstants.iconAthkar,
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
                  'أذكار المسلم',
                  style: context.titleLarge?.copyWith(
                    fontWeight: ThemeConstants.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
                Text(
                  'احرص على الذكر في كل وقت',
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
              // زر المفضلة
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
                    Navigator.pushNamed(context, AppRouter.favorites);
                  },
                  icon: Icon(
                    ThemeConstants.iconFavoriteOutline,
                    color: context.primaryColor,
                  ),
                  tooltip: 'المفضلة',
                ),
              ),
              
              const SizedBox(width: ThemeConstants.space2),
              
              // زر إعدادات الإشعارات
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: ThemeConstants.opacity30),
                  ),
                  boxShadow: ThemeConstants.shadowSm,
                ),
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AthkarNotificationSettingsScreen(),
                          ),
                        );
                      },
                      icon: Icon(
                        ThemeConstants.iconNotifications,
                        color: _notificationsEnabled 
                            ? context.primaryColor 
                            : context.textSecondaryColor,
                      ),
                      tooltip: 'إعدادات الإشعارات',
                    ),
                    // نقطة التنبيه للإشعارات المفعلة
                    if (_notificationsEnabled)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: context.successColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
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
      margin: const EdgeInsets.symmetric(horizontal: ThemeConstants.space4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        gradient: context.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: context.primaryColor.withValues(alpha: ThemeConstants.opacity30),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(ThemeConstants.space5),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                width: ThemeConstants.borderThin,
              ),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
            ),
            child: Row(
              children: [
                // أيقونة الأذكار مع خلفية دائرية
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: ThemeConstants.opacity30),
                      width: ThemeConstants.borderThin,
                    ),
                  ),
                  child: const Icon(
                    ThemeConstants.iconAthkar,
                    color: Colors.white,
                    size: ThemeConstants.icon2xl,
                  ),
                ),
                
                const SizedBox(width: ThemeConstants.space4),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اختر فئة الأذكار',
                        style: context.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: ThemeConstants.bold,
                        ),
                      ),
                      
                      const SizedBox(height: ThemeConstants.space2),
                      
                      Text(
                        'وَاذْكُر رَّبَّكَ كَثِيرًا وَسَبِّحْ بِالْعَشِيِّ وَالْإِبْكَارِ',
                        style: context.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: ThemeConstants.opacity90),
                          fontFamily: ThemeConstants.fontFamilyQuran,
                          height: 1.8,
                        ),
                      ),
                      
                      const SizedBox(height: ThemeConstants.space2),
                      
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: ThemeConstants.space3,
                          vertical: ThemeConstants.space1,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: ThemeConstants.opacity20),
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: ThemeConstants.opacity30),
                            width: ThemeConstants.borderThin,
                          ),
                        ),
                        child: Text(
                          'اقرأ الأذكار اليومية وحافظ على ذكر الله',
                          style: context.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: ThemeConstants.opacity90),
                            fontWeight: ThemeConstants.medium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
