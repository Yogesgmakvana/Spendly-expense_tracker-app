import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../controllers/security_controller.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({super.key});

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final controller = Get.find<SecurityController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoCheckBiometrics();
    });
  }

  void _autoCheckBiometrics() {
    if (controller.isFingerprintEnabled.value) {
      controller.authenticateBiometric('Fingerprint');
    } else if (controller.isFaceIdEnabled.value) {
      controller.authenticateBiometric('Face ID');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Lock Shield Icon
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryPeach.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryPeach.withOpacity(0.4), width: 1.5),
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  color: AppColors.primaryPeach,
                  size: 44,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                'Spendly Security Lock',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),

              Obx(() {
                final hasPin = controller.isSecurityEnabled.value;
                final hasBio = controller.isFingerprintEnabled.value || controller.isFaceIdEnabled.value;

                if (hasPin && hasBio) {
                  return const Text(
                    'Enter your 4-digit PIN or use Biometrics to unlock',
                    style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
                    textAlign: TextAlign.center,
                  );
                } else if (hasPin) {
                  return const Text(
                    'Enter your 4-digit PIN password to access financial records',
                    style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
                    textAlign: TextAlign.center,
                  );
                } else if (hasBio) {
                  return const Text(
                    'Scan your Fingerprint or Face ID to unlock Spendly',
                    style: TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
                    textAlign: TextAlign.center,
                  );
                }
                return const SizedBox.shrink();
              }),
              const SizedBox(height: 24),

              // Dynamic Biometrics Section (Only visible if Fingerprint or Face ID is ON)
              Obx(() {
                final showFingerprint = controller.isFingerprintEnabled.value;
                final showFaceId = controller.isFaceIdEnabled.value;

                if (!showFingerprint && !showFaceId) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (showFingerprint)
                          OutlinedButton.icon(
                            onPressed: () => controller.authenticateBiometric('Fingerprint'),
                            icon: const Icon(Icons.fingerprint_rounded, size: 20, color: AppColors.primaryPeach),
                            label: const Text('Fingerprint', style: TextStyle(color: AppColors.primaryPeach, fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.darkCardBorder),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                        if (showFingerprint && showFaceId) const SizedBox(width: 12),
                        if (showFaceId)
                          OutlinedButton.icon(
                            onPressed: () => controller.authenticateBiometric('Face ID'),
                            icon: const Icon(Icons.face_retouching_natural_rounded, size: 20, color: AppColors.primaryPeach),
                            label: const Text('Face ID', style: TextStyle(color: AppColors.primaryPeach, fontSize: 12)),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.darkCardBorder),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }),

              // Dynamic PIN Section (Only visible if PIN Lock is ON)
              Obx(() {
                if (!controller.isSecurityEnabled.value) {
                  return const SizedBox.shrink();
                }

                final length = controller.enteredPin.value.length;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(4, (index) {
                        final isFilled = index < length;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isFilled ? AppColors.primaryPeach : Colors.transparent,
                            border: Border.all(
                              color: isFilled ? AppColors.primaryPeach : AppColors.textMutedDark,
                              width: 2,
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              }),

              const Spacer(),

              // Dynamic Keypad Section (Only visible if PIN Lock is ON)
              Obx(() {
                if (!controller.isSecurityEnabled.value) {
                  return const SizedBox.shrink();
                }

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKeypadButton('1'),
                        _buildKeypadButton('2'),
                        _buildKeypadButton('3'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKeypadButton('4'),
                        _buildKeypadButton('5'),
                        _buildKeypadButton('6'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildKeypadButton('7'),
                        _buildKeypadButton('8'),
                        _buildKeypadButton('9'),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 68),
                        _buildKeypadButton('0'),
                        IconButton(
                          icon: const Icon(Icons.backspace_outlined, color: AppColors.textSecondaryDark, size: 26),
                          onPressed: () => controller.deleteDigit(),
                        ),
                      ],
                    ),
                  ],
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildKeypadButton(String digit) {
    return InkWell(
      onTap: () => controller.addDigit(digit),
      borderRadius: BorderRadius.circular(36),
      child: Container(
        width: 68,
        height: 68,
        decoration: BoxDecoration(
          color: AppColors.darkCardBackground,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.darkCardBorder, width: 1),
        ),
        child: Center(
          child: Text(
            digit,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
