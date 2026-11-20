import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../routes/app_routes.dart';

class SettingsController extends GetxController {
  final StorageService _storage = Get.find<StorageService>();

  late final RxBool isDarkMode;
  late final RxString currentLang;

  @override
  void onInit() {
    super.onInit();
    isDarkMode = _storage.isDarkMode.obs;
    currentLang = _storage.languageCode.obs;
  }

  Future<void> toggleTheme(bool value) async {
    isDarkMode.value = value;
    await _storage.saveThemeMode(value);
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
  }

  Future<void> changeLanguage(String langCode) async {
    currentLang.value = langCode;
    await _storage.saveLanguage(langCode);
    Get.updateLocale(Locale(langCode));
  }

  Future<void> updatePinCode(String newPin) async {
    if (newPin.trim().length == 4) {
      await _storage.savePin(newPin.trim());
      Get.back();
      Get.snackbar('app_name'.tr, 'save'.tr, snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> lockApp() async {
    await _storage.setUnlocked(false);
    Get.offAllNamed(AppRoutes.pin);
  }
}