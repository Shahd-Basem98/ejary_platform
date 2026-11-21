import '../entities/property_entity.dart';

abstract class PropertyRepository {
  Future<List<PropertyEntity>> getUnitsAndContracts();
  Future<List<MovementRecord>> getMovements();
  Future<void> addPaymentReceipt({
    required String unitId,
    required double amount,
    required String method,
    required String referenceNumber,
  });
  Future<void> assignTenantToUnit({
    required String unitId,
    required String tenantName,
    required String tenantPhone,
    required int familyMembers,
    required String jobAndGuarantee,
    required int dueDay,
    required bool hasInsurance,
  });
  Future<void> vacateUnit(String unitId);
}