import 'package:athkar_app/core/infrastructure/services/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../services/tasbih_service.dart';

/// شاشة المسبحة الرقمية
class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen> {
  late TasbihService _service;
  late LoggerService _logger;

  @override
  void initState() {
    super.initState();
    _service = TasbihService(
      storage: getIt<StorageService>(),
      logger: getIt<LoggerService>(),
    );
    _logger = getIt<LoggerService>();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _service,
      child: Scaffold(
        appBar: CustomAppBar.simple(title: 'المسبحة الرقمية'),
        backgroundColor: context.backgroundColor,
        body: Consumer<TasbihService>(
          builder: (context, service, _) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${service.count}',
                    style: context.displayLarge?.copyWith(
                      fontWeight: ThemeConstants.bold,
                      color: context.primaryColor,
                    ),
                  ),
                  ThemeConstants.space4.h,
                  AppButton(
                    text: 'تصفير',
                    type: ButtonType.outline,
                    onPressed: service.reset,
                    icon: Icons.refresh,
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: Consumer<TasbihService>(
          builder: (context, service, _) {
            return FloatingActionButton(
              onPressed: () {
                service.increment();
                _logger.debug(
                  message: '[TasbihScreen] increment',
                  data: {'count': service.count},
                );
              },
              backgroundColor: context.primaryColor,
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}