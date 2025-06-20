// lib/features/athkar/screens/athkar_details_screen.dart
import 'package:athkar_app/app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:share_plus/share_plus.dart';

// ✅ استيرادات النظام الموحد الموجود فقط
import '../../../app/themes/index.dart';

import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/utils/extensions/string_extensions.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';
import '../widgets/athkar_item_card.dart';
import '../utils/category_utils.dart';
import 'notification_settings_screen.dart';

class AthkarDetailsScreen extends StatefulWidget {
  String categoryId;
  
  AthkarDetailsScreen({
    super.key,
    String? categoryId,
  }) : categoryId = categoryId ?? '';

  @override
  State<AthkarDetailsScreen> createState() => _AthkarDetailsScreenState();
}

class _AthkarDetailsScreenState extends State<AthkarDetailsScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final AthkarService _service;
  late final StorageService _storage;
  late final AnimationController _animationController;
  
  AthkarCategory? _category;
  final Map<int, int> _counts = {};
  final Set<int> _completedItems = {};
  List<AthkarItem> _visibleItems = [];
  bool _loading = true;
  bool _allCompleted = false;
  bool _isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _storage = getIt<StorageService>();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !_isFirstLoad) {
      _resetAndReload();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final cat = await _service.getCategoryById(widget.categoryId);
      if (!mounted) return;
      
      final savedProgress = _isFirstLoad ? _loadSavedProgress() : <int, int>{};
      
      setState(() {
        _category = cat;
        if (cat != null) {
          _counts.clear();
          _completedItems.clear();
          
          for (var i = 0; i < cat.athkar.length; i++) {
            final item = cat.athkar[i];
            _counts[item.id] = savedProgress[item.id] ?? 0;
            if (_counts[item.id]! >= item.count) {
              _completedItems.add(item.id);
            }
          }
          _updateVisibleItems();
          _calculateCompletion();
        }
        _loading = false;
      });
      
      _animationController.forward();
      _isFirstLoad = false;
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _resetAndReload() async {
    if (!mounted || _loading) return;
    
    setState(() {
      _counts.clear();
      _completedItems.clear();
      _allCompleted = false;
    });
    
    await _saveProgress();
    
    if (_category != null) {
      setState(() {
        _updateVisibleItems();
        _calculateCompletion();
      });
    }
  }

  void _updateVisibleItems() {
    if (_category == null) return;
    
    _visibleItems = _category!.athkar
        .where((item) => !_completedItems.contains(item.id))
        .toList();
  }

  Map<int, int> _loadSavedProgress() {
    final key = 'athkar_progress_${widget.categoryId}';
    final data = _storage.getMap(key);
    if (data == null) return {};
    
    return data.map((k, v) => MapEntry(int.parse(k), v as int));
  }

  Future<void> _saveProgress() async {
    final key = 'athkar_progress_${widget.categoryId}';
    final data = _counts.map((k, v) => MapEntry(k.toString(), v));
    await _storage.setMap(key, data);
  }

  void _calculateCompletion() {
    if (_category == null) return;
    
    int completed = 0;
    int total = 0;
    
    for (final item in _category!.athkar) {
      final count = _counts[item.id] ?? 0;
      completed += count.clamp(0, item.count);
      total += item.count;
    }
    
    setState(() {
      _allCompleted = completed >= total && total > 0;
    });
  }

  void _onItemTap(AthkarItem item) {
    HapticFeedback.lightImpact();
    
    setState(() {
      final currentCount = _counts[item.id] ?? 0;
      if (currentCount < item.count) {
        _counts[item.id] = currentCount + 1;
        
        if (_counts[item.id]! >= item.count) {
          _completedItems.add(item.id);
          HapticFeedback.mediumImpact();
          _updateVisibleItems();
        }
      }
      _calculateCompletion();
    });
    
    _saveProgress();
  }

  void _onItemLongPress(AthkarItem item) {
    HapticFeedback.mediumImpact();
    
    setState(() {
      final wasCompleted = _completedItems.contains(item.id);
      
      _counts[item.id] = 0;
      _completedItems.remove(item.id);
      
      if (wasCompleted) {
        _updateVisibleItems();
      }
      
      _calculateCompletion();
    });
    
    _saveProgress();
  }

  void _rereadAthkar() {
    setState(() {
      _counts.clear();
      _completedItems.clear();
      _allCompleted = false;
      _updateVisibleItems();
    });
    _saveProgress();
  }

  Future<void> _shareProgress() async {
    final text = '''
✨ أكملت ${_category!.title} ✨
${_category!.athkar.map((item) => '✓ ${item.text.truncate(50)}').join('\n')}

تطبيق الأذكار
    ''';
    
    await Share.share(text);
  }

  Future<void> _shareItem(AthkarItem item) async {
    final text = '''
${item.text}

${item.fadl != null ? 'الفضل: ${item.fadl}\n' : ''}
${item.source != null ? 'المصدر: ${item.source}' : ''}

تطبيق الأذكار
''';
    
    await Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        body: IslamicLoading(
          message: 'جاري تحميل الأذكار...',
          color: context.primaryColor,
        ),
      );
    }

    if (_category == null) {
      return Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: IslamicAppBar(title: 'الأذكار'),
        body: _buildErrorState(),
      );
    }

    final category = _category!;
    
    return WillPopScope(
      onWillPop: () async {
        await _resetAndReload();
        return true;
      },
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // شريط التنقل العلوي
              _buildAppBar(context, category),
              
              // المحتوى
              Expanded(
                child: _buildContent(category),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AthkarCategory category) {
    final totalAthkar = category.athkar.length;
    final completedAthkar = _completedItems.length;
    final remainingAthkar = totalAthkar - completedAthkar;
    
    return IslamicCard.simple(
      padding: EdgeInsets.all(context.mediumPadding),
      child: Column(
        children: [
          Row(
            children: [
              // زر العودة
              IslamicCard.simple(
                padding: const EdgeInsets.all(8),
                child: IconButton(
                  onPressed: () async {
                    await _resetAndReload();
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: context.textColor,
                  ),
                ),
              ),
              
              SizedBox(width: context.mediumPadding),
              
              // العنوان
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category.title, style: context.titleStyle),
                    Row(
                      children: [
                        Text(
                          '$remainingAthkar متبقي',
                          style: context.captionStyle.copyWith(
                            color: remainingAthkar > 0 
                                ? context.secondaryTextColor 
                                : ThemeConstants.success,
                          ),
                        ),
                        if (completedAthkar > 0) ...[
                          Text(' • ', style: context.captionStyle),
                          Icon(
                            Icons.check_circle,
                            size: 14,
                            color: ThemeConstants.success,
                          ),
                          SizedBox(width: context.smallPadding),
                          Text(
                            '$completedAthkar مكتمل',
                            style: context.captionStyle.copyWith(
                              color: ThemeConstants.success,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // الإجراءات
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // زر المفضلة
                  IslamicCard.simple(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRouter.favorites);
                      },
                      icon: Icon(
                        Icons.favorite_outline,
                        color: context.secondaryTextColor,
                      ),
                      tooltip: 'المفضلة',
                    ),
                  ),
                  
                  SizedBox(width: context.smallPadding),
                  
                  // زر المشاركة
                  IslamicCard.simple(
                    padding: const EdgeInsets.all(8),
                    child: IconButton(
                      onPressed: _shareProgress,
                      icon: Icon(
                        Icons.share_outlined,
                        color: context.secondaryTextColor,
                      ),
                      tooltip: 'مشاركة',
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          SizedBox(height: context.smallPadding),
          
          // شريط التقدم
          if (totalAthkar > 0) ...[
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: context.secondaryTextColor.withValues(alpha: 0.2),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: completedAthkar / totalAthkar,
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    completedAthkar == totalAthkar 
                        ? ThemeConstants.success 
                        : CategoryUtils.getCategoryThemeColor(category.id),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(AthkarCategory category) {
    return RefreshIndicator(
      onRefresh: () async {
        await _resetAndReload();
      },
      child: _visibleItems.isEmpty 
          ? _buildEmptyState()
          : AnimationLimiter(
              child: ListView.builder(
                padding: context.screenPadding,
                itemCount: _visibleItems.length,
                itemBuilder: (context, index) {
                  final item = _visibleItems[index];
                  final currentCount = _counts[item.id] ?? 0;
                  final isCompleted = _completedItems.contains(item.id);
                  
                  final originalIndex = category.athkar.indexOf(item);
                  final number = originalIndex + 1;
                  
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 300),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: index < _visibleItems.length - 1 ? 16 : 0,
                          ),
                          child: AthkarItemCard(
                            item: item,
                            currentCount: currentCount,
                            isCompleted: isCompleted,
                            number: number,
                            color: CategoryUtils.getCategoryThemeColor(category.id),
                            onTap: () => _onItemTap(item),
                            onLongPress: () => _onItemLongPress(item),
                            onFavoriteToggle: () => _toggleFavorite(item),
                            onShare: () => _shareItem(item),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  ThemeConstants.success.withValues(alpha: 0.8),
                  ThemeConstants.success.withValues(alpha: 0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ThemeConstants.success.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 60,
            ),
          ),
          
          Spaces.extraLarge,
          
          Text(
            'أكملت جميع الأذكار! 🎉',
            style: context.headingStyle.copyWith(color: ThemeConstants.success),
            textAlign: TextAlign.center,
          ),
          
          Spaces.medium,
          
          Text(
            'بارك الله فيك\nجعلها الله في ميزان حسناتك',
            style: context.bodyStyle.copyWith(color: context.secondaryTextColor),
            textAlign: TextAlign.center,
          ),
          
          Spaces.extraLarge,
          
          // زر إعادة القراءة
          Container(
            padding: EdgeInsets.all(context.mediumPadding),
            decoration: BoxDecoration(
              color: ThemeConstants.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(context.largeRadius),
              border: Border.all(
                color: ThemeConstants.success.withValues(alpha: 0.3),
              ),
            ),
            child: IslamicButton.primary(
              text: 'إعادة القراءة',
              icon: Icons.refresh_rounded,
              onPressed: _rereadAthkar,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: ThemeConstants.error.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline,
              size: 50,
              color: ThemeConstants.error,
            ),
          ),
          
          Spaces.large,
          
          Text(
            'تعذر تحميل الأذكار المطلوبة',
            style: context.titleStyle.copyWith(color: ThemeConstants.error),
            textAlign: TextAlign.center,
          ),
          
          Spaces.large,
          
          IslamicButton.outlined(
            text: 'العودة',
            icon: Icons.arrow_back,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(AthkarItem item) {
    // تفعيل المفضلة - يمكن إضافة المنطق هنا
  }
}