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

  List<PaymentRecord> _readPayments(String unitId) {
    final raw = _box.read<List<dynamic>>('payments_$unitId');
    if (raw == null) {
      // دفعات ابتدائية افتراضية لتوضيح الدفع الكامل والجزئي
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
    return raw.map((e) => PaymentRecord.fromMap(Map<String, dynamic>.from(e))).toList();
  }

  @override
  Future<List<PropertyEntity>> getUnitsAndContracts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _baseUnits.map((unit) => unit.copyWith(payments: _readPayments(unit.id))).toList();
  }

  @override
  Future<void> addPaymentReceipt({
    required String unitId,
    required double amount,
    required String method,
    required String referenceNumber,
  }) async {
    final current = _readPayments(unitId);
    final now = DateTime.now();
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    current.insert(
      0,
      PaymentRecord(
        id: 'pay_${now.millisecondsSinceEpoch}',
        amount: amount,
        method: method,
        referenceNumber: referenceNumber.trim().isEmpty ? 'CASH-${current.length + 1}' : referenceNumber.trim(),
        date: dateStr,
      ),
    );

    await _box.write('payments_$unitId', current.map((e) => e.toMap()).toList());
  }
}