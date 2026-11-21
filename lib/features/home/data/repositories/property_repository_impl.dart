import 'package:get_storage/get_storage.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/repositories/property_repository.dart';

class PropertyRepositoryImpl implements PropertyRepository {
  final GetStorage _box = GetStorage();

  final List<PropertyEntity> _baseUnits = const [
    PropertyEntity(
      id: 'unit_101',
      propertyNameAr: 'عمارة النور السكنية',
      propertyNameEn: 'Al-Noor Residential Building',
      unitTitleAr: 'شقة 101 - الدور الأول',
      unitTitleEn: 'Apt 101 - 1st Floor',
      zoneAr: 'صنعاء - حي حدة',
      zoneEn: 'Sanaa - Hadda Zone',
      unitTier: 'VIP',
      isRented: true,
      monthlyRent: 350,
      dueDay: 10,
      hasInsurance: true,
      servicesAr: 'ماء وحراسة مشمولة • كهرباء عداد مستقل',
      servicesEn: 'Water & Security included • Separate Electricity meter',
      tenantName: 'أحمد صالح المقطري',
      tenantPhone: '777123456',
      familyMembers: 5,
      jobAndGuaranteeAr: 'مهندس اتصالات • ضمانة تجارية',
      jobAndGuaranteeEn: 'Telecom Engineer • Commercial Guarantee',
    ),
    PropertyEntity(
      id: 'unit_102',
      propertyNameAr: 'عمارة النور السكنية',
      propertyNameEn: 'Al-Noor Residential Building',
      unitTitleAr: 'شقة 102 - الدور الثاني',
      unitTitleEn: 'Apt 102 - 2nd Floor',
      zoneAr: 'صنعاء - حي حدة',
      zoneEn: 'Sanaa - Hadda Zone',
      unitTier: 'Standard',
      isRented: true,
      monthlyRent: 250,
      dueDay: 15,
      hasInsurance: true,
      servicesAr: 'ماء ونظافة مشمولة ضمن الإيجار',
      servicesEn: 'Water & Cleaning included in rent',
      tenantName: 'خالد محمد الحميري',
      tenantPhone: '771987654',
      familyMembers: 4,
      jobAndGuaranteeAr: 'محاسب قانوني • كفيل تجاري',
      jobAndGuaranteeEn: 'Accountant • Commercial Sponsor',
    ),
    PropertyEntity(
      id: 'unit_201',
      propertyNameAr: 'برج الأندلس التجاري',
      propertyNameEn: 'Al-Andalus Commercial Tower',
      unitTitleAr: 'معرض تجاري رقم 4',
      unitTitleEn: 'Commercial Shop #4',
      zoneAr: 'صنعاء - شارع الخمسين',
      zoneEn: 'Sanaa - Al-Khamseen St.',
      unitTier: 'VIP',
      isRented: true,
      monthlyRent: 600,
      dueDay: 30,
      hasInsurance: true,
      servicesAr: 'حراسة 24 ساعة • طاقة شمسية مشتركة',
      servicesEn: '24/7 Security • Shared Solar Power',
      tenantName: 'مؤسسة الرواد للتجارة',
      tenantPhone: '770555444',
      familyMembers: 1,
      jobAndGuaranteeAr: 'سجل تجاري ساري المفعول',
      jobAndGuaranteeEn: 'Valid Commercial Registration',
    ),
    PropertyEntity(
      id: 'unit_202',
      propertyNameAr: 'برج الأندلس التجاري',
      propertyNameEn: 'Al-Andalus Commercial Tower',
      unitTitleAr: 'مكتب إداري 305',
      unitTitleEn: 'Executive Office 305',
      zoneAr: 'صنعاء - شارع الخمسين',
      zoneEn: 'Sanaa - Al-Khamseen St.',
      unitTier: 'Standard',
      isRented: false,
      monthlyRent: 300,
      dueDay: 1,
      hasInsurance: false,
      servicesAr: 'ماء وكهرباء حسب العداد',
      servicesEn: 'Water & Electricity per meter',
      tenantName: '-',
      tenantPhone: '-',
      familyMembers: 0,
      jobAndGuaranteeAr: '-',
      jobAndGuaranteeEn: '-',
    ),
  ];

  String _today() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic>? _readContract(String unitId) {
    final raw = _box.read('contract_$unitId');
    if (raw is Map) {
      return Map<String, dynamic>.from(raw);
    }
    return null;
  }

