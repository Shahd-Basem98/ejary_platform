import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('settings'.tr)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // تبديل الوضع الداكن والفاتح
          Card(
            child: Obx(
                  () => SwitchListTile(
                secondary: const Icon(Icons.dark_mode_rounded, color: Color(0xFF5E35B1)),
                title: Text('dark_mode'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                value: controller.isDarkMode.value,
                onChanged: controller.toggleTheme,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // تبديل اللغة AR / EN
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language_rounded, color: Color(0xFF5E35B1)),
                      const SizedBox(width: 12),
                      Text('language'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Obx(
                        () => Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('العربية (AR)')),
                            selected: controller.currentLang.value == 'ar',
                            onSelected: (_) => controller.changeLanguage('ar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ChoiceChip(
                            label: const Center(child: Text('English (EN)')),
                            selected: controller.currentLang.value == 'en',
                            onSelected: (_) => controller.changeLanguage('en'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // تغيير رمز الدخول PIN
          Card(
            child: ListTile(
              leading: const Icon(Icons.pin_rounded, color: Color(0xFF5E35B1)),
              title: Text('change_pin'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
              onTap: () {
                final pinCtrl = TextEditingController();
                Get.defaultDialog(
                  title: 'change_pin'.tr,
                  content: TextField(
                    controller: pinCtrl,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(hintText: 'new_pin'.tr),
                  ),
                  textConfirm: 'save'.tr,
                  onConfirm: () => controller.updatePinCode(pinCtrl.text),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // زر قفل التطبيق وتسجيل الخروج
          ElevatedButton.icon(
            onPressed: controller.lockApp,
            icon: const Icon(Icons.lock_rounded),
            label: Text('lock_app'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ],
      ),
    );
  }
}