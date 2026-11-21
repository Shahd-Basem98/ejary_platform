import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_routes.dart';
import '../../domain/entities/property_entity.dart';
import '../controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = (Get.locale?.languageCode ?? 'ar') == 'ar';
    final filters = ['all', 'rented', 'overdue', 'vacant'];

    return Scaffold(
      appBar: AppBar(
        title: Text('home_title'.tr),
        actions: [
          IconButton(
            tooltip: 'movements_log'.tr,
            icon: const Icon(Icons.history_rounded),
            onPressed: () => _showMovementsSheet(context, isAr),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: Column(
        children: [
          GetBuilder<HomeController>(
            id: 'summary_cards',
            builder: (_) => Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Row(
                children: [
                  _FinanceCard(
                    title: 'total_expected'.tr,
                    value: '\$${controller.totalExpected.toInt()}',
                    color: const Color(0xFF5E35B1),
                  ),
                  const SizedBox(width: 8),
                  _FinanceCard(
                    title: 'total_collected'.tr,
                    value: '\$${controller.totalCollected.toInt()}',
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(width: 8),
                  _FinanceCard(
                    title: 'total_remaining'.tr,
                    value: '\$${controller.totalRemaining.toInt()}',
                    color: Colors.orange.shade800,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          SizedBox(
            height: 44,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final f = filters[index];
                return Obx(() {
                  return ChoiceChip(
                    label: Text(f.tr),
                    selected: controller.selectedFilter.value == f,
                    onSelected: (_) => controller.selectFilter(f),
                  );
                });
              },
            ),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: controller.obx(
                  (units) => ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: units!.length,
                itemBuilder: (context, index) {
                  final unit = units[index];
                  return _UnitContractCard(unit: unit, isAr: isAr);
                },
              ),
              onLoading: const Center(child: CircularProgressIndicator()),
              onEmpty: Center(child: Text('no_results'.tr)),
              onError: (err) => Center(child: Text(err ?? 'Error')),
            ),
          ),
        ],
      ),
    );
  }

  void _showMovementsSheet(BuildContext context, bool isAr) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('movements_log'.tr, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(height: 24),
            if (controller.movements.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Center(child: Text('no_movements'.tr)),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.movements.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, index) {
                    final m = controller.movements[index];
                    final icon = switch (m.type) {
                      'contract' => Icons.person_add_alt_1_rounded,
                      'vacate' => Icons.door_front_door_outlined,
                      _ => Icons.payments_rounded,
                    };
                    final color = switch (m.type) {
                      'contract' => const Color(0xFF5E35B1),
                      'vacate' => Colors.red.shade700,
                      _ => Colors.green.shade700,
                    };
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: color.withValues(alpha: 0.14),
                        child: Icon(icon, color: color, size: 20),
                      ),
                      title: Text(isAr ? m.titleAr : m.titleEn, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${isAr ? m.subtitleAr : m.subtitleEn}\n${m.date}'),
                      isThreeLine: true,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FinanceCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _FinanceCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 11.5, color: color, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _UnitContractCard extends StatelessWidget {
  final PropertyEntity unit;
  final bool isAr;
  const _UnitContractCard({required this.unit, required this.isAr});

  @override
  Widget build(BuildContext context) {
    final statusBadge = !unit.isRented
        ? ('vacant'.tr, Colors.blueGrey)
        : unit.remainingBalance <= 0
        ? (unit.remainingBalance < 0 ? 'advance'.tr : 'paid'.tr, Colors.green)
        : unit.totalPaid > 0
        ? ('partial'.tr, Colors.orange)
        : ('unpaid'.tr, Colors.red);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Get.toNamed(AppRoutes.propertyDetails, arguments: unit.id),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${isAr ? unit.propertyNameAr : unit.propertyNameEn} • ${isAr ? unit.unitTitleAr : unit.unitTitleEn}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isAr ? unit.zoneAr : unit.zoneEn,
                          style: const TextStyle(color: Colors.grey, fontSize: 12.5),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusBadge.$2.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      statusBadge.$1,
                      style: TextStyle(color: statusBadge.$2, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 17, color: Color(0xFF5E35B1)),
                      const SizedBox(width: 6),
                      Text(
                        unit.isRented ? unit.tenantName : 'vacant'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Text(
                    '\$${unit.monthlyRent.toInt()} ${'per_month'.tr}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5E35B1)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}