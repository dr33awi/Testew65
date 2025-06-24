// lib/features/athkar/screens/athkar_categories_screen.dart - محدث
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: CustomAppBar.simple(
        title: 'أذكار المسلم',
        actions: [
          AppBarAction(
            icon: ThemeConstants.iconNotifications,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AthkarNotificationSettingsScreen(),
              ),
            ),
            tooltip: 'إعدادات الإشعارات',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadProgress();
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // رسالة الترحيب مدمجة في الصفحة
            SliverToBoxAdapter(
              child: _buildWelcomeSection(context),
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
                            mainAxisSpacing: ThemeConstants.space3,
                            crossAxisSpacing: ThemeConstants.space3,
                            childAspectRatio: 1.0, // تصغير حجم الفئات
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final category = categories[index];
                              final progress = _progress[category.id] ?? 0;
                              
                              return AppCard(
                                type: CardType.normal,
                                style: CardStyle.gradient,
                                primaryColor: ThemeConstants.success, // اللون الأخضر الموجود في النظام
                                onTap: () => _openCategoryDetails(category),
                                margin: EdgeInsets.zero,
                                borderRadius: ThemeConstants.radius3xl,
                                child: _buildCategoryContent(context, category, progress),
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
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: AppCard(
        type: CardType.info,
        style: CardStyle.gradient,
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

  Widget _buildCategoryContent(BuildContext context, AthkarCategory category, int progress) {
    final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
    final isCompleted = progress >= 100;
    
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4), // تقليل المساحة الداخلية
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // أيقونة أصغر
          Container(
            width: 60, // تصغير حجم الأيقونة
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.25),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              categoryIcon,
              color: Colors.white,
              size: 32, // تصغير حجم الأيقونة
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space3),
          
          // عنوان أصغر
          Text(
            category.title,
            style: context.titleMedium?.copyWith( // استخدام titleMedium بدلاً من titleLarge
              color: Colors.white,
              fontWeight: ThemeConstants.bold,
              fontSize: 16, // تصغير حجم الخط
              height: 1.3,
              shadows: const [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 1),
                  blurRadius: 3,
                ),
              ],
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          // مؤشر الإكمال إذا كانت مكتملة
          if (isCompleted) ...[
            const SizedBox(height: ThemeConstants.space2),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: ThemeConstants.space2,
                vertical: ThemeConstants.space1,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 14, // تصغير الأيقونة
                  ),
                  const SizedBox(width: ThemeConstants.space1),
                  Text(
                    'مكتمل',
                    style: context.labelSmall?.copyWith( // استخدام labelSmall
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}