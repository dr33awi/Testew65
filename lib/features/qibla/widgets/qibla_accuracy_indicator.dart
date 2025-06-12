// lib/features/qibla/widgets/qibla_accuracy_indicator.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';

class QiblaAccuracyIndicator extends StatefulWidget {
  final double accuracy;
  final bool isCalibrated;
  final VoidCallback? onCalibrate;

  const QiblaAccuracyIndicator({
    super.key,
    required this.accuracy,
    required this.isCalibrated,
    this.onCalibrate,
  });

  @override
  State<QiblaAccuracyIndicator> createState() => _QiblaAccuracyIndicatorState();
}

class _QiblaAccuracyIndicatorState extends State<QiblaAccuracyIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getAccuracyColor();
    final needsCalibration = widget.accuracy < 0.7 && !widget.isCalibrated;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // أيقونة الدقة
              AnimatedBuilder(
                animation: needsCalibration ? _scaleAnimation : _animationController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: needsCalibration ? _scaleAnimation.value : 1.0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getAccuracyIcon(),
                        color: color,
                        size: 24,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              
              // معلومات الدقة
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'دقة البوصلة',
                          style: context.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${(widget.accuracy * 100).toInt()}%',
                            style: TextStyle(
                              color: color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getAccuracyDescription(),
                      style: context.bodySmall?.copyWith(
                        color: context.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              
              // زر المعايرة
              if (needsCalibration && widget.onCalibrate != null)
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      widget.onCalibrate?.call();
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: color.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.compass_calibration,
                            size: 16,
                            color: color,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'معايرة',
                            style: TextStyle(
                              color: color,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          
          // شريط التقدم
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: widget.accuracy,
              backgroundColor: color.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
          
          // رسالة المعايرة
          if (widget.isCalibrated)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 14,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'تمت المعايرة',
                    style: context.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getAccuracyColor() {
    if (widget.accuracy >= 0.8) return Colors.green;
    if (widget.accuracy >= 0.5) return Colors.orange;
    return Colors.red;
  }

  IconData _getAccuracyIcon() {
    if (widget.accuracy >= 0.8) return Icons.gps_fixed;
    if (widget.accuracy >= 0.5) return Icons.gps_not_fixed;
    return Icons.gps_off;
  }

  String _getAccuracyDescription() {
    if (widget.accuracy >= 0.8) {
      return 'دقة ممتازة - البوصلة تعمل بشكل مثالي';
    } else if (widget.accuracy >= 0.5) {
      return 'دقة متوسطة - قد تحتاج إلى معايرة';
    } else {
      return 'دقة ضعيفة - يُنصح بمعايرة البوصلة';
    }
  }
}