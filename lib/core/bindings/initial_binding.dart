import 'package:get/get.dart';
import '../../features/pin/data/repositories/pin_repository_impl.dart';
import '../../features/pin/domain/repositories/pin_repository.dart';
import '../../features/home/data/repositories/property_repository_impl.dart';
import '../../features/home/domain/repositories/property_repository.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // حقن المستودعات (Repository Pattern) بشكل دائم على مستوى التطبيق
    Get.lazyPut<PinRepository>(() => PinRepositoryImpl(), fenix: true);
    Get.lazyPut<PropertyRepository>(() => PropertyRepositoryImpl(), fenix: true);
  }
}