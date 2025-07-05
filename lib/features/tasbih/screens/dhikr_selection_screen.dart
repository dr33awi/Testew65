// lib/features/tasbih/screens/dhikr_selection_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../app/themes/app_theme.dart';
import '../models/dhikr_model.dart';
import '../services/tasbih_service.dart';
import 'package:athkar_app/features/tasbih/widgets/dhikr_card.dart';
import '../widgets/add_custom_dhikr_dialog.dart';

class DhikrSelectionScreen extends StatefulWidget {
  final DhikrItem? currentDhikr;
  final Function(DhikrItem) onDhikrSelected;

  const DhikrSelectionScreen({
    super.key,
    this.currentDhikr,
    required this.onDhikrSelected,
  });

  @override
  State<DhikrSelectionScreen> createState() => _DhikrSelectionScreenState();
}

class _DhikrSelectionScreenState extends State<DhikrSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  List<DhikrItem> _allAdhkar = [];
  List<DhikrItem> _filteredAdhkar = [];
  List<DhikrItem> _customAdhkar = [];
  List<String> _favoriteIds = []; // تخزين معرفات المفضلة
  String _searchQuery = '';
  String _currentFilter = 'الكل';

  @override
  void initState() {
    super.initState();
    _loadAdhkar();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadAdhkar() {
    _allAdhkar = DefaultAdhkar.getAll();
    _filteredAdhkar = List.from(_allAdhkar);
    _loadCustomAdhkar();
    _loadFavoriteAdhkar();
  }

  void _loadCustomAdhkar() {
    try {
      final tasbihService = context.read<TasbihService>();
      _customAdhkar = tasbihService.customAdhkar;
      // إضافة الأذكار المخصصة للقائمة الرئيسية
      for (final customDhikr in _customAdhkar) {
        if (!_allAdhkar.any((dhikr) => dhikr.id == customDhikr.id)) {
          _allAdhkar.add(customDhikr);
        }
      }
    } catch (e) {
      _customAdhkar = [];
    }
  }

  void _loadFavoriteAdhkar() {
    // تحميل معرفات المفضلة (مؤقتاً بعض الأذكار الشائعة)
    _favoriteIds = [
      'subhan_allah',
      'alhamdulillah', 
      'allahu_akbar',
      'la_ilaha_illa_allah',
    ];
  }

  List<DhikrItem> get _favoriteAdhkar {
    return _allAdhkar.where((dhikr) => _favoriteIds.contains(dhikr.id)).toList();
  }

  void _filterAdhkar() {
    List<DhikrItem> sourceList;
    
    switch (_currentFilter) {
      case 'الكل':
        sourceList = _allAdhkar;
        break;
      case 'المفضلة':
        sourceList = _favoriteAdhkar;
        break;
      case 'المخصصة':
        sourceList = _customAdhkar;
        break;
      default:
        sourceList = _allAdhkar;
    }

    if (_searchQuery.isEmpty) {
      _filteredAdhkar = List.from(sourceList);
    } else {
      _filteredAdhkar = sourceList
          .where((dhikr) => dhikr.text.contains(_searchQuery))
          .toList();
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterAdhkar();
    });
  }

  void _onCategoryChanged(DhikrCategory category) {
    setState(() {
      _currentFilter = 'التصنيف';
      _filteredAdhkar = DefaultAdhkar.getByCategory(category);
    });
  }

  void _onFilterChanged(String filter) {
    setState(() {
      _currentFilter = filter;
      _filterAdhkar();
    });
  }

  void _onDhikrTap(DhikrItem dhikr) {
    HapticFeedback.lightImpact();
    widget.onDhikrSelected(dhikr);
    Navigator.pop(context);
  }

  void _showAddCustomDhikr() {
    showDialog(
      context: context,
      builder: (context) => AddCustomDhikrDialog(
        onDhikrAdded: (dhikr) async {
          try {
            final tasbihService = context.read<TasbihService>();
            await tasbihService.addCustomDhikr(dhikr);
            
            setState(() {
              _customAdhkar.add(dhikr);
              _allAdhkar.add(dhikr);
              _filterAdhkar();
            });
            
            context.showSuccessSnackBar('تم إضافة الذكر المخصص بنجاح');
          } catch (e) {
            context.showErrorSnackBar('حدث خطأ أثناء حفظ الذكر المخصص');
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: context.backgroundColor,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      ThemeConstants.primary,
                      ThemeConstants.primaryLight,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _SelectionScreenPainter(),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 20,
                        top: 100,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'اختر الذكر',
                            style: context.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: ThemeConstants.bold,
                            ),
                          ),
                          ThemeConstants.space1.h,
                          Text(
                            'اختر الذكر الذي تريد تسبيحه',
                            style: context.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            title: widget.currentDhikr != null
                ? Text(
                    'الحالي: ${widget.currentDhikr!.text.length > 20 ? widget.currentDhikr!.text.substring(0, 20) + '...' : widget.currentDhikr!.text}',
                    style: context.titleMedium?.copyWith(color: Colors.white),
                  )
                : null,
            leading: AppBackButton(
              color: Colors.white,
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: _showAddCustomDhikr,
                tooltip: 'إضافة ذكر مخصص',
              ),
            ],
          ),

          // شريط البحث
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'ابحث في الأذكار...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _onSearchChanged('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: context.cardColor,
                ),
              ),
            ),
          ),

          // القوائم الرئيسية
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // صف الفئات الرئيسية
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilterButton(
                          'المفضلة',
                          Icons.favorite,
                          Colors.red,
                          _favoriteAdhkar.length,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFilterButton(
                          'التصنيف',
                          Icons.category,
                          ThemeConstants.primary,
                          DefaultAdhkar.getAll().length,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildFilterButton(
                          'المخصصة',
                          Icons.edit,
                          ThemeConstants.accent,
                          _customAdhkar.length,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // زر عرض الكل
                  SizedBox(
                    width: double.infinity,
                    child: _buildFilterButton(
                      'عرض جميع الأذكار',
                      Icons.list,
                      ThemeConstants.success,
                      _allAdhkar.length,
                      isFullWidth: true,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // قائمة الأذكار
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _filteredAdhkar.isEmpty
                ? SliverToBoxAdapter(
                    child: _buildEmptyState(),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final dhikr = _filteredAdhkar[index];
                        final isSelected = widget.currentDhikr?.id == dhikr.id;
                        final isFavorite = _favoriteIds.contains(dhikr.id);
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: DhikrCardSimple(
                            dhikr: dhikr,
                            isSelected: isSelected,
                            isFavorite: isFavorite,
                            onTap: () => _onDhikrTap(dhikr),
                            onFavoriteToggle: () => _toggleFavorite(dhikr),
                            onDelete: dhikr.isCustom ? () => _deleteCustomDhikr(dhikr) : null,
                          ),
                        );
                      },
                      childCount: _filteredAdhkar.length,
                    ),
                  ),
          ),

          // مساحة في الأسفل
          const SliverToBoxAdapter(
            child: SizedBox(height: 80),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: context.textSecondaryColor.withValues(alpha: 0.5),
            ),
            ThemeConstants.space3.h,
            Text(
              'لا توجد أذكار',
              style: context.titleMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
            ThemeConstants.space1.h,
            Text(
              _searchQuery.isNotEmpty
                  ? 'لم يتم العثور على أذكار تطابق البحث'
                  : 'لا توجد أذكار في هذا التصنيف',
              style: context.bodyMedium?.copyWith(
                color: context.textSecondaryColor.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (_currentFilter == 'المخصصة') ...[
              ThemeConstants.space4.h,
              AppButton.outline(
                text: 'إضافة ذكر مخصص',
                icon: Icons.add,
                onPressed: _showAddCustomDhikr,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(
    String title,
    IconData icon,
    Color color,
    int count, {
    bool isFullWidth = false,
  }) {
    final isSelected = _currentFilter == title || 
                      (title == 'عرض جميع الأذكار' && _currentFilter == 'الكل');
    
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          if (title == 'عرض جميع الأذكار') {
            _onFilterChanged('الكل');
          } else if (title == 'التصنيف') {
            _showCategoriesDialog();
          } else {
            _onFilterChanged(title);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isSelected 
                ? LinearGradient(
                    colors: [color, color.lighten(0.2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: !isSelected ? context.cardColor : null,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected 
                  ? Colors.transparent
                  : context.dividerColor.withValues(alpha: 0.3),
            ),
            boxShadow: isSelected ? [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ] : null,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: isFullWidth 
                    ? MainAxisAlignment.center 
                    : MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    icon,
                    color: isSelected ? Colors.white : color,
                    size: isFullWidth ? 28 : 24,
                  ),
                  if (!isFullWidth) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? Colors.white.withValues(alpha: 0.2)
                            : color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$count',
                        style: context.labelSmall?.copyWith(
                          color: isSelected ? Colors.white : color,
                          fontWeight: ThemeConstants.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              
              const SizedBox(height: 8),
              
              Text(
                title,
                style: context.titleSmall?.copyWith(
                  color: isSelected ? Colors.white : context.textPrimaryColor,
                  fontWeight: isSelected ? ThemeConstants.bold : ThemeConstants.semiBold,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              
              if (isFullWidth) ...[
                const SizedBox(height: 4),
                Text(
                  '$count ذكر',
                  style: context.bodySmall?.copyWith(
                    color: isSelected 
                        ? Colors.white.withValues(alpha: 0.8)
                        : context.textSecondaryColor,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showCategoriesDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // مقبض السحب
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'اختر التصنيف',
                      style: context.titleLarge?.copyWith(
                        fontWeight: ThemeConstants.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // شبكة التصنيفات
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.2,
                      ),
                      itemCount: DhikrCategory.values.length - 1, // استثناء المخصص
                      itemBuilder: (context, index) {
                        final category = DhikrCategory.values[index];
                        final count = DefaultAdhkar.getByCategory(category).length;
                        
                        return Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              _onCategoryChanged(category);
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: context.surfaceColor,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: context.dividerColor.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    category.icon,
                                    color: ThemeConstants.primary,
                                    size: 24,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category.title,
                                    style: context.labelMedium?.copyWith(
                                      fontWeight: ThemeConstants.semiBold,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '$count',
                                    style: context.labelSmall?.copyWith(
                                      color: context.textSecondaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
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

  void _toggleFavorite(DhikrItem dhikr) {
    setState(() {
      if (_favoriteIds.contains(dhikr.id)) {
        _favoriteIds.remove(dhikr.id);
      } else {
        _favoriteIds.add(dhikr.id);
      }
      _filterAdhkar();
    });
    
    HapticFeedback.lightImpact();
    final isFavorite = _favoriteIds.contains(dhikr.id);
    context.showInfoSnackBar(
      isFavorite ? 'تم إضافة للمفضلة' : 'تم إزالة من المفضلة'
    );
  }

  void _deleteCustomDhikr(DhikrItem dhikr) {
    AppInfoDialog.showConfirmation(
      context: context,
      title: 'حذف الذكر المخصص',
      content: 'هل أنت متأكد من أنك تريد حذف هذا الذكر المخصص؟\n\n"${dhikr.text}"',
      confirmText: 'حذف',
      cancelText: 'إلغاء',
      icon: Icons.delete_outline,
      destructive: true,
    ).then((confirmed) async {
      if (confirmed == true) {
        try {
          final tasbihService = context.read<TasbihService>();
          await tasbihService.removeCustomDhikr(dhikr.id);
          
          setState(() {
            _customAdhkar.removeWhere((d) => d.id == dhikr.id);
            _allAdhkar.removeWhere((d) => d.id == dhikr.id);
            _filteredAdhkar.removeWhere((d) => d.id == dhikr.id);
            _favoriteIds.remove(dhikr.id);
          });
          
          HapticFeedback.mediumImpact();
          context.showSuccessSnackBar('تم حذف الذكر المخصص');
        } catch (e) {
          context.showErrorSnackBar('حدث خطأ أثناء حذف الذكر');
        }
      }
    });
  }
}

/// رسام نمط الخلفية
class _SelectionScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // رسم دوائر متداخلة
    for (int i = 1; i <= 4; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * 0.3),
        20.0 * i,
        paint,
      );
    }

    // رسم خطوط قطرية
    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(size.width * 0.1, size.height * (0.2 + i * 0.15)),
        Offset(size.width * 0.5, size.height * (0.4 + i * 0.15)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}