// lib/features/athkar/screens/athkar_categories_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:athkar_app/app/di/service_locator.dart';
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:athkar_app/core/infrastructure/services/permissions/permission_service.dart';
import 'package:athkar_app/core/infrastructure/services/notifications/notification_manager.dart';
import '../models/athkar_model.dart';
import '../services/athkar_service.dart';
import 'athkar_details_screen.dart';
import 'notification_settings_screen.dart';

/// شاشة عرض فئات الأذكار الرئيسية
class AthkarCategoriesScreen extends StatefulWidget {
  const AthkarCategoriesScreen({super.key});

  @override
  State<AthkarCategoriesScreen> createState() => _AthkarCategoriesScreenState();
}

class _AthkarCategoriesScreenState extends State<AthkarCategoriesScreen>
    with TickerProviderStateMixin {
  late final AthkarService _athkarService;
  late final PermissionService _permissionService;
  late final AnimationController _animationController;
  late final AnimationController _refreshController;

  List<AthkarCategory> _categories = [];
  Map<String, int> _progressMap = {};
  bool _isLoading = true;
  String? _error;
  bool _hasNotificationPermission = false;
  AthkarStatistics? _statistics;
  String _searchQuery = '';
  List<AthkarCategory> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _athkarService = getService<AthkarService>();
    _permissionService = getService<PermissionService>();
    
    _animationController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );
    
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // تحميل متوازي للبيانات
      final results = await Future.wait([
        _athkarService.loadCategories(),
        _permissionService.checkNotificationPermission(),
        _athkarService.getStatistics(),
      ]);

      final categories = results[0] as List<AthkarCategory>;
      final hasPermission = results[1] as bool;
      final statistics = results[2] as AthkarStatistics;

      // تحميل تقدم كل فئة
      final progressMap = <String, int>{};
      for (final category in categories) {
        progressMap[category.id] = await _athkarService.getCategoryCompletionPercentage(category.id);
      }

      if (mounted) {
        setState(() {
          _categories = categories;
          _progressMap = progressMap;
          _hasNotificationPermission = hasPermission;
          _statistics = statistics;
          _filteredCategories = categories;
          _isLoading = false;
        });
        _animationController.forward();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshData() async {
    _refreshController.repeat();
    await _loadData();
    _refreshController.stop();
    _refreshController.reset();
  }

  void _filterCategories(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredCategories = _categories;
      } else {
        _filteredCategories = _categories.where((category) {
          final titleMatch = category.title.toLowerCase().contains(query.toLowerCase());
          final descMatch = category.description?.toLowerCase().contains(query.toLowerCase()) ?? false;
          final keywordsMatch = CategoryHelper.getCategoryKeywords(category.id)
              .any((keyword) => keyword.toLowerCase().contains(query.toLowerCase()));
          
          return titleMatch || descMatch || keywordsMatch;
        }).toList();
      }
    });
  }

  Future<void> _requestNotificationPermission() async {
    try {
      final granted = await _permissionService.requestNotificationPermission();
      if (mounted) {
        setState(() {
          _hasNotificationPermission = granted;
        });
        
        if (granted) {
          context.showSuccessSnackBar('تم منح إذن الإشعارات بنجاح');
        } else {
          context.showErrorSnackBar('تم رفض إذن الإشعارات');
        }
      }
    } catch (e) {
      context.showErrorSnackBar('خطأ في طلب إذن الإشعارات');
    }
  }

  Future<void> _quickToggleReminder(AthkarCategory category) async {
    try {
      final isEnabled = await _athkarService.isCategoryReminderEnabled(category.id);
      
      if (isEnabled) {
        // إلغاء التذكير
        await _athkarService.cancelReminderForCategory(category.id);
        final enabledIds = _athkarService.getEnabledReminderCategories();
        enabledIds.remove(category.id);
        await _athkarService.setEnabledReminderCategories(enabledIds);
        
        context.showInfoSnackBar('تم إلغاء تذكير ${category.title}');
      } else {
        // تفعيل التذكير
        if (!_hasNotificationPermission) {
          await _requestNotificationPermission();
          return;
        }
        
        await _athkarService.scheduleReminderForCategory(category.id);
        final enabledIds = _athkarService.getEnabledReminderCategories();
        enabledIds.add(category.id);
        await _athkarService.setEnabledReminderCategories(enabledIds);
        
        context.showSuccessSnackBar('تم تفعيل تذكير ${category.title}');
      }
      
      HapticFeedback.lightImpact();
      setState(() {}); // لتحديث أيقونة التذكير
    } catch (e) {
      context.showErrorSnackBar('خطأ في تحديث التذكير');
    }
  }

  void _navigateToCategory(AthkarCategory category) {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AthkarDetailsScreen(categoryId: category.id),
      ),
    ).then((_) {
      // تحديث التقدم عند العودة
      _loadData();
    });
  }

  void _navigateToNotificationSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AthkarNotificationSettingsScreen(),
      ),
    ).then((_) {
      _loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          if (_isLoading)
            SliverFillRemaining(
              child: Center(
                child: AppLoading.page(
                  message: 'جاري تحميل الأذكار...',
                ),
              ),
            )
          else if (_error != null)
            SliverFillRemaining(
              child: AppEmptyState.error(
                message: _error!,
                onRetry: _loadData,
              ),
            )
          else ...[
            // بطاقة الإحصائيات
            if (_statistics != null) _buildStatisticsSection(),
            
            // بطاقة حالة الإشعارات
            _buildNotificationStatusSection(),
            
            // البحث
            _buildSearchSection(),
            
            // قائمة الفئات
            _buildCategoriesGrid(),
          ],
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: context.primaryColor,
      title: RotationTransition(
        turns: _refreshController,
        child: Text(
          'الأذكار',
          style: AppTextStyles.h3.copyWith(
            color: Colors.white,
            fontWeight: ThemeConstants.bold,
          ),
        ),
      ),
      actions: [
        AppBarAction(
          icon: Icons.settings,
          onPressed: _navigateToNotificationSettings,
          tooltip: 'إعدادات التذكيرات',
          color: Colors.white,
        ),
        AppBarAction(
          icon: Icons.refresh,
          onPressed: _refreshData,
          tooltip: 'تحديث',
          color: Colors.white,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.primaryColor,
                context.primaryColor.darken(0.2),
              ],
            ),
          ),
          child: _buildHeaderContent(),
        ),
      ),
    );
  }

  Widget _buildHeaderContent() {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: kToolbarHeight + 20),
          
          // أيقونة رئيسية
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.25),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.4),
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 40,
            ),
          ),
          
          const SizedBox(height: ThemeConstants.space3),
          
          // العنوان الفرعي
          Text(
            'اختر الفئة التي تريد قراءتها',
            style: AppTextStyles.body1.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: ThemeConstants.medium,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.appResponsivePadding,
        child: AppContainerBuilder.card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.analytics,
                    color: context.primaryColor,
                    size: ThemeConstants.iconMd,
                  ),
                  const SizedBox(width: ThemeConstants.space2),
                  Text(
                    'إحصائيات اليوم',
                    style: AppTextStyles.h5.copyWith(
                      fontWeight: ThemeConstants.semiBold,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: ThemeConstants.space4),
              
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.category,
                      title: 'الفئات',
                      value: '${_statistics!.totalCategories}',
                      color: AppColorSystem.info,
                    ),
                  ),
                  const SizedBox(width: ThemeConstants.space3),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.check_circle,
                      title: 'مكتملة',
                      value: '${_statistics!.completedToday}',
                      color: AppColorSystem.success,
                    ),
                  ),
                  const SizedBox(width: ThemeConstants.space3),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.notifications,
                      title: 'مفعلة',
                      value: '${_statistics!.enabledCategories}',
                      color: AppColorSystem.accent,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: ThemeConstants.space1),
          Text(
            value,
            style: AppTextStyles.h4.copyWith(
              color: color,
              fontWeight: ThemeConstants.bold,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationStatusSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.appResponsivePadding,
        child: AppNoticeCard(
          type: _hasNotificationPermission ? NoticeType.success : NoticeType.warning,
          title: _hasNotificationPermission 
              ? 'الإشعارات مفعلة'
              : 'إذن الإشعارات مطلوب',
          message: _hasNotificationPermission
              ? 'ستصلك تذكيرات الأذكار في أوقاتها المحددة'
              : 'نحتاج إذن الإشعارات لإرسال تذكيرات الأذكار',
          action: !_hasNotificationPermission
              ? AppButton.primary(
                  text: 'منح الإذن',
                  onPressed: _requestNotificationPermission,
                  size: ButtonSize.medium,
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return SliverToBoxAdapter(
      child: Container(
        margin: context.appResponsivePadding,
        child: AppTextField.search(
          hint: 'ابحث في الأذكار...',
          onChanged: _filterCategories,
          onSubmitted: _filterCategories,
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid() {
    if (_filteredCategories.isEmpty) {
      return SliverFillRemaining(
        child: AppEmptyState.noResults(
          searchTerm: _searchQuery,
          onClearSearch: () => _filterCategories(''),
        ),
      );
    }

    return SliverPadding(
      padding: context.appResponsivePadding,
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.responsiveColumns(mobile: 1, tablet: 2, desktop: 3),
          childAspectRatio: 1.2,
          crossAxisSpacing: ThemeConstants.space4,
          mainAxisSpacing: ThemeConstants.space4,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final category = _filteredCategories[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: ThemeConstants.durationNormal,
              columnCount: context.responsiveColumns(mobile: 1, tablet: 2, desktop: 3),
              child: ScaleAnimation(
                child: FadeInAnimation(
                  child: _buildCategoryCard(category),
                ),
              ),
            );
          },
          childCount: _filteredCategories.length,
        ),
      ),
    );
  }

  Widget _buildCategoryCard(AthkarCategory category) {
    final progress = _progressMap[category.id] ?? 0;
    final isCompleted = progress >= 100;
    
    return FutureBuilder<bool>(
      future: _athkarService.isCategoryReminderEnabled(category.id),
      builder: (context, snapshot) {
        final isReminderEnabled = snapshot.data ?? false;
        
        return AppContainerBuilder.glassGradient(
          child: Stack(
            children: [
              // المحتوى الرئيسي
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _navigateToCategory(category),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                    child: Padding(
                      padding: const EdgeInsets.all(ThemeConstants.space4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // الرأس مع الأيقونة والإجراءات
                          Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
                                ),
                                child: Icon(
                                  category.icon,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              
                              const Spacer(),
                              
                              // زر التذكير السريع
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _quickToggleReminder(category),
                                  borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Icon(
                                      isReminderEnabled 
                                          ? Icons.notifications_active
                                          : Icons.notifications_off,
                                      color: isReminderEnabled 
                                          ? Colors.white
                                          : Colors.white.withValues(alpha: 0.6),
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const Spacer(),
                          
                          // العنوان
                          Text(
                            category.title,
                            style: AppTextStyles.h5.copyWith(
                              color: Colors.white,
                              fontWeight: ThemeConstants.bold,
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          
                          if (category.description != null) ...[
                            const SizedBox(height: ThemeConstants.space1),
                            Text(
                              category.description!,
                              style: AppTextStyles.caption.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          
                          const SizedBox(height: ThemeConstants.space3),
                          
                          // شريط التقدم
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'التقدم',
                                    style: AppTextStyles.caption.copyWith(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontWeight: ThemeConstants.medium,
                                    ),
                                  ),
                                  Text(
                                    '$progress%',
                                    style: AppTextStyles.caption.copyWith(
                                      color: Colors.white,
                                      fontWeight: ThemeConstants.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: ThemeConstants.space1),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
                                child: LinearProgressIndicator(
                                  value: progress / 100,
                                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isCompleted ? AppColorSystem.success : Colors.white,
                                  ),
                                  minHeight: 4,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              
              // أيقونة الإكمال
              if (isCompleted)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppColorSystem.success,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          colorKey: category.id,
          gradientColors: [
            category.color.withValues(alpha: 0.95),
            category.color.darken(0.1).withValues(alpha: 0.85),
          ],
        ).animatedPress(
          onTap: () => _navigateToCategory(category),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    if (_isLoading || _error != null) return const SizedBox.shrink();
    
    return FloatingActionButton.extended(
      onPressed: _navigateToNotificationSettings,
      backgroundColor: context.primaryColor,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.settings),
      label: Text(
        'إعدادات التذكيرات',
        style: AppTextStyles.button.copyWith(color: Colors.white),
      ),
    );
  }
}