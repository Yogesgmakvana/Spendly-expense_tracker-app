import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/settings_controller.dart';
import '../../security/controllers/security_controller.dart';
import '../../export/views/export_view.dart';
import '../../savings_goals/views/goals_view.dart';
import 'security_settings_view.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final securityCtrl = Get.find<SecurityController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Security'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Preferences', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              // Currency Picker
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.darkCardBorder, width: 1),
                ),
                child: Material(
                  color: AppColors.darkCardBackground,
                  borderRadius: BorderRadius.circular(20),
                  child: ListTile(
                    leading: const Icon(Icons.attach_money_rounded, color: AppColors.primaryPeach),
                    title: const Text('Select Currency', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    trailing: Obx(() => DropdownButton<String>(
                      value: controller.currencySymbol.value,
                      dropdownColor: AppColors.darkCardSecondary,
                      underline: const SizedBox.shrink(),
                      style: const TextStyle(color: AppColors.primaryPeach, fontWeight: FontWeight.bold, fontSize: 16),
                      items: const [
                        DropdownMenuItem(value: '₹', child: Text('₹ (INR)')),
                        DropdownMenuItem(value: '\$', child: Text('\$ (USD)')),
                        DropdownMenuItem(value: '€', child: Text('€ (EUR)')),
                        DropdownMenuItem(value: '£', child: Text('£ (GBP)')),
                      ],
                      onChanged: (val) {
                        if (val != null) controller.changeCurrency(val);
                      },
                    )),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Hide Balance Toggle
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.darkCardBorder, width: 1),
                ),
                child: Material(
                  color: AppColors.darkCardBackground,
                  borderRadius: BorderRadius.circular(20),
                  child: Obx(() => SwitchListTile(
                    secondary: const Icon(Icons.visibility_off_outlined, color: AppColors.primaryPeach),
                    title: const Text('Hide Balances', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Mask figures on dashboard', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                    value: controller.hideBalance.value,
                    activeColor: AppColors.primaryPeach,
                    onChanged: (val) => controller.toggleHideBalance(val),
                  )),
                ),
              ),
              const SizedBox(height: 24),

              const Text('App Lock & Security', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              // Direct App Lock Switch
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.darkCardBorder, width: 1),
                ),
                child: Material(
                  color: AppColors.darkCardBackground,
                  borderRadius: BorderRadius.circular(20),
                  child: Obx(() => SwitchListTile(
                    secondary: const Icon(Icons.lock_rounded, color: AppColors.primaryPeach),
                    title: const Text('App Lock On Launch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Protect app with PIN / Fingerprint / Face ID', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                    value: securityCtrl.isSecurityEnabled.value,
                    activeColor: AppColors.primaryPeach,
                    onChanged: (val) => securityCtrl.toggleSecurity(val),
                  )),
                ),
              ),
              const SizedBox(height: 12),

              // Configure Security Tile
              _buildNavigationTile(
                icon: Icons.shield_rounded,
                title: 'Configure Security & Lock Options',
                subtitle: 'Set Password PIN, Fingerprint & Face Detection',
                onTap: () => Get.to(() => const SecuritySettingsView()),
              ),
              const SizedBox(height: 24),

              const Text('Features & Data', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              _buildNavigationTile(
                icon: Icons.savings_rounded,
                title: 'Savings Goals',
                subtitle: 'Manage target milestones',
                onTap: () => Get.to(() => const GoalsView()),
              ),
              const SizedBox(height: 12),

              _buildNavigationTile(
                icon: Icons.download_rounded,
                title: 'Export & Backup Data',
                subtitle: 'Download CSV, PDF, or JSON backup',
                onTap: () => Get.to(() => const ExportView()),
              ),
              const SizedBox(height: 24),

              const Text('Data & Privacy', style: TextStyle(color: AppColors.textPrimaryDark, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              // Reset Data Button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.expenseRed.withOpacity(0.5), width: 1),
                ),
                child: Material(
                  color: AppColors.darkCardBackground,
                  borderRadius: BorderRadius.circular(20),
                  child: ListTile(
                    onTap: () => _showResetConfirmation(context),
                    leading: const Icon(Icons.delete_forever_rounded, color: AppColors.expenseRed),
                    title: const Text('Clear All Local Data', style: TextStyle(color: AppColors.expenseRed, fontWeight: FontWeight.bold)),
                    subtitle: const Text('Permanently erases all local transaction records', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkCardBorder, width: 1),
      ),
      child: Material(
        color: AppColors.darkCardBackground,
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: AppColors.primaryPeach),
          title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          subtitle: Text(subtitle, style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
          trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondaryDark),
        ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.darkCardBackground,
        title: const Text('Clear All Data?', style: TextStyle(color: Colors.white)),
        content: const Text('This action will permanently remove all stored transactions, budgets, and recurring schedules from your device. It cannot be undone.', style: TextStyle(color: AppColors.textSecondaryDark)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondaryDark))),
          ElevatedButton(
            onPressed: () async {
              await controller.resetAllData();
              Get.back();
              Get.snackbar('Data Cleared', 'All local records have been erased', backgroundColor: AppColors.expenseRed, colorText: Colors.white);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.expenseRed),
            child: const Text('Clear Data', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
