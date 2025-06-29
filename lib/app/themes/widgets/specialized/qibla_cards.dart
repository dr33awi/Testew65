// lib/app/themes/widgets/specialized/qibla_cards.dart
// كروت القبلة والبوصلة - مفصولة ومتخصصة
// ✅ استيراد النظام الموحد الإسلامي - الوحيد المسموح
import 'package:athkar_app/app/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

// ==================== كروت القبلة المتخصصة ====================

/// بطاقة القبلة الرئيسية مع البوصلة التفاعلية
class QiblaCard extends StatefulWidget {
  final double direction;
  final String? locationName;
  final double? accuracy;
  final bool isCalibrated;
  final VoidCallback? onTap;
  final VoidCallback? onCalibrate;
  final List<QiblaAction>? actions;
  final bool showStatus;
  final bool useAnimation;
  final bool isCompact;

  const QiblaCard({
    super.key,
    required this.direction,
    this.locationName,
    this.accuracy,
    this.isCalibrated = false,
    this.onTap,
    this.onCalibrate,
    this.actions,
    this.showStatus = true,
    this.useAnimation = true,
    this.isCompact = false,
  });

  @override
  State<QiblaCard> createState() => _QiblaCardState();
}

class _QiblaCardState extends State<QiblaCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: widget.direction * (math.pi / 180),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.useAnimation) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(QiblaCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.direction != oldWidget.direction && widget.useAnimation) {
      _rotationAnimation = Tween<double>(
        begin: oldWidget.direction * (math.pi / 180),
        end: widget.direction * (math.pi / 180),
      ).animate(CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ));
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (widget.onTap != null) {
      HapticFeedback.lightImpact();
      widget.onTap!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppTheme.space3.padding,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusLg.radius,
        child: InkWell(
          onTap: _handleTap,
          borderRadius: AppTheme.radiusLg.radius,
          child: Container(
            decoration: _buildCardDecoration(),
            padding: AppTheme.space5.padding,
            child: widget.isCompact 
                ? _buildCompactContent()
                : _buildFullContent(),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      color: AppTheme.card,
      borderRadius: AppTheme.radiusLg.radius,
      border: Border.all(
        color: widget.isCalibrated 
            ? AppTheme.success.withValues(alpha: 0.3)
            : AppTheme.warning.withValues(alpha: 0.3),
        width: 2,
      ),
      boxShadow: AppTheme.shadowMd,
    );
  }

  Widget _buildCompactContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // البوصلة المصغرة
        SizedBox(
          width: 80,
          height: 80,
          child: _buildCompass(60),
        ),
        
        AppTheme.space2.h,
        
        Text(
          'القبلة',
          style: AppTheme.titleMedium.copyWith(
            fontWeight: AppTheme.semiBold,
          ),
        ),
        
        AppTheme.space1.h,
        
        Text(
          '${widget.direction.toStringAsFixed(0)}°',
          style: AppTheme.bodyLarge.copyWith(
            color: AppTheme.tertiary,
            fontFamily: AppTheme.numbersFont,
            fontWeight: AppTheme.bold,
          ),
        ),
        
        if (widget.showStatus) ...[
          AppTheme.space1.h,
          _buildStatusChip(),
        ],
      ],
    );
  }

  Widget _buildFullContent() {
    return Column(
      children: [
        // العنوان والحالة
        _buildHeader(),
        
        AppTheme.space4.h,
        
        // البوصلة الرئيسية
        Center(
          child: SizedBox(
            width: 200,
            height: 200,
            child: _buildCompass(180),
          ),
        ),
        
        AppTheme.space4.h,
        
        // المعلومات الإضافية
        _buildInfoSection(),
        
        // الإجراءات
        if (widget.actions != null && widget.actions!.isNotEmpty) ...[
          AppTheme.space4.h,
          _buildActions(),
        ],
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.explore,
              color: AppTheme.tertiary,
              size: AppTheme.iconMd,
            ),
            AppTheme.space2.w,
            Text(
              'اتجاه القبلة',
              style: AppTheme.titleLarge.copyWith(
                fontWeight: AppTheme.bold,
              ),
            ),
          ],
        ),
        if (widget.showStatus)
          _buildStatusChip(),
      ],
    );
  }

  Widget _buildCompass(double size) {
    return AnimatedBuilder(
      animation: widget.useAnimation ? _animationController : const AlwaysStoppedAnimation(1.0),
      builder: (context, child) {
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: AppTheme.oliveGoldGradient,
            shape: BoxShape.circle,
            boxShadow: AppTheme.shadowLg,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // خلفية البوصلة
              Container(
                width: size * 0.85,
                height: size * 0.85,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              
              // علامات الاتجاهات
              _buildCompassMarks(size * 0.85),
              
              // السهم
              Transform.rotate(
                angle: widget.useAnimation ? _rotationAnimation.value : widget.direction * (math.pi / 180),
                child: Transform.scale(
                  scale: widget.useAnimation ? _pulseAnimation.value : 1.0,
                  child: Icon(
                    Icons.navigation,
                    size: size * 0.25,
                    color: AppTheme.tertiary,
                  ),
                ),
              ),
              
              // النص المركزي
              Positioned(
                bottom: size * 0.15,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppTheme.radiusFull.radius,
                    border: Border.all(color: AppTheme.tertiary, width: 1),
                  ),
                  child: Text(
                    '${widget.direction.toStringAsFixed(0)}°',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.tertiary,
                      fontWeight: AppTheme.bold,
                      fontFamily: AppTheme.numbersFont,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompassMarks(double size) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: CompassMarksPainter(),
      ),
    );
  }

  Widget _buildStatusChip() {
    final isCalibrated = widget.isCalibrated;
    final color = isCalibrated ? AppTheme.success : AppTheme.warning;
    final text = isCalibrated ? 'مُعايَر' : 'غير مُعايَر';
    final icon = isCalibrated ? Icons.check_circle : Icons.warning;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.space2,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppTheme.radiusFull.radius,
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color,
          ),
          AppTheme.space1.w,
          Text(
            text,
            style: AppTheme.caption.copyWith(
              color: color,
              fontWeight: AppTheme.medium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Column(
      children: [
        if (widget.locationName != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_on,
                size: AppTheme.iconSm,
                color: AppTheme.textSecondary,
              ),
              AppTheme.space1.w,
              Text(
                widget.locationName!,
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: AppTheme.medium,
                ),
              ),
            ],
          ),
          AppTheme.space2.h,
        ],
        
        if (widget.accuracy != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.gps_fixed,
                size: AppTheme.iconSm,
                color: AppTheme.info,
              ),
              AppTheme.space1.w,
              Text(
                'دقة القياس: ${widget.accuracy!.toStringAsFixed(1)}%',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.info,
                  fontFamily: AppTheme.numbersFont,
                ),
              ),
            ],
          ),
          AppTheme.space2.h,
        ],
        
        // زر المعايرة
        if (!widget.isCalibrated && widget.onCalibrate != null)
          ElevatedButton.icon(
            onPressed: widget.onCalibrate,
            icon: const Icon(Icons.tune, size: AppTheme.iconSm),
            label: const Text('معايرة البوصلة'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.tertiary,
              foregroundColor: Colors.white,
            ),
          ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: widget.actions!.map((action) => action).toList(),
    );
  }
}

