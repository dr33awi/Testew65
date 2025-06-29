// lib/features/athkar/screens/athkar_categories_screen.dart - محدث بالثيم الإسلامي الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ✅ استيراد النظام الموحد الإسلامي - الوحيد المسموح
import 'package:athkar_app/app/themes/index.dart';

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
  
  List<AnimationController>? _controllers;
  List<Animation<double>>? _scaleAnimations;
  List<Animation<double>>? _fadeAnimations;
  
  // انيميشن التلميع للكارد الترحيبي
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
      duration: AppTheme.durationSlow,
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProgress();
  }

  Future<void> _initialize() async {
    _futureCategories = _service.loadCategories();
    _checkNotificationPermission();
    _loadProgress();
  }

  void _setupAnimations(int itemCount) {
    // تنظيف الانيميشن السابق
    if (_controllers != null) {
      for (var controller in _controllers!) {
        controller.dispose();
      }
    }
    
    _controllers = List.generate(itemCount, (index) {
      return AnimationController(
        duration: Duration(milliseconds: 600 + (index * 100)),
        vsync: this,
      );
    });

    _scaleAnimations = _controllers!.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.elasticOut,
      ));
    }).toList();

    _fadeAnimations = _controllers!.map((controller) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ));
    }).toList();

    // بدء الانيميشن تدريجياً
    for (int i = 0; i < _controllers!.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted && _controllers != null && i < _controllers!.length) {
          _controllers![i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    if (_controllers != null) {
      for (var controller in _controllers!) {
        controller.dispose();
      }
    }
    super.dispose();
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
      backgroundColor: AppTheme.background,
      // ✅ استخدام AppAppBar الموحد
      appBar: AppAppBar.home(
        title: 'أذكار المسلم',
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppTheme.textSecondary,
            ),
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
        color: AppTheme.primary,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // رسالة الترحيب مدمجة في الصفحة
            SliverToBoxAdapter(
              child: _buildWelcomeSection(),
            ),
            
            SliverToBoxAdapter(
              child: AppTheme.space4.h,
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
                    child: AppEmptyState.noData(
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
                
                // إعداد الانيميشن عند تحميل البيانات
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && (_controllers == null || _controllers!.length != categories.length)) {
                    _setupAnimations(categories.length);
                  }
                });
                
                return SliverPadding(
                  padding: AppTheme.space4.padding,
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: AppTheme.space3,
                      crossAxisSpacing: AppTheme.space3,
                      childAspectRatio: 0.95,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final category = categories[index];
                        final progress = _progress[category.id] ?? 0;
                        
                        // إذا لم يتم إعداد الانيميشن بعد، أرجع البطاقة بدون انيميشن
                        if (_scaleAnimations == null || _fadeAnimations == null || 
                            index >= _scaleAnimations!.length || index >= _fadeAnimations!.length) {
                          return _buildCategoryCard(category, progress);
                        }
                        
                        return AnimatedBuilder(
                          animation: Listenable.merge([
                            _scaleAnimations![index],
                            _fadeAnimations![index],
                          ]),
                          builder: (context, child) {
                            return FadeTransition(
                              opacity: _fadeAnimations![index],
                              child: ScaleTransition(
                                scale: _scaleAnimations![index],
                                child: _buildCategoryCard(category, progress),
                              ),
                            );
                          },
                        );
                      },
                      childCount: categories.length,
                    ),
                  ),
                );
              },
            ),
            
            SliverToBoxAdapter(
              child: AppTheme.space8.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Padding(
      padding: AppTheme.space4.padding,
      child: AppCard(
        useGradient: true,
        color: AppTheme.primary,
        onTap: () {
          HapticFeedback.lightImpact();
          // يمكن إضافة إجراء عند الضغط على كارد الترحيب
        },
        child: Stack(
          children: [
            // المحتوى الرئيسي
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'وَاذْكُر رَّبَّكَ كَثِيرًا وَسَبِّحْ بِالْعَشِيِّ وَالْإِبْكَارِ',
                  style: AppTheme.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.bold,
                    height: 1.4,
                  ),
                ),
                
                AppTheme.space2.h,
                
                Text(
                  'اقرأ الأذكار اليومية وحافظ على ذكر الله',
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
            
            // تأثير التلميع المتحرك
            Positioned.fill(
              child: AnimatedBuilder(
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
                      borderRadius: AppTheme.radiusLg.radius,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(AthkarCategory category, int progress) {
    return AppCard.category(
      categoryId: category.id,
      title: category.title,
      count: category.athkar.length,
      onTap: () => _openCategoryDetails(category),
      isCompact: true,
      customDescription: CategoryUtils.getDescription(category.id),
    );
  }
}