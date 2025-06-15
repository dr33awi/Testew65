// lib/features/athkar/screens/athkar_categories_screen.dart
import 'package:flutter/material.dart';
import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/themes/widgets/core/app_loading.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';

class AthkarCategoriesScreen extends StatefulWidget {
  const AthkarCategoriesScreen({super.key});

  @override
  State<AthkarCategoriesScreen> createState() => _AthkarCategoriesScreenState();
}

class _AthkarCategoriesScreenState extends State<AthkarCategoriesScreen> {
  late final AthkarService _service;
  late Future<List<AthkarCategory>> _futureCategories;

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _futureCategories = _service.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.simple(title: 'الأذكار'),
      body: FutureBuilder<List<AthkarCategory>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: AppLoading.circular());
          }
          if (snapshot.hasError) {
            return Center(child: Text('حدث خطأ في تحميل البيانات'));
          }
          final categories = snapshot.data ?? [];
          return GridView.builder(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: ThemeConstants.space3,
              crossAxisSpacing: ThemeConstants.space3,
              childAspectRatio: 1.3,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return _buildCategoryItem(context, cat);
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, AthkarCategory cat) {
    final gradient = LinearGradient(
      colors: [cat.color.withOpacity(0.8), cat.color],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      child: InkWell(
        onTap: () {
          // Future feature: open list of athkar
        },
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
            boxShadow: [
              BoxShadow(
                color: cat.color.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(ThemeConstants.space4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(cat.icon, color: Colors.white, size: ThemeConstants.iconLg),
              ThemeConstants.space2.h,
              Text(
                cat.title,
                style: context.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: ThemeConstants.bold,
                ),
                textAlign: TextAlign.center,
              ),
              if (cat.description != null) ...[
                ThemeConstants.space1.h,
                Text(
                  cat.description!,
                  style: context.bodySmall?.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
