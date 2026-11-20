import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class PropertyDetailsScreen extends GetView<HomeController> {
  const PropertyDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String unitId = Get.arguments as String;
    final isAr = (Get.locale?.languageCode ?? 'ar') == 'ar';

    return Scaffold(
      appBar: AppBar(title: Text('property_details'.tr)),
      body: GetBuilder<HomeController>(
        id: 'unit_details',
        builder: (_) {
          final unit = controller.getUnitById(unitId);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // بطاقة الوحدة والخدمات
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${isAr ? unit.propertyNameAr : unit.propertyNameEn} - ${isAr ? unit.unitTitleAr : unit.unitTitleEn}',
                              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Chip(label: Text(unit.unitTier)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(isAr ? unit.zoneAr : unit.zoneEn, style: const TextStyle(color: Colors.grey)),
                      const Divider(height: 22),
                      Text('${'services'.tr}: ${isAr ? unit.servicesAr : unit.servicesEn}'),
                      const SizedBox(height: 6),
                      Text('${'due_day'.tr}: ${unit.dueDay}  •  ${'insurance'.tr}: ${unit.hasInsurance ? 'yes'.tr : 'no'.tr}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              if (!unit.isRented)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(child: Text('vacant_unit_msg'.tr, style: const TextStyle(fontWeight: FontWeight.bold))),
                  ),
                )
              else ...[
                // بطاقة المستأجر والرصيد
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('tenant_info'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const Divider(height: 20),
                        Text('${'tenant_name'.tr}: ${unit.tenantName}'),
                        const SizedBox(height: 6),
                        Text('${'phone'.tr}: ${unit.tenantPhone}  •  ${'family_count'.tr}: ${unit.familyMembers}'),
                        const SizedBox(height: 6),
                        Text('${'job_guarantee'.tr}: ${isAr ? unit.jobAndGuaranteeAr : unit.jobAndGuaranteeEn}'),
                        const Divider(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${'total_collected'.tr}: \$${unit.totalPaid.toInt()}',
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                            Text('${'remaining_balance'.tr}: \$${unit.remainingBalance.toInt()}',
                                style: TextStyle(
                                  color: unit.remainingBalance > 0 ? Colors.red : Colors.green,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // زر استلام دفعة إيجار (يدعم الدفع الجزئي والمقدم والنقدي والمحفظة)
                ElevatedButton.icon(
                  onPressed: () => _showReceivePaymentDialog(context, unit.id, unit.remainingBalance),
                  icon: const Icon(Icons.payments_rounded),
                  label: Text('receive_payment'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF5E35B1),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 20),

                // سجل الدفعات المستلمة
                Text('payments_history'.tr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...unit.payments.map(
                      (p) => Card(
                    child: ListTile(
                      leading: Icon(
                        p.method == 'wallet' ? Icons.account_balance_wallet_rounded : Icons.money_rounded,
                        color: Colors.green.shade700,
                      ),
                      title: Text('\$${p.amount.toInt()} • ${p.method == 'wallet' ? 'wallet'.tr : 'cash'.tr}'),
                      subtitle: Text('${p.date}  |  Ref: ${p.referenceNumber}'),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  void _showReceivePaymentDialog(BuildContext context, String unitId, double suggestedAmount) {
    final amountCtrl = TextEditingController(text: suggestedAmount > 0 ? suggestedAmount.toInt().toString() : '');
    final refCtrl = TextEditingController();
    final method = 'cash'.obs;

    Get.defaultDialog(
      title: 'receive_payment'.tr,
      content: Column(
        children: [
          TextField(
            controller: amountCtrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'amount'.tr, border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          Obx(
                () => Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: Center(child: Text('cash'.tr)),
                    selected: method.value == 'cash',
                    onSelected: (_) => method.value = 'cash',
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: Center(child: Text('wallet'.tr)),
                    selected: method.value == 'wallet',
                    onSelected: (_) => method.value = 'wallet',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: refCtrl,
            decoration: InputDecoration(labelText: 'ref_number'.tr, border: const OutlineInputBorder()),
          ),
        ],
      ),
      textConfirm: 'confirm_payment'.tr,
      onConfirm: () {
        final val = double.tryParse(amountCtrl.text.trim()) ?? 0;
        if (val > 0) {
          controller.recordPayment(
            unitId: unitId,
            amount: val,
            method: method.value,
            referenceNumber: refCtrl.text,
          );
          Get.back();
          Get.snackbar('app_name'.tr, 'payment_saved'.tr, snackPosition: SnackPosition.BOTTOM);
        }
      },
    );
  }
}