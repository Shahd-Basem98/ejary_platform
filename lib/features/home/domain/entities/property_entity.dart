class PaymentRecord {
  final String id;
  final double amount;
  final String method; // cash | wallet
  final String referenceNumber;
  final String date;

  const PaymentRecord({
    required this.id,
    required this.amount,
    required this.method,
    required this.referenceNumber,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'amount': amount,
    'method': method,
    'referenceNumber': referenceNumber,
    'date': date,
  };

  factory PaymentRecord.fromMap(Map<String, dynamic> map) => PaymentRecord(
    id: map['id'] ?? '',
    amount: (map['amount'] as num?)?.toDouble() ?? 0,
    method: map['method'] ?? 'cash',
    referenceNumber: map['referenceNumber'] ?? '-',
    date: map['date'] ?? '',
  );
}

class PropertyEntity {
  final String id;
  final String propertyNameAr;
  final String propertyNameEn;
  final String unitTitleAr;
  final String unitTitleEn;
  final String zoneAr;
  final String zoneEn;
  final String unitTier; // Standard | VIP
  final bool isRented;
  final double monthlyRent;
  final int dueDay;
  final bool hasInsurance;
  final String servicesAr;
  final String servicesEn;

  // بيانات المستأجر (Tenant)
  final String tenantName;
  final String tenantPhone;
  final int familyMembers;
  final String jobAndGuaranteeAr;
  final String jobAndGuaranteeEn;

  // سجل المدفوعات (Payments)
  final List<PaymentRecord> payments;

  const PropertyEntity({
    required this.id,
    required this.propertyNameAr,
    required this.propertyNameEn,
    required this.unitTitleAr,
    required this.unitTitleEn,
    required this.zoneAr,
    required this.zoneEn,
    required this.unitTier,
    required this.isRented,
    required this.monthlyRent,
    required this.dueDay,
    required this.hasInsurance,
    required this.servicesAr,
    required this.servicesEn,
    required this.tenantName,
    required this.tenantPhone,
    required this.familyMembers,
    required this.jobAndGuaranteeAr,
    required this.jobAndGuaranteeEn,
    this.payments = const [],
  });

  double get totalPaid => payments.fold(0.0, (sum, p) => sum + p.amount);
  double get remainingBalance => isRented ? (monthlyRent - totalPaid) : 0.0;

  PropertyEntity copyWith({List<PaymentRecord>? payments}) {
    return PropertyEntity(
      id: id,
      propertyNameAr: propertyNameAr,
      propertyNameEn: propertyNameEn,
      unitTitleAr: unitTitleAr,
      unitTitleEn: unitTitleEn,
      zoneAr: zoneAr,
      zoneEn: zoneEn,
      unitTier: unitTier,
      isRented: isRented,
      monthlyRent: monthlyRent,
      dueDay: dueDay,
      hasInsurance: hasInsurance,
      servicesAr: servicesAr,
      servicesEn: servicesEn,
      tenantName: tenantName,
      tenantPhone: tenantPhone,
      familyMembers: familyMembers,
      jobAndGuaranteeAr: jobAndGuaranteeAr,
      jobAndGuaranteeEn: jobAndGuaranteeEn,
      payments: payments ?? this.payments,
    );
  }
}