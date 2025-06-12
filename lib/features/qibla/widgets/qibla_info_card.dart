// lib/features/qibla/widgets/qibla_info_card.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../domain/models/qibla_model.dart';

class QiblaInfoCard extends StatelessWidget {
  final QiblaModel qiblaData;

  const QiblaInfoCard({
    super.key,
    required this.qiblaData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // رأس البطاقة
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  context.primaryColor.withValues(alpha: 0.1),
                  context.primaryColor.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: context.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on,
                    color: context.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'موقعك الحالي',
                        style: context.bodySmall?.copyWith(
                          color: context.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getLocationName(),
                        style: context.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                // زر نسخ الإحداثيات
                IconButton(
                  onPressed: () => _copyCoordinates(context),
                  icon: Icon(
                    Icons.copy,
                    size: 20,
                    color: context.textSecondaryColor,
                  ),
                  tooltip: 'نسخ الإحداثيات',
                ),
              ],
            ),
          ),
          
          // معلومات القبلة
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // صف المعلومات الأساسية
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoTile(
                        context: context,
                        icon: Icons.navigation_outlined,
                        title: 'اتجاه القبلة',
                        value: '${qiblaData.qiblaDirection.toStringAsFixed(1)}°',
                        subtitle: qiblaData.directionDescription,
                        color: context.primaryColor,
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 60,
                      color: context.dividerColor,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    Expanded(
                      child: _buildInfoTile(
                        context: context,
                        icon: Icons.straighten,
                        title: 'المسافة للكعبة',
                        value: qiblaData.distanceDescription,
                        subtitle: 'خط مستقيم',
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                // معلومات إضافية
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        context: context,
                        label: 'خط العرض',
                        value: '${qiblaData.latitude.toStringAsFixed(6)}°',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        context: context,
                        label: 'خط الطول',
                        value: '${qiblaData.longitude.toStringAsFixed(6)}°',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        context: context,
                        label: 'دقة الموقع',
                        value: _getAccuracyText(),
                        valueColor: _getAccuracyColor(),
                      ),
                      if (!qiblaData.isStale) ...[
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          context: context,
                          label: 'آخر تحديث',
                          value: _getLastUpdateText(),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // تحذير البيانات القديمة
                if (qiblaData.isStale)
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.amber[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'بيانات الموقع قديمة، يُنصح بالتحديث',
                            style: context.bodySmall?.copyWith(
                              color: Colors.amber[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getLocationName() {
    if (qiblaData.cityName != null && qiblaData.countryName != null) {
      return '${qiblaData.cityName}، ${qiblaData.countryName}';
    } else if (qiblaData.cityName != null) {
      return qiblaData.cityName!;
    } else if (qiblaData.countryName != null) {
      return qiblaData.countryName!;
    } else {
      return 'موقع غير محدد';
    }
  }

  Widget _buildInfoTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: context.bodySmall?.copyWith(
            color: context.textSecondaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: context.bodySmall?.copyWith(
            color: context.textSecondaryColor,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.bodySmall?.copyWith(
            color: context.textSecondaryColor,
          ),
        ),
        Text(
          value,
          style: context.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: valueColor ?? context.textPrimaryColor,
          ),
        ),
      ],
    );
  }

  String _getAccuracyText() {
    if (qiblaData.hasHighAccuracy) {
      return '± ${qiblaData.accuracy.toStringAsFixed(0)} متر (عالية)';
    } else if (qiblaData.hasMediumAccuracy) {
      return '± ${qiblaData.accuracy.toStringAsFixed(0)} متر (متوسطة)';
    } else {
      return '± ${qiblaData.accuracy.toStringAsFixed(0)} متر (منخفضة)';
    }
  }

  Color _getAccuracyColor() {
    if (qiblaData.hasHighAccuracy) return Colors.green;
    if (qiblaData.hasMediumAccuracy) return Colors.orange;
    return Colors.red;
  }

  String _getLastUpdateText() {
    final age = qiblaData.age;
    
    if (age.inMinutes < 1) {
      return 'الآن';
    } else if (age.inMinutes < 60) {
      return 'منذ ${age.inMinutes} دقيقة';
    } else if (age.inHours < 24) {
      return 'منذ ${age.inHours} ساعة';
    } else {
      return 'منذ ${age.inDays} يوم';
    }
  }

  void _copyCoordinates(BuildContext context) {
    final coordinates = '${qiblaData.latitude}, ${qiblaData.longitude}';
    Clipboard.setData(ClipboardData(text: coordinates));
    HapticFeedback.lightImpact();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم نسخ الإحداثيات: $coordinates'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        action: SnackBarAction(
          label: 'حسناً',
          onPressed: () {},
        ),
      ),
    );
  }
}