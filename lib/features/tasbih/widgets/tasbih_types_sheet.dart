// lib/features/tasbih/widgets/tasbih_types_sheet.dart

import 'package:flutter/material.dart';
import '../../../app/themes/index.dart';

class TasbihTypesSheet extends StatelessWidget {
  final String currentType;
  final Function(String) onTypeSelected;

  const TasbihTypesSheet({
    super.key,
    required this.currentType,
    required this.onTypeSelected,
  });

  static final List<Map<String, dynamic>> tasbihTypes = [
    {
      'text': 'سبحان الله',
      'meaning': 'تنزيه الله عن كل نقص',
      'reward': 'تملأ ما بين السماء والأرض',
      'icon': Icons.star,
      'color': Color(0xFF4CAF50),
    },
    {
      'text': 'الحمد لله',
      'meaning': 'الثناء على الله بجميع محامده',
      'reward': 'تملأ الميزان',
      'icon': Icons.favorite,
      'color': Color(0xFF2196F3),
    },
    {
      'text': 'الله أكبر',
      'meaning': 'الله أعظم من كل شيء',
      'reward': 'أحب إلى الله مما طلعت عليه الشمس',
      'icon': Icons.wb_sunny,
      'color': Color(0xFFFF9800),
    },
    {
      'text': 'لا إله إلا الله',
      'meaning': 'لا معبود بحق إلا الله',
      'reward': 'أفضل الذكر وأثقله في الميزان',
      'icon': Icons.mosque,
      'color': Color(0xFF9C27B0),
    },
    {
      'text': 'سبحان الله وبحمده',
      'meaning': 'تنزيه الله مع الثناء عليه',
      'reward': 'حبيبتان إلى الرحمن، خفيفتان على اللسان',
      'icon': Icons.auto_awesome,
      'color': Color(0xFF00BCD4),
    },
    {
      'text': 'سبحان الله العظيم',
      'meaning': 'تنزيه الله العظيم',
      'reward': 'غراس الجنة',
      'icon': Icons.park,
      'color': Color(0xFF4CAF50),
    },
    {
      'text': 'أستغفر الله',
      'meaning': 'طلب المغفرة من الله',
      'reward': 'يمحو الذنوب ويفتح أبواب الرزق',
      'icon': Icons.healing,
      'color': Color(0xFF795548),
    },
    {
      'text': 'لا حول ولا قوة إلا بالله',
      'meaning': 'لا تحول من حال إلى حال إلا بالله',
      'reward': 'كنز من كنوز الجنة',
      'icon': Icons.security,
      'color': Color(0xFF607D8B),
    },
    {
      'text': 'حسبنا الله ونعم الوكيل',
      'meaning': 'الله كافينا وهو نعم من نتوكل عليه',
      'reward': 'التوكل على الله والثقة به',
      'icon': Icons.shield,
      'color': Color(0xFF3F51B5),
    },
    {
      'text': 'رب اغفر لي',
      'meaning': 'دعاء طلب المغفرة',
      'reward': 'من أجمع الأدعية',
      'icon': Icons.volunteer_activism,
      'color': Color(0xFFE91E63),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // المقبض
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: context.borderColor.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // العنوان
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.mediumPadding),
            child: Row(
              children: [
                Icon(
                  Icons.format_quote,
                  color: context.primaryColor,
                ),
                Spaces.smallH,
                Text(
                  'اختر نوع التسبيح',
                  style: context.titleStyle.copyWith(
                    color: context.primaryColor,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          // القائمة
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.mediumPadding),
              child: Column(
                children: tasbihTypes.map((type) {
                  final isSelected = type['text'] == currentType;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildTasbihTypeCard(
                      context,
                      type,
                      isSelected,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasbihTypeCard(
    BuildContext context,
    Map<String, dynamic> type,
    bool isSelected,
  ) {
    final color = type['color'] as Color;
    
    return IslamicCard(
      onTap: () => onTypeSelected(type['text']),
      gradient: isSelected
          ? LinearGradient(
              colors: [
                color.withValues(alpha: 0.2),
                color.withValues(alpha: 0.1),
              ],
            )
          : null,
      border: isSelected
          ? Border.all(color: color, width: 2)
          : null,
      child: Padding(
        padding: EdgeInsets.all(context.mediumPadding),
        child: Row(
          children: [
            // الأيقونة
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color,
                    color.darken(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                type['icon'],
                color: Colors.white,
                size: 24,
              ),
            ),
            
            Spaces.mediumH,
            
            // المحتوى
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // النص العربي
                  IslamicText.dua(
                    text: type['text'],
                    textAlign: TextAlign.start,
                    fontSize: 18,
                    color: isSelected ? color : null,
                  ),
                  
                  Spaces.small,
                  
                  // المعنى
                  Text(
                    type['meaning'],
                    style: context.bodyStyle.copyWith(
                      color: context.secondaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                  
                  Spaces.xs,
                  
                  // الفضل
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      type['reward'],
                      style: context.captionStyle.copyWith(
                        color: color,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // مؤشر التحديد
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
}