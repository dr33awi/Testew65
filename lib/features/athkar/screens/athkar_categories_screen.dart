// lib/features/athkar/screens/athkar_categories_screen.dart - مُحدث بالـ widgets الموحدة
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';
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
      // ✅ استخدام CustomAppBar الموحد بدلاً من custom AppBar
      appBar: CustomAppBar.simple(
        title: 'أذكار المسلم',
        actions: [
          AppBarAction(
            icon: ThemeConstants.iconFavoriteOutline,
            onPressed: () => Navigator.pushNamed(context, AppRouter.favorites),
            tooltip: 'المفضلة',
          ),
          AppBarAction(
            icon: ThemeConstants.iconNotifications,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AthkarNotificationSettingsScreen(),
              ),
            ),
            tooltip: 'إعدادات الإشعارات',
            badge: _notificationsEnabled ? '●' : null,
            badgeColor: context.successColor,
          ),
        ],
      ),
      body: Column(
        children: [
          // رسالة الترحيب كبطاقة موحدة
          _buildWelcomeCard(context),
          
          // المحتوى
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _loadProgress();
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(
                    child: SizedBox(height: ThemeConstants.space4),
                  ),
                  
                  // قائمة الفئات
                  FutureBuilder<List<AthkarCategory>>(
                    future: _futureCategories,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SliverFillRemaining(
                          child: AppLoading.page(
                            message: 'جاري تحميل الأذكار...',
                          ),
                        );
                      }
                      
                      if (snapshot.hasError) {
                        return SliverFillRemaining(
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
                              
                              // ✅ استخدام AppCard الموحد بدلاً من AthkarCategoryCard
                              return AppCard.athkar(
                                content: category.title,
                                currentCount: progress,
                                totalCount: 100,
                                primaryColor: CategoryHelper.getCategoryColor(context, category.id),
                                onTap: () => _openCategoryDetails(category),
                                actions: [
                                  CardAction(
                                    icon: Icons.format_list_numbered_rounded,
                                    label: '${category.athkar.length} ذكر',
                                    onPressed: () {},
                                  ),
                                  if (progress >= 100)
                                    CardAction(
                                      icon: Icons.check_circle_rounded,
                                      label: 'مكتمل',
                                      onPressed: () {},
                                      isPrimary: true,
                                    ),
                                ],
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
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    // ✅ استخدام AppCard الموحد للترحيب
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: AppCard(
        type: CardType.info,
        style: CardStyle.gradient,
        title: 'اختر فئة الأذكار',
        content: 'وَاذْكُر رَّبَّكَ كَثِيرًا وَسَبِّحْ بِالْعَشِيِّ وَالْإِبْكَارِ',
        subtitle: 'اقرأ الأذكار اليومية وحافظ على ذكر الله',
        icon: ThemeConstants.iconAthkar,
        primaryColor: context.primaryColor,
        gradientColors: [
          context.primaryColor.withValues(alpha: 0.9),
          context.primaryLightColor.withValues(alpha: 0.7),
        ],
        padding: const EdgeInsets.all(ThemeConstants.space5),
        borderRadius: ThemeConstants.radiusXl,
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