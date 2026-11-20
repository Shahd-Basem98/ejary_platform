import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/storage_keys.dart';

class StorageService extends GetxService {
  late final GetStorage _box;

  Future<StorageService> init() async {
    await GetStorage.init();
    _box = GetStorage();
    return this;
  }

  // إدارة الوضع الداكن والفاتح
  bool get isDarkMode => _box.read<bool>(StorageKeys.isDarkMode) ?? false;
  ThemeMode get themeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> saveThemeMode(bool isDark) async {
    await _box.write(StorageKeys.isDarkMode, isDark);
  }

  // إدارة اللغة (AR / EN)
  String get languageCode => _box.read<String>(StorageKeys.languageCode) ?? 'ar';
  Locale get locale => Locale(languageCode);

  Future<void> saveLanguage(String langCode) async {
    await _box.write(StorageKeys.languageCode, langCode);
  }

  // إدارة رمز القفل (PIN) وحالة فتح القفل
  String get savedPin => _box.read<String>(StorageKeys.savedPin) ?? '1234';
  Future<void> savePin(String pin) async => await _box.write(StorageKeys.savedPin, pin);

  bool get isUnlocked => _box.read<bool>(StorageKeys.isUnlocked) ?? false;
  Future<void> setUnlocked(bool value) async => await _box.write(StorageKeys.isUnlocked, value);

  // إدارة العقارات المحجوزة
  List<String> get bookedIds {
    final list = _box.read<List<dynamic>>(StorageKeys.bookedIds) ?? [];
    return list.map((e) => e.toString()).toList();
  }

  Future<void> toggleBooking(String propertyId) async {
    final current = bookedIds;
    if (current.contains(propertyId)) {
      current.remove(propertyId);
    } else {
      current.add(propertyId);
    }
    await _box.write(StorageKeys.bookedIds, current);
  }
}