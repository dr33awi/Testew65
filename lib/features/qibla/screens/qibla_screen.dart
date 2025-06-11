// lib/features/qibla/screens/qibla_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/themes/app_theme.dart';
import '../../../app/di/service_locator.dart';
import '../../../core/infrastructure/services/logging/logger_service.dart';
import '../../../core/infrastructure/services/storage/storage_service.dart';
import '../../../core/infrastructure/services/permissions/permission_service.dart';
import '../services/qibla_service.dart';
import '../widgets/qibla_compass.dart';
import '../widgets/qibla_info_card.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> with WidgetsBindingObserver {
  late final QiblaService _qiblaService;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  void initState() {
    super.initState();
    
    _qiblaService = QiblaService(
      logger: getIt<LoggerService>(),
      storage: getIt<StorageService>(),
      permissionService: getIt<PermissionService>(),
    );
    
    WidgetsBinding.instance.addObserver(this);
    
    // تحديث بيانات القبلة عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateQiblaData();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // تحديث البيانات عند العودة إلى التطبيق
    if (state == AppLifecycleState.resumed) {
      _updateQiblaData();
    }
  }

  Future<void> _updateQiblaData() async {
    await _qiblaService.updateQiblaData();
  }

  void _showCalibrationInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info_outline, color: context.primaryColor),
            const SizedBox(width: 10),
            const Text('تحسين دقة البوصلة'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'لتحسين دقة البوصلة، قم بتحريك هاتفك على شكل الرقم 8 في الهواء عدة مرات.',
              style: context.bodyMedium,
            ),
            const SizedBox(height: 20),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '∞',
                  style: TextStyle(
                    fontSize: 100,
                    color: context.primaryColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _qiblaService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _qiblaService,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: context.backgroundColor,
        appBar: AppBar(
          backgroundColor: context.backgroundColor,
          elevation: 0,
          title: Text(
            'اتجاه القبلة',
            style: context.titleLarge?.semiBold,
          ),
          centerTitle: true,
          actions: [
            Consumer<QiblaService>(
              builder: (context, service, child) {
                return IconButton(
                  icon: service.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.refresh_outlined),
                  onPressed: service.isLoading ? null : _updateQiblaData,
                  tooltip: 'تحديث الموقع',
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: _showCalibrationInfo,
              tooltip: 'معلومات التحسين',
            ),
          ],
        ),
        body: Consumer<QiblaService>(
          builder: (context, service, child) {
            if (service.isLoading && service.qiblaData == null) {
              return _buildLoadingState();
            }

            if (service.errorMessage != null && service.qiblaData == null) {
              return _buildErrorState(service);
            }

            // في حالة عدم توفر البوصلة
            if (!service.hasCompass) {
              return _buildNoCompassState(service);
            }

            return _buildMainContent(service);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: context.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(context.primaryColor),
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'جاري تحديد موقعك واتجاه القبلة...',
            style: context.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 250,
            child: Text(
              'نحتاج إلى موقعك لحساب اتجاه القبلة بدقة',
              textAlign: TextAlign.center,
              style: context.bodyMedium?.copyWith(
                color: context.textSecondaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(QiblaService service) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_off,
              size: 40,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ',
            style: context.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              service.errorMessage!,
              textAlign: TextAlign.center,
              style: context.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _updateQiblaData,
            icon: const Icon(Icons.refresh),
            label: const Text('إعادة المحاولة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoCompassState(QiblaService service) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.compass_calibration_outlined,
              size: 40,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'البوصلة غير متوفرة',
            style: context.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 300,
            child: Text(
              'جهازك لا يدعم البوصلة أو أنها معطلة حالياً. يمكنك معرفة اتجاه القبلة لكن بدون مؤشر حي.',
              textAlign: TextAlign.center,
              style: context.bodyMedium,
            ),
          ),
          const SizedBox(height: 24),
          if (service.qiblaData != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: context.cardColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'اتجاه القبلة من موقعك الحالي',
                    style: context.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${service.qiblaData!.qiblaDirection.toStringAsFixed(1)}°',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: context.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'استخدم بوصلة خارجية للتوجه إلى هذا الاتجاه',
                    style: context.bodySmall?.copyWith(
                      color: context.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            QiblaInfoCard(qiblaData: service.qiblaData!),
          ],
        ],
      ),
    );
  }

  Widget _buildMainContent(QiblaService service) {
    return SafeArea(
      child: Column(
        children: [
          // معلومات القبلة
          if (service.qiblaData != null)
            QiblaInfoCard(qiblaData: service.qiblaData!),
          
          // البوصلة
          Expanded(
            child: service.qiblaData == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_searching,
                          size: 48,
                          color: context.textSecondaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'يرجى تحديث موقعك لعرض اتجاه القبلة',
                          style: context.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : QiblaCompass(
                    qiblaDirection: service.qiblaData!.qiblaDirection,
                    currentDirection: service.currentDirection,
                  ),
          ),
          
          // تذييل - معلومات إضافية
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: context.textSecondaryColor,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'حرك هاتفك على شكل رقم 8 لتحسين دقة البوصلة',
                    style: context.bodySmall?.copyWith(
                      color: context.textSecondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}