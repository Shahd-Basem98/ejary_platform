import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = (Get.locale?.languageCode ?? 'ar') == 'ar';
    final categories = ['all', 'apartments', 'villas', 'offices'];

    return Scaffold(
      appBar: AppBar(
        title: Text('home_title'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              onChanged: controller.updateSearch,
              decoration: InputDecoration(
                hintText: 'search_hint'.tr,
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // أزرار الفلترة بالتصنيفات (Obx)
          SizedBox(
            height: 46,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = categories[index];
                return Obx(() {
                  final selected = controller.selectedCategory.value == cat;
                  return ChoiceChip(
                    label: Text(cat.tr),
                    selected: selected,
                    onSelected: (_) => controller.selectCategory(cat),
                  );
                });
              },
            ),
          ),
          const SizedBox(height: 8),

          // قائمة العقارات باستخدام StateMixin (controller.obx)
          Expanded(
            child: controller.obx(
                  (properties) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: properties!.length,
                itemBuilder: (context, index) {
                  final prop = properties[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Get.toNamed(AppRoutes.propertyDetails, arguments: prop),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF5E35B1).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    prop.category == 'villas'
                                        ? Icons.villa_rounded
                                        : prop.category == 'offices'
                                        ? Icons.business_center_rounded
                                        : Icons.apartment_rounded,
                                    color: const Color(0xFF5E35B1),
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isAr ? prop.titleAr : prop.titleEn,
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on_outlined, size: 15, color: Colors.grey),
                                          const SizedBox(width: 4),
                                          Text(
                                            isAr ? prop.locationAr : prop.locationEn,
                                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 22),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${prop.rooms} ${'rooms'.tr} • ${prop.baths} ${'baths'.tr} • ${prop.area.toInt()} ${'area'.tr}',
                                  style: const TextStyle(fontSize: 12.5, color: Colors.grey),
                                ),
                                Text(
                                  '\$${prop.monthlyPrice.toInt()} ${'per_month'.tr}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF5E35B1),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              onLoading: const Center(child: CircularProgressIndicator()),
              onEmpty: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off_rounded, size: 56, color: Colors.grey),
                    const SizedBox(height: 10),
                    Text('no_results'.tr),
                  ],
                ),
              ),
              onError: (err) => Center(child: Text(err ?? 'Error')),
            ),
          ),
        ],
      ),
    );
  }
}