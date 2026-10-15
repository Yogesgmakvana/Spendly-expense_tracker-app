import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/navigation_controller.dart';
import '../../home/views/home_view.dart';
import '../../transactions/views/daily_spend_view.dart';
import '../../budgets/views/budget_view.dart';
import '../../settings/views/settings_view.dart';
import '../../transactions/views/add_edit_transaction_dialog.dart';

class MainNavigationScreen extends GetView<NavigationController> {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const DailySpendView(),
      const SizedBox.shrink(), // Placeholder for FAB position
      const BudgetView(),
      const SettingsView(),
    ];

    return Scaffold(
      body: Obx(() => IndexedStack(
        index: controller.currentIndex.value,
        children: pages,
      )),
      bottomNavigationBar: Obx(() => Container(
        decoration: const BoxDecoration(
          color: AppColors.darkHeaderBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home'),
              _buildNavItem(1, Icons.insert_chart_rounded, Icons.insert_chart_outlined_rounded, 'Daily'),
              _buildFabButton(context),
              _buildNavItem(3, Icons.receipt_long_rounded, Icons.receipt_long_outlined, 'Budgets'),
              _buildNavItem(4, Icons.settings_rounded, Icons.settings_outlined, 'Settings'),
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label) {
    final isSelected = controller.currentIndex.value == index;
    return InkWell(
      onTap: () => controller.changePage(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : inactiveIcon,
              color: isSelected ? AppColors.primaryPeach : AppColors.textMutedDark,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryPeach : AppColors.textMutedDark,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFabButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          const AddEditTransactionDialog(),
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
        );
      },
      child: Container(
        width: 52,
        height: 52,
        decoration: const BoxDecoration(
          color: AppColors.primaryPeach,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x66F2A862),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.add_rounded,
          color: AppColors.darkBackground,
          size: 32,
        ),
      ),
    );
  }
}
