import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/transaction_tile.dart';
import '../controllers/transaction_controller.dart';
import '../widgets/daily_bar_chart_widget.dart';
import 'add_edit_transaction_dialog.dart';

class DailySpendView extends GetView<TransactionController> {
  const DailySpendView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card with Leaf Decorative Background
              _buildHeaderCard(),
              const SizedBox(height: 20),

              // Segmented Toggle Pills (Expenses vs Income)
              Obx(() => _buildSegmentedToggle()),
              const SizedBox(height: 20),

              // Daily Bar Chart
              Obx(() => DailyBarChartWidget(
                weeklyData: Map<int, double>.from(controller.weeklySpendMap),
              )),
              const SizedBox(height: 24),

              // "Today's Expenses" Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                    controller.selectedType.value == 'expense' ? "Today's Expenses" : "Today's Income",
                    style: const TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryPeach),
                    onPressed: () {
                      Get.bottomSheet(
                        AddEditTransactionDialog(initialType: controller.selectedType.value),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Transactions List
              Obx(() {
                final list = controller.filteredTransactions;
                if (list.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.darkCardBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text(
                        'No transactions found for today',
                        style: TextStyle(color: AppColors.textSecondaryDark),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final txn = list[index];
                    return TransactionTile(
                      transaction: txn,
                      currencySymbol: controller.currencySymbol.value,
                      hideBalance: controller.hideBalance.value,
                      onTap: () {
                        Get.bottomSheet(
                          AddEditTransactionDialog(transaction: txn),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        );
                      },
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

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: const Color(0xFF0C383F),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.darkCardBorder, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "Today's spend:",
            style: TextStyle(
              color: AppColors.textSecondaryDark,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Obx(() => Text(
            CurrencyFormatter.format(
              controller.todaySpend.value,
              currencySymbol: controller.currencySymbol.value,
              hideBalance: controller.hideBalance.value,
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 34,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          )),
          const SizedBox(height: 8),
          Obx(() => Text(
            controller.todaySpend.value >= controller.dailyLimit.value
                ? "Daily limit reached!"
                : "You almost reach your daily limit spend!",
            style: const TextStyle(
              color: AppColors.primaryPeach,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSegmentedToggle() {
    final isExpense = controller.selectedType.value == 'expense';
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.darkCardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkCardBorder, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => controller.setTypeFilter('expense'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isExpense ? AppColors.primaryPeach : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Expenses',
                    style: TextStyle(
                      color: isExpense ? AppColors.darkBackground : AppColors.textSecondaryDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => controller.setTypeFilter('income'),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !isExpense ? AppColors.incomeGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Income',
                    style: TextStyle(
                      color: !isExpense ? AppColors.darkBackground : AppColors.textSecondaryDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