  List<PaymentRecord> _readPayments(String unitId) {
    final raw = _box.read('payments_$unitId');
    if (raw == null) {
      if (unitId == 'unit_101') {
        return const [
          PaymentRecord(
            id: 'pay_1',
            amount: 350,
            method: 'wallet',
            referenceNumber: 'JAW-984210',
            date: '2026-11-10',
          ),
        ];
      } else if (unitId == 'unit_102') {
        return const [
          PaymentRecord(
            id: 'pay_2',
            amount: 150,
            method: 'cash',
            referenceNumber: 'CASH-001',
            date: '2026-11-14',
          ),
        ];
      }
      return [];
    }
    if (raw is List) {
      return raw.map((e) => PaymentRecord.fromMap(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }

  Future<void> _logMovement(MovementRecord record) async {
    final current = await getMovements();
    final updated = [record, ...current];
    await _box.write('movements_log', updated.map((e) => e.toMap()).toList());
  }

  @override
  Future<List<MovementRecord>> getMovements() async {
    final raw = _box.read('movements_log');
    if (raw == null) {
      return const [
        MovementRecord(
          id: 'mov_1',
          titleAr: 'استلام دفعة إيجار (\$350)',
          titleEn: 'Rent Payment Received (\$350)',
          subtitleAr: 'شقة 101 • أحمد صالح المقطري (محفظة إلكترونية)',
          subtitleEn: 'Apt 101 • Ahmed Al-Maqtari (E-Wallet)',
          date: '2026-11-10',
          type: 'payment',
        ),
        MovementRecord(
          id: 'mov_2',
          titleAr: 'استلام دفعة جزئية (\$150)',
          titleEn: 'Partial Payment Received (\$150)',
          subtitleAr: 'شقة 102 • خالد محمد الحميري (نقداً)',
          subtitleEn: 'Apt 102 • Khaled Al-Hemyari (Cash)',
          date: '2026-11-14',
          type: 'payment',
        ),
      ];
    }
    if (raw is List) {
      return raw.map((e) => MovementRecord.fromMap(Map<String, dynamic>.from(e))).toList();
    }
    return [];
  }

  @override
  Future<List<PropertyEntity>> getUnitsAndContracts() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return _baseUnits.map((unit) {
      final contractOverride = _readContract(unit.id);
      if (contractOverride != null) {
        final bool rented = contractOverride['isRented'] ?? false;
        return unit.copyWith(
          isRented: rented,
          tenantName: rented ? (contractOverride['tenantName'] ?? '-') : '-',
          tenantPhone: rented ? (contractOverride['tenantPhone'] ?? '-') : '-',
          familyMembers: rented ? (contractOverride['familyMembers'] ?? 1) : 0,
          jobAndGuaranteeAr: rented ? (contractOverride['jobAndGuarantee'] ?? '-') : '-',
          jobAndGuaranteeEn: rented ? (contractOverride['jobAndGuarantee'] ?? '-') : '-',
          dueDay: contractOverride['dueDay'] ?? unit.dueDay,
          hasInsurance: contractOverride['hasInsurance'] ?? false,
          payments: rented ? _readPayments(unit.id) : [],
        );
      }
      return unit.copyWith(payments: _readPayments(unit.id));
    }).toList();
  }

  @override
  Future<void> addPaymentReceipt({
    required String unitId,
    required double amount,
    required String method,
    required String referenceNumber,
  }) async {
    final current = _readPayments(unitId);
    final unit = _baseUnits.firstWhere((u) => u.id == unitId);
    final contractOverride = _readContract(unitId);
    final tenant = contractOverride?['tenantName'] ?? unit.tenantName;

    current.insert(
      0,
      PaymentRecord(
        id: 'pay_${DateTime.now().millisecondsSinceEpoch}',
        amount: amount,
        method: method,
        referenceNumber: referenceNumber.trim().isEmpty ? 'CASH-${current.length + 1}' : referenceNumber.trim(),
        date: _today(),
      ),
    );

    await _box.write('payments_$unitId', current.map((e) => e.toMap()).toList());
    await _logMovement(
      MovementRecord(
        id: 'mov_${DateTime.now().millisecondsSinceEpoch}',
        titleAr: 'استلام دفعة إيجار (\$${amount.toInt()})',
        titleEn: 'Rent Payment Received (\$${amount.toInt()})',
        subtitleAr: '${unit.unitTitleAr} • $tenant (${method == 'wallet' ? 'محفظة' : 'نقداً'})',
        subtitleEn: '${unit.unitTitleEn} • $tenant (${method == 'wallet' ? 'Wallet' : 'Cash'})',
        date: _today(),
        type: 'payment',
      ),
    );
  }

  @override
  Future<void> assignTenantToUnit({
    required String unitId,
    required String tenantName,
    required String tenantPhone,
    required int familyMembers,
    required String jobAndGuarantee,
    required int dueDay,
    required bool hasInsurance,
  }) async {
    final unit = _baseUnits.firstWhere((u) => u.id == unitId);
    await _box.write('contract_$unitId', {
      'isRented': true,
      'tenantName': tenantName,
      'tenantPhone': tenantPhone,
      'familyMembers': familyMembers,
      'jobAndGuarantee': jobAndGuarantee,
      'dueDay': dueDay,
      'hasInsurance': hasInsurance,
    });
    await _box.write('payments_$unitId', []);

    await _logMovement(
      MovementRecord(
        id: 'mov_${DateTime.now().millisecondsSinceEpoch}',
        titleAr: 'توقيع عقد وتأجير وحدة',
        titleEn: 'New Lease Contract Signed',
        subtitleAr: '${unit.unitTitleAr} • المستأجر: $tenantName',
        subtitleEn: '${unit.unitTitleEn} • Tenant: $tenantName',
        date: _today(),
        type: 'contract',
      ),
    );
  }

  @override
  Future<void> vacateUnit(String unitId) async {
    final unit = _baseUnits.firstWhere((u) => u.id == unitId);
    final contractOverride = _readContract(unitId);
    final oldTenant = contractOverride?['tenantName'] ?? unit.tenantName;

    await _box.write('contract_$unitId', {'isRented': false});
    await _box.write('payments_$unitId', []);

    await _logMovement(
      MovementRecord(
        id: 'mov_${DateTime.now().millisecondsSinceEpoch}',
        titleAr: 'إنهاء عقد وإخلاء وحدة',
        titleEn: 'Contract Ended & Unit Vacated',
        subtitleAr: '${unit.unitTitleAr} • المستأجر السابق: $oldTenant',
        subtitleEn: '${unit.unitTitleEn} • Former Tenant: $oldTenant',
        date: _today(),
        type: 'vacate',
      ),
    );
  }
}