import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pin_controller.dart';

class PinScreen extends GetView<PinController> {
  const PinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('app_name'.tr)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock_outline_rounded, size: 64, color: Color(0xFF5E35B1)),
                  const SizedBox(height: 16),
                  Text(
                    'enter_pin'.tr,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'default_pin_hint'.tr,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  Obx(
                        () => TextField(
                      controller: controller.pinTextController,
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      obscureText: controller.obscurePin.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22, letterSpacing: 8, fontWeight: FontWeight.bold),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        suffixIcon: IconButton(
                          icon: Icon(controller.obscurePin.value ? Icons.visibility : Icons.visibility_off),
                          onPressed: controller.toggleObscure,
                        ),
                      ),
                      onSubmitted: (_) => controller.submitPin(),
                    ),
                  ),
                  Obx(
                        () => controller.errorMessage.value.isEmpty
                        ? const SizedBox.shrink()
                        : Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: Obx(
                          () => ElevatedButton(
                        onPressed: controller.isLoading.value ? null : controller.submitPin,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: const Color(0xFF5E35B1),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                            : Text('unlock'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}