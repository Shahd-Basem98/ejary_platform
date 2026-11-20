import 'package:get/get.dart';
import '../../../../core/services/storage_service.dart';
import '../../domain/repositories/pin_repository.dart';

class PinRepositoryImpl implements PinRepository {
  final StorageService _storage = Get.find<StorageService>();

  @override
  Future<bool> verifyPin(String enteredPin) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return enteredPin.trim() == _storage.savedPin;
  }

  @override
  Future<void> unlockSession() async {
    await _storage.setUnlocked(true);
  }
}