import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../security/controllers/security_controller.dart';

class SecuritySettingsView extends GetView<SecurityController> {
  const SecuritySettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Security & Lock'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Security Preferences',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Protect your local financial records with Password, Fingerprint, or Face Detection lock.',
                style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
              ),
              const SizedBox(height: 20),

              // Master Security Toggle
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkCardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.darkCardBorder, width: 1),
                ),
                child: Obx(() => SwitchListTile(
                  secondary: const Icon(Icons.shield_outlined, color: AppColors.primaryPeach),
                  title: const Text('Enable App Lock on Launch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Require authentication when opening Spendly', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                  value: controller.isSecurityEnabled.value,
                  activeColor: AppColors.primaryPeach,
                  onChanged: (val) => controller.toggleSecurity(val),
                )),
              ),
              const SizedBox(height: 16),

              // Change PIN / Password Tile
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkCardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.darkCardBorder, width: 1),
                ),
                child: ListTile(
                  onTap: () => _showChangePinDialog(context),
                  leading: const Icon(Icons.password_rounded, color: AppColors.primaryPeach),
                  title: const Text('Set / Change 4-Digit Password PIN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Obx(() => Text('Current PIN: ${controller.savedPin.value}', style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 12))),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondaryDark),
                ),
              ),
              const SizedBox(height: 16),

              // Fingerprint Lock Toggle
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkCardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.darkCardBorder, width: 1),
                ),
                child: Obx(() => SwitchListTile(
                  secondary: const Icon(Icons.fingerprint_rounded, color: AppColors.primaryPeach),
                  title: const Text('Fingerprint Lock', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Unlock Spendly using fingerprint scanner', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                  value: controller.isFingerprintEnabled.value,
                  activeColor: AppColors.primaryPeach,
                  onChanged: (val) => controller.toggleFingerprint(val),
                )),
              ),
              const SizedBox(height: 16),

              // Face Detection Lock Toggle
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkCardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.darkCardBorder, width: 1),
                ),
                child: Obx(() => SwitchListTile(
                  secondary: const Icon(Icons.face_retouching_natural_rounded, color: AppColors.primaryPeach),
                  title: const Text('Face Detection Lock', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: const Text('Unlock Spendly using Face ID / camera detection', style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 12)),
                  value: controller.isFaceIdEnabled.value,
                  activeColor: AppColors.primaryPeach,
                  onChanged: (val) => controller.toggleFaceId(val),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showChangePinDialog(BuildContext context) {
    final pinCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.darkCardBackground,
        title: const Text('Set 4-Digit Password PIN', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: pinCtrl,
          keyboardType: TextInputType.number,
          maxLength: 4,
          obscureText: true,
          style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 4),
          decoration: InputDecoration(
            labelText: 'New 4-Digit PIN',
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
              final pin = pinCtrl.text.trim();
              if (pin.length == 4) {
                await controller.updatePin(pin);
                Get.back();
                Get.snackbar('Security Updated', 'New 4-digit PIN has been set', backgroundColor: AppColors.incomeGreen, colorText: Colors.white);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryPeach),
            child: const Text('Save PIN', style: TextStyle(color: AppColors.darkBackground, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
