// lib/features/athkar/screens/athkar_categories_screen.dart - محدث بنمط category_grid
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
                
                // إعداد الانيميشن عند تحميل البيانات
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && (_controllers == null || _controllers!.length != categories.length)) {
                    _setupAnimations(categories.length);
                  }
                });
                
                return SliverPadding(
                  padding: const EdgeInsets.all(ThemeConstants.space4),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: ThemeConstants.space3,
                      crossAxisSpacing: ThemeConstants.space3,
                      childAspectRatio: 0.95,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final category = categories[index];
                        final progress = _progress[category.id] ?? 0;
                        
                        // إذا لم يتم إعداد الانيميشن بعد، أرجع البطاقة بدون انيميشن
                        if (_scaleAnimations == null || _fadeAnimations == null || 
                            index >= _scaleAnimations!.length || index >= _fadeAnimations!.length) {
                          return _buildCategoryCard(context, category, progress, index);
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
                                child: _buildCategoryCard(context, category, progress, index),
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
            
            const SliverToBoxAdapter(
              child: SizedBox(height: ThemeConstants.space8),
            ),
          ],
        ),
      ),
    );
  }

Widget _buildWelcomeSection(BuildContext context) {
  final welcomeColor = context.primaryColor;
  final gradientColors = [
    welcomeColor,
    welcomeColor.darken(0.2),
  ];

  return Padding(
    padding: const EdgeInsets.all(ThemeConstants.space4),
    child: GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        // يمكن إضافة إجراء عند الضغط على كارد الترحيب
      },
      child: Container(
        height: 160, // ارتفاع ثابت مثل كارد الفئات
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
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
                padding: const EdgeInsets.all(ThemeConstants.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    // النصوص
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'وَاذْكُر رَّبَّكَ كَثِيرًا وَسَبِّحْ بِالْعَشِيِّ وَالْإِبْكَارِ',
                          style: context.titleLarge?.copyWith(
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: ThemeConstants.space2),
                        
                        Text(
                          'اقرأ الأذكار اليومية وحافظ على ذكر الله',
                          style: context.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                offset: const Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // تأثير الهوفر للتفاعل
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // يمكن إضافة إجراء هنا
                  },
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                  splashColor: Colors.white.withValues(alpha: 0.2),
                  highlightColor: Colors.white.withValues(alpha: 0.1),
                ),
              ),
              
              // عناصر زخرفية
              _buildWelcomeDecorativeElements(),
              
              // تأثير التلميع المتحرك (اختياري - يمكن إزالته للحصول على نمط مطابق تماماً)
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
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget _buildWelcomeDecorativeElements() {
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
        
        // دائرة زخرفية إضافية
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
          ),
        ),
      ],
    ),
  );
}
  Widget _buildCategoryCard(BuildContext context, AthkarCategory category, int progress, int index) {
    final categoryColor = CategoryHelper.getCategoryColor(context, category.id);
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
                padding: const EdgeInsets.all(ThemeConstants.space5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // الأيقونة
                    Container(
                      width: 56,
                      height: 56,
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
                        size: 28,
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // النصوص
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category.title,
                          style: context.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: ThemeConstants.bold,
                            fontSize: 18,
                            height: 1.2,
                            letterSpacing: 0.3,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.4),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: ThemeConstants.space3),
                    
                    // مؤشر الانتقال فقط
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // تأثير الهوفر للتفاعل
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
        ],
      ),
    );
  }
}