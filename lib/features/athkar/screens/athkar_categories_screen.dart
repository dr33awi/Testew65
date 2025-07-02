// lib/features/athkar/screens/athkar_categories_screen.dart
import 'package:flutter/material.dart';
import 'package:athkar_app/app/di/service_locator.dart';
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:athkar_app/app/routes/app_router.dart';
import '../models/athkar_model.dart';
import '../services/athkar_service.dart';

/// شاشة فئات الأذكار مع التصميم الموحد
class AthkarCategoriesScreen extends StatefulWidget {
  const AthkarCategoriesScreen({super.key});

  @override
  State<AthkarCategoriesScreen> createState() => _AthkarCategoriesScreenState();
}

class _AthkarCategoriesScreenState extends State<AthkarCategoriesScreen>
    with SingleTickerProviderStateMixin {
  late final AthkarService _athkarService;
  late final AnimationController _animationController;
  
  List<AthkarCategory> _categories = [];
  Map<String, int> _completionPercentages = {};
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _athkarService = getService<AthkarService>();
    _animationController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );
    _loadData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // تحميل الفئات
      final categories = await _athkarService.loadCategories();
      
      // تحميل نسب الإكمال
      final completionMap = <String, int>{};
      for (final category in categories) {
        completionMap[category.id] = 
            await _athkarService.getCategoryCompletionPercentage(category.id);
      }

      if (mounted) {
        setState(() {
          _categories = categories;
          _completionPercentages = completionMap;
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

  List<AthkarCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) return _categories;
    
    return _categories.where((category) {
      return category.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             (category.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.simple(
        title: 'الأذكار',
        actions: [
          AppBarAction(
            icon: AppIconsSystem.settings,
            onPressed: () => Navigator.pushNamed(
              context, 
              AppRouter.athkarNotificationsSettings,
            ),
            tooltip: 'إعدادات التذكيرات',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: Column(
          children: [
            // شريط البحث
            _buildSearchBar(),
            
            // المحتوى الرئيسي
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: context.appResponsivePadding,
      child: AppTextField.search(
        hint: 'البحث في الأذكار...',
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return Center(
        child: AppLoading.page(
          message: 'جاري تحميل الأذكار...',
        ),
      );
    }

    if (_error != null) {
      return AppEmptyState.error(
        message: _error,
        onRetry: _loadData,
      );
    }

    final filteredCategories = _filteredCategories;

    if (filteredCategories.isEmpty) {
      return _searchQuery.isNotEmpty
          ? AppEmptyState.noResults(
              searchTerm: _searchQuery,
              onClearSearch: () {
                setState(() {
                  _searchQuery = '';
                });
              },
            )
          : AppEmptyState.noAthkar(
              onRefresh: _loadData,
            );
    }

    return AnimationLimiter(
      child: ListView.builder(
        padding: context.appResponsivePadding,
        itemCount: filteredCategories.length,
        itemBuilder: (context, index) {
          final category = filteredCategories[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: ThemeConstants.durationNormal,
            child: SlideAnimation(
              verticalOffset: 50.0,
              child: FadeInAnimation(
                child: _buildCategoryCard(category, index),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(AthkarCategory category, int index) {
    final completionPercentage = _completionPercentages[category.id] ?? 0;
    final isCompleted = completionPercentage >= 100;
    
    return Container(
      margin: const EdgeInsets.only(bottom: ThemeConstants.space4),
      child: AppCard.glassCategory(
        title: category.title,
        icon: category.icon,
        primaryColor: category.color,
        onTap: () => _onCategoryTap(category),
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.all(ThemeConstants.space5),
      ).cardContainer(
        withGlass: true,
        margin: EdgeInsets.zero,
      ),
    ).animatedPress(
      onTap: () => _onCategoryTap(category),
    );
  }

  void _onCategoryTap(AthkarCategory category) {
    Navigator.pushNamed(
      context,
      AppRouter.athkarDetails,
      arguments: category.id,
    );
  }
}

/// Extension مساعدة لبناء محتوى البطاقة
extension _CategoryCardContent on _AthkarCategoriesScreenState {
  Widget _buildCategoryContent(AthkarCategory category) {
    final completionPercentage = _completionPercentages[category.id] ?? 0;
    final isCompleted = completionPercentage >= 100;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // الرأس مع الأيقونة والعنوان
        Row(
          children: [
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
              ),
              child: Icon(
                category.icon,
                color: Colors.white,
                size: 28,
              ),
            ),
            const SizedBox(width: ThemeConstants.space4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.title,
                    style: AppTextStyles.h4.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          offset: const Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  if (category.description != null) ...[
                    const SizedBox(height: ThemeConstants.space1),
                    Text(
                      category.description!,
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: ThemeConstants.space4),
        
        // شريط التقدم والإحصائيات
        _buildProgressSection(category, completionPercentage, isCompleted),
        
        const SizedBox(height: ThemeConstants.space3),
        
        // معلومات إضافية
        _buildCategoryInfo(category),
      ],
    );
  }

  Widget _buildProgressSection(AthkarCategory category, int percentage, bool isCompleted) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.space3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التقدم اليومي',
                style: AppTextStyles.label2.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: ThemeConstants.semiBold,
                ),
              ),
              Row(
                children: [
                  if (isCompleted)
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 16,
                    ),
                  const SizedBox(width: ThemeConstants.space1),
                  Text(
                    '$percentage%',
                    style: AppTextStyles.label1.copyWith(
                      color: Colors.white,
                      fontWeight: ThemeConstants.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: ThemeConstants.space2),
          ClipRRect(
            borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted ? Colors.white : Colors.white.withValues(alpha: 0.8),
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryInfo(AthkarCategory category) {
    return Row(
      children: [
        _buildInfoChip(
          icon: Icons.list,
          text: '${category.athkar.length} أذكار',
        ),
        const SizedBox(width: ThemeConstants.space2),
        if (category.notifyTime != null)
          _buildInfoChip(
            icon: Icons.schedule,
            text: '${category.notifyTime!.hour.toString().padLeft(2, '0')}:${category.notifyTime!.minute.toString().padLeft(2, '0')}',
          ),
        const Spacer(),
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
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.space2,
        vertical: ThemeConstants.space1,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.white.withValues(alpha: 0.9),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: ThemeConstants.medium,
            ),
          ),
        ],
      ),
    );
  }
}