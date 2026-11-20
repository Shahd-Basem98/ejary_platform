import 'package:get/get.dart';
import '../../domain/entities/property_entity.dart';
import '../../domain/repositories/property_repository.dart';

class HomeController extends GetxController with StateMixin<List<PropertyEntity>> {
  final PropertyRepository _repository = Get.find<PropertyRepository>();

  List<PropertyEntity> _allProperties = [];
  final selectedCategory = 'all'.obs;
  final searchQuery = ''.obs;
  List<String> bookedIds = [];

  @override
  void onInit() {
    super.onInit();
    bookedIds = _repository.getBookedPropertyIds();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    change(null, status: RxStatus.loading());
    try {
      _allProperties = await _repository.getProperties();
      _applyFilters();
    } catch (e) {
      change(null, status: RxStatus.error(e.toString()));
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    _applyFilters();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchQuery.value.trim().toLowerCase();
    final cat = selectedCategory.value;

    final filtered = _allProperties.where((item) {
      final matchesCategory = cat == 'all' || item.category == cat;
      final matchesQuery = query.isEmpty ||
          item.titleAr.toLowerCase().contains(query) ||
          item.titleEn.toLowerCase().contains(query) ||
          item.locationAr.toLowerCase().contains(query) ||
          item.locationEn.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();

    if (filtered.isEmpty) {
      change([], status: RxStatus.empty());
    } else {
      change(filtered, status: RxStatus.success());
    }
  }

  bool isBooked(String propertyId) => bookedIds.contains(propertyId);

  // تحديث عبر GetBuilder عند تغيير حالة الحجز
  Future<void> toggleBooking(String propertyId) async {
    await _repository.togglePropertyBooking(propertyId);
    bookedIds = _repository.getBookedPropertyIds();
    update(['booking_section']);
  }
}