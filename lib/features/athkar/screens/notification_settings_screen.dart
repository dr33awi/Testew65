import 'package:flutter/material.dart';
import '../../../app/di/service_locator.dart';
import '../../../app/themes/app_theme.dart';
import '../services/athkar_service.dart';
import '../models/athkar_model.dart';
import '../../../core/infrastructure/services/notifications/notification_manager.dart';

class AthkarNotificationSettingsScreen extends StatefulWidget {
  const AthkarNotificationSettingsScreen({super.key});

  @override
  State<AthkarNotificationSettingsScreen> createState() => _AthkarNotificationSettingsScreenState();
}

class _AthkarNotificationSettingsScreenState extends State<AthkarNotificationSettingsScreen> {
  late final AthkarService _service;
  late Future<List<AthkarCategory>> _futureCategories;
  final Map<String, bool> _enabled = {};
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _service = getIt<AthkarService>();
    _futureCategories = _service.loadCategories().then((cats) {
      final enabledIds = _service.getEnabledReminderCategories();
      for (final c in cats) {
        _enabled[c.id] = enabledIds.contains(c.id);
      }
      return cats;
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await _service.updateReminderSettings(_enabled);
      if (mounted) {
        context.showSuccessSnackBar('تم تحديث التذكيرات');
      }
    } catch (e) {
      if (mounted) context.showErrorSnackBar('فشل الحفظ');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.simple(title: 'إشعارات الأذكار'),
      body: FutureBuilder<List<AthkarCategory>>(
        future: _futureCategories,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: AppLoading.circular());
          }
          final cats = snapshot.data!;
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: cats.length,
                  padding: const EdgeInsets.all(ThemeConstants.space4),
                  separatorBuilder: (_, __) => const Divider(height: 0),
                  itemBuilder: (context, index) {
                    final cat = cats[index];
                    final enabled = _enabled[cat.id] ?? false;
                    return SwitchListTile(
                      title: Text(cat.title),
                      subtitle: cat.notifyTime != null
                          ? Text('التنبيه عند ${cat.notifyTime!.format(context)}')
                          : const Text('لا يوجد وقت تنبيه محدد'),
                      value: enabled,
                      onChanged: (value) async {
                        setState(() => _enabled[cat.id] = value);
                        if (value) {
                          if (cat.notifyTime != null) {
                            await NotificationManager.instance.scheduleAthkarReminder(
                              categoryId: cat.id,
                              categoryName: cat.title,
                              time: cat.notifyTime!,
                            );
                          }
                        } else {
                          await NotificationManager.instance.cancelAthkarReminder(cat.id);
                        }
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(ThemeConstants.space4),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Text('حفظ الإعدادات'),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}