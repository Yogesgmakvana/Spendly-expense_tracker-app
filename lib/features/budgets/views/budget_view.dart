import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../controllers/budget_controller.dart';
import 'add_budget_dialog.dart';

class BudgetView extends GetView<BudgetController> {
  const BudgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Budgets & Recurring Bills'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Overall Monthly Budget Card
              _buildOverallBudgetCard(),
              const SizedBox(height: 24),

              // Recurring Bills Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Recurring Bills & Subscriptions',
                      style: TextStyle(
                        color: AppColors.textPrimaryDark,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryPeach),
                    onPressed: () {
                      _showAddBillDialog(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Recurring Bills List
              Obx(() {
                final bills = controller.recurringBills;
                if (bills.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.darkCardBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'No recurring bills added',
                        style: TextStyle(color: AppColors.textSecondaryDark),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bills.length,
                  itemBuilder: (context, index) {
                    final bill = bills[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.darkCardBackground,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.darkCardBorder, width: 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primaryPeach.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.receipt_rounded,
                              color: AppColors.primaryPeach,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bill.title,
                                  style: const TextStyle(
                                    color: AppColors.textPrimaryDark,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Due: ${bill.dueDate.toString().split(' ')[0]} • ${bill.frequency}',
                                  style: const TextStyle(
                                    color: AppColors.textSecondaryDark,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            CurrencyFormatter.format(bill.amount),
                            style: const TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: AppColors.expenseRed, size: 20),
                            onPressed: () => controller.deleteRecurringBill(bill.id),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallBudgetCard() {
    return Obx(() {
      final limit = controller.totalMonthlyBudget.value;
      final spent = controller.totalSpentThisMonth.value;
      final remaining = limit - spent;
      final ratio = limit > 0 ? (spent / limit).clamp(0.0, 1.0) : 0.0;
      final percent = (ratio * 100).toStringAsFixed(0);

      Color progressColor = AppColors.incomeGreen;
      if (ratio >= 0.9) {
        progressColor = AppColors.expenseRed;
      } else if (ratio >= 0.75) {
        progressColor = AppColors.warningOrange;
      }

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.darkCardBackground,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.darkCardBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Monthly Budget Limit',
                  style: TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.bottomSheet(
                      const AddBudgetDialog(),
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                    );
                  },
                  child: const Text(
                    'Edit Budget',
                    style: TextStyle(
                      color: AppColors.primaryPeach,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CurrencyFormatter.format(spent),
                  style: const TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'of ${CurrencyFormatter.format(limit)}',
                  style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Progress Bar
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 12,
                backgroundColor: AppColors.darkCardSecondary,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$percent% spent',
                  style: TextStyle(
                    color: progressColor,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Remaining: ${CurrencyFormatter.format(remaining < 0 ? 0 : remaining)}',
                  style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  void _showAddBillDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.darkCardBackground,
        title: const Text('Add Recurring Bill', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
                filled: true,
                fillColor: AppColors.darkCardSecondary,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Amount',
                labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
                filled: true,
                fillColor: AppColors.darkCardSecondary,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondaryDark)),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleCtrl.text.trim();
              final amt = double.tryParse(amountCtrl.text.trim()) ?? 0.0;
              if (title.isNotEmpty && amt > 0) {
                await controller.addRecurringBill(
                  title: title,
                  amount: amt,
                  category: 'Bills',
                  frequency: 'monthly',
                  dueDate: DateTime.now().add(const Duration(days: 7)),
                );
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPeach),
            child: const Text('Add', style: TextStyle(color: AppColors.darkBackground, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
