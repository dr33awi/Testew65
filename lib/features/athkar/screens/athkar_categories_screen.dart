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
          return ListView.builder(
            padding: const EdgeInsets.all(ThemeConstants.space4),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return _buildCategoryCard(context, cat);
            },
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, AthkarCategory cat) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ThemeConstants.space3),
      child: AppCard(
        title: cat.title,
        subtitle: cat.description,
        leading: Icon(cat.icon, color: cat.color),
        type: CardType.athkar,
        style: CardStyle.outlined,
        trailing: const Icon(Icons.arrow_forward_ios_rounded),
        onTap: () {
          // Future feature: open list of athkar
        },
      ),
    );
  }
}
