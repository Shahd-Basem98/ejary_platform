import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../domain/repositories/pin_repository.dart';

class PinController extends GetxController {
  final PinRepository _pinRepository = Get.find<PinRepository>();

  final pinTextController = TextEditingController();
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final obscurePin = true.obs;

  void toggleObscure() => obscurePin.value = !obscurePin.value;

  Future<void> submitPin() async {
    errorMessage.value = '';
    isLoading.value = true;
    final isValid = await _pinRepository.verifyPin(pinTextController.text);
    isLoading.value = false;

    if (isValid) {
      await _pinRepository.unlockSession();
      Get.offAllNamed(AppRoutes.home);
    } else {
      errorMessage.value = 'wrong_pin'.tr;
    }
  }

  @override
  void onClose() {
    pinTextController.dispose();
    super.onClose();
  }
}