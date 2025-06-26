// lib/features/athkar/screens/athkar_categories_screen.dart - محدث مع نمط Glassmorphism
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui'; // للـ ImageFilter
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

class _AthkarCategoriesScreenState extends State<AthkarCategoriesScreen> 
    with TickerProviderStateMixin {
  late final AthkarService _service;
  late final PermissionService _permissionService;
  late final StorageService _storage;
  
  late Future<List<AthkarCategory>> _futureCategories;
  final Map<String, int> _progress = {};
  bool _notificationsEnabled = false;
  
  // إضافة Animation Controller للتلميع
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _storage = getIt<StorageService>();
    _permissionService = getIt<PermissionService>();
    
    _setupShimmerAnimation();
    _initialize();
  }

  void _setupShimmerAnimation() {
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(
      begin: -2.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
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
                            childAspectRatio: 1.0,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final category = categories[index];
                              final progress = _progress[category.id] ?? 0;
                              
                              return _buildGlassmorphismCard(context, category, progress);
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
    final gradientColors = [
      context.primaryColor,
      context.primaryLightColor,
    ];
    
    return Padding(
      padding: const EdgeInsets.all(ThemeConstants.space4),
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(
          minHeight: 140,
          maxHeight: 180,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          boxShadow: [
            BoxShadow(
              color: gradientColors.first.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: -5,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
          child: Stack(
            children: [
              // الخلفية المتدرجة
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors.map((c) => 
                      c.withValues(alpha: 0.95)
                    ).toList(),
                  ),
                ),
              ),
              
              // تأثير التلميع المتحرك
              AnimatedBuilder(
                animation: _shimmerAnimation,
                builder: (context, child) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.1),
                          Colors.transparent,
                        ],
                        stops: [
                          (_shimmerAnimation.value - 0.3).clamp(0.0, 1.0),
                          _shimmerAnimation.value.clamp(0.0, 1.0),
                          (_shimmerAnimation.value + 0.3).clamp(0.0, 1.0),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              // الطبقة الزجاجية
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(ThemeConstants.radius2xl),
                  ),
                ),
              ),
              
              // المحتوى الرئيسي
              Padding(
                padding: const EdgeInsets.all(ThemeConstants.space4),
                child: Row(
                  children: [
                    // الأيقونة المتحركة
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.2),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 800),
                        curve: Curves.elasticOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Transform.rotate(
                              angle: value * 0.1,
                              child: Icon(
                                ThemeConstants.iconAthkar,
                                color: Colors.white,
                                size: 28,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    
                    const SizedBox(width: ThemeConstants.space4),
                    
                    // النصوص
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // النص الرئيسي
                          Text(
                            'وَاذْكُر رَّبَّكَ كَثِيرًا وَسَبِّحْ بِالْعَشِيِّ وَالْإِبْكَارِ',
                            style: context.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: ThemeConstants.bold,
                              height: 1.1,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: ThemeConstants.space1),
                          
                          // النص الفرعي
                          Text(
                            'اقرأ الأذكار اليومية وحافظ على ذكر الله',
                            style: context.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.3,
                              fontWeight: ThemeConstants.medium,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // نقاط زخرفية
              _buildWelcomeDecorativeElements(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeDecorativeElements() {
    return Positioned.fill(
      child: Stack(
        children: [
          // دائرة زخرفية علوية يمين
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
          ),
          
          // دائرة زخرفية سفلية يسار
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
          ),
          
          // نقاط صغيرة
          Positioned(
            top: 30,
            left: 40,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ),
          
          Positioned(
            bottom: 50,
            right: 60,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassmorphismCard(BuildContext context, AthkarCategory category, int progress) {
    final categoryColor = ThemeConstants.success;
    final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
    final gradientColors = [
      categoryColor,
      categoryColor.darken(0.2),
    ];
    
    return GestureDetector(
      onTap: () => _openCategoryDetails(category),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
          boxShadow: [
            BoxShadow(
              color: categoryColor.withValues(alpha: 0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: -3,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
          child: Stack(
            children: [
              // الخلفية المتدرجة
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradientColors.map((c) => 
                      c.withValues(alpha: 0.9)
                    ).toList(),
                  ),
                ),
              ),
              
              // الطبقة الزجاجية
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
              ),
              
              // المحتوى
              Padding(
                padding: const EdgeInsets.all(ThemeConstants.space4),
                child: _buildCategoryContent(context, category, progress),
              ),
              
              // طبقة التفاعل
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _openCategoryDetails(category),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                  splashColor: Colors.white.withValues(alpha: 0.2),
                  highlightColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              
              // عناصر زخرفية
              _buildDecorativeElements(categoryColor),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDecorativeElements(Color categoryColor) {
    return Positioned.fill(
      child: Stack(
        children: [
          // دائرة زخرفية صغيرة
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
          
          // خط زخرفي
          Positioned(
            bottom: 12,
            left: 12,
            child: Container(
              width: 30,
              height: 2,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryContent(BuildContext context, AthkarCategory category, int progress) {
    final categoryIcon = CategoryHelper.getCategoryIcon(category.id);
    final isCompleted = progress >= 100;
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // أيقونة أصغر
        Container(
          width: 60,
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
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            categoryIcon,
            color: Colors.white,
            size: 32,
          ),
        ),
        
        const SizedBox(height: ThemeConstants.space3),
        
        // عنوان أصغر
        Text(
          category.title,
          style: context.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: ThemeConstants.bold,
            fontSize: 16,
            height: 1.3,
            letterSpacing: 0.3,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.4),
                offset: const Offset(0, 2),
                blurRadius: 4,
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
                  size: 14,
                ),
                const SizedBox(width: ThemeConstants.space1),
                Text(
                  'مكتمل',
                  style: context.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: ThemeConstants.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}