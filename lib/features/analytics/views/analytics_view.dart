import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../controllers/analytics_controller.dart';
import '../widgets/category_pie_chart.dart';

class AnalyticsView extends GetView<AnalyticsController> {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Financial Insights'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Spending by Category',
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Obx(() => CategoryPieChart(
                categoryData: Map<String, double>.from(controller.categorySpending),
                totalExpense: controller.totalExpenseSum.value,
              )),
              const SizedBox(height: 24),

              const Text(
                'Local Smart Insights',
                style: TextStyle(
                  color: AppColors.textPrimaryDark,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Obx(() => _buildInsightTile(
                icon: Icons.star_rounded,
                title: 'Highest Spending Category',
                value: controller.highestSpendingCategory.value,
                subtitle: 'Accounts for the largest share of monthly spending.',
              )),
              const SizedBox(height: 12),

              Obx(() => _buildInsightTile(
                icon: Icons.auto_graph_rounded,
                title: 'Average Daily Spending',
                value: CurrencyFormatter.format(controller.averageDailySpend.value),
                subtitle: 'Calculated from current month transactions.',
              )),
              const SizedBox(height: 12),

              Obx(() => _buildInsightTile(
                icon: Icons.online_prediction_rounded,
                title: 'Estimated Month-End Spending',
                value: CurrencyFormatter.format(controller.averageDailySpend.value * 30),
                subtitle: 'Based on your current daily spending velocity.',
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInsightTile({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCardBackground,
        borderRadius: BorderRadius.circular(20),
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
            child: Icon(icon, color: AppColors.primaryPeach, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textPrimaryDark,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textMutedDark,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
