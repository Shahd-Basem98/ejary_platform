import '../../domain/entities/property_entity.dart';

class PropertyModel extends PropertyEntity {
  const PropertyModel({
    required super.id,
    required super.propertyNameAr,
    required super.propertyNameEn,
    required super.unitTitleAr,
    required super.unitTitleEn,
    required super.zoneAr,
    required super.zoneEn,
    required super.unitTier,
    required super.isRented,
    required super.monthlyRent,
    required super.dueDay,
    required super.hasInsurance,
    required super.servicesAr,
    required super.servicesEn,
    required super.tenantName,
    required super.tenantPhone,
    required super.familyMembers,
    required super.jobAndGuaranteeAr,
    required super.jobAndGuaranteeEn,
    super.payments,
  });
}