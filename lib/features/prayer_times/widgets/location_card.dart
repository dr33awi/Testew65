// lib/features/prayer_times/widgets/location_card.dart

import 'package:flutter/material.dart';
import '../../../app/themes/index.dart';
import '../models/prayer_time_model.dart';

/// بطاقة عرض معلومات الموقع
class LocationCard extends StatelessWidget {
  final PrayerLocation location;
  final VoidCallback? onUpdateLocation;
  final VoidCallback? onChangeLocation;
  final bool isLoading;

  const LocationCard({
    super.key,
    required this.location,
    this.onUpdateLocation,
    this.onChangeLocation,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return IslamicCard(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          context.primaryColor.withValues(alpha: 0.1),
          context.primaryColor.withValues(alpha: 0.05),
        ],
      ),
      border: Border.all(
        color: context.primaryColor.withValues(alpha: 0.2),
        width: 1,
      ),
      child: Column(
        children: [
          // رأس البطاقة
          _buildHeader(context),
          
          Spaces.medium,
          
          // تفاصيل الموقع
          _buildLocationDetails(context),
          
          Spaces.medium,
          
          // الأزرار
          _buildActionButtons(context),
          
          Spaces.medium,
          
          // معلومة إضافية
          _buildInfoNote(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        // أيقونة الموقع
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                context.primaryColor,
                context.primaryColor.darken(0.2),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: context.primaryColor.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.location_on,
            color: Colors.white,
            size: 24,
          ),
        ),
        
        Spaces.mediumH,
        
        // عنوان القسم
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'الموقع الحالي',
                style: context.titleStyle.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'يستخدم لحساب مواقيت الصلاة',
                style: context.captionStyle.copyWith(
                  color: context.secondaryTextColor,
                ),
              ),
            ],
          ),
        ),
        
        // أيقونة الحالة
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: context.successColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                size: 14,
                color: context.successColor,
              ),
              Spaces.xsH,
              Text(
                'نشط',
                style: context.captionStyle.copyWith(
                  color: context.successColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationDetails(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: context.borderColor.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // المدينة والدولة
          _buildLocationInfo(
            context,
            icon: Icons.location_city,
            label: 'المدينة',
            value: location.cityName ?? 'غير محدد',
            color: context.primaryColor,
          ),
          
          if (location.countryName != null) ...[
            Spaces.medium,
            _buildLocationInfo(
              context,
              icon: Icons.flag,
              label: 'الدولة',
              value: location.countryName!,
              color: context.secondaryColor,
            ),
          ],
          
          Spaces.medium,
          
          // خط فاصل
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  context.borderColor.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          
          Spaces.medium,
          
          // الإحداثيات
          Row(
            children: [
              Expanded(
                child: _buildCoordinateCard(
                  context,
                  label: 'خط العرض',
                  value: location.latitude.toStringAsFixed(4),
                  icon: Icons.horizontal_rule,
                  color: context.infoColor,
                ),
              ),
              Spaces.mediumH,
              Expanded(
                child: _buildCoordinateCard(
                  context,
                  label: 'خط الطول',
                  value: location.longitude.toStringAsFixed(4),
                  icon: Icons.vertical_align_center,
                  color: context.warningColor,
                ),
              ),
            ],
          ),
          
          // المنطقة الزمنية والارتفاع
          if (location.timezone.isNotEmpty) ...[
            Spaces.medium,
            _buildLocationInfo(
              context,
              icon: Icons.access_time,
              label: 'المنطقة الزمنية',
              value: _formatTimezone(location.timezone),
              color: context.infoColor,
            ),
          ],
          
          if (location.altitude != null) ...[
            Spaces.medium,
            _buildLocationInfo(
              context,
              icon: Icons.height,
              label: 'الارتفاع عن سطح البحر',
              value: '${location.altitude!.toStringAsFixed(0)} متر',
              color: context.warningColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLocationInfo(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        // أيقونة ملونة
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: color,
          ),
        ),
        
        Spaces.mediumH,
        
        // المعلومات
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: context.captionStyle.copyWith(
                  color: context.secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Spaces.xs,
              Text(
                value,
                style: context.bodyStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.textColor,
                ),
              ),
            ],
          ),
        ),
        
        // مؤشر بصري
        Container(
          width: 4,
          height: 24,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildCoordinateCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.1),
            color.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          // الأيقونة
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),
          
          Spaces.small,
          
          // النص
          Text(
            label,
            style: context.captionStyle.copyWith(
              color: context.secondaryTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          Spaces.xs,
          
          Text(
            value,
            style: context.bodyStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        // زر تحديث الموقع
        Expanded(
          child: IslamicButton.outlined(
            text: 'تحديث الموقع',
            icon: isLoading ? null : Icons.my_location,
            onPressed: isLoading ? null : onUpdateLocation,
            isLoading: isLoading,
          ),
        ),
        
        if (onChangeLocation != null) ...[
          Spaces.mediumH,
          
          // زر تغيير الموقع
          Expanded(
            child: IslamicButton.primary(
              text: 'تغيير الموقع',
              icon: Icons.edit_location,
              onPressed: onChangeLocation,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoNote(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.infoColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.infoColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: context.infoColor,
            size: 20,
          ),
          Spaces.smallH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'معلومة مهمة',
                  style: context.captionStyle.copyWith(
                    color: context.infoColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'يتم استخدام موقعك لحساب مواقيت الصلاة بدقة وفقاً لإحداثياتك الجغرافية',
                  style: context.captionStyle.copyWith(
                    color: context.infoColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimezone(String timezone) {
    // خريطة ترجمة المناطق الزمنية للعربية
    final timezoneMap = <String, String>{
      // الشرق الأوسط
      'Asia/Riyadh': 'توقيت الرياض (GMT+3)',
      'Asia/Dubai': 'توقيت دبي (GMT+4)',
      'Asia/Kuwait': 'توقيت الكويت (GMT+3)',
      'Asia/Qatar': 'توقيت قطر (GMT+3)',
      'Asia/Bahrain': 'توقيت البحرين (GMT+3)',
      'Asia/Muscat': 'توقيت مسقط (GMT+4)',
      'Asia/Baghdad': 'توقيت بغداد (GMT+3)',
      'Asia/Amman': 'توقيت عمان (GMT+3)',
      'Asia/Damascus': 'توقيت دمشق (GMT+3)',
      'Asia/Beirut': 'توقيت بيروت (GMT+3)',
      'Asia/Jerusalem': 'توقيت القدس (GMT+3)',
      
      // شمال أفريقيا
      'Africa/Cairo': 'توقيت القاهرة (GMT+2)',
      'Africa/Tunis': 'توقيت تونس (GMT+1)',
      'Africa/Algiers': 'توقيت الجزائر (GMT+1)',
      'Africa/Casablanca': 'توقيت الدار البيضاء (GMT+1)',
      'Africa/Tripoli': 'توقيت طرابلس (GMT+2)',
      'Africa/Khartoum': 'توقيت الخرطوم (GMT+2)',
      
      // آسيا
      'Asia/Tehran': 'توقيت طهران (GMT+3:30)',
      'Asia/Karachi': 'توقيت كراتشي (GMT+5)',
      'Asia/Dhaka': 'توقيت دكا (GMT+6)',
      'Asia/Jakarta': 'توقيت جاكرتا (GMT+7)',
      'Asia/Kuala_Lumpur': 'توقيت كوالالمبور (GMT+8)',
      'Asia/Singapore': 'توقيت سنغافورة (GMT+8)',
      'Asia/Manila': 'توقيت مانيلا (GMT+8)',
      'Asia/Tokyo': 'توقيت طوكيو (GMT+9)',
      'Asia/Shanghai': 'توقيت شنغهاي (GMT+8)',
      'Asia/Hong_Kong': 'توقيت هونغ كونغ (GMT+8)',
      'Asia/Seoul': 'توقيت سيول (GMT+9)',
      'Asia/Kolkata': 'توقيت كولكاتا (GMT+5:30)',
      'Asia/Bangkok': 'توقيت بانكوك (GMT+7)',
      
      // أوروبا
      'Europe/London': 'توقيت لندن (GMT+0)',
      'Europe/Paris': 'توقيت باريس (GMT+1)',
      'Europe/Berlin': 'توقيت برلين (GMT+1)',
      'Europe/Rome': 'توقيت روما (GMT+1)',
      'Europe/Madrid': 'توقيت مدريد (GMT+1)',
      'Europe/Istanbul': 'توقيت إسطنبول (GMT+3)',
      'Europe/Moscow': 'توقيت موسكو (GMT+3)',
      
      // أمريكا
      'America/New_York': 'التوقيت الشرقي الأمريكي (GMT-5)',
      'America/Chicago': 'التوقيت المركزي الأمريكي (GMT-6)',
      'America/Denver': 'التوقيت الجبلي الأمريكي (GMT-7)',
      'America/Los_Angeles': 'التوقيت الغربي الأمريكي (GMT-8)',
      'America/Toronto': 'توقيت تورونتو (GMT-5)',
      'America/Mexico_City': 'توقيت مكسيكو سيتي (GMT-6)',
      'America/Sao_Paulo': 'توقيت ساو باولو (GMT-3)',
      
      // أستراليا
      'Australia/Sydney': 'توقيت سيدني (GMT+10)',
      'Australia/Melbourne': 'توقيت ملبورن (GMT+10)',
      'Australia/Perth': 'توقيت بيرث (GMT+8)',
      
      // أفريقيا
      'Africa/Johannesburg': 'توقيت جوهانسبرغ (GMT+2)',
      'Africa/Lagos': 'توقيت لاغوس (GMT+1)',
      'Africa/Nairobi': 'توقيت نيروبي (GMT+3)',
      
      // المحيط الهادئ
      'Pacific/Honolulu': 'توقيت هونولولو (GMT-10)',
      'Pacific/Auckland': 'توقيت أوكلاند (GMT+12)',
    };
    
    return timezoneMap[timezone] ?? timezone.replaceAll('_', ' ');
  }
}

/// إضافة دالة مساعدة للاستخدام السريع
extension LocationCardExtensions on LocationCard {
  /// إنشاء بطاقة موقع بسيطة
  static Widget simple({
    required PrayerLocation location,
    VoidCallback? onUpdate,
  }) {
    return LocationCard(
      location: location,
      onUpdateLocation: onUpdate,
    );
  }
  
  /// إنشاء بطاقة موقع مع جميع الخيارات
  static Widget full({
    required PrayerLocation location,
    VoidCallback? onUpdate,
    VoidCallback? onChange,
    bool isLoading = false,
  }) {
    return LocationCard(
      location: location,
      onUpdateLocation: onUpdate,
      onChangeLocation: onChange,
      isLoading: isLoading,
    );
  }
}