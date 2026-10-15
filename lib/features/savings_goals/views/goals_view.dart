import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../controllers/goals_controller.dart';

class GoalsView extends GetView<GoalsController> {
  const GoalsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings Goals'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Active Savings Goals',
                    style: TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showAddGoalDialog(context),
                    icon: const Icon(Icons.add, size: 18),
                    label: const Text('New Goal'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryPeach,
                      foregroundColor: AppColors.darkBackground,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Obx(() {
                final list = controller.goals;
                if (list.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.darkCardBackground,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(
                      child: Text('No savings goals set yet', style: TextStyle(color: AppColors.textSecondaryDark)),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final goal = list[index];
                    final progress = goal.progressPercentage;
                    final percentStr = (progress * 100).toStringAsFixed(0);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.darkCardBackground,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: AppColors.darkCardBorder, width: 1),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                goal.title,
                                style: const TextStyle(
                                  color: AppColors.textPrimaryDark,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: AppColors.expenseRed, size: 20),
                                onPressed: () => controller.deleteGoal(goal.id),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${CurrencyFormatter.format(goal.currentSaved)} saved',
                                style: const TextStyle(color: AppColors.incomeGreen, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Target: ${CurrencyFormatter.format(goal.targetAmount)}',
                                style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 10,
                              backgroundColor: AppColors.darkCardSecondary,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.incomeGreen),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('$percentStr% Completed', style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                              InkWell(
                                onTap: () => _showContributeDialog(context, goal.id),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryPeach.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    '+ Contribute',
                                    style: TextStyle(color: AppColors.primaryPeach, fontSize: 12, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
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

  void _showAddGoalDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final targetCtrl = TextEditingController();
    final currentCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.darkCardBackground,
        title: const Text('Create Savings Goal', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Goal Title',
                labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
                filled: true,
                fillColor: AppColors.darkCardSecondary,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: targetCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Target Amount',
                labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
                filled: true,
                fillColor: AppColors.darkCardSecondary,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: currentCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Initial Saved Amount (Optional)',
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
              final target = double.tryParse(targetCtrl.text.trim()) ?? 0.0;
              final current = double.tryParse(currentCtrl.text.trim()) ?? 0.0;
              if (title.isNotEmpty && target > 0) {
                await controller.addGoal(
                  title: title,
                  targetAmount: target,
                  initialSaved: current,
                  targetDate: DateTime.now().add(const Duration(days: 180)),
                  notes: '',
                );
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPeach),
            child: const Text('Create Goal', style: TextStyle(color: AppColors.darkBackground, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showContributeDialog(BuildContext context, String goalId) {
    final amountCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.darkCardBackground,
        title: const Text('Contribute Amount', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: amountCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Contribution Amount',
            labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
            filled: true,
            fillColor: AppColors.darkCardSecondary,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondaryDark)),
          ),
          ElevatedButton(
            onPressed: () async {
              final amt = double.tryParse(amountCtrl.text.trim()) ?? 0.0;
              if (amt > 0) {
                await controller.contributeToGoal(goalId, amt);
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPeach),
            child: const Text('Add Amount', style: TextStyle(color: AppColors.darkBackground, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
