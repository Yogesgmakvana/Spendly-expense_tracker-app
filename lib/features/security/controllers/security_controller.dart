import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/utils/biometric_helper.dart';
import '../../../core/widgets/processing_overlay.dart';
import '../../navigation/views/main_navigation_screen.dart';
import '../../../app/theme/app_colors.dart';

class SecurityController extends GetxController {
  final enteredPin = ''.obs;
  final isSecurityEnabled = false.obs;
  final isFingerprintEnabled = false.obs;
  final isFaceIdEnabled = false.obs;
  final savedPin = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSecuritySettings();
  }

  void loadSecuritySettings() {
    isSecurityEnabled.value = StorageService.isSecurityEnabled;
    isFingerprintEnabled.value = StorageService.isFingerprintEnabled;
    isFaceIdEnabled.value = StorageService.isFaceIdEnabled;
    savedPin.value = StorageService.appPin ?? '1234';
  }

  void addDigit(String digit) {
    if (enteredPin.value.length < 4) {
      enteredPin.value += digit;
      if (enteredPin.value.length == 4) {
        verifyPin();
      }
    }
  }

  void deleteDigit() {
    if (enteredPin.value.isNotEmpty) {
      enteredPin.value = enteredPin.value.substring(0, enteredPin.value.length - 1);
    }
  }

  void verifyPin() {
    final currentSaved = savedPin.value.isNotEmpty ? savedPin.value : '1234';
    if (enteredPin.value == currentSaved) {
      enteredPin.value = '';
      Get.offAll(() => const MainNavigationScreen());
    } else {
      Get.snackbar(
        'Access Denied',
        'Incorrect PIN code. Please try again.',
        backgroundColor: AppColors.expenseRed,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );
      enteredPin.value = '';
    }
  }

  Future<void> authenticateBiometric(String type) async {
    ProcessingOverlay.show(message: 'Scanning $type...');
    
    final authenticated = await BiometricHelper.authenticate(
      reason: 'Scan $type to unlock Spendly',
    );

    ProcessingOverlay.hide();

    if (authenticated) {
      Get.offAll(() => const MainNavigationScreen());
    } else {
      Get.snackbar(
        'Authentication Failed',
        'Unable to verify $type. Enter your 4-digit PIN.',
        backgroundColor: AppColors.expenseRed,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Future<void> toggleSecurity(bool enabled) async {
    isSecurityEnabled.value = enabled;
    await StorageService.setSecurityEnabled(enabled);
    if (enabled && (StorageService.appPin == null || StorageService.appPin!.isEmpty)) {
      await StorageService.setAppPin('1234');
      savedPin.value = '1234';
    }
  }

  Future<void> toggleFingerprint(bool enabled) async {
    if (enabled) {
      ProcessingOverlay.show(message: 'Verifying...');
      final authenticated = await BiometricHelper.authenticate(
        reason: 'Touch fingerprint sensor to enable Fingerprint Lock',
      );
      ProcessingOverlay.hide();

      if (authenticated) {
        isFingerprintEnabled.value = true;
        await StorageService.setFingerprintEnabled(true);
        await StorageService.setSecurityEnabled(true);
        isSecurityEnabled.value = true;
        Get.snackbar(
          'Fingerprint Lock Enabled',
          'You can now unlock Spendly using Fingerprint',
          backgroundColor: AppColors.incomeGreen,
          colorText: Colors.white,
        );
      } else {
        isFingerprintEnabled.value = false;
        Get.snackbar(
          'Verification Failed',
          'Fingerprint authentication failed. Switch remains off.',
          backgroundColor: AppColors.expenseRed,
          colorText: Colors.white,
        );
      }
    } else {
      isFingerprintEnabled.value = false;
      await StorageService.setFingerprintEnabled(false);
    }
  }

  Future<void> toggleFaceId(bool enabled) async {
    if (enabled) {
      ProcessingOverlay.show(message: 'Verifying...');
      final authenticated = await BiometricHelper.authenticate(
        reason: 'Authenticate Face ID to enable Face Detection Lock',
      );
      ProcessingOverlay.hide();

      if (authenticated) {
        isFaceIdEnabled.value = true;
        await StorageService.setFaceIdEnabled(true);
        await StorageService.setSecurityEnabled(true);
        isSecurityEnabled.value = true;
        Get.snackbar(
          'Face ID Lock Enabled',
          'You can now unlock Spendly using Face ID',
          backgroundColor: AppColors.incomeGreen,
          colorText: Colors.white,
        );
      } else {
        isFaceIdEnabled.value = false;
        Get.snackbar(
          'Verification Failed',
          'Face ID authentication failed. Switch remains off.',
          backgroundColor: AppColors.expenseRed,
          colorText: Colors.white,
        );
      }
    } else {
      isFaceIdEnabled.value = false;
      await StorageService.setFaceIdEnabled(false);
    }
  }

  Future<void> updatePin(String newPin) async {
    savedPin.value = newPin;
    await StorageService.setAppPin(newPin);
    await StorageService.setSecurityEnabled(true);
    isSecurityEnabled.value = true;
  }
}
