import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';

/// خدمة إدارة المسبحة الرقمية
class TasbihService extends ChangeNotifier {
  final StorageService _storage;
  final LoggerService _logger;

  int _count = 0;

  TasbihService({required StorageService storage, required LoggerService logger})
      : _storage = storage,
        _logger = logger {
    _loadCount();
  }

  int get count => _count;

  Future<void> _loadCount() async {
    _count = _storage.getInt(AppConstants.tasbihCounterKey) ?? 0;
    _logger.debug(
      message: '[TasbihService] Loaded count',
      data: {'count': _count},
    );
    notifyListeners();
  }

  Future<void> increment() async {
    _count++;
    notifyListeners();
    await _storage.setInt(AppConstants.tasbihCounterKey, _count);
  }

  Future<void> reset() async {
    _count = 0;
    notifyListeners();
    await _storage.setInt(AppConstants.tasbihCounterKey, _count);
  }
}
