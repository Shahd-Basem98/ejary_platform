import 'package:get/get.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/repositories/property_repository.dart';

class HomeController extends GetxController with StateMixin<List<PropertyEntity>> {
  final PropertyRepository _repository = Get.find<PropertyRepository>();

  List<PropertyEntity> allUnits = [];
  List<MovementRecord> movements = [];
  final selectedFilter = 'all'.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUnits();
  }

  Future<void> fetchUnits() async {
    change(null, status: RxStatus.loading());
    try {
      allUnits = await _repository.getUnitsAndContracts();
      movements = await _repository.getMovements();
      _applyFilters();
      update(['summary_cards', 'unit_details']);
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  double get totalExpected =>
      allUnits.where((u) => u.isRented).fold(0.0, (sum, u) => sum + u.monthlyRent);

  double get totalCollected =>
      allUnits.where((u) => u.isRented).fold(0.0, (sum, u) => sum + u.totalPaid);

  double get totalRemaining {
    final diff = totalExpected - totalCollected;
    return diff > 0 ? diff : 0.0;
  }

  void selectFilter(String filter) {
    selectedFilter.value = filter;
    _applyFilters();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void _applyFilters() {
    final q = searchQuery.value.trim().toLowerCase();
    final filter = selectedFilter.value;

    final filtered = allUnits.where((u) {
      final matchesFilter = switch (filter) {
        'rented' => u.isRented,
        'vacant' => !u.isRented,
        'overdue' => u.isRented && u.remainingBalance > 0,
        _ => true,
      };

      final matchesSearch = q.isEmpty ||
          u.tenantName.toLowerCase().contains(q) ||
          u.propertyNameAr.toLowerCase().contains(q) ||
          u.propertyNameEn.toLowerCase().contains(q) ||
          u.unitTitleAr.toLowerCase().contains(q) ||
          u.unitTitleEn.toLowerCase().contains(q);

      return matchesFilter && matchesSearch;
    }).toList();

    if (filtered.isEmpty) {
      change([], status: RxStatus.empty());
    } else {
      change(filtered, status: RxStatus.success());
    }
  }

  PropertyEntity getUnitById(String id) {
    return allUnits.firstWhere((element) => element.id == id);
  }

  Future<void> recordPayment({
    required String unitId,
    required double amount,
    required String method,
    required String referenceNumber,
  }) async {
    await _repository.addPaymentReceipt(
      unitId: unitId,
      amount: amount,
      method: method,
      referenceNumber: referenceNumber,
    );
    await fetchUnits();
  }

  Future<void> addNewTenant({
    required String unitId,
    required String tenantName,
    required String tenantPhone,
    required int familyMembers,
    required String jobAndGuarantee,
    required int dueDay,
    required bool hasInsurance,
  }) async {
    await _repository.assignTenantToUnit(
      unitId: unitId,
      tenantName: tenantName,
      tenantPhone: tenantPhone,
      familyMembers: familyMembers,
      jobAndGuarantee: jobAndGuarantee,
      dueDay: dueDay,
      hasInsurance: hasInsurance,
    );
    await fetchUnits();
  }

  Future<void> endContractAndVacate(String unitId) async {
    await _repository.vacateUnit(unitId);
    await fetchUnits();
  }
}