import 'package:get/get.dart';
import '../features/splash/presentation/bindings/splash_binding.dart';
import '../features/splash/presentation/screens/splash_screen.dart';
import '../features/pin/presentation/bindings/pin_binding.dart';
import '../features/pin/presentation/screens/pin_screen.dart';
import '../features/home/presentation/bindings/home_binding.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/home/presentation/screens/property_details_screen.dart';
import '../features/settings/presentation/bindings/settings_binding.dart';
import '../features/settings/presentation/screens/settings_screen.dart';
import 'app_routes.dart';
import 'auth_middleware.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.pin,
      page: () => const PinScreen(),
      binding: PinBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.propertyDetails,
      page: () => const PropertyDetailsScreen(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsScreen(),
      binding: SettingsBinding(),
      middlewares: [AuthMiddleware()],
    ),
  ];
}