/// بطاقة القبلة المبسطة للعرض السريع
class SimpleQiblaCard extends StatelessWidget {
  final double direction;
  final VoidCallback? onTap;
  final bool showDegrees;

  const SimpleQiblaCard({
    super.key,
    required this.direction,
    this.onTap,
    this.showDegrees = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppTheme.space3.padding,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusLg.radius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppTheme.radiusLg.radius,
          child: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.oliveGoldGradient,
              borderRadius: AppTheme.radiusLg.radius,
              boxShadow: AppTheme.shadowMd,
            ),
            padding: AppTheme.space4.padding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // البوصلة المصغرة
                Transform.rotate(
                  angle: direction * (math.pi / 180),
                  child: const Icon(
                    Icons.navigation,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                
                AppTheme.space2.h,
                
                Text(
                  'القبلة',
                  style: AppTheme.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: AppTheme.semiBold,
                  ),
                ),
                
                if (showDegrees) ...[
                  AppTheme.space1.h,
                  Text(
                    '${direction.toStringAsFixed(0)}°',
                    style: AppTheme.bodyLarge.copyWith(
                      color: Colors.white,
                      fontFamily: AppTheme.numbersFont,
                      fontWeight: AppTheme.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// بطاقة معلومات القبلة والمسافة
class QiblaInfoCard extends StatelessWidget {
  final double direction;
  final double distance;
  final String? cityName;
  final String? countryName;
  final VoidCallback? onViewMap;

  const QiblaInfoCard({
    super.key,
    required this.direction,
    required this.distance,
    this.cityName,
    this.countryName,
    this.onViewMap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppTheme.space3.padding,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusLg.radius,
        child: InkWell(
          onTap: onViewMap,
          borderRadius: AppTheme.radiusLg.radius,
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: AppTheme.radiusLg.radius,
              border: Border.all(
                color: AppTheme.divider.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: AppTheme.shadowSm,
            ),
            padding: AppTheme.space4.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // العنوان
                Row(
                  children: [
                    Icon(
                      Icons.mosque,
                      color: AppTheme.primary,
                      size: AppTheme.iconMd,
                    ),
                    AppTheme.space2.w,
                    Text(
                      'معلومات القبلة',
                      style: AppTheme.titleMedium.copyWith(
                        fontWeight: AppTheme.semiBold,
                      ),
                    ),
                  ],
                ),
                
                AppTheme.space4.h,
                
                // المعلومات
                _buildInfoRow(
                  'الاتجاه',
                  '${direction.toStringAsFixed(1)}° شمال شرق',
                  Icons.explore,
                  AppTheme.tertiary,
                ),
                
                AppTheme.space3.h,
                
                _buildInfoRow(
                  'المسافة',
                  '${_formatDistance(distance)}',
                  Icons.straighten,
                  AppTheme.info,
                ),
                
                if (cityName != null) ...[
                  AppTheme.space3.h,
                  _buildInfoRow(
                    'موقعك',
                    '$cityName${countryName != null ? "، $countryName" : ""}',
                    Icons.location_on,
                    AppTheme.warning,
                  ),
                ],
                
                AppTheme.space3.h,
                
                _buildInfoRow(
                  'الوجهة',
                  'الكعبة المشرفة، مكة المكرمة',
                  Icons.mosque,
                  AppTheme.primary,
                ),
                
                // رابط الخريطة
                if (onViewMap != null) ...[
                  AppTheme.space4.h,
                  Center(
                    child: TextButton.icon(
                      onPressed: onViewMap,
                      icon: const Icon(Icons.map, size: AppTheme.iconSm),
                      label: const Text('عرض على الخريطة'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon, Color color) {
    return Row(
      children: [
        Icon(
          icon,
          size: AppTheme.iconSm,
          color: color,
        ),
        AppTheme.space2.w,
        Text(
          '$label: ',
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: AppTheme.medium,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTheme.bodyMedium.copyWith(
              color: color,
              fontWeight: AppTheme.semiBold,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDistance(double distanceKm) {
    if (distanceKm >= 1000) {
      return '${(distanceKm / 1000).toStringAsFixed(1)} ألف كم';
    } else {
      return '${distanceKm.toStringAsFixed(0)} كم';
    }
  }
}

/// بطاقة حالة المعايرة
class CalibrationStatusCard extends StatelessWidget {
  final bool isCalibrated;
  final double? accuracy;
  final VoidCallback? onCalibrate;
  final VoidCallback? onReset;
  final List<String>? calibrationSteps;

  const CalibrationStatusCard({
    super.key,
    required this.isCalibrated,
    this.accuracy,
    this.onCalibrate,
    this.onReset,
    this.calibrationSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppTheme.space3.padding,
      child: Material(
        color: Colors.transparent,
        borderRadius: AppTheme.radiusLg.radius,
        child: Container(
          decoration: BoxDecoration(
            color: isCalibrated 
                ? AppTheme.success.withValues(alpha: 0.1)
                : AppTheme.warning.withValues(alpha: 0.1),
            borderRadius: AppTheme.radiusLg.radius,
            border: Border.all(
              color: isCalibrated ? AppTheme.success : AppTheme.warning,
              width: 2,
            ),
          ),
          padding: AppTheme.space4.padding,
          child: Column(
            children: [
              // الأيقونة والحالة
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isCalibrated 
                          ? AppTheme.success
                          : AppTheme.warning,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCalibrated ? Icons.check : Icons.warning,
                      color: Colors.white,
                      size: AppTheme.iconMd,
                    ),
                  ),
                  
                  AppTheme.space3.w,
                  
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isCalibrated ? 'البوصلة معايرة' : 'البوصلة غير معايرة',
                          style: AppTheme.titleMedium.copyWith(
                            fontWeight: AppTheme.semiBold,
                            color: isCalibrated ? AppTheme.success : AppTheme.warning,
                          ),
                        ),
                        AppTheme.space1.h,
                        Text(
                          isCalibrated 
                              ? 'يمكنك الآن استخدام البوصلة بثقة'
                              : 'يرجى معايرة البوصلة للحصول على نتائج دقيقة',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // دقة القياس
              if (accuracy != null) ...[
                AppTheme.space3.h,
                Container(
                  width: double.infinity,
                  padding: AppTheme.space3.padding,
                  decoration: BoxDecoration(
                    color: AppTheme.info.withValues(alpha: 0.1),
                    borderRadius: AppTheme.radiusMd.radius,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.gps_fixed,
                        size: AppTheme.iconSm,
                        color: AppTheme.info,
                      ),
                      AppTheme.space1.w,
                      Text(
                        'دقة القياس: ${accuracy!.toStringAsFixed(1)}%',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.info,
                          fontWeight: AppTheme.medium,
                          fontFamily: AppTheme.numbersFont,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              // خطوات المعايرة
              if (!isCalibrated && calibrationSteps != null) ...[
                AppTheme.space4.h,
                Container(
                  width: double.infinity,
                  padding: AppTheme.space3.padding,
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: AppTheme.radiusMd.radius,
                    border: Border.all(
                      color: AppTheme.divider.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'خطوات المعايرة:',
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: AppTheme.semiBold,
                        ),
                      ),
                      AppTheme.space2.h,
                      ...calibrationSteps!.asMap().entries.map((entry) => 
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppTheme.space1),
                          child: Text(
                            '${entry.key + 1}. ${entry.value}',
                            style: AppTheme.bodySmall.copyWith(
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              // الأزرار
              AppTheme.space4.h,
              Row(
                children: [
                  if (!isCalibrated && onCalibrate != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onCalibrate,
                        icon: const Icon(Icons.tune, size: AppTheme.iconSm),
                        label: const Text('بدء المعايرة'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.warning,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  
                  if (isCalibrated && onReset != null) ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onReset,
                        icon: const Icon(Icons.refresh, size: AppTheme.iconSm),
                        label: const Text('إعادة معايرة'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== مكونات مساعدة للقبلة ====================

/// إجراء في بطاقة القبلة
class QiblaAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final bool isPrimary;

  const QiblaAction({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        borderRadius: AppTheme.radiusMd.radius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.space3,
            vertical: AppTheme.space2,
          ),
          decoration: isPrimary ? BoxDecoration(
            color: color ?? AppTheme.tertiary,
            borderRadius: AppTheme.radiusMd.radius,
          ) : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppTheme.iconMd,
                color: isPrimary 
                    ? Colors.white
                    : color ?? AppTheme.textSecondary,
              ),
              if (label.isNotEmpty) ...[
                AppTheme.space1.h,
                Text(
                  label,
                  style: AppTheme.caption.copyWith(
                    color: isPrimary 
                        ? Colors.white
                        : color ?? AppTheme.textSecondary,
                    fontWeight: AppTheme.medium,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// رسام علامات البوصلة
class CompassMarksPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.textTertiary.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // رسم العلامات الرئيسية (كل 90 درجة)
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 2;
      final startX = center.dx + (radius - 15) * math.cos(angle - math.pi / 2);
      final startY = center.dy + (radius - 15) * math.sin(angle - math.pi / 2);
      final endX = center.dx + (radius - 5) * math.cos(angle - math.pi / 2);
      final endY = center.dy + (radius - 5) * math.sin(angle - math.pi / 2);
      
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        paint..strokeWidth = 2,
      );
    }

    // رسم العلامات الفرعية (كل 30 درجة)
    for (int i = 0; i < 12; i++) {
      if (i % 3 != 0) { // تجنب العلامات الرئيسية
        final angle = i * math.pi / 6;
        final startX = center.dx + (radius - 10) * math.cos(angle - math.pi / 2);
        final startY = center.dy + (radius - 10) * math.sin(angle - math.pi / 2);
        final endX = center.dx + (radius - 5) * math.cos(angle - math.pi / 2);
        final endY = center.dy + (radius - 5) * math.sin(angle - math.pi / 2);
        
        canvas.drawLine(
          Offset(startX, startY),
          Offset(endX, endY),
          paint..strokeWidth = 1,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// مؤشر اتجاه القبلة مع النص
class QiblaDirectionIndicator extends StatelessWidget {
  final double direction;
  final String directionText;
  final bool showAnimation;

  const QiblaDirectionIndicator({
    super.key,
    required this.direction,
    required this.directionText,
    this.showAnimation = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.space3.padding,
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: AppTheme.radiusMd.radius,
        boxShadow: AppTheme.shadowSm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // السهم
          TweenAnimationBuilder<double>(
            duration: showAnimation 
                ? const Duration(milliseconds: 800)
                : Duration.zero,
            tween: Tween(begin: 0, end: direction),
            builder: (context, value, child) {
              return Transform.rotate(
                angle: value * (math.pi / 180),
                child: const Icon(
                  Icons.navigation,
                  color: Colors.white,
                  size: AppTheme.iconMd,
                ),
              );
            },
          ),
          
          AppTheme.space2.w,
          
          // النص
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                directionText,
                style: AppTheme.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: AppTheme.semiBold,
                ),
              ),
              Text(
                '${direction.toStringAsFixed(0)}°',
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontFamily: AppTheme.numbersFont,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== Factory Methods للقبلة ====================

/// مصنع بطاقات القبلة
class QiblaCards {
  QiblaCards._();

  /// بطاقة قبلة بسيطة
  static Widget simple({
    required double direction,
    VoidCallback? onTap,
    bool showDegrees = true,
  }) {
    return SimpleQiblaCard(
      direction: direction,
      onTap: onTap,
      showDegrees: showDegrees,
    );
  }

  /// بطاقة قبلة متقدمة
  static Widget advanced({
    required double direction,
    String? locationName,
    double? accuracy,
    bool isCalibrated = false,
    VoidCallback? onTap,
    VoidCallback? onCalibrate,
    List<QiblaAction>? actions,
    bool isCompact = false,
  }) {
    return QiblaCard(
      direction: direction,
      locationName: locationName,
      accuracy: accuracy,
      isCalibrated: isCalibrated,
      onTap: onTap,
      onCalibrate: onCalibrate,
      actions: actions,
      isCompact: isCompact,
    );
  }

  /// بطاقة معلومات القبلة
  static Widget info({
    required double direction,
    required double distance,
    String? cityName,
    String? countryName,
    VoidCallback? onViewMap,
  }) {
    return QiblaInfoCard(
      direction: direction,
      distance: distance,
      cityName: cityName,
      countryName: countryName,
      onViewMap: onViewMap,
    );
  }

  /// بطاقة حالة المعايرة
  static Widget calibration({
    required bool isCalibrated,
    double? accuracy,
    VoidCallback? onCalibrate,
    VoidCallback? onReset,
    List<String>? steps,
  }) {
    return CalibrationStatusCard(
      isCalibrated: isCalibrated,
      accuracy: accuracy,
      onCalibrate: onCalibrate,
      onReset: onReset,
      calibrationSteps: steps ?? [
        'ضع الجهاز على سطح مستوي',
        'حرك الجهاز في شكل رقم 8 عدة مرات',
        'استدر 360 درجة ببطء',
        'انتظر حتى تستقر البوصلة',
      ],
    );
  }

  /// مؤشر الاتجاه
  static Widget directionIndicator({
    required double direction,
    bool showAnimation = true,
  }) {
    String directionText = _getDirectionText(direction);
    
    return QiblaDirectionIndicator(
      direction: direction,
      directionText: directionText,
      showAnimation: showAnimation,
    );
  }

  /// تحديد النص النصي للاتجاه
  static String _getDirectionText(double direction) {
    // تطبيع الاتجاه (0-360)
    final normalizedDirection = direction % 360;
    
    if (normalizedDirection >= 337.5 || normalizedDirection < 22.5) {
      return 'شمال';
    } else if (normalizedDirection >= 22.5 && normalizedDirection < 67.5) {
      return 'شمال شرق';
    } else if (normalizedDirection >= 67.5 && normalizedDirection < 112.5) {
      return 'شرق';
    } else if (normalizedDirection >= 112.5 && normalizedDirection < 157.5) {
      return 'جنوب شرق';
    } else if (normalizedDirection >= 157.5 && normalizedDirection < 202.5) {
      return 'جنوب';
    } else if (normalizedDirection >= 202.5 && normalizedDirection < 247.5) {
      return 'جنوب غرب';
    } else if (normalizedDirection >= 247.5 && normalizedDirection < 292.5) {
      return 'غرب';
    } else {
      return 'شمال غرب';
    }
  }
}

// ==================== Extensions للقبلة ====================

extension QiblaCardExtensions on BuildContext {
  /// إظهار مساعد المعايرة
  void showCalibrationGuide({
    VoidCallback? onStart,
    VoidCallback? onSkip,
  }) {
    showDialog(
      context: this,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.tune,
              color: AppTheme.warning,
            ),
            AppTheme.space2.w,
            const Text('معايرة البوصلة'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'لضمان دقة البوصلة، يرجى اتباع الخطوات التالية:',
              style: AppTheme.bodyMedium,
            ),
            AppTheme.space3.h,
            ...QiblaCards._getCalibrationSteps().asMap().entries.map((entry) => 
              Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.space2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppTheme.warning,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: AppTheme.caption.copyWith(
                            color: Colors.white,
                            fontWeight: AppTheme.bold,
                          ),
                        ),
                      ),
                    ),
                    AppTheme.space2.w,
                    Expanded(
                      child: Text(
                        entry.value,
                        style: AppTheme.bodySmall.copyWith(
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          if (onSkip != null)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                onSkip();
              },
              child: const Text('تخطي'),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (onStart != null) onStart();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warning,
            ),
            child: const Text('بدء المعايرة'),
          ),
        ],
      ),
    );
  }

  /// إظهار معلومات القبلة التفصيلية
  void showQiblaDetails({
    required double direction,
    required double distance,
    String? locationName,
  }) {
    showModalBottomSheet(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: AppTheme.space4.padding,
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: AppTheme.radiusXl.radius,
        ),
        child: Padding(
          padding: AppTheme.space5.padding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // مقبض السحب
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.divider,
                  borderRadius: AppTheme.radiusFull.radius,
                ),
              ),
              
              AppTheme.space4.h,
              
              // معلومات القبلة
              QiblaCards.info(
                direction: direction,
                distance: distance,
                cityName: locationName,
                onViewMap: () {
                  Navigator.pop(context);
                  // فتح الخريطة
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== دوال مساعدة ====================

extension _QiblaHelpers on QiblaCards {
  static List<String> _getCalibrationSteps() {
    return [
      'ضع الجهاز على سطح مستوي بعيداً عن الأجهزة المعدنية',
      'حرك الجهاز في شكل رقم 8 عدة مرات ببطء',
      'استدر 360 درجة مع الجهاز ببطء وثبات',
      'انتظر بضع ثوانٍ حتى تستقر البوصلة',
      'تأكد من عدم وجود تداخل مغناطيسي قريب',
    ];
  }
}