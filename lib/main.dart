import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/bindings/initial_binding.dart';
import 'core/locale/app_translations.dart';
import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة خدمة التخزين الدائمة GetxService قبل تشغيل التطبيق
  final storageService = await Get.putAsync<StorageService>(
        () => StorageService().init(),
    permanent: true,
  );

  runApp(EjaryPlatformApp(storageService: storageService));
}

class EjaryPlatformApp extends StatelessWidget {
  final StorageService storageService;
  const EjaryPlatformApp({super.key, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ejary Platform',
      translations: AppTranslations(),
      locale: storageService.locale,
      fallbackLocale: const Locale('ar'),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: storageService.themeMode,
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}