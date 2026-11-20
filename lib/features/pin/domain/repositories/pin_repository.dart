abstract class PinRepository {
  Future<bool> verifyPin(String enteredPin);
  Future<void> unlockSession();
}