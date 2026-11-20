import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/property_entity.dart';
import '../controllers/home_controller.dart';

class PropertyDetailsScreen extends GetView<HomeController> {
  const PropertyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PropertyEntity prop = Get.arguments as PropertyEntity;
    final isAr = (Get.locale?.languageCode ?? 'ar') == 'ar';

    return Scaffold(
      appBar: AppBar(title: Text('property_details'.tr)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isAr ? prop.titleAr : prop.titleEn,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 18, color: Color(0xFF5E35B1)),
                        const SizedBox(width: 6),
                        Text(isAr ? prop.locationAr : prop.locationEn),
                      ],
                    ),
                    const Divider(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _SpecBadge(icon: Icons.bed_rounded, label: '${prop.rooms} ${'rooms'.tr}'),
                        _SpecBadge(icon: Icons.bathtub_outlined, label: '${prop.baths} ${'baths'.tr}'),
                        _SpecBadge(icon: Icons.square_foot_rounded, label: '${prop.area.toInt()} ${'area'.tr}'),
                      ],
                    ),
                    const Divider(height: 28),
                    Text(
                      'description'.tr,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isAr ? prop.descriptionAr : prop.descriptionEn,
                      style: const TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            // استخدام GetBuilder لتحديث قسم الحجز عند الضغط
            GetBuilder<HomeController>(
              id: 'booking_section',
              builder: (_) {
                final booked = controller.isBooked(prop.id);
                return ElevatedButton.icon(
                  onPressed: () {
                    controller.toggleBooking(prop.id);
                    Get.snackbar(
                      'app_name'.tr,
                      booked ? 'cancel_booking'.tr : 'booked'.tr,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  icon: Icon(booked ? Icons.check_circle : Icons.bookmark_add_rounded),
                  label: Text(
                    booked
                        ? '${'booked'.tr} (${'cancel_booking'.tr})'
                        : '${'book_now'.tr} - \$${prop.monthlyPrice.toInt()}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: booked ? Colors.green.shade700 : const Color(0xFF5E35B1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SpecBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF5E35B1)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }
}