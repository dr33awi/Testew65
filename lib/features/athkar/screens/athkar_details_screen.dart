// lib/features/athkar/screens/athkar_details_screen.dart - محدث للنظام الموحد
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/utils/extensions/string_extensions.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';
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
      duration: ThemeConstants.durationNormal,
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
        backgroundColor: AppColorSystem.getBackground(context),
        body: AppLoading.page(
          message: 'جاري تحميل الأذكار...',
        ),
      );
    }

    if (_category == null) {
      return Scaffold(
        backgroundColor: AppColorSystem.getBackground(context),
        appBar: CustomAppBar.simple(title: 'الأذكار'),
        body: AppEmptyState.error(
          message: 'تعذر تحميل الأذكار المطلوبة',
          onRetry: _load,
        ),
      );
    }

    final category = _category!;
    final totalAthkar = category.athkar.length;
    final completedAthkar = _completedItems.length;
    final remainingAthkar = totalAthkar - completedAthkar;
    
    return WillPopScope(
      onWillPop: () async {
        await _resetAndReload();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColorSystem.getBackground(context),
        appBar: CustomAppBar(
          title: category.title,
          leading: AppBackButton(
            onPressed: () async {
              await _resetAndReload();
              Navigator.of(context).pop();
            },
          ),
          actions: [
            AppBarAction(
              icon: AppIconsSystem.notifications,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AthkarNotificationSettingsScreen(),
                ),
              ),
              tooltip: 'إعدادات الإشعارات',
            ),
          ],
          // إضافة شريط التقدم كـ bottom
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              padding: const EdgeInsets.all(ThemeConstants.space4),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        '$remainingAthkar متبقي',
                        style: AppTextStyles.body2.copyWith(
                          color: remainingAthkar > 0 
                              ? AppColorSystem.getTextSecondary(context)
                              : AppColorSystem.success,
                          fontWeight: remainingAthkar == 0 
                              ? ThemeConstants.bold 
                              : ThemeConstants.regular,
                        ),
                      ),
                      if (completedAthkar > 0) ...[
                        Text(
                          ' • ',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColorSystem.getTextSecondary(context),
                          ),
                        ),
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColorSystem.success,
                        ),
                        const SizedBox(width: ThemeConstants.space1),
                        Text(
                          '$completedAthkar مكتمل',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColorSystem.success,
                            fontWeight: ThemeConstants.medium,
                          ),
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: ThemeConstants.space3),
                  
                  // شريط التقدم
                  if (totalAthkar > 0)
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColorSystem.getCard(context),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: AppColorSystem.getDivider(context).withValues(alpha: 0.2),
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: completedAthkar / totalAthkar,
                          backgroundColor: Colors.transparent,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColorSystem.success,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        body: _buildContent(category),
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
          : ListView.builder(
              padding: const EdgeInsets.all(ThemeConstants.space4),
              itemCount: _visibleItems.length,
              itemBuilder: (context, index) {
                final item = _visibleItems[index];
                final currentCount = _counts[item.id] ?? 0;
                
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index < _visibleItems.length - 1
                        ? ThemeConstants.space4
                        : 0,
                  ),
                  child: AppCard.athkar(
                    content: item.text,
                    source: item.source,
                    fadl: item.fadl,
                    currentCount: currentCount,
                    totalCount: item.count,
                    primaryColor: AppColorSystem.getCategoryColor(widget.categoryId),
                    onTap: () => _onItemTap(item),
                    actions: [
                      CardAction(
                        icon: Icons.favorite_outline,
                        label: 'مفضلة',
                        onPressed: () => _toggleFavorite(item),
                      ),
                      CardAction(
                        icon: Icons.share_rounded,
                        label: 'مشاركة',
                        onPressed: () => _shareItem(item),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConstants.space6),
        child: AppCard.custom(
          style: CardStyle.gradient,
          primaryColor: AppColorSystem.success,
          gradientColors: [
            AppColorSystem.success,
            AppColorSystem.success.darken(0.2),
          ],
          borderRadius: ThemeConstants.radiusXl,
          padding: const EdgeInsets.all(ThemeConstants.space6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // الأيقونة
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
                  Icons.check_circle_rounded,
                  color: Colors.white,
                  size: 40,
                ),
              ),
              
              const SizedBox(height: ThemeConstants.space5),
              
              // النصوص
              Text(
                'أكملت جميع الأذكار! 🎉',
                style: AppTextStyles.h4.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: ThemeConstants.space2),
              
              Text(
                'بارك الله فيك',
                style: AppTextStyles.body1.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: ThemeConstants.space1),
              
              Text(
                'جعلها الله في ميزان حسناتك',
                style: AppTextStyles.body2.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: ThemeConstants.space6),
              
              // زر إعادة القراءة
              AppButton.outline(
                text: 'إعادة القراءة',
                onPressed: _rereadAthkar,
                icon: Icons.refresh_rounded,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleFavorite(AthkarItem item) {
    HapticFeedback.lightImpact();
    
    // يمكن إضافة منطق حفظ/إزالة من المفضلة هنا
    AppSnackBar.showSuccess(
      context: context,
      message: 'تمت إضافة الذكر للمفضلة',
    );
  }
}