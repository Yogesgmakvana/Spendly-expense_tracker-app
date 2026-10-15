import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/budget_controller.dart';

class AddBudgetDialog extends StatefulWidget {
  const AddBudgetDialog({super.key});

  @override
  State<AddBudgetDialog> createState() => _AddBudgetDialogState();
}

class _AddBudgetDialogState extends State<AddBudgetDialog> {
  final _limitController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BudgetController>();

    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.darkCardBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Set Monthly Budget',
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondaryDark),
                onPressed: () => Get.back(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _limitController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              labelText: 'Monthly Limit Amount',
              hintText: 'e.g. 1500.00',
              labelStyle: const TextStyle(color: AppColors.textSecondaryDark),
              filled: true,
              fillColor: AppColors.darkCardSecondary,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                final text = _limitController.text.trim();
                if (text.isEmpty) return;
                final limit = double.tryParse(text) ?? 0.0;
                if (limit <= 0) return;

                await controller.setOverallBudget(limit);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryPeach,
                foregroundColor: AppColors.darkBackground,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Save Budget', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
