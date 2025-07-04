// lib/features/tasbih/widgets/add_custom_dhikr_dialog.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/themes/app_theme.dart';
import '../models/dhikr_model.dart';

class AddCustomDhikrDialog extends StatefulWidget {
  final Function(DhikrItem) onDhikrAdded;

  const AddCustomDhikrDialog({
    super.key,
    required this.onDhikrAdded,
  });

  @override
  State<AddCustomDhikrDialog> createState() => _AddCustomDhikrDialogState();
}

class _AddCustomDhikrDialogState extends State<AddCustomDhikrDialog> {
  final _formKey = GlobalKey<FormState>();
  final _textController = TextEditingController();
  final _translationController = TextEditingController();
  final _virtueController = TextEditingController();
  final _countController = TextEditingController(text: '33');
  
  DhikrCategory _selectedCategory = DhikrCategory.custom;
  Color _selectedColor = ThemeConstants.primary;
  bool _isLoading = false;

  final List<Color> _availableColors = [
    ThemeConstants.primary,
    ThemeConstants.accent,
    ThemeConstants.tertiary,
    ThemeConstants.success,
    ThemeConstants.warning,
    ThemeConstants.info,
    ThemeConstants.error,
    ThemeConstants.primaryDark,
    ThemeConstants.accentDark,
    ThemeConstants.tertiaryDark,
  ];

  @override
  void dispose() {
    _textController.dispose();
    _translationController.dispose();
    _virtueController.dispose();
    _countController.dispose();
    super.dispose();
  }

  void _addDhikr() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final dhikr = DhikrItem(
        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
        text: _textController.text.trim(),
        translation: _translationController.text.trim().isEmpty 
            ? null 
            : _translationController.text.trim(),
        virtue: _virtueController.text.trim().isEmpty 
            ? null 
            : _virtueController.text.trim(),
        recommendedCount: int.parse(_countController.text),
        category: _selectedCategory,
        gradient: [_selectedColor, _selectedColor.lighten(0.2)],
        primaryColor: _selectedColor,
        isCustom: true,
      );

      widget.onDhikrAdded(dhikr);
      
      if (mounted) {
        HapticFeedback.mediumImpact();
        Navigator.pop(context);
        context.showSuccessSnackBar('تم إضافة الذكر المخصص بنجاح');
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('حدث خطأ أثناء إضافة الذكر');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // الرأس
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_selectedColor, _selectedColor.lighten(0.2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'إضافة ذكر مخصص',
                          style: context.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: ThemeConstants.bold,
                          ),
                        ),
                        Text(
                          'أنشئ ذكرك الخاص',
                          style: context.bodyMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // المحتوى
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // نص الذكر
                      _buildLabel('نص الذكر *'),
                      TextFormField(
                        controller: _textController,
                        decoration: _buildInputDecoration('اكتب الذكر هنا...'),
                        maxLines: 3,
                        validator: (value) {
                          if (value?.trim().isEmpty ?? true) {
                            return 'يرجى إدخال نص الذكر';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // الترجمة (اختيارية)
                      _buildLabel('الترجمة (اختياري)'),
                      TextFormField(
                        controller: _translationController,
                        decoration: _buildInputDecoration('الترجمة بالإنجليزية...'),
                        maxLines: 2,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // الفضل (اختياري)
                      _buildLabel('الفضل (اختياري)'),
                      TextFormField(
                        controller: _virtueController,
                        decoration: _buildInputDecoration('فضل هذا الذكر...'),
                        maxLines: 3,
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // العدد المقترح والتصنيف
                      Row(
                        children: [
                          // العدد المقترح
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('العدد المقترح *'),
                                TextFormField(
                                  controller: _countController,
                                  decoration: _buildInputDecoration('33'),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  validator: (value) {
                                    if (value?.trim().isEmpty ?? true) {
                                      return 'مطلوب';
                                    }
                                    final count = int.tryParse(value!);
                                    if (count == null || count <= 0) {
                                      return 'رقم صحيح';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          // التصنيف
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLabel('التصنيف'),
                                DropdownButtonFormField<DhikrCategory>(
                                  value: _selectedCategory,
                                  decoration: _buildInputDecoration(''),
                                  items: DhikrCategory.values.map((category) {
                                    return DropdownMenuItem(
                                      value: category,
                                      child: Row(
                                        children: [
                                          Icon(category.icon, size: 16),
                                          const SizedBox(width: 8),
                                          Text(category.title),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        _selectedCategory = value;
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // اختيار اللون
                      _buildLabel('اللون'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: _availableColors.map((color) {
                          final isSelected = color == _selectedColor;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedColor = color;
                              });
                              HapticFeedback.selectionClick();
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.3),
                                    blurRadius: isSelected ? 8 : 4,
                                    offset: Offset(0, isSelected ? 4 : 2),
                                  ),
                                ],
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 20,
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // الأزرار
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: AppButton.outline(
                      text: 'إلغاء',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  
                  const SizedBox(width: 12),
                  
                  Expanded(
                    child: AppButton.primary(
                      text: 'إضافة',
                      onPressed: _isLoading ? null : _addDhikr,
                      isLoading: _isLoading,
                      backgroundColor: _selectedColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: context.titleSmall?.copyWith(
          fontWeight: ThemeConstants.semiBold,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: context.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _selectedColor, width: 2),
      ),
      filled: true,
      fillColor: context.cardColor,
      contentPadding: const EdgeInsets.all(16),
    );
  }
}