// lib/features/athkar/screens/athkar_categories_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'dart:ui';
import '../../../app/themes/app_theme.dart';
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
                      child: SizedBox(height: 16),
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
                          padding: const EdgeInsets.all(16),
                          sliver: SliverGrid(
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
                      child: SizedBox(height: 32),
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
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // أيقونة التطبيق
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 24,
            ),
          ),
          
          const SizedBox(width: 12),
          
          // العنوان
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أذكار المسلم',
                  style: context.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
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
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.favorites);
                  },
                  icon: Icon(
                    Icons.favorite_outline,
                    color: context.textSecondaryColor,
                  ),
                  tooltip: 'المفضلة',
                ),
              ),
              
              const SizedBox(width: 8),
              
              // زر إعدادات الإشعارات
              Container(
                decoration: BoxDecoration(
                  color: context.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
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
                    color: context.textSecondaryColor,
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
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF10B981).withValues(alpha: 0.9),
            const Color(0xFF059669).withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(20),
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
                
                const SizedBox(width: 16),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اختر فئة الأذكار',
                        style: context.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        'وَاذْكُر رَّبَّكَ كَثِيرًا وَسَبِّحْ بِالْعَشِيِّ وَالْإِبْكَارِ',
                        style: context.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontFamily: 'Amiri',
                        ),
                      ),
                      
                      const SizedBox(height: 8),
                      
                      Text(
                        'اقرأ الأذكار اليومية وحافظ على ذكر الله',
                        style: context.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
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

// إضافة Widgets مفقودة (يجب إضافتها في ملف منفصل)
class AppLoading {
  static Widget page({String? message}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3,
          ),
        ),
        if (message != null) ...[
          const SizedBox(height: 20),
          Text(
            message,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class AppEmptyState {
  static Widget error({
    required String message,
    VoidCallback? onRetry,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444).withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline,
            size: 64,
            color: Color(0xFFEF4444),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'خطأ في التحميل',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
        if (onRetry != null) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('المحاولة مرة أخرى'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ],
    );
  }

  static Widget noData({
    required String message,
    String? description,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
            ),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.location_on,
            size: 64,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
        if (onAction != null && actionText != null) ...[
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onAction,
            icon: const Icon(Icons.my_location),
            label: Text(actionText),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ],
    );
  }
}