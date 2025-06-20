// lib/features/athkar/screens/athkar_categories_screen.dart
import 'package:flutter/material.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/themes/index.dart';
import '../../../app/routes/app_router.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';
import '../utils/category_utils.dart';

/// شاشة فئات الأذكار الرئيسية
class AthkarCategoriesScreen extends StatefulWidget {
  const AthkarCategoriesScreen({super.key});

  @override
  State<AthkarCategoriesScreen> createState() => _AthkarCategoriesScreenState();
}

class _AthkarCategoriesScreenState extends State<AthkarCategoriesScreen>
    with TickerProviderStateMixin {
  late final AthkarService _athkarService;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List<AthkarCategory> _categories = [];
  Map<String, int> _progressMap = {};
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _athkarService = getService<AthkarService>();
    _initializeAnimations();
    _loadData();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: ThemeConstants.durationNormal,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart,
    ));
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final categories = await _athkarService.loadCategories();
      final progressMap = <String, int>{};

      // تحميل التقدم لكل فئة
      await Future.wait(
        categories.map((category) async {
          final progress = await _athkarService.getCategoryCompletionPercentage(category.id);
          progressMap[category.id] = progress;
        }),
      );

      setState(() {
        _categories = categories;
        _progressMap = progressMap;
        _isLoading = false;
      });

      _animationController.forward();
    } catch (e) {
      setState(() {
        _error = 'حدث خطأ في تحميل الأذكار';
        _isLoading = false;
      });
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
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return IslamicAppBar(
      title: 'الأذكار',
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => AppRouter.push(AppRouter.athkarNotificationsSettings),
          tooltip: 'إعدادات التذكيرات',
        ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _loadData,
          tooltip: 'تحديث',
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const IslamicLoading(
        message: 'جاري تحميل الأذكار...',
      );
    }

    if (_error != null) {
      return EmptyState(
        icon: Icons.error_outline,
        title: 'حدث خطأ',
        subtitle: _error,
        action: IslamicButton.primary(
          text: 'إعادة المحاولة',
          icon: Icons.refresh,
          onPressed: _loadData,
        ),
      );
    }

    if (_categories.isEmpty) {
      return const EmptyState(
        icon: Icons.menu_book,
        title: 'لا توجد أذكار',
        subtitle: 'لم يتم العثور على أي أذكار',
      );
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildCategoriesList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spaceMd),
      child: IslamicInput(
        hint: 'البحث في الأذكار...',
        prefixIcon: Icons.search,
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        suffixIcon: _searchQuery.isNotEmpty ? Icons.clear : null,
        onSuffixIconPressed: _searchQuery.isNotEmpty
            ? () {
                setState(() {
                  _searchQuery = '';
                });
              }
            : null,
      ),
    );
  }

  Widget _buildCategoriesList() {
    final filteredCategories = _filteredCategories;

    if (filteredCategories.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        title: 'لا توجد نتائج',
        subtitle: 'لم يتم العثور على أذكار تطابق البحث',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: ThemeConstants.spaceMd),
      itemCount: filteredCategories.length,
      itemBuilder: (context, index) {
        final category = filteredCategories[index];
        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final delay = index * 0.1;
            final animationValue = Curves.easeOutQuart.transform(
              (_animationController.value - delay).clamp(0.0, 1.0),
            );

            return Transform.translate(
              offset: Offset(0, 50 * (1 - animationValue)),
              child: Opacity(
                opacity: animationValue,
                child: _buildCategoryCard(category),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCategoryCard(AthkarCategory category) {
    final progress = _progressMap[category.id] ?? 0;
    final hasProgress = progress > 0;

    return IslamicCard(
      margin: const EdgeInsets.only(bottom: ThemeConstants.spaceMd),
      onTap: () => _navigateToDetails(category),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
              // Category Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: category.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  category.icon,
                  color: category.color,
                  size: ThemeConstants.iconLg,
                ),
              ),

              Spaces.mediumH,

              // Title and description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: context.titleStyle.copyWith(
                        fontWeight: ThemeConstants.fontSemiBold,
                      ),
                    ),
                    if (category.description != null) ...[
                      Spaces.xs,
                      Text(
                        category.description!,
                        style: context.captionStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                size: ThemeConstants.iconSm,
                color: context.secondaryTextColor,
              ),
            ],
          ),

          Spaces.medium,

          // Progress section
          if (hasProgress) ...[
            Row(
              children: [
                Icon(
                  Icons.trending_up,
                  size: ThemeConstants.iconSm,
                  color: ThemeConstants.success,
                ),
                Spaces.smallH,
                Text(
                  'التقدم: $progress%',
                  style: context.captionStyle.copyWith(
                    color: ThemeConstants.success,
                    fontWeight: ThemeConstants.fontMedium,
                  ),
                ),
                const Spacer(),
                Text(
                  '${category.athkar.length} ذكر',
                  style: context.captionStyle,
                ),
              ],
            ),
            Spaces.small,
            _buildProgressBar(progress),
          ] else ...[
            // Info row for categories without progress
            Row(
              children: [
                Icon(
                  Icons.menu_book,
                  size: ThemeConstants.iconSm,
                  color: context.secondaryTextColor,
                ),
                Spaces.smallH,
                Text(
                  '${category.athkar.length} ذكر',
                  style: context.captionStyle,
                ),
                const Spacer(),
                if (category.notifyTime != null) ...[
                  Icon(
                    Icons.schedule,
                    size: ThemeConstants.iconSm,
                    color: context.secondaryTextColor,
                  ),
                  Spaces.smallH,
                  Text(
                    '${category.notifyTime!.hour.toString().padLeft(2, '0')}:'
                    '${category.notifyTime!.minute.toString().padLeft(2, '0')}',
                    style: context.captionStyle,
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressBar(int progress) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: context.borderColor,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress / 100,
        child: Container(
          decoration: BoxDecoration(
            color: ThemeConstants.success,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: () {
        // يمكن إضافة وظيفة للبحث أو الأذكار المفضلة
        context.showMessage('الأذكار المفضلة - قريباً');
      },
      icon: const Icon(Icons.favorite),
      label: const Text('المفضلة'),
      backgroundColor: context.primaryColor,
    );
  }

  void _navigateToDetails(AthkarCategory category) {
    AppRouter.push(
      AppRouter.athkarDetails,
      arguments: category.id,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}