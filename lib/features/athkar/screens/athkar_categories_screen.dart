// lib/features/athkar/screens/athkar_categories_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/routes/app_router.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../../../core/infrastructure/services/notifications/notification_manager.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';
import '../widgets/athkar_category_card.dart';

class AthkarCategoriesScreen extends StatefulWidget {
  const AthkarCategoriesScreen({super.key});

  @override
  State<AthkarCategoriesScreen> createState() => _AthkarCategoriesScreenState();
}

class _AthkarCategoriesScreenState extends State<AthkarCategoriesScreen>
    with SingleTickerProviderStateMixin {
  late final AthkarService _service;
  late final PermissionService _permissionService;
  late final AnimationController _animationController;
  
  late Future<List<AthkarCategory>> _futureCategories;
  final Map<String, int> _progress = {};
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _permissionService = getIt<PermissionService>();
    _animationController = AnimationController(
      vsync: this,
      duration: ThemeConstants.durationNormal,
    );
    
    _initialize();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // تحديث البيانات عند العودة من صفحة التفاصيل
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
        final percentage = await _service.getCategoryCompletionPercentage(category.id);
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

  Future<void> _requestNotificationPermission() async {
    final status = await _permissionService.requestPermission(
      AppPermissionType.notification,
    );
    
    if (status == AppPermissionStatus.granted) {
      setState(() => _notificationsEnabled = true);
      context.showSuccessSnackBar('تم تفعيل الإشعارات بنجاح');
      
      // جدولة التذكيرات
      await _service.scheduleCategoryReminders();
    } else if (status == AppPermissionStatus.permanentlyDenied) {
      final shouldOpenSettings = await AppInfoDialog.showConfirmation(
        context: context,
        title: 'الإشعارات مطلوبة',
        content: 'يرجى تفعيل الإشعارات من إعدادات التطبيق لتلقي تذكيرات الأذكار',
        confirmText: 'فتح الإعدادات',
        cancelText: 'لاحقاً',
        icon: Icons.notifications_off,
      );
      
      if (shouldOpenSettings == true) {
        await _permissionService.openAppSettings();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: RefreshIndicator(
        onRefresh: () async {
          await _loadProgress();
        },
        child: CustomScrollView(
          slivers: [
            // AppBar مخصص مع ألوان الثيم
            _buildSliverAppBar(context),
            

            
            // العنوان
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  ThemeConstants.space4,
                  ThemeConstants.space4,
                  ThemeConstants.space4,
                  ThemeConstants.space2,
                ),
                child: Text(
                  'فئات الأذكار',
                  style: context.titleLarge?.copyWith(
                    fontWeight: ThemeConstants.bold,
                    color: context.textPrimaryColor,
                  ),
                ),
              ),
            ),
            
            // قائمة الفئات
            FutureBuilder<List<AthkarCategory>>(
              future: _futureCategories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(
                    child: Center(
                      child: AppLoading.page(
                        message: 'جاري تحميل الأذكار...',
                      ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.space4,
                    vertical: ThemeConstants.space2,
                  ),
                  sliver: AnimationLimiter(
                    child: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: ThemeConstants.space3,
                        crossAxisSpacing: ThemeConstants.space3,
                        childAspectRatio: 0.85,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final category = categories[index];
                          final progress = _progress[category.id] ?? 0;
                          
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: ThemeConstants.durationNormal,
                            columnCount: 2,
                            child: ScaleAnimation(
                              child: FadeInAnimation(
                                child: AthkarCategoryCard(
                                  category: category,
                                  progress: progress,
                                  onTap: () => _openCategoryDetails(category),
                                  onNotificationToggle: _notificationsEnabled
                                      ? () => _toggleCategoryNotification(category)
                                      : null,
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
            
            // مساحة إضافية
            const SliverPadding(
              padding: EdgeInsets.only(bottom: ThemeConstants.space8),
            ),
          ],
        ),
      ),
      
      // زر الإشعارات العائم
      floatingActionButton: _buildNotificationFAB(),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: true,
      snap: true,
      backgroundColor: ThemeConstants.primary,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.space4,
          vertical: ThemeConstants.space3,
        ),
        title: Row(
          children: [
            // الشعار
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
              child: Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: ThemeConstants.iconMd,
              ),
            ),
            
            ThemeConstants.space3.w,
            
            // العنوان
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'الأذكار',
                    style: context.titleLarge?.copyWith(
                      fontWeight: ThemeConstants.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'حصن المسلم',
                    style: context.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: ThemeConstants.primaryGradient,
          ),
          child: CustomPaint(
            painter: _BackgroundPatternPainter(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ),
      ),
      actions: [
        // زر المفضلة
        AppBarAction(
          icon: Icons.favorite_outline,
          color: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.favorites);
          },
          tooltip: 'المفضلة',
        ),
        
        // زر الإعدادات
        AppBarAction(
          icon: Icons.settings,
          color: Colors.white,
          onPressed: () {
            Navigator.pushNamed(context, AppRouter.appSettings);
          },
          tooltip: 'الإعدادات',
        ),
      ],
    );
  }

  Widget? _buildNotificationFAB() {
    if (_notificationsEnabled) return null;
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: _animationController,
            curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
          ),
          child: FloatingActionButton.extended(
            onPressed: _requestNotificationPermission,
            backgroundColor: ThemeConstants.accent,
            icon: const Icon(Icons.notifications_off),
            label: const Text('تفعيل التذكيرات'),
          ),
        );
      },
    );
  }

  void _openCategoryDetails(AthkarCategory category) {
    HapticFeedback.lightImpact();
    Navigator.pushNamed(
      context,
      AppRouter.athkarDetails,
      arguments: category.id,
    ).then((_) {
      // تحديث البيانات عند العودة
      _loadProgress();
    });
  }

  Future<void> _toggleCategoryNotification(AthkarCategory category) async {
    HapticFeedback.lightImpact();
    
    if (category.notifyTime == null) {
      context.showInfoSnackBar('هذه الفئة لا تحتوي على وقت تنبيه');
      return;
    }
    
    final enabledIds = _service.getEnabledReminderCategories();
    final isEnabled = enabledIds.contains(category.id);
    
    if (!isEnabled) {
      await NotificationManager.instance.scheduleAthkarReminder(
        categoryId: category.id,
        categoryName: category.title,
        time: category.notifyTime!,
      );
      context.showSuccessSnackBar('تم تفعيل تذكير ${category.title}');
    } else {
      await NotificationManager.instance.cancelAthkarReminder(category.id);
      context.showInfoSnackBar('تم إيقاف تذكير ${category.title}');
    }
  }
}

// رسام النمط في الخلفية
class _BackgroundPatternPainter extends CustomPainter {
  final Color color;

  _BackgroundPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const spacing = 30.0;
    
    // رسم خطوط مائلة
    for (double i = -size.height; i < size.width + size.height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}