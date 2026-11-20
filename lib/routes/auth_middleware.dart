import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/services/storage_service.dart';
import 'app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    final storage = Get.find<StorageService>();
    if (!storage.isUnlocked) {
      return const RouteSettings(name: AppRoutes.pin);
    }
    return null;
  }
}