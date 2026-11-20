import '../entities/property_entity.dart';

abstract class PropertyRepository {
  Future<List<PropertyEntity>> getUnitsAndContracts();
  Future<void> addPaymentReceipt({
    required String unitId,
    required double amount,
    required String method,
    required String referenceNumber,
  });
}